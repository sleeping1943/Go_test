package main

import (
	"fmt"
	"time"
)

func main() {
	var delayCount int = 10 // 倒计时10秒
	ch := make(chan struct{})
	go func(count int) {
		for count > 0 {
			time.Sleep(1 * time.Second)
			fmt.Printf("%d seconds left!!!", count)
			count--
		}
		ch <- struct{}{}
	}(delayCount)
}
