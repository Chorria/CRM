package com.zhou.crm.workbench.mapper;

import com.zhou.crm.workbench.domain.Activity;
import com.zhou.crm.workbench.domain.ActivityRemark;
import com.zhou.crm.workbench.domain.FunnelVO;

import java.util.List;
import java.util.Map;

public interface ActivityMapper {
    int deleteByPrimaryKey(String id);

    int insert(Activity record);

    int insertSelective(Activity record);

    Activity selectByPrimaryKey(String id);

    int updateByPrimaryKeySelective(Activity record);

    int updateByPrimaryKey(Activity record);

    int insertActivity(Activity activity);

    /**
     * 分页查询市场活动
     * @param map
     * @return
     */
    List<Activity> selectActivityByConditionForPage(Map<String,Object> map);

    /**
     * 查询市场活动的总条数
     * @param map
     * @return
     */
    int selectCountOfActivityByCondition(Map<String,Object> map);

    /**
     * 根据ids批量删除市场活动
     * @param ids
     * @return
     */
    int deleteActivityByIds(String[] ids);

    /**
     * 根据id查询市场活动
     * @param id
     * @return
     */
    Activity selectActivityById(String id);

    /**
     * 保存修改的市场活动
     * @param activity
     * @return
     */
    int updateActivity(Activity activity);

    /**
     * 查询所有市场活动
     * @return
     */
    List<Activity> selectAllActivity();

    /**
     * 根据id查询市场活动
     * @return
     */
    List<Activity> selectAllActivityByIds(String[] ids);

    /**
     * 批量保存创建的市场活动
     * @param activityList
     * @return
     */
    int insertActivityByList(List<Activity> activityList);

    /**
     * 根据id查询市场活动的明细信息
     * @param id
     * @return
     */
    Activity selectActivityForDetailById(String id);

    /**
     * 根据clueId查询该线索所绑定的所有市场活动
     * @param clueId
     * @return
     */
    List<Activity> selectActivityForDetailByClueId(String clueId);

    /**
     * 根据ActivityName和clueID查询线索未关联的市场活动
     * @param map
     * @return
     */
    List<Activity> selectActivityForDetailByNameAndClueId(Map<String,Object> map);

    /**
     * 根据ids批量查询市场活动
     * @param ids
     * @return
     */
    List<Activity> selectActivityForDetailByIds(String[] ids);

    /**
     * 根据acitivityName查询交易的市场活动源
     * @param name
     * @return
     */
    List<Activity> selectActivityByName(String name);

    /**
     * 在线索转换页面,根据activityName查询为线索创建的交易的市场活动源
     * @param map
     * @return
     */
    List<Activity> selectActivityForConvertByNameAndClueId(Map<String,Object> map);

    /**
     * 根据contactsId查询该联系人所关联的市场活动
     * @param contactsId
     * @return
     */
    List<Activity> selectActivityForDetailByContactsId(String contactsId);

    /**
     * 根据activityName 和contactsId 模糊查询市场活动
     * @param map
     * @return
     */
    List<Activity> selectActivityForDetailByNameAndContactsId(Map<String,Object> map);

    /**
     * 查询市场活动表中各个市场活动的数据量
     * @return
     */
    List<FunnelVO> selectCountOfActivityGroupByName();
}