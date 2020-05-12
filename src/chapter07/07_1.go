package main

import (
	"fmt"
	"strings"
)

// 接口定义
type Read interface {
	Read(p []string) string
	Read2(p []string, dem string) string
}

// Reader类型实现Read接口,可以不实现Read的全部接口
type Reader struct {

}

func (r *Reader) Read (p []string) string {
	return strings.Join(p, "-")
}

func Show(r Reader, vec []string) {
	fmt.Println(r.Read(vec))
}

func main() {
	reader := Reader{}
	p := []string{
		"name",
		"age",
	}
	Show(reader, p)
}