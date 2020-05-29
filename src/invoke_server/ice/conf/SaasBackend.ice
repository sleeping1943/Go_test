/**
 * @file IceSaaSBackend.ice
 * @brief  The backend admin interface of software as a service
 * @author ZhuMingsheng <mingsheng.zhu@nazhiai.com>
 * @company www.nazhiai.com
 * @version 1.0.0
 * @date 2019/10/15
 */
#pragma once


module Saas
{
    /**
     * @brief SaaS后台管理接口定义
     */
    interface ISaasBackend
    {
        /*----------------------------------------------------------------------
          管理员账号管理方法
         ---------------------------------------------------------------------*/
        /**
         * @brief  Login 管理员登录
         * @since  2019/10/15
         *
         * @param admin 管理员信息。
            example:
            {
                "username": "admin",    必填,string,登录名。
                "password": "md5"       必填,string,MD5加密的密码。
            }
         * @param result 成功或失败。例：
            成功 - 返回对应的结果
            {
                "code":0,
                "info":{
                    "admin_id":1,
                    "username":"admin",
                    "level":0,
                    "permission":"",
                    "remark":"xxx",
                    "creator":"",
                    "last_login_time":"2019-10-28 18:18:12"
                }
            }
            失败 - {"code": <非0>, "message": "错误说明", "visible": false}
         */
        void Login(string admin, out string result);

        /**
         * @brief  AddAdmin 添加管理员
         * @since  2019/10/15
         *
         * @param admin 管理员信息。
            example:
            {
                "username": "admin",    必填,string,管理员名称，只能由字母和数字组成
                "password": "md5",      必填,string,管理员密码，MD5加密的密码
                "level": 0,             选填,int,管理员级别,1:超级管理员,2:高级管理员,3:普通管理员
                "permission": "",       必填,string,权限
                "remark": "xxx"         选填,string,备注
                "operator": "admin",    必填,string,操作者，即当前登录的账号。
            }
         * @param result 成功或失败。例：
            成功 - {"code": 0, "info": {"admin_id": 1}}
            失败 - {"code": <非0>, "message": "错误说明", "visible": false}
         */
        void AddAdmin(string admin, out string result);

        /**
         * @brief  UpdateAdmin 更新管理员信息
         * @since  2019/10/15
         *
         * @param admin 管理员信息。
            example:
            {
                "admin_id": 1,          必填,int,管理员ID
                "password": "md5",      选填,string,管理员密码，MD5加密的密码
                "level":0,              选填,int,管理员级别,1:超级管理员,2:高级管理员,3:普通管理员
                "permission": "",       必填,string,权限
                "remark": "xxx"         选填,string,备注。
                "operator": "admin",    必填,string,操作者，即当前登录的账号。
            }
         * @param result 成功或失败。例：
            成功 - {"code": 0}
            失败 - {"code": <非0>, "message": "错误说明", "visible": false}
         */
        void UpdateAdmin(string admin, out string result);

        /**
         * @brief  DeleteAdmin 删除管理员
         * @since  2019/10/15
         *
         * @param admin 管理员信息。
            example:
            {
                "admin_id": 1,          必填,int,管理员ID
                "operator": "admin",    必填,string,操作者，即当前登录的账号。
            }
         * @param result 成功或失败。例：
            成功 - {"code": 0}
            失败 - {"code": <非0>, "message": "错误说明", "visible": false}
         */
        void DeleteAdmin(string admin, out string result);

        /**
         * @brief  QueryAdminList 查询管理员列表
         * @since  2019/10/15
         *
         * @param cond 查询条件。
            example:
            {
                "page_no": 1,           必填,int,页号
                "page_size": 10,        必填,int,每页个数
                "operator": "admin",    必填,string,操作者
                "query_cond": {
                    "username": "xx",   选填,string,管理员名称，支持模糊匹配
                    "level": 0          选填,int,管理员级别,1:超级管理员,2:高级管理员,3:普通管理员
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
                            "admin_id": 1,
                            "username": "xx",
                            "level": 0,
                            "permission": "",
                            "remark": "auxiliary",
                            "creator": "admin",
                            "create_time": "2019-10-20 08:12:12"
                        }, ...
                    ]
                }
            }
            失败 - {"code": <非0>, "message": "错误说明", "visible": false}
         */
        void QueryAdminList(string cond, out string result);


        /*----------------------------------------------------------------------
          用户账号管理
         ---------------------------------------------------------------------*/
        /**
         * @brief  AddUser 添加用户信息
         * @since  2019/11/26
         *
         * @param user 用户信息。
            example:
            {
                "username": "jobs",     必填,string,用户名
                "password": "md5",      必填,string,用户密码，MD5加密的密码
                "mobile": "13300000001",必填,string,手机号码
                "state": 1,             选填,int,锁定状态,1:正常,2:锁定
                "operator": "admin",    必填,string,操作者，即当前登录的账号。
            }
         * @param result 成功或失败。例：
            成功 - {"code": 0, "info": {"user_id": 1}}
            失败 - {"code": <非0>, "message": "错误说明", "visible": false}
         */
        void AddUser(string user, out string result);

        /**
         * @brief  UpdateUser 更新用户信息
         * @since  2019/10/15
         * @update 2020/04/10 锁定状态不予修改
         *
         * @param user 用户信息。
            example:
            {
                "user_id": 1,           必填,int,用户ID
                "password": "md5",      选填,string,用户密码，MD5加密的密码
                "mobile": "13300000001",选填,string,手机号码
                "operator": "admin",    必填,string,操作者，即当前登录的账号。
            }
         * @param result 成功或失败。例：
            成功 - {"code": 0}
            失败 - {"code": <非0>, "message": "错误说明", "visible": false}
         */
        void UpdateUser(string user, out string result);

        /**
         * @brief  DeleteUser 删除用户
         * @since  2019/10/15
         *
         * @param user 用户信息。
            example:
            {
                "user_id": 1,           必填,int,用户ID
                "operator": "admin",    必填,string,操作者，即当前登录的账号。
            }
         * @param result 成功或失败。例：
            成功 - {"code": 0}
            失败 - {"code": <非0>, "message": "错误说明", "visible": false}
         */
        void DeleteUser(string user, out string result);

        /**
         * @brief  LockUser 锁定/解锁用户
         * @since  2020/04/10
         * @update 2020/05/07
         *
         * @param user 用户信息。
            example:
            {
                "user_id": 1,           必填,int,用户ID
                "state" :1,             必填,int,1:正常2:锁定
                "operator": "admin",    必填,string,操作者，即当前登录的账号。
            }
         * @param result 成功或失败。例：
            成功 - {"code": 0}
            失败 - {"code": <非0>, "message": "错误说明", "visible": false}
         */
        void LockUser(string user, out string result);

        /**
         * @brief  QueryUserList 查询用户列表
         * @since  2019/10/15
         * @update 2020/03/11 修改查询结果
         *
         * @param cond 查询条件。
            example:
            {
                "page_no": 1,           必填,int,页号
                "page_size": 10,        必填,int,每页个数
                "operator": "admin",    必填,string,操作者
                "query_cond": {
                    "username": "xx",   选填,string,账号名称，支持精确匹配
                    "mobile": "xx",     选填,string,手机号，支持精确匹配
                    "state": 0          选填,int,锁定状态,1:正常,2:锁定
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
                            "user_id": 1,       int,用户ID
                            "username": "xx",   string,用户姓名
                            "mobile": "",       string,手机号
                            "state": 0,         int,用户状态
                            "org_id": 1,        int,组织ID
                            "site_count": 1,    int,组织地点数量
                        }, ...
                    ]
                }
            }
            失败 - {"code": <非0>, "message": "错误说明", "visible": false}
         */
        void QueryUserList(string cond, out string result);


        /*----------------------------------------------------------------------
          组织地点管理
         ---------------------------------------------------------------------*/
        /**
         * @brief  AddSite 添加组织地点
         * @since  2019/10/15
         * @update 2019/12/16 修改接口名AddCompany为AddSite，company_id为site_id
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
                "remark": "xx",             选填,string,备注
                "user_id": 1,               必填,int,指定用户ID
                "operator": "jobs",         必填,string,操作者，即当前登录的账号。
            }
         * @param result 成功或失败。例：
            成功 - {"code": 0, "info": {"site_id": 1}}
            失败 - {"code": <非0>, "message": "错误说明", "visible": false}
         */
        void AddSite(string site, out string result);

        /**
         * @brief  UpdateSite 更新组织地点信息
         * @since  2019/10/15
         * @update 2019/12/16 修改接口名AddCompany为AddSite，company_id为site_id
         *
         * @param site 地点信息。
            example:
            {
                "site_id": 1,               必填,int,组织地点ID
                "name": "nise",             选填,string,名称
                "abbreviate": "nise",       选填,string,简称
                "province": 100000,         选填,int,省级代码
                "city": 100100,             选填,int,市级代码
                "region": 100101,           选填,int,区级代码
                "address": "",              选填,string,详细地址
                "industry": 1,              选填,int,所属行业
                "staff_size": 1,            选填,int,人员规模，1：20人以下，2：21人~50人，3：51人~200人，4：201人~500人，5:500人以上
                "flow_scale": 1,            选填,int,客流规模，1：200人以下，2：201人~500人，3：501人~2000人，4：2001人~5000人，5:5000人以上
                "leader": "Li",             选填,string,负责人
                "phone": "023-78455000",    选填,string,负责人电话
                "remark": "xx",             选填,string,备注
                "operator": "jobs",         必填,string,操作者，即当前登录的账号。
            }
         * @param result 成功或失败。例：
            成功 - {"code": 0}
            失败 - {"code": <非0>, "message": "错误说明", "visible": false}
         */
        void UpdateSite(string site, out string result);

        /**
         * @brief  DeleteSite 删除地点
         * @since  2019/10/15
         * @update 2019/12/16 修改接口名DeleteCompany为DeleteSite，company_id为site_id
         *
         * @param site 地点信息。
            example:
            {
                "site_id": 1,           必填,int,地点ID
                "operator": "admin",    必填,string,操作者，即当前登录的账号。
            }
         * @param result 成功或失败。例：
            成功 - {"code": 0}
            失败 - {"code": <非0>, "message": "错误说明", "visible": false}
         */
        void DeleteSite(string site, out string result);

        /**
         * @brief  BatchDeleteSite 批量删除地点信息
         * @since  2019/10/15
         *
         * @param site 地点信息。
            example:
            {
                "site_list": "1,2",     必填,string,组织地点ID列表
                "operator": "admin",    必填,string,操作者，即当前登录的账号。
            }
         * @param result 成功或失败。例：
            成功 - {"code": 0}
            失败 - {"code": <非0>, "message": "错误说明", "visible": false}
         */
        void BatchDeleteSite(string site, out string result);

        /**
         * @brief  QuerySiteList 查询地点列表
         * @since  2019/10/15
         * @update 2020/01/09 增加查询条件
         * @update 2020/03/11 修改查询结果
         *
         * @param cond 查询条件。
            example:
            {
                "page_no": 1,           必填,int,页号
                "page_size": 10,        必填,int,每页个数
                "operator": "admin",    必填,string,操作者
                "query_cond": {
                    "user_id": 1,       选填,int,用户ID
                    "username": "",     选填,string,用户名，精确匹配
                    "site": "xx",       选填,string,地点简称，支持模糊匹配
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
                            "site_id": 1,       // 地点ID
                            "name": "jobs",     // 地点名称
                            "abbreviate": "",   // 地点简称
                            "province": 100000, // 省级代码
                            "city": 100100,     // 市级代码
                            "region": 100101,   // 区级代码
                            "address": "",      // 详细地址
                            "full_address": "", // string,完整路径
                            "industry": 1,      // 所属行业
                            "staff_size": 1,    // 人员规模，1：20人以下，2：21人~50人，3：51人~200人，4：201人~500人，5:500人以上
                            "flow_scale": 1,    // 客流规模，1：200人以下，2：201人~500人，3：501人~2000人，4：2001人~5000人，5:5000人以上
                            "leader": "Li",     // 负责人
                            "phone": "023-78455000",// 负责人电话
                            "remark": "xx",     // 备注
                            "create_time": "",  // 创建时间
                            "user_id": 1,       // 归属用户id
                            "username": "",     // 归属用户名
                            "dev_count": 10,    // 设备数
                            "lib_count": 10,    // 底库数
                            "people_count": 10  // 底库人数
                        }, ...
                    ]
                }
            }
            失败 - {"code": <非0>, "message": "错误说明", "visible": false}
         */
        void QuerySiteList(string cond, out string result);

        /*----------------------------------------------------------------------
          订单管理
         ---------------------------------------------------------------------*/
        /**
         * @brief  AddOrder 添加订单（新购/续订）
         * @since  2019/12/16
         * @update 2020/01/07 增加套餐描述字段
         *
         * @param order 订单信息。
            example:
            {
                "cmd": "SubscribeInform",   必填,string,业务类型,新购:Subscribe,订购通知:SubscribeInform,续订:Renew
                "instance_id": "",      必填,string,实例ID
                "order_id": "",         必填,string,订单ID
                "pricing_id": "",       必填,string,套餐ID,如:wisdomwatch0000001
                "pricing_name": "",     必填,string,套餐描述
                "count": "",            必填,string,订购的数量，需求讨论结果只能是1
                "volume": "",           必填,string,订购的周期，单位：月
                "expire_date": "",      选填,string,过期时间（毫秒数）,由订单创建时间和订购周期计算得出，与订单实际过期时间有误差， 仅供参考
                "mobile": "",           必填,string,用户手机号
                "operator": "admin",    必填,string,操作者，即当前登录的账号。
            }
         * @param result 成功或失败。例：
            成功 - {"code": 0}
            失败 - {"code": <非0>, "message": "错误说明", "visible": false}
         */
        void AddOrder(string order, out string result);

        /**
         * @brief  CancelOrder 取消订单（退订）
         * @since  2019/12/16
         *
         * @param order 订单信息。
            example:
            {
                "instance_id": "",      必填,string,实例ID
                "order_id": "",         必填,string,订单ID
                "mobile": "",           必填,string,用户手机号
                "operator": "admin",    必填,string,操作者，即当前登录的账号。
            }
         * @param result 成功或失败。例：
            成功 - {"code": 0}
            失败 - {"code": <非0>, "message": "错误说明", "visible": false}
         */
        void CancelOrder(string order, out string result);

        /**
         * @brief  ProcessOrder 处理订单
         * @since  2020/01/07
         * @update 2020/03/11 增加地址信息
         *
         * @param info 处理信息。
            example:
            {
                "id": 0,                必填,int,订单记录ID
                "site" : {
                    "site_id": 0,       选填,int,组织地点id，与name二选一
                    "name": "",         选填,string,组织地点，只能由字母和数字组成
                    "province": 100000, 选填,int,省级代码
                    "city": 100100,     选填,int,市级代码
                    "region": 100101,   选填,int,区级代码
                    "address": ""       选填,string,详细地址
                },
                "camera": {
                    "name": "xxx",      选填,string,设备名称
                    "serialno": "xxxx"  必填,string,设备序列号
                },
                "operator": "admin"     必填,string,操作者，即当前登录的账号。
            }
         * @param result 成功或失败。例：
            成功 - 返回对应的结果
            {
                "code": 0,
                "info": {
                    "camera_id": 2,     int,摄像头ID
                    "site_id": 1,       int,安装地点ID
                }
            失败 - {"code": <非0>, "message": "错误说明", "visible": false}
         */
        void ProcessOrder(string info, out string result);

        /**
         * @brief  GetOrderInfo 查询订单信息
         * @since  2020/03/11
         *
         * @param cond 查询条件。
            example:
            {
                "id": 1,                必填,int,订单记录ID
            }
         * @param result 成功或失败。例：
            成功 - 返回对应的结果
            {
                "code": 0,
                "info": {
                    "id": 0,                int,订单记录ID
                    "order_id": "",         string,订单ID
                    "type": 0,              int,订单类型,1:新购,2:续订
                    "pricing": 0,           int,套餐类型,参见《PricingType》
                    "count": 1,             int,订购的数量
                    "volume": 36,           int,订购的周期，单位：月
                    "expire_date": "",      int,过期时间（毫秒数）,由订单创建时间和订购周期计算得出，与订单实际过期时间有误差， 仅供参考
                    "mobile": "",           string,用户手机号
                    "state": 0,             int,状态,参见《OrderState》
                    "process_time": "",     string,处理时间
                    "create_time": "",      string,创建时间（即订购时间）
                    "site" : {
                        "org_id": 1,        int,组织ID
                        "site_id": 1,       int,组织地点ID
                        "name": "",         string,组织地点，只能由字母和数字组成
                        "province": 100000, int,省级代码
                        "city": 100100,     int,市级代码
                        "region": 100101,   int,区级代码
                        "address": "",      string,详细地址
                        "full_address": "", string,完整路径
                    },
                    "camera": {
                        "serialno": "xxxx", string,设备序列号
                        "online": true,     bool,在线状态
                    }
                }
            }
            失败 - {"code": <非0>, "message": "错误说明", "visible": false}
         */
        void GetOrderInfo(string cond, out string result);

        /**
         * @brief  QueryOrderList 查询订单列表
         * @since  2020/01/07
         * @update 2020/03/11 增加地址信息
         *
         * @param cond 查询条件。
            example:
            {
                "page_no": 1,           必填,int,页号
                "page_size": 10,        必填,int,每页个数
                "operator": "admin",    必填,string,操作者，即当前登录的账号。
                "query_cond": {
                    "mobile": "xx",     选填,string,手机号
                    "state": 0,         选填,int,状态,参见《OrderState》
                    "near_expire": "xx",选填,string,过期日期
                    "valid": 1,         选填,int,0-全部订单 1-有效 2-失效
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
                            "id": 0,                int,订单记录ID
                            "order_id": "",         string,订单ID
                            "type": 0,              int,订单类型,1:新购,2:续订
                            "pricing": 0,           int,套餐类型,参见《PricingType》
                            "count": 1,             int,订购的数量
                            "volume": 36,           int,订购的周期，单位：月
                            "expire_date": "",      int,过期时间（毫秒数）,由订单创建时间和订购周期计算得出，与订单实际过期时间有误差， 仅供参考
                            "mobile": "",           string,用户手机号
                            "state": 0,             int,状态,参见《OrderState》
                            "process_time": "",     string,处理时间
                            "create_time": "",      string,创建时间（即订购时间）
                            "user": {
                                "user_id": 1,       int,用户id
                                "username": "",     string,用户名
                            },
                            "site" : {
                                "org_id": 1,        int,组织ID
                                "site_id": 1,       int,组织地点ID
                                "name": "",         string,组织地点，只能由字母和数字组成
                                "province": 100000, int,省级代码
                                "city": 100100,     int,市级代码
                                "region": 100101,   int,区级代码
                                "address": "",      string,详细地址
                                "full_address": "", string,完整路径
                            }
                        }, ...
                    ]
                }
            }
            失败 - {"code": <非0>, "message": "错误说明", "visible": false}
         */
        void QueryOrderList(string cond, out string result);

        /*----------------------------------------------------------------------
          抓拍机管理
         ---------------------------------------------------------------------*/
        /**
         * @brief  AddCamera 添加抓拍机
         * @since  2020/01/01
         *
         * @param camera 抓拍机信息。
            example:
            {
                "name": "xx",           必填,string,抓拍机名称
                "serialno": "xxxx"      必填,string,序列号
                "remark": "xx",         选填,string,备注
                "site_id": 1,           必填,int,组织地点ID
                "operator": "jobs",     必填,string,操作者，即当前登录的账号。
            }
         * @param result 成功或失败。例：
            成功 - {"code": 0, "info": {"camera_id": 1}}
            失败 - {"code": <非0>, "message": "错误说明", "visible": false}
         */
        void AddCamera(string camera, out string result);

        /**
         * @brief  UpdateCamera 更新抓拍机信息
         * @since  2020/01/01
         *
         * @param camera 抓拍机信息。
            example:
            {
                "camera_id": 1,         必填,int,抓拍机ID
                "name": "xx",           必填,string,设备名称
                "remark": "xx",         选填,string,备注
                "operator": "jobs",     必填,string,操作者，即当前登录的账号。
            }
         * @param result 成功或失败。例：
            成功 - {"code": 0}
            失败 - {"code": <非0>, "message": "错误说明", "visible": false}
        */
        void UpdateCamera(string camera, out string result);

        /**
         * @brief  DeleteCamera 删除抓拍机
         * @since  2020/01/01
         *
         * @param camera 抓拍机信息。
            example:
            {
                "camera_id": 1,         必填,int,抓拍机ID
                "site_id": 1,           必填,int,组织地点ID
                "operator": "jobs",     必填,string,操作者，即当前登录的账号。
            }
         * @param result 成功或失败。例：
            成功 - {"code": 0}
            失败 - {"code": <非0>, "message": "错误说明", "visible": false}
        */
        void DeleteCamera(string camera, out string result);

        /**
         * @brief  BatchDeleteCamera 批量删除抓拍机
         * @since  2020/01/01
         *
         * @param camera 设备信息。
            example:
            {
                "camera_list": "1,2",   必填,string,设备ID列表
                "site_id": 1,           必填,int,组织地点ID
                "operator": "jobs",     必填,string,操作者，即当前登录的账号。
            }
         * @param result 成功或失败。例：
            成功 - {"code": 0}
            失败 - {"code": <非0>, "message": "错误说明", "visible": false}
        */
        void BatchDeleteCamera(string camera, out string result);

        /**
         * @brief  QueryCameraList 查询抓拍机列表
         * @since  2020/01/01
         * @update 2020/01/09 修改查询条件，以及返回结果
         * @update 2020/03/11 修改查询结果
         * @update 2020/04/20  套餐过滤标识、热力图映射标识
         *
         * @param cond 查询条件。
            example:
            {
                "page_no": 1,           必填,int,页号
                "page_size": 10,        必填,int,每页个数
                "operator": "jobs",     必填,string,操作者，即当前登录的账号。
                "query_cond": {
                    "name": "xx",       选填,string,设备名称，支持模糊匹配
                    "serialno": "",     选填,string,设备序列号，支持精确匹配
                    "site_id": 0,       选填,int,安装地点ID
                    "username": "",     选填,string,用户名，精确匹配
                    "pricing": 1,       选填,int,套餐标识
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
                            "pricing": 1,       // 套餐标识
                            "remark": "xx",     // 备注
                            "online": true,     // 在线状态
                            "create_time": "",  // 创建时间
                            "heatmap": true,    // 热力图映射标识,false:未设定热力图,true:已设定热力图
                            "user": {
                                "user_id": 1,       int,用户id
                                "username": "",     string,用户名
                                "mobile": ""        string,手机号
                            },
                            "site": {
                                "org_id": 1,        int,组织ID
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
                                "expire_date": "2022-01-01 00:00:00"
                            }
                        }, ...
                    ]
                }
            }
            失败 - {"code": <非0>, "message": "错误说明", "visible": false}
        */
        void QueryCameraList(string cond, out string result);

        /*----------------------------------------------------------------------
          操作记录管理
         ---------------------------------------------------------------------*/
         /**
         * @brief  QueryOperateList 查询操作记录
         * @since  2020/04/14
         *
         * @param cond 条件。
            example:
            {
                "page_no": 1,           必填,int,页号
                "page_size": 10,        必填,int,每页个数
                "admin_id": 1,          必填,int,管理员id
                "query_cond": {
                    "type": 1,          填填,int,变更类型，1:订单状态变更,2:用户信息变更,3:店铺信息变更,4:设备信息变更
                    "username":"xx"     选填,string,用户名
                    "site_name":"xx"    选填,string,店铺关键,支持模糊查询
                    "serialno":"xx"     选填,string,设备序列号
                }
            }
            描述：
            for type 变更类型
            2.用户信息变更
            {
                "username": "xx"    选填,string,用户名
            }
            3.店铺信息变更
            {
                "username": "xx"    选填,string,用户名
                "site_name": "xx"   选填,string,店铺关键,支持模糊查询
            }
            4.设备信息变更
            {
                "serialno": "xx"    选填,string,设备序列号
            }
         * @param result 成功或失败。例：
            成功
            {
                "code": 0,
                "info": {
                    "page_no": 1,
                    "page_size": 10,
                    "total_count": 32,
                    "items": [
                        {
                            "username": "xx",   // 用户名
                            "usertype": 1,      // 用户类型，1:系统 2:管理员 3:用户
                            "type": 1,          // 变更类型，1:订单状态变更,2:用户信息变更,3:店铺信息变更,4:设备信息变更
                            "notes": "xx",      // 变更内容
                            "create_time": "2019-10-20 08:12:12"
                        }, ...
                    ]
                }
            }
            失败 - {"code": <非0>, "message": "错误说明", "visible": false}
        */
        void QueryOperateList(string cond, out string result);

        /*----------------------------------------------------------------------
                                        热力图管理
         ----------------------------------------------------------------------*/
        /**
         * @brief  GetCameraScene 获取摄像头场景图
         * @since  2020/04/20
         *
         * @param cond 摄像头信息
            example:
            {
                "camera_id": 1,       必填,int,摄像头id
                "org_id": 1,          必填,int,组织id
                "operator": "xxx"     必填,string,操作员名称
            }
         * @param result 成功或失败。例:
            成功 - 返回对应的结果
            {
                "code": 0,
                "info":
                {
                    "scene_url: ""  string,摄像头场景图
                }
            }
            失败 - {"code": <非0>, "msg": "错误说明", "user_visible": false}
        */
        void GetCameraScene(string cond, out string result);

        /**
         * @brief  AddHeatmap 新增热力图
         * @since  2020/04/20
         *
         * @param info 点映射信息
            example:
            {
                "name": "",                 必填,string,映射标识
                "panorama_url": "",         必填,string,全景图地址
                "collect_interval": 1,      必填,int,数据采集间隔
                "mapping_relation": [
                    {
                        "camera_id": 1,     必填,int,摄像头id
                        "scene_url": "",    必填,string,摄像头场景图地址
                        "mapping": "{}",    必填,json-string,json格式的属性字段
                    }
                    ...
                ],
                "site_id": 1,       必填,int,组织地点id
                "org_id": 1,        必填,int,组织id
                "operator":"xxx"    必填,string,操作员名称
            }
                [字段] mapping 取值:
                {
                    "camera": {   //摄像头场景图上瞄点采用逆时针方向选取A,B,C,D
                        "ratio": {
                            "width":0.2,   必填,float,场景图缩放比例
                            "height":0.2,  必填,float,场景图缩放比例
                        },
                        "polygon": {
                            "Ax": 1,        必填,int,A点x坐标
                            "Ay": 1,        必填,int,A点y坐标
                            "Bx": 1,        必填,int,B点x坐标
                            "By": 1,        必填,int,B点y坐标
                            "Cx": 1,        必填,int,C点x坐标
                            "Cy": 1,        必填,int,C点y坐标
                            "Dx": 1,        必填,int,D点x坐标
                            "Dy": 1         必填,int,D点y坐标
                        }
                    },
                    "panorama": {      //全景图上瞄点采用逆时针方向选取A,B,C,D
                        "ratio": {
                            "width":0.2,   必填,float,全景图缩放比例
                            "height":0.2,  必填,float,全景图缩放比例
                        }
                        "polygon": {
                            "Ax": 1,        必填,int,A点x坐标
                            "Ay": 1,        必填,int,A点y坐标
                            "Bx": 1,        必填,int,B点x坐标
                            "By": 1,        必填,int,B点y坐标
                            "Cx": 1,        必填,int,C点x坐标
                            "Cy": 1,        必填,int,C点y坐标
                            "Dx": 1,        必填,int,D点x坐标
                            "Dy": 1         必填,int,D点y坐标
                        }
                    }
                }
         * @param result 成功或失败。例:
            成功 - {"code": 0}
            失败 - {"code": <非0>, "msg": "错误说明", "user_visible": false}
        */
        void AddHeatmap(string info, out string result);

        /**
         * @brief  UpdateHeatmap 修改热力图
         * @since  2020/04/20
         *
         * @para info 点映射信息
            example:
            {
                "heatmap_id": 1,            必填,int,热力图映射id
                "name": "",                 必填,string,映射标识
                "panorama_url": "",         必填,string,全景图地址
                "collect_interval": 1,      必填,int,数据采集间隔
                "mapping_relation":[
                    {
                        "camera_id": 1,     必填,int,摄像头id
                        "scene_url": "",    必填,string,摄像头场景图地址
                        "mapping": "{}",    必填,json-string,json格式的属性字段
                    }
                    ...
                ],
                "site_id": 1,       必填,int,组织地点id
                "org_id": 1,        必填,int,组织id
                "operator":"xxx"    必填,string,操作员名称
            }
                [字段] mapping 取值:
                {
                    "camera": {   //摄像头场景图上瞄点采用逆时针方向选取A,B,C,D
                        "ratio": {
                            "width":0.2,   必填,float,场景图缩放比例
                            "height":0.2,  必填,float,场景图缩放比例
                        }
                        "polygon": {
                            "Ax": 1,        必填,int,A点x坐标
                            "Ay": 1,        必填,int,A点y坐标
                            "Bx": 1,        必填,int,B点x坐标
                            "By": 1,        必填,int,B点y坐标
                            "Cx": 1,        必填,int,C点x坐标
                            "Cy": 1,        必填,int,C点y坐标
                            "Dx": 1,        必填,int,D点x坐标
                            "Dy": 1         必填,int,D点y坐标
                        }
                    },
                    "panorama": {      //全景图上瞄点采用逆时针方向选取A,B,C,D
                        "ratio": {
                            "width":0.2,   必填,float,全景图缩放比例
                            "height":0.2,  必填,float,全景图缩放比例
                        }
                        "polygon": {
                            "Ax": 1,        必填,int,A点x坐标
                            "Ay": 1,        必填,int,A点y坐标
                            "Bx": 1,        必填,int,B点x坐标
                            "By": 1,        必填,int,B点y坐标
                            "Cx": 1,        必填,int,C点x坐标
                            "Cy": 1,        必填,int,C点y坐标
                            "Dx": 1,        必填,int,D点x坐标
                            "Dy": 1         必填,int,D点y坐标
                        }
                    }
                }
         * @para result 成功或失败。例:
            成功 - {"code": 0}
            失败 - {"code": <非0>, "msg": "错误说明", "user_visible": false}
        */
        void UpdateHeatmap(string info, out string result);

        /**
         * @brief  DeleteHeatmap 删除热力图
         * @since  2020/04/20
         *
         * @para info 点映射信息
            example:
            {
                "heatmap_id": 1,    必填,int,记录id
                "site_id": 1,       必填,int,组织地点id
                "org_id": 1,        必填,int,组织id
                "operator":"xxx"    必填,string,操作员名称
            }
         * @para result 成功或失败。例:
            成功 - {"code": 0}
            失败 - {"code": <非0>, "msg": "错误说明", "user_visible": false}
        */
        void DeleteHeatmap(string info, out string result);

        /**
         * @brief  QueryHeatmapList 获取热力图列表
         * @since  2020/04/20
         *
         * @para cond 查询条件
            example:
            {
                "page_no": 1,           必填,int,页号
                "page_size": 1,         必填,int,每页个数
                "org_id": 1,            必填,int,组织id
                "operator":"xxx"        必填,string,操作员名称
                "site_id": 1,           选填,int,组织地点id
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
                            "org_id": 1,                int,组织id
                            "organization": "",         string,组织名
                            "site_id" 1,                int,组织地址id
                            "site": "name",             string,组织地址名
                            "create_time": "2019-07-17 14:00:00"    string,创建时间
                        }
                    ]
                }
            }
            失败 - {"code": <非0>, "msg": "错误说明", "user_visible": false}
        */
        void QueryHeatmapList(string cond, out string result);

        /**
         * @brief  QueryHeatmapDetail 获取热力图详细信息
         * @since  2020/04/20
         *
         * @para cond 查询条件
            example:
            {
                "heatmap_id": 1,        必填,int,热力图图id
                "org_id": 1,            必填,int,组织id
                "site_id": 1,           必填,int,组织地点id
                "operator":"xxx"        必填,string,操作员名称
            }
         * @para result 成功或失败。例:
            成功 - 返回对应的结果
            {
                "code": 0,
                "info":
                {
                    "heatmap_id": 1,            int,映射id
                    "name": "",                 string,映射标识
                    "panorama_url": 1,          string,公司全景图
                    "site_id": 1,               int,组织地点id
                    "site": "name",             string,组织地址名
                    "mapping_relation":[
                        {
                            "camera_id": 1,     必填,int,摄像头id
                            "scene_url": "",    必填,string,摄像头场景图地址
                            "mapping": "{}",    必填,json-string,json格式的属性字段
                        }
                        ...
                    ],
                    "create_time": "2019-07-17 14:00:00"    string,创建时间
                }
            }
                [字段] mapping 取值:
                {
                    "camera": {   //摄像头场景图上瞄点采用逆时针方向选取A,B,C,D
                        "ratio": {
                            "width":0.2,   必填,float,场景图缩放比例
                            "height":0.2,  必填,float,场景图缩放比例
                        }
                        "polygon": {
                            "Ax": 1,        必填,int,A点x坐标
                            "Ay": 1,        必填,int,A点y坐标
                            "Bx": 1,        必填,int,B点x坐标
                            "By": 1,        必填,int,B点y坐标
                            "Cx": 1,        必填,int,C点x坐标
                            "Cy": 1,        必填,int,C点y坐标
                            "Dx": 1,        必填,int,D点x坐标
                            "Dy": 1         必填,int,D点y坐标
                        }
                    },
                    "panorama": {      //全景图上瞄点采用逆时针方向选取A,B,C,D
                        "ratio": {
                            "width":0.2,   必填,float,全景图缩放比例
                            "height":0.2,  必填,float,全景图缩放比例
                        }
                        "polygon": {
                            "Ax": 1,        必填,int,A点x坐标
                            "Ay": 1,        必填,int,A点y坐标
                            "Bx": 1,        必填,int,B点x坐标
                            "By": 1,        必填,int,B点y坐标
                            "Cx": 1,        必填,int,C点x坐标
                            "Cy": 1,        必填,int,C点y坐标
                            "Dx": 1,        必填,int,D点x坐标
                            "Dy": 1         必填,int,D点y坐标
                        }
                    }
                }
            失败 - {"code": <非0>, "msg": "错误说明", "user_visible": false}
        */
        void QueryHeatmapDetail(string cond, out string result);

        /**
         * @brief  QueryCameraMappingInfo 查询指定摄像头映射信息
         * @since  2020/04/20
         *
         * @para cond 查询条件
            example:
            {
                "camera_id": 1,         必填,int,摄像头id
                "org_id": 1,            必填,int,组织id
                "site_id": 1,           必填,int,组织地点id
                "operator":"xxx"        必填,string,操作员名称
            }
         * @para result 成功或失败。例:
            成功 - 返回对应的结果
            {
                "code": 0,
                "info":
                {
                    "camera_id": 1,     int,摄像头id
                    "camera_name": "",  string,摄像头名
                    "scene_url": "",    string,摄像头场景图地址
                    "mapping": "{}",    json-string,json格式的属性字段
                } 
            }
            [字段] mapping 取值:
                {
                    "camera": {   //摄像头场景图上瞄点采用逆时针方向选取A,B,C,D
                        "ratio": {
                            "width":0.2,   必填,float,场景图缩放比例
                            "height":0.2,  必填,float,场景图缩放比例
                        }
                        "polygon": {
                            "Ax": 1,        必填,int,A点x坐标
                            "Ay": 1,        必填,int,A点y坐标
                            "Bx": 1,        必填,int,B点x坐标
                            "By": 1,        必填,int,B点y坐标
                            "Cx": 1,        必填,int,C点x坐标
                            "Cy": 1,        必填,int,C点y坐标
                            "Dx": 1,        必填,int,D点x坐标
                            "Dy": 1         必填,int,D点y坐标
                        }
                    },
                    "panorama": {      //全景图上瞄点采用逆时针方向选取A,B,C,D
                        "ratio": {
                            "width":0.2,   必填,float,全景图缩放比例
                            "height":0.2,  必填,float,全景图缩放比例
                        }
                        "polygon": {
                            "Ax": 1,        必填,int,A点x坐标
                            "Ay": 1,        必填,int,A点y坐标
                            "Bx": 1,        必填,int,B点x坐标
                            "By": 1,        必填,int,B点y坐标
                            "Cx": 1,        必填,int,C点x坐标
                            "Cy": 1,        必填,int,C点y坐标
                            "Dx": 1,        必填,int,D点x坐标
                            "Dy": 1         必填,int,D点y坐标
                        }
                    }
                }
            失败 - {"code": <非0>, "msg": "错误说明", "user_visible": false}
        */
        void QueryCameraMappingInfo(string cond, out string result);
    };
};
