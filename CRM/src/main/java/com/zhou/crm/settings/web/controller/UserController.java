package com.zhou.crm.settings.web.controller;

import com.zhou.crm.commons.constants.Constants;
import com.zhou.crm.commons.utils.DateUtils;
import com.zhou.crm.commons.domain.ReturnObject;
import com.zhou.crm.settings.domain.User;
import com.zhou.crm.settings.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;

@Controller
public class UserController {
    @Autowired
    private UserService userService;

    @RequestMapping("/settings/qx/user/toLogin.do")
    public String toLogin(){
        return "settings/qx/user/login";
    }

    @RequestMapping("/settings/qx/user/login.do")
    public @ResponseBody ReturnObject login(String loginAct, String loginPwd, String isRemPwd, HttpServletRequest request, HttpServletResponse response, HttpSession session) {
        String remoteAddr = request.getRemoteAddr();
        //封装参数
        Map<String,Object> map = new HashMap<>();
        map.put("loginAct",loginAct);
        map.put("loginPwd",loginPwd);
        //调用Service层方法,查询用户
        User user = userService.queryUserByLoginActAndPwd(map);
        //根据查询结果,生成相应信息
        ReturnObject returnObject = new ReturnObject();
        if (user == null){//登录失败,账号或密码错误
            returnObject.setCode(Constants.RETURN_OBJECT_CODE_FAIL);
            returnObject.setMessage("用户名或者密码错误!");
        } else {//进一步判断账号是否合法
            if (DateUtils.formatDateTime(new Date()).compareTo(user.getExpireTime()) > 0) {
                //登录失败,账号已过期
                returnObject.setCode(Constants.RETURN_OBJECT_CODE_FAIL);
                returnObject.setMessage("账号已过期!");
            } else if ("0".equals(user.getLockState())) {
                //登录失败,账号已被锁定
                returnObject.setCode(Constants.RETURN_OBJECT_CODE_FAIL);
                returnObject.setMessage("账号已被锁定!");
            } else if (!user.getAllowIps().contains(remoteAddr)) {
                System.out.println(remoteAddr);
                System.out.println(user.getAllowIps() + "-----------------------");
                //登录失败,账号登录IP地址受限
                returnObject.setCode(Constants.RETURN_OBJECT_CODE_FAIL);
                returnObject.setMessage("登录IP地址受限!");
            } else {
                //登录成功
                returnObject.setCode(Constants.RETURN_OBJECT_CODE_SUCCESS);
                returnObject.setMessage("登录成功!");
                //将成功的数据放入Session中
                session.setAttribute(Constants.SESSION_USER,user);

                //若十天内免登录,则记录Cookie
                if("true".equals(isRemPwd)){
                    //往外记录Cookie
                    Cookie loginActCookie = new Cookie("loginAct", user.getLoginAct());
                    loginActCookie.setMaxAge(60 * 60 * 24 * 10);
                    Cookie loginPwdCookie = new Cookie("loginPwd", user.getLoginPwd());
                    loginPwdCookie.setMaxAge(60 * 60 * 24 * 10);

                    response.addCookie(loginActCookie);
                    response.addCookie(loginPwdCookie);
                } else {
                    //把没有过期的Cookie删除
                    Cookie loginActCookie = new Cookie("loginAct", "1");
                    loginActCookie.setMaxAge(0);
                    Cookie loginPwdCookie = new Cookie("loginPwd", "1");
                    loginPwdCookie.setMaxAge(0);

                    response.addCookie(loginActCookie);
                    response.addCookie(loginPwdCookie);
                }
            }
        }

        return returnObject;

    }

    /**
     * 安全退出接口
     * @param response
     * @param session
     * @return
     */
    @RequestMapping("/settings/qx/user/logout.do")
    public String logout(HttpServletResponse response,HttpSession session){
        //销毁cookie
        Cookie loginActCookie = new Cookie("loginAct","1");
        loginActCookie.setMaxAge(0);
        Cookie loginPwdCookie = new Cookie("loginPwd","1");
        loginPwdCookie.setMaxAge(0);

        //销毁session
        session.invalidate();

        response.addCookie(loginActCookie);
        response.addCookie(loginPwdCookie);
        //跳转到首页
        return "redirect:/";
    }

}
