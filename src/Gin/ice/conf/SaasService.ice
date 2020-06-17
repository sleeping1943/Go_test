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

        /**
         * @brief  UpdateUser 更新授权用户信息
         * @since  2020/05/06
         *
         * @param user 用户信息。
            example:
            {
                "user_id": 0,           必填,int,用户ID
                "name": "zhangsan",     选填,string,姓名
                "state": 1,             选填,int,用户状态
                "site_list": "",        必填,string,授权店铺,ALL表示所有店铺
                "permission": "",       选填,string,权限信息
                "org_id": 1,            必填,int,组织id
                "operator": "jobs",     必填,string,操作者，即当前登录的账号。
            }
         * @param result 成功或失败。例：
            成功 - {"code": 0}
            失败 - {"code": <非0>, "message": "错误说明", "visible": false}
        */
        void UpdateUser(string user, out string result);

         /**
         * @brief  DeleteUser 删除授权用户信息
         * @since  2020/05/06
         *
         * @param user 用户信息。
            example:
            {
                "user_id": 0,           必填,int,用户ID
                "org_id": 1,            必填,int,组织id
                "operator": "jobs",     必填,string,操作者，即当前登录的账号。
            }
         * @param result 成功或失败。例：
            成功 - {"code": 0}
            失败 - {"code": <非0>, "message": "错误说明", "visible": false}
         */
         void DeleteUser(string user, out string result);

        /**
         * @brief  QueryUserList 查询授权用户列表
         * @since  2020/05/06
         * @update 2020/05/12
         *
         * @param cond 查询条件。
            example:
            {
                "page_no": 1,           必填,int,页号
                "page_size": 10,        必填,int,每页个数
                "org_id": 1,            必填,int,组织id
                "operator": "jobs",     必填,string,操作者
                "query_cond": {
                    "name": "xx",       选填,string,地点名称，支持模糊匹配
                    "mobile": "",       选填,string,手机号
                }
            }
         * @param result 成功或失败。例：
            成功 - 返回对应的结果
            {
                "code": 0,
                "info": {
                    "page_no": 1,
                    "page_size": 10,
                    "total_count": 32,
                    "items": [
                        {
                            "user_id": 0,               int,用户ID
                            "username": 1,              string,用户名
                            "name": "zhangsan",         string,姓名
                            "state": 1,                 int,用户状态
                            "mobile": "13300000001",    string,手机号码
                            "email": "x",               string,邮箱
                            "site_list": "",            string,关联店铺id列表,ALL表示所有店铺
                            "permission": "",           string,权限信息
                        },...
                    ]
                }
            }
            失败 - {"code": <非0>, "message": "错误说明", "visible": false}
        */
        void QueryUserList(string cond, out string result);
        
        /**
         * @brief  ChangePassword 修改密码
         * @since  2020/06/03
         *
         * @param cond 修改信息。
            example:
            {
                "user_id": 0,           必填,int,用户ID
                "password": "x",        必填,string,新密码,MD5加密的密码。
                "old_password": "x",    必填,string,原密码,MD5加密的密码。
                "operator": "jobs",     必填,string,操作者，即当前登录的账号。
            }
         * @param result 成功或失败。例：
            成功 - {"code": 0}
            失败 - {"code": <非0>, "message": "错误说明", "visible": false}
        */
        void ChangePassword(string cond, out string result);

        /**
         * @brief  ResetPassword 重置密码
         * @since  2020/05/12
         *
         * @param cond 重置信息。
            example:
            {
                "user_id": 0,           必填,int,用户ID
                "password": "x",        必填,string,新密码,MD5加密的密码。
                "operator": "jobs",     必填,string,操作者，即当前登录的账号。
            }
         * @param result 成功或失败。例：
            成功 - {"code": 0}
            失败 - {"code": <非0>, "message": "错误说明", "visible": false}
        */
        void ResetPassword(string cond, out string result);

        /**
         * @brief  ResetEmail 重置邮箱
         * @since  2020/05/12
         *
         * @param cond 重置信息。
            example:
            {
                "user_id": 0,           必填,int,用户ID
                "password":"x",         必填,string,MD5加密的密码。
                "email": "x",           必填,string,新邮箱
                "operator": "jobs",     必填,string,操作者，即当前登录的账号。
            }
         * @param result 成功或失败。例：
            成功 - {"code": 0}
            失败 - {"code": <非0>, "message": "错误说明", "visible": false}
        */
        void ResetEmail(string cond, out string result);

        /*----------------------------------------------------------------------
          组织地点管理
         ---------------------------------------------------------------------*/
        /**
         * @brief  AddSite 添加组织地点
         * @since  2020/03/18
         *
         * @param site 地点信息。
            example:
            {
                "name": "nise",             必填,string,地点名称，只能由字母和数字组成
                "abbreviate": "nise",       选填,string,地点简称
                "province": 100000,         选填,int,省级代码
                "city": 100100,             选填,int,市级代码
                "region": 100101,           选填,int,区级代码
                "address": "",              选填,string,详细地址
                "industry": 1,              选填,int,所属行业
                "staff_size": 1,            选填,int,人员规模，1：20人以下，2：21人~50人，3：51人~200人，4：201人~500人，5:500人以上
                "flow_scale": 1,            选填,int,客流规模，1：200人以下，2：201人~500人，3：501人~2000人，4：2001人~5000人，5:5000人以上
                "leader": "Li",             必填,string,负责人
                "phone": "023-78455000",    必填,string,负责人电话
                "org_id": 1,                必填,int,组织id
                "operator": "jobs",         必填,string,操作者，即当前登录的账号。
            }
         * @param result 成功或失败。例：
            成功 - {"code": 0, "info": {"site_id": 1}}
            失败 - {"code": <非0>, "message": "错误说明", "visible": false}
        */
        void AddSite(string site, out string result);

        /**
         * @brief  UpdateSite 更新组织地点信息
         * @since  2020/03/18
         *
         * @param site 地点信息。
            example:
            {
                "site_id": 1,               必填,int,地点ID
                "name": "nise",             选填,string,名称
                "abbreviate": "nise",       选填,string,简称
                "province": 100000,         选填,int,省级代码
                "city": 100100,             选填,int,市级代码
                "region": 100101,           选填,int,区级代码
                "address": "",              选填,string,详细地址
                "industry": 1,              选填,int,所属行业
                "staff_size": 1,            选填,int,人员规模，1：20人以下，2：21人~50人，3：51人~200人，4：201人~500人，5:500人以上
                "flow_scale": 1,            选填,int,客流规模，1：200人以下，2：201人~500人，3：501人~2000人，4：2001人~5000人，5:5000人以上
                "leader": "Li",             必填,string,负责人
                "phone": "023-78455000",    必填,string,负责人电话
                "org_id": 1,                必填,int,组织id
                "operator": "jobs",         必填,string,操作者，即当前登录的账号。
            }
         * @param result 成功或失败。例：
            成功 - {"code": 0}
            失败 - {"code": <非0>, "message": "错误说明", "visible": false}
        */
        void UpdateSite(string site, out string result);

         /**
         * @brief  GetSiteInfo 获取组织地点信息
         * @since  2020/03/18
         *
         * @param cond 查询条件。
            example:
            {
                "site_id": 1,           必填,int,地点ID
                "org_id": 1,            必填,int,组织id
                "operator": "jobs",     必填,string,操作者
            }
         * @param result 成功或失败。例：
            成功 - 返回对应的结果
            {
                "code": 0,
                "info": {
                    "site_id": 1,               // int,地点ID
                    "name": "nise",             // string,地点名称，只能由字母和数字组成
                    "abbreviate": "nise",       // string,简称
                    "province": 100000,         // int,省级代码
                    "city": 100100,             // int,市级代码
                    "region": 100101,           // int,区级代码
                    "address": "",              // string,详细地址
                    "full_address": "",         // string,完整路径
                    "industry": 1,              // int,所属行业
                    "staff_size": 1,            // int,人员规模，1：20人以下，2：21人~50人，3：51人~200人，4：201人~500人，5:500人以上
                    "flow_scale": 1,            // int,客流规模，1：200人以下，2：201人~500人，3：501人~2000人，4：2001人~5000人，5:5000人以上
                    "leader": "Li",             // string,负责人
                    "phone": "023-78455000",    // string,负责人电话
                    "resource": {
                        "camera_count": 0,      // int,摄像头数量
                    }
                }
            }
            失败 - {"code": <非0>, "message": "错误说明", "visible": false}
        */
        void GetSiteInfo(string cond, out string result);

         /**
         * @brief  QuerySiteList 查询用户组织地点列表
         * @since  2020/03/18
         *
         * @param cond 查询条件。
            example:
            {
                "page_no": 1,           必填,int,页号
                "page_size": 10,        必填,int,每页个数
                "org_id": 1,            必填,int,组织id
                "operator": "jobs",     必填,string,操作者
                "query_cond": {
                    "name": "xx",       选填,string,地点名称，支持模糊匹配
                }
            }
         * @param result 成功或失败。例：
            成功 - 返回对应的结果
            {
                "code": 0,
                "info": {
                    "page_no": 1,
                    "page_size": 10,
                    "total_count": 32,
                    "items": [
                        {
                            "site_id": 1,               // int,地点ID
                            "name": "nise",             // string,地点名称，只能由字母和数字组成
                            "abbreviate": "nise",       // string,简称
                            "province": 100000,         // int,省级代码
                            "city": 100100,             // int,市级代码
                            "region": 100101,           // int,区级代码
                            "address": "",              // string,详细地址
                            "full_address": "",         // string,完整路径
                            "industry": 1,              // int,所属行业
                            "staff_size": 1,            // int,人员规模，1：20人以下，2：21人~50人，3：51人~200人，4：201人~500人，5:500人以上
                            "flow_scale": 1,            // int,客流规模，1：200人以下，2：201人~500人，3：501人~2000人，4：2001人~5000人，5:5000人以上
                            "leader": "Li",             // string,负责人
                            "phone": "023-78455000",    // string,负责人电话
                            "resource": {
                                "camera_count": 0,      // int,摄像头数量
                            }
                        }, ...
                    ]
                }
            }
            失败 - {"code": <非0>, "message": "错误说明", "visible": false}
        */
        void QuerySiteList(string cond, out string result);


        /*----------------------------------------------------------------------
         * 以下接口皆是针对组织地点业务管理
         *--------------------------------------------------------------------*/

        /*----------------------------------------------------------------------
          人员底库管理
         ---------------------------------------------------------------------*/
        /**
         * @brief  AddLibrary 添加人员底库
         * @since  2020/03/18
         *
         * @param library 底库信息。
            example:
            {
                "name": "xx",           必填,string,底库名称
                "type": 1,              必填,int,底库人员类型，参见《PeopleType》
                "site_list": "1,2",     必填,string,关联店铺id列表,ALL表示所有店铺
                "remark": "xx",         选填,string,备注
                "org_id": 1,            必填,int,组织id
                "operator": "jobs",     必填,string,操作者，即当前登录的账号。
            }
         * @param result 成功或失败。例：
            成功 - {"code": 0, "info": {"lib_id": 1}}
            失败 - {"code": <非0>, "message": "错误说明", "visible": false}
         */
         void AddLibrary(string library, out string result);

        /**
         * @brief  UpdateLibrary 修改人员底库信息
         * @since  2020/03/18
         *
         * @param library 底库信息。
            example:
            {
                "lib_id": 1,            必填,int,底库id
                "name": "xx",           必填,string,底库名称
                "site_list": "1,2",     必填,string,关联店铺id列表,ALL表示所有店铺
                "remark": "xx",         选填,string,备注
                "org_id": 1,            必填,int,组织id
                "operator": "jobs",     必填,string,操作者，即当前登录的账号。
            }
         * @param result 成功或失败。例：
            成功 - {"code": 0, "info": {"lib_id": 1}}
            失败 - {"code": <非0>, "message": "错误说明", "visible": false}
         */
         void UpdateLibrary(string library, out string result);

         /**
         * @brief  DeleteLibrary 删除人员底库
         * @since  2020/03/18
         *
         * @param library 底库信息。
            example:
            {
                "lib_id": 1,            必填,int,底库ID
                "org_id": 1,            必填,int,组织id
                "operator": "jobs",     必填,string,操作者，即当前登录的账号。
            }
         * @param result 成功或失败。例：
            成功 - {"code": 0}
            失败 - {"code": <非0>, "message": "错误说明", "visible": false}
         */
         void DeleteLibrary(string library, out string result);

        /**
         * @brief  QueryLibraryList 查询底库列表
         * @since  2020/03/18
         *
         * @param cond 查询条件。
            example:
            {
                "page_no": 1,           必填,int,页号
                "page_size": 10,        必填,int,每页个数
                "org_id": 1,            必填,int,组织id
                "operator": "jobs",     必填,string,操作者
                "query_cond": {
                    "name": "xx",       选填,string,底库名称，支持模糊匹配
                }
            }
         * @param result 成功或失败。例：
            成功 - 返回对应的结果
            {
                "code": 0,
                "info": {
                    "page_no": 1,
                    "page_size": 10,
                    "total_count": 32,
                    "items": [
                        {
                            "lib_id": 1,        // 底库ID
                            "name": "xx",       // 底库名称
                            "type": 1,          // 底库人员类型
                            "site_list": "1,2", // 关联店铺id列表,ALL表示所有店铺
                            "number": 100,      // 人数
                            "remark": "xx",     // 备注
                            "create_time": "2019-10-20 08:12:12"
                        }, ...
                    ]
                }
            }
            失败 - {"code": <非0>, "message": "错误说明", "visible": false}
        */
        void QueryLibraryList(string cond, out string result);

         /**
         * @brief  BatchSetLibraryBlackWhiteList 批量底库人员黑白名单
         * @since  2020/03/18
         *
         * @param library 底库信息。
            example:
            {
                "lib_list": "1,2",      必填,string,底库ID列表
                "group": 1,             必填,int,黑白名单类型，参见《BlackWhiteList》
                "org_id": 1,            必填,int,组织id
                "operator": "jobs",     必填,string,操作者，即当前登录的账号。
            }
         * @param result 成功或失败。例：
            成功 - {"code": 0}
            失败 - {"code": <非0>, "message": "错误说明", "visible": false}
         */
         void BatchSetLibraryBlackWhiteList(string library, out string result);


        /*----------------------------------------------------------------------
          人员管理
         ---------------------------------------------------------------------*/
         /**
         * @brief  AddPeople 添加人员信息
         * @since  2020/03/18
         * @update 2020/04/08 增加年龄字段
         *
         * @param people 人员信息。
            example:
            {
                "lib_id": 1,            必填,int,底库ID
                "name": "xx",           必填,string,姓名
                "sex": 1,               选填,int,性别，参见《SexType》
                "age": 30,              选填,int,年龄
                "credential_no": "",    选填,string,证件号
                "group": 1,             选填,int,黑白名单类型，参见《BlackWhiteList》
                "birthday": "",         选填,string,出生日期
                "mobile": "13900000000",选填,string,手机号
                "email": "xx@xx.com",   选填,string,邮箱
                "company": "",          选填,string,所在单位
                "position": "",         选填,string,职位
                "effective": "",        选填,string,有效时间-开始时间（生效）
                "expire": "",           选填,string,有效时间-结束时间（到期）
                "speech": "xx",         选填,string,迎宾语
                "photo_list": [""],     必填,json,照片路径列表，第一张照片为默认显示照片
                "property": {},         必填,json,人员类型
                "org_id": 1,            必填,int,组织id
                "operator": "jobs",     必填,string,操作者，即当前登录的账号。
            }
            字段定义
            for property
            1. 员工
            {
                "rule_id": 1,       必填,int,考勤规则id
                "empno": 1,         选填,int,员工工号
                "hiredate": "xx"    选填,string,入职时间
            }
            2. VIP
            {
                "level": "",        选填,string,VIP等级
                "expire_date": ""   选填,string,到期时间
            }
         * @param result 成功或失败。例：
            成功 - {"code": 0, "info": {"people_id": 1}}
            失败 - {"code": <非0>, "message": "错误说明", "visible": false}
         */
         void AddPeople(string people, out string result);

         /**
         * @brief  UpdatePeople 更新人员信息
         * @since  2020/03/18
         * @update 2020/04/08 增加年龄字段
         *
         * @param people 人员信息。
            example:
            {
                "people_id": 1,         必填,int,人员ID
                "name": "xx",           必填,string,姓名
                "sex": 1,               选填,int,性别，参见《SexType》
                "age": 30,              选填,int,年龄
                "credential_no": "",    选填,string,证件号
                "group": 1,             选填,int,黑白名单类型，参见《BlackWhiteList》
                "birthday": "",         选填,string,出生日期
                "mobile": "13900000000",选填,string,手机号
                "email": "xx@xx.com",   选填,string,邮箱
                "company": "",          选填,string,所在单位
                "position": "",         选填,string,职位
                "effective": "",        选填,string,有效时间-开始时间（生效）
                "expire": "",           选填,string,有效时间-结束时间（到期）
                "speech": "xx",         选填,string,迎宾语
                "photo_list": [""],     必填,json,照片路径列表，第一张照片为默认显示照片
                "property": {},         选填,json,人员类型
                "org_id": 1,            必填,int,组织id
                "operator": "jobs",     必填,string,操作者，即当前登录的账号。
            }
            字段定义
            for property
            1. 员工
            {
                "rule_id": 1,        必填,int,考勤规则id
                "empno": 1,         选填,int,员工工号
                "hiredate": "xx"    选填,string,入职时间
            }
            2. VIP
            {
                "level": "",        选填,string,VIP等级
                "expire_date": ""   选填,string,到期时间
            }
         * @param result 成功或失败。例：
            成功 - {"code": 0}
            失败 - {"code": <非0>, "message": "错误说明", "visible": false}
         */
         void UpdatePeople(string people, out string result);

         /**
         * @brief  DeletePeople 删除人员信息
         * @since  2020/03/18
         *
         * @param people 人员信息。
            example:
            {
                "people_id": 1,         必填,int,人员ID
                "org_id": 1,            必填,int,组织id
                "operator": "jobs",     必填,string,操作者，即当前登录的账号。
            }
         * @param result 成功或失败。例：
            成功 - {"code": 0}
            失败 - {"code": <非0>, "message": "错误说明", "visible": false}
         */
         void DeletePeople(string people, out string result);

         /**
         * @brief  BatchDeletePeople 批量删除人员信息
         * @since  2020/03/18
         *
         * @param people 人员信息。
            example:
            {
                "lib_id": 1,            必填,int,底库ID
                "people_list": "1,2",   必填,string,人员ID列表
                "org_id": 1,            必填,int,组织id
                "operator": "jobs",     必填,string,操作者，即当前登录的账号。
            }
         * @param result 成功或失败。例：
            成功 - {"code": 0}
            失败 - {"code": <非0>, "message": "错误说明", "visible": false}
         */
         void BatchDeletePeople(string people, out string result);

        /**
         * @brief  GetPeopleInfo 获取详细人员信息
         * @since  2019/10/15
         * @update 2020/04/08 增加年龄字段，修改查询条件
         *
         * @param cond 查询条件。
            example:
            {
                "people_id": 1,         必填,int,人员ID
                "org_id": 1,            必填,int,组织id
                "operator": "jobs",     必填,string,操作者，即当前登录的账号。
            }
         * @param result 成功或失败。例：
            成功 - 返回对应的结果
            {
                "code": 0,
                "info": {
                    "people_id": 1,     // 人员ID
                    "name": "xx",       // 姓名
                    "sex": 1,           // 性别，参见《SexType》
                    "age": 30,          // 年龄
                    "credential_no": "",// 证件号
                    "group": 1,         // 黑白名单类型，参见《BlackWhiteList》
                    "birthday": "",     // 出生日期
                    "mobile": "",       // 手机号
                    "email": "",        // 邮箱
                    "company": "",      // 所在单位
                    "position": "",     // 职位
                    "effective": "",    // 有效时间-开始时间（生效）
                    "expire": "",       // 有效时间-结束时间（到期）
                    "speech": "xx",     // 迎宾语
                    "photo_list": [""], // 照片URL列表，第一张照片为默认显示照片
                    "property": {},     // 人员类型
                }
            }
            字段定义
            for property
            1. 员工
            {
                "rule_id": 1,     // 考勤规则id
                "rule_name": "",  // 考勤规则名称
            }
            2. VIP
            {
                "level": "",        // VIP等级
                "expire_date": ""   // 到期时间
            }
            失败 - {"code": <非0>, "message": "错误说明", "visible": false}
        */
        void GetPeopleInfo(string cond, out string result);

        /**
         * @brief  QueryPeopleList 查询人员列表
         * @since  2020/03/18
         * @update 2020/04/08 增加年龄字段
         *
         * @param cond 查询条件。
            example:
            {
                "page_no": 1,           必填,int,页号
                "page_size": 10,        必填,int,每页个数
                "org_id": 1,            必填,int,组织id
                "operator": "jobs",     必填,string,操作者
                "query_cond": {
                    "lib_id": 1,        必填,底库ID
                    "name": "xx",       选填,string,姓名，支持模糊匹配
                    "credential_no": "",选填,string,证件号
                    "mobile": "",       选填,string,手机号
                    "group": 1,         选填,int,黑白名单类型，参见《BlackWhiteList》
                }
            }
         * @param result 成功或失败。例：
            成功 - 返回对应的结果
            {
                "code": 0,
                "info": {
                    "page_no": 1,
                    "page_size": 10,
                    "total_count": 32,
                    "items": [
                        {
                            "people_id": 1,     // 人员ID
                            "name": "xx",       // 姓名
                            "sex": 1,           // 性别，参见《SexType》
                            "age": 30,          // 年龄
                            "credential_no": "",// 证件号
                            "group": 1,         // 黑白名单类型，参见《BlackWhiteList》
                            "birthday": "",     // 出生日期
                            "mobile": "",       // 手机号
                            "email": "",        // 邮箱
                            "company": "",      // 所在单位
                            "position": "",     // 职位
                            "effective": "",    // 有效时间-开始时间（生效）
                            "expire": "",       // 有效时间-结束时间（到期）
                            "speech": "xx",     // 迎宾语
                            "photo_url": "xx",  // 照片URL
                            "property": {},     // 人员类型
                        }, ...
                    ]
                }
            }
            字段定义
            for property
            1. 员工
            {
                "rule_id": 1,     // 考勤规则id
                "rule_name": "",  // 考勤规则名称
            }
            2. VIP
            {
                "level": "",        // VIP等级
                "expire_date": ""   // 到期时间
            }
            失败 - {"code": <非0>, "message": "错误说明", "visible": false}
        */
        void QueryPeopleList(string cond, out string result);


        /*----------------------------------------------------------------------
          人脸识别历史管理
         ---------------------------------------------------------------------*/
         /**
         * @brief  DeleteFaceRecoRecord 删除人脸识别历史记录
         * @since  2020/03/18
         *
         * @param record 任务识别记录信息。
            example:
            {
                "id": 1,                必填,int,记录id
                "org_id": 1,            必填,int,组织id
                "operator": "jobs",     必填,string,操作者，即当前登录的账号。
            }
         * @param result 成功或失败。例：
            成功 - {"code": 0}
            失败 - {"code": <非0>, "message": "错误说明", "visible": false}
        */
        void DeleteFaceRecoRecord(string record, out string result);

        /**
         * @brief  BatchDeleteFaceRecoRecord 批量删除人脸识别历史记录
         * @since  2020/03/18
         *
         * @param record 识别记录信息。
            example:
            {
                "id_list": "1,2",       必填,string,记录ID列表
                "org_id": 1,            必填,int,组织id
                "operator": "jobs",     必填,string,操作者，即当前登录的账号。
            }
         * @param result 成功或失败。例：
            成功 - {"code": 0}
            失败 - {"code": <非0>, "message": "错误说明", "visible": false}
        */
        void BatchDeleteFaceRecoRecord(string record, out string result);

        /**
         * @brief  QueryFaceRecoRecordList 查询人脸识别历史记录
         * @since  2020/03/18
         *
         * @param cond 查询条件。
            example:
            {
                "page_no": 1,           必填,int,页号
                "page_size": 10,        必填,int,每页个数
                "org_id": 1,            必填,int,组织id
                "operator": "jobs",     必填,string,操作者，即当前登录的账号。
                "query_cond": {
                    "site_id": 1,       选填,int,组织地点ID
                    "lib_id": 1,        选填,int,底库ID
                    "name": "xx",       选填,string,姓名，支持精确匹配
                    "begin_time": "",   必填,string,开始时间
                    "end_time": "",     必填,string,结束时间
                }
            }
         * @param result 成功或失败。例：
            成功 - 返回对应的结果
            {
                "code": 0,
                "info": {
                    "page_no": 1,
                    "page_size": 10,
                    "total_count": 32,
                    "items": [
                        {
                            "id": 1,            // 记录ID
                            "name": "xx",       // 姓名
                            "credential_no": "",// 证件号
                            "compare_score": .0,// 比对得分
                            "photo_url": "xxx", // 底库照片URL
                            "face_url": "xxx",  // 抓拍人脸图URL
                            "lib_id": 1,        // 底库ID
                            "lib_name": 1,      // 底库名称
                            "camera_id": 1,     // 设备ID
                            "camera_name": "xx",// 设备名称
                            "site_id": 1,       // 店铺ID
                            "site_name": "xx",  // 店铺名称
                            "create_time": "",  // 记录时间
                        }, ...
                    ]
                }
            }
            失败 - {"code": <非0>, "message": "错误说明", "visible": false}
        */
        void QueryFaceRecoRecordList(string cond, out string result);

        /*----------------------------------------------------------------------
         客流历史记录管理
         ---------------------------------------------------------------------*/
        /**
         * @brief  QueryCustomerFlowList 查询客流记录统计
         * @since  2020/03/31
         *
         * @param cond 查询条件。
            example:
            {
                "page_no": 1,           必填,int,页号
                "page_size": 10,        必填,int,每页个数
                "type": 1,              必填,int,0-未知 1-3日内到店 2-7日内到店 3-30日内到店
                "org_id": 1,            必填,int,组织id
                "operator": "jobs",     必填,string,操作者，即当前登录的账号。
                "query_cond": {
                    "order_flag": 1,        选填,int,1-时间倒序 2-进店次数倒序
                    "site_id_list": "1",    选填,string,组织地点ID列表
                    "lib_id_list": "1",     选填,string,底库ID列表
                }
            }
         * @param result 成功或失败。例：
            成功 - 返回对应的结果
            {
                "code": 0,
                "info": {
                    "page_no": 1,
                    "page_size": 1,
                    "total_count": 1,
                    "items": [
                        {
                            "customer_id": "",          // 客人ID
                            "people_id": 1,             // 人员ID
                            "name": "xx"                // 人员姓名
                            "type": 1,                  // 人员类型
                            "age": 1,                   // 性别
                            "sex": 1,                   // 年龄
                            "site_id": 1,               // 组织地点ID
                            "site_name": "xx",          // 地点名称
                            "photo_url": "xxx",         // 底库照片URL
                            "face_url": "xxx",          // 抓拍人脸图URL
                            "first_capture_time": "xx", // 进店首次抓拍时间
                            "last_capture_time": "xx",  // 进店末次抓拍时间
                            "thirty_day_times": 1,      // 30天进店次数
                        }, ...
                    ]
                }
            }
            失败 - {"code": <非0>, "message": "错误说明", "visible": false}
        */
        void QueryCustomerFlowList(string cond, out string result);

        /*----------------------------------------------------------------------
          抓拍机管理
         ---------------------------------------------------------------------*/
        /**
         * @brief  UpdateCamera 更新抓拍机信息
         * @since  2020/03/18
         *
         * @param camera 抓拍机信息。
            example:
            {
                "camera_id": 1,         必填,int,抓拍机ID
                "name": "xx",           必填,string,设备名称
                "remark": "xx",         选填,string,备注
                "org_id": 1,            必填,int,组织id
                "operator": "jobs",     必填,string,操作者，即当前登录的账号。
            }
         * @param result 成功或失败。例：
            成功 - {"code": 0}
            失败 - {"code": <非0>, "message": "错误说明", "visible": false}
        */
        void UpdateCamera(string camera, out string result);

        /**
         * @brief  DeleteCamera 删除抓拍机
         * @since  2020/03/18
         *
         * @param camera 抓拍机信息。
            example:
            {
                "camera_id": 1,         必填,int,抓拍机ID
                "org_id": 1,            必填,int,组织id
                "operator": "jobs",     必填,string,操作者，即当前登录的账号。
            }
         * @param result 成功或失败。例：
            成功 - {"code": 0}
            失败 - {"code": <非0>, "message": "错误说明", "visible": false}
        */
        void DeleteCamera(string camera, out string result);

        /**
         * @brief  BatchDeleteCamera 批量删除抓拍机
         * @since  2020/03/18
         *
         * @param camera 设备信息。
            example:
            {
                "camera_list": "1,2",   必填,string,设备ID列表
                "org_id": 1,            必填,int,组织id
                "operator": "jobs",     必填,string,操作者，即当前登录的账号。
            }
         * @param result 成功或失败。例：
            成功 - {"code": 0}
            失败 - {"code": <非0>, "message": "错误说明", "visible": false}
        */
        void BatchDeleteCamera(string camera, out string result);

        /**
         * @brief  QueryCameraList 查询抓拍机列表
         * @since  2020/03/18
         *
         * @param cond 查询条件。
            example:
            {
                "page_no": 1,           必填,int,页号
                "page_size": 10,        必填,int,每页个数
                "org_id": 1,            必填,int,组织id
                "operator": "jobs",     必填,string,操作者，即当前登录的账号。
                "query_cond": {
                    "name": "xx",       选填,string,设备名称，支持模糊匹配
                    "serialno": "",     选填,string,设备序列号，支持精确匹配
                    "site_id": 1,       选填,int,组织地点ID
                    "pricing": 1,       选填,int,套餐类型，参见《PricingType》
                    "valid": 1,         选填,int,0-全部 1-有效 2-失效
                }
            }
         * @param result 成功或失败。例：
            成功 - 返回对应的结果
            {
                "code": 0,
                "info": {
                    "page_no": 1,
                    "page_size": 10,
                    "total_count": 32,
                    "items": [
                        {
                            "camera_id": 1,     // 设备ID
                            "name": "xx",       // 设备名称
                            "manufacturer": 1,  // 设备厂商,参见《CameraMfrsType》
                            "serialno": "xxx",  // 设备序列号
                            "model": "xxx",     // 设备型号
                            "remark": "xx",     // 备注
                            "online": true,     // 在线状态
                            "create_time": "2019-10-20 08:12:12"
                            "site": {
                                "site_id": 0,       int,安装地点ID
                                "name": "",         string,组织地点，只能由字母和数字组成
                                "province": 100000, int,省级代码
                                "city": 100100,     int,市级代码
                                "region": 100101,   int,区级代码
                                "address": "",      string,详细地址
                                "full_address": "", string,完整路径
                            },
                            "order": {
                                "id": 0,            int,记录ID
                                "order_id": 0,      int,订单号
                                "pricing": "",      int,套餐类型，参见《PricingType》
                                "expire_date": "2022-01-01 00:00:00"
                            }
                        }, ...
                    ]
                }
            }
            失败 - {"code": <非0>, "message": "错误说明", "visible": false}
        */
        void QueryCameraList(string cond, out string result);

        /**
         * @brief  UpdateCameraConfig 修改抓拍机配置
         * @since  2020/06/15
         *
         * @param cond 查询条件。
            example:
            {
                "org_id": 1,            必填,int,组织id
                "camera_id": 1,         必填,int,设备id
                "config": "{}",         必填,string,设备配置,json格式
                "operator": "jobs",     必填,string,操作者，即当前登录的账号。
            }

            config格式如下:
            {
                "detect_interval":5,    // int,抓拍间隔,单位/秒
                "angle_pitch": 20.0,    // float,人脸俯仰角
                "angle_yaw": 20.0,      // float,人脸偏航角
                "angle_roll": 20.0,     // float,人脸滚转角
                "keypoints_confidence": 7   // float,人脸关键点可信度，范围0.0~100.0
            }
         * @param result 成功或失败。例：
            成功 - {"code": 0}
            失败 - {"code": <非0>, "message": "错误说明", "visible": false}
        */
        void UpdateCameraConfig(string cond, out string result);

        /**
         * @brief  ResetCameraConfig 重置抓拍机配置为默认
         * @since  2020/06/15
         *
         * @param cond 查询条件。
            example:
            {
                "org_id": 1,            必填,int,组织id
                "camera_id": 1,         必填,int,设备id
                "operator": "jobs",     必填,string,操作者，即当前登录的账号。
            }
         * @param result 成功或失败。例：
            成功 - {"code": 0}
            失败 - {"code": <非0>, "message": "错误说明", "visible": false}
        */
        void ResetCameraConfig(string cond, out string result);

        /**
         * @brief  QueryCameraConfig 查询抓拍机配置
         * @since  2020/06/15
         *
         * @param cond 查询条件。
            example:
            {
                "org_id": 1,            必填,int,组织id
                "camera_id": 1,         必填,int,设备id
                "operator": "jobs",     必填,string,操作者，即当前登录的账号。
            }
         * @param result 成功或失败。例：
            成功 - 返回对应的结果
            {
                "code": 0,
                "info": "{}"    string,json格式设备配置,详细格式见UpdateCameraConfig的config格式
            }
            失败 - {"code": <非0>, "message": "错误说明", "visible": false}
        */
        void QueryCameraConfig(string cond, out string result);


        /*----------------------------------------------------------------------
         推送客流进店实时信息
         ---------------------------------------------------------------------*/
        /**
         * @brief  GetRealtimeCapture 获取实时抓拍信息
         * @since  2020/03/18
         *
         * @param cond 获取条件。
            example:
            {
                "site_id": 1,           必填,int,组织地点ID
                "operator": "jobs",     选填,string,操作者，即当前登录的账号。
            }
         * @param result 成功或失败。例：
            成功 - 返回对应的结果
            {
                "code": 0,
                "info": {
                    "customer_id": "",          // 客人ID
                    "people_id": 1,             // 人员ID
                    "name": "xx"                // 人员姓名
                    "type": 1,                  // 人员类型，参见《PeopleType》
                    "group": 1,                 // 黑白名单类型，参见《BlackWhiteList》
                    "credential_no": "xx"       // 证件号
                    "age": 1,                   // 性别
                    "sex": 1,                   // 年龄
                    "site_id": 1,               // 组织地点ID
                    "site_name": "xx",          // 地点名称
                    "compare_score": 1.0        // 比对得分 float
                    "photo_url": "xx",          // 底库图片路径
                    "capture_time": "xx",       // 抓拍时间
                }
            }
            失败 - {"code": <非0>, "message": "错误说明", "visible": false}
        */
        void GetRealtimeCapture(string cond, out string result);


        /*----------------------------------------------------------------------
         看板信息
         ---------------------------------------------------------------------*/
        /**
         * @brief  GetTodayInfo 获取今日店铺信息
         * @since  2020/03/12
         *
         * @param cond 获取条件。
            example:
            {
                "org_id": x,                // 必填,int,组织id
                "site_list": "1,2"          // 必填,string,店铺id列表
            }
         * @param result 成功或失败。例：
            成功 - 返回对应的结果
            {
                "code": 0,
                "info": {
                    "total_count": x,       // int,累计进店
                    "yestoday_count": x,    // int,昨日进店
                    "month_count": x,       // int 本月进店
                    "vip_count": x,         // int,vip识别
                    "emplogyee_count": x    // int,员工到岗
                }
            }
            失败 - {"code": <非0>, "message": "错误说明", "visible": false}
         */
        void GetTodayInfo(string cond, out string result);

        /**
         * @brief  GetCustomerFlowInfo 获取客流量统计
         * @since  2020/03/12
         *
         * @param cond 获取条件。
            example:
            {
                "org_id":x,                 // 必填,int,组织id
                "site_list": "1,2"          // 必填,string,店铺列表
                "begin_date": "x",          // 必填,string,开始时间
                "end_date": "x",            // 必填,string,结束时间
            }
         * @param result 成功或失败。例：
            成功 - 返回对应的结果
            {
                "code": 0,
                "info": {
                    "date_group": [
                        {
                            "date": "x",        // string,日期
                            "male_count": 0,    // int,男性的数量
                            "female_count": 0,  // int,女性的数量
                        }, ...
                    ],
                    "age_group": [
                        {
                            "age": "0-12",      // string,年龄段
                            "count": 0          // int,数量
                        }
                    ]
                }
            }
            失败 - {"code": <非0>, "message": "错误说明", "visible": false}
         */
        void GetCustomerFlowInfo(string cond, out string result);

        /**
         * @brief  GetCompetitionInfo 获取擂台对比数据
         * @since  2020/03/12
         *
         * @param cond 获取条件。
            example:
            {
                "org_id": x,                // 必填,Int,组指id
                "site_left": "1,2",         // 必填,string,店铺id
                "site_right": "1,2",        // 必填,string,店铺id
                "begin_date": "x",          // 必填,string,开始时间
                "end_date": "x",            // 必填,string,结束时间
            }
         * @param result 成功或失败。例：
            成功 - 返回对应的结果
            {
                "code": 0,
                "info": {
                    "left": {
                        "site_list": "1,2", // string,店铺id列表
                        "total_count": 0,   // int,累计进店
                        "vip_count": 0,     // int,vip数量
                        "activity": 0.0     // double,员工活跃度（人均活跃值）
                    },
                    "right": {
                        "site_list": "1,2", // string,店铺id列表
                        "total_count": 0,   // int,累计进店
                        "vip_count": 0,     // int,vip数量
                        "activity": 0.0     // double,员工活跃度（人均活跃值）
                    }
                }
            }
            失败 - {"code": <非0>, "message": "错误说明", "visible": false}
         */
        void GetCompetitionInfo(string cond, out string result);

        /**
         * @brief  GetVIPAttendanceInfo 获取VIP考勤统计
         * @since  2020/03/12
         *
         * @param cond 获取条件。
            example:
            {
                "org_id": x,                // 必填,Int,组指id
                "site_list": "1,2"          // 必填,string,店铺列表
                "begin_date": "x",          // 必填,string,开始时间
                "end_date": "x",            // 必填,string,结束时间
            }
         * @param result 成功或失败。例：
            成功 - 返回对应的结果
            {
                "code": 0,
                "info": {
                    "attend_count": 0,      // int,vip到场人数
                    "total_count": 0        // int,vip总人数
                }
            }
            失败 - {"code": <非0>, "message": "错误说明", "visible": false}
         */
        void GetVIPAttendanceInfo(string cond, out string result);

        /**
         * @brief  QueryCustomerStayTime 查询顾客驻店时间
         * @since  2020/03/12
         *
         * @param info 查询条件
            example: 
            {
                "site_list": "1,2,3",   必填,string,店铺ID列表
                "begin_date": "",       必填,string,查询开始时间
                "end_date": "",         必填,string,查询结束时间
                "org_id": 1,            必填,int,组织机构ID
            }
         * @param result 成功或失败。例：
            成功 - 返回对应结果
            {
                "code": 0, 
                "info": {
                    "items": [
                        {
                            "date": "2020-03-03",   string,日期
                            "male_stay_time": 1,    int,男性停留时间,分钟
                            "female_stay_time": 1   int,女性停留时间,分钟
                        }, ...
                    ]
                }
            }
            失败 - {"code": <非0>, "msg": "错误说明", "user_visible": false}
         */
        void QueryCustomerStayTime(string info, out string result);

        /**
         * @brief  QueryActivity 查询活跃度
         * @since  2020/03/12
         *
         * @param info 查询条件
            example: 
            {
                "site_list": "1,2,3",   必填,string,店铺ID列表
                "begin_date": "",       必填,string,查询开始时间
                "end_date": "",         必填,string,查询结束时间
                "org_id": 1,            必填,int,组织机构ID
            }
         * @param result 成功或失败。例：
            成功 - 返回对应结果
            {
                "code": 0, 
                "info": {
                    "emplogyees": [
                        {
                            "people_id": 1,     int,员工id
                            "people_name": "",  string,员工名字
                            "activity": 1       int,员工活跃度
                        }, ...
                    ]
                    "guids": [
                        {
                            "date": "",         string,日期
                            "efficiency": 0.56  float,效率值
                        }, ...
                    ]
                }
            }
            失败 - {"code": <非0>, "msg": "错误说明", "user_visible": false}
         */
        void QueryActivity(string info, out string result);

        /*----------------------------------------------------------------------
                                        热力图管理
         ----------------------------------------------------------------------*/
        /**
         * @brief  QueryHeatmapList 获取热力图列表
         * @since  2020/04/20
         *
         * @para cond 查询条件
            example:
            {
                "site_id": 1,           选填,int,组织地点id
                "org_id": 1,            必填,int,组织id
                "operator":"xxx"        必填,string,操作员名称
            }
         * @para result 成功或失败。例:
            成功 - 返回对应的结果
            {
                "code": 0,
                "info":
                {
                    "items": [
                        {
                            "heatmap_id": 1,            int,映射id
                            "name": "",                 string,映射标识
                            "panorama_url": 1,          string,公司全景图
                            "site_id" 1,                int,组织地址id
                            "site_name": "test",        string,组织地址名
                            "org_id": 1,                int,组织id
                            "organization": "",         string,组织名
                            "create_time": "2019-07-17 14:00:00"    string,创建时间
                        }
                    ]
                }
            }
            失败 - {"code": <非0>, "msg": "错误说明", "user_visible": false}
        */
        void QueryHeatmapList(string cond, out string result);

        /**
         * @brief  QueryHeatmapData 获取热力图数据
         * @since  2020/04/20
         *
         * @para cond 查询条件
            example:
            {
                "heatmap_id": 1,        必填,int,热力图映射id
                "begin_time": "",       必填,string,开始时间
                "end_time": ""          必填,string,结束时间
                "site_id": 1,           必填,int,组织地点id
                "org_id": 1,            必填,int,组织id
                "operator":"xxx"        必填,string,操作员名称
            }
         * @para result 成功或失败。例:
            成功 - 返回对应的结果
            {
                "code": 0,
                "info":
                {
                    "heat_value": [
                        {
                            "x": 1,         int,x坐标
                            "y": 1,         int,y坐标
                            "heat": 1       int,热力值
                        },...
                    ]
                }
            }
            失败 - {"code": <非0>, "msg": "错误说明", "user_visible": false}
        */
        void QueryHeatmapData(string cond, out string result);

/*****************************************考勤相关接口*************************************/
        /**
         * @brief SetHolidays 设置节假日
         * @since  V1.20200409
         * @update V2.20200513
         *
         * @param info 节假日信息
             example:
             {
                "org_id":0,     必填,int,组织ID
                "year": 2019,   必填,int,年
                "workdays": "1212", 必填,string,工作日列表,自该年一月一日起,1-工作日 2-休息日
                "operator": "jobs", 必填,string,操作者
             }
         * @param result 成功或失败。例：
             成功 - {"code": 0}
             失败 - {"code": <非0>, "msg": "错误说明", "user_visible": false}
        */
        void SetHolidays(string info, out string result);

        /**
         * @brief GetHolidays 获取节假日
         * @since  V1.20200409
         * @update V2.20200513
         *
         * @param info 节假日信息
             example:
             {
                "year": 2019    必填,int,年
                "org_id":0      必填,int,组织ID
                "operator": "jobs",     必填,string,操作者
             }
         * @param result 成功或失败。例：
            成功 - 返回对应结果
            {
                "code": 0, 
                "info": {
                    "year": 2019,   int,年
                    "workdays": "1212",   string,工作日列表,自该年一月一日起,1-工作日 2-休息日
                }
            }
            失败 - {"code": <非0>, "msg": "错误说明", "user_visible": false}
        */
        void GetHolidays(string info, out string result);

        /**
         * @brief  AddLeaveInfo 添加请假信息
         * @since  V1.20200409
         *
         * 请假类型:
         * 1:出差
         * 2:参会
         * 3:事假
         * 4:病假
         * 5:产假
         * 6:婚假
         * 7:工伤
         * 8:哺乳假
         * 9:丧假
         * 10:其他
         * @param info 请假信息
            example: 
            {
                "type" : 1,         必填,int,请假类型
                "lib_id" : 1,       必填,int,人员ID
                "lib_name" : "xxx", 必填,string,人员名称
                "people_id" : 1,    必填,int,人员ID
                "people_name" : "xxx",  必填,string,人员名称
                "start_date" : "",  必填,string,请假开始时间
                "end_date" : "",    必填,string,请假结束时间
                "remark" : "",     选填,string,备注
                "org_id" : 1,       必填,int,组织ID
                "operator": "jobs",     必填,string,操作者
            }
         * @param result 成功或失败。例：
            成功 - {"code": 0}
            失败 - {"code": <非0>, "msg": "错误说明", "user_visible": false}
         */
        void AddLeaveInfo(string info, out string result);

        /**
         * @brief  UpdateLeaveInfo 更新请假信息
         * @since  V1.20200409
         *
         * 请假类型:
         * 1:出差
         * 2:参会
         * 3:事假
         * 4:病假
         * 5:产假
         * 6:婚假
         * 7:工伤
         * 8:哺乳假
         * 9:丧假
         * 10:其他
         * @param info 请假信息
            example: 
            {
                "id":0,             必填,int,记录id
                "type" : 1,         选填,int,请假类型
                "lib_id" : 1,       选填,int,人员ID
                "lib_name" : "xxx", 选填,string,人员名称
                "people_id" : 1,    选填,int,人员ID
                "people_name" : "xxx",  选填,string,人员名称
                "start_date" : "",  选填,string,请假开始时间
                "end_date" : "",    选填,string,请假结束时间
                "remark" : "",      选填,string,备注
                "org_id" : 1,       必填,int,组织ID
                "operator": "jobs",     必填,string,操作者
            }
         * @param result 成功或失败。例：
            成功 - {"code": 0}
            失败 - {"code": <非0>, "msg": "错误说明", "user_visible": false}
        */
        void UpdateLeaveInfo(string info, out string result);

        /**
         * @brief  DeleteLeaveInfo 删除请假信息
         * @since  V1.20200409
         *
         * @param info 请假信息
            example: 
            {
                "id":0,             必填,int,记录id
                "org_id" : 1,       必填,int,组织ID
                "operator": "jobs", 必填,string,操作者
            }
         * @param result 成功或失败。例：
            成功 - {"code": 0}
            失败 - {"code": <非0>, "msg": "错误说明", "user_visible": false}
        */
        void DeleteLeaveInfo(string info, out string result);

        /**
         * @brief  QueryLeaveList 查询请假信息
         * @since  V1.20200409
         *
         * @param cond 搜索相关信息
            example:
            {
                "page_no": 1,       必填,int,页号
                "page_size": 10,    必填,int,每页个数
                "org_id": 0,        必填,int,组织id
                "query_cond": {
                    "type" : 0,         选填,int,请假类型
                    "name": "",         选填,string,员工名称
                    "lib_id": 0,        选填,int,底库id
                    "begin_time": "",   选填,string,开始时间
                    "end_time": "",     选填,string,结束时间
                }
            }
         * @param result 成功或失败。例：
            成功 - 返回对应结果
            {
                "code": 0, 
                "info": {
                    "page_no":xx,
                    "page_size":xx,
                    "total_count":xx,
                    "items": [
                        {
                            "id" : 1,           int,记录序号
                            "org_id" : 1,       int,组织ID
                            "type" : 1,         int,请假类型
                            "lib_id" : 1,       int,人员ID
                            "lib_name" : "xxx", string,人员名称
                            "people_id" : 1,    int,人员ID
                            "people_name" : "xxx",  string,人员名称
                            "start_date" : "",  string,请假开始时间
                            "end_date" : "",    string,请假结束时间
                            "remark" : "",      string,备注
                        }, ...
                    ]
                }
            }
            失败 - {"code": <非0>, "msg": "错误说明", "user_visible": false}
         */
        void QueryLeaveList(string cond, out string result);

        /**
         * @brief  AddReSigninInfo 添加补签信息
         * @since  V1.20200409
         * @update  V2.20200514
         *
         * @param info 补签信息
            example: 
            {
                "lib_id" : 1,       必填,int,底库ID
                "lib_name" : "",    必填,string,底库名称
                "people_id" : 1,    必填,int,员工ID
                "people_name" : "", 必填,string,员工名称
                "type" : 1,         必填,int,补签类型,1:上班,2:下班
                "rule_id" : 1,      必填,int,考勤主规则ID
                "rule_name" : "",   必填,int,考勤主规则名称
                "sub_rule_id" : 1,  必填,int,考勤子规则ID
                "sub_rule_name" : "",   必填,int,考勤子规则名称
                "signin_date" : "", 必填,string,补签日期 格式:"2020-01-01"
                "remark" : "",      选填,string,补签原因
                "org_id" : 1,       必填,int,组织ID
                "operator": "jobs",     必填,string,操作者
            }
         * @param result 成功或失败。例：
            成功 - {"code": 0}
            失败 - {"code": <非0>, "msg": "错误说明", "user_visible": false}
         */
        void AddReSigninInfo(string info, out string result);

        /**
         * @brief  UpdateReSigninInfo 修改补签信息
         * @since  V1.20200409
         *
         * @param info 补签信息
            example: 
            {
                "rule_id" : 0,      必填,int,记录id
                "lib_id" : 1,       选填,int,底库ID
                "lib_name" : "",    选填,string,底库名称
                "people_id" : 1,    选填,int,员工ID
                "people_name" : "", 选填,string,员工名称
                "type" : 1,         选填,int,补签类型,1:上班,2:下班
                "signin_date" : "", 必填,string,补签日期 格式:"2020-01-01"
                "remark" : "",      选填,string,补签原因
                "org_id" : 1,       必填,int,组织ID
                "operator": "jobs", 必填,string,操作者
            }
         * @param result 成功或失败。例：
            成功 - {"code": 0}
            失败 - {"code": <非0>, "msg": "错误说明", "user_visible": false}
         */
        void UpdateReSigninInfo(string info, out string result);

        /**
         * @brief  DeleteReSigninInfo 删除补签信息
         * @since  V1.20200409
         *
         * @param info 补签信息
            example: 
            {
                "rule_id" : 1,           必填,int,记录ID
                "org_id" : 1,       必填,int,组织ID
                "operator": "jobs", 必填,string,操作者
            }
         * @param result 成功或失败。例：
            成功 - {"code": 0}
            失败 - {"code": <非0>, "msg": "错误说明", "user_visible": false}
         */
        void DeleteReSigninInfo(string info, out string result);

        /**
         * @brief  QueryReSigninList 查询补签信息
         * @since  V1.20200409
         *
         * @param cond 搜索相关信息
            example:
            {
                "page_no": 1,       必填,int,页号
                "page_size": 10,    必填,int,每页个数
                "org_id": 0,        必填,int,底库id
                "query_cond": {
                    "name": "",         选填,string,员工名称
                    "lib_id": 0,        选填,int,底库id
                    "type": 0,          选填,int,"1-上班 2-下班"
                    "begin_time": "",   选填,string,开始时间
                    "end_time": "",     选填,string,结束时间
                }
            }
         * @param result 成功或失败。例：
            成功 - 返回对应结果
            {
                "code": 0, 
                "info": {
                    "page_no":xx,
                    "page_size":xx,
                    "total_count":xx,
                    "items": [
                        {
                            "id" : 1,           int,记录序号
                            "org_id" : 1,       int,组织id
                            "lib_id" : 1,       int,底库id
                            "lib_name" : "",    string,底库名称
                            "rule_name" : "",   string,考勤主规则名称
                            "sub_rule_name" : "",    string,考勤子规则名称
                            "people_id" : 1,    int,员工id
                            "people_name" : "", string,员工名称
                            "type" : 1,         int,补签类型,1:上班,2:下班
                            "signin_time" : "", string,补签时间 格式:"2020-01-01"
                            "remark" : "",      string,补签原因
                        }, ...
                    ]
                }
            }
            失败 - {"code": <非0>, "msg": "错误说明", "user_visible": false}
         */
        void QueryReSigninList(string cond, out string result);

        /**
         * @brief  AddAttendanceRule 添加考勤规则
         * @since  V1.20200409
         * @update  V2.20200514
         *
         * @param cond 搜索相关信息
            example:
            {
                "name":"",                  必填,string,考勤规则名
                "enable_holiday":0,         必填,int,节假日休息标识，0-节假日不可用 1-节假日可用
                "type":1,                   必填,int,规则类型 1-固定考勤 2-时长考勤 3-排班考勤
                "enable_over_work":0,       必填,int,是否开启加班   0-关闭 1-开启
                "property": {}              必填,具体根据type确定
                "org_id" : 1,               必填,int,组织ID
                "operator": "jobs",         必填,string,操作者
                "dead_line":"00 04:00:00"   选填,string,下班卡截止时间,固定和时长考勤必填
                "enable_dead_line_cross":0  选填,int,下班卡截止时间是否跨天 0-不跨天 1-跨天,固定和时长考勤必填
                "unsign_threshold":30,      选填,int,签到延迟阈值, 单位/分钟(固定时长-漏打卡/早退阈值 时长考勤-当班阈值 排班考勤-漏打卡阈值)
                "over_work_threshold":30,   选填,int,加班开始延迟阈值, 单位/分钟
                "remark":"",                选填,string,备注
                "dead_line_threshold":240,  选填,int,截止时间,最后时间延后阈值,轮班考勤必填
                "team_count":3,             选填,int,班组数量,轮班考勤必填
                "shift_period":3,           选填,int,排班周期,轮班考勤必填
                "shift_times":3,            选填,int,每日排班次数,轮班考勤必填
                "start_date":"2020-05-07",  选填,string,主规则开始日期,排班考勤必填
            }
            type=1:固定时长考勤规则
            "property": {
                "rule_info":    //最多四组规则，四组规则时间不交叉，时间顺序增加
                [
                    { 
                        "name":"rule_name",                 string,子规则名称
                        "start_signin_time":"00 09:00:00",  string,开始签到时间
                        "end_signin_time":"00 09:00:00",    string,结束签到时间
                        "start_signout_time":"00 18:00:00", string,开始签退时间
                        "end_signout_time":"00 18:00:00",   string,结束签退时间
                    },...
                ]
            }
            type=2:时长考勤规则
            "property": {
            
            }
            type=3:轮班考勤规则
            "property": {
                "rule_info":
                [
                    {
                        "index":0,                          int,该规则日期索引,0-第一天 1-第二天,以此类推
                        "rule_index":0,                     int,该规则索引,0-第一班 1-第二班,以此类推
                        "team_index":0,                     int,该规则班组索引
                        "sub_rule_name":"A班组",            string,该规则适用班组
                        "start_signin_time":"00 07:00:00",  string,签到开始时间
                        "end_signin_time":"00 09:00:00",    string,签到结束时间
                        "start_signout_time":"00 17:00:00", string,签退开始时间
                        "end_signout_time":"00 19:00:00"    string,签退结束时间
                    },...
                ]
            }
         * @param result 成功或失败。例：
            成功 - {"code": 0}
            失败 - {"code": <非0>, "msg": "错误说明", "user_visible": false}
         */
        void AddAttendanceRule(string cond, out string result);

        /**
         * @brief  UpdateAttendanceRule 更新考勤规则
         * @since  V1.20200409
         *
         * @param cond 搜索相关信息
            example:
            {                
                "rule_id":0,                     必填,int,考勤规则ID
                "name":"",                  必填,string,考勤规则名
                "enable_holiday":0,         必填,int,节假日休息标识，0-节假日不可用 1-节假日可用
                "type":1,                   必填,int,规则类型 1-固定考勤 2-时长考勤 3-排班考勤
                "enable_over_work":0,       必填,int,是否开启加班   0-关闭 1-开启
                "property": {}              必填,具体根据type确定
                "org_id" : 1,               必填,int,组织ID
                "operator": "jobs",         必填,string,操作者
                "dead_line":"00 04:00:00"   选填,string,下班卡截止时间,固定和时长考勤必填
                "enable_dead_line_cross":0  选填,int,下班卡截止时间是否跨天 0-不跨天 1-跨天,固定和时长考勤必填
                "unsign_threshold":30,      选填,int,签到延迟阈值, 单位/分钟(固定时长-漏打卡/早退阈值 时长考勤-当班阈值 排班考勤-漏打卡阈值)
                "over_work_threshold":30,   选填,int,加班开始延迟阈值, 单位/分钟
                "remark":"",                选填,string,备注
                "dead_line_threshold":240,  选填,int,截止时间,最后时间延后阈值,轮班考勤必填
                "team_count":3,             选填,int,班组数量,轮班考勤必填
                "shift_period":3,           选填,int,排班周期,轮班考勤必填
                "shift_times":3,            选填,int,每日排班次数,轮班考勤必填
                "start_date":"2020-05-07"   选填,string,主规则开始日期,排班考勤必填
            }
         * @param result 成功或失败。例：
            成功 - {"code": 0}
            失败 - {"code": <非0>, "msg": "错误说明", "user_visible": false}
         */
        void UpdateAttendanceRule(string cond, out string result);

        /**
         * @brief  DeleteAttendanceRule 删除考勤规则
         * @since  V1.20200409
         *
         * @param cond 搜索相关信息
            example:
            {
                "rule_id":0,        必填,int,考勤规则ID
                "type":0,           必填,int,考勤规则类型
                "org_id" : 1,       必填,int,组织ID
                "operator": "jobs", 必填,string,操作者
            }
         * @param result 成功或失败。例：
            成功 - {"code": 0}
            失败 - {"code": <非0>, "msg": "错误说明", "user_visible": false}
         */
        void DeleteAttendanceRule(string cond, out string result);

        /**
         * @brief  GetSimpleAttendanceRuleList 查询简单考勤规则列表
         * @since  V1.20200409
         *
         * @param cond 搜索相关信息
            example:
            {
                "page_no": 1,       必填,int,页号
                "page_size": 10,    必填,int,每页个数
                "org_id":0,         必填,int,组织ID
            }
         * @param result 成功或失败。例：
            成功 - 返回对应结果
            {                
                "code": 0, 
                "info": {
                    "page_no":xx,
                    "page_size":xx,
                    "total_count":xx,
                    "items": [
                        {
                            "rule_id":0,        int,考勤规则ID
                            "name":"",          string,考勤规则名
                            "type":1,           int,规则类型 1-固定考勤 2-时长考勤 3-排班考勤
                        }
                    ]
            }
            失败 - {"code": <非0>, "msg": "错误说明", "user_visible": false}
         */
        void GetSimpleAttendanceRuleList(string cond, out string result);

        /**
         * @brief  GetSimpleSubAttendanceRuleList 查询简单子规则列表
         * @since  V1.20200409
         *
         * @param cond 搜索相关信息
            example:
            {
                "page_no": 1,       必填,int,页号
                "page_size": 10,    必填,int,每页个数
                "org_id":0,         必填,int,组织ID
                "rule_id":0,        必填,int,主规则ID
                "type":0,           选填,int,规则type 1-固定考勤 2-时长考勤 3-排班考勤
            }
         * @param result 成功或失败。例：
            成功 - 返回对应结果
            {                
                "code": 0, 
                "info": {
                    "page_no":xx,
                    "page_size":xx,
                    "total_count":xx,
                    "items": [
                        {
                            "rule_id":0,    int,考勤规则ID
                            "name":"",          string,考勤规则名
                            "type":1,           int,规则类型 1-固定考勤 2-时长考勤 3-排班考勤
                            "property" : {}
                        }
                    ]
            }
            for property:
            type 1-固定考勤
            {
                "start_signin_time" : "00 09:00:00",
                "end_signin_time" : "00 09:30:00",
                "start_signout_time" : "01 09:00:00",
                "end_signout_time" : "01 09:30:00"
                "rule_id" :1,
                "sub_rule_name" : "",
                "type" : 1
            }
            失败 - {"code": <非0>, "msg": "错误说明", "user_visible": false}
         */
        void GetSimpleSubAttendanceRuleList(string cond, out string result);

        /**
         * @brief  QueryAttendanceRuleList 查询考勤规则列表
         * @since  V1.20200409
         *
         * @param cond 搜索相关信息
            example:
            {
                "page_no": 1,       必填,int,页号
                "page_size": 10,    必填,int,每页个数
                "org_id":0,         必填,int,组织ID
            }
         * @param result 成功或失败。例：
            成功 - 返回对应结果
            {                
                "code": 0, 
                "info": {
                    "page_no":xx,
                    "page_size":xx,
                    "total_count":xx,
                    "items": [
                        {
                            "rule_id":0,        int,考勤规则ID
                            "org_id":0,         int,组织ID
                            "name":"",          string,考勤规则名
                            "type":1,           int,规则类型 1-固定考勤 2-时长考勤 3-排班考勤
                            "bind_count":0      int,绑定人数
                            "remark":"xxx"      string,备注
                        }
                    ]
            }
            失败 - {"code": <非0>, "msg": "错误说明", "user_visible": false}
         */
        void QueryAttendanceRuleList(string cond, out string result);

        /**
         * @brief  QueryAttendanceRuleBindList 查询考勤规则绑定列表
         * @since  V1.20200409
         *
         * @param cond 搜索相关信息
            example:
            {
                "page_no": 1,       必填,int,页号
                "page_size": 10,    必填,int,每页个数
                "type": 1,          必填,int,规则类型 1-固定考勤 2-时长考勤 3-轮班考勤
                "rule_id": 1,       必填,int,主考勤ID
                "org_id":0,         必填,int,组织ID
            }
         * @param result 成功或失败。例：
            成功 - 返回对应结果
            {                
                "code": 0, 
                "info": {
                    "page_no":xx,
                    "page_size":xx,
                    "total_count":xx,
                    "items": [
                        {
                            "rule_id":0,        int,考勤规则ID
                            "org_id":0,         int,组织ID
                            "rule_name":"",     string,考勤规则名
                            "type":1,           int,规则类型 1-固定考勤 2-时长考勤 3-排班考勤
                            "people_id":1       int,人员ID
                            "people_name":""    string,人员名称
                        }
                    ]
            }
            失败 - {"code": <非0>, "msg": "错误说明", "user_visible": false}
         */
        void QueryAttendanceRuleBindList(string cond, out string result);

        /**
         * @brief  QueryAttendanceRuleInfo 查询考勤规则信息
         * @since  V1.20200409
         * @update  V2.20200514
         *
         * @param cond 搜索相关信息
            example:
            {
                "org_id":0,         必填,int,组织ID
                "type":1,           必填,int,规则类型, 1-固定时长考勤 2-不固定时长 3-轮班
                "rule_id":0,        必填,int,主规则ID
            }
         * @param result 成功或失败。例：
            成功 - 返回对应结果
            {                
                "rule_id" : 1,          int,主规则ID
                "rule_name" : "",       int,主规则名称
                "enable_holiday" : 1,   int,节假日可用 0-不可用 1-可用
                "enable_cross_day" : 1, int,是否跨天 0-不跨天 1-跨天
                "unsign_threshold" : 30,int,漏打卡阈值，单位/分钟
                "enable_over_work" : 1, int,是否开启加班 0-关闭 1-开启
                "over_work_threshold" : 30, int,加班阈值,单位/分钟
                "dead_line" : "01 04:00:00",int,截止日期
                "type" : 1,             int,规则类型 1-固定时长2-不固定时长 3-轮班
                "remark" : "",          string,备注
                "org_id" : 1,           int,组织ID
                "rule_info" : [         子规则信息
                    {}
                ],
                "dead_line_threshold":240,  int,截止时间,最后时间延后阈值,轮班考勤独有
                "team_count":3,             int,班组数量,轮班考勤独有
                "shift_period":3,           int,排班周期,轮班考勤独有
                "shift_times":3,            int,每日排班次数,轮班考勤独有
                "start_date":"2020-05-07",  string,主规则开始日期,轮班考勤独有
           }
            for rule_info:
            type = 1 固定时长考勤
            {
                "sub_rule_id" : 1,  int,子规则ID
                "sub_rule_name" : "",                  string,子规则名称
                "start_signin_time" : "00 09:00:00",   string,开始签到时间
                "end_signin_time" : "00 09:30:00",     string,结束签到时间
                "start_signout_time" : "00 18:00:00",  string,开始签退时间
                "end_signout_time" : "00 18:30:00"     string,结束签退时间
            }
            type = 2 时长考勤
            {
            }
            type = 3 轮班考勤
            {
                "index":0,                          int,该规则日期索引,0-第一天 1-第二天,以此类推
                "rule_index":0,                     int,该规则索引,0-第一班 1-第二班,以此类推
                "team_index":0,                     int,该规则班组索引
                "sub_rule_name":"A班组",            string,该规则适用班组
                "start_signin_time":"00 07:00:00",  string,签到开始时间
                "end_signin_time":"00 09:00:00",    string,签到结束时间
                "start_signout_time":"00 17:00:00", string,签退开始时间
                "end_signout_time":"00 19:00:00"    string,签退结束时间
            }
            失败 - {"code": <非0>, "msg": "错误说明", "user_visible": false}
         */
        void QueryAttendanceRuleInfo(string cond, out string result);

        /**
         * @brief  BatchSetAttendanceRule 批量设置考勤规则
         * @since  V1.20200409
         * @update  V2.20200514
         *
         * @param cond 搜索相关信息
            example:
            {
                "rule_id":0,            必填,int,考勤规则ID
                "people_id_list":"1",   必填,string,人员ID列表
                "org_id" : 1,           必填,int,组织ID
                "operator": "jobs",     必填,string,操作者
            }
         * @param result 成功或失败。例：
            成功 - {"code": 0}
            失败 - {"code": <非0>, "msg": "错误说明", "user_visible": false}
         */
        void BatchSetAttendanceRule(string cond, out string result);

        /**
         * @brief  SetPeopleAttendanceRule 设置考勤规则
         * @since  V1.20200409
         *
         * @param cond 搜索相关信息
            example:
            {
                "rule_id":0,            必填,int,考勤规则ID
                "people_id":1,          必填,int,人员ID
                "org_id" : 1,           必填,int,组织ID
                "operator": "jobs"      必填,string,操作者
            }
         * @param result 成功或失败。例：
            成功 - {"code": 0}
            失败 - {"code": <非0>, "msg": "错误说明", "user_visible": false}
         */
        void SetPeopleAttendanceRule(string cond, out string result);

        /**
         * @brief  QueryCurMonthAttendance 查询当月考勤统计
         * @since  V1.20200409
         *
         * @param cond 搜索相关信息
            example:
            {
                "org_id" : 1,           必填,int,组织ID
                "start_time":"2020-04-01",  必填,string,开始时间
                "end_time":"2020-04-01",    必填,string,结束时间
                "operator": "jobs",     必填,string,操作者
            }
         * @param result 成功或失败。例：
            成功 - 返回对应结果
            {
                "code": 0, 
                "info": {
                    "org_id" : 1,               int,组织ID
                    "late_count" : 1,           int,迟到总数
                    "early_leave_count" : 1,    int,早退人员总数
                    "unsignin_count" : 1,       int,漏打卡总数
                    "absent_count" : 1,         int,缺勤总数
                    "leave_count" : 1,          int,请假总数
                    "resign_count" : 1          int,补签总数
                }
            }
            失败 - {"code": <非0>, "msg": "错误说明", "user_visible": false}
         */
        void QueryCurMonthAttendance(string cond, out string result);

        /**
         * @brief  QueryAttendanceToday 查询今日考勤统计
         * @since  V1.20200409
         *
         * @param cond 搜索相关信息
            example:
            {
                "org_id" : 1,           必填,int,组织ID
                "operator": "jobs",     必填,string,操作者
            }
         * @param result 成功或失败。例：
            成功 - 返回对应结果
            {
                "code": 0, 
                "info": {
                    "org_id" : 1,               int,组织ID
                    "people_count" : 1,         int,应到人员总数
                    "arrive_count" : 1,         int,实到人员总数
                    "late_count" : 1,           int,迟到总数
                    "unsignin_count" : 1,       int,漏打卡总数
                    "leave_count" : 1           int,请假总数
                }
            }
            失败 - {"code": <非0>, "msg": "错误说明", "user_visible": false}
         */
        void QueryAttendanceToday(string cond, out string result);

        /**
         * @brief  QueryAttendanceList 查询考勤记录列表
         * @since  V1.20200409
         *
         * @param cond 搜索相关信息
            example:
            {
                "page_no": 1,           必填,int,页号
                "page_size": 10,        必填,int,每页个数
                "org_id" : 1,           必填,int,组织ID
                "operator": "jobs",     必填,string,操作者
                "query_cond": {
                    "start_time":"2020-04-01",  选填,string,开始时间
                    "end_time":"2020-04-01",    选填,string,结束时间
                    "lib_id":1,                 选填,int,底库id
                    "people_name":"",           选填,string,员工名称
                    "rule_id":1,                选填,int,考勤规则ID
                    "state":0                   选填,int,异常状态 1-迟到 2-早退 3-漏打卡 4-缺勤 5-请假 6-加班 7-补卡
                }
            }
         * @param result 成功或失败。例：
            成功 - 返回对应结果
            {
                "code": 0, 
                "info": {
                    "page_no":xx,
                    "page_size":xx,
                    "total_count":xx,
                    "items": [
                        {
                            "id" : 1,                   int,记录序号
                            "org_id" : 1,               int,组织ID
                            "people_id" : 1,            int,人员ID
                            "people_name" : "xxx",      string,人员名称
                            "lib_id" : 1,               int,人员ID
                            "lib_name" : "xxx",         string,人员名称
                            "rule_id" : 1,              int,考勤规则ID
                            "rule_name" : "",           string,考勤规则名称
                            "attend_date" : "2020-01-01",   string,考勤日期
                            "signin_time" : "09:00:00",     string,签到时间
                            "signout_time" : "09:00:00",    string,签退时间
                            "late_mins" : 30,           int,迟到时长 单位/分钟
                            "early_leave_mins" : 30,    int,早退时长 单位/分钟
                            "over_work_mins" : 30,      int,加班时长 单位/分钟
                            "forget_sigin_times" : 1,        int,漏打卡次数,每个规则最大2次,2次即为缺勤
                            "absent_times" : 0,         int,缺勤次数,每个规则最大缺勤次数一次
                            "resign_times" : 0,         int,补签次数
                            "is_leave" : 0              int,是否请假
                        }, ...
                    ]
                    "others":{                          其他统计数据
                        "total_late_mins" : 30,         int,所有迟到分钟和
                        "total_late_times" : 30,        int,所有迟到人数和
                        "total_early_leave_mins" : 30,  int,所有早退分钟和
                        "total_early_leave_times" : 30, int,所有早退人数和
                        "total_over_work_mins" : 30,    int,所有加班分钟和
                        "total_over_work_times" : 30,   int,所有加班人数和
                        "total_forget_sigin_times" : 30,     int,所有漏打卡次数
                        "total_absent_times" : 30,      int,所有缺勤次数
                        "total_leave_days" : 30         int,所有请假天数
                    }
                }
            }
            失败 - {"code": <非0>, "msg": "错误说明", "user_visible": false}
         */
        void QueryAttendanceList(string cond, out string result);

        /**
         * @brief  QueryTodayAttendanceList 查询今日考勤记录列表
         * @since  V1.20200409
         *
         * @param cond 搜索相关信息
            example:
            {

                "page_no": 1,           必填,int,页号
                "page_size": 10,        必填,int,每页个数
                "org_id" : 1,           必填,int,组织ID
                "operator": "jobs",     必填,string,操作者
                "query_cond": {
                    "lib_id":1,                 选填,int,底库id
                    "rule_id":1,                选填,int,考勤规则ID
                    "state":0                   选填,int,异常状态 1-迟到 3-漏打卡 5-请假
                }
            }
         * @param result 成功或失败。例：
            成功 - 返回对应结果
            {
                "code": 0, 
                "info": {
                    "page_no":xx,
                    "page_size":xx,
                    "total_count":xx,
                    "items": [
                        {
                            "org_id" : 1,               int,组织ID
                            "people_id" : 1,            int,人员ID
                            "people_name" : "xxx",      string,人员名称
                            "lib_id" : 1,               int,人员ID
                            "lib_name" : "xxx",         string,人员名称
                            "rule_id" : 1,              int,考勤规则ID
                            "rule_name" : "",           string,考勤规则名称
                            "signin_time" : "2020-04-01 09:00:00",     string,签到时间
                            "state" : 0                 int,1-迟到 3-漏打卡 5-迟到
                        }, ...
                    ]
                    "others":{                          其他统计数据
                        "total_late_times" : 30,        int,所有迟到人数和
                        "total_forget_sigin_times" : 30,     int,所有漏打卡次数
                        "total_people" : 30,            int,所有考勤人员数
                        "total_leave_times" : 30        int,所有请假人次
                    }
                }
            }
            失败 - {"code": <非0>, "msg": "错误说明", "user_visible": false}
         */
        void QueryTodayAttendanceList(string cond, out string result);

        /**
         * @brief  QueryAttendanceMainPage 查询首页考勤记录统计
         * @since  V1.20200409
         *
         * @param cond 搜索相关信息
            example:
            {

                "site_list" : "1,2",        必填,string,店铺ID列表
                "begin_date":"2020-04-01",  必填,string,开始时间
                "end_date":"2020-04-01",    必填,string,结束时间
                "org_id" : 1,               必填,int,组织ID
                "operator": "jobs",         必填,string,操作者
            }
         * @param result 成功或失败。例：
            成功 - 返回对应结果
            {
                "code": 0, 
                "info": {
                    "resign_count" : 30,            int,补签总和
                    "late_count" : 30,              int,迟到总和
                    "absent_count" : 30,            int,旷工总和
                    "sign_count" : 30,              int,正常总和
                    "record_count" : 30             int,记录总和
                }
            }
            失败 - {"code": <非0>, "msg": "错误说明", "user_visible": false}
         */
        void QueryAttendanceMainPage(string cond, out string result);
/*****************************************考勤相关接口结束*************************************/
    };
};
