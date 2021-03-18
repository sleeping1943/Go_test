package ice

import (
	"Gin/conf"
	"bufio"
	"fmt"
	"html/template"
	"log"
	"os"
	"strings"
	"unicode"
)

// SaasBackendPath : backend端ice文件路径
var SaasBackendPath = "./ice/conf/SaasBackend.ice"

// SaasBackend : backend结构体
type SaasBackend struct {
	// FuncMap : <函数名, 函数参数说明>
	FuncMap map[string]string
}

// BackendFuncs : SaasBackend函数定义集合
var BackendFuncs = SaasBackend{FuncMap: make(map[string]string)}

func init() {
	fmt.Printf("init SaasBackendPath:[%s]\n", SaasBackendPath)
	BackendFuncs.ParseIce(SaasBackendPath)
	BackendFuncs.ParseParams(SaasBackendPath)
	//BackendFuncs.ReplaceAddr()
}

// ParseIce : 解析ice文件
func (s SaasBackend) ParseIce(path string) {
	fmt.Printf("SaasBackendPath:[%s]\n", path)
	fd, err := os.Open(SaasBackendPath)
	if err != nil {
		log.Fatal(err)
	}
	scanner := bufio.NewScanner(fd)
	for scanner.Scan() {
		line := scanner.Text()
		line = strings.TrimSpace(line)
		for _, pre := range Prefix {
			if strings.HasPrefix(line, pre) { // "void funcName(inParams,outParams)"
				line = strings.TrimPrefix(line, pre)
				line = strings.TrimLeft(line, " ")
				elems := strings.Split(line, "(")
				if len(elems) > 1 {
					s.FuncMap[strings.Trim(elems[0], " ")] = pre
				}
				break
			}
		}
	}
}

// ParseParams : 解析函数的对应参数
/*
	1· 先提取出每个函数对应的原始参数str
*/
func (s SaasBackend) ParseParams(path string) {
	fmt.Printf("SaasBackendPath:[%s]\n", path)
	fd, err := os.Open(SaasBackendPath)
	if err != nil {
		log.Fatal(err)
	}
	scanner := bufio.NewScanner(fd)

	var funcName = ""
	var originFuncParam []string
	var isParamStart = false
	var isFuncEnd = false
	for scanner.Scan() {
		line := scanner.Text()
		line = strings.TrimRight(line, " ")
		preStr := strings.TrimLeft(line, " ")
		// step 1
		// "example:"表示开始定义参数
		if preStr == "example:" {
			isParamStart = true
		}
		// 找到函数定义,则结束参数收集,并截取精确的函数名(避免DeleteUser和BatchDeleteUser这样的包含bug)
		for key := range s.FuncMap {
			if strings.Contains(line, key) {
				trimStr := strings.TrimLeft(line, " ")
				for _, pre := range Prefix {
					if strings.HasPrefix(trimStr, pre) { // "void funcName(inParams,outParams)"
						trimStr = strings.TrimPrefix(trimStr, pre)
						elems := strings.Split(trimStr, "(")
						if len(elems) > 1 {
							funcName = strings.Trim(elems[0], " ")
						}
						isFuncEnd = true
						isParamStart = false
						break
					}
				}
				break
			}
		}
		if isParamStart {
			originFuncParam = append(originFuncParam, line)
		}
		// step end 处理后清空该函数相关数据
		if isFuncEnd {
			var level = -1
			var funcParams []string
			var blankCount = 0
			for _, line := range originFuncParam {
				var pureStr = strings.TrimSpace(line)
				if strings.Contains(pureStr, "{") {
					if level == -1 {
						level = 0
						// 留白的字符count
						funcCheckBlank := func(c rune) bool {
							return !unicode.IsSpace(c)
						}
						blankCount = strings.IndexFunc(line, funcCheckBlank)
					}
					level++
				}
				if strings.Contains(pureStr, "}") { // 可能"{"和"}"在同一行
					level--
				}

				// 去除参数后面的注释
				if index := strings.Index(line, "选填"); index != -1 {
					line = line[0:index]
				}
				if index := strings.Index(line, "必填"); index != -1 {
					line = line[0:index]
				}
				line = strings.TrimRight(line, " ")
				// 去除前面的空格字符
				if blankCount >= 0 && len(line) > blankCount {
					line = line[blankCount:]
				}
				if level == 0 {
					funcParams = append(funcParams, line)
					break
				} else if level == -1 {
					continue
				}
				funcParams = append(funcParams, line)
			}
			var jsonStr = strings.Join(funcParams, "\n")
			if err != nil {
				fmt.Printf("%v\n", err)
			}
			s.FuncMap[funcName] = jsonStr
			funcName = ""
			isFuncEnd = false
			originFuncParam = originFuncParam[0:0]
			blankCount = 0
		}
	}
	fmt.Printf("funcName.size:%d\n", len(s.FuncMap))
}

// ReplaceAddr : 解析模板中的地址
func (s SaasBackend) ReplaceAddr() {
	fd, err := os.OpenFile("./static/backend.html", os.O_CREATE|os.O_TRUNC, 666)
	if err != nil {
		log.Fatal(err)
	}
	addr := fmt.Sprintf("%s:%d", conf.Conf.IP, conf.Conf.Port)
	temp := template.Must(template.ParseFiles("./static/backend.tpl"))
	temp.Execute(fd, addr)
	fd.Close()
}
