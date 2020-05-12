/*
 自定义接口排序
 需实现3个接口
	func Len()int
	func Less(i, j int) bool
	func Swap(i, j int)
*/
package main

import (
	"fmt"
	"sort"
)

type Movie struct {
	name string
	year int
	length string
}

type Movies []Movie

func (m Movies) Len() int {
	return len(m);
}

func (m Movies) Less(i, j int) bool {
	return m[i].name < m[j].name;
}

func (m Movies) Swap(i, j int) {
	m[i],m[j] = m[j],m[i]
}
/*
func (m *Movies) Len() int {
	return len(*m);
}

func (m *Movies) Less(i, j int) bool {
	return (*m)[i].name < (*m)[j].name;
}

func (m *Movies) Swap(i, j int) {
	(*m)[i],(*m)[j] = (*m)[j],(*m)[i]
}
*/
func main() {
	movies := Movies {
		{name:"ccc", year:1994, length:"4m13s"},
		{name:"zzz", year:1993, length:"3m56s"},
		{name:"aaa", year:2000, length:"3m51s"},
	}
	fmt.Printf("before:%v\n", movies)
	sort.Sort(movies)
	fmt.Printf("after:%v\n", movies)
}