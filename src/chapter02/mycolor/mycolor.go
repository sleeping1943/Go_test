package mycolor

import "fmt"

const (
	White = 0
	Black = 1
)

func init() {
	fmt.Println("mycolor init01")
}

func init() {
	fmt.Println("mycolor init02")
}

func foo() int { return White }
