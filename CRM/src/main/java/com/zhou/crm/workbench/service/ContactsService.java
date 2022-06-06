package com.zhou.crm.workbench.service;

import com.zhou.crm.workbench.domain.Contacts;
import com.zhou.crm.workbench.domain.FunnelVO;

import java.util.List;
import java.util.Map;

public interface ContactsService {
    List<Contacts> queryContactsForDetailByCustomerId(String customerId);

    List<Contacts> queryContactsByName(String name);

    int saveCreateContactsForDetail(Contacts contacts);

    int deleteContactsForDetail(String id);

    void saveCreateContacts(Map<String,Object> map);

    List<Contacts> queryContactsByConditionForPage(Map<String,Object> map);

    int queryCountOfContactsByConditionForPage(Map<String,Object> map);

    Contacts queryContactsById(String id);

    void updateContacts(Map<String,Object> map);

    void deleteContactsByIds(String[] ids);

    Contacts queryContactsForDetailById(String id);

    List<FunnelVO> queryCountOfContactsGroupByCustomerId();
}
