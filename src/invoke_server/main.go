package main

import (
	"fmt"
	"invoke_server/ice"
)

func main() {
	fmt.Println("invoke_server")
	service := ice.SaasService{}
	service.ParseIce(ice.SaasServicePath)
}
