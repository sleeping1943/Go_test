package main

import (
	"fmt"
	"time"
)

func fib(i int) int {
	if i < 2 {
		return i
	}
	return fib(i-1) + fib(i-2)
}

func snipper(delay time.Duration) {
	for {
		for _, char := range `-\|/` {
			fmt.Printf("\r%c", char)
			time.Sleep(delay)
		}
	}
}

func main() {
	go snipper(100 * time.Millisecond)
	const fib_count = 45
	fibN := fib(fib_count)
	fmt.Printf("fib:%d\n", fibN)
}
