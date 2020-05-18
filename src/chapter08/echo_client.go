package main

import (
	"bufio"
	"fmt"
	"io"
	"log"
	"net"
	"os"
	"strings"
)

func mustCopy(dst io.Writer, src io.Reader) {
	if _, err := io.Copy(dst, src); err != nil {
		log.Fatal(err)
	}
}

func main() {
	conn, err := net.Dial("tcp", "localhost:8000")
	if err != nil {
		log.Fatal(err)
	}
	defer conn.Close()
	go mustCopy(os.Stdout, conn)
	//mustCopy(conn, os.Stdin)
	input := bufio.NewScanner(os.Stdin)
	for input.Scan() {
		str := input.Text()
		if strings.ToLower(str) == "bye" ||
			strings.ToLower(str) == "byebye" {
			break
		}
		fmt.Fprintln(conn, str)
	}
	conn.Close()
}
