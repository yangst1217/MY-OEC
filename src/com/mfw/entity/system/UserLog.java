package com.mfw.entity.system;

import java.util.Date;

public class UserLog {

	public enum LogType{
		add,
		delete,
		update
	}
	
	private Integer id;
	private Date oper_date;
	private String user_id;
	private LogType logType;
	/*操作对象*/
	private String operObj;
	/*操作内容*/
	private String content;
	
	/**
	 * 初始化用户操作日志
	 * @param user_id	操作人ID
	 * @param logType	操作类型，LogType枚举类
	 * @param operObj	操作对象
	 * @param content	操作内容
	 */
	public UserLog(String user_id, LogType logType, String operObj, String content){
		this.user_id = user_id;
		this.logType = logType;
		this.operObj = operObj;
		this.content = content;
	}
	
	public Integer getId() {
		return id;
	}
	public void setId(Integer id) {
		this.id = id;
	}
	public Date getOper_date() {
		return oper_date;
	}
	public void setOper_date(Date oper_date) {
		this.oper_date = oper_date;
	}
	public String getUser_id() {
		return user_id;
	}
	public void setUser_id(String user_id) {
		this.user_id = user_id;
	}
	public LogType getLogType() {
		return logType;
	}
	public void setLogType(LogType logType) {
		this.logType = logType;
	}
	public String getOperObj() {
		return operObj;
	}
	public void setOperObj(String operObj) {
		this.operObj = operObj;
	}
	public String getContent() {
		return content;
	}
	public void setContent(String content) {
		this.content = content;
	}
	
	
}
