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
     * @brief SaaS��̨����ӿڶ���
     */
    interface ISaasBackend
    {
        /*----------------------------------------------------------------------
          ����Ա�˺Ź�����
         ---------------------------------------------------------------------*/
        /**
         * @brief  Login ����Ա��¼
         * @since  2019/10/15
         *
         * @param admin ����Ա��Ϣ��
            example:
            {
                "username": "admin",    ����,string,��¼����
                "password": "md5"       ����,string,MD5���ܵ����롣
            }
         * @param result �ɹ���ʧ�ܡ�����
            �ɹ� - ���ض�Ӧ�Ľ��
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
            ʧ�� - {"code": <��0>, "message": "����˵��", "visible": false}
         */
        void Login(string admin, out string result);

        /**
         * @brief  AddAdmin ��ӹ���Ա
         * @since  2019/10/15
         *
         * @param admin ����Ա��Ϣ��
            example:
            {
                "username": "admin",    ����,string,����Ա���ƣ�ֻ������ĸ���������
                "password": "md5",      ����,string,����Ա���룬MD5���ܵ�����
                "level": 0,             ѡ��,int,����Ա����,1:��������Ա,2:�߼�����Ա,3:��ͨ����Ա
                "permission": "",       ����,string,Ȩ��
                "remark": "xxx"         ѡ��,string,��ע
                "operator": "admin",    ����,string,�����ߣ�����ǰ��¼���˺š�
            }
         * @param result �ɹ���ʧ�ܡ�����
            �ɹ� - {"code": 0, "info": {"admin_id": 1}}
            ʧ�� - {"code": <��0>, "message": "����˵��", "visible": false}
         */
        void AddAdmin(string admin, out string result);

        /**
         * @brief  UpdateAdmin ���¹���Ա��Ϣ
         * @since  2019/10/15
         *
         * @param admin ����Ա��Ϣ��
            example:
            {
                "admin_id": 1,          ����,int,����ԱID
                "password": "md5",      ѡ��,string,����Ա���룬MD5���ܵ�����
                "level":0,              ѡ��,int,����Ա����,1:��������Ա,2:�߼�����Ա,3:��ͨ����Ա
                "permission": "",       ����,string,Ȩ��
                "remark": "xxx"         ѡ��,string,��ע��
                "operator": "admin",    ����,string,�����ߣ�����ǰ��¼���˺š�
            }
         * @param result �ɹ���ʧ�ܡ�����
            �ɹ� - {"code": 0}
            ʧ�� - {"code": <��0>, "message": "����˵��", "visible": false}
         */
        void UpdateAdmin(string admin, out string result);

        /**
         * @brief  DeleteAdmin ɾ������Ա
         * @since  2019/10/15
         *
         * @param admin ����Ա��Ϣ��
            example:
            {
                "admin_id": 1,          ����,int,����ԱID
                "operator": "admin",    ����,string,�����ߣ�����ǰ��¼���˺š�
            }
         * @param result �ɹ���ʧ�ܡ�����
            �ɹ� - {"code": 0}
            ʧ�� - {"code": <��0>, "message": "����˵��", "visible": false}
         */
        void DeleteAdmin(string admin, out string result);

        /**
         * @brief  QueryAdminList ��ѯ����Ա�б�
         * @since  2019/10/15
         *
         * @param cond ��ѯ������
            example:
            {
                "page_no": 1,           ����,int,ҳ��
                "page_size": 10,        ����,int,ÿҳ����
                "operator": "admin",    ����,string,������
                "query_cond": {
                    "username": "xx",   ѡ��,string,����Ա���ƣ�֧��ģ��ƥ��
                    "level": 0          ѡ��,int,����Ա����,1:��������Ա,2:�߼�����Ա,3:��ͨ����Ա
                }
            }
         * @param result �ɹ���ʧ�ܡ�����
            �ɹ� - ���ض�Ӧ�Ľ��
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
            ʧ�� - {"code": <��0>, "message": "����˵��", "visible": false}
         */
        void QueryAdminList(string cond, out string result);


        /*----------------------------------------------------------------------
          �û��˺Ź���
         ---------------------------------------------------------------------*/
        /**
         * @brief  AddUser ����û���Ϣ
         * @since  2019/11/26
         *
         * @param user �û���Ϣ��
            example:
            {
                "username": "jobs",     ����,string,�û���
                "password": "md5",      ����,string,�û����룬MD5���ܵ�����
                "mobile": "13300000001",����,string,�ֻ�����
                "state": 1,             ѡ��,int,����״̬,1:����,2:����
                "operator": "admin",    ����,string,�����ߣ�����ǰ��¼���˺š�
            }
         * @param result �ɹ���ʧ�ܡ�����
            �ɹ� - {"code": 0, "info": {"user_id": 1}}
            ʧ�� - {"code": <��0>, "message": "����˵��", "visible": false}
         */
        void AddUser(string user, out string result);

        /**
         * @brief  UpdateUser �����û���Ϣ
         * @since  2019/10/15
         * @update 2020/04/10 ����״̬�����޸�
         *
         * @param user �û���Ϣ��
            example:
            {
                "user_id": 1,           ����,int,�û�ID
                "password": "md5",      ѡ��,string,�û����룬MD5���ܵ�����
                "mobile": "13300000001",ѡ��,string,�ֻ�����
                "operator": "admin",    ����,string,�����ߣ�����ǰ��¼���˺š�
            }
         * @param result �ɹ���ʧ�ܡ�����
            �ɹ� - {"code": 0}
            ʧ�� - {"code": <��0>, "message": "����˵��", "visible": false}
         */
        void UpdateUser(string user, out string result);

        /**
         * @brief  DeleteUser ɾ���û�
         * @since  2019/10/15
         *
         * @param user �û���Ϣ��
            example:
            {
                "user_id": 1,           ����,int,�û�ID
                "operator": "admin",    ����,string,�����ߣ�����ǰ��¼���˺š�
            }
         * @param result �ɹ���ʧ�ܡ�����
            �ɹ� - {"code": 0}
            ʧ�� - {"code": <��0>, "message": "����˵��", "visible": false}
         */
        void DeleteUser(string user, out string result);

        /**
         * @brief  LockUser ����/�����û�
         * @since  2020/04/10
         * @update 2020/05/07
         *
         * @param user �û���Ϣ��
            example:
            {
                "user_id": 1,           ����,int,�û�ID
                "state" :1,             ����,int,1:����2:����
                "operator": "admin",    ����,string,�����ߣ�����ǰ��¼���˺š�
            }
         * @param result �ɹ���ʧ�ܡ�����
            �ɹ� - {"code": 0}
            ʧ�� - {"code": <��0>, "message": "����˵��", "visible": false}
         */
        void LockUser(string user, out string result);

        /**
         * @brief  QueryUserList ��ѯ�û��б�
         * @since  2019/10/15
         * @update 2020/03/11 �޸Ĳ�ѯ���
         *
         * @param cond ��ѯ������
            example:
            {
                "page_no": 1,           ����,int,ҳ��
                "page_size": 10,        ����,int,ÿҳ����
                "operator": "admin",    ����,string,������
                "query_cond": {
                    "username": "xx",   ѡ��,string,�˺����ƣ�֧�־�ȷƥ��
                    "mobile": "xx",     ѡ��,string,�ֻ��ţ�֧�־�ȷƥ��
                    "state": 0          ѡ��,int,����״̬,1:����,2:����
                }
            }
         * @param result �ɹ���ʧ�ܡ�����
            �ɹ� - ���ض�Ӧ�Ľ��
            {
                "code": 0,
                "info": {
                    "page_no": 1,
                    "page_size": 10,
                    "total_count": 32,
                    "items": [
                        {
                            "user_id": 1,       int,�û�ID
                            "username": "xx",   string,�û�����
                            "mobile": "",       string,�ֻ���
                            "state": 0,         int,�û�״̬
                            "org_id": 1,        int,��֯ID
                            "site_count": 1,    int,��֯�ص�����
                        }, ...
                    ]
                }
            }
            ʧ�� - {"code": <��0>, "message": "����˵��", "visible": false}
         */
        void QueryUserList(string cond, out string result);


        /*----------------------------------------------------------------------
          ��֯�ص����
         ---------------------------------------------------------------------*/
        /**
         * @brief  AddSite �����֯�ص�
         * @since  2019/10/15
         * @update 2019/12/16 �޸Ľӿ���AddCompanyΪAddSite��company_idΪsite_id
         *
         * @param site �ص���Ϣ��
            example:
            {
                "name": "nise",             ����,string,�ص����ƣ�ֻ������ĸ���������
                "abbreviate": "nise",       ѡ��,string,�ص���
                "province": 100000,         ѡ��,int,ʡ������
                "city": 100100,             ѡ��,int,�м�����
                "region": 100101,           ѡ��,int,��������
                "address": "",              ѡ��,string,��ϸ��ַ
                "industry": 1,              ѡ��,int,������ҵ
                "staff_size": 1,            ѡ��,int,��Ա��ģ��1��20�����£�2��21��~50�ˣ�3��51��~200�ˣ�4��201��~500�ˣ�5:500������
                "flow_scale": 1,            ѡ��,int,������ģ��1��200�����£�2��201��~500�ˣ�3��501��~2000�ˣ�4��2001��~5000�ˣ�5:5000������
                "leader": "Li",             ����,string,������
                "phone": "023-78455000",    ����,string,�����˵绰
                "remark": "xx",             ѡ��,string,��ע
                "user_id": 1,               ����,int,ָ���û�ID
                "operator": "jobs",         ����,string,�����ߣ�����ǰ��¼���˺š�
            }
         * @param result �ɹ���ʧ�ܡ�����
            �ɹ� - {"code": 0, "info": {"site_id": 1}}
            ʧ�� - {"code": <��0>, "message": "����˵��", "visible": false}
         */
        void AddSite(string site, out string result);

        /**
         * @brief  UpdateSite ������֯�ص���Ϣ
         * @since  2019/10/15
         * @update 2019/12/16 �޸Ľӿ���AddCompanyΪAddSite��company_idΪsite_id
         *
         * @param site �ص���Ϣ��
            example:
            {
                "site_id": 1,               ����,int,��֯�ص�ID
                "name": "nise",             ѡ��,string,����
                "abbreviate": "nise",       ѡ��,string,���
                "province": 100000,         ѡ��,int,ʡ������
                "city": 100100,             ѡ��,int,�м�����
                "region": 100101,           ѡ��,int,��������
                "address": "",              ѡ��,string,��ϸ��ַ
                "industry": 1,              ѡ��,int,������ҵ
                "staff_size": 1,            ѡ��,int,��Ա��ģ��1��20�����£�2��21��~50�ˣ�3��51��~200�ˣ�4��201��~500�ˣ�5:500������
                "flow_scale": 1,            ѡ��,int,������ģ��1��200�����£�2��201��~500�ˣ�3��501��~2000�ˣ�4��2001��~5000�ˣ�5:5000������
                "leader": "Li",             ѡ��,string,������
                "phone": "023-78455000",    ѡ��,string,�����˵绰
                "remark": "xx",             ѡ��,string,��ע
                "operator": "jobs",         ����,string,�����ߣ�����ǰ��¼���˺š�
            }
         * @param result �ɹ���ʧ�ܡ�����
            �ɹ� - {"code": 0}
            ʧ�� - {"code": <��0>, "message": "����˵��", "visible": false}
         */
        void UpdateSite(string site, out string result);

        /**
         * @brief  DeleteSite ɾ���ص�
         * @since  2019/10/15
         * @update 2019/12/16 �޸Ľӿ���DeleteCompanyΪDeleteSite��company_idΪsite_id
         *
         * @param site �ص���Ϣ��
            example:
            {
                "site_id": 1,           ����,int,�ص�ID
                "operator": "admin",    ����,string,�����ߣ�����ǰ��¼���˺š�
            }
         * @param result �ɹ���ʧ�ܡ�����
            �ɹ� - {"code": 0}
            ʧ�� - {"code": <��0>, "message": "����˵��", "visible": false}
         */
        void DeleteSite(string site, out string result);

        /**
         * @brief  BatchDeleteSite ����ɾ���ص���Ϣ
         * @since  2019/10/15
         *
         * @param site �ص���Ϣ��
            example:
            {
                "site_list": "1,2",     ����,string,��֯�ص�ID�б�
                "operator": "admin",    ����,string,�����ߣ�����ǰ��¼���˺š�
            }
         * @param result �ɹ���ʧ�ܡ�����
            �ɹ� - {"code": 0}
            ʧ�� - {"code": <��0>, "message": "����˵��", "visible": false}
         */
        void BatchDeleteSite(string site, out string result);

        /**
         * @brief  QuerySiteList ��ѯ�ص��б�
         * @since  2019/10/15
         * @update 2020/01/09 ���Ӳ�ѯ����
         * @update 2020/03/11 �޸Ĳ�ѯ���
         *
         * @param cond ��ѯ������
            example:
            {
                "page_no": 1,           ����,int,ҳ��
                "page_size": 10,        ����,int,ÿҳ����
                "operator": "admin",    ����,string,������
                "query_cond": {
                    "user_id": 1,       ѡ��,int,�û�ID
                    "username": "",     ѡ��,string,�û�������ȷƥ��
                    "site": "xx",       ѡ��,string,�ص��ƣ�֧��ģ��ƥ��
                }
            }
         * @param result �ɹ���ʧ�ܡ�����
            �ɹ� - ���ض�Ӧ�Ľ��
            {
                "code": 0,
                "info": {
                    "page_no": 1,
                    "page_size": 10,
                    "total_count": 32,
                    "items": [
                        {
                            "site_id": 1,       // �ص�ID
                            "name": "jobs",     // �ص�����
                            "abbreviate": "",   // �ص���
                            "province": 100000, // ʡ������
                            "city": 100100,     // �м�����
                            "region": 100101,   // ��������
                            "address": "",      // ��ϸ��ַ
                            "full_address": "", // string,����·��
                            "industry": 1,      // ������ҵ
                            "staff_size": 1,    // ��Ա��ģ��1��20�����£�2��21��~50�ˣ�3��51��~200�ˣ�4��201��~500�ˣ�5:500������
                            "flow_scale": 1,    // ������ģ��1��200�����£�2��201��~500�ˣ�3��501��~2000�ˣ�4��2001��~5000�ˣ�5:5000������
                            "leader": "Li",     // ������
                            "phone": "023-78455000",// �����˵绰
                            "remark": "xx",     // ��ע
                            "create_time": "",  // ����ʱ��
                            "user_id": 1,       // �����û�id
                            "username": "",     // �����û���
                            "dev_count": 10,    // �豸��
                            "lib_count": 10,    // �׿���
                            "people_count": 10  // �׿�����
                        }, ...
                    ]
                }
            }
            ʧ�� - {"code": <��0>, "message": "����˵��", "visible": false}
         */
        void QuerySiteList(string cond, out string result);

        /*----------------------------------------------------------------------
          ��������
         ---------------------------------------------------------------------*/
        /**
         * @brief  AddOrder ��Ӷ������¹�/������
         * @since  2019/12/16
         * @update 2020/01/07 �����ײ������ֶ�
         *
         * @param order ������Ϣ��
            example:
            {
                "cmd": "SubscribeInform",   ����,string,ҵ������,�¹�:Subscribe,����֪ͨ:SubscribeInform,����:Renew
                "instance_id": "",      ����,string,ʵ��ID
                "order_id": "",         ����,string,����ID
                "pricing_id": "",       ����,string,�ײ�ID,��:wisdomwatch0000001
                "pricing_name": "",     ����,string,�ײ�����
                "count": "",            ����,string,�������������������۽��ֻ����1
                "volume": "",           ����,string,���������ڣ���λ����
                "expire_date": "",      ѡ��,string,����ʱ�䣨��������,�ɶ�������ʱ��Ͷ������ڼ���ó����붩��ʵ�ʹ���ʱ������ �����ο�
                "mobile": "",           ����,string,�û��ֻ���
                "operator": "admin",    ����,string,�����ߣ�����ǰ��¼���˺š�
            }
         * @param result �ɹ���ʧ�ܡ�����
            �ɹ� - {"code": 0}
            ʧ�� - {"code": <��0>, "message": "����˵��", "visible": false}
         */
        void AddOrder(string order, out string result);

        /**
         * @brief  CancelOrder ȡ���������˶���
         * @since  2019/12/16
         *
         * @param order ������Ϣ��
            example:
            {
                "instance_id": "",      ����,string,ʵ��ID
                "order_id": "",         ����,string,����ID
                "mobile": "",           ����,string,�û��ֻ���
                "operator": "admin",    ����,string,�����ߣ�����ǰ��¼���˺š�
            }
         * @param result �ɹ���ʧ�ܡ�����
            �ɹ� - {"code": 0}
            ʧ�� - {"code": <��0>, "message": "����˵��", "visible": false}
         */
        void CancelOrder(string order, out string result);

        /**
         * @brief  ProcessOrder ������
         * @since  2020/01/07
         * @update 2020/03/11 ���ӵ�ַ��Ϣ
         *
         * @param info ������Ϣ��
            example:
            {
                "id": 0,                ����,int,������¼ID
                "site" : {
                    "site_id": 0,       ѡ��,int,��֯�ص�id����name��ѡһ
                    "name": "",         ѡ��,string,��֯�ص㣬ֻ������ĸ���������
                    "province": 100000, ѡ��,int,ʡ������
                    "city": 100100,     ѡ��,int,�м�����
                    "region": 100101,   ѡ��,int,��������
                    "address": ""       ѡ��,string,��ϸ��ַ
                },
                "camera": {
                    "name": "xxx",      ѡ��,string,�豸����
                    "serialno": "xxxx"  ����,string,�豸���к�
                },
                "operator": "admin"     ����,string,�����ߣ�����ǰ��¼���˺š�
            }
         * @param result �ɹ���ʧ�ܡ�����
            �ɹ� - ���ض�Ӧ�Ľ��
            {
                "code": 0,
                "info": {
                    "camera_id": 2,     int,����ͷID
                    "site_id": 1,       int,��װ�ص�ID
                }
            ʧ�� - {"code": <��0>, "message": "����˵��", "visible": false}
         */
        void ProcessOrder(string info, out string result);

        /**
         * @brief  GetOrderInfo ��ѯ������Ϣ
         * @since  2020/03/11
         *
         * @param cond ��ѯ������
            example:
            {
                "id": 1,                ����,int,������¼ID
            }
         * @param result �ɹ���ʧ�ܡ�����
            �ɹ� - ���ض�Ӧ�Ľ��
            {
                "code": 0,
                "info": {
                    "id": 0,                int,������¼ID
                    "order_id": "",         string,����ID
                    "type": 0,              int,��������,1:�¹�,2:����
                    "pricing": 0,           int,�ײ�����,�μ���PricingType��
                    "count": 1,             int,����������
                    "volume": 36,           int,���������ڣ���λ����
                    "expire_date": "",      int,����ʱ�䣨��������,�ɶ�������ʱ��Ͷ������ڼ���ó����붩��ʵ�ʹ���ʱ������ �����ο�
                    "mobile": "",           string,�û��ֻ���
                    "state": 0,             int,״̬,�μ���OrderState��
                    "process_time": "",     string,����ʱ��
                    "create_time": "",      string,����ʱ�䣨������ʱ�䣩
                    "site" : {
                        "org_id": 1,        int,��֯ID
                        "site_id": 1,       int,��֯�ص�ID
                        "name": "",         string,��֯�ص㣬ֻ������ĸ���������
                        "province": 100000, int,ʡ������
                        "city": 100100,     int,�м�����
                        "region": 100101,   int,��������
                        "address": "",      string,��ϸ��ַ
                        "full_address": "", string,����·��
                    },
                    "camera": {
                        "serialno": "xxxx", string,�豸���к�
                        "online": true,     bool,����״̬
                    }
                }
            }
            ʧ�� - {"code": <��0>, "message": "����˵��", "visible": false}
         */
        void GetOrderInfo(string cond, out string result);

        /**
         * @brief  QueryOrderList ��ѯ�����б�
         * @since  2020/01/07
         * @update 2020/03/11 ���ӵ�ַ��Ϣ
         *
         * @param cond ��ѯ������
            example:
            {
                "page_no": 1,           ����,int,ҳ��
                "page_size": 10,        ����,int,ÿҳ����
                "operator": "admin",    ����,string,�����ߣ�����ǰ��¼���˺š�
                "query_cond": {
                    "mobile": "xx",     ѡ��,string,�ֻ���
                    "state": 0,         ѡ��,int,״̬,�μ���OrderState��
                    "near_expire": "xx",ѡ��,string,��������
                    "valid": 1,         ѡ��,int,0-ȫ������ 1-��Ч 2-ʧЧ
                }
            }
         * @param result �ɹ���ʧ�ܡ�����
            �ɹ� - ���ض�Ӧ�Ľ��
            {
                "code": 0,
                "info": {
                    "page_no": 1,
                    "page_size": 10,
                    "total_count": 32,
                    "items": [
                        {
                            "id": 0,                int,������¼ID
                            "order_id": "",         string,����ID
                            "type": 0,              int,��������,1:�¹�,2:����
                            "pricing": 0,           int,�ײ�����,�μ���PricingType��
                            "count": 1,             int,����������
                            "volume": 36,           int,���������ڣ���λ����
                            "expire_date": "",      int,����ʱ�䣨��������,�ɶ�������ʱ��Ͷ������ڼ���ó����붩��ʵ�ʹ���ʱ������ �����ο�
                            "mobile": "",           string,�û��ֻ���
                            "state": 0,             int,״̬,�μ���OrderState��
                            "process_time": "",     string,����ʱ��
                            "create_time": "",      string,����ʱ�䣨������ʱ�䣩
                            "user": {
                                "user_id": 1,       int,�û�id
                                "username": "",     string,�û���
                            },
                            "site" : {
                                "org_id": 1,        int,��֯ID
                                "site_id": 1,       int,��֯�ص�ID
                                "name": "",         string,��֯�ص㣬ֻ������ĸ���������
                                "province": 100000, int,ʡ������
                                "city": 100100,     int,�м�����
                                "region": 100101,   int,��������
                                "address": "",      string,��ϸ��ַ
                                "full_address": "", string,����·��
                            }
                        }, ...
                    ]
                }
            }
            ʧ�� - {"code": <��0>, "message": "����˵��", "visible": false}
         */
        void QueryOrderList(string cond, out string result);

        /*----------------------------------------------------------------------
          ץ�Ļ�����
         ---------------------------------------------------------------------*/
        /**
         * @brief  AddCamera ���ץ�Ļ�
         * @since  2020/01/01
         *
         * @param camera ץ�Ļ���Ϣ��
            example:
            {
                "name": "xx",           ����,string,ץ�Ļ�����
                "serialno": "xxxx"      ����,string,���к�
                "remark": "xx",         ѡ��,string,��ע
                "site_id": 1,           ����,int,��֯�ص�ID
                "operator": "jobs",     ����,string,�����ߣ�����ǰ��¼���˺š�
            }
         * @param result �ɹ���ʧ�ܡ�����
            �ɹ� - {"code": 0, "info": {"camera_id": 1}}
            ʧ�� - {"code": <��0>, "message": "����˵��", "visible": false}
         */
        void AddCamera(string camera, out string result);

        /**
         * @brief  UpdateCamera ����ץ�Ļ���Ϣ
         * @since  2020/01/01
         *
         * @param camera ץ�Ļ���Ϣ��
            example:
            {
                "camera_id": 1,         ����,int,ץ�Ļ�ID
                "name": "xx",           ����,string,�豸����
                "remark": "xx",         ѡ��,string,��ע
                "operator": "jobs",     ����,string,�����ߣ�����ǰ��¼���˺š�
            }
         * @param result �ɹ���ʧ�ܡ�����
            �ɹ� - {"code": 0}
            ʧ�� - {"code": <��0>, "message": "����˵��", "visible": false}
        */
        void UpdateCamera(string camera, out string result);

        /**
         * @brief  DeleteCamera ɾ��ץ�Ļ�
         * @since  2020/01/01
         *
         * @param camera ץ�Ļ���Ϣ��
            example:
            {
                "camera_id": 1,         ����,int,ץ�Ļ�ID
                "site_id": 1,           ����,int,��֯�ص�ID
                "operator": "jobs",     ����,string,�����ߣ�����ǰ��¼���˺š�
            }
         * @param result �ɹ���ʧ�ܡ�����
            �ɹ� - {"code": 0}
            ʧ�� - {"code": <��0>, "message": "����˵��", "visible": false}
        */
        void DeleteCamera(string camera, out string result);

        /**
         * @brief  BatchDeleteCamera ����ɾ��ץ�Ļ�
         * @since  2020/01/01
         *
         * @param camera �豸��Ϣ��
            example:
            {
                "camera_list": "1,2",   ����,string,�豸ID�б�
                "site_id": 1,           ����,int,��֯�ص�ID
                "operator": "jobs",     ����,string,�����ߣ�����ǰ��¼���˺š�
            }
         * @param result �ɹ���ʧ�ܡ�����
            �ɹ� - {"code": 0}
            ʧ�� - {"code": <��0>, "message": "����˵��", "visible": false}
        */
        void BatchDeleteCamera(string camera, out string result);

        /**
         * @brief  QueryCameraList ��ѯץ�Ļ��б�
         * @since  2020/01/01
         * @update 2020/01/09 �޸Ĳ�ѯ�������Լ����ؽ��
         * @update 2020/03/11 �޸Ĳ�ѯ���
         * @update 2020/04/20  �ײ͹��˱�ʶ������ͼӳ���ʶ
         *
         * @param cond ��ѯ������
            example:
            {
                "page_no": 1,           ����,int,ҳ��
                "page_size": 10,        ����,int,ÿҳ����
                "operator": "jobs",     ����,string,�����ߣ�����ǰ��¼���˺š�
                "query_cond": {
                    "name": "xx",       ѡ��,string,�豸���ƣ�֧��ģ��ƥ��
                    "serialno": "",     ѡ��,string,�豸���кţ�֧�־�ȷƥ��
                    "site_id": 0,       ѡ��,int,��װ�ص�ID
                    "username": "",     ѡ��,string,�û�������ȷƥ��
                    "pricing": 1,       ѡ��,int,�ײͱ�ʶ
                    "valid": 1,         ѡ��,int,0-ȫ�� 1-��Ч 2-ʧЧ
                }
            }
         * @param result �ɹ���ʧ�ܡ�����
            �ɹ� - ���ض�Ӧ�Ľ��
            {
                "code": 0,
                "info": {
                    "page_no": 1,
                    "page_size": 10,
                    "total_count": 32,
                    "items": [
                        {
                            "camera_id": 1,     // �豸ID
                            "name": "xx",       // �豸����
                            "manufacturer": 1,  // �豸����,�μ���CameraMfrsType��
                            "serialno": "xxx",  // �豸���к�
                            "model": "xxx",     // �豸�ͺ�
                            "pricing": 1,       // �ײͱ�ʶ
                            "remark": "xx",     // ��ע
                            "online": true,     // ����״̬
                            "create_time": "",  // ����ʱ��
                            "heatmap": true,    // ����ͼӳ���ʶ,false:δ�趨����ͼ,true:���趨����ͼ
                            "user": {
                                "user_id": 1,       int,�û�id
                                "username": "",     string,�û���
                                "mobile": ""        string,�ֻ���
                            },
                            "site": {
                                "org_id": 1,        int,��֯ID
                                "site_id": 0,       int,��װ�ص�ID
                                "name": "",         string,��֯�ص㣬ֻ������ĸ���������
                                "province": 100000, int,ʡ������
                                "city": 100100,     int,�м�����
                                "region": 100101,   int,��������
                                "address": "",      string,��ϸ��ַ
                                "full_address": "", string,����·��
                            },
                            "order": {
                                "id": 0,            int,��¼ID
                                "order_id": 0,      int,������
                                "expire_date": "2022-01-01 00:00:00"
                            }
                        }, ...
                    ]
                }
            }
            ʧ�� - {"code": <��0>, "message": "����˵��", "visible": false}
        */
        void QueryCameraList(string cond, out string result);

        /*----------------------------------------------------------------------
          ������¼����
         ---------------------------------------------------------------------*/
         /**
         * @brief  QueryOperateList ��ѯ������¼
         * @since  2020/04/14
         *
         * @param cond ������
            example:
            {
                "page_no": 1,           ����,int,ҳ��
                "page_size": 10,        ����,int,ÿҳ����
                "admin_id": 1,          ����,int,����Աid
                "query_cond": {
                    "type": 1,          ����,int,������ͣ�1:����״̬���,2:�û���Ϣ���,3:������Ϣ���,4:�豸��Ϣ���
                    "username":"xx"     ѡ��,string,�û���
                    "site_name":"xx"    ѡ��,string,���̹ؼ�,֧��ģ����ѯ
                    "serialno":"xx"     ѡ��,string,�豸���к�
                }
            }
            ������
            for type �������
            2.�û���Ϣ���
            {
                "username": "xx"    ѡ��,string,�û���
            }
            3.������Ϣ���
            {
                "username": "xx"    ѡ��,string,�û���
                "site_name": "xx"   ѡ��,string,���̹ؼ�,֧��ģ����ѯ
            }
            4.�豸��Ϣ���
            {
                "serialno": "xx"    ѡ��,string,�豸���к�
            }
         * @param result �ɹ���ʧ�ܡ�����
            �ɹ�
            {
                "code": 0,
                "info": {
                    "page_no": 1,
                    "page_size": 10,
                    "total_count": 32,
                    "items": [
                        {
                            "username": "xx",   // �û���
                            "usertype": 1,      // �û����ͣ�1:ϵͳ 2:����Ա 3:�û�
                            "type": 1,          // ������ͣ�1:����״̬���,2:�û���Ϣ���,3:������Ϣ���,4:�豸��Ϣ���
                            "notes": "xx",      // �������
                            "create_time": "2019-10-20 08:12:12"
                        }, ...
                    ]
                }
            }
            ʧ�� - {"code": <��0>, "message": "����˵��", "visible": false}
        */
        void QueryOperateList(string cond, out string result);

        /*----------------------------------------------------------------------
                                        ����ͼ����
         ----------------------------------------------------------------------*/
        /**
         * @brief  GetCameraScene ��ȡ����ͷ����ͼ
         * @since  2020/04/20
         *
         * @param cond ����ͷ��Ϣ
            example:
            {
                "camera_id": 1,       ����,int,����ͷid
                "org_id": 1,          ����,int,��֯id
                "operator": "xxx"     ����,string,����Ա����
            }
         * @param result �ɹ���ʧ�ܡ���:
            �ɹ� - ���ض�Ӧ�Ľ��
            {
                "code": 0,
                "info":
                {
                    "scene_url: ""  string,����ͷ����ͼ
                }
            }
            ʧ�� - {"code": <��0>, "msg": "����˵��", "user_visible": false}
        */
        void GetCameraScene(string cond, out string result);

        /**
         * @brief  AddHeatmap ��������ͼ
         * @since  2020/04/20
         *
         * @param info ��ӳ����Ϣ
            example:
            {
                "name": "",                 ����,string,ӳ���ʶ
                "panorama_url": "",         ����,string,ȫ��ͼ��ַ
                "collect_interval": 1,      ����,int,���ݲɼ����
                "mapping_relation": [
                    {
                        "camera_id": 1,     ����,int,����ͷid
                        "scene_url": "",    ����,string,����ͷ����ͼ��ַ
                        "mapping": "{}",    ����,json-string,json��ʽ�������ֶ�
                    }
                    ...
                ],
                "site_id": 1,       ����,int,��֯�ص�id
                "org_id": 1,        ����,int,��֯id
                "operator":"xxx"    ����,string,����Ա����
            }
                [�ֶ�] mapping ȡֵ:
                {
                    "camera": {   //����ͷ����ͼ����������ʱ�뷽��ѡȡA,B,C,D
                        "ratio": {
                            "width":0.2,   ����,float,����ͼ���ű���
                            "height":0.2,  ����,float,����ͼ���ű���
                        },
                        "polygon": {
                            "Ax": 1,        ����,int,A��x����
                            "Ay": 1,        ����,int,A��y����
                            "Bx": 1,        ����,int,B��x����
                            "By": 1,        ����,int,B��y����
                            "Cx": 1,        ����,int,C��x����
                            "Cy": 1,        ����,int,C��y����
                            "Dx": 1,        ����,int,D��x����
                            "Dy": 1         ����,int,D��y����
                        }
                    },
                    "panorama": {      //ȫ��ͼ����������ʱ�뷽��ѡȡA,B,C,D
                        "ratio": {
                            "width":0.2,   ����,float,ȫ��ͼ���ű���
                            "height":0.2,  ����,float,ȫ��ͼ���ű���
                        }
                        "polygon": {
                            "Ax": 1,        ����,int,A��x����
                            "Ay": 1,        ����,int,A��y����
                            "Bx": 1,        ����,int,B��x����
                            "By": 1,        ����,int,B��y����
                            "Cx": 1,        ����,int,C��x����
                            "Cy": 1,        ����,int,C��y����
                            "Dx": 1,        ����,int,D��x����
                            "Dy": 1         ����,int,D��y����
                        }
                    }
                }
         * @param result �ɹ���ʧ�ܡ���:
            �ɹ� - {"code": 0}
            ʧ�� - {"code": <��0>, "msg": "����˵��", "user_visible": false}
        */
        void AddHeatmap(string info, out string result);

        /**
         * @brief  UpdateHeatmap �޸�����ͼ
         * @since  2020/04/20
         *
         * @para info ��ӳ����Ϣ
            example:
            {
                "heatmap_id": 1,            ����,int,����ͼӳ��id
                "name": "",                 ����,string,ӳ���ʶ
                "panorama_url": "",         ����,string,ȫ��ͼ��ַ
                "collect_interval": 1,      ����,int,���ݲɼ����
                "mapping_relation":[
                    {
                        "camera_id": 1,     ����,int,����ͷid
                        "scene_url": "",    ����,string,����ͷ����ͼ��ַ
                        "mapping": "{}",    ����,json-string,json��ʽ�������ֶ�
                    }
                    ...
                ],
                "site_id": 1,       ����,int,��֯�ص�id
                "org_id": 1,        ����,int,��֯id
                "operator":"xxx"    ����,string,����Ա����
            }
                [�ֶ�] mapping ȡֵ:
                {
                    "camera": {   //����ͷ����ͼ����������ʱ�뷽��ѡȡA,B,C,D
                        "ratio": {
                            "width":0.2,   ����,float,����ͼ���ű���
                            "height":0.2,  ����,float,����ͼ���ű���
                        }
                        "polygon": {
                            "Ax": 1,        ����,int,A��x����
                            "Ay": 1,        ����,int,A��y����
                            "Bx": 1,        ����,int,B��x����
                            "By": 1,        ����,int,B��y����
                            "Cx": 1,        ����,int,C��x����
                            "Cy": 1,        ����,int,C��y����
                            "Dx": 1,        ����,int,D��x����
                            "Dy": 1         ����,int,D��y����
                        }
                    },
                    "panorama": {      //ȫ��ͼ����������ʱ�뷽��ѡȡA,B,C,D
                        "ratio": {
                            "width":0.2,   ����,float,ȫ��ͼ���ű���
                            "height":0.2,  ����,float,ȫ��ͼ���ű���
                        }
                        "polygon": {
                            "Ax": 1,        ����,int,A��x����
                            "Ay": 1,        ����,int,A��y����
                            "Bx": 1,        ����,int,B��x����
                            "By": 1,        ����,int,B��y����
                            "Cx": 1,        ����,int,C��x����
                            "Cy": 1,        ����,int,C��y����
                            "Dx": 1,        ����,int,D��x����
                            "Dy": 1         ����,int,D��y����
                        }
                    }
                }
         * @para result �ɹ���ʧ�ܡ���:
            �ɹ� - {"code": 0}
            ʧ�� - {"code": <��0>, "msg": "����˵��", "user_visible": false}
        */
        void UpdateHeatmap(string info, out string result);

        /**
         * @brief  DeleteHeatmap ɾ������ͼ
         * @since  2020/04/20
         *
         * @para info ��ӳ����Ϣ
            example:
            {
                "heatmap_id": 1,    ����,int,��¼id
                "site_id": 1,       ����,int,��֯�ص�id
                "org_id": 1,        ����,int,��֯id
                "operator":"xxx"    ����,string,����Ա����
            }
         * @para result �ɹ���ʧ�ܡ���:
            �ɹ� - {"code": 0}
            ʧ�� - {"code": <��0>, "msg": "����˵��", "user_visible": false}
        */
        void DeleteHeatmap(string info, out string result);

        /**
         * @brief  QueryHeatmapList ��ȡ����ͼ�б�
         * @since  2020/04/20
         *
         * @para cond ��ѯ����
            example:
            {
                "page_no": 1,           ����,int,ҳ��
                "page_size": 1,         ����,int,ÿҳ����
                "org_id": 1,            ����,int,��֯id
                "operator":"xxx"        ����,string,����Ա����
                "site_id": 1,           ѡ��,int,��֯�ص�id
            }
         * @para result �ɹ���ʧ�ܡ���:
            �ɹ� - ���ض�Ӧ�Ľ��
            {
                "code": 0,
                "info":
                {
                    "items": [
                        {
                            "heatmap_id": 1,            int,ӳ��id
                            "name": "",                 string,ӳ���ʶ
                            "panorama_url": 1,          string,��˾ȫ��ͼ
                            "org_id": 1,                int,��֯id
                            "organization": "",         string,��֯��
                            "site_id" 1,                int,��֯��ַid
                            "site": "name",             string,��֯��ַ��
                            "create_time": "2019-07-17 14:00:00"    string,����ʱ��
                        }
                    ]
                }
            }
            ʧ�� - {"code": <��0>, "msg": "����˵��", "user_visible": false}
        */
        void QueryHeatmapList(string cond, out string result);

        /**
         * @brief  QueryHeatmapDetail ��ȡ����ͼ��ϸ��Ϣ
         * @since  2020/04/20
         *
         * @para cond ��ѯ����
            example:
            {
                "heatmap_id": 1,        ����,int,����ͼͼid
                "org_id": 1,            ����,int,��֯id
                "site_id": 1,           ����,int,��֯�ص�id
                "operator":"xxx"        ����,string,����Ա����
            }
         * @para result �ɹ���ʧ�ܡ���:
            �ɹ� - ���ض�Ӧ�Ľ��
            {
                "code": 0,
                "info":
                {
                    "heatmap_id": 1,            int,ӳ��id
                    "name": "",                 string,ӳ���ʶ
                    "panorama_url": 1,          string,��˾ȫ��ͼ
                    "site_id": 1,               int,��֯�ص�id
                    "site": "name",             string,��֯��ַ��
                    "mapping_relation":[
                        {
                            "camera_id": 1,     ����,int,����ͷid
                            "scene_url": "",    ����,string,����ͷ����ͼ��ַ
                            "mapping": "{}",    ����,json-string,json��ʽ�������ֶ�
                        }
                        ...
                    ],
                    "create_time": "2019-07-17 14:00:00"    string,����ʱ��
                }
            }
                [�ֶ�] mapping ȡֵ:
                {
                    "camera": {   //����ͷ����ͼ����������ʱ�뷽��ѡȡA,B,C,D
                        "ratio": {
                            "width":0.2,   ����,float,����ͼ���ű���
                            "height":0.2,  ����,float,����ͼ���ű���
                        }
                        "polygon": {
                            "Ax": 1,        ����,int,A��x����
                            "Ay": 1,        ����,int,A��y����
                            "Bx": 1,        ����,int,B��x����
                            "By": 1,        ����,int,B��y����
                            "Cx": 1,        ����,int,C��x����
                            "Cy": 1,        ����,int,C��y����
                            "Dx": 1,        ����,int,D��x����
                            "Dy": 1         ����,int,D��y����
                        }
                    },
                    "panorama": {      //ȫ��ͼ����������ʱ�뷽��ѡȡA,B,C,D
                        "ratio": {
                            "width":0.2,   ����,float,ȫ��ͼ���ű���
                            "height":0.2,  ����,float,ȫ��ͼ���ű���
                        }
                        "polygon": {
                            "Ax": 1,        ����,int,A��x����
                            "Ay": 1,        ����,int,A��y����
                            "Bx": 1,        ����,int,B��x����
                            "By": 1,        ����,int,B��y����
                            "Cx": 1,        ����,int,C��x����
                            "Cy": 1,        ����,int,C��y����
                            "Dx": 1,        ����,int,D��x����
                            "Dy": 1         ����,int,D��y����
                        }
                    }
                }
            ʧ�� - {"code": <��0>, "msg": "����˵��", "user_visible": false}
        */
        void QueryHeatmapDetail(string cond, out string result);

        /**
         * @brief  QueryCameraMappingInfo ��ѯָ������ͷӳ����Ϣ
         * @since  2020/04/20
         *
         * @para cond ��ѯ����
            example:
            {
                "camera_id": 1,         ����,int,����ͷid
                "org_id": 1,            ����,int,��֯id
                "site_id": 1,           ����,int,��֯�ص�id
                "operator":"xxx"        ����,string,����Ա����
            }
         * @para result �ɹ���ʧ�ܡ���:
            �ɹ� - ���ض�Ӧ�Ľ��
            {
                "code": 0,
                "info":
                {
                    "camera_id": 1,     int,����ͷid
                    "camera_name": "",  string,����ͷ��
                    "scene_url": "",    string,����ͷ����ͼ��ַ
                    "mapping": "{}",    json-string,json��ʽ�������ֶ�
                } 
            }
            [�ֶ�] mapping ȡֵ:
                {
                    "camera": {   //����ͷ����ͼ����������ʱ�뷽��ѡȡA,B,C,D
                        "ratio": {
                            "width":0.2,   ����,float,����ͼ���ű���
                            "height":0.2,  ����,float,����ͼ���ű���
                        }
                        "polygon": {
                            "Ax": 1,        ����,int,A��x����
                            "Ay": 1,        ����,int,A��y����
                            "Bx": 1,        ����,int,B��x����
                            "By": 1,        ����,int,B��y����
                            "Cx": 1,        ����,int,C��x����
                            "Cy": 1,        ����,int,C��y����
                            "Dx": 1,        ����,int,D��x����
                            "Dy": 1         ����,int,D��y����
                        }
                    },
                    "panorama": {      //ȫ��ͼ����������ʱ�뷽��ѡȡA,B,C,D
                        "ratio": {
                            "width":0.2,   ����,float,ȫ��ͼ���ű���
                            "height":0.2,  ����,float,ȫ��ͼ���ű���
                        }
                        "polygon": {
                            "Ax": 1,        ����,int,A��x����
                            "Ay": 1,        ����,int,A��y����
                            "Bx": 1,        ����,int,B��x����
                            "By": 1,        ����,int,B��y����
                            "Cx": 1,        ����,int,C��x����
                            "Cy": 1,        ����,int,C��y����
                            "Dx": 1,        ����,int,D��x����
                            "Dy": 1         ����,int,D��y����
                        }
                    }
                }
            ʧ�� - {"code": <��0>, "msg": "����˵��", "user_visible": false}
        */
        void QueryCameraMappingInfo(string cond, out string result);
    };
};
