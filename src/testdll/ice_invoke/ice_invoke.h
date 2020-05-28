#pragma once

#include <string>
#ifndef DLL_API 
#define DLL_API _declspec(dllimport)
#endif

#ifdef __cplusplus
extern "C" {
#endif
    DLL_API const char* invoke(const char* ice_str, const char* func_name, const char* in_params);
    DLL_API void free_str(const char* pout_str);
#ifdef __cplusplus
}
#endif
