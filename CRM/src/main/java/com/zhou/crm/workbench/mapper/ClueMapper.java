package com.zhou.crm.workbench.mapper;

import com.zhou.crm.workbench.domain.Clue;
import com.zhou.crm.workbench.domain.ClueRemark;
import com.zhou.crm.workbench.domain.FunnelVO;

import java.util.List;
import java.util.Map;

public interface ClueMapper {
    int deleteByPrimaryKey(String id);

    int insert(Clue record);

    int insertSelective(Clue record);

    Clue selectByPrimaryKey(String id);

    int updateByPrimaryKeySelective(Clue record);

    int updateByPrimaryKey(Clue record);

    /**
     * 保存创建的线索
     * @param clue
     * @return
     */
    int insertClue(Clue clue);

    /**
     * 分页查询所有的线索
     * @param map
     * @return
     */
    List<Clue> selectClueByConditionForPage(Map<String,Object> map);

    /**
     * 查询线索的总记录数
     * @param map
     * @return
     */
    int selectCountOfClueByCondition(Map<String,Object> map);

    /**
     * 根据id查询线索
     * @param id
     * @return
     */
    Clue selectClueById(String id);

    /**
     * 修改保存的线索
     * @param clue
     * @return
     */
    int updateClue(Clue clue);

    /**
     * 根据ids批量删除线索
     * @param ids
     * @return
     */
    int deleteClueByIds(String[] ids);

    /**
     * 根据id查询线索的明细
     * @param id
     * @return
     */
    Clue selectClueForDetailById(String id);

    /**
     * 根据id删除线索
     * @param id
     * @return
     */
    int deleteClueById(String id);

    /**
     * 查看线索表中各个联系来源的数据量
     * @return
     */
    List<FunnelVO> selectCountOfClueGroupBySource();
}