package main

import (
	"bufio"
	"fmt"
	"os"
)

func main() {
	counts := make(map[string]int)	// <line,times>
	input := bufio.NewScanner(os.Stdin)
	for input.Scan() {
		counts[input.Text()]++
	}
	for line,times := range counts {
		if times > 1 {
			fmt.Printf("%s occurs %d times\n", line, times)
		}
	}
}
