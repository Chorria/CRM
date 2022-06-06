package com.zhou.crm.workbench.service;

import com.zhou.crm.workbench.domain.Activity;
import com.zhou.crm.workbench.domain.FunnelVO;

import java.util.List;
import java.util.Map;

public interface ActivityService {
    int saveCreateActivity(Activity activity);

    List<Activity> queryActivityByConditionForPage(Map<String,Object> map);

    int queryCountOfActivityByCondition(Map<String,Object> map);

    Activity queryActivityById(String id);

    int saveEditActivity(Activity activity);

    List<Activity> queryAllActivity();

    List<Activity> queryAllActivityByIds(String[] ids);

    int saveCreateActivityByList(List<Activity> activityList);

    Activity queryActivityForDetail(String id);

    List<Activity> queryActivityForDetailByClueId(String clueId);

    List<Activity> queryActivityForDetailByNameAndClueId(Map<String,Object> map);

    List<Activity> queryActivityForDetailByIds(String[] ids);

    List<Activity> queryActivityByName(String name);

    void deleteActivity(String[] ids);

    List<Activity> queryActivityForConvertByNameAndClueId(Map<String,Object> map);

    List<Activity> queryActivityForDetailByContactsId(String contactsId);

    List<Activity> queryActivityForDetailByNameAndContactsId(Map<String,Object> map);

    List<FunnelVO> queryCountOfActivityGroupByName();
}
