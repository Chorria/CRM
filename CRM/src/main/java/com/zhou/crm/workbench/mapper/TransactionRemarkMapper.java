package com.zhou.crm.workbench.mapper;

import com.zhou.crm.workbench.domain.TransactionRemark;

import java.util.List;

public interface TransactionRemarkMapper {
    int deleteByPrimaryKey(String id);

    int insert(TransactionRemark record);

    int insertSelective(TransactionRemark record);

    TransactionRemark selectByPrimaryKey(String id);

    int updateByPrimaryKeySelective(TransactionRemark record);

    int updateByPrimaryKey(TransactionRemark record);

    /**
     * 根据list批量新建交易备注
     * @param list
     * @return
     */
    int insertTransactionRemarkByList(List<TransactionRemark> list);

    /**
     * 根据id查询所有的交易备注
     * @param transactionId
     * @return
     */
    List<TransactionRemark> selectTransactionRemarkForDetailByTransactionId(String transactionId);

    /**
     * 新建交易备注
     * @param transactionRemark
     * @return
     */
    int insertTransactionRemark(TransactionRemark transactionRemark);

    /**
     * 修改交易备注
     * @param transactionRemark
     * @return
     */
    int updateTransactionRemark(TransactionRemark transactionRemark);

    /**
     * 根据id删除交易备注
     * @param id
     * @return
     */
    int deleteTransactionRemarkById(String id);

    /**
     * 根据transactionIds批量删除交易备注
     * @param transactionIds
     * @return
     */
    int deleteTransactionRemarkByTransactionIds(String[] transactionIds);
}