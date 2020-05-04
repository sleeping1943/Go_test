// 读取参数中的网址,获取内容并输出
package main

import (
	"io/ioutil"
	"net/http"
	"fmt"
	"os"
)

func main() {
	if len(os.Args) < 2 {
		fmt.Println("Useage:fetch <url>")
		return
	}
	for _,url := range os.Args[1:] {
		rep,err := http.Get(url)
		if err != nil {
			fmt.Fprintf(os.Stderr,"fetch:%v\n", err)
			continue
		}
		content,err := ioutil.ReadAll(rep.Body)
		rep.Body.Close()
		if err != nil {
			fmt.Fprintf(os.Stderr, "fetch:%v\n",err)
			continue
		}
		fmt.Printf("%s\n", content)
	}
}
