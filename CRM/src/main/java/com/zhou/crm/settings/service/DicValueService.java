package com.zhou.crm.settings.service;

import com.zhou.crm.settings.domain.DicValue;

import java.util.List;

public interface DicValueService {
    List<DicValue> queryDicValueByTypeCode(String typeCode);

    DicValue queryDicValueById(String id);
}
