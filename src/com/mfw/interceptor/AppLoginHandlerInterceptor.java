package com.mfw.interceptor;

import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.shiro.SecurityUtils;
import org.apache.shiro.session.Session;
import org.apache.shiro.subject.Subject;
import org.springframework.web.servlet.handler.HandlerInterceptorAdapter;

import com.mfw.entity.system.Menu;
import com.mfw.entity.system.User;
import com.mfw.util.Const;

/**
 * 类名称：LoginHandlerInterceptor.java 类描述：
 * 
 * @author mfw 作者单位： 联系方式： 创建时间：2015年1月1日
 * @version 1.6
 */
public class AppLoginHandlerInterceptor extends HandlerInterceptorAdapter {

	@Override
	public boolean preHandle(HttpServletRequest request, HttpServletResponse response, 
			Object handler) throws Exception {
		String path = request.getServletPath();
		if (path.startsWith("/app") && path.contains("login")) {
			return true;
		}else{
			Subject currentUser = SecurityUtils.getSubject();
			Session session = currentUser.getSession();
			User user = (User) session.getAttribute(Const.SESSION_USER);
			if (user == null) {
				response.sendRedirect(request.getContextPath() + "/app_login/toLogin.do");
				return false;
			}else{
				return true;
			}
		}
	}

}
