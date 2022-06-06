package com.zhou.crm.workbench.web.controller;

import com.zhou.crm.commons.constants.Constants;
import com.zhou.crm.commons.domain.ReturnObject;
import com.zhou.crm.commons.utils.DateUtils;
import com.zhou.crm.commons.utils.HSSFUtils;
import com.zhou.crm.commons.utils.UUIDUtils;
import com.zhou.crm.settings.domain.User;
import com.zhou.crm.settings.service.UserService;
import com.zhou.crm.workbench.domain.Activity;
import com.zhou.crm.workbench.domain.ActivityRemark;
import com.zhou.crm.workbench.service.ActivityRemarkService;
import com.zhou.crm.workbench.service.ActivityService;
import org.apache.poi.hssf.usermodel.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.util.*;

@Controller
public class ActivityController {
    @Autowired
    private UserService userService;

    @Autowired
    private ActivityService activityService;

    @Autowired
    private ActivityRemarkService activityRemarkService;

    @RequestMapping("/workbench/activity/index.do")
    public String index(HttpServletRequest httpServletRequest){
        //调用Service层的方法,查询所有的用户
        List<User> userList = userService.queryAllUsers();
        //将数据保存到request中
        httpServletRequest.setAttribute("userList",userList);
        //请求转发到市场活动的主页面
        return "workbench/activity/index";
    }

    @RequestMapping("/workbench/activity/saveCreateActivity.do")
    public @ResponseBody Object saveCreateActivity(Activity activity, HttpSession session){
        //封装参数
        activity.setId(UUIDUtils.getUUID());
        activity.setCreateTime(DateUtils.formatDate(new Date()));

        User user = (User) session.getAttribute(Constants.SESSION_USER);
        activity.setCreateBy(user.getId());

        ReturnObject returnObject = new ReturnObject();
        try {
            //调用Service层的方法,保存市场活动
            int reslut = activityService.saveCreateActivity(activity);
            if (reslut == 1) {
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

    /**
     * 分页查询市场活动
     * @param owner
     * @param name
     * @param startDate
     * @param endDate
     * @param pageNo
     * @param pageSize  市场活动总记录数
     * @return
     */
    @RequestMapping("/workbench/activity/queryActivityByConditionForPage.do")
    public @ResponseBody Object queryActivityByConditionForPage(String name,String owner,String startDate,String endDate,int pageNo,int pageSize) {
        //封装参数
        Map<String, Object> map = new HashMap<>();
        map.put("name", name);
        map.put("owner", owner);
        map.put("startDate", startDate);
        map.put("endDate", endDate);
        map.put("beginNo", (pageNo - 1) * pageSize);
        map.put("pageSize", pageSize);
        //调用Service层方法,查询数据
        List<Activity> activityList = activityService.queryActivityByConditionForPage(map);
        int totalRows = activityService.queryCountOfActivityByCondition(map);
        //根据查询结果，生成响应信息
        Map<String, Object> retMap = new HashMap<>();
        retMap.put("activityList", activityList);
        retMap.put("totalRows", totalRows);
        return retMap;
    }

    @RequestMapping("/workbench/activity/deleteActivityByIds.do")
    public @ResponseBody Object deleteActivityByIds(String[] id){
        ReturnObject returnObject = new ReturnObject();
        try {
            //调用Service层方法,删除市场活动及市场备注
            activityService.deleteActivity(id);
            returnObject.setCode(Constants.RETURN_OBJECT_CODE_SUCCESS);
        } catch (Exception e) {
            e.printStackTrace();
            returnObject.setCode(Constants.RETURN_OBJECT_CODE_FAIL);
            returnObject.setMessage("系统繁忙,请稍后再试......");
        }
        return returnObject;
    };

    @RequestMapping("/workbench/activity/queryActivityById.do")
    public @ResponseBody Object queryActivityById(String id){
        //调用Service层方法,查询市场活动
        //根据查询结果,返回响应信息
        return activityService.queryActivityById(id);
    }

    @RequestMapping("/workbench/activity/saveEditActivity.do")
    public @ResponseBody Object saveEditActivity(Activity activity,HttpSession session){
        //记录修改者参数
        User user = (User) session.getAttribute(Constants.SESSION_USER);
        activity.setEditBy(user.getId());
        activity.setEditTime(DateUtils.formatDateTime(new Date()));

        ReturnObject returnObject = new ReturnObject();
        try {
            if (activityService.saveEditActivity(activity) > 0) {
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

    @RequestMapping("/workbench/activity/exportAllActivity.do")
    public void exportAllActivity(HttpServletResponse response) throws IOException {
        //调用Service层方法,查询全部的市场活动
        List<Activity> activityList = activityService.queryAllActivity();
        //创建exel文件，并且把activityList写入到excel文件中
        HSSFWorkbook hw = new HSSFWorkbook();
        HSSFSheet sheet = hw.createSheet("市场活动列表");
        HSSFRow row = sheet.createRow(0);
        HSSFCell cell = row.createCell(0);
        cell.setCellValue("ID编号");
        cell = row.createCell(1);
        cell.setCellValue("所有者");
        cell = row.createCell(2);
        cell.setCellValue("名称");
        cell = row.createCell(3);
        cell.setCellValue("开始日期");
        cell = row.createCell(4);
        cell.setCellValue("结束日期");
        cell = row.createCell(5);
        cell.setCellValue("成本");
        cell = row.createCell(6);
        cell.setCellValue("描述");
        cell = row.createCell(7);
        cell.setCellValue("创建时间");
        cell = row.createCell(8);
        cell.setCellValue("创建者");
        cell = row.createCell(9);
        cell.setCellValue("修改时间");
        cell = row.createCell(10);
        cell.setCellValue("修改者");

        //遍历activityList,创建HSSFRow对象,生成所有的数据行
        if (activityList != null && activityList.size() > 0) {
            Activity activity = null;
            for (int i = 0; i < activityList.size(); i++) {
                activity = activityList.get(i);
                //每遍历出一个Activity,生成一行
                row = sheet.createRow(i + 1);
                //每行创建出11列,每列数据从Activity中获取
                cell = row.createCell(0);
                cell.setCellValue(activity.getId());
                cell = row.createCell(1);
                cell.setCellValue(activity.getOwner());
                cell = row.createCell(2);
                cell.setCellValue(activity.getName());
                cell = row.createCell(3);
                cell.setCellValue(activity.getStartDate());
                cell = row.createCell(4);
                cell.setCellValue(activity.getEndDate());
                cell = row.createCell(5);
                cell.setCellValue(activity.getCost());
                cell = row.createCell(6);
                cell.setCellValue(activity.getDescription());
                cell = row.createCell(7);
                cell.setCellValue(activity.getCreateTime());
                cell = row.createCell(8);
                cell.setCellValue(activity.getCreateBy());
                cell = row.createCell(9);
                cell.setCellValue(activity.getEditTime());
                cell = row.createCell(10);
                cell.setCellValue(activity.getEditBy());

            }
        }

        //设置响应的格式
        response.setContentType("application/octet-stream;charset=UTF-8");
        response.addHeader("Content-Disposition","attachment;filename=activityList.xls");

        OutputStream out = response.getOutputStream();
        hw.write(out);

        hw.close();
        out.flush();
    }

    @RequestMapping("/workbench/activity/exportXzActivity.do")
    public void exportXzActivity(String[] id,HttpServletResponse response) throws IOException {
        //调用Service层的方法,根据id查询市场活动
        List<Activity> activityList = activityService.queryAllActivityByIds(id);
        //创建exel文件，并且把activityList写入到excel文件中
        HSSFWorkbook hw = new HSSFWorkbook();
        HSSFSheet sheet = hw.createSheet("市场活动列表");
        HSSFRow row = sheet.createRow(0);
        HSSFCell cell = row.createCell(0);
        cell.setCellValue("Id编号");
        cell = row.createCell(1);
        cell.setCellValue("所有者");
        cell = row.createCell(2);
        cell.setCellValue("名称");
        cell = row.createCell(3);
        cell.setCellValue("开始日期");
        cell = row.createCell(4);
        cell.setCellValue("结束日期");
        cell = row.createCell(5);
        cell.setCellValue("成本");
        cell = row.createCell(6);
        cell.setCellValue("描述");
        cell = row.createCell(7);
        cell.setCellValue("创建时间");
        cell = row.createCell(8);
        cell.setCellValue("创建者");
        cell = row.createCell(9);
        cell.setCellValue("修改时间");
        cell = row.createCell(10);
        cell.setCellValue("修改者");

        if (activityList != null && activityList.size() > 0) {
            Activity activity = null;
            for (int i = 0; i < activityList.size(); i++){
                activity = activityList.get(i);
                row = sheet.createRow(i + 1);
                cell = row.createCell(0);
                cell.setCellValue(activity.getId());
                cell = row.createCell(1);
                cell.setCellValue(activity.getOwner());
                cell = row.createCell(2);
                cell.setCellValue(activity.getName());
                cell = row.createCell(3);
                cell.setCellValue(activity.getStartDate());
                cell = row.createCell(4);
                cell.setCellValue(activity.getEndDate());
                cell = row.createCell(5);
                cell.setCellValue(activity.getCost());
                cell = row.createCell(6);
                cell.setCellValue(activity.getDescription());
                cell = row.createCell(7);
                cell.setCellValue(activity.getCreateTime());
                cell = row.createCell(8);
                cell.setCellValue(activity.getCreateBy());
                cell = row.createCell(9);
                cell.setCellValue(activity.getEditTime());
                cell = row.createCell(10);
                cell.setCellValue(activity.getEditBy());
            }

            //设置响应的格式
            response.setContentType("application/octet-stream;charset=UTF-8");
            response.addHeader("Content-Disposition","attachment;filename=activityList.xls");

            OutputStream out = response.getOutputStream();
            hw.write(out);

            hw.close();
            out.flush();
        }
    }

    @RequestMapping("/workbench/activity/importActivity.do")
    public @ResponseBody Object saveCreateActivityByList(MultipartFile activityFile,HttpSession session) {
        User user = (User) session.getAttribute(Constants.SESSION_USER);
        ReturnObject returnObject = new ReturnObject();
        try {
            //获取文件的输入流
            InputStream inputStream = activityFile.getInputStream();
            HSSFWorkbook hw = new HSSFWorkbook(inputStream);
            //根据Sheet获取HSSFSheet对象,封装了excel文件的所有信息
            HSSFSheet sheet = hw.getSheetAt(0);
            HSSFRow row = null;
            HSSFCell cell = null;
            Activity activity = null;
            //封装Activity参数
            List<Activity> activityList = new ArrayList<>();
            for (int i = 1; i <= sheet.getLastRowNum(); i++) {
                row = sheet.getRow(i);
                activity = new Activity();
                activity.setId(UUIDUtils.getUUID());
                activity.setOwner(user.getId());
                activity.setCreateTime(DateUtils.formatDateTime(new Date()));
                activity.setCreateBy(user.getId());
                for (int j = 0; j < row.getLastCellNum(); j++) {
                    cell = row.getCell(j);

                    String cellValue = HSSFUtils.getCellValueForStr(cell);
                    if (j == 0) {
                        activity.setName(cellValue);
                    } else if (j == 1) {
                        activity.setStartDate(cellValue);
                    } else if (j == 2) {
                        activity.setEndDate(cellValue);
                    } else if (j == 3) {
                        activity.setCost(cellValue);
                    } else if (j == 4) {
                        activity.setDescription(cellValue);
                    }
                }
                //每一行中所有列都封装完成之后，把activity保存到list中
                activityList.add(activity);
            }
            //调用Service层的方法,保存市场活动
            int ret = activityService.saveCreateActivityByList(activityList);
            returnObject.setCode(Constants.RETURN_OBJECT_CODE_SUCCESS);
            returnObject.setRetData(ret);
        } catch (Exception e) {
            e.printStackTrace();
            returnObject.setCode(Constants.RETURN_OBJECT_CODE_FAIL);
            returnObject.setMessage("系统繁忙,请稍后再试......");
        }
        return returnObject;
    }

    @RequestMapping("workbench/activity/detailActivity.do")
    public String detailActivity(String id,HttpServletRequest request){
        //调用Service层方法，查询市场明细页面中所需要的市场活动及市场备注数据
        Activity activity = activityService.queryActivityForDetail(id);
        List<ActivityRemark> activityRemarkList = activityRemarkService.queryActivityRemarkForDetailByActivityId(id);
        //将数据保存在request中
        request.setAttribute("activity",activity);
        request.setAttribute("activityRemarkList",activityRemarkList);
        //请求转发
        return "workbench/activity/detail";
    }
}
