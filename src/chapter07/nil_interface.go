package main

import (
	"fmt"
	"bytes"
	"io"
)

const debug = false

func foo(out io.Writer) {
	if out != nil {
		out.Write([]byte("done!\n"))
	}
}

// debug为false时,buf指针是包含有动态类型的指针，不为nil详见《Go语言圣经》7.5.1
func test_pointer() {
	var buf *bytes.Buffer
	if debug {
		buf = new(bytes.Buffer)
	}
	foo(buf)
	if debug {
		fmt.Println("debug end!")
	}
}

// 使用interface来接收，就可以正确判断nil值，避免bug
func test_struct() {
	var buf io.Writer
	if debug {
		buf = new(bytes.Buffer)
	}
	foo(buf)
	if debug {
		fmt.Println("debug end!")
	}
}

func main() {
	fmt.Println("test_struct....")
	test_struct()
	fmt.Println("test_pointer...")
	test_pointer()
}