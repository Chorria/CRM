package com.zhou.crm.workbench.service;

import com.zhou.crm.workbench.domain.ContactsRemark;

import java.util.List;

public interface ContactsRemarkService {
    List<ContactsRemark> queryContactsRemarkForDetailByContactsId(String contactsId);

    int saveCreateContactsRemark(ContactsRemark contactsRemark);

    int saveEditContactsRemark(ContactsRemark contactsRemark);

    int deleteContactsRemarkById(String id);
}
