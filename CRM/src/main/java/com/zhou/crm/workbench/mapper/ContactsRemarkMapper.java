package com.zhou.crm.workbench.mapper;

import com.zhou.crm.workbench.domain.ContactsRemark;

import java.util.List;

public interface ContactsRemarkMapper {
    int deleteByPrimaryKey(String id);

    int insert(ContactsRemark record);

    int insertSelective(ContactsRemark record);

    ContactsRemark selectByPrimaryKey(String id);

    int updateByPrimaryKeySelective(ContactsRemark record);

    int updateByPrimaryKey(ContactsRemark record);

    /**
     * 根据list批量新建联系人备注
     * @param list
     * @return
     */
    int insertContactsRemarkByList(List<ContactsRemark> list);

    /**
     * 根据id查询联系人备注
     * @param contactsId
     * @return
     */
    List<ContactsRemark> selectContactsRemarkForDetailByContactsId(String contactsId);

    /**
     * 根据contactsIds批量删除联系人备注
     * @param contactsIds
     * @return
     */
    int deleteContactsRemarkByContactsIds(String[] contactsIds);

    /**
     * 新建联系人备注
     * @param contactsRemark
     * @return
     */
    int insertContactsRemark(ContactsRemark contactsRemark);

    /**
     * 根据contactsId修改联系人备注
     * @param contactsRemark
     * @return
     */
    int updateContactsRemark(ContactsRemark contactsRemark);

    /**
     * 根据id删除联系人备注
     * @param id
     * @return
     */
    int deleteContactsRemarkById(String id);
}