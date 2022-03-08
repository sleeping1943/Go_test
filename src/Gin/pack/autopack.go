package pack

import (
	"bufio"
	"bytes"
	"encoding/json"
	"fmt"
	"io/ioutil"
	"log"
	"net/http"
	"os"
	"os/exec"
	"regexp"
	"strings"
	"time"

	"github.com/fatih/color"
)

// 创建工程错误
type buildError struct {
	ErrCode int
	ErrMsg  string
}

// NewBuildError : 创建一个建立工程文件的错误
func NewBuildError(code int, msg string) *buildError {
	return &buildError{ErrCode: code, ErrMsg: msg}
}
func (e *buildError) Error() string {
	return e.ErrMsg
}

// WeiXinUser : 微信用户信息
type WeiXinUser struct {
	Name   string
	OpenID string
}

// KeyWord : 微信消息关键字信息
type KeyWord struct {
	Color string `json:"color"`
	Value string `json:"value"`
}

// NewsData : 微信具体数据
type NewsData struct {
	First    KeyWord `json:"first"`
	ProName  KeyWord `json:"keyword1"`
	WorkInfo KeyWord `json:"keyword2"`
	Progress KeyWord `json:"keyword3"`
	Remark   KeyWord `json:"remark"`
}

// NewsParams : 微信消息参数信息
type NewsParams struct {
	ToUser     string   `json:"touser"`
	TemplateID string   `json:"template_id"`
	Data       NewsData `json:"data"`
}

// NotifyNews : 打包完成通知消息
type NotifyNews struct {
	URL    string     `json:"url"`
	Params NewsParams `json:"param"`
}

// ProjectInfo : 工程配置信息
type ProjectInfo struct {
	RebuildExe        bool              `json:"rebuildExe"`
	RebuildPro        bool              `json:"rebuildPro"`
	Repack            bool              `json:"rebuildPack"`
	ProPath           string            `json:"projectPath"`
	CodePath          string            `json:"codePath"`
	BuildParams       map[string]string `json:"buildParams"`
	ExeName           string            `json:"exeName"`
	PdbName           string            `json:"pdbName"`
	NsiPath           string            `json:"nsiPath"`
	NsiParams         map[string]string `json:"nsiParams"`
	DefaultFrontendIP string            `json:"defaultFrontendIP"`
	TemplateID        string            `json:"templateID"`
	NotifyProxy       string            `json:"notifyProxy"`
	WeiXinUsers       []WeiXinUser      `json:"weixinUsers"`
	WeiXInURL         string            `json:"weixinurl"`
}

// SetupInfo: 主程序配置信息
type SetupJsonInfo struct {
	NsiPath     string            `json:"nsiPath"`
	NsiParams   map[string]string `json:"nsiParams"`
	NotifyProxy string            `json:"notifyProxy"`
	WeiXinUsers []WeiXinUser      `json:"weixinUsers"`
	WeiXInURL   string            `json:"weixinurl"`
}

//工程文件目录
const SlnPath = "builds/vs2015"

// 配置文件路径
const ProFilePath = "./remoupack.json"

// 代码中默认配置文件的路径
const DefaultConfigPath = "source/Business/conf/default"

// 发布的默认配置文件路径
const DefaultPackConfigPath = "Business/process/conf/default"

// 代码中sql文件路径
const DefaultSQLFilePath = "docs/SQL Script"

// 发布文件夹sql文件路径
const PackSQLFilePath = "MySQLScript"

// 发布文件夹Saas程序目录
const SaasExePath = "Business/process"

// 编译好程序的目录
const ExePath = "Visual Studio 14 2015 Win64/release"

var Params = []string{"slnName", "mode", "proName"}

var NsiParams = []string{
	"short_cut", "pack_name", "pack_path",
	"product_name_to_change", "product_file_name",
	"product_version_to_change", "language_version"}

var ProInfo ProjectInfo
var SetupInfo SetupJsonInfo

var DefaultFrontConfig = map[string]string{
	"redisCluster": "host",
	"iceConfig":    "iceIp",
	"picConfig":    "ip",
}

// nsi配置文件替换模板
const BaseSectionString string = `; Extract {__param__}.7z
Section "Extract {__param__}"
    IfFileExists $INSTDIR\{__param__}\* 0 +2
    DetailPrint "$INSTDIR\{__param__}\ already exists"
    nsExec::Exec '$INSTDIR\Install_Env\7za.exe -o$INSTDIR\ x $EXEDIR\7zs\{__param__}.7z'
    DetailPrint "       extract {__param__} success"
SectionEnd`

func Rebuild(path string) *buildError {
	path = strings.Replace(path, "\\", "/", -1)
	// 检车文件目录是否存在
	// 然后删除builds/vs2015文件夹下的所有文件
	// 创建build/vs2015文件夹
	// 建立cmake的windows工程
	// CmakeCmd = `cmake ../.. -G "Visual Studio 14 2015 Win64"`
	fileInfo, err := os.Stat(path)
	// 路径不存在
	if err != nil {
		return NewBuildError(-1, err.Error())
	}
	if !fileInfo.IsDir() {
		retStr := fmt.Sprintf("%s 不是一个文件夹", path)
		return NewBuildError(-1, retStr)
	}
	buildPath := fmt.Sprintf("%s/%s", path, SlnPath)
	err = os.MkdirAll(buildPath, os.ModePerm)
	if err != nil {
		retStr := fmt.Sprintf("%s 创建失败", buildPath)
		return NewBuildError(-1, retStr)
	}
	file, err := os.Open(buildPath)
	if err != nil {
		retStr := fmt.Sprintf("%s 打开失败", path)
		return NewBuildError(-1, retStr)
	}
	defer file.Close()
	files, err := file.Readdirnames(0)
	if err != nil {
		retStr := fmt.Sprintf("%s 读取失败", path)
		return NewBuildError(-1, retStr)
	}
	for _, name := range files {
		filePath := fmt.Sprintf("%s/%s", buildPath, name)
		err := os.RemoveAll(filePath)
		if err != nil {
			retStr := fmt.Sprintf("%s 删除失败", filePath)
			return NewBuildError(-1, retStr)
		}
	}

	curWorkDir, err := os.Getwd()
	if err != nil {
		retStr := fmt.Sprintf("获取当前目录出错:%s", err.Error())
		return NewBuildError(-1, retStr)
	}

	// 切换到初始根目录下
	defer func(wd string) {
		err := os.Chdir(buildPath)
		if err != nil {
			log.Printf("open vs project err:%s\n", err.Error())
		}
	}(curWorkDir)

	// 切换到builds/vs2015目录下
	err = os.Chdir(buildPath)
	if err != nil {
		retStr := fmt.Sprintf("change dir error[%s]", buildPath)
		return NewBuildError(-1, retStr)
	}
	cmd := exec.Command("cmake", "../..", "-G", "Visual Studio 14 2015 Win64")
	err = cmd.Run()
	if err != nil {
		retStr := fmt.Sprintf("cmd execute err:%s\nbuildPath[%s]", err.Error(), buildPath)
		return NewBuildError(-1, retStr)
	}
	log.Printf("rebuild project successfully![%s]\n", buildPath)
	return nil
}

// 编译可执行程序
func CompileExecute(codePath string, buildPath string) (int, string) {
	buildPath = strings.Replace(buildPath, "\\", "/", -1)
	/*
	 1、检测文件目录是否存在
	 2、切换到sln所在目录
	 3、检测配置参数是否已配置且加载完全
	 4、进入build/vs2015文件夹
	 5、编译工程
	 6、编译完成后切换回代码根目录
	*/
	_, err := os.Stat(buildPath)
	// 路径不存在
	if err != nil {
		return -1, err.Error()
	}

	err = os.Chdir(buildPath)
	if err != nil {
		log.Printf("open vs project err:%s\n", err.Error())
	}
	// 结束后切换到代码根目录下
	defer func(wd string) {
		err := os.Chdir(buildPath)
		if err != nil {
			log.Printf("open vs project err:%s\n", err.Error())
		}
	}(codePath)

	buildParams := ProInfo.BuildParams
	for _, value := range Params {
		_, isOk := buildParams[value]
		if !isOk {
			return -1, fmt.Sprintf("%s is not exists!", value)
		}
	}
	// example : "devenv *.sln /build Release /project saas.project"
	cmd := exec.Command("devenv", buildParams["slnName"], "/build",
		buildParams["mode"], "/project", buildParams["proName"])
	err = cmd.Run()
	if err != nil {
		return -1, err.Error()
	}
	return 0, ""
}

// 拷贝文件
func CopyFiles(srcPath string, dstPath string) (int, string) {
	srcPath = fmt.Sprintf("%s/%s", ProInfo.CodePath, srcPath)
	dstPath = fmt.Sprintf("%s/%s", ProInfo.ProPath, dstPath)

	_, err := os.Stat(srcPath)
	// 路径不存在
	if err != nil {
		return -1, fmt.Sprintf("filePath[%s] is not exists!", srcPath)
	}
	_, err = os.Stat(dstPath)
	if err != nil {
		return -1, fmt.Sprintf("filePath[%s] is not exists!", dstPath)
	}

	fileInfos, err := ioutil.ReadDir(srcPath)
	if err != nil {
		return -1, fmt.Sprintf("readdir error:%s", err.Error())
	}
	for index, value := range fileInfos {
		if value.IsDir() {
			continue
		}
		fileName := value.Name()
		color.Blue("    %d-%s", index+1, fileName)
		srcFileName := srcPath + "/" + fileName
		content, err := ioutil.ReadFile(srcFileName)
		if err != nil {
			color.RedString("readfile error:%s", srcFileName)
			continue
		}
		dstFileName := dstPath + "/" + fileName
		err = ioutil.WriteFile(dstFileName, content, os.ModePerm)
		if err != nil {
			color.RedString("writefile error:%s", dstFileName)
		}
	}
	color.HiYellow("    successful:copy dir from\n    [%s]\n    to\n    [%s]\n", srcPath, dstPath)
	return 0, ""
}

// CopyExe : 拷贝编译好的exe等文件到发布目录下
func CopyExe(srcExePath string, dstExePath string, suffix string) (int, string) {
	srcFileName := fmt.Sprintf("%s/%s/%s", ProInfo.CodePath, srcExePath, suffix)
	dstFilePath := fmt.Sprintf("%s/%s", ProInfo.ProPath, dstExePath)
	fileInfo, err := os.Stat(srcFileName)
	// 路径不存在
	if err != nil {
		return -1, fmt.Sprintf("file[%s] is not exists!", srcFileName)
	}

	if !fileInfo.Mode().IsRegular() {
		return -1, fmt.Sprintf("file[%s] is not a regular file!", srcFileName)
	}
	fileInfo, err = os.Stat(dstFilePath)
	if err != nil {
		return -1, fmt.Sprintf("filePath[%s] is not exists!", dstFilePath)
	}
	if !fileInfo.IsDir() {
		return -1, fmt.Sprintf("filePath[%s] is not a directory!", dstFilePath)
	}
	dstFileName := dstFilePath + "/" + suffix
	content, err := ioutil.ReadFile(srcFileName)
	if err != nil {
		return -1, fmt.Sprintf("readfile error:%s", srcFileName)
	}
	err = ioutil.WriteFile(dstFileName, content, os.ModePerm)
	if err != nil {
		return -1, fmt.Sprintf("writefile error:%s", dstFileName)
	}
	color.HiYellow("    successful:copy file from\n")
	color.HiBlue("    %s\n", srcFileName)
	color.HiYellow("    to\n")
	color.HiBlue("    %s\n", dstFileName)
	return 0, ""
}

// ModifyFrontedDefaultIP : 修改前端配置默认ip
func ModifyFrontedDefaultIP(configPath string) (int, string) {
	file, err := os.Open(configPath)
	if err != nil {
		return -1, err.Error()
	}
	defer file.Close()
	reader := bufio.NewReader(file)
	var content []string
	for {
		line, _, err := reader.ReadLine()
		if err != nil {
			break
		}
		content = append(content, string(line))
	}
	// 循环关键字替换
	for key, changeWord := range DefaultFrontConfig {
		var isBegin = false
		// 在每行中查找关键字替换
		for index, value := range content {
			if !isBegin && strings.Contains(value, key) {
				isBegin = true
				continue
			}
			if isBegin && strings.Contains(value, changeWord) {
				color.HiRed(fmt.Sprintf("value:[%s] ----- changeWord:[%s]", value, changeWord))
				var lastChar = ""
				if strings.Contains(value, ",") {
					lastChar = ","
				}
				elems := strings.Split(value, ":")
				if len(elems) <= 0 {
					break
				}
				content[index] = fmt.Sprintf("%s: '%s'%s", elems[0], ProInfo.DefaultFrontendIP, lastChar)
				//break
			}
		}
	}
	//color.HiRed(strings.Join(content, "\r\n"))
	strContent := strings.Join(content, "\r\n")
	err = ioutil.WriteFile(configPath, []byte(strContent), os.ModePerm)
	if err != nil {
		return -1, err.Error()
	}
	return 0, ""
}

// ModifyNsiParams : 修改nsi文件参数,根据7zs.txt增加要解压的服务
func ModifyNsiParams(nsiPath string, isZh bool) (int, string) {
	filePath := nsiPath + "/" + "Nise_template.nsi"
	fileInfo, err := os.Stat(filePath)
	if err != nil {
		return -1, fmt.Sprintf("check file[%s] err:%s", filePath, err.Error())
	}
	if !fileInfo.Mode().IsRegular() {
		return -1, fmt.Sprintf("file[%s] is not a regular file", filePath)
	}
	_7zFilePath := fmt.Sprintf("%s/%s", nsiPath, "7z_list.txt")
	_7zFilePathInfo, err := os.Stat(_7zFilePath)
	if err != nil {
		return -2, fmt.Sprintf("check file[%s] err:%s", _7zFilePath, err.Error())
	}
	if !_7zFilePathInfo.Mode().IsRegular() {
		return -2, fmt.Sprintf("file[%s] is not a regular file", _7zFilePathInfo)
	}
	configNsiParams := ProInfo.NsiParams
	configNsiParams["language_version"] = "SimpChinese"
	if !isZh {
		configNsiParams["language_version"] = "English"
	}
	for _, value := range NsiParams {
		_, isOk := configNsiParams[value]
		if !isOk {
			return -1, fmt.Sprintf("the param[%s] is not exists", value)
		}
	}

	file, err := os.Open(filePath)
	if err != nil {
		return -1, fmt.Sprintf("open file[%s] error:%s", filePath, err.Error())
	}
	defer file.Close()
	reader := bufio.NewReader(file)
	var content []string
	for {
		bytes, _, isEnd := reader.ReadLine()
		if isEnd != nil {
			break
		}
		str := string(bytes)
		// 替换字符串,只查询替换一次
		for _, value := range NsiParams {
			if strings.Contains(str, value) {
				str = strings.Replace(str, value, configNsiParams[value], 1)
				break
			}
		}
		content = append(content, str)
	}
	// 写入到新文件
	newPath := nsiPath + "/" + "Nise_pack.nsi"
	// 提取7z_list中服务名字
	fd, err := os.Open(_7zFilePath)
	if err != nil {
		color.HiRed("    open file 7z_list.txt error:", newPath)
		return -4, fmt.Sprintf("Open 7z list txt error:%s", err.Error())
	}
	scanner := bufio.NewScanner(fd)
	var serverList []string
	for {
		if !scanner.Scan() {
			break
		}
		content := scanner.Text()
		serverList = append(serverList, content)
	}

	//解释正则表达式
	reg := regexp.MustCompile(`^[0-9]*-(.*).7z$`)
	if reg == nil {
		fmt.Println("MustCompile err")
		return -3, fmt.Sprintf("parse regexp error:%v", reg)
	}
	sectionList := make([]string, 0)
	for index, value := range serverList {
		//提取关键信息
		result := reg.FindAllStringSubmatch(value, -1)
		for _, text := range result {
			fmt.Println(index+1, "---", text[1])
			tempSection := strings.ReplaceAll(BaseSectionString, "{__param__}", text[1])
			//fmt.Println("The new tempSection:", tempSection)
			sectionList = append(sectionList, tempSection)
		}
	}
	sectionString := strings.Join(sectionList, "\r\n\r\n")
	fileContent := []byte(strings.Join(content, "\r\n"))
	fileContent = []byte(strings.ReplaceAll(string(fileContent), "{__sections__}", sectionString))
	err = ioutil.WriteFile(newPath, fileContent, os.ModePerm)
	if err != nil {
		return -1, fmt.Sprintf("writefile[%s] error:%s", newPath, err.Error())
	}
	color.HiYellow("    WriteNewNsiFile[%s]: Successfully", newPath)
	return 0, ""
}

// ModifySetupNsiParams: 替换setup的nis文件参数
func ModifySetupNsiParams(nsiPath string, isZh bool) (int, string) {
	filePath := nsiPath + "/" + "Nise_setup_template.nsi"
	fileInfo, err := os.Stat(filePath)
	if err != nil {
		return -1, fmt.Sprintf("check file[%s] err:%s", filePath, err.Error())
	}
	if !fileInfo.Mode().IsRegular() {
		return -1, fmt.Sprintf("file[%s] is not a regular file", filePath)
	}
	configNsiParams := SetupInfo.NsiParams
	configNsiParams["language_version"] = "SimpChinese"
	if !isZh {
		configNsiParams["language_version"] = "English"
	}
	for _, value := range NsiParams {
		_, isOk := configNsiParams[value]
		if !isOk {
			return -1, fmt.Sprintf("the param[%s] is not exists", value)
		}
	}

	file, err := os.Open(filePath)
	if err != nil {
		return -1, fmt.Sprintf("open file[%s] error:%s", filePath, err.Error())
	}
	defer file.Close()
	reader := bufio.NewReader(file)
	var content []string
	for {
		bytes, _, isEnd := reader.ReadLine()
		if isEnd != nil {
			break
		}
		str := string(bytes)
		// 替换字符串,只查询替换一次
		for _, value := range NsiParams {
			if strings.Contains(str, value) {
				str = strings.Replace(str, value, configNsiParams[value], 1)
				break
			}
		}
		content = append(content, str)
	}
	// 写入到新文件
	newPath := nsiPath + "/" + "Nise_setup_pack.nsi"
	fileContent := []byte(strings.Join(content, "\r\n"))
	err = ioutil.WriteFile(newPath, fileContent, os.ModePerm)
	if err != nil {
		return -1, fmt.Sprintf("writefile[%s] error:%s", newPath, err.Error())
	}
	color.HiYellow("    WriteNewNsiFile[%s]: Successfully", newPath)
	return 0, ""
}

func PackExec(packPath string) (int, string) {
	info, err := os.Stat(packPath)
	if err != nil {
		return -1, fmt.Sprintf("os.Stat error:%s", err.Error())
	}
	if !info.IsDir() {
		return -1, fmt.Sprintf("[%s] is not a dir!", packPath)
	}
	os.Chdir(packPath)
	fmt.Println("packPath:", packPath)
	cmd := exec.Command("makensis", "./Nise_pack.nsi")
	err = cmd.Run()
	if err != nil {
		return -1, err.Error()
	}
	color.HiYellow("    Make Pack successfully")
	return 0, ""
}

// PackSetupExec: 打包setup主程序
func PackSetupExec(packPath string) (int, string) {
	info, err := os.Stat(packPath)
	if err != nil {
		return -1, fmt.Sprintf("os.Stat error:%s", err.Error())
	}
	if !info.IsDir() {
		return -1, fmt.Sprintf("[%s] is not a dir!", packPath)
	}
	os.Chdir(packPath)
	fmt.Println("packPath:", packPath)
	cmd := exec.Command("makensis", "./Nise_setup_pack.nsi")
	err = cmd.Run()
	if err != nil {
		return -1, err.Error()
	}
	color.HiYellow("    Make setup successfully")
	return 0, ""
}

// 打包完成后发送微信通知
func SendWXNews() (int, string) {
	packInfo := fmt.Sprintf("开始打包时间[%s]", time.Now().Format("2006-01-02 15:04:05"))
	var notifyNews NotifyNews
	notifyNews.URL = ProInfo.WeiXInURL
	notifyNews.Params.TemplateID = ProInfo.TemplateID
	notifyNews.Params.Data.First = KeyWord{"#173177", "自动打包通知"}
	notifyNews.Params.Data.ProName = KeyWord{"#173177", "贵阳营业厅"}
	notifyNews.Params.Data.WorkInfo = KeyWord{"#173177", "完成"}
	notifyNews.Params.Data.Progress = KeyWord{"#173177", packInfo}
	notifyNews.Params.Data.Remark = KeyWord{"#173177", "如有问题，咨询sleeping"}
	for _, userID := range ProInfo.WeiXinUsers {
		notifyNews.Params.ToUser = userID.OpenID
		byteNews, err := json.Marshal(notifyNews)
		if err != nil {
			retStr := err.Error()
			fmt.Println("json Marshal error:", retStr)
			continue
		}

		// 打包成功后发送微信消息
		resp, err := http.Post(ProInfo.NotifyProxy, "application/json", bytes.NewBuffer(byteNews))
		if err != nil {
			retStr := err.Error()
			fmt.Println("http post error:", retStr)
			return -1, retStr
		}
		defer resp.Body.Close()
		result, _ := ioutil.ReadAll(resp.Body)
		color.HiRed(fmt.Sprintf("config:%v\nresult:%v\n", ProInfo, string(result)))
	}
	return 0, ""
}

// init解析配置文件信息
/*
func init() {
	byteContent, err := ioutil.ReadFile(ProFilePath)
	if err != nil {
		log.Fatal("read file err,fileName:", ProFilePath)
	}
	err = json.Unmarshal(byteContent, &ProInfo)
	if err != nil {
		log.Println(err.Error())
	}
}
*/
