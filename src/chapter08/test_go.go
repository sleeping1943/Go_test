package main

import (
	"fmt"
	"bufio"
	"os"
	"io"
	"log"
)

func handleIn() {
	scanner := bufio.NewScanner(os.Stdin)
	for scanner.Scan() {
		fmt.Println(scanner.Text())
	}
}

func mustCopy(dst io.Writer, src io.Reader) {
	if _,err := io.Copy(dst, src); err != nil {
		log.Fatal(err)
	}
}

func main() {
	fmt.Println("please enter:")
	//go handleIn()
	//fmt.Println("after go HandleIn!!!")
	//handleIn()
	mustCopy(os.Stdout, os.Stdin)
}