/**
 * 
 */
package com.mfw.entity.bdata;

/**
 * bd_kpi_files表
 * 创建日期：2015年12月17日
 * 修改日期：
 * TODO
 */
public class Unit {
	private int ID;				//主键ID
	private String UNIT_CODE;		//编码
	private String UNIT_NAME;	//名称	
	private String ISDEL;			//是否删除
	private String DESCP;	//指标描述
	private String CREATE_TIME;		//创建时间
	private String CREATE_USER;		//创建人
	private String UPDATE_TIME;//最后更新时间
	private String UPDATE_USER;//最后更新人

	
	
	public int getID() {
		return ID;
	}
	public void setID(int iD) {
		ID = iD;
	}
	public String getUNIT_CODE() {
		return UNIT_CODE;
	}
	public void setUNIT_CODE(String uNIT_CODE) {
		UNIT_CODE = uNIT_CODE;
	}
	public String getUNIT_NAME() {
		return UNIT_NAME;
	}
	public void setUNIT_NAME(String uNIT_NAME) {
		UNIT_NAME = uNIT_NAME;
	}
	public String getISDEL() {
		return ISDEL;
	}
	public void setISDEL(String iSDEL) {
		ISDEL = iSDEL;
	}	
	public String getDESCPL() {
		return DESCP;
	}
	public void setDESCP(String dESCP) {
		DESCP = dESCP;
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
	public String getUPDATE_TIME() {
		return UPDATE_TIME;
	}
	public void setUPDATE_TIME(String uPDATE_TIME) {
		UPDATE_TIME = uPDATE_TIME;
	}
	public String getUPDATE_USER() {
		return UPDATE_USER;
	}
	public void setLAST_UPDATE_USER(String uPDATE_USER) {
		UPDATE_USER = uPDATE_USER;
	}
	
}
