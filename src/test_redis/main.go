package main

import (
	"fmt"

	"github.com/go-redis/redis"
)

func main() {
	client := redis.NewClient(&redis.Options{
		Addr:     "127.0.0.1:6379",
		Password: "", // no password set
		DB:       0,  // use default DB
	})

	pong, err := client.Ping().Result()
	fmt.Println(pong, err)

	err = client.Set("name", "sleeping", 0).Err()
	if err != nil {
		panic(err)
	}

	val, err := client.Get("name").Result()
	if err != nil {
		panic(err)
	}
	fmt.Println("name", val)

	val2, err := client.Get("name2").Result()
	if err == redis.Nil {
		fmt.Println("name2 does not exists")
	} else if err != nil {
		panic(err)
	} else {
		fmt.Println("name2", val2)
	}
	info, err := client.HGetAll("slp:1").REsult()
	if err != nil {
		panic(err)
	} else {
		for key, val := range info {
			fmt.Printf("key:%s val:%s", key, val)
		}
	}
}
