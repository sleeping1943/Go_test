package main

import (
	"Gin/conf"
	"Gin/ice"
	_ "Gin/sln"
	"Gin/tools"
	"bufio"
	"encoding/base64"
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
)

// RootPath : 项目根路径
var RootPath string

var packConfigName = "remoupack.json"

// MapParams : 各个客户端上传缓存的参数信息 <ip, <funcName, funcParams>>
var MapParams = make(map[string]map[string]string)

// CmakeCmd : cmake生成vs2015工程命令
var CmakeCmd = `cmake ../.. -G "Visual Studio 14 2015 Win64"`

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

// PackInfo : 打包exe程序配置
type PackInfo struct {
	RebuildPro  bool              `json:"rebuildPro"`
	RebuildExe  bool              `json:"rebuildExe"`
	ProjectPath string            `json:"projectPath"`
	CodePath    string            `json:"codePath"`
	BuildParams map[string]string `json:"buildParams"`
	ExeName     string            `json:"exeName"`
	PdbName     string            `json:"pdbName"`
	NsiPath     string            `json:"nsiPath"`
	NsiParams   map[string]string `json:"nsiParams"`
	RebuildPack bool              `json:"rebuildPack"`
}

var defaultPackInfo PackInfo

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

func defineStatic(router *gin.Engine) {
	router.StaticFile("/", "./static/index.html")
	router.StaticFile("/Ice", "./static/Ice.html")
	router.StaticFile("/Project", "./static/project.html")
	router.StaticFile("/Service", "./static/service.html")
	router.StaticFile("/Backend", "./static/backend.html")
	router.StaticFile("/Upload", "./static/upload.html")
	router.StaticFile("/Order", "./static/order.html")
	router.StaticFile("/Pack", "./static/pack.html")
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
		// 目标文件内从转为utf8编码
		utf8Content := strings.Join(content, "\r\n")
		utf8Content = tools.TransUTF8(utf8Content)
		mapFunc := make(map[string]string)
		content = strings.Split(utf8Content, "\r\n")
		ice.CustomizeFuncs.ParseIceByFile(content, mapFunc)
		ice.CustomizeFuncs.ParseParamsByFile(content, mapFunc)
		clientIP := c.ClientIP()
		MapParams[clientIP] = mapFunc
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
	}
}

func definePack(router *gin.Engine) {
	packEngine := router.Group("/Pack")
	{
		packEngine.POST("/remou", func(c *gin.Context) {
			var retStr = "Successfully"
			for {
				configJSON := c.PostForm("configJson")
				var byteConfigJSON = []byte(configJSON)
				err := json.Unmarshal(byteConfigJSON, &defaultPackInfo)
				if err != nil {
					retStr = err.Error()
					break
				}

				fmt.Printf("%v\n", defaultPackInfo)
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
					cmd := exec.Command("./pack/remoupack.exe")
					err := cmd.Run()
					if err != nil {
						retStr := err.Error()
						fmt.Println("Command Run error:", retStr)
						return
					}
					//output, err := cmd.Output()
					//if err != nil {
					//	retStr := err.Error()
					//	fmt.Println("Command Output error:", retStr)
					//	return
					//}
					//fmt.Printf("output:%v\n", output)
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
			for {
				version := c.PostForm("version")
				configJSON := c.PostForm("configJson")
				logContent := c.PostForm("logContent")
				color.HiRed(fmt.Sprintf("logConent:%s\n", logContent))
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
				color.HiGreen(logContent)
				var byteConfigJSON = []byte(configJSON)
				err = json.Unmarshal(byteConfigJSON, &defaultPackInfo)
				if err != nil {
					retStr = err.Error()
					break
				}

				logFileName := defaultPackInfo.ProjectPath + "/" + version
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
			for {
				version := c.PostForm("version")
				configJSON := c.PostForm("configJson")
				var byteConfigJSON = []byte(configJSON)
				err := json.Unmarshal(byteConfigJSON, &defaultPackInfo)
				if err != nil {
					retStr = err.Error()
					break
				}

				logFileName := defaultPackInfo.ProjectPath + "/" + version

				byteContent, err := ioutil.ReadFile(logFileName)
				if err != nil {
					retStr = err.Error()
					break
				}
				retStr = string(byteContent)
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

func defineRout(router *gin.Engine) {
	defineStatic(router)
	defineService(router)
	defineBackend(router)
	defineCustomize(router)
	defineUpload(router)
	defineProject(router)
	defineOther(router)
	definePack(router)
}

func main() {
	rootPath, err := os.Getwd()
	if err != nil {
		Error.Printf("获取当前目录出错:%s\n", err.Error())
		return
	}
	RootPath = rootPath
	ReciveCh()
	router := gin.Default()
	defineRout(router)
	addr := fmt.Sprintf("%s:%d", conf.Conf.IP, conf.Conf.Port)
	router.Run(addr)
}
