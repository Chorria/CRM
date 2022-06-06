package com.zhou.crm.workbench.mapper;

import com.zhou.crm.workbench.domain.Contacts;
import com.zhou.crm.workbench.domain.FunnelVO;

import java.util.List;
import java.util.Map;

public interface ContactsMapper {
    int deleteByPrimaryKey(String id);

    int insert(Contacts record);

    int insertSelective(Contacts record);

    Contacts selectByPrimaryKey(String id);

    int updateByPrimaryKeySelective(Contacts record);

    int updateByPrimaryKey(Contacts record);

    /**
     * 根据customerId查询该客户所涉及的联系人信息
     * @param customerId
     * @return
     */
    List<Contacts> selectContactsForDetailByCustomerId(String customerId);

    /**
     * 根据联系人名字contactsName查询联系人
     * @param name
     * @return
     */
    List<Contacts> selectContactsByName(String name);

    /**
     * 客户明细页中保存新建的联系人
     * @param contacts
     * @return
     */
    int insertContactsForDetail(Contacts contacts);

    /**
     * 客户明细页中根据id删除联系人
     * @param id
     * @return
     */
    int deleteContactsForDetail(String id);

    /**
     * 根据customerIds批量删除联系人
     * @param customerIds
     * @return
     */
    int deleteContactsForDetailByCustomerIds(String[] customerIds);

    /**
     * 保存新建的联系人
     * @param contacts
     * @return
     */
    int insertContacts(Contacts contacts);

    /**
     * 分页查询所有的联系人
     * @param map
     * @return
     */
    List<Contacts> selectContactsByConditionForPage(Map<String,Object> map);

    /**
     * 查询联系人的总条数
     * @param map
     * @return
     */
    int selectCountOfContactsByConditionForPage(Map<String,Object> map);

    /**
     * 根据id查询联系人
     * @param id
     * @return
     */
    Contacts selectContactsById(String id);
    /**
     * 修改联系人
     * @param contacts
     * @return
     */
    int updateContacts(Contacts contacts);

    /**
     * 根据id删除联系人
     * @param ids
     * @return
     */
    int deleteContactsByIds(String[] ids);

    /**
     * 根据id查询联系人明细
     * @param id
     * @return
     */
    Contacts selectContactsForDetailById(String id);

    /**
     * 查询联系人表中各个客户的数据量
     * @return
     */
    List<FunnelVO> selectCountOfContactsGroupByCustomerId();
}