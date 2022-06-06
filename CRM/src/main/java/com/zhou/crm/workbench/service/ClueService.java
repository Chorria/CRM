package com.zhou.crm.workbench.service;

import com.zhou.crm.workbench.domain.Clue;
import com.zhou.crm.workbench.domain.FunnelVO;

import java.util.List;
import java.util.Map;

public interface ClueService {
    int saveCreateClue(Clue clue);

    List<Clue> queryClueByConditionForPage(Map<String,Object> map);

    int queryCountOfClueByCondition(Map<String,Object> map);

    Clue queryClueById(String id);

    int saveEditClue(Clue clue);

    Clue queryClueForDetailById(String id);

    void deleteClueByIds(String[] id);

    void saveConvertClue(Map<String,Object> map);

    List<FunnelVO> queryCountOfClueGroupBySource();
}
