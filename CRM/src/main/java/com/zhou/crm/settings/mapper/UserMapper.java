package com.zhou.crm.settings.mapper;

import com.zhou.crm.settings.domain.User;
import org.apache.ibatis.annotations.Mapper;

import java.util.List;
import java.util.Map;

public interface UserMapper {
    int deleteByPrimaryKey(String id);

    int insert(User record);

    int insertSelective(User record);

    User selectByPrimaryKey(String id);

    int updateByPrimaryKeySelective(User record);

    int updateByPrimaryKey(User record);

    /**
     * 根据账号和密码查询用户
     * @param map   账号和密码所封装成的map
     * @return  查询的用户
     */
    User selectUserByLoginActAndPwd(Map<String,Object> map);

    /**
     * 查询所有用户
     * @return
     */
    List<User> selectAllUsers();
}