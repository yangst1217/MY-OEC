/**
 * 
 */
package com.mfw.entity.bdata;

/**
 * bd_kpi_category_files表
 * 创建日期：2015年12月16日
 * 修改日期：
 * TODO
 */
public class KpiCategoryFiles {
	
	private int ID;		//科目类别ID
	private String CODE;	//科目类别编码
	private String NAME;	//科目类别名称
	private String REMARKS;	//科目类别描述
	
	public int getID() {
		return ID;
	}
	public void setID(int iD) {
		ID = iD;
	}
	public String getCODE() {
		return CODE;
	}
	public void setCODE(String cODE) {
		CODE = cODE;
	}
	public String getNAME() {
		return NAME;
	}
	public void setNAME(String nAME) {
		NAME = nAME;
	}
	public String getREMARKS() {
		return REMARKS;
	}
	public void setREMARKS(String rEMARKS) {
		REMARKS = rEMARKS;
	}
	
}
