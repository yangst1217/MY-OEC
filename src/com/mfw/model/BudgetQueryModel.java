package com.mfw.model;

import java.io.Serializable;

/**
 * 预算查询模型
 * @author Tang
 * @date 2015-12-1
 *
 */
public class BudgetQueryModel implements Serializable{

	private static final long serialVersionUID = 1L;
	
	private Integer budgetDeptId;//预算部门
	
	private Integer year;//年度
	
	private String month;//月度
	
	private Integer produceDeptId;//编制部门
	
	private String statu;//状态
	
	private String keyWord;//关键词

	private String budgetDeptName;//预算部门名称
	
	private String produceDeptName;//编制部门名称

	public Integer getBudgetDeptId() {
		return budgetDeptId;
	}

	public void setBudgetDeptId(Integer budgetDeptId) {
		this.budgetDeptId = budgetDeptId;
	}

	public Integer getYear() {
		return year;
	}

	public void setYear(Integer year) {
		this.year = year;
	}

	public Integer getProduceDeptId() {
		return produceDeptId;
	}

	public void setProduceDeptId(Integer produceDeptId) {
		this.produceDeptId = produceDeptId;
	}

	public String getStatu() {
		return statu;
	}

	public void setStatu(String statu) {
		this.statu = statu;
	}

	public String getKeyWord() {
		return keyWord;
	}

	public void setKeyWord(String keyWord) {
		this.keyWord = keyWord;
	}

	public String getMonth() {
		return month;
	}

	public void setMonth(String month) {
		this.month = month;
	}

	
	public String getBudgetDeptName() {
		return budgetDeptName;
	}

	public void setBudgetDeptName(String budgetDeptName) {
		this.budgetDeptName = budgetDeptName;
	}

	public String getProduceDeptName() {
		return produceDeptName;
	}

	public void setProduceDeptName(String produceDeptName) {
		this.produceDeptName = produceDeptName;
	}

	@Override
	public String toString() {
		return "BudgetQueryModel [budgetDeptId=" + budgetDeptId + ", year="
				+ year + ", produceDeptId=" + produceDeptId + ", statu="
				+ statu + ", keyWord=" + keyWord + "]";
	}
	
}
