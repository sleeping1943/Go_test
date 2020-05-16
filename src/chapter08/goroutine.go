package main

import (
	"fmt"
	"os"
	"time"
)

func foo(delay int, done chan string) {
	for i := 0; i < delay; i++ {
		time.Sleep(time.Duration(1 * time.Second))
		fmt.Fprintf(os.Stdout, "sleep %d seconds\n", i+1)
	}
	endStr := fmt.Sprintf("I have sleep for %d seconds!!!\n", delay)
	done <- endStr
}

func main() {
	fmt.Println("begin goroutine...")
	done := make(chan string)
	delaySecs := 3
	go foo(delaySecs, done)
	fmt.Println("wait for gouroutine end....")
	endStr := <-done
	fmt.Fprintf(os.Stdout, "The string returned from goroutine is:%s", endStr)
}
