package com.zhou.crm.commons.utils;

import java.text.SimpleDateFormat;
import java.util.Date;

public class DateUtils {
    public static String formatDateTime(Date date){
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        return sdf.format(date);
    }

    public static String formatDate(Date date){
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
        return sdf.format(date);
    }

    public static String formatTime(Date date){
        SimpleDateFormat sdf = new SimpleDateFormat("yHH:mm:ss");
        return sdf.format(date);
    }
}
