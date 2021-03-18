/**
 * @file IceSaaSService.ice
 * @brief  The service interface of software as a service
 * @author ZhuMingsheng <mingsheng.zhu@nazhiai.com>
 * @company www.nazhiai.com
 * @version 1.0.0
 * @date 2019/10/15
 */
#pragma once


module Saas
{
    /**
     * @brief SaaS服务接口定义
     */
    interface ISaasService
    {
        /*----------------------------------------------------------------------
          用户账号管理
         ---------------------------------------------------------------------*/
        /**
         * @brief  Login 用户登录。
         * @since  2020/03/18
         * @update 2020/05/06 新增普通授权用户权限信息
         *
         * @param user 用户信息。
            example: 
            {
                "username": "jobs",     必填,string,登录名。
                "password": "md5"       必填,string,MD5加密的密码。
            }
         * @param result 成功或失败。例：
            成功 - 返回对应的结果
            {
                "code": 0,
                "info": {
                    "org_id": 1,            组织id
                    "user_id": 1,           用户id
                    "username": 1,          用户名
                    "type": 1,              用户类型,参见<UserType>
                    "state": 1,             状态
                    "mobile": "",           手机号
                    "sites": [              授权店铺列表
                        {
                            "site_id": 1,   店铺ID
                            "name": ""      店铺名称
                        },
                        ...
                    ],
                    "permission": ""        权限
                }
            }
            失败 - {"code": <非0>, "message": "错误说明", "visible": false}
        */
        void Login(string user, out string result);

        /**
         * @brief  AddUser 添加授权用户信息
         * @since  2020/05/06
         *
         * @param user 用户信息。
            example:
            {
                "mobile": "13300000001",必填,string,手机号码
                "name": "zhangsan",     选填,string,姓名
                "state": 1,             必填,int,用户状态
                "site_list": "",        必填,string,授权店铺,ALL表示所有店铺
                "permission": "",       选填,string,权限信息
                "org_id": 1,            必填,int,组织id
                "operator": "jobs",     必填,string,操作者，即当前登录的账号。
            }
         * @param result 成功或失败。例：
            成功 - {"code": 0}
            失败 - {"code": <非0>, "message": "错误说明", "visible": false}
        */
        void AddUser(string user, out string result);
    };
};
