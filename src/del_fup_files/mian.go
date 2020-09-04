package main

import (
	"bufio"
	"fmt"
	"log"
	"os"
	"strings"
)

// FileMap : 文件名，slice文件路径
var FileMap map[string][]string
var Index = 0

// ScanFolder : 扫描指定目录的重复文件
func ScanFolder(filePath string, index int) {
	fileInfo, err := os.Stat(filePath)
	if err != nil {
		log.Fatalf("os.Stat erro:%v\n", err)
	}
	fileName := fileInfo.Name()
	// 文件则直接打印退出
	if !fileInfo.IsDir() {
		fmt.Println(strings.Repeat(" ", index) + fileInfo.Name())
		FileMap[fileName] = append(FileMap[fileName], filePath)
		return
	}
	// 改名
	newName := strings.End
	//_, exist := FileMap[fileName]
	//if exist {
	//	FileMap[fileName] = append(FileMap[fileName], filePath)
	//} else {
	//	FileMap[fileName] = make([]string)
	//}

	FileMap[fileName] = append(FileMap[fileName], filePath)
	fileName = fmt.Sprintf("%s%s/%s", strings.Repeat("-", index), filePath, fileName)
	fmt.Println(fileName)
	file, err := os.Open(filePath)
	if err != nil {
		log.Fatalf("Open error:%v\n", err)
	}
	files, err := file.Readdir(0)
	if err != nil {
		log.Fatal("Readdir error:%v\n", err)
	}
	for _, fileInfo := range files {
		ScanFolder(filePath+"/"+fileInfo.Name(), index+1)
	}
}

func main() {
	scanner := bufio.NewScanner(os.Stdin)
	for {
		fmt.Println("please enter the folder path:")
		FileMap = make(map[string][]string)
		for scanner.Scan() {
			filePath := scanner.Text()
			if len(filePath) <= 0 {
				fmt.Println("the folder path you enter is error!!")
				break
			}
			filePath = strings.Replace(filePath, "\\", "/", -1)
			ScanFolder(string(filePath), 0)
			for key, value := range FileMap {
				if len(value) > 1 {
					fmt.Println(key)
					for _, path := range value {
						fmt.Println(path)
					}
				}
			}
			break
			//fmt.Printf("****************%v\n", FileMap)
		}
	}
}
