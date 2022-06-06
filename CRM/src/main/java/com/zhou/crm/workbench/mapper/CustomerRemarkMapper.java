package com.zhou.crm.workbench.mapper;

import com.zhou.crm.workbench.domain.CustomerRemark;

import java.util.List;

public interface CustomerRemarkMapper {
    int deleteByPrimaryKey(String id);

    int insert(CustomerRemark record);

    int insertSelective(CustomerRemark record);

    CustomerRemark selectByPrimaryKey(String id);

    int updateByPrimaryKeySelective(CustomerRemark record);

    int updateByPrimaryKey(CustomerRemark record);

    /**
     * 根据customerID查询所有的客户信息备注
     * @param customerId
     * @return
     */
    List<CustomerRemark> selectCustomerRemarkForDetailByCustomerId(String customerId);

    /**
     * 添加客户备注
     * @param customerRemark
     * @return
     */
    int insertCustomerRemark(CustomerRemark customerRemark);

    /**
     * 修改客户备注信息
     * @param customerRemark
     * @return
     */
    int updateCustomerRemark(CustomerRemark customerRemark);

    /**
     * 根据id删除客户备注信息
     * @param id
     * @return
     */
    int deleteCustomerRemarkById(String id);

    /**
     * 根据customerIds批量删除客户备注
     * @param customerIds
     * @return
     */
    int deleteCustomerRemarkByCustomerIds(String[] customerIds);

    /**
     * 根据list批量新建客户备注
     * @param list
     * @return
     */
    int insertCustomerRemarkByList(List<CustomerRemark> list);
}