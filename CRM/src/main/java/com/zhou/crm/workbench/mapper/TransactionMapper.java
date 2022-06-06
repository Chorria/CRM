package com.zhou.crm.workbench.mapper;

import com.zhou.crm.workbench.domain.FunnelVO;
import com.zhou.crm.workbench.domain.Transaction;

import java.util.List;
import java.util.Map;

public interface TransactionMapper {
    int deleteByPrimaryKey(String id);

    int insert(Transaction record);

    int insertSelective(Transaction record);

    Transaction selectByPrimaryKey(String id);

    int updateByPrimaryKeySelective(Transaction record);

    int updateByPrimaryKey(Transaction record);

    /**
     * 根据customerId查询该客户所涉及的所有交易信息
     * @param customerId
     * @return
     */
    List<Transaction> selectTransactionForDetailByCustomerId(String customerId);

    /**
     * 添加交易
     * @param transaction
     * @return
     */
    int insertTransaction(Transaction transaction);

    /**
     * 根据id删除交易
     * @param id
     * @return
     */
    int deleteTransactionById(String id);

    /**
     * 根据customerIds批量删除交易
     * @param customerIds
     * @return
     */
    int deleteTransactionByCustomerIds(String[] customerIds);

    /**
     * 根据contactsId查询交易
     * @param contactsId
     * @return
     */
    List<Transaction> selectTransactionForDetailByContactsId(String contactsId);

    /**
     * 根据contactsIds批量删除交易
     * @param contactsIds
     * @return
     */
    int deleteTransactionByContactsIds(String[] contactsIds);

    /**
     * 分页查询交易
     * @param map
     * @return
     */
    List<Transaction> selectTransactionByConditionForPage(Map<String,Object> map);

    /**
     * 查询分页查询交易的总条数
     * @param map
     * @return
     */
    int selectCountOfTransactionByConditionForPage(Map<String,Object> map);

    /**
     * 根据id查询交易
     * @param id
     * @return
     */
    Transaction selectTransactionForEditById(String id);

    /**
     * 修改交易
     * @param transaction
     * @return
     */
    int updateTransaction(Transaction transaction);

    /**
     * 根据ids批量删除交易
     * @param ids
     * @return
     */
    int deleteTransactionByIds(String[] ids);

    /**
     * 根据id查询交易明细
     * @param id
     * @return
     */
    Transaction selectTransactionForDetailById(String id);

    /**
     * 在交易明细页，根据map修改交易阶段
     * @param map
     * @return
     */
    int updateTransactionForDetailByMap(Map<String,Object> map);

    /**
     * 查询交易表中各个阶段的数据量
     * @return
     */
    List<FunnelVO> selectCountOfTransactionGroupByStage();
}