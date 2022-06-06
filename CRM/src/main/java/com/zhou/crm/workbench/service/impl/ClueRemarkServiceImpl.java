package com.zhou.crm.workbench.service.impl;

import com.zhou.crm.workbench.domain.ClueRemark;
import com.zhou.crm.workbench.mapper.ClueRemarkMapper;
import com.zhou.crm.workbench.service.ClueRemarkService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service("clueRemarkService")
public class ClueRemarkServiceImpl implements ClueRemarkService {
    @Autowired
    private ClueRemarkMapper clueRemarkMapper;
    @Override
    public List<ClueRemark> queryClueRemarkForDetailByClueId(String clueId) {
        return clueRemarkMapper.selectClueRemarkForDetailByClueId(clueId);
    }

    @Override
    public int saveCreateClueRemark(ClueRemark clueRemark) {
        return clueRemarkMapper.insertClueRemark(clueRemark);
    }

    @Override
    public int deleteClueRemarkById(String id) {
        return clueRemarkMapper.deleteClueRemarkById(id);
    }

    @Override
    public int saveEditClueRemark(ClueRemark clueRemark) {
        return clueRemarkMapper.updateClueRemark(clueRemark);
    }
}
