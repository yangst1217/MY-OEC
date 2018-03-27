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
public class KpiFiles {
	private int ID;				//主键ID
	private String KPI_CODE;		//KPI编码
	private String KPI_NAME;	//KPI名称
	private int KPI_CATEGORY_ID;	//KPI类型
	private String KPI_CATEGORY_NAME;	//KPI类型名称
	
	private String KPI_SQL;			//KPI计算逻辑(sql)
	private String KPI_DESCRIPTION;	//指标描述
	private String KPI_UNIT;		//KPI单位
	private int PARENT_ID;			//父科目ID，无父科目则为0
	private String REMARKS;			//备注信息
	private String ENABLED;			//是否有效
	private String CREATE_TIME;		//创建时间
	private String CREATE_USER;		//创建人
	private String LAST_UPDATE_TIME;//最后更新时间
	private String LAST_UPDATE_USER;//最后更新人
	private String RELATION_ID;		//父子节点关系(a-b-c-d)
	private int SUBJECT_ATTR;		//科目属性：0-收；1-支
	private int IS_RECOMMEND;		//预算是否引用：0-不引用；1-引用
	private String UNIT_PRECI_CODE;
	private String DOCUMENT;		//指标文档
	private int DOCUMENT_ID;		//附件ID
	
	
	public int getID() {
		return ID;
	}
	public void setID(int iD) {
		ID = iD;
	}
	public String getKPI_CODE() {
		return KPI_CODE;
	}
	public void setKPI_CODE(String kPI_CODE) {
		KPI_CODE = kPI_CODE;
	}
	public String getKPI_DESCRIPTION() {
		return KPI_DESCRIPTION;
	}
	public void setKPI_DESCRIPTION(String kPI_DESCRIPTION) {
		KPI_DESCRIPTION = kPI_DESCRIPTION;
	}
	public String getKPI_NAME() {
		return KPI_NAME;
	}
	public void setKPI_NAME(String kPI_NAME) {
		KPI_NAME = kPI_NAME;
	}
	public int getKPI_CATEGORY_ID() {
		return KPI_CATEGORY_ID;
	}
	public void setKPI_CATEGORY_ID(int kPI_CATEGORY_ID) {
		KPI_CATEGORY_ID = kPI_CATEGORY_ID;
	}
	public String getKPI_CATEGORY_NAME() {
		return KPI_CATEGORY_NAME;
	}
	public void setKPI_CATEGORY_NAME(String kPI_CATEGORY_NAME) {
		KPI_CATEGORY_NAME = kPI_CATEGORY_NAME;
	}
	public String getKPI_SQL() {
		return KPI_SQL;
	}
	public void setKPI_SQL(String kPI_SQL) {
		KPI_SQL = kPI_SQL;
	}
	public String getKPI_UNIT() {
		return KPI_UNIT;
	}
	public void setKPI_UNIT(String kPI_UNIT) {
		KPI_UNIT = kPI_UNIT;
	}
	public int getPARENT_ID() {
		return PARENT_ID;
	}
	public void setPARENT_ID(int pARENT_ID) {
		PARENT_ID = pARENT_ID;
	}
	public String getREMARKS() {
		return REMARKS;
	}
	public void setREMARKS(String rEMARKS) {
		REMARKS = rEMARKS;
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
	public String getRELATION_ID() {
		return RELATION_ID;
	}
	public void setRELATION_ID(String rELATION_ID) {
		RELATION_ID = rELATION_ID;
	}
	public int getSUBJECT_ATTR() {
		return SUBJECT_ATTR;
	}
	public void setSUBJECT_ATTR(int sUBJECT_ATTR) {
		SUBJECT_ATTR = sUBJECT_ATTR;
	}
	public int getIS_RECOMMEND() {
		return IS_RECOMMEND;
	}
	public void setIS_RECOMMEND(int iS_RECOMMEND) {
		IS_RECOMMEND = iS_RECOMMEND;
	}
	public String getUNIT_PRECI_CODE() {
		return UNIT_PRECI_CODE;
	}
	public void setUNIT_PRECI_CODE(String uNIT_PRECI_CODE) {
		UNIT_PRECI_CODE = uNIT_PRECI_CODE;
	}
	public String getDOCUMENT() {
		return DOCUMENT;
	}
	public void setDOCUMENT(String dOCUMENT) {
		DOCUMENT = dOCUMENT;
	}
	public int getDOCUMENT_ID() {
		return DOCUMENT_ID;
	}
	public void setDOCUMENT_ID(int dOCUMENT_ID) {
		DOCUMENT_ID = dOCUMENT_ID;
	}
	
}
