package main

import (
	"fmt"
)

type Point struct {
	x int
	y int
}

func (p *Point) Distance() int {
	return p.x*p.x + p.y*p.y;
}

func (p Point) Show() string {
	return fmt.Sprintf("x:%d y:%d", p.x, p.y)
}

func main() {
	p := Point{x:3,y:4}
	fmt.Printf("Distance:%d\n", p.Distance())
	fmt.Println(p.Show())
}