package main

import (
	"Gin/conf"
	"Gin/ice"
	"Gin/tools"
	"fmt"
	"net/http"
	"strconv"

	"github.com/gin-gonic/gin"
)

func defineRout(router *gin.Engine) {
	router.StaticFile("/", "./static/index.html")
	router.StaticFile("/Service", "./static/service.html")
	router.StaticFile("/Backend", "./static/backend.html")
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

func main() {
	router := gin.Default()
	defineRout(router)
	addr := fmt.Sprintf("%s:%d", conf.Conf.IP, conf.Conf.Port)
	router.Run(addr)
}
