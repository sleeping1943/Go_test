package sln

import (
	"encoding/json"
	"fmt"
	"io/ioutil"
	"log"
)

// 编译单个项目命令:
// 	devenv.com .\NiseSaaS.sln /ReBuild "Release|x64" /Project Soms
// Sln : 单个工程信息
type Sln struct {
	Name string `json:"name"`
	Path string `json:"path"`
}

// ReleaseConfig : 工程配置
type ReleaseConfig struct {
	Slns []Sln `json`
}

// ProjectComplier : 编译工程的一些操作
type ProjectComplier struct {
}

// SlnConfig : 工程配置
var SlnConfig ReleaseConfig

func init() {
	//dir, err := filepath.Abs(filepath.Dir(os.Args[0]))
	//if err != nil {
	//	log.Fatal(err)
	//}
	//dir = strings.Replace(dir, "\\", "/", -1)
	//dir = fmt.Sprintf("%s/conf/release.json", dir)
	dir := "./conf/release.json"
	content, err := ioutil.ReadFile(dir)
	if err != nil {
		log.Fatal(err)
	}
	json.Unmarshal([]byte(content), &SlnConfig)
	fmt.Printf("json:%v\n", SlnConfig)
}
