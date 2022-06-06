package com.zhou.crm.workbench.service.impl;

import com.zhou.crm.commons.constants.Constants;
import com.zhou.crm.commons.utils.DateUtils;
import com.zhou.crm.commons.utils.UUIDUtils;
import com.zhou.crm.settings.domain.User;
import com.zhou.crm.workbench.domain.*;
import com.zhou.crm.workbench.mapper.*;
import com.zhou.crm.workbench.service.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Map;

@Service("clueService")
public class ClueServiceImpl implements ClueService {
    @Autowired
    private ClueMapper clueMapper;
    @Autowired
    private ClueRemarkMapper clueRemarkMapper;
    @Autowired
    private ClueActivityRelationMapper clueActivityRelationMapper;
    @Autowired
    private ContactsRemarkMapper contactsRemarkMapper;
    @Autowired
    private ContactsActivityRelationMapper contactsActivityRelationMapper;
    @Autowired
    private CustomerMapper customerMapper;
    @Autowired
    private ContactsMapper contactsMapper;
    @Autowired
    private CustomerRemarkMapper customerRemarkMapper;
    @Autowired
    private TransactionMapper transactionMapper;
    @Autowired
    private TransactionRemarkMapper transactionRemarkMapper;

    @Override
    public int saveCreateClue(Clue clue) {
        return clueMapper.insertClue(clue);
    }

    @Override
    public List<Clue> queryClueByConditionForPage(Map<String, Object> map) {
        return clueMapper.selectClueByConditionForPage(map);
    }

    @Override
    public int queryCountOfClueByCondition(Map<String, Object> map) {
        return clueMapper.selectCountOfClueByCondition(map);
    }

    @Override
    public Clue queryClueById(String id) {
        return clueMapper.selectClueById(id);
    }

    @Override
    public int saveEditClue(Clue clue) {
        return clueMapper.updateClue(clue);
    }

    @Override
    public Clue queryClueForDetailById(String id) {
        return clueMapper.selectClueForDetailById(id);
    }

    @Override
    public void deleteClueByIds(String[] id) {
        //删除线索备注、所关联的市场活动
        clueRemarkMapper.deleteClueRemarkByClueIds(id);
        clueActivityRelationMapper.deleteClueActivityRelationByClueIds(id);
        //删除线索
        clueMapper.deleteClueByIds(id);
    }

    @Override
    public void saveConvertClue(Map<String,Object> map) {
        String clueId = (String) map.get("clueId");
        User user = (User) map.get(Constants.SESSION_USER);
        //根据id查询线索的信息
        Clue clue = clueMapper.selectClueById(clueId);
        //把该线索中有关公司的信息转换到客户表中
        Customer customer = new Customer();
        customer.setId(UUIDUtils.getUUID());
        customer.setOwner(user.getId());
        customer.setName(clue.getCompany());
        customer.setWebsite(clue.getWebsite());
        customer.setPhone(clue.getPhone());
        customer.setCreateBy(user.getId());
        customer.setCreateTime(DateUtils.formatDateTime(new Date()));
        customer.setContactSummary(clue.getContactSummary());
        customer.setNextContactTime(clue.getNextContactTime());
        customer.setDescription(clue.getDescription());
        customer.setAddress(clue.getAddress());
        customerMapper.insertCustomer(customer);
        //把该线索中有关个人的信息转换到联系人表中
        Contacts contacts = new Contacts();
        contacts.setId(UUIDUtils.getUUID());
        contacts.setOwner(user.getId());
        contacts.setSource(clue.getSource());
        contacts.setCustomerId(customer.getId());
        contacts.setFullname(clue.getFullname());
        contacts.setAppellation(clue.getAppellation());
        contacts.setEmail(clue.getEmail());
        contacts.setMphone(clue.getMphone());
        contacts.setJob(clue.getJob());
        contacts.setCreateBy(user.getId());
        contacts.setCreateTime(DateUtils.formatDateTime(new Date()));
        contacts.setDescription(clue.getDescription());
        contacts.setContactSummary(clue.getContactSummary());
        contacts.setNextContactTime(clue.getNextContactTime());
        contacts.setAddress(clue.getAddress());
        contactsMapper.insertContacts(contacts);
        //根据id查询所有的线索备注
        List<ClueRemark> clueRemarkList = clueRemarkMapper.selectClueRemarkForDetailByClueId(clueId);
        //如果该线索下有备注，把该线索下所有的备注转换到客户备注表中一份,把该线索下所有的备注转换到联系人备注表中一份
        if (clueRemarkList != null && clueRemarkList.size() > 0) {
            //遍历clueRemarkList，封装客户备注
            CustomerRemark customerRemark = null;
            List<CustomerRemark> customerRemarkList = new ArrayList<>();
            ContactsRemark contactsRemark = null;
            List<ContactsRemark> contactsRemarkList = new ArrayList<>();
            for(ClueRemark clueRemark : clueRemarkList) {
                //把线索的备注信息转换到客户备注表中一份
                customerRemark = new CustomerRemark();
                customerRemark.setId(UUIDUtils.getUUID());
                customerRemark.setNoteContent(clueRemark.getNoteContent());
                customerRemark.setCreateBy(user.getId());
                customerRemark.setCreateTime(DateUtils.formatDateTime(new Date()));
                customerRemark.setEditFlag("0");
                customerRemark.setCustomerId(customer.getId());
                customerRemarkList.add(customerRemark);
                //把把线索的备注信息转换到联系人备注表中一份
                contactsRemark = new ContactsRemark();
                contactsRemark.setId(UUIDUtils.getUUID());
                contactsRemark.setNoteContent(clueRemark.getNoteContent());
                contactsRemark.setCreateBy(user.getId());
                contactsRemark.setCreateTime(DateUtils.formatDateTime(new Date()));
                contactsRemark.setEditFlag("0");
                contactsRemark.setContactsId(contacts.getId());
                contactsRemarkList.add(contactsRemark);
            }
            //调用Mapper层方法,新建客户备注和联系人备注
            customerRemarkMapper.insertCustomerRemarkByList(customerRemarkList);
            contactsRemarkMapper.insertContactsRemarkByList(contactsRemarkList);
        }
        //调用Mapper层方法,根据clueId查询线索所关联的所有市场活动
        List<ClueActivityRelation> clueActivityRelationList = clueActivityRelationMapper.selectClueActivityRelationByClueId(clueId);
        if (clueActivityRelationList != null && clueActivityRelationList.size() > 0) {
            //遍历clueActivityRelationList，封装联系人市场关联
            ContactsActivityRelation contactsActivityRelation = null;
            List<ContactsActivityRelation> contactsActivityRelationList = new ArrayList<>();
            for (ClueActivityRelation clueActivityRelation : clueActivityRelationList) {
                //把线索和市场活动的关联关系转换到联系人和市场活动的关联关系表中
                contactsActivityRelation = new ContactsActivityRelation();
                contactsActivityRelation.setId(UUIDUtils.getUUID());
                contactsActivityRelation.setContactsId(contacts.getId());
                contactsActivityRelation.setActivityId(clueActivityRelation.getActivityId());
                contactsActivityRelationList.add(contactsActivityRelation);
            }
            //调用Mapper层方法,新建联系人与市场活动的关联关系
            contactsActivityRelationMapper.insertContactsActivityRelationByList(contactsActivityRelationList);
        }
        //如果需要创建交易，则往交易表中添加一条记录,还需要把该线索下的备注转换到交易备注表中一份
        String isCreateTransaction = (String) map.get("isCreateTransaction");
        if ("true".equals(isCreateTransaction)) {
            Transaction transaction = new Transaction();
            transaction.setId(UUIDUtils.getUUID());
            transaction.setOwner(user.getId());
            String money = (String) map.get("money");
            transaction.setMoney(money);
            String name = (String) map.get("name");
            transaction.setName(name);
            String expectedDate = (String) map.get("expectedDate");
            transaction.setExpectedDate(expectedDate);
            transaction.setCustomerId(customer.getId());
            String stage = (String) map.get("stage");
            transaction.setStage(stage);
            String activityId = (String) map.get("activityId");
            transaction.setActivityId(activityId);
            transaction.setContactsId(contacts.getId());
            transaction.setCreateBy(user.getId());
            transaction.setCreateTime(DateUtils.formatDateTime(new Date()));
            transactionMapper.insertTransaction(transaction);

            if (clueRemarkList != null && clueRemarkList.size() > 0) {
                TransactionRemark transactionRemark = null;
                List<TransactionRemark> transactionRemarkList = new ArrayList<>();
                for (ClueRemark clueRemark : clueRemarkList) {
                    transactionRemark = new TransactionRemark();
                    transactionRemark.setId(UUIDUtils.getUUID());
                    transactionRemark.setNoteContent(clueRemark.getNoteContent());
                    transactionRemark.setCreateBy(user.getId());
                    transactionRemark.setCreateTime(DateUtils.formatDateTime(new Date()));
                    transactionRemark.setEditFlag("0");
                    transactionRemark.setTranId(transaction.getId());
                    transactionRemarkList.add(transactionRemark);
                }
                transactionRemarkMapper.insertTransactionRemarkByList(transactionRemarkList);
            }
            //调用Mapper层方法,删除线索的备注、线索和市场活动的关联关系和线索
            clueRemarkMapper.deleteClueRemarkByClueId(clueId);
            clueActivityRelationMapper.deleteClueActivityRelationByClueId(clueId);
            clueMapper.deleteClueById(clueId);
        }
    }

    @Override
    public List<FunnelVO> queryCountOfClueGroupBySource() {
        return clueMapper.selectCountOfClueGroupBySource();
    }
}
