package com.mfw.enums;

import java.util.HashMap;
import java.util.Map;

/**
 * 状态枚举
 * @author Tang
 * @date 2015-12-10
 *
 */
public enum StatusEnum {
	ZERO("0","所有状态"),
	DRAFTS("1","草稿"),
	SUBMIT("2","提交"),
	PASS("3","审核通过"),
	REBUT("4","审核驳回"),
	CLSUBMIT("5","取消提交");
	 private static Map<String,StatusEnum> CACHE =new HashMap<String,StatusEnum>(){
			
			private static final long serialVersionUID = 7891690619201405457L;
			{
			  for(StatusEnum enu : StatusEnum.values()){
				  put(enu.getStatus(), enu);
			  }
		   }
	 };
	private String status;
	private String description;
	private StatusEnum(String status, String description) {
		this.status = status;
		this.description = description;
	}
	public String getStatus() {
		return status;
	}
	public String getDescription() {
		return description;
	}
	public static StatusEnum toEnum(String status){
		return CACHE.get(status);
	}
}
