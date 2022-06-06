package com.zhou.crm.settings.service.impl;

import com.zhou.crm.settings.domain.User;
import com.zhou.crm.settings.mapper.UserMapper;
import com.zhou.crm.settings.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Map;

@Service("userService")
public class UserServiceImpl implements UserService {
    @Autowired
    private UserMapper userMapper;
    @Override
    public User queryUserByLoginActAndPwd(Map<String, Object> map) {
        User user = userMapper.selectUserByLoginActAndPwd(map);
        return user;
    }

    @Override
    public List<User> queryAllUsers() {
        List<User> userList = userMapper.selectAllUsers();
        return userList;
    }
}
