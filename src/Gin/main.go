package main

// _ "Gin/compress"
import (
	"Gin/conf"
	"Gin/db"
	"Gin/ice"
	"Gin/pack"
	_ "Gin/sln"
	"Gin/tools"
	"bufio"
	"bytes"
	"crypto/sha256"
	"encoding/base64"
	"encoding/hex"
	"encoding/json"
	"fmt"
	"io/ioutil"
	"log"
	"net/http"
	"net/url"
	"os"
	"os/exec"
	"strconv"
	"strings"
	"time"

	"github.com/fatih/color"
	"github.com/gin-gonic/gin"
	"github.com/piaohao/godis"
)

// RootPath : 项目根路径
var RootPath string

// RebuildPathKey : 重建工程的Redis key
var RebuildPathKey = "VSRebuildPath"

// IceShaKey : ice文件哈希值key
var IceShaKey = "IceSha"

var packConfigName = "remoupack.json"

var setupConfigName = "setup.json"

// MapParams : 各个客户端上传缓存的参数信息 <ip, <funcName, funcParams>>
var MapParams = make(map[string]map[string]string)

// CmakeCmd : cmake生成vs2015工程命令
var CmakeCmd = `cmake ../.. -G "Visual Studio 14 2015 Win64"`

// ReleaseNotePath : 修改日志相对路径
var ReleaseNotePath = "Documents/ReleaseNote.txt"

// chVsPro : 通知vs工程文件创建完成，并打开工程
var chVsPro = make(chan string)

var (
	// Info : 一般等级日志
	Info *log.Logger
	// Warning : 警告日志
	Warning *log.Logger
	// Error : 错误日志
	Error *log.Logger
)

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

// PackInfo : 打包exe程序配置
type PackInfo struct {
	RebuildProComment         string            `json:"rebuildProComment"`
	RebuildPro                bool              `json:"rebuildPro"`
	RebuildExeComment         string            `json:"rebuildExeComment"`
	RebuildExe                bool              `json:"rebuildExe"`
	ProjectPathVersionComment string            `json:"projectPathVersionComment"`
	ProjectPathEN             string            `json:"projectPathEN"`
	ProjectPathZH             string            `json:"projectPathZH"`
	ProjectPathComment        string            `json:"projectPathComment"`
	ProjectPath               string            `json:"projectPath"`
	CodePathComment           string            `json:"codePathComment"`
	CodePath                  string            `json:"codePath"`
	BuildParamsComment        string            `json:"buildParamsComment"`
	BuildParams               map[string]string `json:"buildParams"`
	ExeNameComment            string            `json:"exeNameComment"`
	ExeName                   string            `json:"exeName"`
	PdbNameComment            string            `json:"pdbNameComment"`
	PdbName                   string            `json:"pdbName"`
	NsiPathComment            string            `json:"nsiPathComment"`
	NsiPath                   string            `json:"nsiPath"`
	NsiParamsComment          string            `json:"nsiParamsComment"`
	NsiParams                 map[string]string `json:"nsiParams"`
	RebuildPackComment        string            `json:"rebuildPackComment"`
	RebuildPack               bool              `json:"rebuildPack"`

	DefaultFrontendIPComment string       `json:"defaultFrontendIPComment"`
	DefaultFrontendIP        string       `json:"defaultFrontendIP"`
	TemplateID               string       `json:"templateID"`
	NotifyProxy              string       `json:"notifyProxy"`
	WeiXinUsers              []WeiXinUser `json:"weixinUsers"`
	WeiXInURL                string       `json:"weixinurl"`
}

var defaultPackInfo PackInfo
var pool *godis.Pool

func init() {
	errFile, err := os.OpenFile("./errors.log", os.O_CREATE|os.O_WRONLY|os.O_APPEND, 0666)
	if err != nil {
		log.Fatalln("打开日志文件失败：", err)
	}

	Info = log.New(os.Stdout, "Info:", log.Ldate|log.Ltime|log.Lshortfile)
	Warning = log.New(os.Stdout, "Warning:", log.Ldate|log.Ltime|log.Lshortfile)
	//Error = log.New(io.MultiWriter(os.Stderr, errFile), "Error:", log.Ldate|log.Ltime|log.Lshortfile)
	Error = log.New(errFile, "Error:", log.Ldate|log.Ltime|log.Lshortfile)

	// 解析默认的打包配置
	byteContent, err := ioutil.ReadFile("./" + packConfigName)
	if err != nil {
		Error.Println("open file error:", err.Error())
	}
	err = json.Unmarshal(byteContent, &defaultPackInfo)
	if err != nil {
		Error.Println("parse pack.json error:", err.Error())
	}
}

// 打印当前项目根目录
func printWd() {
	curWorkDir, err := os.Getwd()
	if err != nil {
		fmt.Sprintf("获取当前目录出错:%s", err.Error())
		return
	}
	fmt.Sprintf("当前目录:%s", curWorkDir)
}

// ReciveCh : ch接收器
func ReciveCh() {
	go func() {
		for {
			select {
			case path := <-chVsPro:
				file, err := os.Open(path)
				if err != nil {
					Error.Printf("open vs project err:%s\n", err.Error())
					continue
				}
				files, err := file.Readdirnames(0)
				if err != nil {
					Error.Printf("readdirnames err:%s\n", err.Error())
					continue
				}
				// 遍历找到工程文件并打开,windows服务不能开启界面交互，所以此功能需要以普通程序启动
				for _, name := range files {
					if strings.HasSuffix(name, ".sln") {
						cmd := exec.Command("devenv.com", name)
						err := cmd.Run()
						if err != nil {
							Error.Printf("open sln err:%s\n", err.Error())
						}
						break
					}
				}
				err = os.Chdir(RootPath)
				if err != nil {
					Error.Printf("change dir error:%s\n", RootPath)
				}
				// 关闭文件夹的占用，否则不能删除
				file.Close()
				Error.Printf("close %s\n", path)
			}
		}
	}()
}

func autoPack(isZh bool) {
	// 解析配置文件
	byteContent, err := ioutil.ReadFile(pack.ProFilePath)
	if err != nil {
		color.Red(fmt.Sprintf("read file err,fileName:%s\n", pack.ProFilePath))
	}
	err = json.Unmarshal(byteContent, &(pack.ProInfo))
	if err != nil {
		color.Red(err.Error())
		return
	}
	codePath := pack.ProInfo.CodePath
	color.HiGreen("step1: 重新生成工程文件")
	if pack.ProInfo.RebuildPro {
		buildErr := pack.Rebuild(codePath)
		if buildErr != nil {
			log.Fatalln(buildErr.Error())
		}
	} else {
		color.Blue("    配置为不重新生成")
	}
	buildPath := fmt.Sprintf("%s/%s", codePath, pack.SlnPath)
	color.HiGreen("step2: 重编可执行程序")
	if pack.ProInfo.RebuildExe {
		errcode, msg := pack.CompileExecute(codePath, buildPath)
		if errcode != 0 {
			fmt.Println("compile Execute error:", msg)
		}
	} else {
		color.Blue("    配置为不重新编译")
	}
	color.HiGreen("step3: 拷贝配置文件到发布文件夹backend/Business/process/default/")
	pack.CopyFiles(pack.DefaultConfigPath, pack.DefaultPackConfigPath)

	color.HiGreen("step4: 拷贝sql文件到发布文件夹backend/MySQLScript")
	pack.CopyFiles(pack.DefaultSQLFilePath, pack.PackSQLFilePath)

	color.HiGreen("step5: 拷贝可执行文件到发布文件夹backend/Business/process/")
	errCode, errMsg := pack.CopyExe(pack.ExePath, pack.SaasExePath, pack.ProInfo.ExeName)
	if errCode != 0 {
		color.HiRed(errMsg)
	}
	errCode, errMsg = pack.CopyExe(pack.ExePath, pack.SaasExePath, pack.ProInfo.PdbName)
	if errCode != 0 {
		color.HiRed(errMsg)
	}

	color.Green("step6: 修改打包的Fronted中配置文件的默认ip为'127.0.0.1'")
	errCode, errMsg = pack.ModifyFrontedDefaultIP(pack.ProInfo.ProPath + "/Frontend/Frontend/configFile.js")
	if errCode != 0 {
		color.HiRed(errMsg)
	}

	color.Green("step7: 修改打包的nsi文件内容")
	errCode, errMsg = pack.ModifyNsiParams(pack.ProInfo.NsiPath, isZh)
	if errCode != 0 {
		color.HiRed(errMsg)
	}

	if pack.ProInfo.Repack {
		color.Green("step8: 打包发布的所有文件成一个exe文件")
		errCode, errMsg = pack.PackExec(pack.ProInfo.NsiPath)
		if errCode != 0 {
			color.HiRed(errMsg)
		}
	}
	// 重置根目录
	err = os.Chdir(RootPath)
	if err != nil {
		color.HiRed("reset project dir error:" + err.Error())
	}
}

func autoPackMainExe(isZh bool) {
	// 解析配置文件
	confFilePath := "./" + setupConfigName
	byteContent, err := ioutil.ReadFile(confFilePath)
	if err != nil {
		color.Red(fmt.Sprintf("read file err,fileName:%s\n", confFilePath))
	}
	err = json.Unmarshal(byteContent, &(pack.SetupInfo))
	if err != nil {
		color.Red(err.Error())
		return
	}
	color.Green("step1: 修改打包的nsi文件内容")
	errCode, errMsg := pack.ModifySetupNsiParams(pack.SetupInfo.NsiPath, isZh)
	if errCode != 0 {
		color.HiRed(errMsg)
	}

	color.Green("step2: 打包发布的所有文件成一个exe文件")
	errCode, errMsg = pack.PackSetupExec(pack.SetupInfo.NsiPath)
	if errCode != 0 {
		color.HiRed(errMsg)
	}
	// 重置根目录
	err = os.Chdir(RootPath)
	if err != nil {
		color.HiRed("reset project dir error:" + err.Error())
	}
}

// getShaSum : 获取指定内容的哈希值
func getShaSum(content []byte) string {
	shaEncoder := sha256.New()
	shaEncoder.Write(content)
	retByte := shaEncoder.Sum(nil)
	return hex.EncodeToString(retByte)
}

// isSameShaSum : 检测ice文件内容是否更改过
func isSameShaSum(checkRet string) bool {
	isChanged := true
	redis, _ := pool.GetResource()
	defer redis.Close()
	lastCheckSum, err := redis.Get(IceShaKey)
	if err != nil {
		color.RedString("Set redis cache error:", err.Error())
	}
	if checkRet != lastCheckSum {
		isChanged = false
	}
	return isChanged
}

func defineStatic(router *gin.Engine) {
	router.StaticFile("/", "./static/index.html")
	router.StaticFile("/Ice", "./static/Ice.html")
	router.StaticFile("/Project", "./static/project.html")
	router.StaticFile("/Service", "./static/service.html")
	router.StaticFile("/Backend", "./static/backend.html")
	router.StaticFile("/Upload", "./static/upload.html")
	router.StaticFile("/Order", "./static/order.html")
	router.StaticFile("/Pack", "./static/pack.html")
	router.StaticFile("/Setup", "./static/setup.html")
	router.StaticFile("/Compress", "./static/compress.html")
}

func defineService(router *gin.Engine) {
	service := router.Group("/Service")
	{
		service.POST("/func", func(c *gin.Context) {
			c.SecureJSON(http.StatusOK, ice.ServiceFuncs.FuncMap)
		})
		service.POST("/call", func(c *gin.Context) {
			funcName := c.PostForm("funcName")
			params := c.PostForm("params")
			flag := c.PostForm("flag")
			ip := c.PostForm("ip")
			if !tools.IsIP(ip) {
				strIP := fmt.Sprintf("ip[%s] is invalid!", ip)
				c.JSON(http.StatusOK, gin.H{
					"code": 0,
					"info": strIP,
				})
			}
			port := c.PostForm("port")
			intPort, err := strconv.Atoi(port)
			if err != nil || (intPort < 0 || intPort > 65535) {
				intPort = -1
			}

			iceFlag := fmt.Sprintf("%s:default -h %s -p %d", flag, ip, intPort)
			retStr := ice.Invoke(iceFlag, funcName, params)
			c.JSON(http.StatusOK, gin.H{
				"code": 0,
				"info": retStr,
			})
		})
		service.GET("/funcParams", func(c *gin.Context) {
			funcName := c.Query("funcName")
			params, isExists := ice.ServiceFuncs.FuncMap[funcName]
			var retStr = params
			if !isExists {
				params = fmt.Sprintf("func[%s] is not exists!", funcName)
			}
			//else {
			//	// ice远程调用
			//	fmt.Printf("call ice[%s]!", params)
			//}
			c.JSON(http.StatusOK, gin.H{
				"org_id":    1,
				"operator":  "jobs",
				"func_name": retStr,
			})
		})
	}
}

func defineBackend(router *gin.Engine) {
	backend := router.Group("/Backend")
	{
		backend.POST("/func", func(c *gin.Context) {
			c.SecureJSON(http.StatusOK, ice.BackendFuncs.FuncMap)
		})
		backend.POST("/call", func(c *gin.Context) {
			funcName := c.PostForm("funcName")
			params := c.PostForm("params")
			flag := c.PostForm("flag")
			ip := c.PostForm("ip")
			if !tools.IsIP(ip) {
				strIP := fmt.Sprintf("ip[%s] is invalid!", ip)
				c.JSON(http.StatusOK, gin.H{
					"code": 0,
					"info": strIP,
				})
			}
			port := c.PostForm("port")
			intPort, err := strconv.Atoi(port)
			if err != nil || (intPort < 0 || intPort > 65535) {
				intPort = -1
			}

			iceFlag := fmt.Sprintf("%s:default -h %s -p %d", flag, ip, intPort)
			retStr := ice.Invoke(iceFlag, funcName, params)
			c.JSON(http.StatusOK, gin.H{
				"code": 0,
				"info": retStr,
			})
		})
		backend.GET("/funcParams", func(c *gin.Context) {
			funcName := c.Query("funcName")
			params, isExists := ice.BackendFuncs.FuncMap[funcName]
			var retStr = params
			if !isExists {
				params = fmt.Sprintf("func[%s] is not exists!", funcName)
			}
			//else {
			//	// ice远程调用
			//	fmt.Printf("call ice[%s]!", params)
			//}
			c.JSON(http.StatusOK, gin.H{
				"org_id":    1,
				"operator":  "jobs",
				"func_name": retStr,
			})
		})
	}
}

func defineCustomize(router *gin.Engine) {
	customize := router.Group("/Customize")
	{
		customize.POST("/func", func(c *gin.Context) {
			mapInfo, ok := MapParams[c.ClientIP()]
			if !ok {
				tmpMap := make(map[string]string)
				tmpMap["info"] = "error"
				c.SecureJSON(http.StatusOK, tmpMap)
			} else {
				c.SecureJSON(http.StatusOK, mapInfo)
			}
		})
		customize.POST("/call", func(c *gin.Context) {
			funcName := c.PostForm("funcName")
			params := c.PostForm("params")
			flag := c.PostForm("flag")
			ip := c.PostForm("ip")
			if !tools.IsIP(ip) {
				strIP := fmt.Sprintf("ip[%s] is invalid!", ip)
				c.JSON(http.StatusOK, gin.H{
					"code": 0,
					"info": strIP,
				})
			}
			port := c.PostForm("port")
			intPort, err := strconv.Atoi(port)
			if err != nil || (intPort < 0 || intPort > 65535) {
				intPort = -1
			}

			iceFlag := fmt.Sprintf("%s:default -h %s -p %d", flag, ip, intPort)
			retStr := ice.Invoke(iceFlag, funcName, params)
			c.JSON(http.StatusOK, gin.H{
				"code": 0,
				"info": retStr,
			})
		})
		customize.GET("/funcParams", func(c *gin.Context) {
			clientIP := c.ClientIP()
			mapInfos, ok := MapParams[clientIP]
			// 不存在该客户端缓存函数信息
			if !ok {
				c.File("./static/error.html")
				return
			}
			funcName := c.Query("funcName")
			params, isExists := mapInfos[funcName]
			var retStr = params
			if !isExists {
				params = fmt.Sprintf("func[%s] is not exists!", funcName)
			}
			//else {
			//	// ice远程调用
			//	fmt.Printf("call ice[%s]!", params)
			//}
			c.JSON(http.StatusOK, gin.H{
				"org_id":    1,
				"operator":  "jobs",
				"func_name": retStr,
			})
		})
	}
}

func defineUpload(router *gin.Engine) {
	router.POST("/iceupload", func(c *gin.Context) {
		fileReader, err := c.FormFile("myfile")
		if err != nil {
			Error.Printf("iceupload:%v\n", err)
		}

		file, err := fileReader.Open()
		if err != nil {
			Error.Printf("fileReader open error:%v\n", err)
		}
		content := make([]string, fileReader.Size)
		scanner := bufio.NewScanner(file)
		for scanner.Scan() {
			line := strings.TrimSpace(scanner.Text())
			if len(line) > 0 {
				content = append(content, line)
			}
		}
		strContent := strings.Join(content, "")
		byteContent := []byte(strContent)
		shaSum := getShaSum(byteContent)
		if !isSameShaSum(shaSum) { // 若此次ice文件sha值和上次不一样，则文件改动过，解析之
			utf8Content := strings.Join(content, "\r\n")
			utf8Content = tools.TransUTF8(utf8Content) // 目标文件内从转为utf8编码
			mapFunc := make(map[string]string)
			content = strings.Split(utf8Content, "\r\n")
			ice.CustomizeFuncs.ParseIceByFile(content, mapFunc)
			ice.CustomizeFuncs.ParseParamsByFile(content, mapFunc)
			MapParams[c.ClientIP()] = mapFunc
			redis, _ := pool.GetResource()
			redis.Set(IceShaKey, shaSum)
		}
		//fmt.Println(clientIP)
		// 返回自定义页面
		c.File("./static/customize.html")
	})
}

func defineProject(router *gin.Engine) {
	project := router.Group("/Project")
	{
		project.POST("/rebuild", func(c *gin.Context) {
			path := c.PostForm("path")
			path = strings.Replace(path, "\\", "/", -1)
			retStr := "成功-" + time.Now().Format("2006-01-02 15:04:05")
			// 缓存此次文件目录到redis
			{
				redis, _ := pool.GetResource()
				defer redis.Close()
				_, err := redis.Set(RebuildPathKey, path)
				if err != nil {
					color.RedString("Set redis cache error:", err.Error())
				}
			}
			// 检车文件目录是否存在
			// 然后删除builds/vs2015文件夹下的所有文件
			// 创建build/vs2015文件夹
			// 建立cmake的windows工程
			// 遍历得到.sln文件路径
			// devenv.com 打开工程
			// CmakeCmd = `cmake ../.. -G "Visual Studio 14 2015 Win64"`
		Loop:
			for {
				fileInfo, err := os.Stat(path)
				// 路径不存在
				if err != nil {
					retStr = fmt.Sprintf("%s 打开失败", path)
					break
				}
				if !fileInfo.IsDir() {
					retStr = fmt.Sprintf("%s 不是一个文件夹", path)
					break
				}
				buildPath := fmt.Sprintf("%s/builds/vs2015", path)
				err = os.MkdirAll(buildPath, os.ModePerm)
				if err != nil {
					retStr = fmt.Sprintf("%s 创建失败", buildPath)
					break
				}
				file, err := os.Open(buildPath)
				if err != nil {
					retStr = fmt.Sprintf("%s 打开失败", path)
					break
				}
				defer file.Close()
				files, err := file.Readdirnames(0)
				if err != nil {
					retStr = fmt.Sprintf("%s 读取失败", path)
					break
				}
				for _, name := range files {
					filePath := fmt.Sprintf("%s/%s", buildPath, name)
					err := os.RemoveAll(filePath)
					if err != nil {
						retStr = fmt.Sprintf("%s 删除失败", filePath)
						break Loop
					}
				}

				curWorkDir, err := os.Getwd()
				if err != nil {
					retStr = fmt.Sprintf("获取当前目录出错:%s", err.Error())
					break
				}

				// 切换到初始根目录下
				defer func(wd string) {
					err := os.Chdir(buildPath)
					if err != nil {
						Error.Printf("open vs project err:%s\n", err.Error())
					}
				}(curWorkDir)

				go func() {
					// 切换到builds/vs2015目录下
					err := os.Chdir(buildPath)
					if err != nil {
						Error.Printf("change dir error[%s]\n", buildPath)
						return
					}
					cmd := exec.Command("cmake", "../..", "-G", "Visual Studio 14 2015 Win64")
					err = cmd.Run()
					if err != nil {
						Error.Printf("cmd execute err:%s\n", err.Error())
					}
					chVsPro <- buildPath
					Error.Printf("Send chVsPro[%s]\n", buildPath)
				}()
				//fmt.Printf("files:%v len:%d\n", files, len(files))
				break
			}
			c.JSON(http.StatusOK, gin.H{
				"code": 0,
				"info": retStr,
			})
		})
		project.POST("/get_last_path", func(c *gin.Context) {
			// 从Redis获取上次的工程路径
			retStr := ""
			{
				redis, _ := pool.GetResource()
				defer redis.Close()
				lastRebuildPath, err := redis.Get(RebuildPathKey)
				if err != nil {
					color.RedString("Get redis cache error:", err.Error())
				} else {
					retStr = lastRebuildPath
				}
			}
			c.JSON(http.StatusOK, gin.H{
				"code": 0,
				"info": retStr,
			})
		})
	}
}

func definePack(router *gin.Engine) {
	packEngine := router.Group("/Pack")
	{
		packEngine.POST("/remou", func(c *gin.Context) {
			var retStr = "Successfully"
			for {
				var isZh = true
				version := c.PostForm("version")
				if version == "EN" {
					isZh = false
				}
				configJSON := c.PostForm("configJson")
				var byteConfigJSON = []byte(configJSON)
				err := json.Unmarshal(byteConfigJSON, &defaultPackInfo)
				if err != nil {
					retStr = err.Error()
					break
				}

				//fmt.Printf("%v\n", defaultPackInfo)
				file, err := os.Open("./" + packConfigName)
				if err != nil {
					retStr = err.Error()
					break
				}
				defer file.Close()
				err = ioutil.WriteFile("./"+packConfigName, byteConfigJSON, os.ModePerm)
				if err != nil {
					retStr = err.Error()
					break
				}
				// 异步开启打包程序
				go func() {
					packTime := time.Now().Format("2006-01-02 15:04:05")
					autoPack(isZh)
					//cmd := exec.Command("./pack/remoupack.exe")
					//err := cmd.Run()
					//if err != nil {
					//	retStr := err.Error()
					//	fmt.Println("Command Run error:", retStr)
					//	return
					//}

					exeName, isExists := defaultPackInfo.NsiParams["product_file_name"]
					if !isExists {
						exeName = "热眸"
					}
					var notifyNews NotifyNews
					notifyNews.URL = defaultPackInfo.WeiXInURL
					notifyNews.Params.TemplateID = defaultPackInfo.TemplateID
					notifyNews.Params.Data.First = KeyWord{"#173177", "自动打包通知"}
					notifyNews.Params.Data.ProName = KeyWord{"#173177", exeName + ".exe"}
					notifyNews.Params.Data.WorkInfo = KeyWord{"#173177", "完成"}
					notifyNews.Params.Data.Progress = KeyWord{"#173177", "开始打包时间[" + packTime + "]"}
					notifyNews.Params.Data.Remark = KeyWord{"#173177", "如有问题，咨询sleeping"}
					for _, userID := range defaultPackInfo.WeiXinUsers {
						notifyNews.Params.ToUser = userID.OpenID
						byteNews, err := json.Marshal(notifyNews)
						if err != nil {
							retStr := err.Error()
							fmt.Println("json Marshal error:", retStr)
							continue
						}

						// 打包成功后发送微信消息
						//color.HiYellow(fmt.Sprintf("WeiXinUsers:%v\n", defaultPackInfo.WeiXinUsers))
						//color.HiGreen(fmt.Sprintf("Proxy:%s\n, content:%s\n", defaultPackInfo.NotifyProxy, string(byteNews)))
						resp, err := http.Post(defaultPackInfo.NotifyProxy, "application/json", bytes.NewBuffer(byteNews))
						if err != nil {
							retStr := err.Error()
							fmt.Println("http post error:", retStr)
							return
						}
						defer resp.Body.Close()
						result, _ := ioutil.ReadAll(resp.Body)
						color.HiRed(fmt.Sprintf("config:%v\nresult:%v\n", defaultPackInfo, string(result)))
					}
				}()

				break
			}
			c.JSON(http.StatusOK, gin.H{
				"code": 0,
				"info": retStr,
			})
		})
		packEngine.POST("/config", func(c *gin.Context) {
			byteConfig, err := ioutil.ReadFile("./" + packConfigName)
			var errcode = 0
			if err != nil {
				errcode = -1
				Error.Println("get default pack config error:", err.Error())
			}

			c.JSON(http.StatusOK, gin.H{
				"code":   errcode,
				"config": string(byteConfig),
			})
		})

		packEngine.POST("/changeLog", func(c *gin.Context) {
			var retStr = "修改日志成功"
		Loop:
			for {
				version := c.PostForm("version")
				configJSON := c.PostForm("configJson")
				logContent := c.PostForm("logContent")
				//color.HiRed(fmt.Sprintf("logConent:%s\n", logContent))
				byteLogContent, err := base64.StdEncoding.DecodeString(logContent)
				if err != nil {
					retStr = err.Error()
					break
				}
				logContent, err = url.QueryUnescape(string(byteLogContent))
				if err != nil {
					retStr = err.Error()
					break
				}
				//color.HiGreen(logContent)
				var byteConfigJSON = []byte(configJSON)
				err = json.Unmarshal(byteConfigJSON, &defaultPackInfo)
				if err != nil {
					retStr = err.Error()
					break
				}

				logFileName := ""
				switch version {
				case "ZH": // 中文版
					logFileName = fmt.Sprintf("%s/%s", defaultPackInfo.ProjectPathZH, ReleaseNotePath)
					break
				case "EN": // 英文版
					logFileName = fmt.Sprintf("%s/%s",
						defaultPackInfo.ProjectPathEN, ReleaseNotePath)
					break
				default: // 未知版本
					retStr = "Unknow version"
					break Loop
				}
				err = ioutil.WriteFile(logFileName, []byte(logContent), os.ModePerm)
				if err != nil {
					retStr = err.Error()
					break
				}
				color.HiYellow(fmt.Sprintf("retStr:%s\n", retStr))
				break
			}
			c.JSON(http.StatusOK, gin.H{
				"code": 0,
				"info": retStr,
			})
		})

		packEngine.POST("/readLog", func(c *gin.Context) {
			var retStr = "Successfully"
			var jsonConfig = "{}"
		Loop:
			for {
				version := c.PostForm("version")
				configJSON := c.PostForm("configJson")
				var byteConfigJSON = []byte(configJSON)
				err := json.Unmarshal(byteConfigJSON, &defaultPackInfo)
				if err != nil {
					retStr = err.Error()
					break
				}
				logFileName := ""
				switch version {
				case "ZH": // 中文版
					logFileName = fmt.Sprintf("%s/%s",
						defaultPackInfo.ProjectPathZH, ReleaseNotePath)
					defaultPackInfo.ProjectPath = defaultPackInfo.ProjectPathZH
					break
				case "EN": // 英文版
					logFileName = fmt.Sprintf("%s/%s",
						defaultPackInfo.ProjectPathEN, ReleaseNotePath)
					defaultPackInfo.ProjectPath = defaultPackInfo.ProjectPathEN
					break
				default: // 未知版本
					retStr = "Unknow version"
					break Loop
				}

				byteContent, err := ioutil.ReadFile(logFileName)
				if err != nil {
					retStr = err.Error()
					break
				}
				retStr = string(byteContent)
				byteJSONConfig, err := json.MarshalIndent(defaultPackInfo, "", "\t")
				jsonConfig = string(byteJSONConfig)
				if err != nil {
					retStr = err.Error()
					break
				}
				break
			}
			c.JSON(http.StatusOK, gin.H{
				"code":   0,
				"info":   retStr,
				"config": jsonConfig,
			})
		})
	}
}

func defineSetup(router *gin.Engine) {
	packEngine := router.Group("/Setup")
	{
		packEngine.POST("/config", func(c *gin.Context) {
			byteConfig, err := ioutil.ReadFile("./" + setupConfigName)
			var errcode = 0
			if err != nil {
				errcode = -1
				Error.Println("get default setup config error:", err.Error())
			}

			c.JSON(http.StatusOK, gin.H{
				"code":   errcode,
				"config": string(byteConfig),
			})
		})
		packEngine.POST("/pack", func(c *gin.Context) {
			var retStr = "Successfully"
			for {
				version := c.PostForm("version")
				configJSON := c.PostForm("configJson")
				var byteConfigJSON = []byte(configJSON)
				err := json.Unmarshal(byteConfigJSON, &pack.SetupInfo)
				if err != nil {
					retStr = err.Error()
					break
				}
				// 把前端传过来的json配置会写到本地配置文件
				file, err := os.Open("./" + setupConfigName)
				if err != nil {
					retStr = err.Error()
					break
				}
				defer file.Close()
				err = ioutil.WriteFile("./"+setupConfigName, byteConfigJSON, os.ModePerm)
				if err != nil {
					retStr = err.Error()
					break
				}
				// 异步开启打包程序
				go func() {
					packTime := time.Now().Format("2006-01-02 15:04:05")
					autoPackMainExe(version == "ZH")
					exeName, isExists := defaultPackInfo.NsiParams["product_file_name"]
					if !isExists {
						exeName = "热眸"
					}
					var notifyNews NotifyNews
					notifyNews.URL = defaultPackInfo.WeiXInURL
					notifyNews.Params.TemplateID = defaultPackInfo.TemplateID
					notifyNews.Params.Data.First = KeyWord{"#173177", "自动打包通知"}
					notifyNews.Params.Data.ProName = KeyWord{"#173177", exeName + ".exe"}
					notifyNews.Params.Data.WorkInfo = KeyWord{"#173177", "完成"}
					notifyNews.Params.Data.Progress = KeyWord{"#173177", "开始打包时间[" + packTime + "]"}
					notifyNews.Params.Data.Remark = KeyWord{"#173177", "如有问题，咨询sleeping"}
					for _, userID := range defaultPackInfo.WeiXinUsers {
						notifyNews.Params.ToUser = userID.OpenID
						byteNews, err := json.Marshal(notifyNews)
						if err != nil {
							retStr := err.Error()
							fmt.Println("json Marshal error:", retStr)
							continue
						}

						// 打包成功后发送微信消息
						resp, err := http.Post(defaultPackInfo.NotifyProxy, "application/json", bytes.NewBuffer(byteNews))
						if err != nil {
							retStr := err.Error()
							fmt.Println("http post error:", retStr)
							return
						}
						defer resp.Body.Close()
						result, _ := ioutil.ReadAll(resp.Body)
						color.HiRed(fmt.Sprintf("config:%v\nresult:%v\n", defaultPackInfo, string(result)))
					}
				}()
				break
			}
			c.JSON(http.StatusOK, gin.H{
				"code": 0,
				"info": retStr,
			})
		})
	}
}

// 其余请求
func defineOther(router *gin.Engine) {
	router.StaticFile("/Video", "./conf/video.json")
}

func defineTest(router *gin.Engine) {
	testEngine := router.Group("/test")
	testEngine.GET("/1", func(c *gin.Context) {
		var retStr = "Successfully test/1 sleep 10 seconds"
		var jsonConfig = "{}"
		time.Sleep(10 * time.Second)
		c.JSON(http.StatusOK, gin.H{
			"code":   0,
			"info":   retStr,
			"config": jsonConfig,
		})
	})
	testEngine.GET("/2", func(c *gin.Context) {
		var retStr = "Successfully test/2"
		var jsonConfig = "{}"
		c.JSON(http.StatusOK, gin.H{
			"code":   0,
			"info":   retStr,
			"config": jsonConfig,
		})
	})
}

func defineDb(router *gin.Engine) {
	testEngine := router.Group("/db")
	testEngine.GET("/test", func(c *gin.Context) {
		c.JSON(http.StatusOK, gin.H{
			"code": 0,
			"info": db.TestRead(),
		})
	})
}

func defineHelpFuncs(router *gin.Engine) {
	helpEngine := router.Group("/tools")
	helpEngine.POST("/reset_root_path", func(c *gin.Context) {
		_, err := os.Stat(RootPath)
		retStr := "reset RootPath:" + RootPath + " Successfully"
		for {
			if err != nil {
				retStr = fmt.Sprintf("The RootPath[%s] is not exists", RootPath)
				color.RedString(retStr)
				break
			}
			err = os.Chdir(RootPath)
			if err != nil {
				retStr := fmt.Sprintf("Chdir RootPath[%s] error", RootPath)
				color.RedString(retStr)
				break
			}
			break
		}
		c.JSON(http.StatusOK, gin.H{
			"code": 0,
			"info": retStr,
		})
	})
}

/*
func defineCompress(router *gin.Engine) {
	testEngine := router.Group("/Compress")
	testEngine.POST("/newer", func(c *gin.Context) {
		retStr := ""
		compressPath := c.PostForm("compress_path")
		if len(compressPath) <= 0 {
			color.HiRed("compressPath is invalid:", compressPath)
			retStr = fmt.Sprintf("compressPath error:%s", compressPath)
		} else {
			var dirNeedCompress []string
			compressPath = strings.Replace(compressPath, "\\", "/", -1)
			compress.CompressNewer(compressPath, &dirNeedCompress)
			if len(dirNeedCompress) <= 0 {
				retStr = "所有压缩文件都是最新的，无需重新压缩!"
			} else {
				retStr = fmt.Sprintf("共有%d个文件需要压缩", len(dirNeedCompress))
			}
		}
		c.JSON(http.StatusOK, gin.H{
			"code": 0,
			"info": retStr,
		})
	})
}
*/
func defineRout(router *gin.Engine) {
	defineStatic(router)
	defineService(router)
	defineBackend(router)
	defineCustomize(router)
	defineUpload(router)
	defineProject(router)
	defineOther(router)
	definePack(router)
	defineSetup(router)
	defineTest(router)
	defineDb(router)
	defineHelpFuncs(router)
	//defineCompress(router)
}

// cleanCache : 为防止程序停止后，redis中的缓存数据造成干扰，故启动时删除
func cleanCache() {
	redis, _ := pool.GetResource()
	defer redis.Close()
	delNum, err := redis.Del(IceShaKey)
	if err != nil {
		color.RedString("Set redis cache error:", err.Error())
	} else {
		color.RedString(fmt.Sprintf("Del %d key from redis!", delNum))
	}
}

func init() {
	option := &godis.Option{
		Host: "localhost",
		Port: 6379,
		Db:   0,
	}
	pool = godis.NewPool(&godis.PoolConfig{}, option)
}

func main() {
	rootPath, err := os.Getwd()
	if err != nil {
		Error.Printf("获取当前目录出错:%s\n", err.Error())
		return
	}
	color.GreenString("当前工作目录:%s\n", rootPath)
	cleanCache()
	RootPath = rootPath
	ReciveCh()
	router := gin.Default()
	defineRout(router)
	addr := fmt.Sprintf("%s:%d", conf.Conf.IP, conf.Conf.Port)
	router.Run(addr)
}
