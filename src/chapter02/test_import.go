package main

import (
	_ "chapter02/mycolor"
	"fmt"
	"time"
)

func main() {
	//fmt.Printf("black is %d", mycolor.Black)
	defer func() {
		time.Sleep(10 * time.Second)
		fmt.Println("10 secs:defer after main")
	}()
	fmt.Printf("black is %d\n", 2)
	return
}
