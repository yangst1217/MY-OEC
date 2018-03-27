package com.mfw.controller.system.parameter;

import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.apache.shiro.SecurityUtils;
import org.apache.shiro.session.Session;
import org.apache.shiro.subject.Subject;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import com.mfw.controller.base.BaseController;
import com.mfw.entity.reportcenter.ReportParameter;
import com.mfw.entity.system.Parameter;
import com.mfw.service.system.parameter.ParameterService;
import com.mfw.util.AppUtil;
import com.mfw.util.Const;
import com.mfw.util.PageData;

/**
 * Created by yangdw on 2015/12/7.
 */

@Controller
@RequestMapping(value = "/parameter")
public class ParameterController extends BaseController {

    private static SimpleDateFormat YEARSMF = new SimpleDateFormat("yyyy");
    private static SimpleDateFormat MONTHSMF = new SimpleDateFormat("MM");
    private static SimpleDateFormat DAYSMF = new SimpleDateFormat("dd");

    @Resource(name = "parameterService")
    private ParameterService parameterService;


    @RequestMapping(value = "/form")
    public ModelAndView form() throws Exception{
        ModelAndView mv = this.getModelAndView();
        try {
            List<ReportParameter> reportList = parameterService.listAllReport();
            mv.addObject("reportList", reportList);
            if(reportList != null){
                if(reportList.size() > 0){
                    List<ReportParameter> firstParameterList = parameterService.getParameterByReportCode(reportList.get(0).getREPORT_CODE());
                    mv.addObject("firstParameterList", firstParameterList);
                }
            }
            mv.setViewName("system/parameter/form");
        } catch (Exception e) {
            logger.error(e.toString(), e);
        }
        return mv;
    }


    @RequestMapping(value = "/getReportParameter")
    @ResponseBody
    public Object addOredit(
            @RequestParam(value = "reportCode", required = false) String reportCode
    ) throws Exception {
        Map<String, Object> map = new HashMap<String, Object>();
        PageData pd = new PageData();
        List<ReportParameter> parameterList = parameterService.getParameterByReportCode(reportCode);
        map.put("parameterList",parameterList);
        return AppUtil.returnObject(pd,map);
    }

    /**
     * 保存系统参数
     * @param
     * @return
     */
    @RequestMapping(value = "/addOredit")
    @ResponseBody
    public Object addOredit() throws Exception {
        Map<String, Object> map = new HashMap<String, Object>();
        PageData pd = new PageData();
        try {
            pd = this.getPageData();

            //获得前台参数
            String systemKey = pd.getString("systemKey");
            String systemOrder = pd.getString("systemOrder");
            String startDate = pd.getString("startDate");
            String endDate = pd.getString("endDate");
            String systemValue = pd.getString("systemValue");
            String define1 = pd.getString("define1");
            String define2 = pd.getString("define2");
            String define3 = pd.getString("define3");
            String define4 = pd.getString("define4");
            String define5 = pd.getString("define5");

            //判断时间字符串是否符合规范
            if((startDate.length() == endDate.length()) && (startDate.length() == 4
                    || startDate.length() == 6 || startDate.length() == 8)){
                //到年判断
                if(startDate.length() == 4){
                    if(Integer.valueOf(startDate.substring(0,4)) > Integer.valueOf(endDate.substring(0,4))){
                        map.put("msg", String.valueOf("提交失败，重试后仍不成功，请联系系统工程师！"));
                        return AppUtil.returnObject(pd,map);
                    }
                }
                //到月判断
                else if(startDate.length() == 6){
                    Calendar startcal = Calendar.getInstance();
                    startcal.set(Integer.valueOf(startDate.substring(0,4)),Integer.valueOf(startDate.substring(4,6))-1,1);
                    Calendar endcal = Calendar.getInstance();
                    endcal.set(Integer.valueOf(endDate.substring(0,4)),Integer.valueOf(endDate.substring(4,6))-1,1);
                    if((endcal).before(startcal)){
                        map.put("msg", String.valueOf("提交失败，重试后仍不成功，请联系系统工程师！"));
                        return AppUtil.returnObject(pd,map);
                    }
                }
                //到日判断
                else {
                    Calendar startcal = Calendar.getInstance();
                    startcal.set(Integer.valueOf(startDate.substring(0,4)),Integer.valueOf(startDate.substring(4,6))-1,Integer.valueOf(startDate.substring(6,8)));
                    Calendar endcal = Calendar.getInstance();
                    endcal.set(Integer.valueOf(endDate.substring(0,4)),Integer.valueOf(endDate.substring(4,6))-1,Integer.valueOf(endDate.substring(6,8)));
                    if((endcal).before(startcal)){
                        map.put("msg", String.valueOf("提交失败，重试后仍不成功，请联系系统工程师！"));
                        return AppUtil.returnObject(pd,map);
                    }
                }

                //参数到年
                if(startDate.length() == 4){
                    for(int i = Integer.valueOf(startDate); i <= Integer.valueOf(endDate);i ++){
                        PageData parameterpd = new PageData();
                        parameterpd.put("SYSTEM_KEY", systemKey);
                        parameterpd.put("SYSTEM_ORDER", systemOrder);
                        parameterpd.put("DEFINE1", define1);
                        parameterpd.put("DEFINE2", define2);
                        parameterpd.put("DEFINE3", define3);
                        parameterpd.put("DEFINE4", define4);
                        parameterpd.put("DEFINE5", define5);
                        parameterpd.put("DATE", String.valueOf(i));
                        if(parameterService.getParameterByKeyAndOrderAndDate(parameterpd) != null){
                            PageData mypd = parameterService.getParameterByKeyAndOrderAndDate(parameterpd);
                            Parameter myparameter = new Parameter();
                            myPd2myParameter(mypd,myparameter);
                            myparameter.setSYSTEM_VALUE(systemValue);
                            parameterService.updateParameter(myparameter);
                        }else {
                            SimpleDateFormat smf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
                            Parameter myparameter = new Parameter();
                            Subject currentUser = SecurityUtils.getSubject();
                            Session session = currentUser.getSession();
                            myparameter.setSYSTEM_KEY(systemKey);
                            myparameter.setSYSTEM_ORDER(systemOrder);
                            myparameter.setDEFINE1(define1);
                            myparameter.setDEFINE2(define2);
                            myparameter.setDEFINE3(define3);
                            myparameter.setDEFINE4(define4);
                            myparameter.setDEFINE5(define5);
                            myparameter.setYEARNO(String.valueOf(i));
                            myparameter.setSYSTEM_VALUE(systemValue);
                            myparameter.setLAST_UPDATE_USER(session.getAttribute(Const.SESSION_USERNAME).toString());
                            myparameter.setLAST_UPDATE_TIME(smf.format(new Date()));
                            parameterService.insertParameter(myparameter);
                        }
                    }
                }

                //参数到月
                if(startDate.length() == 6){
                    Calendar startcal = Calendar.getInstance();
                    startcal.set(Integer.valueOf(startDate.substring(0,4)),Integer.valueOf(startDate.substring(4,6))-1,1);
                    Calendar endcal = Calendar.getInstance();
                    endcal.set(Integer.valueOf(endDate.substring(0,4)),Integer.valueOf(endDate.substring(4,6))-1,1);
                    while (!endcal.before(startcal)){
                        SimpleDateFormat mf = new SimpleDateFormat("yyyyMM");
                        PageData parameterpd = new PageData();
                        parameterpd.put("SYSTEM_KEY", systemKey);
                        parameterpd.put("SYSTEM_ORDER", systemOrder);
                        parameterpd.put("DEFINE1", define1);
                        parameterpd.put("DEFINE2", define2);
                        parameterpd.put("DEFINE3", define3);
                        parameterpd.put("DEFINE4", define4);
                        parameterpd.put("DEFINE5", define5);
                        parameterpd.put("DATE", mf.format(startcal.getTime()));
                        if(parameterService.getParameterByKeyAndOrderAndDate(parameterpd) != null){
                            PageData mypd = parameterService.getParameterByKeyAndOrderAndDate(parameterpd);
                            Parameter myparameter = new Parameter();
                            myPd2myParameter(mypd,myparameter);
                            myparameter.setSYSTEM_VALUE(systemValue);
                            parameterService.updateParameter(myparameter);
                        }else {
                            SimpleDateFormat smf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
                            Parameter myparameter = new Parameter();
                            Subject currentUser = SecurityUtils.getSubject();
                            Session session = currentUser.getSession();
                            myparameter.setSYSTEM_KEY(systemKey);
                            myparameter.setSYSTEM_ORDER(systemOrder);
                            myparameter.setDEFINE1(define1);
                            myparameter.setDEFINE2(define2);
                            myparameter.setDEFINE3(define5);
                            myparameter.setDEFINE4(define4);
                            myparameter.setDEFINE5(define3);
                            myparameter.setYEARNO(YEARSMF.format(startcal.getTime()));
                            myparameter.setMONTHNO(MONTHSMF.format(startcal.getTime()));
                            myparameter.setSYSTEM_VALUE(systemValue);
                            myparameter.setLAST_UPDATE_USER(session.getAttribute(Const.SESSION_USERNAME).toString());
                            myparameter.setLAST_UPDATE_TIME(smf.format(new Date()));
                            parameterService.insertParameter(myparameter);
                        }
                        startcal.add(Calendar.MONTH,1);
                    }
                }

                //参数到日
                if(startDate.length() == 8){
                    Calendar startcal = Calendar.getInstance();
                    startcal.set(Integer.valueOf(startDate.substring(0,4)),Integer.valueOf(startDate.substring(4,6))-1,Integer.valueOf(startDate.substring(6,8)));
                    Calendar endcal = Calendar.getInstance();
                    endcal.set(Integer.valueOf(endDate.substring(0,4)),Integer.valueOf(endDate.substring(4,6))-1,Integer.valueOf(endDate.substring(6,8)));
                    while (!endcal.before(startcal)){
                        SimpleDateFormat mf = new SimpleDateFormat("yyyyMMdd");
                        PageData parameterpd = new PageData();
                        parameterpd.put("SYSTEM_KEY", systemKey);
                        parameterpd.put("SYSTEM_ORDER", systemOrder);
                        parameterpd.put("DEFINE1", define1);
                        parameterpd.put("DEFINE2", define2);
                        parameterpd.put("DEFINE5", define3);
                        parameterpd.put("DEFINE4", define4);
                        parameterpd.put("DEFINE3", define5);
                        parameterpd.put("DATE", mf.format(startcal.getTime()));
                        if(parameterService.getParameterByKeyAndOrderAndDate(parameterpd) != null){
                            PageData mypd = parameterService.getParameterByKeyAndOrderAndDate(parameterpd);
                            Parameter myparameter = new Parameter();
                            myPd2myParameter(mypd,myparameter);
                            myparameter.setSYSTEM_VALUE(systemValue);
                            parameterService.updateParameter(myparameter);
                        }else {
                            SimpleDateFormat smf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
                            Parameter myparameter = new Parameter();
                            Subject currentUser = SecurityUtils.getSubject();
                            Session session = currentUser.getSession();
                            myparameter.setSYSTEM_KEY(systemKey);
                            myparameter.setSYSTEM_ORDER(systemOrder);
                            myparameter.setDEFINE1(define1);
                            myparameter.setDEFINE2(define2);
                            myparameter.setDEFINE3(define3);
                            myparameter.setDEFINE4(define4);
                            myparameter.setDEFINE5(define5);
                            myparameter.setYEARNO(YEARSMF.format(startcal.getTime()));
                            myparameter.setMONTHNO(MONTHSMF.format(startcal.getTime()));
                            myparameter.setDAYNO(DAYSMF.format(startcal.getTime()));
                            myparameter.setSYSTEM_VALUE(systemValue);
                            myparameter.setLAST_UPDATE_USER(session.getAttribute(Const.SESSION_USERNAME).toString());
                            myparameter.setLAST_UPDATE_TIME(smf.format(new Date()));
                            parameterService.insertParameter(myparameter);
                        }
                        startcal.add(Calendar.DAY_OF_MONTH,1);
                    }
                }
            }
        }catch (Exception e) {
            logger.error(e.toString(), e);
            map.put("msg", String.valueOf("提交失败，重试后仍不成功，请联系系统工程师！"));
            return AppUtil.returnObject(pd,map);
        }
        map.put("msg", String.valueOf("提交成功！"));
        return AppUtil.returnObject(pd,map);
    }



    /**
     * pd到parameter
     * @param mypd,myparameter
     */
    private void myPd2myParameter(PageData mypd,Parameter myparameter){
        SimpleDateFormat smf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        Subject currentUser = SecurityUtils.getSubject();
        Session session = currentUser.getSession();
        if(mypd.get("ID") != null){
            myparameter.setID(mypd.get("ID").toString());
        }
        if(mypd.get("SYSTEM_KEY") != null){
            myparameter.setSYSTEM_KEY(mypd.get("SYSTEM_KEY").toString());
        }
        if(mypd.get("SYSTEM_ORDER") != null){
            myparameter.setSYSTEM_ORDER(mypd.get("SYSTEM_ORDER").toString());
        }
        if(mypd.get("YEARNO") != null){
            myparameter.setYEARNO(mypd.get("YEARNO").toString());
        }
        if(mypd.get("MONTHNO") != null){
            myparameter.setMONTHNO(mypd.get("MONTHNO").toString());
        }
        if(mypd.get("DAYNO") != null){
            myparameter.setDAYNO(mypd.get("DAYNO").toString());
        }
        if(mypd.get("DEFINE1") != null){
            myparameter.setDEFINE1(mypd.get("DEFINE1").toString());
        }
        if(mypd.get("DEFINE2") != null){
            myparameter.setDEFINE2(mypd.get("DEFINE2").toString());
        }
        if(mypd.get("DEFINE3") != null){
            myparameter.setDEFINE3(mypd.get("DEFINE3").toString());
        }
        if(mypd.get("DEFINE4") != null){
            myparameter.setDEFINE4(mypd.get("DEFINE4").toString());
        }
        if(mypd.get("DEFINE5") != null){
            myparameter.setDEFINE5(mypd.get("DEFINE5").toString());
        }
        myparameter.setLAST_UPDATE_USER(session.getAttribute(Const.SESSION_USERNAME).toString());
        myparameter.setLAST_UPDATE_TIME(smf.format(new Date()));
    }
}
