package com.zhou.crm.workbench.service.impl;

import com.zhou.crm.commons.constants.Constants;
import com.zhou.crm.commons.utils.DateUtils;
import com.zhou.crm.commons.utils.UUIDUtils;
import com.zhou.crm.settings.domain.User;
import com.zhou.crm.workbench.domain.*;
import com.zhou.crm.workbench.mapper.ContactsMapper;
import com.zhou.crm.workbench.mapper.CustomerMapper;
import com.zhou.crm.workbench.mapper.CustomerRemarkMapper;
import com.zhou.crm.workbench.mapper.TransactionMapper;
import com.zhou.crm.workbench.service.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.Date;
import java.util.List;
import java.util.Map;

@Service("customerService")
public class CustomerServiceImpl implements CustomerService {
    @Autowired
    private CustomerMapper customerMapper;
    @Autowired
    private CustomerRemarkMapper customerRemarkMapper;
    @Autowired
    private TransactionMapper transactionMapper;
    @Autowired
    private ContactsMapper contactsMapper;

    @Override
    public int saveCreateCustomer(Customer customer) {
        return customerMapper.insertCustomer(customer);
    }

    @Override
    public List<Customer> queryCustomerByConditionForPage(Map<String, Object> map) {
        return customerMapper.selectCustomerByConditionForPage(map);
    }

    @Override
    public int queryCountOfCustomerByCondition(Map<String, Object> map) {
        return customerMapper.selectCountOfCustomerByCondition(map);
    }

    @Override
    public Customer queryCustomerById(String id) {
        return customerMapper.selectCustomerById(id);
    }

    @Override
    public int saveEditCustomer(Customer customer) {
        return customerMapper.updateCustomer(customer);
    }

    @Override
    public Customer queryCustomerForDetailById(String id) {
        return customerMapper.selectCustomerForDetailById(id);
    }

    @Override
    public void deleteCustomer(String[] id) {
        //删除顾客信息下所绑定的备注信息、交易信息及联系人
        customerRemarkMapper.deleteCustomerRemarkByCustomerIds(id);
        transactionMapper.deleteTransactionByCustomerIds(id);
        contactsMapper.deleteContactsForDetailByCustomerIds(id);
        customerMapper.deleteCustomerByIds(id);
    }

    @Override
    public List<String> queryCustomerNameByName(String name) {
        return customerMapper.selectCustomerNameByName(name);
    }

    @Override
    public Customer queryCustomerByName(String name) {
        return customerMapper.selectCustomerByName(name);
    }


}
