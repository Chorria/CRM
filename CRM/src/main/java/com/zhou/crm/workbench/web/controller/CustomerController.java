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
public class CustomerController {
    @Autowired
    private UserService userService;
    @Autowired
    private CustomerService customerService;
    @Autowired
    private CustomerRemarkService customerRemarkService;
    @Autowired
    private TransactionService transactionService;
    @Autowired
    private ContactsService contactsService;
    @Autowired
    private DicValueService dicValueService;
    @Autowired
    private ActivityService activityService;
    @RequestMapping("/workbench/customer/index.do")
    public String index(HttpServletRequest request){
        //调用Service层方法，查询所有的客户
        List<User> userList = userService.queryAllUsers();
        //将数据保存在request中
        request.setAttribute("userList",userList);
        //请发转发
        return "workbench/customer/index";
    }

    @RequestMapping("/workbench/customer/saveCreateCustomer.do")
    public @ResponseBody Object saveCreateCustomer(Customer customer, HttpSession session){
        User user = (User) session.getAttribute(Constants.SESSION_USER);
        //封装参数
        customer.setId(UUIDUtils.getUUID());
        customer.setCreateBy(user.getId());
        customer.setCreateTime(DateUtils.formatDateTime(new Date()));

        ReturnObject returnObject = new ReturnObject();
        try {
            int ret = customerService.saveCreateCustomer(customer);
            if (ret > 0) {
                returnObject.setCode(Constants.RETURN_OBJECT_CODE_SUCCESS);
            } else {
                returnObject.setCode(Constants.RETURN_OBJECT_CODE_FAIL);
                returnObject.setMessage("系统繁忙,请稍后再试......");
            }
        } catch (Exception e) {
            returnObject.setCode(Constants.RETURN_OBJECT_CODE_FAIL);
            returnObject.setMessage("系统繁忙,请稍后再试......");
        }
        return returnObject;
    }

    @RequestMapping("/workbench/customer/queryCustomerByConditionForPage.do")
    public @ResponseBody Object queryCustomerByConditionForPage(String name,String owner,String phone,String website,int pageNo,int pageSize){
        //封装参数
        Map<String,Object> queryMap = new HashMap<>();
        queryMap.put("name",name);
        queryMap.put("owner",owner);
        queryMap.put("phone",phone);
        queryMap.put("website",website);
        queryMap.put("beginNo",(pageNo - 1) * pageSize);
        queryMap.put("pageSize",pageSize);
        //调用Service层方法,分页查询顾客及获取顾客的总条数
        List<Customer> customerList = customerService.queryCustomerByConditionForPage(queryMap);
        int totalRows = customerService.queryCountOfCustomerByCondition(queryMap);
        //根据查询结果,生成响应信息
        Map<String,Object> retMap = new HashMap<>();
        retMap.put("customerList",customerList);
        retMap.put("totalRows",totalRows);
        return retMap;
    }

    @RequestMapping("/workbench/customer/queryCustomerById.do")
    public @ResponseBody Object queryCustomerById(String id){
        return customerService.queryCustomerById(id);
    }

    @RequestMapping("/workbench/customer/saveEditCustomer.do")
    public @ResponseBody Object saveEditCustomer(Customer customer,HttpSession session){
        //封装参数
        User user = (User) session.getAttribute(Constants.SESSION_USER);
        customer.setEditBy(user.getId());
        customer.setEditTime(DateUtils.formatDateTime(new Date()));

        ReturnObject returnObject = new ReturnObject();
        try {
            int ret = customerService.saveEditCustomer(customer);
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

    @RequestMapping("/workbench/customer/deleteCustomerByIds.do")
    public @ResponseBody Object deleteCustomerByIds(String[] id){
        ReturnObject returnObject = new ReturnObject();
        try {
            //调用Service层方法,删除客户信息
            customerService.deleteCustomer(id);
            returnObject.setCode(Constants.RETURN_OBJECT_CODE_SUCCESS);
        } catch (Exception e) {
            e.printStackTrace();
            returnObject.setCode(Constants.RETURN_OBJECT_CODE_FAIL);
            returnObject.setMessage("系统繁忙,请稍后再试......");
        }
        return returnObject;
    }

    @RequestMapping("/workbench/customer/detailCustomer.do")
    public String detailCustomer(String id,HttpServletRequest request){
        //调用Service层方法,查询客户信息的明细
        Customer customer = customerService.queryCustomerForDetailById(id);
        List<CustomerRemark> customerRemarkList = customerRemarkService.queryCustomerRemarkForDetailByCustomerId(id);
        List<Transaction> transactionList = transactionService.queryTransactionForDetailByCustomerId(id);
        for (Transaction transaction : transactionList) {
            String stage = transaction.getStage();
            ResourceBundle resourceBundle = ResourceBundle.getBundle("possibility");
            String possibility = resourceBundle.getString(stage);
            //封装可能行属性
            transaction.setPossibility(possibility);
        }
        List<Contacts> contactsList = contactsService.queryContactsForDetailByCustomerId(id);
        List<User> userList = userService.queryAllUsers();
        List<DicValue> sourceList = dicValueService.queryDicValueByTypeCode("source");
        List<DicValue> appellationList = dicValueService.queryDicValueByTypeCode("appellation");
        //将数据保存在request中
        request.setAttribute("customer",customer);
        request.setAttribute("customerRemarkList",customerRemarkList);
        request.setAttribute("transactionList", transactionList);
        request.setAttribute("contactsList",contactsList);
        request.setAttribute("userList",userList);
        request.setAttribute("sourceList",sourceList);
        request.setAttribute("appellationList",appellationList);
        //请求转发
        return "workbench/customer/detail";
    }

    @RequestMapping("/workbench/customer/saveCreateCustomerRemark.do")
    public @ResponseBody Object saveCreateCustomerRemark(CustomerRemark customerRemark,HttpSession session){
        //封装参数
        User user = (User) session.getAttribute(Constants.SESSION_USER);
        customerRemark.setId(UUIDUtils.getUUID());
        customerRemark.setCreateBy(user.getId());
        customerRemark.setCreateTime(DateUtils.formatDateTime(new Date()));
        customerRemark.setEditFlag("0");

        ReturnObject returnObject = new ReturnObject();
        try {
            int ret = customerRemarkService.saveCreateCustomerRemark(customerRemark);
            if (ret > 0) {
                returnObject.setCode(Constants.RETURN_OBJECT_CODE_SUCCESS);
                returnObject.setRetData(customerRemark);
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

    @RequestMapping("/workbench/customer/queryCustomerNameByName.do")
    public @ResponseBody Object queryCustomerNameByName(String customerName){
        //调用Service层方法,自动补全客户名称
        return customerService.queryCustomerNameByName(customerName);
    }

    @RequestMapping("/workbench/customer/saveEditCustomerRemark.do")
    public @ResponseBody Object saveEditCustomerRemark(CustomerRemark customerRemark,HttpSession session){
        //封装参数
        User user = (User) session.getAttribute(Constants.SESSION_USER);
        customerRemark.setEditBy(user.getId());
        customerRemark.setEditTime(DateUtils.formatDateTime(new Date()));
        customerRemark.setEditFlag("1");

        ReturnObject returnObject = new ReturnObject();
        try {
            //调用Service层方法,修改客户备注信息
            int ret = customerRemarkService.saveEditCustomerRemark(customerRemark);
            if (ret > 0) {
                returnObject.setCode(Constants.RETURN_OBJECT_CODE_SUCCESS);
                returnObject.setRetData(customerRemark);
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

    @RequestMapping("/workbench/customer/deleteCustomerRemarkById.do")
    public @ResponseBody Object deleteCustomerRemark(String id){
        ReturnObject returnObject = new ReturnObject();
        try {
            int ret = customerRemarkService.deleteCustomerRemarkById(id);
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

    @RequestMapping("/workbench/customer/createTransaction.do")
    public String detailOfTransactionSave(String id,HttpServletRequest request){
        //调用Service层方法,查询动态数据所有者、阶段、类型、来源
        Customer customer = customerService.queryCustomerById(id);
        List<User> userList = userService.queryAllUsers();
        List<DicValue> stageList = dicValueService.queryDicValueByTypeCode("stage");
        List<DicValue> transactionTypeList = dicValueService.queryDicValueByTypeCode("transactionType");
        List<DicValue> sourceList = dicValueService.queryDicValueByTypeCode("source");
        //将数据保存在request域中
        request.setAttribute("customer",customer);
        request.setAttribute("userList",userList);
        request.setAttribute("stageList",stageList);
        request.setAttribute("transactionTypeList",transactionTypeList);
        request.setAttribute("sourceList",sourceList);
        //请求转发
        return "workbench/transaction/save";
    }

    @RequestMapping("/workbench/customer/saveCreateContactsForDetail.do")
    public @ResponseBody Object saveCreateContactsForDetail(Contacts contacts,HttpSession session){
        User user = (User) session.getAttribute(Constants.SESSION_USER);
        //封装参数
        contacts.setId(UUIDUtils.getUUID());
        contacts.setCreateBy(user.getId());
        contacts.setCreateTime(DateUtils.formatDateTime(new Date()));

        ReturnObject returnObject = new ReturnObject();
        try {
            //调用Service层方法,保存新建的联系人
            int ret = contactsService.saveCreateContactsForDetail(contacts);
            if (ret > 0) {
                returnObject.setCode(Constants.RETURN_OBJECT_CODE_SUCCESS);
                returnObject.setRetData(contacts);
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

    @RequestMapping("/workbench/customer/deleteContactsForDetail.do")
    public @ResponseBody Object deleteContactsForDetail(String id){
        ReturnObject returnObject = new ReturnObject();
        try {
            //调用Service层方法,删除联系人
            int ret = contactsService.deleteContactsForDetail(id);
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

    @RequestMapping("/workbench/customer/deleteTransactionById.do")
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
        return  returnObject;
    }

}
