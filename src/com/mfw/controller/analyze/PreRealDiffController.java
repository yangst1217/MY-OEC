package com.mfw.controller.analyze;

import com.mfw.controller.base.BaseController;
import com.mfw.entity.system.User;
import com.mfw.service.analyze.PreRealDiffService;
import com.mfw.service.btarget.BYearTargetService;
import com.mfw.util.AppUtil;
import com.mfw.util.PageData;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import sun.nio.cs.US_ASCII;

import javax.annotation.Resource;
import java.math.BigDecimal;
import java.util.Calendar;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * 预实差报表Controller
 * Created by yangdw on 2016/5/25.
 */
@Controller
@RequestMapping(value="/preRealDiff")
public class PreRealDiffController  extends BaseController {

    @Resource(name = "preRealDiffService")
    private PreRealDiffService preRealDiffService;

    @Resource(name="bYearTargetService")
    private BYearTargetService bYearTargetService;

    /**
     * 经营目标预实显差表（预实分析）
     * @return mv
     * @throws Exception
     * author yangdw
     */
    @RequestMapping(value = "/pre_implementation")
    public ModelAndView preImplementation() throws Exception{
        logBefore(logger, "经营目标预实显差表（预实分析）");

        ModelAndView mv = this.getModelAndView();
        PageData pd = this.getPageData();

        if(null != pd.get("B_YEAR_TARGET_CODE") && !"".equals(pd.get("B_YEAR_TARGET_CODE"))){
            //通过Code获取年度经营目标
            PageData bYearTarget = bYearTargetService.getTargetByCode(pd.get("B_YEAR_TARGET_CODE").toString());
            mv.addObject("bYearTarget",bYearTarget);

            //获取年月列表
            List<PageData> yearMonthList = preRealDiffService.getYearMonth(pd);
            mv.addObject("yearMonthList",yearMonthList);
            //获取部门列表
            List<PageData> deptList = preRealDiffService.getDeptList(pd);
            BigDecimal PRE_SUM = new BigDecimal(0);
            BigDecimal REAL_SUM = new BigDecimal(0);
            BigDecimal DIFF_SUM = new BigDecimal(0);
            for(int i = 0;i < deptList.size();i ++){
                PageData searchPd = new PageData();
                searchPd.put("B_YEAR_TARGET_CODE",pd.get("B_YEAR_TARGET_CODE"));
                searchPd.put("DEPT_CODE",deptList.get(i).get("DEPT_CODE"));
                //获取预实差
                List<PageData> preImplementationList = preRealDiffService.getPreImplementationList(searchPd);
                deptList.get(i).put("preImplementationList",preImplementationList);

                PRE_SUM = BigDecimal.valueOf(Double.valueOf(deptList.get(i).get("PRE_SUM").toString())).add(PRE_SUM);
                REAL_SUM = BigDecimal.valueOf(Double.valueOf(deptList.get(i).get("REAL_SUM").toString())).add(REAL_SUM);
                DIFF_SUM = BigDecimal.valueOf(Double.valueOf(deptList.get(i).get("DIFF_SUM").toString())).add(DIFF_SUM);
            }
            mv.addObject("PRE_SUM",PRE_SUM);
            mv.addObject("REAL_SUM",REAL_SUM);
            mv.addObject("DIFF_SUM",DIFF_SUM);
            mv.addObject("deptList",deptList);
            //获取可供选择的目标列表
            List<PageData> targetList = preRealDiffService.getTargetList(pd);
            mv.addObject("targetList",targetList);
        }else{
        	PageData queryPd = new PageData();
        	Calendar c = Calendar.getInstance();
        	String year = String.valueOf(c.get(Calendar.YEAR));
        	queryPd.put("YEAR", year);
        	List<PageData> tarList = this.preRealDiffService.getTargetList(queryPd);
        	if(tarList != null && tarList.size()>0){
        		PageData target = (PageData)tarList.get(0);
        		String code = target.getString("CODE");
        		target.put("B_YEAR_TARGET_CODE",code);
        		target.put("YEAR",year);
                //通过Code获取年度经营目标
                PageData bYearTarget = bYearTargetService.getTargetByCode(target.get("B_YEAR_TARGET_CODE").toString());
                mv.addObject("bYearTarget",bYearTarget);

                //获取年月列表
                List<PageData> yearMonthList = preRealDiffService.getYearMonth(target);
                mv.addObject("yearMonthList",yearMonthList);
                //获取部门列表
                List<PageData> deptList = preRealDiffService.getDeptList(target);
                BigDecimal PRE_SUM = new BigDecimal(0);
                BigDecimal REAL_SUM = new BigDecimal(0);
                BigDecimal DIFF_SUM = new BigDecimal(0);
                for(int i = 0;i < deptList.size();i ++){
                    PageData searchPd = new PageData();
                    searchPd.put("B_YEAR_TARGET_CODE",target.get("B_YEAR_TARGET_CODE"));
                    searchPd.put("DEPT_CODE",deptList.get(i).get("DEPT_CODE"));
                    //获取预实差
                    List<PageData> preImplementationList = preRealDiffService.getPreImplementationList(searchPd);
                    deptList.get(i).put("preImplementationList",preImplementationList);

                    PRE_SUM = BigDecimal.valueOf(Double.valueOf(deptList.get(i).get("PRE_SUM").toString())).add(PRE_SUM);
                    REAL_SUM = BigDecimal.valueOf(Double.valueOf(deptList.get(i).get("REAL_SUM").toString())).add(REAL_SUM);
                    DIFF_SUM = BigDecimal.valueOf(Double.valueOf(deptList.get(i).get("DIFF_SUM").toString())).add(DIFF_SUM);
                }
                mv.addObject("PRE_SUM",PRE_SUM);
                mv.addObject("REAL_SUM",REAL_SUM);
                mv.addObject("DIFF_SUM",DIFF_SUM);
                mv.addObject("deptList",deptList);
                //获取可供选择的目标列表
                List<PageData> targetList = preRealDiffService.getTargetList(target);
                mv.addObject("targetList",targetList);
        	}
        	
        }
        mv.addObject("pd",pd);
        mv.setViewName("analyze/pre_implementation");
        return mv;
    }


    /**
     * 获取可供选择的目标列表
     * @return mv
     * @throws Exception
     * author yangdw
     */
    @RequestMapping(value = "/getTargetList")
    @ResponseBody
    public Object getTargetList() throws Exception{
        Map<String, Object> map = new HashMap<String, Object>();
        PageData pd = this.getPageData();

        try {
            //获取可供选择的目标列表
            List<PageData> targetList = preRealDiffService.getTargetList(pd);

            map.put("targetList", targetList);

        } catch (Exception e) {
            logger.error(e.toString(), e);
        }
        return AppUtil.returnObject(pd,map);

    }

    /**
     * 获得部门下员工预实差
     * @return mv
     * @throws Exception
     * author yangdw
     */
    @RequestMapping(value = "/getEmpPreImplementationList")
    @ResponseBody
    public Object getEmpPreImplementationList() throws Exception{
        Map<String, Object> map = new HashMap<String, Object>();
        PageData pd = this.getPageData();

        try {
            //获取员工列表
            List<PageData> empList = preRealDiffService.getEmpList(pd);
            for(int i = 0;i < empList.size();i ++){
                PageData searchPd = new PageData();
                searchPd.put("B_YEAR_TARGET_CODE",pd.get("B_YEAR_TARGET_CODE"));
                searchPd.put("EMP_CODE",empList.get(i).get("EMP_CODE"));
                //获取员工预实差
                List<PageData> empPreImplementationList = preRealDiffService.getEmpPreImplementationList(searchPd);
                empList.get(i).put("empPreImplementationList",empPreImplementationList);
            }

            map.put("empList", empList);

        } catch (Exception e) {
            logger.error(e.toString(), e);
        }
        return AppUtil.returnObject(pd,map);
    }
    
    
}
