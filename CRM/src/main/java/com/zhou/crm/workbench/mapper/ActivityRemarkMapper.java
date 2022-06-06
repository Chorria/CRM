package com.zhou.crm.workbench.mapper;

import com.zhou.crm.workbench.domain.ActivityRemark;

import java.util.List;

public interface ActivityRemarkMapper {
    int deleteByPrimaryKey(String id);

    int insert(ActivityRemark record);

    int insertSelective(ActivityRemark record);

    ActivityRemark selectByPrimaryKey(String id);

    int updateByPrimaryKeySelective(ActivityRemark record);

    int updateByPrimaryKey(ActivityRemark record);

    /**
     * 根据市场活动id查询所有的市场活动备注信息
     * @param activityId
     * @return
     */
    List<ActivityRemark> selectActivityRemarkForDetailByActivityId(String activityId);

    /**
     * 保存创建的市场活动备注
     * @param activityRemark
     * @return
     */
    int insertActivityRemark(ActivityRemark activityRemark);

    /**
     * 根据id删除市场活动备注
     * @param id
     * @return
     */
    int deleteActivityRemarkById(String id);

    /**
     * 根据ids批量删除市场活动备注
     * @param activityIds
     * @return
     */
    int deleteActivityRemarkByActivityIds(String[] activityIds);

    /**
     * 保存修改的市场活动备注
     * @param activityRemark
     * @return
     */
    int updateActivityRemark(ActivityRemark activityRemark);
}