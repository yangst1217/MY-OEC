package com.mfw.model;

import java.io.Serializable;

/**
 * 部门预算模板模型
 * @author Tang
 * @date 2015-11-26
 *
 */
public class BudgetModelResult implements Serializable{

	private static final long serialVersionUID = -8344265545401780854L;
	
	private Integer id;
	
	private Integer deptId;//部门ID
	
	private String deptName;//部门名称
	
	private String yearTime;//年度
	
	private String state;//状态
	
	private Integer forduceDeptId;//编制部门ID
	
	private Integer budgetDeptModelId;//预算部门权限

	public Integer getDeptId() {
		return deptId;
	}

	public void setDeptId(Integer deptId) {
		this.deptId = deptId;
	}

	public String getDeptName() {
		return deptName;
	}

	public void setDeptName(String deptName) {
		this.deptName = deptName;
	}

	public String getYearTime() {
		return yearTime;
	}

	public void setYearTime(String yearTime) {
		this.yearTime = yearTime;
	}

	public String getState() {
		return state;
	}

	public void setState(String state) {
		this.state = state;
	}

	public Integer getForduceDeptId() {
		return forduceDeptId;
	}

	public void setForduceDeptId(Integer forduceDeptId) {
		this.forduceDeptId = forduceDeptId;
	}

	public Integer getId() {
		return id;
	}

	public void setId(Integer id) {
		this.id = id;
	}

	public Integer getBudgetDeptModelId() {
		return budgetDeptModelId;
	}

	public void setBudgetDeptModelId(Integer budgetDeptModelId) {
		this.budgetDeptModelId = budgetDeptModelId;
	}
}
