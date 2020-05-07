package main

import (
	"fmt"
)

type Student struct {
	name string
	age int
	grand int
}

func reverse(nums []int) {
	for i,j := 0, len(nums)-1; i < j; i,j = i+1, j-1 {
		nums[i],nums[j] = nums[j], nums[i]
	}
}
func main() {
	nums := []int {0,1,2,3,4,5}
	fmt.Printf("before:%v\n",nums)
	reverse(nums)
	fmt.Printf("after:%v\n",nums)
	m_info := map[string]int{
		"sleeping":19,
		"benxx":17,
	}
	fmt.Printf("len:%d\n",len(m_info))

	var sleeping Student
	p_slp := &sleeping
	sleeping.name = "sleeping"
	sleeping.age = 29
	fmt.Printf("name:%s age:%d\n",sleeping.name, sleeping.age)
	fmt.Printf("p_slp.name:%s p_slp.age:%d\n",p_slp.name, p_slp.age)
}