package com.zhou.crm.workbench.service.impl;

import com.zhou.crm.workbench.domain.TransactionRemark;
import com.zhou.crm.workbench.mapper.TransactionRemarkMapper;
import com.zhou.crm.workbench.service.TransactionRemarkService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service("transactionRemarkService")
public class TransactionRemarkServiceImpl implements TransactionRemarkService {
    @Autowired
    private TransactionRemarkMapper transactionRemarkMapper;
    @Override
    public List<TransactionRemark> queryTransactionRemarkForDetailByTransactionId(String transactionId) {
        return transactionRemarkMapper.selectTransactionRemarkForDetailByTransactionId(transactionId);
    }

    @Override
    public int saveCreateTransactionRemark(TransactionRemark transactionRemark) {
        return transactionRemarkMapper.insertTransactionRemark(transactionRemark);
    }

    @Override
    public int saveEditTransactionRemark(TransactionRemark transactionRemark) {
        return transactionRemarkMapper.updateTransactionRemark(transactionRemark);
    }

    @Override
    public int deleteTransactionRemarkById(String id) {
        return transactionRemarkMapper.deleteTransactionRemarkById(id);
    }
}
