package com.zhou.crm.workbench.mapper;

import com.zhou.crm.workbench.domain.ClueRemark;

import java.util.List;

public interface ClueRemarkMapper {
    int deleteByPrimaryKey(String id);

    int insert(ClueRemark record);

    int insertSelective(ClueRemark record);

    ClueRemark selectByPrimaryKey(String id);

    int updateByPrimaryKeySelective(ClueRemark record);

    int updateByPrimaryKey(ClueRemark record);

    /**
     * 根据clueId查询所有的线索备注
     * @param clueId
     * @return
     */
    List<ClueRemark> selectClueRemarkForDetailByClueId(String clueId);

    /**
     * 添加线索备注
     * @param clueRemark
     * @return
     */
    int insertClueRemark(ClueRemark clueRemark);

    /**
     * 根据id删除线索备注
     * @param id
     * @return
     */
    int deleteClueRemarkById(String id);

    /**
     * 根据clueId删除线索备注
     * @param clueId
     * @return
     */
    int deleteClueRemarkByClueId(String clueId);

    /**
     * 根据clueIds批量删除线索备注
     * @param clueIds
     * @return
     */
    int deleteClueRemarkByClueIds(String[] clueIds);

    /**
     * 修改保存线索备注
     * @param clueRemark
     * @return
     */
    int updateClueRemark(ClueRemark clueRemark);
}