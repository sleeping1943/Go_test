package ice

import "fmt"

var SaasBackendPath = "./ice/conf/SaasBackend.ice"

type SaasBackend struct{}

func init() {
	fmt.Printf("init SaasBackendPath:[%s]\n", SaasBackendPath)
}

func (s SaasBackend) ParseIce(path string) {
	fmt.Printf("SaasBackendPath:[%s]\n", path)
}
