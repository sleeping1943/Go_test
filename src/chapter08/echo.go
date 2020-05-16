package main

import (
	"fmt"
	"net"
	"bufio"
	"log"
	"time"
	"strings"
)

func echo(c net.Conn, shut string, delay time.Duration) {
	fmt.Println(shut)
	fmt.Fprintln(c, "\t", strings.ToUpper(shut))
	time.Sleep(delay)
	fmt.Fprintln(c, "\t", shut)
	time.Sleep(delay)
	fmt.Fprintln(c, "\t", strings.ToLower(shut))
}
func handleConn(c net.Conn) {
	input := bufio.NewScanner(c)
	defer c.Close()
	for input.Scan() {
		echo(c, input.Text(), 1*time.Second)
	}
}
func main() {
	listener, err := net.Listen("tcp","localhost:8000")
	if err != nil {
		log.Fatal(err)
		return
	}
	for {
		conn, err := listener.Accept()
		if err != nil {
			log.Print(err)
			continue
		}
		go handleConn(conn)
	}
}