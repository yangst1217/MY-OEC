package com.mfw.controller.base;

import java.util.Date;

import org.apache.shiro.SecurityUtils;
import org.apache.shiro.session.Session;
import org.apache.shiro.subject.Subject;

import com.mfw.entity.system.User;
import com.mfw.util.Const;
import com.mfw.util.PageData;

public class BaseService {

	/**
	 * 获取用户信息
	 * @return
	 */
	public User getUser(){
		Subject currentUser = SecurityUtils.getSubject();  
		Session session = currentUser.getSession();
		User user = (User)session.getAttribute(Const.SESSION_USER);
		return user;
	}
	
	/**
	 * 新增数据时设置默认信息
	 * @param pd
	 * @return
	 */
	public PageData savePage(PageData pd){
		User user=getUser();
		pd.put("isdel","0");//0 有效，1或者null 无效
		pd.put("createUser", user.getUSERNAME());
		pd.put("createTime", new Date());
		return pd;
	}
	
	/**
	 * 更新数据时组装更新信息
	 * @param pd
	 * @return
	 */
	public PageData updatePage(PageData pd){
		User user=getUser();
		pd.put("updateUser", user.getUSERNAME());
		pd.put("updateTime", new Date());
		return pd;
	}
	
}
