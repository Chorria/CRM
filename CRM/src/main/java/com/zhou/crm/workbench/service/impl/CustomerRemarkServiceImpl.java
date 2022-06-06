package com.zhou.crm.workbench.service.impl;

import com.zhou.crm.workbench.domain.CustomerRemark;
import com.zhou.crm.workbench.mapper.CustomerRemarkMapper;
import com.zhou.crm.workbench.service.CustomerRemarkService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service("customerRemarkService")
public class CustomerRemarkServiceImpl implements CustomerRemarkService {
    @Autowired
    private CustomerRemarkMapper customerRemarkMapper;
    @Override
    public List<CustomerRemark> queryCustomerRemarkForDetailByCustomerId(String customerId) {
        return customerRemarkMapper.selectCustomerRemarkForDetailByCustomerId(customerId);
    }

    @Override
    public int saveCreateCustomerRemark(CustomerRemark customerRemark) {
        return customerRemarkMapper.insertCustomerRemark(customerRemark);
    }

    @Override
    public int saveEditCustomerRemark(CustomerRemark customerRemark) {
        return customerRemarkMapper.updateCustomerRemark(customerRemark);
    }

    @Override
    public int deleteCustomerRemarkById(String id) {
        return customerRemarkMapper.deleteCustomerRemarkById(id);
    }
}
