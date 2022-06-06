package com.zhou.crm.workbench.service;

import com.zhou.crm.workbench.domain.Customer;

import java.util.List;
import java.util.Map;

public interface CustomerService {
    int saveCreateCustomer(Customer customer);

    List<Customer> queryCustomerByConditionForPage(Map<String,Object> map);

    int queryCountOfCustomerByCondition(Map<String,Object> map);

    Customer queryCustomerById(String id);

    int saveEditCustomer(Customer customer);

    Customer queryCustomerForDetailById(String id);

    void deleteCustomer(String[] id);

    List<String> queryCustomerNameByName(String name);

    Customer queryCustomerByName(String name);
}
