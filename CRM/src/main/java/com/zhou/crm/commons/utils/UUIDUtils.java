package com.zhou.crm.commons.utils;

import java.util.UUID;

public class UUIDUtils {
    /**
     * 获取UUID的值
     */
    public static String getUUID(){
        return UUID.randomUUID().toString().replaceAll("-","");
    }
}
