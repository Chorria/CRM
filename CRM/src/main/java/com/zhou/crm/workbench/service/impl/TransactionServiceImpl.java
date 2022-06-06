package com.zhou.crm.workbench.service.impl;

import com.zhou.crm.commons.constants.Constants;
import com.zhou.crm.commons.utils.DateUtils;
import com.zhou.crm.commons.utils.UUIDUtils;
import com.zhou.crm.settings.domain.User;
import com.zhou.crm.workbench.domain.Customer;
import com.zhou.crm.workbench.domain.FunnelVO;
import com.zhou.crm.workbench.domain.Transaction;
import com.zhou.crm.workbench.domain.TransactionHistory;
import com.zhou.crm.workbench.mapper.CustomerMapper;
import com.zhou.crm.workbench.mapper.TransactionHistoryMapper;
import com.zhou.crm.workbench.mapper.TransactionMapper;
import com.zhou.crm.workbench.mapper.TransactionRemarkMapper;
import com.zhou.crm.workbench.service.TransactionService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.Date;
import java.util.List;
import java.util.Map;
import java.util.ResourceBundle;

@Service("transactionService")
public class TransactionServiceImpl implements TransactionService {
    @Autowired
    private CustomerMapper customerMapper;
    @Autowired
    private TransactionMapper transactionMapper;
    @Autowired
    private TransactionRemarkMapper transactionRemarkMapper;
    @Autowired
    private TransactionHistoryMapper transactionHistoryMapper;
    @Override
    public List<Transaction> queryTransactionForDetailByCustomerId(String customerId) {
        return transactionMapper.selectTransactionForDetailByCustomerId(customerId);
    }

    @Override
    public void saveCreateTransaction(Map<String,Object> map) {
        String customerName = (String) map.get("customerName");
        User user = (User) map.get(Constants.SESSION_USER);
        //根据name精确查询客户
        Customer customer = customerMapper.selectCustomerByName(customerName);
        //如果客户不存在，则新建客户
        if (customer == null) {
            customer = new Customer();
            customer.setId(UUIDUtils.getUUID());
            customer.setOwner(user.getId());
            customer.setName((String) map.get("customerName"));
            customer.setCreateBy(user.getId());
            customer.setCreateTime(DateUtils.formatDateTime(new Date()));
            customerMapper.insertCustomer(customer);
        }
        //保存创建的交易
        Transaction transaction = new Transaction();
        transaction.setId(UUIDUtils.getUUID());
        transaction.setOwner(user.getId());
        transaction.setMoney((String) map.get("money"));
        transaction.setName((String) map.get("name"));
        transaction.setExpectedDate((String) map.get("expectedDate"));
        transaction.setCustomerId(customer.getId());
        transaction.setStage((String) map.get("stage"));
        transaction.setType((String) map.get("type"));
        transaction.setSource((String) map.get("source"));
        transaction.setActivityId((String) map.get("activityId"));
        transaction.setContactsId((String) map.get("contactsId"));
        transaction.setCreateBy(user.getId());
        transaction.setCreateTime(DateUtils.formatDateTime(new Date()));
        transaction.setDescription((String) map.get("description"));
        transaction.setContactSummary((String) map.get("contactSummary"));
        transaction.setNextContactTime((String) map.get("nextContactTime"));
        transactionMapper.insertTransaction(transaction);
        //保存交易历史
        TransactionHistory transactionHistory = new TransactionHistory();
        transactionHistory.setId(UUIDUtils.getUUID());
        transactionHistory.setStage(transaction.getStage());
        transactionHistory.setMoney((transaction.getMoney()));
        transactionHistory.setExpectedDate(transaction.getExpectedDate());
        transactionHistory.setCreateBy(user.getId());
        transactionHistory.setCreateTime(DateUtils.formatDateTime(new Date()));
        transactionHistory.setTranId(transaction.getId());
        transactionHistoryMapper.insertTransactionHistory(transactionHistory);
    }

    @Override
    public int deleteTransactionById(String id) {
        return transactionMapper.deleteTransactionById(id);
    }

    @Override
    public List<Transaction> queryTransactionForDetailByContactsId(String contactsId) {
        return transactionMapper.selectTransactionForDetailByContactsId(contactsId);
    }

    @Override
    public List<Transaction> queryTransactionByConditionForPage(Map<String, Object> map) {
        return transactionMapper.selectTransactionByConditionForPage(map);
    }

    @Override
    public int queryCountOfTransactionByConditionForPage(Map<String, Object> map) {
        return transactionMapper.selectCountOfTransactionByConditionForPage(map);
    }

    @Override
    public Transaction queryTransactionForEditById(String id) {
        return transactionMapper.selectTransactionForEditById(id);
    }

    @Override
    public void saveEditTransaction(Map<String, Object> map) {
        String customerName = (String) map.get("customerName");
        User user = (User) map.get(Constants.SESSION_USER);
        //查询客户,若无客户,则新建
        Customer customer = customerMapper.selectCustomerByName(customerName);
        if (customer == null) {
            customer = new Customer();
            customer.setId(UUIDUtils.getUUID());
            customer.setOwner((String) map.get(Constants.SESSION_USER));
            customer.setName(customerName);
            customer.setCreateBy((String) map.get(Constants.SESSION_USER));
            customer.setCreateTime(DateUtils.formatDateTime(new Date()));
            //调用Service层方法,新建客户
            customerMapper.insertCustomer(customer);
        }
        //获取之前的交易阶段
        Transaction tran = transactionMapper.selectTransactionForEditById((String) map.get("id"));
        String stageBefore = tran.getStage();
        String stage = (String) map.get("stage");
        //封装transaction
        Transaction transaction = new Transaction();
        transaction.setId((String) map.get("id"));
        transaction.setOwner((String) map.get("owner"));
        transaction.setMoney((String) map.get("money"));
        transaction.setName((String) map.get("name"));
        transaction.setExpectedDate((String) map.get("expectedDate"));
        transaction.setCustomerId(customer.getId());
        transaction.setStage((String) map.get("stage"));
        transaction.setType((String) map.get("type"));
        transaction.setSource((String) map.get("source"));
        transaction.setActivityId((String) map.get("activityId"));
        transaction.setContactsId((String) map.get("contactsId"));
        transaction.setEditBy(user.getId());
        transaction.setEditTime(DateUtils.formatDateTime(new Date()));
        transaction.setDescription((String) map.get("description"));
        transaction.setContactSummary((String) map.get("contactSummary"));
        transaction.setNextContactTime((String) map.get("nextContactTime"));
        //调用Service层方法,修改交易
        transactionMapper.updateTransaction(transaction);
        //若交易阶段改变,则新建交易历史
        if (!stageBefore.equals(stage)) {
            //封装TransactionHistory
            TransactionHistory transactionHistory = new TransactionHistory();
            transactionHistory.setId(UUIDUtils.getUUID());
            transactionHistory.setStage(transaction.getStage());
            transactionHistory.setMoney(transaction.getMoney());
            transactionHistory.setExpectedDate(transaction.getExpectedDate());
            transactionHistory.setCreateBy(user.getId());
            transactionHistory.setCreateTime(DateUtils.formatDateTime(new Date()));
            transactionHistory.setTranId(transaction.getId());
            //调用Service层方法,新建交易历史
            transactionHistoryMapper.insertTransactionHistory(transactionHistory);
        }
    }

    @Override
    public void deleteTransactionByIds(String[] ids) {
        //删除交易备注
        transactionRemarkMapper.deleteTransactionRemarkByTransactionIds(ids);
        //删除交易历史
        transactionHistoryMapper.deleteTransactionHistoryByTransactionIds(ids);
        //删除交易
        transactionMapper.deleteTransactionByIds(ids);
    }

    @Override
    public Transaction queryTransactionForDetailById(String id) {
        return transactionMapper.selectTransactionForDetailById(id);
    }

    @Override
    public void saveEditTransactionForDetailByMap(Map<String, Object> map) {
        User user = (User) map.get(Constants.SESSION_USER);
        //获取之前的交易阶段
        Transaction transaction = transactionMapper.selectTransactionForEditById((String) map.get("id"));
        String stageBefore = transaction.getStage();
        String stage = (String) map.get("stage");
        //修改交易
        transactionMapper.updateTransactionForDetailByMap(map);
        //若交易阶段发生改变,则创建交易历史
        if (!stageBefore.equals(stage)) {
            //封装TransactionHistory
            TransactionHistory transactionHistory = new TransactionHistory();
            transactionHistory.setId(UUIDUtils.getUUID());
            transactionHistory.setStage(transaction.getStage());
            transactionHistory.setMoney(transaction.getMoney());
            transactionHistory.setExpectedDate(transaction.getExpectedDate());
            transactionHistory.setCreateBy(user.getId());
            transactionHistory.setCreateTime(DateUtils.formatDateTime(new Date()));
            transactionHistory.setTranId(transaction.getId());
            //调用Service层方法,新建交易历史
            transactionHistoryMapper.insertTransactionHistory(transactionHistory);
        }

    }

    @Override
    public List<FunnelVO> queryCountOfTransactionGroupByStage() {
        return transactionMapper.selectCountOfTransactionGroupByStage();
    }
}
