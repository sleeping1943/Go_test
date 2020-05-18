package main

import (
	"bufio"
	"fmt"
	"log"
	"net"
)

type client chan string

var (
	entering = make(chan client)
	message  = make(chan string)
	leave    = make(chan client)
)

// 广播消息
func boardcast() {
	clients := make(map[client]bool)
	fmt.Println(len(clients))
	for {
		select {
		// 新连接处理
		case cli := <-entering:
			clients[cli] = true
		// 新消息处理
		case msg := <-message:
			for client := range clients {
				client <- msg
			}
		// 客户端断链处理
		case cli := <-leave:
			delete(clients, cli)
			close(cli)
			fmt.Println("someone has left!!!")
			// 在select中给select已经监控的channel发送数据，貌似不接收，需要在琢磨一下
			//str := fmt.Sprintf("leave:%v\n", cli)
			//message <- str
		}
	}
	fmt.Print("boardcast end!")
}

// 处理新建的客户端连接
func handleClient(conn net.Conn) {
	ch := make(chan string)
	go func() {
		for msg := range ch {
			fmt.Fprintln(conn, msg)
		}
	}()
	who := conn.RemoteAddr().String()
	ch <- "You are " + who
	entering <- ch
	message <- fmt.Sprintf("%v has entering!!\n", ch)
	input := bufio.NewScanner(conn)
	for input.Scan() {
		str := input.Text()
		fmt.Printf("%s:%s\n", who, str)
		message <- str
	}
	fmt.Println("after input.Scan()!!!")
	leave <- ch
	message <- fmt.Sprintf("%v has left\n", ch)
	conn.Close()
}

func main() {
	listener, err := net.Listen("tcp", "localhost:8000")
	if err != nil {
		log.Fatal(err)
		return
	}

	go boardcast()
	for {
		conn, err := listener.Accept()
		if err != nil {
			log.Println(err)
			continue
		}
		go handleClient(conn)
	}
	fmt.Println("server will close()!!!")
}
