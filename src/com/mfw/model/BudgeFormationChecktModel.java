package com.mfw.model;

import java.io.Serializable;
import java.util.Date;

/**
 * 月度预算审核
 * @author su
 * @date 2015-11-26
 *
 */
public class BudgeFormationChecktModel implements Serializable{

	private static final long serialVersionUID = -8344265545401780854L;
	
/*	主键	ID
	部门ID	DEPT_ID
	模板编号	MODEL_CODE
	年度	V_YEAR
	状态	V_STATUS
	提交人	SUB_USER
	提交时间	SUB_TIME
	最后审核人	LAST_CHECK_USER
	最后审核时间	LAST_CHECK_TIME
	创建人	CREATE_USER
	创建时间	CREATE_TIME
	修改人	LAST_UPDATE_USER
	修改时间	LASTUPDATE_TIME*/

	
	private Integer id;
	
	private Integer deptId;//部门ID
	
	private String modelCode;//模板编码
	
	private String year;//年度
	
	private String status;
	
	private String subUser;
	
	private Date subTime;
	
	private String checkUser;
	
	private Date checkTime;
	
	private String createUser;
	
	private Date createTime;
	
	private String updateUser;
	
	private Date updateTime;

	public Integer getId() {
		return id;
	}

	public void setId(Integer id) {
		this.id = id;
	}

	public Integer getDeptId() {
		return deptId;
	}

	public void setDeptId(Integer deptId) {
		this.deptId = deptId;
	}

	public String getModelCode() {
		return modelCode;
	}

	public void setModelCode(String modelCode) {
		this.modelCode = modelCode;
	}

	public String getYear() {
		return year;
	}

	public void setYear(String year) {
		this.year = year;
	}

	public String getStatus() {
		return status;
	}

	public void setStatus(String status) {
		this.status = status;
	}

	public String getSubUser() {
		return subUser;
	}

	public void setSubUser(String subUser) {
		this.subUser = subUser;
	}

	public Date getSubTime() {
		return subTime;
	}

	public void setSubTime(Date subTime) {
		this.subTime = subTime;
	}

	public String getCheckUser() {
		return checkUser;
	}

	public void setCheckUser(String checkUser) {
		this.checkUser = checkUser;
	}

	public Date getCheckTime() {
		return checkTime;
	}

	public void setCheckTime(Date checkTime) {
		this.checkTime = checkTime;
	}

	public String getCreateUser() {
		return createUser;
	}

	public void setCreateUser(String createUser) {
		this.createUser = createUser;
	}

	public Date getCreateTime() {
		return createTime;
	}

	public void setCreateTime(Date createTime) {
		this.createTime = createTime;
	}

	public String getUpdateUser() {
		return updateUser;
	}

	public void setUpdateUser(String updateUser) {
		this.updateUser = updateUser;
	}

	public Date getUpdateTime() {
		return updateTime;
	}

	public void setUpdateTime(Date updateTime) {
		this.updateTime = updateTime;
	}

	public static long getSerialversionuid() {
		return serialVersionUID;
	}
	
	
	


	
	
}
