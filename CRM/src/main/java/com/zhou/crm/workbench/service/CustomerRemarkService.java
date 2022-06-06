package com.zhou.crm.workbench.service;

import com.zhou.crm.workbench.domain.CustomerRemark;

import java.util.List;

public interface CustomerRemarkService {
    List<CustomerRemark> queryCustomerRemarkForDetailByCustomerId(String customerId);

    int saveCreateCustomerRemark(CustomerRemark customerRemark);

    int saveEditCustomerRemark(CustomerRemark customerRemark);

    int deleteCustomerRemarkById(String id);
}
