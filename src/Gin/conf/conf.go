package conf

import (
	"encoding/json"
	"fmt"
	"io/ioutil"
	"log"
)

// ConfInfo : 配置文件定义
type ConfInfo struct {
	IP   string `json:ip`
	Port int    `json:port`
}

var Conf ConfInfo

func init() {
	bytes, err := ioutil.ReadFile("./conf/conf.json")
	if err != nil {
		log.Fatal(err)
	}
	json.Unmarshal(bytes, &Conf)

	fmt.Printf("%s %v\n", string(bytes), Conf)
}
