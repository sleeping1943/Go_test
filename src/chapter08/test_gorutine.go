package main

import (
	"fmt"
	"sync"
	"time"
)

func main() {
	ch := make(chan string)
	wg := sync.WaitGroup{}

	for i := 0; i < 5; i++ {
		wg.Add(1)
		go func(index int) {
			defer wg.Done()
			time.Sleep(3 * time.Second)
			fmt.Printf("goruotine[%d] wake up\n", index)
			ch <- fmt.Sprintf("goroutine[%d] wake up after [%d] second\n", index, 3)
		}(i)
	}

	go func() {
		wg.Wait()
		close(ch)
	}()

	fmt.Println("begin for chan range")
	for retStr := range ch {
		fmt.Println(retStr)
	}
	//fmt.Println("ready to close ch")
	//close(ch)
	//fmt.Println("have closed the channel[ch]")
}
