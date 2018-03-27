package com.mfw.service.system.parameter;

import com.mfw.dao.DaoSupport;
import com.mfw.entity.reportcenter.ReportParameter;
import com.mfw.entity.system.Parameter;
import com.mfw.service.system.buttons.ButtonsService;
import com.mfw.util.PageData;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.util.List;

/**
 * Created by yangdw on 2015/12/7.
 */
@Service("parameterService")
public class ParameterService {


    @Resource(name = "daoSupport")
    private DaoSupport dao;

    /**
     * 通过key,order,date获得参数
     * @param pd
     */
    public PageData getParameterByKeyAndOrderAndDate(PageData pd) throws Exception {
        return (PageData) dao.findForObject("ParameterMapper.getParameterByKeyAndOrderAndDate", pd);
    }

    /**
     * 更新系统参数
     * @param myparameter
     */
    public void updateParameter(Parameter myparameter) throws Exception {
        dao.update("ParameterMapper.updateParameter", myparameter);
    }

    /**
     * 新增系统参数
     * @param myparameter
     */
    public void insertParameter(Parameter myparameter) throws Exception {
        dao.save("ParameterMapper.insertParameter", myparameter);
    }

    public List<ReportParameter> listAllReport() throws Exception {
        return (List<ReportParameter>) dao.findForList("ParameterMapper.listAllReport", null);
    }

    public List<ReportParameter> getParameterByReportCode(String REPORT_CODE) throws Exception {
        return (List<ReportParameter>) dao.findForList("ParameterMapper.getParameterByReportCode", REPORT_CODE);
    }
}
