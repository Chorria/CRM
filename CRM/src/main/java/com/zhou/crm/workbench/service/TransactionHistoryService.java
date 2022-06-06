package com.zhou.crm.workbench.service;

import com.zhou.crm.workbench.domain.TransactionHistory;

import java.util.List;

public interface TransactionHistoryService {
    List<TransactionHistory> queryTransactionHistoryForDetailByTransactionId(String transactionId);
}
