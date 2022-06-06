package com.zhou.crm.workbench.service.impl;

import com.zhou.crm.commons.constants.Constants;
import com.zhou.crm.commons.utils.DateUtils;
import com.zhou.crm.commons.utils.UUIDUtils;
import com.zhou.crm.settings.domain.User;
import com.zhou.crm.workbench.domain.Contacts;
import com.zhou.crm.workbench.domain.Customer;
import com.zhou.crm.workbench.domain.FunnelVO;
import com.zhou.crm.workbench.mapper.*;
import com.zhou.crm.workbench.service.ContactsService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.Date;
import java.util.List;
import java.util.Map;

@Service("contactsService")
public class ContactsServiceImpl implements ContactsService {
    @Autowired
    private ContactsMapper contactsMapper;
    @Autowired
    private CustomerMapper customerMapper;
    @Autowired
    private ContactsRemarkMapper contactsRemarkMapper;
    @Autowired
    private TransactionMapper transactionMapper;
    @Autowired
    private ContactsActivityRelationMapper contactsActivityRelationMapper;
    @Override
    public List<Contacts> queryContactsForDetailByCustomerId(String customerId) {
        return contactsMapper.selectContactsForDetailByCustomerId(customerId);
    }

    @Override
    public List<Contacts> queryContactsByName(String name) {
        return contactsMapper.selectContactsByName(name);
    }

    @Override
    public int saveCreateContactsForDetail(Contacts contacts) {
        return contactsMapper.insertContactsForDetail(contacts);
    }

    @Override
    public int deleteContactsForDetail(String id) {
        return contactsMapper.deleteContactsForDetail(id);
    }

    @Override
    public void saveCreateContacts(Map<String,Object> map) {
        String customerName = (String) map.get("customerName");
        User user = (User) map.get(Constants.SESSION_USER);
        Contacts contacts = new Contacts();
        //封装参数
        contacts.setId(UUIDUtils.getUUID());
        contacts.setOwner((String) map.get("owner"));
        contacts.setSource((String) map.get("source"));
        Customer customer = customerMapper.selectCustomerByName(customerName);
        //若客户名称不存在,则新建客户
        if (customer == null) {
            customer = new Customer();
            customer.setId(UUIDUtils.getUUID());
            customer.setOwner(user.getId());
            customer.setName(customerName);
            customer.setCreateBy(user.getId());
            customer.setCreateTime(DateUtils.formatDateTime(new Date()));
            customerMapper.insertCustomer(customer);
        }
        contacts.setCustomerId(customer.getId());
        contacts.setFullname((String) map.get("fullname"));
        contacts.setAppellation((String) map.get("appellation"));
        contacts.setEmail((String) map.get("email"));
        contacts.setMphone((String) map.get("mphone"));
        contacts.setBirthday((String) map.get("birthday"));
        contacts.setJob((String) map.get("job"));
        contacts.setCreateBy(user.getId());
        contacts.setCreateTime(DateUtils.formatDateTime(new Date()));
        contacts.setDescription((String) map.get("description"));
        contacts.setContactSummary((String) map.get("contactSummary"));
        contacts.setNextContactTime((String) map.get("nextContactTime"));
        contacts.setAddress((String) map.get("address"));
        contactsMapper.insertContacts(contacts);
    }

    @Override
    public List<Contacts> queryContactsByConditionForPage(Map<String, Object> map) {
        return contactsMapper.selectContactsByConditionForPage(map);
    }

    @Override
    public int queryCountOfContactsByConditionForPage(Map<String, Object> map) {
        return contactsMapper.selectCountOfContactsByConditionForPage(map);
    }

    @Override
    public Contacts queryContactsById(String id) {
        return contactsMapper.selectContactsById(id);
    }

    @Override
    public void updateContacts(Map<String,Object> map) {
        String customerName = (String) map.get("customerName");
        User user = (User) map.get(Constants.SESSION_USER);
        Contacts contacts = new Contacts();
        //封装参数
        contacts.setId((String) map.get("id"));
        contacts.setOwner((String) map.get("owner"));
        contacts.setSource((String) map.get("source"));
        Customer customer = customerMapper.selectCustomerByName(customerName);
        //若客户名称不存在,则新建客户
        if (customer == null) {
            customer = new Customer();
            customer.setId(UUIDUtils.getUUID());
            customer.setOwner(user.getId());
            customer.setName(customerName);
            customer.setCreateBy(user.getId());
            customer.setCreateTime(DateUtils.formatDateTime(new Date()));
            customerMapper.insertCustomer(customer);
        }
        contacts.setCustomerId(customer.getId());
        contacts.setFullname((String) map.get("fullname"));
        contacts.setAppellation((String) map.get("appellation"));
        contacts.setEmail((String) map.get("email"));
        contacts.setMphone((String) map.get("mphone"));
        contacts.setBirthday((String) map.get("birthday"));
        contacts.setJob((String) map.get("job"));
        contacts.setEditBy(user.getId());
        contacts.setEditTime(DateUtils.formatDateTime(new Date()));
        contacts.setDescription((String) map.get("description"));
        contacts.setContactSummary((String) map.get("contactSummary"));
        contacts.setNextContactTime((String) map.get("nextContactTime"));
        contacts.setAddress((String) map.get("address"));
        //修改联系人
        contactsMapper.updateContacts(contacts);
    }

    @Override
    public void deleteContactsByIds(String[] ids) {
        //删除联系人备注
        contactsRemarkMapper.deleteContactsRemarkByContactsIds(ids);
        //删除联系人所关联的交易
        transactionMapper.deleteTransactionByContactsIds(ids);
        //删除联系人与市场活动的关联关系
        contactsActivityRelationMapper.deleteContactsActivityRelationByContactsIds(ids);
        //删除联系人
        contactsMapper.deleteContactsByIds(ids);
    }

    @Override
    public Contacts queryContactsForDetailById(String id) {
        return contactsMapper.selectContactsForDetailById(id);
    }

    @Override
    public List<FunnelVO> queryCountOfContactsGroupByCustomerId() {
        return contactsMapper.selectCountOfContactsGroupByCustomerId();
    }
}
