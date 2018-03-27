package com.mfw.entity.bdata;

import com.mfw.entity.Page;
import com.mfw.entity.system.Role;

/**
 * 类名称：User.java 类描述：
 * 
 * @version 1.0
 */
public class Dept {
	private Integer ID; //部门id
	private String DEPT_CODE; //部门编码
	private String DEPT_NAME; //部门名称
	private String DEPT_SIGN; //部门标识
	private String DEPT_LEADER_ID; //负责人ID
	private String DEPT_LEADER_NAME; //负责人姓名
	private String ENABLED; //是否有效
	private String DESCRIPTION; //备注
	private String PARENT_ID; //上级id
	private String CREATE_TIME; //创建时间
	private String CREATE_USER; //创建人
	private String LAST_UPDATE_TIME; //最后更新时间
	private String LAST_UPDATE_USER; //最后更新人
	private String IS_FUNCTIONAL_DEPT; //是否是预算部门
	private String IS_PREPARE_DEPT; //是否是编制部门
	private Role role; //角色对象
	private Page page; //分页对象
	private String SKIN;

	public Integer getID() {
		return ID;
	}
	public void setID(Integer iD) {
		ID = iD;
	}
	public String getDEPT_CODE() {
		return DEPT_CODE;
	}
	public void setDEPT_CODE(String dEPT_CODE) {
		DEPT_CODE = dEPT_CODE;
	}
	public String getDEPT_NAME() {
		return DEPT_NAME;
	}
	public void setDEPT_NAME(String dEPT_NAME) {
		DEPT_NAME = dEPT_NAME;
	}
	public String getDEPT_SIGN() {
		return DEPT_SIGN;
	}
	public void setDEPT_SIGN(String dEPT_SIGN) {
		DEPT_SIGN = dEPT_SIGN;
	}
	public String getDEPT_LEADER_ID() {
		return DEPT_LEADER_ID;
	}
	public void setDEPT_LEADER_ID(String dEPT_LEADER_ID) {
		DEPT_LEADER_ID = dEPT_LEADER_ID;
	}
	public String getDEPT_LEADER_NAME() {
		return DEPT_LEADER_NAME;
	}
	public void setDEPT_LEADER_NAME(String dEPT_LEADER_NAME) {
		DEPT_LEADER_NAME = dEPT_LEADER_NAME;
	}
	public String getENABLED() {
		return ENABLED;
	}
	public void setENABLED(String eNABLED) {
		ENABLED = eNABLED;
	}
	public String getDESCRIPTION() {
		return DESCRIPTION;
	}
	public void setDESCRIPTION(String dESCRIPTION) {
		DESCRIPTION = dESCRIPTION;
	}
	public String getPARENT_ID() {
		return PARENT_ID;
	}
	public void setPARENT_ID(String pARENT_ID) {
		PARENT_ID = pARENT_ID;
	}
	public String getCREATE_TIME() {
		return CREATE_TIME;
	}
	public void setCREATE_TIME(String cREATE_TIME) {
		CREATE_TIME = cREATE_TIME;
	}
	public String getCREATE_USER() {
		return CREATE_USER;
	}
	public void setCREATE_USER(String cREATE_USER) {
		CREATE_USER = cREATE_USER;
	}
	public String getLAST_UPDATE_TIME() {
		return LAST_UPDATE_TIME;
	}
	public void setLAST_UPDATE_TIME(String lAST_UPDATE_TIME) {
		LAST_UPDATE_TIME = lAST_UPDATE_TIME;
	}
	public String getLAST_UPDATE_USER() {
		return LAST_UPDATE_USER;
	}
	public void setLAST_UPDATE_USER(String lAST_UPDATE_USER) {
		LAST_UPDATE_USER = lAST_UPDATE_USER;
	}
	public String getIS_FUNCTIONAL_DEPT() {
		return IS_FUNCTIONAL_DEPT;
	}
	public void setIS_FUNCTIONAL_DEPT(String iS_FUNCTIONAL_DEPT) {
		IS_FUNCTIONAL_DEPT = iS_FUNCTIONAL_DEPT;
	}
	public String getIS_PREPARE_DEPT() {
		return IS_PREPARE_DEPT;
	}
	public void setIS_PREPARE_DEPT(String iS_PREPARE_DEPT) {
		IS_PREPARE_DEPT = iS_PREPARE_DEPT;
	}
	public Role getRole() {
		return role;
	}
	public void setRole(Role role) {
		this.role = role;
	}
	public Page getPage() {
		return page;
	}
	public void setPage(Page page) {
		this.page = page;
	}
	public String getSKIN() {
		return SKIN;
	}
	public void setSKIN(String sKIN) {
		SKIN = sKIN;
	} //皮肤
}
