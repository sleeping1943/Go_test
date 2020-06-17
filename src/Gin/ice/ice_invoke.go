package ice

import (
	"log"
	"os"
	"path/filepath"
	"strings"
	"syscall"
	"unsafe"
)

var Dir string

func init() {
	dir, err := filepath.Abs(filepath.Dir(os.Args[0]))
	if err != nil {
		log.Fatal(err)
	}
	Dir = strings.Replace(dir, "\\", "/", -1)
	//fmt.Println("dir-----------------", dir)
}

// Invoke : 调用方法invoke(iceFlag, funcName, inParams)
func Invoke(iceFlag, funcName, inParams string) string {
	//var dllPath = fmt.Sprintf("%s/ice_invoke.dll", Dir)
	dllPath := "./ice_invoke.dll"
	hdll, err := syscall.LoadLibrary(dllPath)
	if err != nil {
		log.Fatal(err, ":", dllPath)
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
