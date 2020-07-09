package main

import (
	"bytes"
	"crypto/aes"
	"crypto/cipher"
	"encoding/base64"
	"fmt"
)

func main() {
	text := "nzai123!@#"
	key := "jd43f@#fj@#$dyf5"
	iv := "fg$S$2464GFD%$D#"

	cipherTextBytes := EncryptByAESAndCBC(text, key, iv)
	encryptedStr := base64.StdEncoding.EncodeToString(cipherTextBytes)
	fmt.Printf("%s--->aes---->base64[%s]\n", text, encryptedStr)

	decryptedStr, err := base64.StdEncoding.DecodeString(encryptedStr)
	if err != nil {
		panic(err)
	}
	newText := DecryptByAESAndCBC(decryptedStr, key, iv)
	fmt.Printf("base64[%s]--->aes--->%s\n", encryptedStr, newText)
}

func DecryptByAESAndCBC(cipherText []byte, key, iv string) string {

	textBytes := cipherText
	keyBytes := []byte(key)
	ivBytes := []byte(iv)

	//1. 创建并返回一个使用AES算法的cipher.Block接口。
	block, err := aes.NewCipher(keyBytes)
	if err != nil {
		panic(err)
	}
	//2. 创建CBC分组模式
	blockMode := cipher.NewCBCDecrypter(block, ivBytes)
	//3. 解密
	blockMode.CryptBlocks(textBytes, textBytes)
	//4. 去掉填充数据 (注意去掉填充的顺序是在解密之后)
	plainText := MakeBlocksOrigin(textBytes)
	return string(plainText)
}

func EncryptByAESAndCBC(text string, key string, iv string) []byte {

	textBytes := []byte(text)
	keyBytes := []byte(key)
	ivBytes := []byte(iv)

	//加密
	//1. 创建并返回一个使用AES算法的cipher.Block接口
	//使用des调用NewCipher获取block接口
	block, err := aes.NewCipher(keyBytes)
	if err != nil {
		panic(err)
	}
	//2. 填充数据，将输入的明文构造成8的倍数
	textBytes = MakeBlocksFull(textBytes, 8)
	//3. 创建CBC分组模式,返回一个密码分组链接模式的、底层用b加密的BlockMode接口，初始向量iv的长度必须等于b的块尺寸
	//使用cipher调用NewCBCDecrypter获取blockMode接口
	blockMode := cipher.NewCBCEncrypter(block, ivBytes)
	//4. 加密
	//这里的两个参数为什么都是textBytes
	//第一个是目标,第二个是源
	//也就是说将第二个进行加密,然后放到第一个里面
	//如果我们重新定义一个密文cipherTextBytes
	//那么就是blockMode.CryptBlocks(cipherTextBytes, textBytes)
	blockMode.CryptBlocks(textBytes, textBytes)
	return textBytes

}

func MakeBlocksOrigin(src []byte) []byte {
	//1. 获取src长度
	length := len(src)
	//2. 得到最后一个字符
	lastChar := src[length-1] //'4'
	//3. 将字符转换为数字
	number := int(lastChar) //4
	//4. 截取需要的长度
	return src[:length-number]
}

func MakeBlocksFull(src []byte, blockSize int) []byte {
	//1. 获取src的长度， blockSize对于des是8
	length := len(src)
	//2. 对blockSize进行取余数， 4
	remains := length % blockSize
	//3. 获取要填的数量 = blockSize - 余数
	paddingNumber := blockSize - remains //4
	//4. 将填充的数字转换成字符， 4， '4'， 创建了只有一个字符的切片
	s1 := []byte{byte(paddingNumber)}
	//5. 创造一个有4个'4'的切片
	s2 := bytes.Repeat(s1, paddingNumber)
	//6. 将填充的切片追加到src后面
	s3 := append(src, s2...)
	return s3
}
