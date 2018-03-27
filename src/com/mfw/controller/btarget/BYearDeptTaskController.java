package com.mfw.controller.btarget;

import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.apache.shiro.SecurityUtils;
import org.apache.shiro.session.Session;
import org.apache.shiro.subject.Subject;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import com.mfw.controller.base.BaseController;
import com.mfw.entity.GridPage;
import com.mfw.entity.Page;
import com.mfw.entity.system.User;
import com.mfw.entity.system.UserLog;
import com.mfw.service.bdata.CommonService;
import com.mfw.service.btarget.BMonthDeptTaskService;
import com.mfw.service.btarget.BYearDeptTaskService;
import com.mfw.service.btarget.BYearTargetService;
import com.mfw.service.system.UserLogService;
import com.mfw.util.Const;
import com.mfw.util.EndPointServer;
import com.mfw.util.PageData;
import com.mfw.util.TaskType;
import com.mfw.util.Tools;

/**
 * 年度经营任务（部门）
 * Created by yangdw on 2016/5/11.
 */
@Controller("bYearDeptTaskController")
@RequestMapping(value="/byeardepttask")
public class BYearDeptTaskController extends BaseController {

    @Resource(name = "userLogService")
    private UserLogService userLogService;

    @Resource(name = "bYearDeptTaskService")
    private BYearDeptTaskService bYearDeptTaskService;

    @Resource(name = "bMonthDeptTaskService")
    private BMonthDeptTaskService bMonthDeptTaskService;

    @Resource(name = "bYearTargetController")
    private BYearTargetController bYearTargetController;

    @Resource(name="bYearTargetService")
    private BYearTargetService bYearTargetService;

    @Resource(name = "commonService")
    private CommonService commonService;


//    /**
//     * 公司到部门的拆分
//     * @return mv
//     * @throws Exception
//     * author yangdw
//     */
//    @RequestMapping(value="/add")
//    public ModelAndView add() throws Exception{
//
//        logBefore(logger, "年度经营目标列表");
//
//        ModelAndView mv = this.getModelAndView();
//        PageData pd = this.getPageData();
//        Subject currentUser = SecurityUtils.getSubject();
//        Session session = currentUser.getSession();
//        try {
//            String[] dept_codes = pd.getString("DEPT_CODE").split(",");
//            String[] emp_codes = pd.getString("EMP_CODE").split(",");
//            String[] ids = pd.getString("ID").split(",",-1);
//            String[] update_ids = pd.getString("ID").split(",");
//            String[] statuses = pd.getString("STATUSES").split(",",-1);
//
//            if(pd.get("isChanged").toString().equals("1")){
//                List<PageData> addTaskList = new ArrayList<PageData>();
//                List<PageData> updateTaskList = new ArrayList<PageData>();
//                for(int i = 0;i < dept_codes.length;i ++){
//                	String[] counts = pd.getString("count_"+(i+1)).split(",");
//                	String[] moneys = pd.getString("money_"+(i+1)).split(",");
//                	String[] products = pd.getString("product_"+(i+1)).split(",");
//                	for(int j = 0; j < counts.length; j++){
//                		PageData task = new PageData();
//                		task.put("B_YEAR_TARGET_CODE",pd.get("B_YEAR_TARGET_CODE"));//目标编码
//                		if(!"".equals(statuses[i])){
//                			task.put("STATUS",statuses[i]);//状态
//                		}else if("YW_YSX".equals(statuses[0])){
//                			task.put("STATUS","YW_YSX");//状态
//                		}else{
//                			task.put("STATUS","YW_CG");//状态
//                		}
//                		task.put("ISDEL",0);//是否删除
//                		task.put("UPDATE_USER", session.getAttribute(Const.SESSION_USERNAME));//最后更新人
//                		task.put("UPDATE_TIME", Tools.date2Str(new Date()));//最后更新时间
//                		task.put("DEPT_CODE",dept_codes[i]);//部门编号
//                		task.put("EMP_CODE",emp_codes[i]);//员工编号
//                		task.put("PRODUCT_CODE",products[j]);//产品编号
//                		task.put("COUNT",counts[j]);//数量
//                		task.put("MONEY_COUNT",moneys[j]);//数量
//                		task.put("ID",ids[i]);//ID
//                		if("".equals(ids[i])){
//                			//如果id不存在，那么就是增加
//                			task.put("CREATE_USER", session.getAttribute(Const.SESSION_USERNAME));//创建人
//                			task.put("CREATE_TIME", Tools.date2Str(new Date()));//创建时间
//                			addTaskList.add(task);
//                		}else {
//                			//如果id存在，就是更新
//                			updateTaskList.add(task);
//                		}
//                	}
//                }
//
//                //批量删除
//                PageData deletePd = new PageData();
//                deletePd.put("B_YEAR_TARGET_CODE",pd.get("B_YEAR_TARGET_CODE"));
//                if(0 != update_ids.length && !("").equals(update_ids[0])){
//                    deletePd.put("update_ids",update_ids);
//                }else {
//                    String[] new_update_ids = {"0"};
//                    deletePd.put("update_ids",new_update_ids);
//                }
//                bYearDeptTaskService.batchDelete(deletePd);
//                userLogService.logInfo(new UserLog(getUser().getUSER_ID()
//                        , UserLog.LogType.delete, "年度经营任务（部门）", "批量删除"));//操作日志入库
//
//
//                //批量新增
//                if(null != addTaskList && 0 != addTaskList.size()){
//                    bYearDeptTaskService.batchAdd(addTaskList);
//                    userLogService.logInfo(new UserLog(getUser().getUSER_ID()
//                            , UserLog.LogType.add, "年度经营任务（部门）", "批量新增"));//操作日志入库
//                }
//
//                //批量更新
//                if(null != updateTaskList && 0 != updateTaskList.size()){
//                    bYearDeptTaskService.batchUpdate(updateTaskList);
//                    userLogService.logInfo(new UserLog(getUser().getUSER_ID()
//                            , UserLog.LogType.update, "年度经营任务（部门）", "批量更新"));//操作日志入库
//                }
//
//
//                if("YW_YSX".equals(pd.get("STATUS"))){
//                    //已生效的目标可能是来自草稿状态
//                    PageData updatePd = new PageData();
//                    updatePd.put("CODE",pd.get("B_YEAR_TARGET_CODE").toString());//编号
//                    updatePd.put("UPDATE_USER", session.getAttribute(Const.SESSION_USERNAME));//最后更新人
//                    updatePd.put("UPDATE_TIME", Tools.date2Str(new Date()));//最后更新时间
//                    bYearTargetService.arrange(updatePd);//下发目标
//
//                    //已生效的目标需要同时添加历史数据
//                    List<PageData> hisList = new ArrayList<PageData>();
//                    hisList.addAll(addTaskList);
//                    hisList.addAll(updateTaskList);
//                    bYearDeptTaskService.batchHisAdd(hisList);
//                }
//                
//                for(int i = 0; i < emp_codes.length; i++){
//                	EndPointServer.sendMessage(getUser().getNAME(), emp_codes[i], TaskType.yeardepttask);
//                }
//            }
//            mv.addObject("flag","success");
//        }catch (Exception e){
//            logger.error(e.toString(), e);
//            mv.addObject("flag","false");
//        }
//
//        bYearTargetController.initExplainPage(mv,pd);
//        mv.setViewName("btarget/byeartarget/explain");
//        return mv;
//    }

    /**
     * 公司到部门的拆分
     * @return mv
     * @throws Exception
     * author yangdw
     */
    @RequestMapping(value="/add")
    public ModelAndView add() throws Exception{
        ModelAndView mv = this.getModelAndView();
        PageData pd = this.getPageData();
        //承接部门
        String[] dept_codes = pd.getString("DEPT_CODE").split(",");
        //承接责任人
        String[] emp_codes = pd.getString("EMP_CODE").split(",");
        //需要更新的结果集
        List<PageData> addTaskList = new ArrayList<PageData>();
        //页面内容变更或点击生效按钮后执行保存，否则直接跳过
        if(pd.get("isChanged").toString().equals("1") || "YW_YSX".equals(pd.get("STATUS"))){
        	updatePage(pd);
        	//删除现有分解
        	bYearDeptTaskService.deleteByYearTargetCode(pd.get("B_YEAR_TARGET_CODE").toString());
        	//按照部门数拼接结果集
        	for(int i = 0; i < dept_codes.length; i++){
        		//承接数量
            	String[] count = pd.getString("count_"+(i+1)).split(",");
            	//承接金额，金额不一定存在，非销售类的任务无金额字段
            	Object moneys = pd.get("money_"+(i+1));
            	String[] money = null;
            	if(moneys != null && moneys.toString().length() > 0){
            		money = pd.getString("money_"+(i+1)).split(",");
            	}
            	//产品
            	String[] products = pd.getString("product_"+(i+1)).split(",");
            	//根据分解项拼接结果集
            	for(int j = 0; j < count.length; j++){
            		PageData task = new PageData();
        			task.put("B_YEAR_TARGET_CODE",pd.get("B_YEAR_TARGET_CODE"));//年度经营目标编码
            		task.put("STATUS","YW_CG");//状态
            		task.put("ISDEL",0);//是否删除
            		task.put("UPDATE_USER", getUser().getUSERNAME());//最后更新人
            		task.put("UPDATE_TIME", Tools.date2Str(new Date()));//最后更新时间
            		task.put("DEPT_CODE",dept_codes[i]);//部门编号
            		task.put("EMP_CODE",emp_codes[i]);//员工编号
            		task.put("PRODUCT_CODE",products[j]);//产品编号
            		task.put("COUNT",count[j]);//数量
            		if(moneys != null && moneys.toString().length() > 0){
            			task.put("MONEY_COUNT",money[j]);//数量
            		}else{
            			task.put("MONEY_COUNT", 0);//数量
            		}
            		task.put("CREATE_USER", getUser().getUSERNAME());//创建人
            		task.put("CREATE_TIME", Tools.date2Str(new Date()));//创建时间
            		task.put("UPDATE_USER", getUser().getUSERNAME());//创建人
            		task.put("UPDATE_TIME", Tools.date2Str(new Date()));//创建时间
            		addTaskList.add(task);
            	}
            }
            
            //批量新增
            if(null != addTaskList && 0 != addTaskList.size()){
            	bYearDeptTaskService.batchAdd(addTaskList);
            	userLogService.logInfo(new UserLog(getUser().getUSER_ID(), UserLog.LogType.add,
            			"年度经营任务（部门）", "批量新增"));//操作日志入库
            }
            
            if("YW_YSX".equals(pd.get("STATUS"))){
                //已生效的目标可能是来自草稿状态
                PageData updatePd = new PageData();
                updatePd.put("CODE",pd.get("B_YEAR_TARGET_CODE").toString());//编号
                updatePd.put("UPDATE_USER", getUser().getUSERNAME());//最后更新人
                updatePd.put("UPDATE_TIME", Tools.date2Str(new Date()));//最后更新时间
                bYearTargetService.arrange(updatePd);//下发目标
                bYearDeptTaskService.arrange(updatePd);

                //已生效的目标需要同时添加历史数据
                bYearDeptTaskService.batchHisAdd(addTaskList);
                
                //通知在线的责任人
                for(int i = 0; i < emp_codes.length; i++){
                	EndPointServer.sendMessage(getUser().getNAME(), emp_codes[i], TaskType.yeardepttask);
                }
            }
        }
        
        bYearTargetController.initExplainPage(mv,pd);
        mv.setViewName("btarget/byeartarget/explain");
        return mv;
    }
    
    /**
     * 年度经营任务（部门）列表
     * @param page
     * @return mv
     * @throws Exception
     * author yangdw
     */
    @RequestMapping(value="/list")
    public ModelAndView list(Page page) throws Exception{
        ModelAndView mv = this.getModelAndView();
        mv.addObject("currentEmpCode", getUser().getNUMBER());
        mv.setViewName("btarget/byeardepttask/list");
        return mv;
    }
    /**
     * 获取表格数据
     * @param page
     * @param request
     * @return
     */
    @ResponseBody
    @RequestMapping(value="/taskList")
    public GridPage taskList(Page page,HttpServletRequest request){
    	logBefore(logger, "年度经营任务（部门）列表");
    	List<PageData> taskList = new ArrayList<>();
    	
        try {
        	convertPage(page, request);
        	PageData pageData = page.getPd();
            User user = getUser();
            pageData.put("USER_NUMBER", user.getNUMBER());
            pageData.put("USER_NAME", user.getUSERNAME());
            pageData.put("USER_DEPT_ID", user.getDeptId());
            //2016-07-07 yangdw 加入数据权限
            List<PageData> sysDeptList = commonService.getSysDeptList();
            if(null != sysDeptList && 0 != sysDeptList.size() && null != sysDeptList.get(0)){
                String[] sysDeptArr = new String[sysDeptList.size()];
                for(int i = 0; i < sysDeptList.size(); i ++){
                    sysDeptArr[i] = sysDeptList.get(i).get("DEPT_CODE").toString();
                }
                pageData.put("sysDeptArr", sysDeptArr);
            }

            page.setPd(pageData);
            taskList = bYearDeptTaskService.list(page);//获取月度经营任务（部门）列表
        }catch (Exception e){
            logger.error(e.toString(), e);
            e.printStackTrace();
        }
        return new GridPage(taskList, page);
    }
    /**
     * 跳转任务分解页面
     * @return mv
     * @throws Exception
     * author yangdw
     */
    @RequestMapping(value="/goExplain")
    public ModelAndView goExplain() throws Exception{

        logBefore(logger, "跳转任务分解页面");

        ModelAndView mv = this.getModelAndView();
        PageData pd = this.getPageData();
        try {
            //初始化分解页面
            initExplainPage(mv,pd);
        }catch (Exception e){
            logger.error(e.toString(), e);
        }
        mv.setViewName("btarget/byeardepttask/explain");
        return mv;
    }

    /**
     * 跳转分解历史页面
     * @return mv
     * @throws Exception
     * author yangdw
     */
    @RequestMapping(value="/goHistory")
    public ModelAndView goHistory() throws Exception{

        logBefore(logger, "跳转分解历史页面");

        ModelAndView mv = this.getModelAndView();
        PageData pd = this.getPageData();
        try {

            //获取任务
            PageData task = bYearDeptTaskService.getTaskById(pd);
            //获取起始时间和结束时间
            String START_DATE = task.get("START_DATE").toString();
            String END_DATE = task.get("END_DATE").toString();
            //获取起始年度和结束年度
            Integer START_YEAR = Integer.valueOf(START_DATE.substring(0,4));
            Integer END_YEAR = Integer.valueOf(END_DATE.substring(0,4));
            //获取历史数据时间分组
            List<PageData> hisTimeList = bMonthDeptTaskService.getHisTimeList(pd);
            PageData hisSearchPd = new PageData();
            List<PageData> hisList = new ArrayList<PageData>();
            hisSearchPd.put("ID",pd.get("ID").toString());//ID
            for (int i =0 ; i < hisTimeList.size();i ++){
                hisSearchPd.put("UPDATE_TIME",hisTimeList.get(i).get("UPDATE_TIME"));//更新时间
                PageData his = new PageData();
                his.put("HIS_COUNT",hisTimeList.get(i).get("HIS_COUNT"));
                his.put("HIS_COUNT_MONEY",hisTimeList.get(i).get("HIS_COUNT_MONEY"));
                //将拆分到月的任务按年分组
                List<PageData> hisTaskGroupByYear = new ArrayList<PageData>();
                for(int j = START_YEAR; j <= END_YEAR; j ++){
                    hisSearchPd.put("YEAR",String.valueOf(j));//年度
                    //List<PageData> hisMonthTaskList = bMonthDeptTaskService.getHisMonthTaskListByYear(hisSearchPd);
                    List<PageData> hisMonthTaskList = bMonthDeptTaskService.getMonthDeptTaskList(hisSearchPd);
                    PageData setPd = new PageData();
                    setPd.put("hisMonthTaskList",hisMonthTaskList);//拆分到月的列表
                    setPd.put("YEAR",String.valueOf(j));//年度
                    hisTaskGroupByYear.add(setPd);
                }
                his.put("USER_NAME", hisTimeList.get(i).get("USER_NAME"));
                his.put("UPDATE_TIME",hisTimeList.get(i).get("UPDATE_TIME"));
                his.put("MONTH_COUNT_SUM",hisTimeList.get(i).get("MONTH_COUNT_SUM"));
                his.put("MONEY_COUNT_SUM",hisTimeList.get(i).get("MONEY_COUNT_SUM"));
                his.put("hisTaskGroupByYear",hisTaskGroupByYear);
                hisList.add(his);
            }

            mv.addObject("task",task);
            mv.addObject("hisList",hisList);
            //放入上级frameId用于返回
            mv.addObject("PARENT_FRAME_ID",pd.get("PARENT_FRAME_ID"));
        }catch (Exception e){
            logger.error(e.toString(), e);
        }
        mv.setViewName("btarget/byeardepttask/history");
        return mv;
    }


    /**
     * 下发任务
     * @param out
     * @throws Exception
     * author yangdw
     */
    @RequestMapping(value = "/arrange",produces = "text/plain;charset=UTF-8")
    public void arrange(PrintWriter out) throws Exception{
        logBefore(logger, "下发任务");
        PageData pd = this.getPageData();
        Subject currentUser = SecurityUtils.getSubject();
        Session session = currentUser.getSession();

        try {
            PageData updatePd = new PageData();
            updatePd.put("ID",pd.get("ID").toString());//编号
            updatePd.put("UPDATE_USER", session.getAttribute(Const.SESSION_USERNAME));//最后更新人
            updatePd.put("UPDATE_TIME", Tools.date2Str(new Date()));//最后更新时间

            bMonthDeptTaskService.arrange(updatePd);

            List<PageData> monthTaskList = bMonthDeptTaskService.getMonthTaskList(pd);
            bMonthDeptTaskService.batchHisAdd(monthTaskList);//目标分解存入历史库

            userLogService.logInfo(new UserLog(getUser().getUSER_ID()
                    , UserLog.LogType.update, "下发目标", "id是" + pd.get("ID").toString()));//操作日志入库

            out.write("success");
            out.close();
        } catch (Exception e) {
            logger.error(e.toString(), e);
            out.write("false");
            out.close();
        }
    }

    /**
     * 初始化分解页面
     * @param mv,pd
     * @throws Exception
     * author yangdw
     */
    public void initExplainPage(ModelAndView mv, PageData pd) throws Exception {
        //获取任务
        PageData task = bYearDeptTaskService.getTaskById(pd);
        //获取起始时间和结束时间
        String START_DATE = task.get("START_DATE").toString();
        String END_DATE = task.get("END_DATE").toString();
        //获取起始年度和结束年度
        Integer START_YEAR = Integer.valueOf(START_DATE.substring(0,4));
        Integer END_YEAR = Integer.valueOf(END_DATE.substring(0,4));
        //将拆分到月的任务按年分组
        List<PageData> taskGroupByYear = new ArrayList<PageData>();
        for(int i = START_YEAR; i <= END_YEAR; i ++){
            PageData searchPd = new PageData();
            searchPd.put("YEAR",String.valueOf(i));//年度
            searchPd.put("START_DATE",START_DATE);//起始时间
            searchPd.put("END_DATE",END_DATE);//结束时间
            searchPd.put("ID",pd.get("ID").toString());//ID
            List<PageData> monthTaskList = bMonthDeptTaskService.getMonthDeptTaskList(searchPd);
            PageData setPd = new PageData();
            setPd.put("monthTaskList",monthTaskList);//拆分到月的列表
            setPd.put("YEAR",String.valueOf(i));//年度
            taskGroupByYear.add(setPd);
        }

        mv.addObject("taskGroupByYear",taskGroupByYear);
        mv.addObject("task",task);
        if(null!=task.get("EXPLAIN_EMP_CODE") && getUser().getNUMBER().equals(task.getString("EXPLAIN_EMP_CODE"))){//分解人为指定负责人
            mv.addObject("isExplainEmp", 1);
        }
        //放入上级frameId用于返回
        mv.addObject("PARENT_FRAME_ID",pd.get("PARENT_FRAME_ID"));
    }
    
    /**
	 * 任务撤回
	 * @return
	 */
	@ResponseBody
	@RequestMapping(value="withdraw")
	public String withdraw(String id){
		try {
			bYearDeptTaskService.withdraw(id);
		} catch (Exception e) {
			e.printStackTrace();
			return "faild";
		}
		return "success";
	}
	
	/**
	 * 指定任务负责人
	 */
	@ResponseBody
	@RequestMapping(value="updateExplainEmp")
	public String updateExplainEmp(){
		try {
			PageData pd = this.getPageData();
			//设置任务负责人
			bYearDeptTaskService.updateExplainEmp(pd);
		} catch (Exception e) {
			logger.error("指定任务负责人出错", e);
			return "error";
		}
		return "success";
	}
	
}
