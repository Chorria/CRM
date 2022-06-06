package com.zhou.crm.workbench.web.controller;

import com.zhou.crm.commons.constants.Constants;
import com.zhou.crm.commons.domain.ReturnObject;
import com.zhou.crm.commons.utils.DateUtils;
import com.zhou.crm.commons.utils.UUIDUtils;
import com.zhou.crm.settings.domain.User;
import com.zhou.crm.workbench.domain.ActivityRemark;
import com.zhou.crm.workbench.service.ActivityRemarkService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpSession;
import java.util.Date;

@Controller
public class ActivityRemarkController {
    @Autowired
    private ActivityRemarkService activityRemarkService;
    @RequestMapping("workbench/activity/saveCreateActivityRemark.do")
    public @ResponseBody Object saveCreateActivityRemark(ActivityRemark activityRemark, HttpSession session){
        //封装activityRemark参数
        User user = (User) session.getAttribute(Constants.SESSION_USER);
        activityRemark.setId(UUIDUtils.getUUID());
        activityRemark.setCreateTime(DateUtils.formatDateTime(new Date()));
        activityRemark.setCreateBy(user.getId());
        activityRemark.setEditFlag("0");

        ReturnObject returnObject = new ReturnObject();
        try {
            //调用Service层的方法,保存创建的市场活动备注
            int ret = activityRemarkService.saveCreateActivityRemark(activityRemark);
            if (ret > 0) {
                returnObject.setCode(Constants.RETURN_OBJECT_CODE_SUCCESS);
                returnObject.setRetData(activityRemark);
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

    @RequestMapping("/workbench/activity/deleteActivityRemarkById.do")
    public @ResponseBody Object deleteActivityRemarkById(String id){
        ReturnObject returnObject = new ReturnObject();
        try {
            //调用service层方法，删除备注
            int ret = activityRemarkService.deleteActivityRemarkById(id);
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

    @RequestMapping("/workbench/activity/saveEditActivityRemark.do")
    public @ResponseBody Object saveEditActivityRemark(ActivityRemark activityRemark,HttpSession session){
        ReturnObject returnObject = new ReturnObject();
        //封装参数
        activityRemark.setEditTime(DateUtils.formatDateTime(new Date()));
        User user = (User) session.getAttribute(Constants.SESSION_USER);
        activityRemark.setEditBy(user.getId());
        activityRemark.setEditFlag("1");
        try {
            //调用Service层方法,保存修改的市场活动备注
            int ret = activityRemarkService.saveEditActivityRemark(activityRemark);
            if (ret > 0) {
                returnObject.setCode(Constants.RETURN_OBJECT_CODE_SUCCESS);
                returnObject.setRetData(activityRemark);
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
