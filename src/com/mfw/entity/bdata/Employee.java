/**
 * 
 */
package com.mfw.entity.bdata;

/**
 * bd_employee表
 * 创建日期：2015年12月11日 
 * TODO
 */
public class Employee {
	private int ID;				//员工ID	
	private String EMP_CODE;	//员工编码
	private String EMP_NAME;	//员工名称
	private String EMP_GENDER;	//员工性别 1-男 2-女
	private int EMP_DEPARTMENT_ID;	//员工部门ID
	private String EMP_DEPARTMENT_NAME;	//员工部门名称
	private String EMP_EMAIL;	//员工邮箱
	private String EMP_PHONE;	//员工联系电话
	private int EMP_GRADE_ID;	//员工级别(岗位)ID
	private String EMP_GRADE_NAME;	//级别(岗位)名称
	private int ATTACH_KPI_MODEL;	//KPI模型ID
	private String EMP_REMARK;	//备注
	private String ENABLED;	//是否有效
	private String CREATE_TIME;	//创建时间
	private String CREATE_USER;	//创建人
	private String LAST_UPDATE_TIME;	//最后更新时间
	private String LAST_UPDATE_USER;	//最后更新人
	
	public int getID() {
		return ID;
	}
	public void setID(int iD) {
		ID = iD;
	}
	public String getEMP_CODE() {
		return EMP_CODE;
	}
	public void setEMP_CODE(String eMP_CODE) {
		EMP_CODE = eMP_CODE;
	}
	public String getEMP_NAME() {
		return EMP_NAME;
	}
	public void setEMP_NAME(String eMP_NAME) {
		EMP_NAME = eMP_NAME;
	}
	public String getEMP_GENDER() {
		return EMP_GENDER;
	}
	public void setEMP_GENDER(String eMP_GENDER) {
		EMP_GENDER = eMP_GENDER;
	}
	public int getEMP_DEPARTMENT_ID() {
		return EMP_DEPARTMENT_ID;
	}
	public void setEMP_DEPARTMENT_ID(int eMP_DEPARTMENT_ID) {
		EMP_DEPARTMENT_ID = eMP_DEPARTMENT_ID;
	}
	public String getEMP_DEPARTMENT_NAME() {
		return EMP_DEPARTMENT_NAME;
	}
	public void setEMP_DEPARTMENT_NAME(String eMP_DEPARTMENT_NAME) {
		EMP_DEPARTMENT_NAME = eMP_DEPARTMENT_NAME;
	}
	public String getEMP_EMAIL() {
		return EMP_EMAIL;
	}
	public void setEMP_EMAIL(String eMP_EMAIL) {
		EMP_EMAIL = eMP_EMAIL;
	}
	public String getEMP_PHONE() {
		return EMP_PHONE;
	}
	public void setEMP_PHONE(String eMP_PHONE) {
		EMP_PHONE = eMP_PHONE;
	}
	public int getEMP_GRADE_ID() {
		return EMP_GRADE_ID;
	}
	public void setEMP_GRADE_ID(int eMP_GRADE_ID) {
		EMP_GRADE_ID = eMP_GRADE_ID;
	}
	public String getEMP_GRADE_NAME() {
		return EMP_GRADE_NAME;
	}
	public void setEMP_GRADE_NAME(String eMP_GRADE_NAME) {
		EMP_GRADE_NAME = eMP_GRADE_NAME;
	}
	public int getATTACH_KPI_MODEL() {
		return ATTACH_KPI_MODEL;
	}
	public void setATTACH_KPI_MODEL(int aTTACH_KPI_MODEL) {
		ATTACH_KPI_MODEL = aTTACH_KPI_MODEL;
	}
	public String getEMP_REMARK() {
		return EMP_REMARK;
	}
	public void setEMP_REMARK(String eMP_REMARK) {
		EMP_REMARK = eMP_REMARK;
	}
	public String getENABLED() {
		return ENABLED;
	}
	public void setENABLED(String eNABLED) {
		ENABLED = eNABLED;
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
	
}
