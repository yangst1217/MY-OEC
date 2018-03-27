package com.mfw.entity.bdata;

import java.util.Date;

public class RatioModel {
    private Integer id;

    private String ratioId;

    private String ratioName;

    private String ratioNumber;

    private String status;

    private String enable;

    private String createUser;

    private Date createTime;

    private String lastUpdateUser;

    private Date lastUpdateTime;

    private String preparation1;

    private String preparation2;

    private String preparation3;

    private String preparation4;

    private String preparation5;

    private String preparation6;

    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public String getRatioId() {
        return ratioId;
    }

    public void setRatioId(String ratioId) {
        this.ratioId = ratioId == null ? null : ratioId.trim();
    }

    public String getRatioName() {
        return ratioName;
    }

    public void setRatioName(String ratioName) {
        this.ratioName = ratioName == null ? null : ratioName.trim();
    }

    public String getRatioNumber() {
        return ratioNumber;
    }

    public void setRatioNumber(String ratioNumber) {
        this.ratioNumber = ratioNumber == null ? null : ratioNumber.trim();
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status == null ? null : status.trim();
    }

    public String getEnable() {
        return enable;
    }

    public void setEnable(String enable) {
        this.enable = enable == null ? null : enable.trim();
    }

    public String getCreateUser() {
        return createUser;
    }

    public void setCreateUser(String createUser) {
        this.createUser = createUser == null ? null : createUser.trim();
    }

    public Date getCreateTime() {
        return createTime;
    }

    public void setCreateTime(Date createTime) {
        this.createTime = createTime;
    }

    public String getLastUpdateUser() {
        return lastUpdateUser;
    }

    public void setLastUpdateUser(String lastUpdateUser) {
        this.lastUpdateUser = lastUpdateUser == null ? null : lastUpdateUser.trim();
    }

    public Date getLastUpdateTime() {
        return lastUpdateTime;
    }

    public void setLastUpdateTime(Date lastUpdateTime) {
        this.lastUpdateTime = lastUpdateTime;
    }

    public String getPreparation1() {
        return preparation1;
    }

    public void setPreparation1(String preparation1) {
        this.preparation1 = preparation1 == null ? null : preparation1.trim();
    }

    public String getPreparation2() {
        return preparation2;
    }

    public void setPreparation2(String preparation2) {
        this.preparation2 = preparation2 == null ? null : preparation2.trim();
    }

    public String getPreparation3() {
        return preparation3;
    }

    public void setPreparation3(String preparation3) {
        this.preparation3 = preparation3 == null ? null : preparation3.trim();
    }

    public String getPreparation4() {
        return preparation4;
    }

    public void setPreparation4(String preparation4) {
        this.preparation4 = preparation4 == null ? null : preparation4.trim();
    }

    public String getPreparation5() {
        return preparation5;
    }

    public void setPreparation5(String preparation5) {
        this.preparation5 = preparation5 == null ? null : preparation5.trim();
    }

    public String getPreparation6() {
        return preparation6;
    }

    public void setPreparation6(String preparation6) {
        this.preparation6 = preparation6 == null ? null : preparation6.trim();
    }
}