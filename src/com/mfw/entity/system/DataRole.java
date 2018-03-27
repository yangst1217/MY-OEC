package com.mfw.entity.system;

import java.util.Date;

/**
 * 用户数据权限实体类
 * @author liweitao
 *
 * 修改时间		修改人		修改内容
 * 2016-03-18	李伟涛		新建
 */
public class DataRole {
	
	/**
	 * ID
	 */
	private String ID;
	/**
	 * 用户ID
	 */
	private String USER_ID;
	/**
	 * 部门ID
	 */
	private int DEPT_ID;
	/**
	 * 创建人
	 */
	private String CREATE_USER;
	/**
	 * 创建时间
	 */
	private Date CREATE_TIME;
	
	/*Getters And Setters*/
	public String getID() {
		return ID;
	}
	public void setID(String iD) {
		ID = iD;
	}
	public String getUSER_ID() {
		return USER_ID;
	}
	public void setUSER_ID(String uSER_ID) {
		USER_ID = uSER_ID;
	}
	public int getDEPT_ID() {
		return DEPT_ID;
	}
	public void setDEPT_ID(int dEPT_ID) {
		DEPT_ID = dEPT_ID;
	}
	public String getCREATE_USER() {
		return CREATE_USER;
	}
	public void setCREATE_USER(String cREATE_USER) {
		CREATE_USER = cREATE_USER;
	}
	public Date getCREATE_TIME() {
		return CREATE_TIME;
	}
	public void setCREATE_TIME(Date cREATE_TIME) {
		CREATE_TIME = cREATE_TIME;
	}
	
}
