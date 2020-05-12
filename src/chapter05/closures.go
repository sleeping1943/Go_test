package main

import (
	"fmt"
)

/*
	错误的闭包，dir为最后一次的值，因为dir内存地址一样,每次循环只是修改dir的值
*/
func err_closures(dirs []string, funcs []func(string)) {
	for _,dir := range dirs {
		funcs = append(funcs, func (pre string) {
			fmt.Printf("%s---%s\n",pre, dir)
		})
	}

	for _,the_func := range funcs {
		the_func("sleeping says:")
	}
}

/*
	正确的闭包,每次用新的变量接收dir，每次临时dir的内存地址不一样，所以每次调用结果不一样
*/
func right_closures(dirs []string, funcs []func(string)) {
	for _,dir := range dirs {
		temp_dir := dir
		funcs = append(funcs, func (pre string) {
			fmt.Printf("%s---%s\n",pre, temp_dir)
		})
	}

	for _,the_func := range funcs {
		the_func("sleeping says:")
	}
}

func main() {
	var dirs = []string{
		"./dir1",
		"./dir2",
		"./dir3",
	}
	var funcs []func(string)
	fmt.Println("错误的closures示例:")
	err_closures(dirs, funcs)
	// 清空funcs
	funcs = funcs[0:0]
	fmt.Println("正确的closures示例:")
	right_closures(dirs, funcs)

	var a int = 99
	var ret int= func(a int) int {
		a++
		return a
	}(a)
	fmt.Printf("a=%d a++=%d\n", a, ret)
}