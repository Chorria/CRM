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
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.util.*;

@Controller
public class ClueController {
    @Autowired
    private UserService userService;
    @Autowired
    private DicValueService dicValueService;
    @Autowired
    private ClueService clueService;
    @Autowired
    private ClueRemarkService clueRemarkService;
    @Autowired
    private ActivityService activityService;
    @Autowired
    private ClueActivityRelationService clueActivityRelationService;

    @RequestMapping("/workbench/clue/index.do")
    public String index(HttpServletRequest request){
        //调用Service层方法,查询动态数据
        List<User> userList = userService.queryAllUsers();
        List<DicValue> appellationList = dicValueService.queryDicValueByTypeCode("appellation");
        List<DicValue> clueStateList = dicValueService.queryDicValueByTypeCode("clueState");
        List<DicValue> sourceList = dicValueService.queryDicValueByTypeCode("source");
        //把数据保存到request中
        request.setAttribute("userList",userList);
        request.setAttribute("appellationList",appellationList);
        request.setAttribute("clueStateList",clueStateList);
        request.setAttribute("sourceList",sourceList);
        //请求转发
        return "workbench/clue/index";
    }

    @RequestMapping("/workbench/clue/saveCreateClue.do")
    private @ResponseBody Object saveCreateClue(Clue clue, HttpSession session){
        User user = (User) session.getAttribute(Constants.SESSION_USER);
        //封装参数
        clue.setId(UUIDUtils.getUUID());
        clue.setCreateBy(user.getId());
        clue.setCreateTime(DateUtils.formatDateTime(new Date()));

        ReturnObject returnObject = new ReturnObject();
        try {
            //调用Service层方法,保存创建的线索
            int ret = clueService.saveCreateClue(clue);
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

    @RequestMapping("/workbench/clue/queryClueByConditionForPage.do")
    public @ResponseBody Object queryClueByConditionForPage(String fullname,String company,String phone,String source,String owner,String mphone,String state,int pageNo,int pageSize){
        Map<String,Object> map = new HashMap<>();
        map.put("fullname",fullname);
        map.put("company",company);
        map.put("phone",phone);
        map.put("source",source);
        map.put("owner",owner);
        map.put("mphone",mphone);
        map.put("state",state);
        map.put("beginNo",(pageNo - 1) * pageSize);
        map.put("pageSize",pageSize);
        //调用Service层方法,分页查询所有的线索
        List<Clue> clueList = clueService.queryClueByConditionForPage(map);
        int totalRows = clueService.queryCountOfClueByCondition(map);
        //根据查询结果,生成响应信息
        Map<String,Object> retMap = new HashMap<>();
        retMap.put("clueList",clueList);
        retMap.put("totalRows",totalRows);
        return retMap;
    }

    @RequestMapping("/workbench/clue/queryClueById.do")
    public @ResponseBody Object queryClueById(String id){
        return clueService.queryClueById(id);
    }

    @RequestMapping("/workbench/clue/saveEditClue.do")
    public @ResponseBody Object saveEditClue(Clue clue,HttpSession session){
        User user = (User) session.getAttribute(Constants.SESSION_USER);
        clue.setEditBy(user.getId());
        clue.setEditTime(DateUtils.formatDateTime(new Date()));

        ReturnObject returnObject = new ReturnObject();
        try {
            int ret = clueService.saveEditClue(clue);
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

    @RequestMapping("/workbench/clue/deleteClueByIds.do")
    public @ResponseBody Object deleteClueByIds(String[] id){
        ReturnObject returnObject = new ReturnObject();
        try {
            clueService.deleteClueByIds(id);
            returnObject.setCode(Constants.RETURN_OBJECT_CODE_SUCCESS);
        } catch (Exception e) {
            e.printStackTrace();
            returnObject.setCode(Constants.RETURN_OBJECT_CODE_FAIL);
            returnObject.setMessage("系统繁忙,请稍后再试......");
        }
        return returnObject;
    }

    @RequestMapping("/workbench/clue/detailClue.do")
    public String detailClue(String id,HttpServletRequest request){
        //调用Service层方法,收集参数
        Clue clue = clueService.queryClueForDetailById(id);
        List<ClueRemark> clueRemarkList = clueRemarkService.queryClueRemarkForDetailByClueId(id);
        List<Activity> activityList = activityService.queryActivityForDetailByClueId(id);
        //将数据保存在request中
        request.setAttribute("clue",clue);
        request.setAttribute("clueRemarkList",clueRemarkList);
        request.setAttribute("activityList",activityList);
        //请求转发
        return "workbench/clue/detail";
    }

    @RequestMapping("/workbench/clue/saveCreateClueRemark.do")
    public @ResponseBody Object saveCreateClueRemark(ClueRemark clueRemark,HttpSession session){
        //封装参数
        User user = (User) session.getAttribute(Constants.SESSION_USER);
        clueRemark.setId(UUIDUtils.getUUID());
        clueRemark.setCreateBy(user.getId());
        clueRemark.setCreateTime(DateUtils.formatDateTime(new Date()));
        clueRemark.setEditFlag("0");

        ReturnObject returnObject = new ReturnObject();
        try {
            int ret = clueRemarkService.saveCreateClueRemark(clueRemark);
            if (ret > 0) {
                returnObject.setCode(Constants.RETURN_OBJECT_CODE_SUCCESS);
                returnObject.setRetData(clueRemark);
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

    @RequestMapping("/workbench/clue/deleteClueRemarkById.do")
    public @ResponseBody Object deleteClueRemarkById(String id){
        ReturnObject returnObject = new ReturnObject();
        try {
            int ret = clueRemarkService.deleteClueRemarkById(id);
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

    @RequestMapping("/workbench/clue/saveEditClueRemark.do")
    public @ResponseBody Object saveEditClueRemark(ClueRemark clueRemark,HttpSession session){
        User user = (User) session.getAttribute(Constants.SESSION_USER);
        clueRemark.setEditBy(user.getId());
        clueRemark.setEditTime(DateUtils.formatDateTime(new Date()));
        clueRemark.setEditFlag("1");

        ReturnObject returnObject = new ReturnObject();
        try {
            int ret = clueRemarkService.saveEditClueRemark(clueRemark);
            if (ret > 0) {
                returnObject.setCode(Constants.RETURN_OBJECT_CODE_SUCCESS);
                returnObject.setRetData(clueRemark);
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

    @RequestMapping("/workbench/clue/queryActivityForDetailByNameAndClueId.do")
    public @ResponseBody Object queryActivityForDetailByNameAndClueId(String activityName,String clueId){
        //封装参数
        Map<String,Object> map = new HashMap<>();
        map.put("activityName",activityName);
        map.put("clueId",clueId);
        //调用Service层方法，查询该线索未关联的市场活动
        List<Activity> activityList = activityService.queryActivityForDetailByNameAndClueId(map);
        //根据查询结果,返回响应信息
        return activityList;
    }

    @RequestMapping("/workbench/clue/saveBundActivity.do")
    public @ResponseBody Object bunActivity(String[] id,String clueId){
        //封装参数
        List<ClueActivityRelation> clueActivityRelationList = new ArrayList<>();
        ClueActivityRelation clueActivityRelation = null;
        for(String activityId : id){
            clueActivityRelation = new ClueActivityRelation();
            clueActivityRelation.setId(UUIDUtils.getUUID());
            clueActivityRelation.setClueId(clueId);
            clueActivityRelation.setActivityId(activityId);

            clueActivityRelationList.add(clueActivityRelation);
        }
        ReturnObject returnObject = new ReturnObject();
        try {
            //调用Service层方法,保存创建的线索市场活动关系
            int ret = clueActivityRelationService.saveCreateClueActivityRelationByList(clueActivityRelationList);
            if (ret > 0) {
                //调用Service层方法,查询该线索所关联的所有市场活动
                List<Activity> activityList = activityService.queryActivityForDetailByIds(id);
                returnObject.setCode(Constants.RETURN_OBJECT_CODE_SUCCESS);
                returnObject.setRetData(activityList);
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

    @RequestMapping("/workbench/clue/deleteBundActivity.do")
    public @ResponseBody Object deleteBundActivity(ClueActivityRelation clueActivityRelation){
        ReturnObject returnObject = new ReturnObject();
        try {
            int ret = clueActivityRelationService.deleteClueActivityRelationByClueIdAndActivityId(clueActivityRelation);
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

    @RequestMapping("/workbench/clue/convert.do")
    public String cover(String id,HttpServletRequest request){
        //调用Service层方法,查询阶段数据字典值
        List<DicValue> stageList = dicValueService.queryDicValueByTypeCode("stage");
        Clue clue = clueService.queryClueForDetailById(id);
        //将数据存放在request中
        request.setAttribute("stageList",stageList);
        request.setAttribute("clue",clue);
        return "workbench/clue/convert";
    }

    @RequestMapping("/workbench/clue/queryActivityForConvertByNameAndClueId.do")
    public @ResponseBody Object queryActivityForConvertByNameAndClueId(String clueId,String activityName){
        //封装参数
        Map<String,Object> map = new HashMap<>();
        map.put("clueId",clueId);
        map.put("activityName",activityName);
        //调用Service层方法,查询该线索所关联的所有市场活动源
        List<Activity> activityList = activityService.queryActivityForConvertByNameAndClueId(map);
        //根据查询结果，返回响应信息
        return activityList;
    }

    @RequestMapping("/workbench/clue/convertClue.do")
    public @ResponseBody Object convertClue(String clueId,String isCreateTransaction,String money,String name,String expectedDate,String stage,String activityId,HttpSession session){
        //封装参数
        Map<String,Object> map = new HashMap<>();
        map.put("clueId",clueId);
        map.put("isCreateTransaction",isCreateTransaction);
        map.put("money",money);
        map.put("name",name);
        map.put("expectedDate",expectedDate);
        map.put("stage",stage);
        map.put("activityId",activityId);
        map.put(Constants.SESSION_USER,session.getAttribute(Constants.SESSION_USER));

        ReturnObject returnObject = new ReturnObject();
        try {
            //调用Service层方法,转换线索
            clueService.saveConvertClue(map);
            returnObject.setCode(Constants.RETURN_OBJECT_CODE_SUCCESS);
        } catch (Exception e) {
            returnObject.setCode(Constants.RETURN_OBJECT_CODE_FAIL);
            returnObject.setMessage("系统繁忙,请稍后再试......");
        }
        return returnObject;
    }


}
