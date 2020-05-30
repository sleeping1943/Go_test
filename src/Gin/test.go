package main

import (
	"fmt"
	"net/http"
	"strconv"
	"test/tools"

	"github.com/gin-gonic/gin"
)

func main() {
	router := gin.Default()

	router.StaticFile("/", "./static/index.html")
	v1 := router.Group("/Service")
	{
		v1.POST("/func", func(c *gin.Context) {
			var funcMap = map[string]string{
				"func1": "Login",
				"func2": "AddPeople",
				"func3": "QueryPeopleInfo",
			}
			//jsonByte, err := json.Marshal(funcMap)
			//if err != nil {
			//	fmt.Printf("%v\n", err)
			//	jsonByte = []byte("{}")
			//}
			//jsonStr := string(jsonByte)
			//fmt.Println(jsonStr)
			c.SecureJSON(http.StatusOK, funcMap)
			//c.JSONP(http.StatusOK, string(jsonStr))
		})
		v1.POST("/call", func(c *gin.Context) {
			funcName := c.PostForm("funcName")
			params := c.PostForm("params")
			ip := c.PostForm("ip")
			strIP := ip
			if !tools.IsIP(ip) {
				strIP = fmt.Sprintf("ip[%s] is invalid!", ip)
			}
			port := c.PostForm("port")
			intPort, err := strconv.Atoi(port)
			if err != nil || (intPort < 0 || intPort > 65535) {
				intPort = -1
			}
			c.JSON(http.StatusOK, gin.H{
				"func_name": funcName,
				"params":    params,
				"code":      0,
				"info":      "...",
				"ip":        strIP,
				"port":      intPort,
			})
		})
		v1.GET("/funcParams", func(c *gin.Context) {
			funcName := c.Query("funcName")
			c.JSON(http.StatusOK, gin.H{
				"org_id":    1,
				"operator":  "jobs",
				"func_name": funcName,
			})
		})
	}
	v2 := router.Group("/Backend")
	{
		v2.POST("/call", func(c *gin.Context) {
			c.JSON(http.StatusOK, gin.H{
				"code": 0,
				"info": "...",
			})
		})
		v2.GET("/funcParams", func(c *gin.Context) {
			c.JSON(http.StatusOK, gin.H{
				"org_id":   1,
				"operator": "jobs",
			})
		})
	}
	router.Run()
}
