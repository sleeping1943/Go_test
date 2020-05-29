package ice

import (
	"bufio"
	"fmt"
	"log"
	"os"
	"strings"
)

// SaasServicePath : service端ice文件路径
var SaasServicePath = "./ice/conf/SaasService.ice"

// funcMap : <函数名, 函数参数说明>
var funcMap = make(map[string]string)

// prefix : <返回值>
var prefix = []string{"int", "void"}

// SaasService : service结构体
type SaasService struct{}

func init() {
	fmt.Printf("init SaasServicePath:[%s]\n", SaasServicePath)
}

// ParseIce : 解析ice文件
func (s SaasService) ParseIce(path string) {
	fmt.Printf("SaasServicePath:[%s]\n", path)
	fd, err := os.Open(SaasServicePath)
	if err != nil {
		log.Fatal(err)
	}
	scanner := bufio.NewScanner(fd)
	for scanner.Scan() {
		line := scanner.Text()
		line = strings.TrimSpace(line)
		for _, pre := range prefix {
			//fmt.Printf("line:%s,pre:%s\n", line, pre)
			if strings.HasPrefix(line, pre) { // "void funcName(inParams,outParams)"
				oldLine := line
				line = strings.TrimPrefix(line, pre)
				line = strings.TrimLeft(line, " ")
				elems := strings.Split(line, "(")
				if len(elems) > 1 {
					funcMap[elems[0]] = oldLine
				}
				break
			}
		}
	}
	i := 1
	for k, v := range funcMap {
		fmt.Printf("[%d] key:%s value:%s\n", i, k, v)
		i++
	}
	fmt.Printf("funcName.size:%d\n", len(funcMap))
}
