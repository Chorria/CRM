package com.zhou.crm.settings.mapper;

import com.zhou.crm.settings.domain.DicValue;

import java.util.List;

public interface DicValueMapper {
    int deleteByPrimaryKey(String id);

    int insert(DicValue record);

    int insertSelective(DicValue record);

    DicValue selectByPrimaryKey(String id);

    int updateByPrimaryKeySelective(DicValue record);

    int updateByPrimaryKey(DicValue record);

    /**
     * 根据TypeCode查询数据字典值
     * @param typeCode
     * @return
     */
    List<DicValue> selectDicValueByTypeCode(String typeCode);

    /**
     * 根据id查询数据字典值
     * @param id
     * @return
     */
    DicValue selectDicValueById(String id);
}