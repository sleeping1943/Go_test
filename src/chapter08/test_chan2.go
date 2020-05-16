/*
	测试goroutine执行，等待返回的情况
*/
package main

import (
	"fmt"
	"time"
)

func main() {
	ch := make(chan int)
	go func() {
		time.Sleep(time.Duration(3 * time.Second))
		ch <- 4
	}()

	fmt.Println("wait for reacive ch")
	<-ch
}
