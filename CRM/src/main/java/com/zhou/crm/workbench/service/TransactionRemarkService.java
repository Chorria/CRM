package com.zhou.crm.workbench.service;

import com.zhou.crm.workbench.domain.TransactionRemark;

import java.util.List;

public interface TransactionRemarkService {
    List<TransactionRemark> queryTransactionRemarkForDetailByTransactionId(String transactionId);

    int saveCreateTransactionRemark(TransactionRemark transactionRemark);

    int saveEditTransactionRemark(TransactionRemark transactionRemark);

    int deleteTransactionRemarkById(String id);
}
