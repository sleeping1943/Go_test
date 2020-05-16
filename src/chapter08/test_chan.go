/*
	测试多个goroutine执行，等待返回的情况
*/
package main

import (
	"fmt"
	"sync"
	"time"
)

func test() {

}
func main() {
	var count int = 5
	ch := make(chan int)
	wg := sync.WaitGroup{}
	for i := 1; i < count; i++ {
		wg.Add(1)
		go func(index int) {
			defer wg.Done()
			strDur := fmt.Sprintf("%ds", index)
			dur, _ := time.ParseDuration(strDur)
			time.Sleep(dur)
			ch <- index
			fmt.Printf("goroutine[%d] sleep [%d] seconds,then end!\n", index, index)
		}(i)
	}

	// 该等待/关闭操作必须在遍历ch之前以goroutine方式执行
	go func() {
		wg.Wait()
		close(ch)
		fmt.Println("have already close channel")
	}()

	for index := range ch {
		fmt.Printf("goroutine[%d] over!\n", index)
	}
}
