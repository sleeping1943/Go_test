// 读取参数中的文件名，读取文件，记录重复行次数并打印
package main

import (
	"bufio"
	"fmt"
	"os"
)

func countlines(f *os.File, counts map[string]int) {
	input := bufio.NewScanner(f)
	for input.Scan() {
		counts[input.Text()]++
	}
}

func main() {
	for _,file_name := range os.Args[1:] {
		file,err := os.Open(file_name)
		if err != nil {
			fmt.Fprintf(os.Stderr, "dup2:%v\n",err)
			continue
		}
		counts := make(map[string]int)	// <line,times>
		countlines(file, counts)
		file.Close()
		for line,times := range counts {
			if times > 1 {
				fmt.Printf("%s:%s occurs %d times\n", file_name, line, times)
			}
		}
	}
}
