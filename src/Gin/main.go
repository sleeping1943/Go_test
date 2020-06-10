package main

import (
	"Gin/conf"
	"Gin/ice"
	"Gin/tools"
	"bufio"
	"fmt"
	"log"
	"net/http"
	"strconv"

	"github.com/gin-gonic/gin"
)

// MapParams : 各个客户端上传缓存的参数信息 <ip, <funcName, funcParams>>
var MapParams = make(map[string]map[string][]string)

func defineStatic(router *gin.Engine) {
	router.StaticFile("/", "./static/index.html")
	router.StaticFile("/Service", "./static/service.html")
	router.StaticFile("/Backend", "./static/backend.html")
	router.StaticFile("/Upload", "./static/upload.html")
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
			} else {
				// ice远程调用
				fmt.Printf("call ice[%s]!", params)
			}
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
			} else {
				// ice远程调用
				fmt.Printf("call ice[%s]!", params)
			}
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
			if mapInfo, ok := MapParams[c.ClientIP()]; !ok {
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
			funcName := c.Query("funcName")
			params, isExists := ice.ServiceFuncs.FuncMap[funcName]
			var retStr = params
			if !isExists {
				params = fmt.Sprintf("func[%s] is not exists!", funcName)
			} else {
				// ice远程调用
				fmt.Printf("call ice[%s]!", params)
			}
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
			log.Fatal("iceupload:%v\n", err)
		}

		file, err := fileReader.Open()
		if err != nil {
			log.Fatal("fileReader open error:%v\n", err)
		}
		content := make([]string, fileReader.Size)
		scanner := bufio.NewScanner(file)
		for scanner.Scan() {
			content = append(content, scanner.Text())
		}
		mapFunc := make(map[string]string)
		ice.CustomizeFuncs.ParseIceByFile(content, mapFunc)
		ice.CustomizeFuncs.ParseParamsByFile(content, mapFunc)
		fmt.Printf("%v \nsize:%d\n", mapFunc, len(content))
		clientIP := c.ClientIP()
		fmt.Println(clientIP)
		c.File("./static/customize.html")
	})
}

func defineRout(router *gin.Engine) {
	defineStatic(router)
	defineService(router)
	defineCustomize(router)
	defineUpload(router)
}

func main() {
	router := gin.Default()
	defineRout(router)
	addr := fmt.Sprintf("%s:%d", conf.Conf.IP, conf.Conf.Port)
	router.Run(addr)
}
