package com.zhou.crm.workbench.web.controller;

import com.zhou.crm.commons.constants.Constants;
import com.zhou.crm.commons.domain.ReturnObject;
import com.zhou.crm.commons.utils.DateUtils;
import com.zhou.crm.commons.utils.UUIDUtils;
import com.zhou.crm.settings.domain.DicValue;
import com.zhou.crm.settings.domain.User;
import com.zhou.crm.settings.service.DicValueService;
import com.zhou.crm.settings.service.UserService;
import com.zhou.crm.workbench.domain.*;
import com.zhou.crm.workbench.service.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.util.*;

@Controller
public class ContactsController {
    @Autowired
    private UserService userService;
    @Autowired
    private DicValueService dicValueService;
    @Autowired
    private ContactsService contactsService;
    @Autowired
    private ContactsRemarkService contactsRemarkService;
    @Autowired
    private TransactionService transactionService;
    @Autowired
    private ActivityService activityService;
    @Autowired
    private ContactsActivityRelationService contactsActivityRelationService;
    @RequestMapping("/workbench/contacts/index.do")
    public String index(HttpServletRequest request){
        //调用Service层方法,查询所有者、来源及称呼的数据
        List<User> userList = userService.queryAllUsers();
        List<DicValue> sourceList = dicValueService.queryDicValueByTypeCode("source");
        List<DicValue> appellationList = dicValueService.queryDicValueByTypeCode("appellation");
        //将数据保存在request中
        request.setAttribute("userList",userList);
        request.setAttribute("sourceList",sourceList);
        request.setAttribute("appellationList",appellationList);
        //请求转发
        return "workbench/contacts/index";
    }
    @RequestMapping("/workbench/contacts/saveCreateContacts.do")
    public @ResponseBody Object saveCreateContacts(@RequestParam Map<String,Object> map, HttpSession session){
        User user = (User) session.getAttribute(Constants.SESSION_USER);
        //封装参数
        map.put(Constants.SESSION_USER,user);

        ReturnObject returnObject = new ReturnObject();
        try {
            //调用Service层方法,保存新建的联系人
            contactsService.saveCreateContacts(map);
            returnObject.setCode(Constants.RETURN_OBJECT_CODE_SUCCESS);
        } catch (Exception e) {
            e.printStackTrace();
            returnObject.setCode(Constants.RETURN_OBJECT_CODE_FAIL);
            returnObject.setMessage("系统繁忙,请稍后再试......");
        }
        return returnObject;
    }

    @RequestMapping("/workbench/contacts/queryContactsByConditionForPage.do")
    public @ResponseBody Object queryContactsByConditionForPage(String owner,String fullname,String customerName,String source,String birthday,int pageNo,int pageSize){
        //封装参数
        Map<String,Object> map = new HashMap<>();
        map.put("owner",owner);
        map.put("fullname",fullname);
        map.put("customerName",customerName);
        map.put("source",source);
        map.put("birthday",birthday);
        map.put("beginNo",(pageNo - 1) * pageSize);
        map.put("pageSize",pageSize);
        //调用Service层方法,查询所有的联系人和总条数
        List<Contacts> contactsList = contactsService.queryContactsByConditionForPage(map);
        int totalRows = contactsService.queryCountOfContactsByConditionForPage(map);
        //根据查询结果，生成响应信息
        Map<String,Object> retMap = new HashMap<>();
        retMap.put("contactsList",contactsList);
        retMap.put("totalRows",totalRows);
        return retMap;
    }

    @RequestMapping("/workbench/contacts/queryContactsById.do")
    public @ResponseBody Object queryContactsById(String id){
        return contactsService.queryContactsById(id);
    }

    @RequestMapping("/workbench/contacts/saveEditContacts.do")
    public @ResponseBody Object saveEditContacts(@RequestParam Map<String,Object> map, HttpSession session){
        User user = (User) session.getAttribute(Constants.SESSION_USER);
        map.put(Constants.SESSION_USER,user);

        ReturnObject returnObject = new ReturnObject();
        try {
            contactsService.updateContacts(map);
            returnObject.setCode(Constants.RETURN_OBJECT_CODE_SUCCESS);
        } catch (Exception e) {
            e.printStackTrace();
            returnObject.setCode(Constants.RETURN_OBJECT_CODE_FAIL);
            returnObject.setMessage("系统繁忙,请稍后再试......");
        }
        return returnObject;
    }

    @RequestMapping("/workbench/contacts/deleteContactsByIds.do")
    public @ResponseBody Object deleteContactsByIds(String[] id){
        ReturnObject returnObject = new ReturnObject();
        try {
            //调用Service层方法,删除联系人相关的所有信息
            contactsService.deleteContactsByIds(id);
            returnObject.setCode(Constants.RETURN_OBJECT_CODE_SUCCESS);
        } catch (Exception e) {
            e.printStackTrace();
            returnObject.setCode(Constants.RETURN_OBJECT_CODE_FAIL);
            returnObject.setMessage("系统繁忙,请稍后再试......");
        }
        return returnObject;
    }

    @RequestMapping("/workbench/contacts/detailContacts.do")
    public String detailContacts(String id,HttpServletRequest request){
        //调用Service层方法,查询联系人明细、联系人备注、交易和市场活动等信息
        List<User> userList = userService.queryAllUsers();
        List<DicValue> sourceList = dicValueService.queryDicValueByTypeCode("source");
        List<DicValue> appellationList = dicValueService.queryDicValueByTypeCode("appellation");
        Contacts contacts = contactsService.queryContactsForDetailById(id);
        List<ContactsRemark> contactsRemarkList = contactsRemarkService.queryContactsRemarkForDetailByContactsId(id);
        List<Transaction> transactionList = transactionService.queryTransactionForDetailByContactsId(id);
        for(Transaction transaction : transactionList) {
            ResourceBundle bundle = ResourceBundle.getBundle("possibility");
            String possibility = bundle.getString(transaction.getStage());
            transaction.setPossibility(possibility);
        }
        List<Activity> activityList = activityService.queryActivityForDetailByContactsId(id);
        //将数据保存在request
        request.setAttribute("userList",userList);
        request.setAttribute("sourceList",sourceList);
        request.setAttribute("appellationList",appellationList);
        request.setAttribute("contacts",contacts);
        request.setAttribute("contactsRemarkList",contactsRemarkList);
        request.setAttribute("transactionList",transactionList);
        request.setAttribute("activityList",activityList);
        return "/workbench/contacts/detail";
    }

    @RequestMapping("/workbench/contacts/saveCreateContactsRemark.do")
    public @ResponseBody Object saveCreateContactsRemark(ContactsRemark contactsRemark,HttpSession session){
        User user = (User) session.getAttribute(Constants.SESSION_USER);
        //封装参数
        contactsRemark.setId(UUIDUtils.getUUID());
        contactsRemark.setCreateBy(user.getId());
        contactsRemark.setCreateTime(DateUtils.formatDateTime(new Date()));
        contactsRemark.setEditFlag("0");

        ReturnObject returnObject = new ReturnObject();
        try {
            //调用Service层方法,新建联系人备注
            int ret = contactsRemarkService.saveCreateContactsRemark(contactsRemark);
            if (ret > 0) {
                returnObject.setCode(Constants.RETURN_OBJECT_CODE_SUCCESS);
                returnObject.setRetData(contactsRemark);
            } else {
                returnObject.setCode(Constants.RETURN_OBJECT_CODE_FAIL);
                returnObject.setMessage("系统繁忙,请稍后再试......");
            }
        } catch (Exception e) {
            e.printStackTrace();
            returnObject.setCode(Constants.RETURN_OBJECT_CODE_FAIL);
            returnObject.setMessage("系统繁忙,请稍后再试......");
        }
        return returnObject;
    }

    @RequestMapping("/workbench/contacts/saveEditContactsRemark.do")
    public @ResponseBody Object saveEditContactsRemar(ContactsRemark contactsRemark,HttpSession session){
        User user = (User) session.getAttribute(Constants.SESSION_USER);
        //封装参数
        contactsRemark.setEditBy(user.getEditBy());
        contactsRemark.setEditTime(DateUtils.formatDateTime(new Date()));
        contactsRemark.setEditFlag("1");

        ReturnObject returnObject = new ReturnObject();
        try {
            //调用Service层方法,修改联系人备注
            int ret = contactsRemarkService.saveEditContactsRemark(contactsRemark);
            if (ret > 0) {
                returnObject.setCode(Constants.RETURN_OBJECT_CODE_SUCCESS);
                returnObject.setRetData(contactsRemark);
            } else {
                returnObject.setCode(Constants.RETURN_OBJECT_CODE_FAIL);
                returnObject.setMessage("系统繁忙,请稍后再试......");
            }
        } catch (Exception e) {
            e.printStackTrace();
            returnObject.setCode(Constants.RETURN_OBJECT_CODE_FAIL);
            returnObject.setMessage("系统繁忙,请稍后再试......");
        }
        return returnObject;
    }

    @RequestMapping("/workbench/contacts/deleteContactsRemarkById.do")
    public @ResponseBody Object deleteContactsRemarkById(String id){
        ReturnObject returnObject = new ReturnObject();
        try {
            //调用Service层方法，删除联系人备注信息
            int ret = contactsRemarkService.deleteContactsRemarkById(id);
            if (ret > 0) {
                returnObject.setCode(Constants.RETURN_OBJECT_CODE_SUCCESS);
            } else {
                returnObject.setCode(Constants.RETURN_OBJECT_CODE_FAIL);
                returnObject.setMessage("系统繁忙,请稍后再试......");
            }
        } catch (Exception e) {
            e.printStackTrace();
            returnObject.setCode(Constants.RETURN_OBJECT_CODE_FAIL);
            returnObject.setMessage("系统繁忙,请稍后再试......");
        }
        return returnObject;
    }

    @RequestMapping("/workbench/contacts/createTransaction.do")
    public String createTransaction(String id,HttpServletRequest request){
        //调用Service层方法,查询用户、阶段、类型和来源的数据字典值
        Contacts contacts = contactsService.queryContactsById(id);
        String customerName = contacts.getCustomerId();
        List<User> userList = userService.queryAllUsers();
        List<DicValue> transactionTypeList = dicValueService.queryDicValueByTypeCode("transactionType");
        List<DicValue> stageList = dicValueService.queryDicValueByTypeCode("stage");
        List<DicValue> sourceList = dicValueService.queryDicValueByTypeCode("source");
        //将数据保存在request
        request.setAttribute("contacts",contacts);
        request.setAttribute("customerName",customerName);
        request.setAttribute("userList",userList);
        request.setAttribute("transactionTypeList",transactionTypeList);
        request.setAttribute("stageList",stageList);
        request.setAttribute("sourceList",sourceList);
        return "workbench/transaction/save";
    }

    @RequestMapping("/workbench/contacts/deleteTransactionById.do")
    public @ResponseBody Object deleteTransactionById(String id){
        ReturnObject returnObject = new ReturnObject();
        try {
            //调用Service层方法,删除交易
            int ret = transactionService.deleteTransactionById(id);
            if (ret > 0) {
                returnObject.setCode(Constants.RETURN_OBJECT_CODE_SUCCESS);
            } else {
                returnObject.setCode(Constants.RETURN_OBJECT_CODE_FAIL);
                returnObject.setMessage("系统繁忙,请稍后再试......");
            }
        } catch (Exception e) {
            e.printStackTrace();
            returnObject.setCode(Constants.RETURN_OBJECT_CODE_FAIL);
            returnObject.setMessage("系统繁忙,请稍后再试......");
        }
        return returnObject;
    }

    @RequestMapping("/workbench/contacts/queryActivityForDetailByNameAndContactsId.do")
    public @ResponseBody Object queryActivityForDetailByNameAndContactsId(@RequestParam Map<String,Object> map){
        return activityService.queryActivityForDetailByNameAndContactsId(map);
    }

    @RequestMapping("/workbench/contacts/bundActivity.do")
    public @ResponseBody Object bundActivity(String[] id,String contactsId){
        List<ContactsActivityRelation> contactsActivityRelationList = new ArrayList<>();
        ContactsActivityRelation contactsActivityRelation = null;
        for (String activityId : id) {
            contactsActivityRelation = new ContactsActivityRelation();
            contactsActivityRelation.setId(UUIDUtils.getUUID());
            contactsActivityRelation.setActivityId(activityId);
            contactsActivityRelation.setContactsId(contactsId);

            contactsActivityRelationList.add(contactsActivityRelation);
        }
        ReturnObject returnObject = new ReturnObject();
        try {
            //调用Service层方法,新建联系人和市场活动的关联关系
            int ret = contactsActivityRelationService.saveCreateContactsActivityRelationByList(contactsActivityRelationList);
            if (ret > 0) {
                //调用Service层方法,查询所关联的市场活动
                List<Activity> activityList = activityService.queryActivityForDetailByIds(id);
                returnObject.setCode(Constants.RETURN_OBJECT_CODE_SUCCESS);
                returnObject.setRetData(activityList);
            } else {
                returnObject.setCode(Constants.RETURN_OBJECT_CODE_FAIL);
                returnObject.setMessage("系统繁忙,请稍后再试......");
            }
        } catch (Exception e) {
            e.printStackTrace();
            returnObject.setCode(Constants.RETURN_OBJECT_CODE_FAIL);
            returnObject.setMessage("系统繁忙,请稍后再试......");
        }
        return returnObject;
    }

    @RequestMapping("/workbench/contacts/unbundActivity.do")
    public @ResponseBody Object unbundActivity(String activityId){
        ReturnObject returnObject = new ReturnObject();
        try {
            //调用Service层方法,解除联系人关联市场活动
            int ret = contactsActivityRelationService.deleteContactsActivityRelationByActivityId(activityId);
            if (ret > 0) {
                returnObject.setCode(Constants.RETURN_OBJECT_CODE_SUCCESS);
            } else {
                returnObject.setCode(Constants.RETURN_OBJECT_CODE_FAIL);
                returnObject.setMessage("系统繁忙,请稍后再试......");
            }
        } catch (Exception e) {
            e.printStackTrace();
            returnObject.setCode(Constants.RETURN_OBJECT_CODE_FAIL);
            returnObject.setMessage("系统繁忙,请稍后再试......");
        }
        return returnObject;
    }
}
