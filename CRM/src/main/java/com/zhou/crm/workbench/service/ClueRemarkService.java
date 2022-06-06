package com.zhou.crm.workbench.service;

import com.zhou.crm.workbench.domain.ClueRemark;

import java.util.List;

public interface ClueRemarkService {
    List<ClueRemark> queryClueRemarkForDetailByClueId(String clueId);

    int saveCreateClueRemark(ClueRemark clueRemark);

    int deleteClueRemarkById(String id);

    int saveEditClueRemark(ClueRemark clueRemark);
}
