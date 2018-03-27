package com.mfw.controller.performance;

import java.io.PrintWriter;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

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
import com.mfw.service.bdata.CommonService;
import com.mfw.service.dailytask.WorkEntryService;
import com.mfw.service.performance.PerformanceService;
import com.mfw.service.system.datarole.DataRoleService;
import com.mfw.service.task.EmpDailyTaskService;
import com.mfw.util.Const;
import com.mfw.util.ObjectExcelView;
import com.mfw.util.PageData;
import com.mfw.util.Tools;


@Controller
@RequestMapping("/performance")
public class PerformanceController extends BaseController{

	@Resource(name="performanceService")
	private PerformanceService performanceService;
	
	//=========
	@Resource(name="empDailyTaskService")
	private EmpDailyTaskService empDailyTaskService;
	
	@Resource(name="WorkEntryService")
	private WorkEntryService workEntryService;
	
	@Resource(name="dataroleService")
	private DataRoleService dataroleService;
	
	@Resource(name="commonService")
	private CommonService commonService;
	
	
	/**
	 * 初始化进入页面跳转
	 * @return
	 */
	@RequestMapping(value= "/list")
	public ModelAndView list(){
		ModelAndView mv = this.getModelAndView();
		mv.setViewName("performance/list");
		//查询是否领导，1为领导，0为普通员工
		PageData userPd = new PageData();
		userPd.put("USERNAME", getUser().getUSERNAME());
		Subject currentUser = SecurityUtils.getSubject();
		Session session = currentUser.getSession();
		User user = (User) session.getAttribute(Const.SESSION_USERROL);
		String EMP_CODE = user.getNUMBER();
		try {
			int count = commonService.checkLeader(userPd);
			mv.addObject("isLeader", count);
			mv.addObject("EMP_CODE", EMP_CODE);
		} catch (Exception e) {
			logger.error("跳转到绩效考核页面出错", e);
		}
		return mv;
	}
	/**
	 * 获取人员
	 * @param page
	 * @return
	 * @throws Exception 
	 */
	@ResponseBody
	@RequestMapping(value="/empList")
	public GridPage taskList(Page page,HttpServletRequest request) throws Exception{
		logBefore(logger, "部门员工列表");
		List<PageData> list = new ArrayList<>();
		List<PageData> perList = new ArrayList<>();
		convertPage(page, request);
		PageData pageData = page.getPd();
		String DEPT_NAME = pageData.getString("DEPT_NAME");
		if(null != DEPT_NAME && !"".equals(DEPT_NAME)){//trim
			DEPT_NAME = DEPT_NAME.trim();
			pageData.put("DEPT_NAME", DEPT_NAME);
		}
		
		String MONTH = pageData.getString("MONTH");
		String LAST_MONTH = "";
		SimpleDateFormat sdf =  new SimpleDateFormat("yyyy-MM");
		if (MONTH==null||MONTH.equals("")) {
			Calendar c = Calendar.getInstance();
			MONTH = sdf.format(c.getTime());
			c.add(Calendar.MONTH, -1);
			LAST_MONTH = sdf.format(c.getTime());
		}else{
			Date d = sdf.parse(MONTH);
			Calendar c=Calendar.getInstance();  
		    c.setTime(d);  
		    c.add(Calendar.MONTH, -1);
			LAST_MONTH = sdf.format(c.getTime());
		}
		pageData.put("MONTH", MONTH);
		pageData.put("LAST_MONTH", LAST_MONTH);
		
		//====数据权限
		Subject currentUser = SecurityUtils.getSubject();
		Session session = currentUser.getSession();
		User user = (User) session.getAttribute(Const.SESSION_USERROL);
		List<PageData> dataRoles = dataroleService.findByUser(user.getUSER_ID());
		String DEPT_IDS = "";
		int deptId = user.getDeptId();
		for(PageData dataRole : dataRoles){
			DEPT_IDS+=(dataRole.get("DEPT_ID")+",");
		}
		if (DEPT_IDS!=null&&!DEPT_IDS.equals("")) {
			DEPT_IDS = DEPT_IDS.substring(0, DEPT_IDS.length()-1);
		}
		pageData.put("DEPT_IDS", DEPT_IDS);
		pageData.put("EMP_DEPARTMENT_ID", deptId);
		//======
		
		page.setPd(pageData);
		list = performanceService.list(page);
		for(PageData pd : list){
			pd.put("RANKING", Integer.valueOf(pd.get("RANKING").toString())+(page.getCurrentPage()-1)*page.getShowCount());
			perList.add(pd);
			
		}
		return new GridPage(perList,page);
		
	}
	
	/**
	 * ===========绩效管理================
	 */
	
	
	/**
	 * 跳转到日清工作台
	 */
	@RequestMapping("listTask")
	public ModelAndView listTask(){
		logBefore(logger, "跳转到绩效管理页面");
		ModelAndView mv = this.getModelAndView();
		List<PageData> productList = new ArrayList<PageData>();//用于页面查询的数据列表
		List<PageData> projectList = new ArrayList<PageData>();//用于页面查询的数据列表
		List<PageData> kpiList = new ArrayList<PageData>();//用于页面查询的数据列表
		PageData pd = this.getPageData();
		String flg = "1";
		try {
			if(null == pd.get("empCode")){
				User user = getUser();
				//获取当前登录用户
				String empCode = user.getNUMBER();
				pd.put("empCode", empCode);
			}
			//默认加载目标工作
			if(null == pd.get("loadType")){
				pd.put("loadType", "B");
			}
			//查询员工是否可以添加日常工作
			pd.put("EMP_CODE", pd.get("empCode"));
			
			//========相比于员工日清页面新增代码======
			if(pd.get("PERF_ID")!=null&&!pd.get("PERF_ID").toString().equals("")&&!pd.get("PERF_ID").toString().equals("undefined")){
				kpiList = performanceService.getScoreByPerfId(pd);
				flg="2";
			}else{
				kpiList = performanceService.getScoreByEmpCode(pd);
				pd.put("PERF_ID", 0);
				pd.put("SCORE", 0);
			}
			for(int i=0;i<kpiList.size();i++){
				PageData kpi = kpiList.get(i);
				if(!"".equals(kpi.getString("KPI_SQL"))&&kpi.getString("KPI_SQL")!=null){
					PageData sqlPd = new PageData();
					sqlPd.put("KPI_SQL", kpi.getString("KPI_SQL"));
					//设置查询参数
					sqlPd.put("empCode", pd.get("empCode"));
					String percent = performanceService.getPercent(sqlPd);
//					int score =Integer.valueOf(kpi.getString("PREPARATION3"))*Integer.valueOf(percent);
					//sql返回的结果是带小数的
					if(null == percent){
						percent = "0";
					}
					Double score = new Double(percent) * Integer.valueOf(kpi.getString("PREPARATION3"));
					kpi.put("SCORE", score.intValue());
					kpi.put("PERCENT", percent);
					kpiList.set(i, kpi);
				}else{
					kpi.put("sqlFlg", "1");
					kpiList.set(i, kpi);
				}
			}
			mv.addObject("kpiList",kpiList);
			//================新增结束===============
			
			
		} catch (Exception e) {
			mv.addObject("errorMsg", "跳转到绩效管理页面出错");
			logger.error("跳转到绩效管理页面出错", e);
		}
		//返回到页面
		mv.addObject("flg", flg);
		mv.addObject("productList", productList);
		mv.addObject("projectList", projectList);
		mv.addObject("pd", pd);
		mv.setViewName("performance/listTask");
		return mv;
	}

	/**
	 * 查询员工的任务列表，以json形式返回；
	 * 请求中需要包含empCode参数-员工编号，loadType-查询的任务类型，
	 */
	@ResponseBody
	@RequestMapping("listTaskForGrid")
	public GridPage listTaskForGrid(Page page , HttpServletRequest request){
		logBefore(logger, "查询员工的任务列表，以json形式返回");
		List<PageData> taskList = new ArrayList<PageData>();//任务列表
		try {
			convertPage(page, request);
			PageData pageData = page.getPd();
			//获取查询的任务类型
			
			//==========绩效新增代码start========
			if ((pageData.get("startDate")==null||"".equals(pageData.get("startDate")))&&(pageData.get("endDate")==null||"".equals(pageData.get("endDate")))) {
				SimpleDateFormat sdf =  new SimpleDateFormat("yyyy-MM-dd");
				String startDate = pageData.get("MONTH").toString()+"-01";
				
				Date d = sdf.parse(startDate);
				Calendar c=Calendar.getInstance();  
			    c.setTime(d);  
			    c.add(Calendar.MONTH, 1);
			    c.add(Calendar.DATE, -1);
			    
			    String endDate = sdf.format(c.getTime());
			    pageData.put("startDate", startDate);
			    pageData.put("endDate", endDate);
			}
			//==========绩效新增代码end========
			
			
			String loadType = pageData.getString("loadType");
			if(Const.TASK_TYPE_B.equals(loadType)){//目标工作不返回草稿状态的
				pageData.put("useStatus", Const.SYS_STATUS_YW_CG);
			}
			page.setPd(pageData);
			if(Const.TASK_TYPE_B.equals(loadType)){
				//查询周工作目标
				taskList = performanceService.empWeekTasklistPage(page);
			}else if(Const.TASK_TYPE_C.equals(loadType)){
				//查询项目工作
				taskList = empDailyTaskService.empProjectEventlistPage(page);
			}else if(Const.TASK_TYPE_F.equals(loadType)){
				//查询流程工作
				taskList = empDailyTaskService.empFlowWorklistPage(page);
			}else if(Const.TASK_TYPE_D.equals(loadType)){
				//查询日常工作
				taskList = empDailyTaskService.empPositionTasklistPage(page);
			}else if(Const.TASK_TYPE_T.equals(loadType)){
				//查询临时工作
				pageData.put("userCode", pageData.get("empCode"));
				taskList = workEntryService.list(page); //列出员工日清列表
			}
		} catch (Exception e) {
			logger.error("查询员工的任务列表出错", e);
		}
		return new GridPage(taskList, page);
	}

	
	@RequestMapping(value = "/savePerf")
	public void add(PrintWriter out, HttpServletRequest request) throws Exception {
		logBefore(logger, "保存绩效考核信息");
		PageData pd = this.getPageData();
		PageData pdPerf = new PageData();
		PageData pdt;
		
		Subject currentUser = SecurityUtils.getSubject();
		Session session = currentUser.getSession();
		User user = (User) session.getAttribute(Const.SESSION_USERROL);
		
		try {
			if (pd.get("PERF_ID").toString().equals("0")) {
				pdPerf.put("MONTH", pd.get("MONTH"));
				pdPerf.put("EMP_CODE", pd.get("EMP_CODE"));
				pdPerf.put("SCORE", Integer.parseInt(pd.get("totalScore").toString()));
				
				pdPerf.put("CREATE_USER_ID", user.getUSER_ID());		//创建人
				pdPerf.put("CREATE_USER", session.getAttribute(Const.SESSION_USERNAME));		//创建人
				pdPerf.put("CREATE_TIME", Tools.date2Str(new Date()));							//创建时间			
				performanceService.savePerf(pdPerf);
				
				String[] socreList = pd.get("SCORE").toString().split(",");
				String[] lIdList = pd.get("LID").toString().split(",");
				for(int i=0;i<socreList.length;i++){
					pdt = new PageData();
					pdt.put("PERFORMANCE_ID", pdPerf.get("ID"));
					pdt.put("SCORE", socreList[i]);
					pdt.put("KPI_DETAIL_ID", lIdList[i]);
					pdt.put("CREATE_USER", session.getAttribute(Const.SESSION_USERNAME));		//创建人
					pdt.put("CREATE_TIME", Tools.date2Str(new Date()));	
					performanceService.savePerfDetail(pdt);
				}
			}else{
				pdPerf.put("ID", pd.get("PERF_ID"));
				pdPerf.put("SCORE", Integer.parseInt(pd.get("totalScore").toString()));
				pdPerf.put("UPDATE_USER", session.getAttribute(Const.SESSION_USERNAME));		//创建人
				pdPerf.put("UPDATE_TIME", Tools.date2Str(new Date()));	
				performanceService.editPerf(pdPerf);
				
				String[] socreList = pd.get("SCORE").toString().split(",");
				String[] pdIdList = pd.get("PDID").toString().split(",");
				for(int i=0;i<socreList.length;i++){
					pdt = new PageData();
					pdt.put("SCORE", socreList[i]);
					pdt.put("ID", pdIdList[i]);
					pdt.put("UPDATE_USER", session.getAttribute(Const.SESSION_USERNAME));		//创建人
					pdt.put("UPDATE_TIME", Tools.date2Str(new Date()));	
					performanceService.editPerfDetail(pdt);
				}
			}
			
			out.write("success");
			
		} catch (Exception e) {
			out.write("error");
			logger.error(e.toString(), e);
		}
		out.close();
	}
	
	/*
	 * 导出员工绩效到EXCEL
	 * @return
	 */
	@RequestMapping(value = "/excel")
	public ModelAndView exportExcel() {
		ModelAndView mv = this.getModelAndView();
		try {

			Map<String, Object> dataMap = new HashMap<String, Object>();
			List<String> titles = new ArrayList<String>();

			titles.add("员工号"); //1
			titles.add("员工姓名"); //2
			titles.add("岗位"); //3
			titles.add("部门"); //4
			titles.add("当月得分率"); //5

			dataMap.put("titles", titles);

			List<PageData> userList = excelTaskList();
			List<PageData> varList = new ArrayList<PageData>();
			for (int i = 0; i < userList.size(); i++) {
				PageData vpd = new PageData();
				vpd.put("var1", userList.get(i).getString("EMP_CODE")); //1
				vpd.put("var2", userList.get(i).getString("EMP_NAME")); //2
				vpd.put("var3", userList.get(i).getString("EMP_DEPARTMENT_NAME")); //3
				vpd.put("var4", userList.get(i).getString("EMP_GRADE_NAME")); //4
				if(null == userList.get(i).get("SCORE")||"".equals(userList.get(i).get("SCORE"))){
					vpd.put("var5", "0"); //5
				}else{
					Double score = new Double(userList.get(i).get("SCORE").toString())/100;
					vpd.put("var5", score.toString()); //5
				}
				
				varList.add(vpd);
			}

			dataMap.put("varList", varList);

			ObjectExcelView erv = new ObjectExcelView(); //执行excel操作

			mv = new ModelAndView(erv, dataMap);
		} catch (Exception e) {
			logger.error(e.toString(), e);
		}
		return mv;
	}
	
	//获取导出到excel的信息
	public List<PageData> excelTaskList() throws Exception{
		logBefore(logger, "部门员工列表");
		List<PageData> taskList = new ArrayList<>();
		PageData pageData = new PageData();
		
		String MONTH = "";
		String LAST_MONTH = "";
		SimpleDateFormat sdf =  new SimpleDateFormat("yyyy-MM");
		Calendar c = Calendar.getInstance();
		MONTH = sdf.format(c.getTime());
		c.add(Calendar.MONTH, -1);
		LAST_MONTH = sdf.format(c.getTime());
		pageData.put("MONTH", MONTH);
		pageData.put("LAST_MONTH", LAST_MONTH);
		
		//====数据权限
		Subject currentUser = SecurityUtils.getSubject();
		Session session = currentUser.getSession();
		User user = (User) session.getAttribute(Const.SESSION_USERROL);
		List<PageData> dataRoles = dataroleService.findByUser(user.getUSER_ID());
		String DEPT_IDS = "";
		int deptId = user.getDeptId();
		for(PageData dataRole : dataRoles){
			DEPT_IDS+=(dataRole.get("DEPT_ID")+",");
		}
		if (DEPT_IDS!=null&&!DEPT_IDS.equals("")) {
			DEPT_IDS = DEPT_IDS.substring(0, DEPT_IDS.length()-1);
		}
		pageData.put("DEPT_IDS", DEPT_IDS);
		pageData.put("EMP_DEPARTMENT_ID", deptId);
		//======
		
		taskList = performanceService.excelList(pageData);
		
		return taskList;
		
	}
	
}
