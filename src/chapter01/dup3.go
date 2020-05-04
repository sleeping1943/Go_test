// 读取参数中的文件名，读取文件，记录重复行次数并打印
package main

import (
	"io/ioutil"
	"fmt"
	"os"
	"strings"
)

func main() {
	counts := make(map[string]int)	// <line,times>
	for _,file_name := range os.Args[1:] {
		data,err := ioutil.ReadFile(file_name)
		if err != nil {
			fmt.Fprintf(os.Stderr, "dup3:%v\n",err)
			continue
		}
		for _,line := range strings.Split(string(data), "\n") {
			counts[line]++
		}
	}
	for line,times := range counts {
		if times > 1 {
			fmt.Printf("%s occurs %d times\n", line, times)
		}
	}
}
