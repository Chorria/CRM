package com.zhou.crm.workbench.web.controller;

import com.zhou.crm.commons.constants.Constants;
import com.zhou.crm.commons.domain.ReturnObject;
import com.zhou.crm.commons.utils.DateUtils;
import com.zhou.crm.commons.utils.UUIDUtils;
import com.zhou.crm.settings.domain.DicValue;
import com.zhou.crm.settings.domain.User;
import com.zhou.crm.settings.service.DicValueService;
import com.zhou.crm.settings.service.UserService;
import com.zhou.crm.workbench.domain.Activity;
import com.zhou.crm.workbench.domain.Transaction;
import com.zhou.crm.workbench.domain.TransactionHistory;
import com.zhou.crm.workbench.domain.TransactionRemark;
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
public class TransactionController {
    @Autowired
    private UserService userService;
    @Autowired
    private DicValueService dicValueService;
    @Autowired
    private ActivityService activityService;
    @Autowired
    private ContactsService contactsService;
    @Autowired
    private TransactionService transactionService;
    @Autowired
    private TransactionRemarkService transactionRemarkService;
    @Autowired
    private TransactionHistoryService transactionHistoryService;
    @RequestMapping("/workbench/transaction/index.do")
    public String index(HttpServletRequest request){
        //调用Service层方法,查询数据字典
        List<DicValue> stageList = dicValueService.queryDicValueByTypeCode("stage");
        List<DicValue> transactionTypeList = dicValueService.queryDicValueByTypeCode("transactionType");
        List<DicValue> sourceList = dicValueService.queryDicValueByTypeCode("source");
        //将数据存放在request中
        request.setAttribute("stageList",stageList);
        request.setAttribute("transactionTypeList",transactionTypeList);
        request.setAttribute("sourceList",sourceList);
        //请求转发
        return "workbench/transaction/index";
    }

    @RequestMapping("/workbench/transaction/save.do")
    public String save(HttpServletRequest request){
        //调用Service层方法,查询数据字典和所有者
        List<User> userList = userService.queryAllUsers();
        List<DicValue> stageList = dicValueService.queryDicValueByTypeCode("stage");
        List<DicValue> transactionTypeList = dicValueService.queryDicValueByTypeCode("transactionType");
        List<DicValue> sourceList = dicValueService.queryDicValueByTypeCode("source");
        //将数据存放在request中
        request.setAttribute("userList",userList);
        request.setAttribute("stageList",stageList);
        request.setAttribute("transactionTypeList",transactionTypeList);
        request.setAttribute("sourceList",sourceList);
        //请求转发
        return "workbench/transaction/save";
    }

    @RequestMapping("/workbench/transaction/getPossibilityByStage.do")
    public @ResponseBody Object getPossibilityByStage(String stage){
        //解析properties配置文件，根据阶段获取可能性
        ResourceBundle resourceBundle = ResourceBundle.getBundle("possibility");
        String possibility = resourceBundle.getString(stage);
        //返回响应信息
        return  possibility;
    }

    @RequestMapping("/workbench/transaction/queryActivityByName.do")
    public @ResponseBody Object queryActivityForSaveByName(String activityName){
        List<Activity> activityList = activityService.queryActivityByName(activityName);
        return activityList;
    }

    @RequestMapping("/workbench/transaction/queryContactsByName.do")
    public @ResponseBody Object queryContactsByName(String contactsName){
        return contactsService.queryContactsByName(contactsName);
    }

    @RequestMapping("/workbench/transaction/saveCreateTransaction.do")
    public @ResponseBody Object saveCreateTransaction(@RequestParam Map<String,Object> map, HttpSession session){
        User user = (User) session.getAttribute(Constants.SESSION_USER);
        map.put(Constants.SESSION_USER,user);

        ReturnObject returnObject = new ReturnObject();
        try{
            //调用Service层方法,保存交易
            transactionService.saveCreateTransaction(map);
            returnObject.setCode(Constants.RETURN_OBJECT_CODE_SUCCESS);
        } catch (Exception e) {
            e.printStackTrace();
            returnObject.setCode(Constants.RETURN_OBJECT_CODE_FAIL);
            returnObject.setMessage("系统繁忙,请稍后再试......");
        }
        return returnObject;
    }

    @RequestMapping("/workbench/transaction/queryTransactionByConditionForPage.do")
    public @ResponseBody Object queryTransactionByConditionForPage(@RequestParam Map<String,Object> map,int pageNo,int pageSize){
        //封装参数
        map.put("beginNo",(pageNo - 1) * pageSize);
        map.put("pageSize",pageSize);
        //调用Service层方法,分页查询交易和交易的总条数
        List<Transaction> transactionList = transactionService.queryTransactionByConditionForPage(map);
        int totalRows = transactionService.queryCountOfTransactionByConditionForPage(map);
        //根据查询结果,生成响应信息
        Map<String,Object> retMap = new HashMap<>();
        retMap.put("transactionList",transactionList);
        retMap.put("totalRows",totalRows);
        return retMap;
    }

    @RequestMapping("/workbench/transaction/edit.do")
    public String edit(String id,HttpServletRequest request){
        //调用Service层方法,查询数据字典值和用户数据
        List<User> userList = userService.queryAllUsers();
        List<DicValue> stageList = dicValueService.queryDicValueByTypeCode("stage");
        List<DicValue> transactionTypeList = dicValueService.queryDicValueByTypeCode("transactionType");
        List<DicValue> sourceList = dicValueService.queryDicValueByTypeCode("source");
        Transaction transaction = transactionService.queryTransactionForEditById(id);
        ResourceBundle resourceBundle = ResourceBundle.getBundle("possibility");
        DicValue dicValue = dicValueService.queryDicValueById(transaction.getStage());
        String stage = dicValue.getValue();
        String possibility = resourceBundle.getString(stage);
        transaction.setPossibility(possibility);
        //将数据存放在request中
        request.setAttribute("userList",userList);
        request.setAttribute("stageList",stageList);
        request.setAttribute("transactionTypeList",transactionTypeList);
        request.setAttribute("sourceList",sourceList);
        request.setAttribute("transaction",transaction);
        //请求转发
        return "workbench/transaction/edit";
    }
    @RequestMapping("/workbench/transaction/saveEditTransaction.do")
    public @ResponseBody Object saveEditTransaction(@RequestParam Map<String,Object> map,HttpSession session) {
        //封装参数
        map.put(Constants.SESSION_USER,session.getAttribute(Constants.SESSION_USER));

        ReturnObject returnObject = new ReturnObject();
        try {
            //调用Service层方法,修改交易
            transactionService.saveEditTransaction(map);
            returnObject.setCode(Constants.RETURN_OBJECT_CODE_SUCCESS);
        } catch (Exception e) {
            e.printStackTrace();
            returnObject.setCode(Constants.RETURN_OBJECT_CODE_FAIL);
            returnObject.setMessage("系统繁忙,请稍后再试......");
        }
        return returnObject;
    }

    @RequestMapping("/workbench/transaction/deleteTransactionByIds.do")
    public @ResponseBody Object deleteTransactionByIds(String[] id){
        ReturnObject returnObject = new ReturnObject();
        try {
            //调用Service层方法,删除交易、交易备注及交易历史
            transactionService.deleteTransactionByIds(id);
            returnObject.setCode(Constants.RETURN_OBJECT_CODE_SUCCESS);
        } catch (Exception e) {
            e.printStackTrace();
            returnObject.setCode(Constants.RETURN_OBJECT_CODE_FAIL);
            returnObject.setMessage("系统繁忙,请稍后再试......");
        }
        return  returnObject;
    }

    @RequestMapping("/workbench/transaction/detailTransaction.do")
    public String detailTransaction(String id,HttpServletRequest request){
        //调用Service层方法,查询交易明细、交易备注和交易历史
        List<DicValue> stageList = dicValueService.queryDicValueByTypeCode("stage");
        Transaction transaction = transactionService.queryTransactionForDetailById(id);
        //配置阶段的可能性
        ResourceBundle resourceBundle = ResourceBundle.getBundle("possibility");
        String possibility = resourceBundle.getString(transaction.getStage());
        transaction.setPossibility(possibility);
        List<TransactionRemark> transactionRemarkList = transactionRemarkService.queryTransactionRemarkForDetailByTransactionId(id);
        List<TransactionHistory> transactionHistoryList = transactionHistoryService.queryTransactionHistoryForDetailByTransactionId(id);
        //将数据保存在request
        request.setAttribute("stageList",stageList);
        request.setAttribute("transaction",transaction);
        request.setAttribute("transactionRemarkList",transactionRemarkList);
        request.setAttribute("transactionHistoryList",transactionHistoryList);
        return "workbench/transaction/detail";
    }

    @RequestMapping("/workbench/transaction/saveEditTransactionForDetailByMap.do")
    public @ResponseBody Object saveEditTransactionForDetailByMap(@RequestParam Map<String,Object> map,HttpSession session){
        User user = (User) session.getAttribute(Constants.SESSION_USER);
        //封装参数
        map.put("editBy",user.getId());
        map.put("editTime", DateUtils.formatDateTime(new Date()));
        map.put(Constants.SESSION_USER,user);
        ReturnObject returnObject = new ReturnObject();
        try {
            //调用Service层方法,点击交易图标修改交易阶段
            transactionService.saveEditTransactionForDetailByMap(map);
            returnObject.setCode(Constants.RETURN_OBJECT_CODE_SUCCESS);
        } catch (Exception e) {
            e.printStackTrace();
            returnObject.setCode(Constants.RETURN_OBJECT_CODE_FAIL);
            returnObject.setMessage("系统繁忙,请稍后再试......");
        }
        return returnObject;
    }

    @RequestMapping("/workbench/transaction/saveCreateTransactionRemark.do")
    public @ResponseBody Object saveCreateTransactionRemark(TransactionRemark transactionRemark,HttpSession session){
        User user = (User) session.getAttribute(Constants.SESSION_USER);
        //封装参数
        transactionRemark.setId(UUIDUtils.getUUID());
        transactionRemark.setCreateBy(user.getId());
        transactionRemark.setCreateTime(DateUtils.formatDateTime(new Date()));
        transactionRemark.setEditFlag("0");

        ReturnObject returnObject = new ReturnObject();
        try {
            //调用Service层方法，新增交易备注
            int ret = transactionRemarkService.saveCreateTransactionRemark(transactionRemark);
            if (ret > 0) {
                returnObject.setCode(Constants.RETURN_OBJECT_CODE_SUCCESS);
                returnObject.setRetData(transactionRemark);
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

    @RequestMapping("/workbench/transaction/saveEditTransactionRemark.do")
    public @ResponseBody Object saveEditTransactionRemark(TransactionRemark transactionRemark,HttpSession session){
        User user = (User) session.getAttribute(Constants.SESSION_USER);
        //封装参数
        transactionRemark.setEditBy(user.getId());
        transactionRemark.setEditTime(DateUtils.formatDateTime(new Date()));
        transactionRemark.setEditFlag("1");

        ReturnObject returnObject = new ReturnObject();
        try {
            //调用Service层方法,修改交易备注
            int ret = transactionRemarkService.saveEditTransactionRemark(transactionRemark);
            if (ret > 0) {
                returnObject.setCode(Constants.RETURN_OBJECT_CODE_SUCCESS);
                returnObject.setRetData(transactionRemark);
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

    @RequestMapping("/workbench/transaction/deleteTransactionRemarkById.do")
    public @ResponseBody Object deleteTransactionRemarkById(String id){
        ReturnObject returnObject = new ReturnObject();
        try {
            //调用Service层方法,删除交易备注
            int ret = transactionRemarkService.deleteTransactionRemarkById(id);
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
