#include <iostream>
#include <string>
#include <vector>
#include <memory>
#include <Ice/Ice.h>
#include <Ice/Object.h>
#include <Ice/Proxy.h>
#include <Ice/Communicator.h>
#include <Ice/InputStream.h>

#define DLL_API _declspec(dllexport)
#include "ice_invoke.h"

using std::string;
using std::cout;
using std::endl;

DLL_API const char* invoke(const char* ice_str, const char* func_name, const char* in_params)
{
    int argc = 1;
    char * argv[] = { "" };
    Ice::CommunicatorPtr ich;
    ich = Ice::initialize(argc, argv);
    //Ice::ObjectPrx base = ic->stringToProxy("SimplePrinter:tcp -p 10000");
    Ice::ObjectPrx proxy = ich->stringToProxy(ice_str);
    std::string pout_str;
    try
    {
        std::vector<Ice::Byte> inParams, outParams;
     
        Ice::OutputStream out(ich);
        out.startEncapsulation();
        out.write(std::string(in_params));
        out.endEncapsulation();
        out.finished(inParams);
 
        if(proxy->ice_invoke(func_name,Ice::OperationMode::Normal, inParams, outParams)) {
            // Handle success
            Ice::InputStream in(ich, outParams);
            in.startEncapsulation();
            in.read(pout_str);
            in.endEncapsulation();
        } 
    } catch(const Ice::LocalException& e) {
        pout_str = e.what();
        cout << "Ice::LocalException:" << pout_str;
    } catch (std::exception& e) {
        pout_str = e.what();
        cout << "exception:" << pout_str;
    }
    ich->destroy();
    int str_len = pout_str.size() + 1;
    char* content = new char[str_len];
    strcpy_s(content, str_len, pout_str.c_str());
    return content;
}

DLL_API void free_str(const char* content)
{
    if (content != nullptr) {
        delete []content;
        content = nullptr;
    }
}