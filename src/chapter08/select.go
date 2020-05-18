package main

import (
	"fmt"
	"os"
	"time"
)

func main() {
	abort := make(chan struct{})
	tick := time.Tick(time.Second)
	fmt.Println("按任意字符退出...")
	// 退出
	go func() {
		os.Stdin.Read(make([]byte, 1))
		abort <- struct{}{}
	}()

Loop:
	for {
		select {
		case <-abort:
			fmt.Println("send rocket immediately!!!")
			break Loop
		case theTime := <-tick:
			fmt.Printf("tick[%s]...!!!\n", theTime.String())
		default:
		}
	}
	fmt.Println("end!!!")
}
