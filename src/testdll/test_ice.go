package main

import (
	"fmt"
	"log"
	"syscall"
	"unsafe"
)

const (
	iceFlag  = "SaasService:default -h 192.168.2.77 -p 20071"
	funcName = "Login"
	inParams = `
		{
			"username":"admin",
			"password" : "0192023a7bbd73250516f069df18b500"
		}
	`
)

func invoke(iceFlag, funcName, inParams string) string {
	hdll, err := syscall.LoadLibrary("./ice_invoke.dll")
	if err != nil {
		log.Fatal(err)
	}

	defer syscall.FreeLibrary(hdll)
	invoke, err := syscall.GetProcAddress(hdll, "invoke")
	if err != nil {
		log.Fatal(err)
		return ""
	}
	freeStr, err := syscall.GetProcAddress(hdll, "free_str")
	if err != nil {
		log.Fatal(err)
		return ""
	}
	var nargs uintptr = 3
	ret, _, _ := syscall.Syscall(uintptr(invoke),
		nargs,
		uintptr(unsafe.Pointer(syscall.StringBytePtr(iceFlag))),
		uintptr(unsafe.Pointer(syscall.StringBytePtr(funcName))),
		uintptr(unsafe.Pointer(syscall.StringBytePtr(inParams))))

	// 获取C返回的指针。
	// 注意C返回的r为char*，对应的Go类型为*byte
	retStr := ret
	p := (*byte)(unsafe.Pointer(retStr))
	// 定义一个[]byte切片，用来存储C返回的字符串
	data := make([]byte, 0)
	// 遍历C返回的char指针，直到 '\0' 为止
	for *p != 0 {
		data = append(data, *p)             // 将得到的byte追加到末尾
		retStr += unsafe.Sizeof(byte(0))    // 移动指针，指向下一个char
		p = (*byte)(unsafe.Pointer(retStr)) // 获取指针的值，此时指针已经指向下一个char
	}
	name := string(data) // 将data转换为字符串
	//fmt.Printf("name:%s--\n", name)
	nargs = 1
	// freeStr:回收C内存
	syscall.Syscall(uintptr(freeStr),
		nargs,
		uintptr(ret),
		0,
		0)
	return name
}

func main() {
	for i := 0; i < 10; i++ {
		fmt.Printf("invoke:[%s]\n", invoke(iceFlag, funcName, inParams))
	}
}
