package com.zhou.crm.workbench.service;

import com.zhou.crm.workbench.domain.ContactsActivityRelation;

import java.util.List;

public interface ContactsActivityRelationService {
    int saveCreateContactsActivityRelationByList(List<ContactsActivityRelation> list);

    int deleteContactsActivityRelationByActivityId(String activityId);
}
