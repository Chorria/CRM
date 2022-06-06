package com.zhou.crm.workbench.mapper;

import com.zhou.crm.workbench.domain.ClueActivityRelation;

import java.util.List;

public interface ClueActivityRelationMapper {
    int deleteByPrimaryKey(String id);

    int insert(ClueActivityRelation record);

    int insertSelective(ClueActivityRelation record);

    ClueActivityRelation selectByPrimaryKey(String id);

    int updateByPrimaryKeySelective(ClueActivityRelation record);

    int updateByPrimaryKey(ClueActivityRelation record);

    /**
     * 添加线索所关联的市场活动
     * @param list
     * @return
     */
    int insertClueActivityRelationByList(List<ClueActivityRelation> list);

    /**
     * 解除线索所关联的市场活动
     * @param clueActivityRelation
     * @return
     */
    int deleteClueActivityRelationByClueIdAndActivityId(ClueActivityRelation clueActivityRelation);

    /**
     * 根据clueIds批量删除线索所关联的市场活动
     * @param clueIds
     * @return
     */
    int deleteClueActivityRelationByClueIds(String[] clueIds);

    /**
     * 根据clueId查询线索所关联的所有市场活动
     * @param clueId
     * @return
     */
    List<ClueActivityRelation> selectClueActivityRelationByClueId(String clueId);

    /**
     * 根据clueId 删除该线索所关联的所有线索与市场活动的关联关系
     * @param clueId
     * @return
     */
    int deleteClueActivityRelationByClueId(String clueId);
}