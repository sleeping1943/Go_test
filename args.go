package main

import (
	"fmt"
	"os"
	"strings"
) 

func main() {
	var s,sep string
	sep = " "
	for i:=1; i<len(os.Args); i++ {
		s += sep + os.Args[i]
	}
	fmt.Println(s)
	fmt.Println("exe:", os.Args[0])
	fmt.Println(strings.Join(os.Args[1:],"-"))
}
