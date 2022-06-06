package com.zhou.crm.workbench.mapper;

import com.zhou.crm.workbench.domain.TransactionHistory;

import java.util.List;

public interface TransactionHistoryMapper {
    int deleteByPrimaryKey(String id);

    int insert(TransactionHistory record);

    int insertSelective(TransactionHistory record);

    TransactionHistory selectByPrimaryKey(String id);

    int updateByPrimaryKeySelective(TransactionHistory record);

    int updateByPrimaryKey(TransactionHistory record);

    /**
     * 保存新建的交易历史
     * @param transactionHistory
     * @return
     */
    int insertTransactionHistory(TransactionHistory transactionHistory);

    /**
     * 根据transactionId查询交易历史信息
     * @param transactionId
     * @return
     */
    List<TransactionHistory> selectTransactionHistoryByTransactionId(String transactionId);

    /**
     * 根据transactionIds批量删除交易历史信息
     * @param transactionIds
     * @return
     */
    int deleteTransactionHistoryByTransactionIds(String[] transactionIds);
}