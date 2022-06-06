package com.zhou.crm.workbench.mapper;

import com.zhou.crm.workbench.domain.Customer;

import java.util.List;
import java.util.Map;

public interface CustomerMapper {
    int deleteByPrimaryKey(String id);

    int insert(Customer record);

    int insertSelective(Customer record);

    Customer selectByPrimaryKey(String id);

    int updateByPrimaryKeySelective(Customer record);

    int updateByPrimaryKey(Customer record);

    /**
     * 保存创建的客户信息
     * @param customer
     * @return
     */
    int insertCustomer(Customer customer);

    /**
     * 分页查询客户信息
     * @param map
     * @return
     */
    List<Customer> selectCustomerByConditionForPage(Map<String,Object> map);

    /**
     * 查询客户的总条数
     * @return
     */
    int selectCountOfCustomerByCondition(Map<String,Object> map);

    /**
     * 根据id查询客户信息
     * @param id
     * @return
     */
    Customer selectCustomerById(String id);

    /**
     * 修改客户信息
     * @param customer
     * @return
     */
    int updateCustomer(Customer customer);

    /**
     * 根据ids批量删除客户信息
     * @param ids
     * @return
     */
    int deleteCustomerByIds(String[] ids);

    /**
     * 根据id查询客户信息明细
     * @param id
     * @return
     */
    Customer selectCustomerForDetailById(String id);

    /**
     * 根据name查询客户信息
     * @param name
     * @return
     */
    Customer selectCustomerByName(String name);

    /**
     * 根据name 查询客户名称
     * @param name
     * @return
     */
    List<String> selectCustomerNameByName(String name);
}