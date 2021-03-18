#include <iostream>
#include <string>
#include "ice_invoke.h"

using std::cout;
using std::endl;

int main(int argc, char** argv)
{
    for (int i = 0; i < 10; i++) {

        std::string ice_str = "SaasService:default -h 192.168.2.77 -p 20071";
        std::string func_name = "Login";
        std::string in_params = "{ \
            \"username\":\"admin\",\
            \"password\" : \"0192023a7bbd73250516f069df18b500\"\
            }";
        const char* pout_str = invoke(ice_str.c_str(), func_name.c_str(), in_params.c_str());
        cout << "out_params:" << std::string(pout_str) << endl;
        free_str(pout_str);
    }
    system("pause");
    return 0;
}