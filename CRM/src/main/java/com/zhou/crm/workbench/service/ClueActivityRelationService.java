package com.zhou.crm.workbench.service;

import com.zhou.crm.workbench.domain.ClueActivityRelation;

import java.util.List;

public interface ClueActivityRelationService {
    int saveCreateClueActivityRelationByList(List<ClueActivityRelation> list);

    int deleteClueActivityRelationByClueIdAndActivityId(ClueActivityRelation clueActivityRelation);

    int deleteClueActivityRelationByClueId(String clueId);
}
