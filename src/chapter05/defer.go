/*
	1· defer指定的函数在其所在函数执行完后，倒序执行(类型析构函数)
	2· defer指定的语句在return改变返回值后执行，故可以在return后修改返回值
*/
package main

import (
	"fmt"
	"time"
)

func CalcUseTime(func_name string) func() {
	start := time.Now()
	return func () {
		fmt.Printf("%s use time:[%s]\n", func_name, time.Since(start))
	}
}

func test(secs int) {
	defer CalcUseTime("test")()
	fmt.Printf("sleep for [%d]secs\n", secs)
	time.Sleep(time.Duration(secs)*time.Second)
}

func ModifyName(name *string) {
	if *name == "sleeping" {
		*name = "benxx"
	}
}
func test2(name *string) (ret_string string){
	defer ModifyName(name)
	*name = "sleeping"
	return *name
}
func main() {
	//test(3)
	var name string="sleeping01"
	test2(&name)
	fmt.Printf("name:[%s]\n",name)
}