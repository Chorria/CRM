package com.zhou.crm.workbench.service.impl;

import com.zhou.crm.workbench.domain.ClueActivityRelation;
import com.zhou.crm.workbench.mapper.ClueActivityRelationMapper;
import com.zhou.crm.workbench.service.ClueActivityRelationService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service("clueActivityRelationService")
public class ClueActivityRelationServiceImpl implements ClueActivityRelationService {
    @Autowired
    private ClueActivityRelationMapper clueActivityRelationMapper;

    @Override
    public int saveCreateClueActivityRelationByList(List<ClueActivityRelation> list) {
        return clueActivityRelationMapper.insertClueActivityRelationByList(list);
    }

    @Override
    public int deleteClueActivityRelationByClueIdAndActivityId(ClueActivityRelation clueActivityRelation) {
        return clueActivityRelationMapper.deleteClueActivityRelationByClueIdAndActivityId(clueActivityRelation);
    }

    @Override
    public int deleteClueActivityRelationByClueId(String clueId) {
        return deleteClueActivityRelationByClueId(clueId);
    }
}
