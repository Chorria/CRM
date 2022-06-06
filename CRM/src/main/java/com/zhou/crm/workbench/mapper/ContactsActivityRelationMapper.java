package com.zhou.crm.workbench.mapper;

import com.zhou.crm.workbench.domain.ContactsActivityRelation;

import java.util.List;

public interface ContactsActivityRelationMapper {
    int deleteByPrimaryKey(String id);

    int insert(ContactsActivityRelation record);

    int insertSelective(ContactsActivityRelation record);

    ContactsActivityRelation selectByPrimaryKey(String id);

    int updateByPrimaryKeySelective(ContactsActivityRelation record);

    int updateByPrimaryKey(ContactsActivityRelation record);

    /**
     * 根据list批量新建联系人和市场活动的关联关系
     * @param list
     * @return
     */
    int insertContactsActivityRelationByList(List<ContactsActivityRelation> list);

    /**
     * 根据contactsIds批量删除联系人和市场活动的关联关系
     * @param contactsIds
     * @return
     */
    int deleteContactsActivityRelationByContactsIds(String[] contactsIds);

    /**
     * 根据activityId删除联系人和市场活动的关联关系
     * @param activityId
     * @return
     */
    int deleteContactsActivityRelationByActivityId(String activityId);
}