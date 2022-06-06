package com.zhou.crm.workbench.service;

import com.zhou.crm.workbench.domain.FunnelVO;
import com.zhou.crm.workbench.domain.Transaction;

import java.util.List;
import java.util.Map;

public interface TransactionService {
    List<Transaction> queryTransactionForDetailByCustomerId(String customerId);

    void saveCreateTransaction(Map<String,Object> map);

    int deleteTransactionById(String id);

    List<Transaction> queryTransactionForDetailByContactsId(String contactsId);

    List<Transaction> queryTransactionByConditionForPage(Map<String,Object> map);

    int queryCountOfTransactionByConditionForPage(Map<String,Object> map);

    Transaction queryTransactionForEditById(String id);

    void saveEditTransaction(Map<String,Object> map);

    void deleteTransactionByIds(String[] ids);

    Transaction queryTransactionForDetailById(String id);

    void saveEditTransactionForDetailByMap(Map<String,Object> map);

    List<FunnelVO> queryCountOfTransactionGroupByStage();
}
