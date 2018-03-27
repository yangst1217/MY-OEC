package com.mfw.entity.system;

import java.io.Serializable;

/**
 * Created by yangdw on 2015/12/7.
 */
public class Parameter implements Serializable {

    private static final long serialVersionUID = -8429655476280137807L;

    private String ID; //自增主键
    private String SYSTEM_KEY; //参数标识
    private String SYSTEM_ORDER; //参数序列（第几个参数）
    private String YEARNO; //有效时间（年）
    private String MONTHNO; //有效时间（月）
    private String DAYNO; //有效时间（日）参数值
    private String SYSTEM_VALUE; //
    private String LAST_UPDATE_USER; //最后更新人
    private String LAST_UPDATE_TIME; //最后更新时间
    private String DEFINE1; //自定义字段1（内/外销）
    private String DEFINE2; //自定义字段2（预算/实际）
    private String DEFINE3; //自定义字段3
    private String DEFINE4; //自定义字段4
    private String DEFINE5; //自定义字段5

    public static long getSerialVersionUID() {
        return serialVersionUID;
    }

    public String getID() {
        return ID;
    }

    public void setID(String ID) {
        this.ID = ID;
    }

    public String getSYSTEM_KEY() {
        return SYSTEM_KEY;
    }

    public void setSYSTEM_KEY(String SYSTEM_KEY) {
        this.SYSTEM_KEY = SYSTEM_KEY;
    }

    public String getSYSTEM_ORDER() {
        return SYSTEM_ORDER;
    }

    public void setSYSTEM_ORDER(String SYSTEM_ORDER) {
        this.SYSTEM_ORDER = SYSTEM_ORDER;
    }

    public String getYEARNO() {
        return YEARNO;
    }

    public void setYEARNO(String YEARNO) {
        this.YEARNO = YEARNO;
    }

    public String getMONTHNO() {
        return MONTHNO;
    }

    public void setMONTHNO(String MONTHNO) {
        this.MONTHNO = MONTHNO;
    }

    public String getDAYNO() {
        return DAYNO;
    }

    public void setDAYNO(String DAYNO) {
        this.DAYNO = DAYNO;
    }

    public String getSYSTEM_VALUE() {
        return SYSTEM_VALUE;
    }

    public void setSYSTEM_VALUE(String SYSTEM_VALUE) {
        this.SYSTEM_VALUE = SYSTEM_VALUE;
    }

    public String getLAST_UPDATE_USER() {
        return LAST_UPDATE_USER;
    }

    public void setLAST_UPDATE_USER(String LAST_UPDATE_USER) {
        this.LAST_UPDATE_USER = LAST_UPDATE_USER;
    }

    public String getLAST_UPDATE_TIME() {
        return LAST_UPDATE_TIME;
    }

    public void setLAST_UPDATE_TIME(String LAST_UPDATE_TIME) {
        this.LAST_UPDATE_TIME = LAST_UPDATE_TIME;
    }

    public String getDEFINE1() {
        return DEFINE1;
    }

    public void setDEFINE1(String DEFINE1) {
        this.DEFINE1 = DEFINE1;
    }

    public String getDEFINE2() {
        return DEFINE2;
    }

    public void setDEFINE2(String DEFINE2) {
        this.DEFINE2 = DEFINE2;
    }

    public String getDEFINE3() {
        return DEFINE3;
    }

    public void setDEFINE3(String DEFINE3) {
        this.DEFINE3 = DEFINE3;
    }

    public String getDEFINE4() {
        return DEFINE4;
    }

    public void setDEFINE4(String DEFINE4) {
        this.DEFINE4 = DEFINE4;
    }

    public String getDEFINE5() {
        return DEFINE5;
    }

    public void setDEFINE5(String DEFINE5) {
        this.DEFINE5 = DEFINE5;
    }
}
