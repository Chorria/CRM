package com.zhou.crm.workbench.service.impl;

import com.zhou.crm.workbench.domain.TransactionHistory;
import com.zhou.crm.workbench.mapper.TransactionHistoryMapper;
import com.zhou.crm.workbench.service.TransactionHistoryService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service("transactionHistoryService")
public class TransactionHistoryServiceImpl implements TransactionHistoryService {
    @Autowired
    private TransactionHistoryMapper transactionHistoryMapper;
    @Override
    public List<TransactionHistory> queryTransactionHistoryForDetailByTransactionId(String transactionId) {
        return transactionHistoryMapper.selectTransactionHistoryByTransactionId(transactionId);
    }
}
