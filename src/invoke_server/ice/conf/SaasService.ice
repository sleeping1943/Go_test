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
     * @brief SaaS����ӿڶ���
     */
    interface ISaasService
    {
        /*----------------------------------------------------------------------
          �û��˺Ź���
         ---------------------------------------------------------------------*/
        /**
         * @brief  Login �û���¼��
         * @since  2020/03/18
         * @update 2020/05/06 ������ͨ��Ȩ�û�Ȩ����Ϣ
         *
         * @param user �û���Ϣ��
            example: 
            {
                "username": "jobs",     ����,string,��¼����
                "password": "md5"       ����,string,MD5���ܵ����롣
            }
         * @param result �ɹ���ʧ�ܡ�����
            �ɹ� - ���ض�Ӧ�Ľ��
            {
                "code": 0,
                "info": {
                    "org_id": 1,            ��֯id
                    "user_id": 1,           �û�id
                    "username": 1,          �û���
                    "type": 1,              �û�����,�μ�<UserType>
                    "state": 1,             ״̬
                    "mobile": "",           �ֻ���
                    "sites": [              ��Ȩ�����б�
                        {
                            "site_id": 1,   ����ID
                            "name": ""      ��������
                        },
                        ...
                    ],
                    "permission": ""        Ȩ��
                }
            }
            ʧ�� - {"code": <��0>, "message": "����˵��", "visible": false}
        */
        void Login(string user, out string result);

        /**
         * @brief  AddUser �����Ȩ�û���Ϣ
         * @since  2020/05/06
         *
         * @param user �û���Ϣ��
            example:
            {
                "mobile": "13300000001",����,string,�ֻ�����
                "name": "zhangsan",     ѡ��,string,����
                "state": 1,             ����,int,�û�״̬
                "site_list": "",        ����,string,��Ȩ����,ALL��ʾ���е���
                "permission": "",       ѡ��,string,Ȩ����Ϣ
                "org_id": 1,            ����,int,��֯id
                "operator": "jobs",     ����,string,�����ߣ�����ǰ��¼���˺š�
            }
         * @param result �ɹ���ʧ�ܡ�����
            �ɹ� - {"code": 0}
            ʧ�� - {"code": <��0>, "message": "����˵��", "visible": false}
        */
        void AddUser(string user, out string result);

        /**
         * @brief  UpdateUser ������Ȩ�û���Ϣ
         * @since  2020/05/06
         *
         * @param user �û���Ϣ��
            example:
            {
                "user_id": 0,           ����,int,�û�ID
                "name": "zhangsan",     ѡ��,string,����
                "state": 1,             ѡ��,int,�û�״̬
                "site_list": "",        ����,string,��Ȩ����,ALL��ʾ���е���
                "permission": "",       ѡ��,string,Ȩ����Ϣ
                "org_id": 1,            ����,int,��֯id
                "operator": "jobs",     ����,string,�����ߣ�����ǰ��¼���˺š�
            }
         * @param result �ɹ���ʧ�ܡ�����
            �ɹ� - {"code": 0}
            ʧ�� - {"code": <��0>, "message": "����˵��", "visible": false}
        */
        void UpdateUser(string user, out string result);

         /**
         * @brief  DeleteUser ɾ����Ȩ�û���Ϣ
         * @since  2020/05/06
         *
         * @param user �û���Ϣ��
            example:
            {
                "user_id": 0,           ����,int,�û�ID
                "org_id": 1,            ����,int,��֯id
                "operator": "jobs",     ����,string,�����ߣ�����ǰ��¼���˺š�
            }
         * @param result �ɹ���ʧ�ܡ�����
            �ɹ� - {"code": 0}
            ʧ�� - {"code": <��0>, "message": "����˵��", "visible": false}
         */
         void DeleteUser(string user, out string result);

        /**
         * @brief  QueryUserList ��ѯ��Ȩ�û��б�
         * @since  2020/05/06
         *
         * @param cond ��ѯ������
            example:
            {
                "page_no": 1,           ����,int,ҳ��
                "page_size": 10,        ����,int,ÿҳ����
                "org_id": 1,            ����,int,��֯id
                "operator": "jobs",     ����,string,������
                "query_cond": {
                    "name": "xx",       ѡ��,string,�ص����ƣ�֧��ģ��ƥ��
                    "mobile": "",       ѡ��,string,�ֻ���
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
                            "user_id": 0,               int,�û�ID
                            "username": 1,              string,�û���
                            "name": "zhangsan",         string,����
                            "state": 1,                 int,�û�״̬
                            "mobile": "13300000001",    string,�ֻ�����
                            "site_list": "",            string,��������id�б�,ALL��ʾ���е���
                            "permission": "",           string,Ȩ����Ϣ
                        },...
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
         * @since  2020/03/18
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
                "org_id": 1,                ����,int,��֯id
                "operator": "jobs",         ����,string,�����ߣ�����ǰ��¼���˺š�
            }
         * @param result �ɹ���ʧ�ܡ�����
            �ɹ� - {"code": 0, "info": {"site_id": 1}}
            ʧ�� - {"code": <��0>, "message": "����˵��", "visible": false}
        */
        void AddSite(string site, out string result);

        /**
         * @brief  UpdateSite ������֯�ص���Ϣ
         * @since  2020/03/18
         *
         * @param site �ص���Ϣ��
            example:
            {
                "site_id": 1,               ����,int,�ص�ID
                "name": "nise",             ѡ��,string,����
                "abbreviate": "nise",       ѡ��,string,���
                "province": 100000,         ѡ��,int,ʡ������
                "city": 100100,             ѡ��,int,�м�����
                "region": 100101,           ѡ��,int,��������
                "address": "",              ѡ��,string,��ϸ��ַ
                "industry": 1,              ѡ��,int,������ҵ
                "staff_size": 1,            ѡ��,int,��Ա��ģ��1��20�����£�2��21��~50�ˣ�3��51��~200�ˣ�4��201��~500�ˣ�5:500������
                "flow_scale": 1,            ѡ��,int,������ģ��1��200�����£�2��201��~500�ˣ�3��501��~2000�ˣ�4��2001��~5000�ˣ�5:5000������
                "leader": "Li",             ����,string,������
                "phone": "023-78455000",    ����,string,�����˵绰
                "org_id": 1,                ����,int,��֯id
                "operator": "jobs",         ����,string,�����ߣ�����ǰ��¼���˺š�
            }
         * @param result �ɹ���ʧ�ܡ�����
            �ɹ� - {"code": 0}
            ʧ�� - {"code": <��0>, "message": "����˵��", "visible": false}
        */
        void UpdateSite(string site, out string result);

         /**
         * @brief  GetSiteInfo ��ȡ��֯�ص���Ϣ
         * @since  2020/03/18
         *
         * @param cond ��ѯ������
            example:
            {
                "site_id": 1,           ����,int,�ص�ID
                "org_id": 1,            ����,int,��֯id
                "operator": "jobs",     ����,string,������
            }
         * @param result �ɹ���ʧ�ܡ�����
            �ɹ� - ���ض�Ӧ�Ľ��
            {
                "code": 0,
                "info": {
                    "site_id": 1,               // int,�ص�ID
                    "name": "nise",             // string,�ص����ƣ�ֻ������ĸ���������
                    "abbreviate": "nise",       // string,���
                    "province": 100000,         // int,ʡ������
                    "city": 100100,             // int,�м�����
                    "region": 100101,           // int,��������
                    "address": "",              // string,��ϸ��ַ
                    "full_address": "",         // string,����·��
                    "industry": 1,              // int,������ҵ
                    "staff_size": 1,            // int,��Ա��ģ��1��20�����£�2��21��~50�ˣ�3��51��~200�ˣ�4��201��~500�ˣ�5:500������
                    "flow_scale": 1,            // int,������ģ��1��200�����£�2��201��~500�ˣ�3��501��~2000�ˣ�4��2001��~5000�ˣ�5:5000������
                    "leader": "Li",             // string,������
                    "phone": "023-78455000",    // string,�����˵绰
                    "resource": {
                        "camera_count": 0,      // int,����ͷ����
                    }
                }
            }
            ʧ�� - {"code": <��0>, "message": "����˵��", "visible": false}
        */
        void GetSiteInfo(string cond, out string result);

         /**
         * @brief  QuerySiteList ��ѯ�û���֯�ص��б�
         * @since  2020/03/18
         *
         * @param cond ��ѯ������
            example:
            {
                "page_no": 1,           ����,int,ҳ��
                "page_size": 10,        ����,int,ÿҳ����
                "org_id": 1,            ����,int,��֯id
                "operator": "jobs",     ����,string,������
                "query_cond": {
                    "name": "xx",       ѡ��,string,�ص����ƣ�֧��ģ��ƥ��
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
                            "site_id": 1,               // int,�ص�ID
                            "name": "nise",             // string,�ص����ƣ�ֻ������ĸ���������
                            "abbreviate": "nise",       // string,���
                            "province": 100000,         // int,ʡ������
                            "city": 100100,             // int,�м�����
                            "region": 100101,           // int,��������
                            "address": "",              // string,��ϸ��ַ
                            "full_address": "",         // string,����·��
                            "industry": 1,              // int,������ҵ
                            "staff_size": 1,            // int,��Ա��ģ��1��20�����£�2��21��~50�ˣ�3��51��~200�ˣ�4��201��~500�ˣ�5:500������
                            "flow_scale": 1,            // int,������ģ��1��200�����£�2��201��~500�ˣ�3��501��~2000�ˣ�4��2001��~5000�ˣ�5:5000������
                            "leader": "Li",             // string,������
                            "phone": "023-78455000",    // string,�����˵绰
                            "resource": {
                                "camera_count": 0,      // int,����ͷ����
                            }
                        }, ...
                    ]
                }
            }
            ʧ�� - {"code": <��0>, "message": "����˵��", "visible": false}
        */
        void QuerySiteList(string cond, out string result);


        /*----------------------------------------------------------------------
         * ���½ӿڽ��������֯�ص�ҵ�����
         *--------------------------------------------------------------------*/

        /*----------------------------------------------------------------------
          ��Ա�׿����
         ---------------------------------------------------------------------*/
        /**
         * @brief  AddLibrary �����Ա�׿�
         * @since  2020/03/18
         *
         * @param library �׿���Ϣ��
            example:
            {
                "name": "xx",           ����,string,�׿�����
                "type": 1,              ����,int,�׿���Ա���ͣ��μ���PeopleType��
                "site_list": "1,2",     ����,string,��������id�б�,ALL��ʾ���е���
                "remark": "xx",         ѡ��,string,��ע
                "org_id": 1,            ����,int,��֯id
                "operator": "jobs",     ����,string,�����ߣ�����ǰ��¼���˺š�
            }
         * @param result �ɹ���ʧ�ܡ�����
            �ɹ� - {"code": 0, "info": {"lib_id": 1}}
            ʧ�� - {"code": <��0>, "message": "����˵��", "visible": false}
         */
         void AddLibrary(string library, out string result);

        /**
         * @brief  UpdateLibrary �޸���Ա�׿���Ϣ
         * @since  2020/03/18
         *
         * @param library �׿���Ϣ��
            example:
            {
                "lib_id": 1,            ����,int,�׿�id
                "name": "xx",           ����,string,�׿�����
                "site_list": "1,2",     ����,string,��������id�б�,ALL��ʾ���е���
                "remark": "xx",         ѡ��,string,��ע
                "org_id": 1,            ����,int,��֯id
                "operator": "jobs",     ����,string,�����ߣ�����ǰ��¼���˺š�
            }
         * @param result �ɹ���ʧ�ܡ�����
            �ɹ� - {"code": 0, "info": {"lib_id": 1}}
            ʧ�� - {"code": <��0>, "message": "����˵��", "visible": false}
         */
         void UpdateLibrary(string library, out string result);

         /**
         * @brief  DeleteLibrary ɾ����Ա�׿�
         * @since  2020/03/18
         *
         * @param library �׿���Ϣ��
            example:
            {
                "lib_id": 1,            ����,int,�׿�ID
                "org_id": 1,            ����,int,��֯id
                "operator": "jobs",     ����,string,�����ߣ�����ǰ��¼���˺š�
            }
         * @param result �ɹ���ʧ�ܡ�����
            �ɹ� - {"code": 0}
            ʧ�� - {"code": <��0>, "message": "����˵��", "visible": false}
         */
         void DeleteLibrary(string library, out string result);

        /**
         * @brief  QueryLibraryList ��ѯ�׿��б�
         * @since  2020/03/18
         *
         * @param cond ��ѯ������
            example:
            {
                "page_no": 1,           ����,int,ҳ��
                "page_size": 10,        ����,int,ÿҳ����
                "org_id": 1,            ����,int,��֯id
                "operator": "jobs",     ����,string,������
                "query_cond": {
                    "name": "xx",       ѡ��,string,�׿����ƣ�֧��ģ��ƥ��
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
                            "lib_id": 1,        // �׿�ID
                            "name": "xx",       // �׿�����
                            "type": 1,          // �׿���Ա����
                            "site_list": "1,2", // ��������id�б�,ALL��ʾ���е���
                            "number": 100,      // ����
                            "remark": "xx",     // ��ע
                            "create_time": "2019-10-20 08:12:12"
                        }, ...
                    ]
                }
            }
            ʧ�� - {"code": <��0>, "message": "����˵��", "visible": false}
        */
        void QueryLibraryList(string cond, out string result);

         /**
         * @brief  BatchSetLibraryBlackWhiteList �����׿���Ա�ڰ�����
         * @since  2020/03/18
         *
         * @param library �׿���Ϣ��
            example:
            {
                "lib_list": "1,2",      ����,string,�׿�ID�б�
                "group": 1,             ����,int,�ڰ��������ͣ��μ���BlackWhiteList��
                "org_id": 1,            ����,int,��֯id
                "operator": "jobs",     ����,string,�����ߣ�����ǰ��¼���˺š�
            }
         * @param result �ɹ���ʧ�ܡ�����
            �ɹ� - {"code": 0}
            ʧ�� - {"code": <��0>, "message": "����˵��", "visible": false}
         */
         void BatchSetLibraryBlackWhiteList(string library, out string result);


        /*----------------------------------------------------------------------
          ��Ա����
         ---------------------------------------------------------------------*/
         /**
         * @brief  AddPeople �����Ա��Ϣ
         * @since  2020/03/18
         * @update 2020/04/08 ���������ֶ�
         *
         * @param people ��Ա��Ϣ��
            example:
            {
                "lib_id": 1,            ����,int,�׿�ID
                "name": "xx",           ����,string,����
                "sex": 1,               ѡ��,int,�Ա𣬲μ���SexType��
                "age": 30,              ѡ��,int,����
                "credential_no": "",    ѡ��,string,֤����
                "group": 1,             ѡ��,int,�ڰ��������ͣ��μ���BlackWhiteList��
                "birthday": "",         ѡ��,string,��������
                "mobile": "13900000000",ѡ��,string,�ֻ���
                "company": "",          ѡ��,string,���ڵ�λ
                "position": "",         ѡ��,string,ְλ
                "effective": "",        ѡ��,string,��Чʱ��-��ʼʱ�䣨��Ч��
                "expire": "",           ѡ��,string,��Чʱ��-����ʱ�䣨���ڣ�
                "speech": "xx",         ѡ��,string,ӭ����
                "photo_list": [""],     ����,json,��Ƭ·���б���һ����ƬΪĬ����ʾ��Ƭ
                "property": {},         ����,json,��Ա����
                "org_id": 1,            ����,int,��֯id
                "operator": "jobs",     ����,string,�����ߣ�����ǰ��¼���˺š�
            }
            �ֶζ���
            for property
            1. Ա��
            {
                "rule_id": 1,     ����,int,���ڹ���id
            }
            2. VIP
            {
                "level": "",        ѡ��,string,VIP�ȼ�
                "expire_date": ""   ѡ��,string,����ʱ��
            }
         * @param result �ɹ���ʧ�ܡ�����
            �ɹ� - {"code": 0, "info": {"people_id": 1}}
            ʧ�� - {"code": <��0>, "message": "����˵��", "visible": false}
         */
         void AddPeople(string people, out string result);

         /**
         * @brief  UpdatePeople ������Ա��Ϣ
         * @since  2020/03/18
         * @update 2020/04/08 ���������ֶ�
         *
         * @param people ��Ա��Ϣ��
            example:
            {
                "people_id": 1,         ����,int,��ԱID
                "name": "xx",           ����,string,����
                "sex": 1,               ѡ��,int,�Ա𣬲μ���SexType��
                "age": 30,              ѡ��,int,����
                "credential_no": "",    ѡ��,string,֤����
                "group": 1,             ѡ��,int,�ڰ��������ͣ��μ���BlackWhiteList��
                "birthday": "",         ѡ��,string,��������
                "mobile": "13900000000",ѡ��,string,�ֻ���
                "company": "",          ѡ��,string,���ڵ�λ
                "position": "",         ѡ��,string,ְλ
                "effective": "",        ѡ��,string,��Чʱ��-��ʼʱ�䣨��Ч��
                "expire": "",           ѡ��,string,��Чʱ��-����ʱ�䣨���ڣ�
                "speech": "xx",         ѡ��,string,ӭ����
                "photo_list": [""],     ����,json,��Ƭ·���б���һ����ƬΪĬ����ʾ��Ƭ
                "property": {},         ѡ��,json,��Ա����
                "org_id": 1,            ����,int,��֯id
                "operator": "jobs",     ����,string,�����ߣ�����ǰ��¼���˺š�
            }
            �ֶζ���
            for property
            1. Ա��
            {
                "rule_id": 1,     ����,int,���ڹ���id
            }
            2. VIP
            {
                "level": "",        ѡ��,string,VIP�ȼ�
                "expire_date": ""   ѡ��,string,����ʱ��
            }
         * @param result �ɹ���ʧ�ܡ�����
            �ɹ� - {"code": 0}
            ʧ�� - {"code": <��0>, "message": "����˵��", "visible": false}
         */
         void UpdatePeople(string people, out string result);

         /**
         * @brief  DeletePeople ɾ����Ա��Ϣ
         * @since  2020/03/18
         *
         * @param people ��Ա��Ϣ��
            example:
            {
                "people_id": 1,         ����,int,��ԱID
                "org_id": 1,            ����,int,��֯id
                "operator": "jobs",     ����,string,�����ߣ�����ǰ��¼���˺š�
            }
         * @param result �ɹ���ʧ�ܡ�����
            �ɹ� - {"code": 0}
            ʧ�� - {"code": <��0>, "message": "����˵��", "visible": false}
         */
         void DeletePeople(string people, out string result);

         /**
         * @brief  BatchDeletePeople ����ɾ����Ա��Ϣ
         * @since  2020/03/18
         *
         * @param people ��Ա��Ϣ��
            example:
            {
                "lib_id": 1,            ����,int,�׿�ID
                "people_list": "1,2",   ����,string,��ԱID�б�
                "org_id": 1,            ����,int,��֯id
                "operator": "jobs",     ����,string,�����ߣ�����ǰ��¼���˺š�
            }
         * @param result �ɹ���ʧ�ܡ�����
            �ɹ� - {"code": 0}
            ʧ�� - {"code": <��0>, "message": "����˵��", "visible": false}
         */
         void BatchDeletePeople(string people, out string result);

        /**
         * @brief  GetPeopleInfo ��ȡ��ϸ��Ա��Ϣ
         * @since  2019/10/15
         * @update 2020/04/08 ���������ֶΣ��޸Ĳ�ѯ����
         *
         * @param cond ��ѯ������
            example:
            {
                "people_id": 1,         ����,int,��ԱID
                "org_id": 1,            ����,int,��֯id
                "operator": "jobs",     ����,string,�����ߣ�����ǰ��¼���˺š�
            }
         * @param result �ɹ���ʧ�ܡ�����
            �ɹ� - ���ض�Ӧ�Ľ��
            {
                "code": 0,
                "info": {
                    "people_id": 1,     // ��ԱID
                    "name": "xx",       // ����
                    "sex": 1,           // �Ա𣬲μ���SexType��
                    "age": 30,          // ����
                    "credential_no": "",// ֤����
                    "group": 1,         // �ڰ��������ͣ��μ���BlackWhiteList��
                    "birthday": "",     // ��������
                    "mobile": "",       // �ֻ���
                    "company": "",      // ���ڵ�λ
                    "position": "",     // ְλ
                    "effective": "",    // ��Чʱ��-��ʼʱ�䣨��Ч��
                    "expire": "",       // ��Чʱ��-����ʱ�䣨���ڣ�
                    "speech": "xx",     // ӭ����
                    "photo_list": [""], // ��ƬURL�б���һ����ƬΪĬ����ʾ��Ƭ
                    "property": {},     // ��Ա����
                }
            }
            �ֶζ���
            for property
            1. Ա��
            {
                "rule_id": 1,     // ���ڹ���id
                "rule_name": "",  // ���ڹ�������
            }
            2. VIP
            {
                "level": "",        // VIP�ȼ�
                "expire_date": ""   // ����ʱ��
            }
            ʧ�� - {"code": <��0>, "message": "����˵��", "visible": false}
        */
        void GetPeopleInfo(string cond, out string result);

        /**
         * @brief  QueryPeopleList ��ѯ��Ա�б�
         * @since  2020/03/18
         * @update 2020/04/08 ���������ֶ�
         *
         * @param cond ��ѯ������
            example:
            {
                "page_no": 1,           ����,int,ҳ��
                "page_size": 10,        ����,int,ÿҳ����
                "org_id": 1,            ����,int,��֯id
                "operator": "jobs",     ����,string,������
                "query_cond": {
                    "lib_id": 1,        ����,�׿�ID
                    "name": "xx",       ѡ��,string,������֧��ģ��ƥ��
                    "credential_no": "",ѡ��,string,֤����
                    "mobile": "",       ѡ��,string,�ֻ���
                    "group": 1,         ѡ��,int,�ڰ��������ͣ��μ���BlackWhiteList��
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
                            "people_id": 1,     // ��ԱID
                            "name": "xx",       // ����
                            "sex": 1,           // �Ա𣬲μ���SexType��
                            "age": 30,          // ����
                            "credential_no": "",// ֤����
                            "group": 1,         // �ڰ��������ͣ��μ���BlackWhiteList��
                            "birthday": "",     // ��������
                            "mobile": "",       // �ֻ���
                            "company": "",      // ���ڵ�λ
                            "position": "",     // ְλ
                            "effective": "",    // ��Чʱ��-��ʼʱ�䣨��Ч��
                            "expire": "",       // ��Чʱ��-����ʱ�䣨���ڣ�
                            "speech": "xx",     // ӭ����
                            "photo_url": "xx",  // ��ƬURL
                            "property": {},     // ��Ա����
                        }, ...
                    ]
                }
            }
            �ֶζ���
            for property
            1. Ա��
            {
                "rule_id": 1,     // ���ڹ���id
                "rule_name": "",  // ���ڹ�������
            }
            2. VIP
            {
                "level": "",        // VIP�ȼ�
                "expire_date": ""   // ����ʱ��
            }
            ʧ�� - {"code": <��0>, "message": "����˵��", "visible": false}
        */
        void QueryPeopleList(string cond, out string result);


        /*----------------------------------------------------------------------
          ����ʶ����ʷ����
         ---------------------------------------------------------------------*/
         /**
         * @brief  DeleteFaceRecoRecord ɾ������ʶ����ʷ��¼
         * @since  2020/03/18
         *
         * @param record ����ʶ���¼��Ϣ��
            example:
            {
                "id": 1,                ����,int,��¼id
                "org_id": 1,            ����,int,��֯id
                "operator": "jobs",     ����,string,�����ߣ�����ǰ��¼���˺š�
            }
         * @param result �ɹ���ʧ�ܡ�����
            �ɹ� - {"code": 0}
            ʧ�� - {"code": <��0>, "message": "����˵��", "visible": false}
        */
        void DeleteFaceRecoRecord(string record, out string result);

        /**
         * @brief  BatchDeleteFaceRecoRecord ����ɾ������ʶ����ʷ��¼
         * @since  2020/03/18
         *
         * @param record ʶ���¼��Ϣ��
            example:
            {
                "id_list": "1,2",       ����,string,��¼ID�б�
                "org_id": 1,            ����,int,��֯id
                "operator": "jobs",     ����,string,�����ߣ�����ǰ��¼���˺š�
            }
         * @param result �ɹ���ʧ�ܡ�����
            �ɹ� - {"code": 0}
            ʧ�� - {"code": <��0>, "message": "����˵��", "visible": false}
        */
        void BatchDeleteFaceRecoRecord(string record, out string result);

        /**
         * @brief  QueryFaceRecoRecordList ��ѯ����ʶ����ʷ��¼
         * @since  2020/03/18
         *
         * @param cond ��ѯ������
            example:
            {
                "page_no": 1,           ����,int,ҳ��
                "page_size": 10,        ����,int,ÿҳ����
                "org_id": 1,            ����,int,��֯id
                "operator": "jobs",     ����,string,�����ߣ�����ǰ��¼���˺š�
                "query_cond": {
                    "site_id": 1,       ѡ��,int,��֯�ص�ID
                    "lib_id": 1,        ѡ��,int,�׿�ID
                    "name": "xx",       ѡ��,string,������֧�־�ȷƥ��
                    "begin_time": "",   ����,string,��ʼʱ��
                    "end_time": "",     ����,string,����ʱ��
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
                            "id": 1,            // ��¼ID
                            "name": "xx",       // ����
                            "credential_no": "",// ֤����
                            "compare_score": .0,// �ȶԵ÷�
                            "photo_url": "xxx", // �׿���ƬURL
                            "face_url": "xxx",  // ץ������ͼURL
                            "lib_id": 1,        // �׿�ID
                            "lib_name": 1,      // �׿�����
                            "camera_id": 1,     // �豸ID
                            "camera_name": "xx",// �豸����
                            "site_id": 1,       // ����ID
                            "site_name": "xx",  // ��������
                            "create_time": "",  // ��¼ʱ��
                        }, ...
                    ]
                }
            }
            ʧ�� - {"code": <��0>, "message": "����˵��", "visible": false}
        */
        void QueryFaceRecoRecordList(string cond, out string result);

        /*----------------------------------------------------------------------
         ������ʷ��¼����
         ---------------------------------------------------------------------*/
        /**
         * @brief  QueryCustomerFlowList ��ѯ������¼ͳ��
         * @since  2020/03/31
         *
         * @param cond ��ѯ������
            example:
            {
                "page_no": 1,           ����,int,ҳ��
                "page_size": 10,        ����,int,ÿҳ����
                "type": 1,              ����,int,0-δ֪ 1-3���ڵ��� 2-7���ڵ��� 3-30���ڵ���
                "org_id": 1,            ����,int,��֯id
                "operator": "jobs",     ����,string,�����ߣ�����ǰ��¼���˺š�
                "query_cond": {
                    "order_flag": 1,        ѡ��,int,1-ʱ�䵹�� 2-�����������
                    "site_id_list": "1",    ѡ��,string,��֯�ص�ID�б�
                    "lib_id_list": "1",     ѡ��,string,�׿�ID�б�
                }
            }
         * @param result �ɹ���ʧ�ܡ�����
            �ɹ� - ���ض�Ӧ�Ľ��
            {
                "code": 0,
                "info": {
                    "page_no": 1,
                    "page_size": 1,
                    "total_count": 1,
                    "items": [
                        {
                            "customer_id": "",          // ����ID
                            "people_id": 1,             // ��ԱID
                            "name": "xx"                // ��Ա����
                            "type": 1,                  // ��Ա����
                            "age": 1,                   // �Ա�
                            "sex": 1,                   // ����
                            "site_id": 1,               // ��֯�ص�ID
                            "site_name": "xx",          // �ص�����
                            "photo_url": "xxx",         // �׿���ƬURL
                            "face_url": "xxx",          // ץ������ͼURL
                            "first_capture_time": "xx", // �����״�ץ��ʱ��
                            "last_capture_time": "xx",  // ����ĩ��ץ��ʱ��
                            "thirty_day_times": 1,      // 30��������
                        }, ...
                    ]
                }
            }
            ʧ�� - {"code": <��0>, "message": "����˵��", "visible": false}
        */
        void QueryCustomerFlowList(string cond, out string result);

        /*----------------------------------------------------------------------
          ץ�Ļ�����
         ---------------------------------------------------------------------*/
        /**
         * @brief  UpdateCamera ����ץ�Ļ���Ϣ
         * @since  2020/03/18
         *
         * @param camera ץ�Ļ���Ϣ��
            example:
            {
                "camera_id": 1,         ����,int,ץ�Ļ�ID
                "name": "xx",           ����,string,�豸����
                "remark": "xx",         ѡ��,string,��ע
                "org_id": 1,            ����,int,��֯id
                "operator": "jobs",     ����,string,�����ߣ�����ǰ��¼���˺š�
            }
         * @param result �ɹ���ʧ�ܡ�����
            �ɹ� - {"code": 0}
            ʧ�� - {"code": <��0>, "message": "����˵��", "visible": false}
        */
        void UpdateCamera(string camera, out string result);

        /**
         * @brief  DeleteCamera ɾ��ץ�Ļ�
         * @since  2020/03/18
         *
         * @param camera ץ�Ļ���Ϣ��
            example:
            {
                "camera_id": 1,         ����,int,ץ�Ļ�ID
                "org_id": 1,            ����,int,��֯id
                "operator": "jobs",     ����,string,�����ߣ�����ǰ��¼���˺š�
            }
         * @param result �ɹ���ʧ�ܡ�����
            �ɹ� - {"code": 0}
            ʧ�� - {"code": <��0>, "message": "����˵��", "visible": false}
        */
        void DeleteCamera(string camera, out string result);

        /**
         * @brief  BatchDeleteCamera ����ɾ��ץ�Ļ�
         * @since  2020/03/18
         *
         * @param camera �豸��Ϣ��
            example:
            {
                "camera_list": "1,2",   ����,string,�豸ID�б�
                "org_id": 1,            ����,int,��֯id
                "operator": "jobs",     ����,string,�����ߣ�����ǰ��¼���˺š�
            }
         * @param result �ɹ���ʧ�ܡ�����
            �ɹ� - {"code": 0}
            ʧ�� - {"code": <��0>, "message": "����˵��", "visible": false}
        */
        void BatchDeleteCamera(string camera, out string result);

        /**
         * @brief  QueryCameraList ��ѯץ�Ļ��б�
         * @since  2020/03/18
         *
         * @param cond ��ѯ������
            example:
            {
                "page_no": 1,           ����,int,ҳ��
                "page_size": 10,        ����,int,ÿҳ����
                "org_id": 1,            ����,int,��֯id
                "operator": "jobs",     ����,string,�����ߣ�����ǰ��¼���˺š�
                "query_cond": {
                    "name": "xx",       ѡ��,string,�豸���ƣ�֧��ģ��ƥ��
                    "serialno": "",     ѡ��,string,�豸���кţ�֧�־�ȷƥ��
                    "site_id": 1,       ѡ��,int,��֯�ص�ID
                    "pricing": 1,       ѡ��,int,�ײ����ͣ��μ���PricingType��
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
                            "remark": "xx",     // ��ע
                            "online": true,     // ����״̬
                            "create_time": "2019-10-20 08:12:12"
                            "site": {
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
                                "pricing": "",      int,�ײ����ͣ��μ���PricingType��
                                "expire_date": "2022-01-01 00:00:00"
                            }
                        }, ...
                    ]
                }
            }
            ʧ�� - {"code": <��0>, "message": "����˵��", "visible": false}
        */
        void QueryCameraList(string cond, out string result);

        /**
         * @brief  UpdateCameraConfig �޸�ץ�Ļ�����
         * @since  2020/05/25
         *
         * @param cond ��ѯ������
            example:
            {
                "org_id": 1,            ����,int,��֯id
                "camera_id": 1,         ����,int,�豸id
                "config": "{}",         ����,string,�豸����,json��ʽ
                "operator": "jobs",     ����,string,�����ߣ�����ǰ��¼���˺š�
            }
         * @param result �ɹ���ʧ�ܡ�����
            �ɹ� - {"code": 0}
            ʧ�� - {"code": <��0>, "message": "����˵��", "visible": false}
        */
        void UpdateCameraConfig(string cond, out string result);

        /**
         * @brief  QueryCameraConfig ��ѯץ�Ļ�����
         * @since  2020/05/25
         *
         * @param cond ��ѯ������
            example:
            {
                "org_id": 1,            ����,int,��֯id
                "camera_id": 1,         ����,int,�豸id
                "operator": "jobs",     ����,string,�����ߣ�����ǰ��¼���˺š�
            }
         * @param result �ɹ���ʧ�ܡ�����
            �ɹ� - ���ض�Ӧ�Ľ��
            {
                "code": 0,
                "info": "{}"    string,json��ʽ�豸����
            }
            ʧ�� - {"code": <��0>, "message": "����˵��", "visible": false}
        */
        void QueryCameraConfig(string cond, out string result);


        /*----------------------------------------------------------------------
         ���Ϳ�������ʵʱ��Ϣ
         ---------------------------------------------------------------------*/
        /**
         * @brief  GetRealtimeCapture ��ȡʵʱץ����Ϣ
         * @since  2020/03/18
         *
         * @param cond ��ȡ������
            example:
            {
                "site_id": 1,           ����,int,��֯�ص�ID
                "operator": "jobs",     ѡ��,string,�����ߣ�����ǰ��¼���˺š�
            }
         * @param result �ɹ���ʧ�ܡ�����
            �ɹ� - ���ض�Ӧ�Ľ��
            {
                "code": 0,
                "info": {
                    "customer_id": "",          // ����ID
                    "people_id": 1,             // ��ԱID
                    "name": "xx"                // ��Ա����
                    "type": 1,                  // ��Ա����
                    "credential_no": "xx"       // ֤����
                    "age": 1,                   // �Ա�
                    "sex": 1,                   // ����
                    "site_id": 1,               // ��֯�ص�ID
                    "site_name": "xx",          // �ص�����
                    "compare_score": 1.0        // �ȶԵ÷� float
                    "photo_url": "xx",          // �׿�ͼƬ·��
                    "capture_time": "xx",       // ץ��ʱ��
                }
            }
            ʧ�� - {"code": <��0>, "message": "����˵��", "visible": false}
        */
        void GetRealtimeCapture(string cond, out string result);


        /*----------------------------------------------------------------------
         ������Ϣ
         ---------------------------------------------------------------------*/
        /**
         * @brief  GetTodayInfo ��ȡ���յ�����Ϣ
         * @since  2020/03/12
         *
         * @param cond ��ȡ������
            example:
            {
                "org_id": x,                // ����,int,��֯id
                "site_list": "1,2"          // ����,string,����id�б�
            }
         * @param result �ɹ���ʧ�ܡ�����
            �ɹ� - ���ض�Ӧ�Ľ��
            {
                "code": 0,
                "info": {
                    "total_count": x,       // int,�ۼƽ���
                    "yestoday_count": x,    // int,���ս���
                    "month_count": x,       // int ���½���
                    "vip_count": x,         // int,vipʶ��
                    "emplogyee_count": x    // int,Ա������
                }
            }
            ʧ�� - {"code": <��0>, "message": "����˵��", "visible": false}
         */
        void GetTodayInfo(string cond, out string result);

        /**
         * @brief  GetCustomerFlowInfo ��ȡ������ͳ��
         * @since  2020/03/12
         *
         * @param cond ��ȡ������
            example:
            {
                "org_id":x,                 // ����,int,��֯id
                "site_list": "1,2"          // ����,string,�����б�
                "begin_date": "x",          // ����,string,��ʼʱ��
                "end_date": "x",            // ����,string,����ʱ��
            }
         * @param result �ɹ���ʧ�ܡ�����
            �ɹ� - ���ض�Ӧ�Ľ��
            {
                "code": 0,
                "info": {
                    "date_group": [
                        {
                            "date": "x",        // string,����
                            "male_count": 0,    // int,���Ե�����
                            "female_count": 0,  // int,Ů�Ե�����
                        }, ...
                    ],
                    "age_group": [
                        {
                            "age": "0-12",      // string,�����
                            "count": 0          // int,����
                        }
                    ]
                }
            }
            ʧ�� - {"code": <��0>, "message": "����˵��", "visible": false}
         */
        void GetCustomerFlowInfo(string cond, out string result);

        /**
         * @brief  GetCompetitionInfo ��ȡ��̨�Ա�����
         * @since  2020/03/12
         *
         * @param cond ��ȡ������
            example:
            {
                "org_id": x,                // ����,Int,��ָid
                "site_left": "1,2",         // ����,string,����id
                "site_right": "1,2",        // ����,string,����id
                "begin_date": "x",          // ����,string,��ʼʱ��
                "end_date": "x",            // ����,string,����ʱ��
            }
         * @param result �ɹ���ʧ�ܡ�����
            �ɹ� - ���ض�Ӧ�Ľ��
            {
                "code": 0,
                "info": {
                    "left": {
                        "site_list": "1,2", // string,����id�б�
                        "total_count": 0,   // int,�ۼƽ���
                        "vip_count": 0,     // int,vip����
                        "activity": 0.0     // double,Ա����Ծ�ȣ��˾���Ծֵ��
                    },
                    "right": {
                        "site_list": "1,2", // string,����id�б�
                        "total_count": 0,   // int,�ۼƽ���
                        "vip_count": 0,     // int,vip����
                        "activity": 0.0     // double,Ա����Ծ�ȣ��˾���Ծֵ��
                    }
                }
            }
            ʧ�� - {"code": <��0>, "message": "����˵��", "visible": false}
         */
        void GetCompetitionInfo(string cond, out string result);

        /**
         * @brief  GetVIPAttendanceInfo ��ȡVIP����ͳ��
         * @since  2020/03/12
         *
         * @param cond ��ȡ������
            example:
            {
                "org_id": x,                // ����,Int,��ָid
                "site_list": "1,2"          // ����,string,�����б�
                "begin_date": "x",          // ����,string,��ʼʱ��
                "end_date": "x",            // ����,string,����ʱ��
            }
         * @param result �ɹ���ʧ�ܡ�����
            �ɹ� - ���ض�Ӧ�Ľ��
            {
                "code": 0,
                "info": {
                    "attend_count": 0,      // int,vip��������
                    "total_count": 0        // int,vip������
                }
            }
            ʧ�� - {"code": <��0>, "message": "����˵��", "visible": false}
         */
        void GetVIPAttendanceInfo(string cond, out string result);

        /**
         * @brief  QueryCustomerStayTime ��ѯ�˿�פ��ʱ��
         * @since  2020/03/12
         *
         * @param info ��ѯ����
            example: 
            {
                "site_list": "1,2,3",   ����,string,����ID�б�
                "begin_date": "",       ����,string,��ѯ��ʼʱ��
                "end_date": "",         ����,string,��ѯ����ʱ��
                "org_id": 1,            ����,int,��֯����ID
            }
         * @param result �ɹ���ʧ�ܡ�����
            �ɹ� - ���ض�Ӧ���
            {
                "code": 0, 
                "info": {
                    "items": [
                        {
                            "date": "2020-03-03",   string,����
                            "male_stay_time": 1,    int,����ͣ��ʱ��,����
                            "female_stay_time": 1   int,Ů��ͣ��ʱ��,����
                        }, ...
                    ]
                }
            }
            ʧ�� - {"code": <��0>, "msg": "����˵��", "user_visible": false}
         */
        void QueryCustomerStayTime(string info, out string result);

        /**
         * @brief  QueryActivity ��ѯ��Ծ��
         * @since  2020/03/12
         *
         * @param info ��ѯ����
            example: 
            {
                "site_list": "1,2,3",   ����,string,����ID�б�
                "begin_date": "",       ����,string,��ѯ��ʼʱ��
                "end_date": "",         ����,string,��ѯ����ʱ��
                "org_id": 1,            ����,int,��֯����ID
            }
         * @param result �ɹ���ʧ�ܡ�����
            �ɹ� - ���ض�Ӧ���
            {
                "code": 0, 
                "info": {
                    "emplogyees": [
                        {
                            "people_id": 1,     int,Ա��id
                            "people_name": "",  string,Ա������
                            "activity": 1       int,Ա����Ծ��
                        }, ...
                    ]
                    "guids": [
                        {
                            "date": "",         string,����
                            "efficiency": 0.56  float,Ч��ֵ
                        }, ...
                    ]
                }
            }
            ʧ�� - {"code": <��0>, "msg": "����˵��", "user_visible": false}
         */
        void QueryActivity(string info, out string result);

        /*----------------------------------------------------------------------
                                        ����ͼ����
         ----------------------------------------------------------------------*/
        /**
         * @brief  QueryHeatmapList ��ȡ����ͼ�б�
         * @since  2020/04/20
         *
         * @para cond ��ѯ����
            example:
            {
                "site_id": 1,           ѡ��,int,��֯�ص�id
                "org_id": 1,            ����,int,��֯id
                "operator":"xxx"        ����,string,����Ա����
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
                            "site_id" 1,                int,��֯��ַid
                            "site_name": "test",        string,��֯��ַ��
                            "org_id": 1,                int,��֯id
                            "organization": "",         string,��֯��
                            "create_time": "2019-07-17 14:00:00"    string,����ʱ��
                        }
                    ]
                }
            }
            ʧ�� - {"code": <��0>, "msg": "����˵��", "user_visible": false}
        */
        void QueryHeatmapList(string cond, out string result);

        /**
         * @brief  QueryHeatmapData ��ȡ����ͼ����
         * @since  2020/04/20
         *
         * @para cond ��ѯ����
            example:
            {
                "heatmap_id": 1,        ����,int,����ͼӳ��id
                "begin_time": "",       ����,string,��ʼʱ��
                "end_time": ""          ����,string,����ʱ��
                "site_id": 1,           ����,int,��֯�ص�id
                "org_id": 1,            ����,int,��֯id
                "operator":"xxx"        ����,string,����Ա����
            }
         * @para result �ɹ���ʧ�ܡ���:
            �ɹ� - ���ض�Ӧ�Ľ��
            {
                "code": 0,
                "info":
                {
                    "heat_value": [
                        {
                            "x": 1,         int,x����
                            "y": 1,         int,y����
                            "heat": 1       int,����ֵ
                        },...
                    ]
                }
            }
            ʧ�� - {"code": <��0>, "msg": "����˵��", "user_visible": false}
        */
        void QueryHeatmapData(string cond, out string result);

/*****************************************������ؽӿ�*************************************/
        /**
         * @brief SetHolidays ���ýڼ���
         * @since  V1.20200409
         * @update V2.20200513
         *
         * @param info �ڼ�����Ϣ
             example:
             {
                "org_id":0,     ����,int,��֯ID
                "year": 2019,   ����,int,��
                "workdays": "1212", ����,string,�������б�,�Ը���һ��һ����,1-������ 2-��Ϣ��
                "operator": "jobs", ����,string,������
             }
         * @param result �ɹ���ʧ�ܡ�����
             �ɹ� - {"code": 0}
             ʧ�� - {"code": <��0>, "msg": "����˵��", "user_visible": false}
        */
        void SetHolidays(string info, out string result);

        /**
         * @brief GetHolidays ��ȡ�ڼ���
         * @since  V1.20200409
         * @update V2.20200513
         *
         * @param info �ڼ�����Ϣ
             example:
             {
                "year": 2019    ����,int,��
                "org_id":0      ����,int,��֯ID
                "operator": "jobs",     ����,string,������
             }
         * @param result �ɹ���ʧ�ܡ�����
            �ɹ� - ���ض�Ӧ���
            {
                "code": 0, 
                "info": {
                    "year": 2019,   int,��
                    "workdays": "1212",   string,�������б�,�Ը���һ��һ����,1-������ 2-��Ϣ��
                }
            }
            ʧ�� - {"code": <��0>, "msg": "����˵��", "user_visible": false}
        */
        void GetHolidays(string info, out string result);

        /**
         * @brief  AddLeaveInfo ��������Ϣ
         * @since  V1.20200409
         *
         * �������:
         * 1:����
         * 2:�λ�
         * 3:�¼�
         * 4:����
         * 5:����
         * 6:���
         * 7:����
         * 8:�����
         * 9:ɥ��
         * 10:����
         * @param info �����Ϣ
            example: 
            {
                "type" : 1,         ����,int,�������
                "lib_id" : 1,       ����,int,��ԱID
                "lib_name" : "xxx", ����,string,��Ա����
                "people_id" : 1,    ����,int,��ԱID
                "people_name" : "xxx",  ����,string,��Ա����
                "start_date" : "",  ����,string,��ٿ�ʼʱ��
                "end_date" : "",    ����,string,��ٽ���ʱ��
                "remark" : "",     ѡ��,string,��ע
                "org_id" : 1,       ����,int,��֯ID
                "operator": "jobs",     ����,string,������
            }
         * @param result �ɹ���ʧ�ܡ�����
            �ɹ� - {"code": 0}
            ʧ�� - {"code": <��0>, "msg": "����˵��", "user_visible": false}
         */
        void AddLeaveInfo(string info, out string result);

        /**
         * @brief  UpdateLeaveInfo ���������Ϣ
         * @since  V1.20200409
         *
         * �������:
         * 1:����
         * 2:�λ�
         * 3:�¼�
         * 4:����
         * 5:����
         * 6:���
         * 7:����
         * 8:�����
         * 9:ɥ��
         * 10:����
         * @param info �����Ϣ
            example: 
            {
                "id":0,             ����,int,��¼id
                "type" : 1,         ѡ��,int,�������
                "lib_id" : 1,       ѡ��,int,��ԱID
                "lib_name" : "xxx", ѡ��,string,��Ա����
                "people_id" : 1,    ѡ��,int,��ԱID
                "people_name" : "xxx",  ѡ��,string,��Ա����
                "start_date" : "",  ѡ��,string,��ٿ�ʼʱ��
                "end_date" : "",    ѡ��,string,��ٽ���ʱ��
                "remark" : "",      ѡ��,string,��ע
                "org_id" : 1,       ����,int,��֯ID
                "operator": "jobs",     ����,string,������
            }
         * @param result �ɹ���ʧ�ܡ�����
            �ɹ� - {"code": 0}
            ʧ�� - {"code": <��0>, "msg": "����˵��", "user_visible": false}
        */
        void UpdateLeaveInfo(string info, out string result);

        /**
         * @brief  DeleteLeaveInfo ɾ�������Ϣ
         * @since  V1.20200409
         *
         * @param info �����Ϣ
            example: 
            {
                "id":0,             ����,int,��¼id
                "org_id" : 1,       ����,int,��֯ID
                "operator": "jobs", ����,string,������
            }
         * @param result �ɹ���ʧ�ܡ�����
            �ɹ� - {"code": 0}
            ʧ�� - {"code": <��0>, "msg": "����˵��", "user_visible": false}
        */
        void DeleteLeaveInfo(string info, out string result);

        /**
         * @brief  QueryLeaveList ��ѯ�����Ϣ
         * @since  V1.20200409
         *
         * @param cond ���������Ϣ
            example:
            {
                "page_no": 1,       ����,int,ҳ��
                "page_size": 10,    ����,int,ÿҳ����
                "org_id": 0,        ����,int,��֯id
                "query_cond": {
                    "type" : 0,         ѡ��,int,�������
                    "name": "",         ѡ��,string,Ա������
                    "lib_id": 0,        ѡ��,int,�׿�id
                    "begin_time": "",   ѡ��,string,��ʼʱ��
                    "end_time": "",     ѡ��,string,����ʱ��
                }
            }
         * @param result �ɹ���ʧ�ܡ�����
            �ɹ� - ���ض�Ӧ���
            {
                "code": 0, 
                "info": {
                    "page_no":xx,
                    "page_size":xx,
                    "total_count":xx,
                    "items": [
                        {
                            "id" : 1,           int,��¼���
                            "org_id" : 1,       int,��֯ID
                            "type" : 1,         int,�������
                            "lib_id" : 1,       int,��ԱID
                            "lib_name" : "xxx", string,��Ա����
                            "people_id" : 1,    int,��ԱID
                            "people_name" : "xxx",  string,��Ա����
                            "start_date" : "",  string,��ٿ�ʼʱ��
                            "end_date" : "",    string,��ٽ���ʱ��
                            "remark" : "",      string,��ע
                        }, ...
                    ]
                }
            }
            ʧ�� - {"code": <��0>, "msg": "����˵��", "user_visible": false}
         */
        void QueryLeaveList(string cond, out string result);

        /**
         * @brief  AddReSigninInfo ��Ӳ�ǩ��Ϣ
         * @since  V1.20200409
         * @update  V2.20200514
         *
         * @param info ��ǩ��Ϣ
            example: 
            {
                "lib_id" : 1,       ����,int,�׿�ID
                "lib_name" : "",    ����,string,�׿�����
                "people_id" : 1,    ����,int,Ա��ID
                "people_name" : "", ����,string,Ա������
                "type" : 1,         ����,int,��ǩ����,1:�ϰ�,2:�°�
                "rule_id" : 1,      ����,int,����������ID
                "rule_name" : "",   ����,int,��������������
                "sub_rule_id" : 1,  ����,int,�����ӹ���ID
                "sub_rule_name" : "",   ����,int,�����ӹ�������
                "signin_date" : "", ����,string,��ǩ���� ��ʽ:"2020-01-01"
                "remark" : "",      ѡ��,string,��ǩԭ��
                "org_id" : 1,       ����,int,��֯ID
                "operator": "jobs",     ����,string,������
            }
         * @param result �ɹ���ʧ�ܡ�����
            �ɹ� - {"code": 0}
            ʧ�� - {"code": <��0>, "msg": "����˵��", "user_visible": false}
         */
        void AddReSigninInfo(string info, out string result);

        /**
         * @brief  UpdateReSigninInfo �޸Ĳ�ǩ��Ϣ
         * @since  V1.20200409
         *
         * @param info ��ǩ��Ϣ
            example: 
            {
                "rule_id" : 0,      ����,int,��¼id
                "lib_id" : 1,       ѡ��,int,�׿�ID
                "lib_name" : "",    ѡ��,string,�׿�����
                "people_id" : 1,    ѡ��,int,Ա��ID
                "people_name" : "", ѡ��,string,Ա������
                "type" : 1,         ѡ��,int,��ǩ����,1:�ϰ�,2:�°�
                "signin_date" : "", ����,string,��ǩ���� ��ʽ:"2020-01-01"
                "remark" : "",      ѡ��,string,��ǩԭ��
                "org_id" : 1,       ����,int,��֯ID
                "operator": "jobs", ����,string,������
            }
         * @param result �ɹ���ʧ�ܡ�����
            �ɹ� - {"code": 0}
            ʧ�� - {"code": <��0>, "msg": "����˵��", "user_visible": false}
         */
        void UpdateReSigninInfo(string info, out string result);

        /**
         * @brief  DeleteReSigninInfo ɾ����ǩ��Ϣ
         * @since  V1.20200409
         *
         * @param info ��ǩ��Ϣ
            example: 
            {
                "rule_id" : 1,           ����,int,��¼ID
                "org_id" : 1,       ����,int,��֯ID
                "operator": "jobs", ����,string,������
            }
         * @param result �ɹ���ʧ�ܡ�����
            �ɹ� - {"code": 0}
            ʧ�� - {"code": <��0>, "msg": "����˵��", "user_visible": false}
         */
        void DeleteReSigninInfo(string info, out string result);

        /**
         * @brief  QueryReSigninList ��ѯ��ǩ��Ϣ
         * @since  V1.20200409
         *
         * @param cond ���������Ϣ
            example:
            {
                "page_no": 1,       ����,int,ҳ��
                "page_size": 10,    ����,int,ÿҳ����
                "org_id": 0,        ����,int,�׿�id
                "query_cond": {
                    "name": "",         ѡ��,string,Ա������
                    "lib_id": 0,        ѡ��,int,�׿�id
                    "type": 0,          ѡ��,int,"1-�ϰ� 2-�°�"
                    "begin_time": "",   ѡ��,string,��ʼʱ��
                    "end_time": "",     ѡ��,string,����ʱ��
                }
            }
         * @param result �ɹ���ʧ�ܡ�����
            �ɹ� - ���ض�Ӧ���
            {
                "code": 0, 
                "info": {
                    "page_no":xx,
                    "page_size":xx,
                    "total_count":xx,
                    "items": [
                        {
                            "id" : 1,           int,��¼���
                            "org_id" : 1,       int,��֯id
                            "lib_id" : 1,       int,�׿�id
                            "lib_name" : "",    string,�׿�����
                            "rule_name" : "",   string,��������������
                            "sub_rule_name" : "",    string,�����ӹ�������
                            "people_id" : 1,    int,Ա��id
                            "people_name" : "", string,Ա������
                            "type" : 1,         int,��ǩ����,1:�ϰ�,2:�°�
                            "signin_time" : "", string,��ǩʱ�� ��ʽ:"2020-01-01"
                            "remark" : "",      string,��ǩԭ��
                        }, ...
                    ]
                }
            }
            ʧ�� - {"code": <��0>, "msg": "����˵��", "user_visible": false}
         */
        void QueryReSigninList(string cond, out string result);

        /**
         * @brief  AddAttendanceRule ��ӿ��ڹ���
         * @since  V1.20200409
         * @update  V2.20200514
         *
         * @param cond ���������Ϣ
            example:
            {
                "name":"",                  ����,string,���ڹ�����
                "enable_holiday":0,         ����,int,�ڼ�����Ϣ��ʶ��0-�ڼ��ղ����� 1-�ڼ��տ���
                "type":1,                   ����,int,�������� 1-�̶����� 2-ʱ������ 3-�Ű࿼��
                "enable_over_work":0,       ����,int,�Ƿ����Ӱ�   0-�ر� 1-����
                "property": {}              ����,�������typeȷ��
                "org_id" : 1,               ����,int,��֯ID
                "operator": "jobs",         ����,string,������
                "dead_line":"00 04:00:00"   ѡ��,string,�°࿨��ֹʱ��,�̶���ʱ�����ڱ���
                "enable_dead_line_cross":0  ѡ��,int,�°࿨��ֹʱ���Ƿ���� 0-������ 1-����,�̶���ʱ�����ڱ���
                "unsign_threshold":30,      ѡ��,int,ǩ���ӳ���ֵ, ��λ/����(�̶�ʱ��-©��/������ֵ ʱ������-������ֵ �Ű࿼��-©����ֵ)
                "over_work_threshold":30,   ѡ��,int,�Ӱ࿪ʼ�ӳ���ֵ, ��λ/����
                "remark":"",                ѡ��,string,��ע
                "dead_line_threshold":240,  ѡ��,int,��ֹʱ��,���ʱ���Ӻ���ֵ,�ְ࿼�ڱ���
                "team_count":3,             ѡ��,int,��������,�ְ࿼�ڱ���
                "shift_period":3,           ѡ��,int,�Ű�����,�ְ࿼�ڱ���
                "shift_times":3,            ѡ��,int,ÿ���Ű����,�ְ࿼�ڱ���
                "start_date":"2020-05-07",  ѡ��,string,������ʼ����,�Ű࿼�ڱ���
            }
            type=1:�̶�ʱ�����ڹ���
            "property": {
                "rule_info":    //�����������������ʱ�䲻���棬ʱ��˳������
                [
                    { 
                        "name":"rule_name",                 string,�ӹ�������
                        "start_signin_time":"00 09:00:00",  string,��ʼǩ��ʱ��
                        "end_signin_time":"00 09:00:00",    string,����ǩ��ʱ��
                        "start_signout_time":"00 18:00:00", string,��ʼǩ��ʱ��
                        "end_signout_time":"00 18:00:00",   string,����ǩ��ʱ��
                    },...
                ]
            }
            type=2:ʱ�����ڹ���
            "property": {
            
            }
            type=3:�ְ࿼�ڹ���
            "property": {
                "rule_info":
                [
                    {
                        "index":0,                          int,�ù�����������,0-��һ�� 1-�ڶ���,�Դ�����
                        "rule_index":0,                     int,�ù�������,0-��һ�� 1-�ڶ���,�Դ�����
                        "team_index":0,                     int,�ù����������
                        "sub_rule_name":"A����",            string,�ù������ð���
                        "start_signin_time":"00 07:00:00",  string,ǩ����ʼʱ��
                        "end_signin_time":"00 09:00:00",    string,ǩ������ʱ��
                        "start_signout_time":"00 17:00:00", string,ǩ�˿�ʼʱ��
                        "end_signout_time":"00 19:00:00"    string,ǩ�˽���ʱ��
                    },...
                ]
            }
         * @param result �ɹ���ʧ�ܡ�����
            �ɹ� - {"code": 0}
            ʧ�� - {"code": <��0>, "msg": "����˵��", "user_visible": false}
         */
        void AddAttendanceRule(string cond, out string result);

        /**
         * @brief  UpdateAttendanceRule ���¿��ڹ���
         * @since  V1.20200409
         *
         * @param cond ���������Ϣ
            example:
            {                
                "rule_id":0,                     ����,int,���ڹ���ID
                "name":"",                  ����,string,���ڹ�����
                "enable_holiday":0,         ����,int,�ڼ�����Ϣ��ʶ��0-�ڼ��ղ����� 1-�ڼ��տ���
                "type":1,                   ����,int,�������� 1-�̶����� 2-ʱ������ 3-�Ű࿼��
                "enable_over_work":0,       ����,int,�Ƿ����Ӱ�   0-�ر� 1-����
                "property": {}              ����,�������typeȷ��
                "org_id" : 1,               ����,int,��֯ID
                "operator": "jobs",         ����,string,������
                "dead_line":"00 04:00:00"   ѡ��,string,�°࿨��ֹʱ��,�̶���ʱ�����ڱ���
                "enable_dead_line_cross":0  ѡ��,int,�°࿨��ֹʱ���Ƿ���� 0-������ 1-����,�̶���ʱ�����ڱ���
                "unsign_threshold":30,      ѡ��,int,ǩ���ӳ���ֵ, ��λ/����(�̶�ʱ��-©��/������ֵ ʱ������-������ֵ �Ű࿼��-©����ֵ)
                "over_work_threshold":30,   ѡ��,int,�Ӱ࿪ʼ�ӳ���ֵ, ��λ/����
                "remark":"",                ѡ��,string,��ע
                "dead_line_threshold":240,  ѡ��,int,��ֹʱ��,���ʱ���Ӻ���ֵ,�ְ࿼�ڱ���
                "team_count":3,             ѡ��,int,��������,�ְ࿼�ڱ���
                "shift_period":3,           ѡ��,int,�Ű�����,�ְ࿼�ڱ���
                "shift_times":3,            ѡ��,int,ÿ���Ű����,�ְ࿼�ڱ���
                "start_date":"2020-05-07"   ѡ��,string,������ʼ����,�Ű࿼�ڱ���
            }
         * @param result �ɹ���ʧ�ܡ�����
            �ɹ� - {"code": 0}
            ʧ�� - {"code": <��0>, "msg": "����˵��", "user_visible": false}
         */
        void UpdateAttendanceRule(string cond, out string result);

        /**
         * @brief  DeleteAttendanceRule ɾ�����ڹ���
         * @since  V1.20200409
         *
         * @param cond ���������Ϣ
            example:
            {
                "rule_id":0,        ����,int,���ڹ���ID
                "type":0,           ����,int,���ڹ�������
                "org_id" : 1,       ����,int,��֯ID
                "operator": "jobs", ����,string,������
            }
         * @param result �ɹ���ʧ�ܡ�����
            �ɹ� - {"code": 0}
            ʧ�� - {"code": <��0>, "msg": "����˵��", "user_visible": false}
         */
        void DeleteAttendanceRule(string cond, out string result);

        /**
         * @brief  GetSimpleAttendanceRuleList ��ѯ�򵥿��ڹ����б�
         * @since  V1.20200409
         *
         * @param cond ���������Ϣ
            example:
            {
                "page_no": 1,       ����,int,ҳ��
                "page_size": 10,    ����,int,ÿҳ����
                "org_id":0,         ����,int,��֯ID
            }
         * @param result �ɹ���ʧ�ܡ�����
            �ɹ� - ���ض�Ӧ���
            {                
                "code": 0, 
                "info": {
                    "page_no":xx,
                    "page_size":xx,
                    "total_count":xx,
                    "items": [
                        {
                            "rule_id":0,        int,���ڹ���ID
                            "name":"",          string,���ڹ�����
                            "type":1,           int,�������� 1-�̶����� 2-ʱ������ 3-�Ű࿼��
                        }
                    ]
            }
            ʧ�� - {"code": <��0>, "msg": "����˵��", "user_visible": false}
         */
        void GetSimpleAttendanceRuleList(string cond, out string result);

        /**
         * @brief  GetSimpleSubAttendanceRuleList ��ѯ���ӹ����б�
         * @since  V1.20200409
         *
         * @param cond ���������Ϣ
            example:
            {
                "page_no": 1,       ����,int,ҳ��
                "page_size": 10,    ����,int,ÿҳ����
                "org_id":0,         ����,int,��֯ID
                "rule_id":0,        ����,int,������ID
                "type":0,           ѡ��,int,����type 1-�̶����� 2-ʱ������ 3-�Ű࿼��
            }
         * @param result �ɹ���ʧ�ܡ�����
            �ɹ� - ���ض�Ӧ���
            {                
                "code": 0, 
                "info": {
                    "page_no":xx,
                    "page_size":xx,
                    "total_count":xx,
                    "items": [
                        {
                            "rule_id":0,    int,���ڹ���ID
                            "name":"",          string,���ڹ�����
                            "type":1,           int,�������� 1-�̶����� 2-ʱ������ 3-�Ű࿼��
                            "property" : {}
                        }
                    ]
            }
            for property:
            type 1-�̶�����
            {
                "start_signin_time" : "00 09:00:00",
                "end_signin_time" : "00 09:30:00",
                "start_signout_time" : "01 09:00:00",
                "end_signout_time" : "01 09:30:00"
                "rule_id" :1,
                "sub_rule_name" : "",
                "type" : 1
            }
            ʧ�� - {"code": <��0>, "msg": "����˵��", "user_visible": false}
         */
        void GetSimpleSubAttendanceRuleList(string cond, out string result);

        /**
         * @brief  QueryAttendanceRuleList ��ѯ���ڹ����б�
         * @since  V1.20200409
         *
         * @param cond ���������Ϣ
            example:
            {
                "page_no": 1,       ����,int,ҳ��
                "page_size": 10,    ����,int,ÿҳ����
                "org_id":0,         ����,int,��֯ID
            }
         * @param result �ɹ���ʧ�ܡ�����
            �ɹ� - ���ض�Ӧ���
            {                
                "code": 0, 
                "info": {
                    "page_no":xx,
                    "page_size":xx,
                    "total_count":xx,
                    "items": [
                        {
                            "rule_id":0,        int,���ڹ���ID
                            "org_id":0,         int,��֯ID
                            "name":"",          string,���ڹ�����
                            "type":1,           int,�������� 1-�̶����� 2-ʱ������ 3-�Ű࿼��
                            "bind_count":0      int,������
                            "remark":"xxx"      string,��ע
                        }
                    ]
            }
            ʧ�� - {"code": <��0>, "msg": "����˵��", "user_visible": false}
         */
        void QueryAttendanceRuleList(string cond, out string result);

        /**
         * @brief  QueryAttendanceRuleBindList ��ѯ���ڹ�����б�
         * @since  V1.20200409
         *
         * @param cond ���������Ϣ
            example:
            {
                "page_no": 1,       ����,int,ҳ��
                "page_size": 10,    ����,int,ÿҳ����
                "type": 1,          ����,int,�������� 1-�̶����� 2-ʱ������ 3-�ְ࿼��
                "rule_id": 1,       ����,int,������ID
                "org_id":0,         ����,int,��֯ID
            }
         * @param result �ɹ���ʧ�ܡ�����
            �ɹ� - ���ض�Ӧ���
            {                
                "code": 0, 
                "info": {
                    "page_no":xx,
                    "page_size":xx,
                    "total_count":xx,
                    "items": [
                        {
                            "rule_id":0,        int,���ڹ���ID
                            "org_id":0,         int,��֯ID
                            "rule_name":"",     string,���ڹ�����
                            "type":1,           int,�������� 1-�̶����� 2-ʱ������ 3-�Ű࿼��
                            "people_id":1       int,��ԱID
                            "people_name":""    string,��Ա����
                        }
                    ]
            }
            ʧ�� - {"code": <��0>, "msg": "����˵��", "user_visible": false}
         */
        void QueryAttendanceRuleBindList(string cond, out string result);

        /**
         * @brief  QueryAttendanceRuleInfo ��ѯ���ڹ�����Ϣ
         * @since  V1.20200409
         * @update  V2.20200514
         *
         * @param cond ���������Ϣ
            example:
            {
                "org_id":0,         ����,int,��֯ID
                "type":1,           ����,int,��������, 1-�̶�ʱ������ 2-���̶�ʱ�� 3-�ְ�
                "rule_id":0,        ����,int,������ID
            }
         * @param result �ɹ���ʧ�ܡ�����
            �ɹ� - ���ض�Ӧ���
            {                
                "rule_id" : 1,          int,������ID
                "rule_name" : "",       int,����������
                "enable_holiday" : 1,   int,�ڼ��տ��� 0-������ 1-����
                "enable_cross_day" : 1, int,�Ƿ���� 0-������ 1-����
                "unsign_threshold" : 30,int,©����ֵ����λ/����
                "enable_over_work" : 1, int,�Ƿ����Ӱ� 0-�ر� 1-����
                "over_work_threshold" : 30, int,�Ӱ���ֵ,��λ/����
                "dead_line" : "01 04:00:00",int,��ֹ����
                "type" : 1,             int,�������� 1-�̶�ʱ��2-���̶�ʱ�� 3-�ְ�
                "remark" : "",          string,��ע
                "org_id" : 1,           int,��֯ID
                "rule_info" : [         �ӹ�����Ϣ
                    {}
                ],
                "dead_line_threshold":240,  int,��ֹʱ��,���ʱ���Ӻ���ֵ,�ְ࿼�ڶ���
                "team_count":3,             int,��������,�ְ࿼�ڶ���
                "shift_period":3,           int,�Ű�����,�ְ࿼�ڶ���
                "shift_times":3,            int,ÿ���Ű����,�ְ࿼�ڶ���
                "start_date":"2020-05-07",  string,������ʼ����,�ְ࿼�ڶ���
           }
            for rule_info:
            type = 1 �̶�ʱ������
            {
                "sub_rule_id" : 1,  int,�ӹ���ID
                "sub_rule_name" : "",                  string,�ӹ�������
                "start_signin_time" : "00 09:00:00",   string,��ʼǩ��ʱ��
                "end_signin_time" : "00 09:30:00",     string,����ǩ��ʱ��
                "start_signout_time" : "00 18:00:00",  string,��ʼǩ��ʱ��
                "end_signout_time" : "00 18:30:00"     string,����ǩ��ʱ��
            }
            type = 2 ʱ������
            {
            }
            type = 3 �ְ࿼��
            {
                "index":0,                          int,�ù�����������,0-��һ�� 1-�ڶ���,�Դ�����
                "rule_index":0,                     int,�ù�������,0-��һ�� 1-�ڶ���,�Դ�����
                "team_index":0,                     int,�ù����������
                "sub_rule_name":"A����",            string,�ù������ð���
                "start_signin_time":"00 07:00:00",  string,ǩ����ʼʱ��
                "end_signin_time":"00 09:00:00",    string,ǩ������ʱ��
                "start_signout_time":"00 17:00:00", string,ǩ�˿�ʼʱ��
                "end_signout_time":"00 19:00:00"    string,ǩ�˽���ʱ��
            }
            ʧ�� - {"code": <��0>, "msg": "����˵��", "user_visible": false}
         */
        void QueryAttendanceRuleInfo(string cond, out string result);

        /**
         * @brief  BatchSetAttendanceRule �������ÿ��ڹ���
         * @since  V1.20200409
         * @update  V2.20200514
         *
         * @param cond ���������Ϣ
            example:
            {
                "rule_id":0,            ����,int,���ڹ���ID
                "people_id_list":"1",   ����,string,��ԱID�б�
                "org_id" : 1,           ����,int,��֯ID
                "operator": "jobs",     ����,string,������
            }
         * @param result �ɹ���ʧ�ܡ�����
            �ɹ� - {"code": 0}
            ʧ�� - {"code": <��0>, "msg": "����˵��", "user_visible": false}
         */
        void BatchSetAttendanceRule(string cond, out string result);

        /**
         * @brief  SetPeopleAttendanceRule ���ÿ��ڹ���
         * @since  V1.20200409
         *
         * @param cond ���������Ϣ
            example:
            {
                "rule_id":0,            ����,int,���ڹ���ID
                "people_id":1,          ����,int,��ԱID
                "org_id" : 1,           ����,int,��֯ID
                "operator": "jobs"      ����,string,������
            }
         * @param result �ɹ���ʧ�ܡ�����
            �ɹ� - {"code": 0}
            ʧ�� - {"code": <��0>, "msg": "����˵��", "user_visible": false}
         */
        void SetPeopleAttendanceRule(string cond, out string result);

        /**
         * @brief  QueryCurMonthAttendance ��ѯ���¿���ͳ��
         * @since  V1.20200409
         *
         * @param cond ���������Ϣ
            example:
            {
                "org_id" : 1,           ����,int,��֯ID
                "start_time":"2020-04-01",  ����,string,��ʼʱ��
                "end_time":"2020-04-01",    ����,string,����ʱ��
                "operator": "jobs",     ����,string,������
            }
         * @param result �ɹ���ʧ�ܡ�����
            �ɹ� - ���ض�Ӧ���
            {
                "code": 0, 
                "info": {
                    "org_id" : 1,               int,��֯ID
                    "late_count" : 1,           int,�ٵ�����
                    "early_leave_count" : 1,    int,������Ա����
                    "unsignin_count" : 1,       int,©������
                    "absent_count" : 1,         int,ȱ������
                    "leave_count" : 1,          int,�������
                    "resign_count" : 1          int,��ǩ����
                }
            }
            ʧ�� - {"code": <��0>, "msg": "����˵��", "user_visible": false}
         */
        void QueryCurMonthAttendance(string cond, out string result);

        /**
         * @brief  QueryAttendanceToday ��ѯ���տ���ͳ��
         * @since  V1.20200409
         *
         * @param cond ���������Ϣ
            example:
            {
                "org_id" : 1,           ����,int,��֯ID
                "operator": "jobs",     ����,string,������
            }
         * @param result �ɹ���ʧ�ܡ�����
            �ɹ� - ���ض�Ӧ���
            {
                "code": 0, 
                "info": {
                    "org_id" : 1,               int,��֯ID
                    "people_count" : 1,         int,Ӧ����Ա����
                    "arrive_count" : 1,         int,ʵ����Ա����
                    "late_count" : 1,           int,�ٵ�����
                    "unsignin_count" : 1,       int,©������
                    "leave_count" : 1           int,�������
                }
            }
            ʧ�� - {"code": <��0>, "msg": "����˵��", "user_visible": false}
         */
        void QueryAttendanceToday(string cond, out string result);

        /**
         * @brief  QueryAttendanceList ��ѯ���ڼ�¼�б�
         * @since  V1.20200409
         *
         * @param cond ���������Ϣ
            example:
            {
                "page_no": 1,           ����,int,ҳ��
                "page_size": 10,        ����,int,ÿҳ����
                "org_id" : 1,           ����,int,��֯ID
                "operator": "jobs",     ����,string,������
                "query_cond": {
                    "start_time":"2020-04-01",  ѡ��,string,��ʼʱ��
                    "end_time":"2020-04-01",    ѡ��,string,����ʱ��
                    "lib_id":1,                 ѡ��,int,�׿�id
                    "people_name":"",           ѡ��,string,Ա������
                    "rule_id":1,                ѡ��,int,���ڹ���ID
                    "state":0                   ѡ��,int,�쳣״̬ 1-�ٵ� 2-���� 3-©�� 4-ȱ�� 5-��� 6-�Ӱ� 7-����
                }
            }
         * @param result �ɹ���ʧ�ܡ�����
            �ɹ� - ���ض�Ӧ���
            {
                "code": 0, 
                "info": {
                    "page_no":xx,
                    "page_size":xx,
                    "total_count":xx,
                    "items": [
                        {
                            "id" : 1,                   int,��¼���
                            "org_id" : 1,               int,��֯ID
                            "people_id" : 1,            int,��ԱID
                            "people_name" : "xxx",      string,��Ա����
                            "lib_id" : 1,               int,��ԱID
                            "lib_name" : "xxx",         string,��Ա����
                            "rule_id" : 1,              int,���ڹ���ID
                            "rule_name" : "",           string,���ڹ�������
                            "attend_date" : "2020-01-01",   string,��������
                            "signin_time" : "09:00:00",     string,ǩ��ʱ��
                            "signout_time" : "09:00:00",    string,ǩ��ʱ��
                            "late_mins" : 30,           int,�ٵ�ʱ�� ��λ/����
                            "early_leave_mins" : 30,    int,����ʱ�� ��λ/����
                            "over_work_mins" : 30,      int,�Ӱ�ʱ�� ��λ/����
                            "forget_sigin_times" : 1,        int,©�򿨴���,ÿ���������2��,2�μ�Ϊȱ��
                            "absent_times" : 0,         int,ȱ�ڴ���,ÿ���������ȱ�ڴ���һ��
                            "resign_times" : 0,         int,��ǩ����
                            "is_leave" : 0              int,�Ƿ����
                        }, ...
                    ]
                    "others":{                          ����ͳ������
                        "total_late_mins" : 30,         int,���гٵ����Ӻ�
                        "total_late_times" : 30,        int,���гٵ�������
                        "total_early_leave_mins" : 30,  int,�������˷��Ӻ�
                        "total_early_leave_times" : 30, int,��������������
                        "total_over_work_mins" : 30,    int,���мӰ���Ӻ�
                        "total_over_work_times" : 30,   int,���мӰ�������
                        "total_forget_sigin_times" : 30,     int,����©�򿨴���
                        "total_absent_times" : 30,      int,����ȱ�ڴ���
                        "total_leave_days" : 30         int,�����������
                    }
                }
            }
            ʧ�� - {"code": <��0>, "msg": "����˵��", "user_visible": false}
         */
        void QueryAttendanceList(string cond, out string result);

        /**
         * @brief  QueryTodayAttendanceList ��ѯ���տ��ڼ�¼�б�
         * @since  V1.20200409
         *
         * @param cond ���������Ϣ
            example:
            {

                "page_no": 1,           ����,int,ҳ��
                "page_size": 10,        ����,int,ÿҳ����
                "org_id" : 1,           ����,int,��֯ID
                "operator": "jobs",     ����,string,������
                "query_cond": {
                    "lib_id":1,                 ѡ��,int,�׿�id
                    "rule_id":1,                ѡ��,int,���ڹ���ID
                    "state":0                   ѡ��,int,�쳣״̬ 1-�ٵ� 3-©�� 5-���
                }
            }
         * @param result �ɹ���ʧ�ܡ�����
            �ɹ� - ���ض�Ӧ���
            {
                "code": 0, 
                "info": {
                    "page_no":xx,
                    "page_size":xx,
                    "total_count":xx,
                    "items": [
                        {
                            "org_id" : 1,               int,��֯ID
                            "people_id" : 1,            int,��ԱID
                            "people_name" : "xxx",      string,��Ա����
                            "lib_id" : 1,               int,��ԱID
                            "lib_name" : "xxx",         string,��Ա����
                            "rule_id" : 1,              int,���ڹ���ID
                            "rule_name" : "",           string,���ڹ�������
                            "signin_time" : "2020-04-01 09:00:00",     string,ǩ��ʱ��
                            "state" : 0                 int,1-�ٵ� 3-©�� 5-�ٵ�
                        }, ...
                    ]
                    "others":{                          ����ͳ������
                        "total_late_times" : 30,        int,���гٵ�������
                        "total_forget_sigin_times" : 30,     int,����©�򿨴���
                        "total_people" : 30,            int,���п�����Ա��
                        "total_leave_times" : 30        int,��������˴�
                    }
                }
            }
            ʧ�� - {"code": <��0>, "msg": "����˵��", "user_visible": false}
         */
        void QueryTodayAttendanceList(string cond, out string result);

        /**
         * @brief  QueryAttendanceMainPage ��ѯ��ҳ���ڼ�¼ͳ��
         * @since  V1.20200409
         *
         * @param cond ���������Ϣ
            example:
            {

                "site_list" : "1,2",        ����,string,����ID�б�
                "begin_date":"2020-04-01",  ����,string,��ʼʱ��
                "end_date":"2020-04-01",    ����,string,����ʱ��
                "org_id" : 1,               ����,int,��֯ID
                "operator": "jobs",         ����,string,������
            }
         * @param result �ɹ���ʧ�ܡ�����
            �ɹ� - ���ض�Ӧ���
            {
                "code": 0, 
                "info": {
                    "resign_count" : 30,            int,��ǩ�ܺ�
                    "late_count" : 30,              int,�ٵ��ܺ�
                    "absent_count" : 30,            int,�����ܺ�
                    "sign_count" : 30,              int,�����ܺ�
                    "record_count" : 30             int,��¼�ܺ�
                }
            }
            ʧ�� - {"code": <��0>, "msg": "����˵��", "user_visible": false}
         */
        void QueryAttendanceMainPage(string cond, out string result);
/*****************************************������ؽӿڽ���*************************************/
    };
};
