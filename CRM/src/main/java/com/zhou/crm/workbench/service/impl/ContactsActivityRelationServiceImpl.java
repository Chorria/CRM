package com.zhou.crm.workbench.service.impl;

import com.zhou.crm.workbench.domain.ContactsActivityRelation;
import com.zhou.crm.workbench.mapper.ContactsActivityRelationMapper;
import com.zhou.crm.workbench.service.ContactsActivityRelationService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Map;

@Service("contactsActivityRelationService")
public class ContactsActivityRelationServiceImpl implements ContactsActivityRelationService {
    @Autowired
    private ContactsActivityRelationMapper contactsActivityRelationMapper;
    @Override
    public int saveCreateContactsActivityRelationByList(List<ContactsActivityRelation> list) {
        return contactsActivityRelationMapper.insertContactsActivityRelationByList(list);
    }

    @Override
    public int deleteContactsActivityRelationByActivityId(String activityId) {
        return contactsActivityRelationMapper.deleteContactsActivityRelationByActivityId(activityId);
    }
}
