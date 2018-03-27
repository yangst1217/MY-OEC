package com.mfw.controller.app.task;

import com.mfw.controller.base.BaseController;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
@RequestMapping(value = "/app_board")
public class AppBoardController extends BaseController {/*
	
	@Resource(name = "empDailyTaskService")
	private EmpDailyTaskService empDailyTaskService;
	@Resource(name = "commonService")
	private CommonService commonService;
	@Resource(name="userLogService")
	private UserLogService userLogService;
	@Resource(name="empDailyEventService")
	private EmpDailyEventService empDailyEventService;
	@Resource(name="employeeService")
	private EmployeeService employeeService;

	String test = "RQKB";

	*//**
	 * 页面初始化查询
	 * @param request
	 * @param page
	 * @return
	 *//*
	@RequestMapping(value = "listBoard")
	public ModelAndView listBoard(HttpServletRequest request, Page page) {
		ModelAndView mv = this.getModelAndView();
		PageData pd = new PageData();
		List<PageData> deptList = new ArrayList<PageData>();// 下属部门列表
		List<PageData> taskList = new ArrayList<PageData>();// 周工作列表
		List<PageData> eventList = new ArrayList<PageData>();// 创新活动列表
		List<PageData> manageList = new ArrayList<PageData>();// 行政任务列表
		List<PageData> productList = new ArrayList<PageData>();//产品列表
		List<PageData> projectList = new ArrayList<PageData>();//项目列表
		List<PageData> empList = new ArrayList<PageData>();//员工列表
		try {
			pd = this.getPageData();
			pd.put("showDept", 1);
			User user = getUser();
			if (null == pd.get("taskTypeName")
					|| ("").equals(pd.get("taskTypeName"))) {
				pd.put("taskTypeName", "1");
			}
			// 查询部门列表
			deptList = getDeptList(request, commonService);
			String deptIdStr = "";// 用于页面上选择部门时查询员工
			String deptCodeStr = "";// 用于查询所有部门下的员工周工作
			List<String> deptCodeList = new ArrayList<String>();// 用于查询项目和产品
			if (deptList.size() > 0) {
				for (PageData dept : deptList) {
					deptIdStr += "," + dept.get("ID");
					deptCodeStr += "," + "'" + dept.getString("DEPT_CODE")
							+ "'";
					deptCodeList.add(dept.getString("DEPT_CODE"));
				}
				deptIdStr = deptIdStr.substring(1);
				deptCodeStr = "(" + deptCodeStr.substring(1) + ")";

				pd.put("deptCodeStr", deptCodeStr);
				pd.put("deptIdStr", deptIdStr);
			}
			List<Integer> deptIdList = new ArrayList<Integer>();// 用于查询员工
			// 是否选择部门
			if (null == pd.get("deptCode")
					|| pd.get("deptCode").toString().isEmpty()) {
				if (deptList.size() > 0) {
					for (PageData dept : deptList) {
						deptIdList.add(Integer.valueOf(dept.get("ID")
								.toString()));
					}
				} else {
					mv.addObject("errorMsg", "没有查询到该员工的下属部门！");
					return mv;
				}
			} else {// 已选部门
			// deptCodeList.add(pd.getString("deptCode"));
				for (PageData dep : deptList) {
					if (dep.getString("DEPT_CODE").equals(
							pd.getString("deptCode"))) {
						deptIdList.add(Integer.valueOf(dep.get("ID")
								.toString()));
						break;
					}
				}
			}
			//查询部门员工列表
			empList = employeeService.findEmpByDeptIds(deptIdList);
			//查询产品列表
			productList = empDailyTaskService.findProductByDept(deptCodeList);
			//查询项目列表
			projectList = empDailyTaskService.findProjectByDept(deptCodeList);
			// 不显示草稿状态
			pd.put("useStatus", Const.SYS_STATUS_YW_CG);
			page.setPd(pd);
			if (pd.get("taskTypeName").equals("1")) {

				// 查询周工作任务
				taskList = empDailyTaskService.empWeekTasklistPage(page);
				mv.addObject("weekList", taskList);
			} else if (pd.get("taskTypeName").equals("2")) {
				//查询创新活动
				eventList = empDailyTaskService.empProjectEventlistPage(page);
				mv.addObject("eventList", eventList);
			} else if (pd.get("taskTypeName").equals("3")) {
				//查询行政任务
				manageList = empDailyTaskService.empProjectManagelistPage(page);
				mv.addObject("manageList", manageList);
			}
			List<PageData> modelList = commonService.typeListByBm(test);
			mv.setViewName("app/board/AppBoard");
			mv.addObject("empList", empList);
			mv.addObject("modelList", modelList);
			mv.addObject("deptList",deptList);
			mv.addObject("productList", productList);
			mv.addObject("projectList", projectList);
			mv.addObject("pd", pd);
		} catch (Exception e) {
			logger.error(e.toString(), e);
		}
		
		return mv;
	}
	*//**
	 * 查询周工作详情
	 * @param pd
	 * @return
	 *//*
	@RequestMapping(value="findWeekInfo")
	public ModelAndView findWeekInfo(){
		logBefore(logger, "查询周工作任务详情");
		ModelAndView mv = new ModelAndView();
		PageData pd = this.getPageData();
		try {
			pd.put("taskType", Const.TASK_TYPE_B);//经营类为B，创新类为C
			//查询周工作详情
			PageData weekTaskPd = new PageData();
			weekTaskPd.put("id", pd.get("weekEmpTaskId"));
			
			PageData weekTask = empDailyTaskService.findWeekTaskDetail(weekTaskPd);
			//查询员工日清明细
			List<PageData> emptaskList = empDailyTaskService.listEmptaskByWeektaskId(pd);
			//计划进度
			SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
			double planPercent = getPercent(weekTask.getString("WEEK_START_DATE"), 
					weekTask.getString("WEEK_END_DATE"), sdf.format(new Date()));
			//实际进度
			double actual_percent = 0;
			//已添加日清的进度
			double finish_percent = 0;
			for(int i=0; i<emptaskList.size(); i++){
				PageData empTask = emptaskList.get(i);
				String taskStatus = empTask.getString("STATUS_BIANMA");
				double taskPercent = new BigDecimal(emptaskList.get(i).get("FINISH_PERCENT").toString()).doubleValue();
				if(Const.SYS_STATUS_YW_YSX.equals(taskStatus)){//实际进度计算‘审核通过’的
					actual_percent += taskPercent;
				}else if(Const.SYS_STATUS_YW_YTH.equals(taskStatus)){//已退回的不计算在完成进度中
					continue;
				}
				finish_percent += taskPercent;
			}
			//工作量实际差值
			double taskDiff = 0;
			if(planPercent>finish_percent){
				taskDiff = Double.parseDouble(weekTask.get("WEEK_COUNT").toString()) * (planPercent-finish_percent)/100;
			}
			weekTask.put("taskCount", new DecimalFormat("0.00").format(taskDiff));
			weekTask.put("plan_percent", new DecimalFormat("0.00").format(planPercent));
			weekTask.put("actual_percent", new DecimalFormat("0.00").format(actual_percent));
			mv.addObject("weekTask", weekTask);
			
		} catch (Exception e) {
			mv.addObject("errorMsg", "查询员工周工作详情出错");
			logger.error("查询周工作详情出错", e);
		}
		String page = "currentPage=" + pd.get("currentPage") + "&showCount=" + pd.getString("showCount");
		pd.put("page", page);
		pd.put("taskTypeName","1");
		mv.addObject("pd",pd);
		mv.setViewName("app/board/AppBoardDetail");
		return mv;
	}
	*//**
	 * 查询创新类活动详情
	 * @return
	 *//*
	@RequestMapping("findProInfo")
	public ModelAndView findProInfo(){
		logBefore(logger, "查询员工创新类日清列表");
		ModelAndView mv = new ModelAndView();
		PageData pd = this.getPageData();
		try {
			pd.put("taskType", Const.TASK_TYPE_C);//经营类为B，创新类为C
			//查询任务详情
			PageData eventPd = new PageData();
			eventPd.put("id", pd.get("eventId"));
			eventPd.put("status", Const.SYS_STATUS_YW_YSX);//用于查询活动分解的数量
			PageData projectEvent = empDailyTaskService.findProjectEventDetail(eventPd);
			//查询员工日清明细
			List<PageData> emptaskList = empDailyEventService.listEmptaskByProjectEventId(pd);
			//计划进度
			double planPercent = 0;
			SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
			Date startday = sdf.parse(projectEvent.getString("START_DATE"));
			Date endday = sdf.parse(projectEvent.getString("END_DATE"));
			//获取当前时间
			Date now = sdf.parse(sdf.format(new Date()));
			//计算任务天数
			double days = getDays(startday, endday);
			//计算已经过去的天数
			double pastDays = getDays(startday, now);
			//当前时间小于开始时间，计划进度为0；当前时间大于结束时间，计划进度返回1
			if(now.before(startday)){
				planPercent = 0;
			}else if(!now.before(endday)){
				planPercent = 100;
			}else{//计算计划进度
				planPercent  = new Double(pastDays/days).doubleValue() * 100;
			}
			//实际进度
			double actual_percent = 0;
			//已添加日清的进度
			double finish_percent = 0;
			for(int i=0; i<emptaskList.size(); i++){
				PageData empTask = emptaskList.get(i);
				String taskStatus = empTask.getString("STATUS_BIANMA");
				double taskPercent = new BigDecimal(emptaskList.get(i).get("FINISH_PERCENT").toString()).doubleValue();
				if(Const.SYS_STATUS_YW_YSX.equals(taskStatus)){//实际进度计算‘审核通过’的
					actual_percent += taskPercent;
				}else if(Const.SYS_STATUS_YW_YTH.equals(taskStatus)){//已退回的不计算在完成进度中
					continue;
				}
				finish_percent += taskPercent;
			}
			//进度的实际差值
			double taskDiff = 0;
			if(planPercent>finish_percent){
				taskDiff = planPercent-finish_percent;
			}
			//当前SPI
			double spi = 0;
			if(Double.compare(planPercent, 0)>0){
				spi = actual_percent/planPercent;
			}
			//预计完成时间
			String expectDate = projectEvent.getString("END_DATE");
			if(Double.compare(spi, 0)>0){
				Integer needDays = Integer.parseInt(new DecimalFormat("0").format(days/spi));
				Calendar cal = Calendar.getInstance();
				cal.setTime(startday);
				cal.add(Calendar.DATE, needDays-1);
				expectDate = sdf.format(cal.getTime());
			}
			
			projectEvent.put("expect_date", expectDate);
			projectEvent.put("spi", new DecimalFormat("0.00").format(spi));
			projectEvent.put("taskCount", new DecimalFormat("0.00").format(taskDiff));
			projectEvent.put("plan_percent", new DecimalFormat("0.00").format(planPercent));
			projectEvent.put("actual_percent", new DecimalFormat("0.00").format(actual_percent));
			//显示领导的日清批示列表
			List<PageData> commentList = empDailyEventService.listEventComment(pd);
			
			mv.addObject("commentList", commentList);
			mv.addObject("emptaskList", emptaskList);
			mv.addObject("projectEvent", projectEvent);
			
		} catch (Exception e) {
			mv.addObject("errorMsg", "查询员工创新类日清列表出错");
			logger.error("查询员工创新类日清列表出错", e);
		}
		String page = "currentPage=" + pd.get("currentPage") + "&showCount=" + pd.getString("showCount");
		pd.put("page", page);
		pd.put("taskTypeName", "2");
		mv.addObject("pd", pd);
		mv.setViewName("app/board/AppBoardDetail");
		return mv;
	}
	*//**
	 * 查询行政详情
	 * @return
	 *//*
	@RequestMapping(value="findManageInfo")
	public ModelAndView findManageInfo(){
		logBefore(logger, "查询员工行政日清列表");
		ModelAndView mv = new ModelAndView();
		PageData pd = this.getPageData();
		Subject currentUser = SecurityUtils.getSubject();
	    Session session = currentUser.getSession();
	    User user = (User)session.getAttribute(Const.SESSION_USER);
	    try {
			PageData searchPd = new PageData();
			searchPd.put("ID", pd.get("manageId").toString());
			PageData manageDailyTask = empDailyTaskService.find(searchPd);
			mv.addObject("manageDailyTask",manageDailyTask);
	        //通过员工CODE获得员工名，部门等基本信息
	        PageData positionSearchPd = new PageData();
	        positionSearchPd.put("EMP_CODE",user.getNUMBER());
	        PageData baseData = empDailyTaskService.findBaseDate(positionSearchPd);
	        baseData.put("DATE",new Date());
	        mv.addObject("baseData",baseData);
		} catch (Exception e) {
			logger.error(e.toString(),e);
		}
	    String page = "currentPage=" + pd.get("currentPage") + "&showCount=" + pd.getString("showCount");
		pd.put("page", page);
		pd.put("taskTypeName", "3");
	    mv.addObject("pd",pd);
	    mv.setViewName("app/board/AppBoardDetail");
		return mv;
	}
	*//**
	 * 行政详情查询
	 * @param manageId
	 * @param mv
	 * @param user
	 * @throws Exception 
	 *//*
	private void initDetailPage(String manageId,ModelAndView mv,User user) throws Exception{


     
	}
	*//**
	 * 查询日清列表
	 * @return
	 *//*
	@RequestMapping(value="findEmpInfo")
	public ModelAndView findEmpInfo(){
		logBefore(logger, "查询日清详情");
		ModelAndView mv = new ModelAndView();
		PageData pd = this.getPageData();
		try {
			if(pd.get("taskTypeName").toString().equals("1")){
				//周工作任务
				pd.put("taskType", Const.TASK_TYPE_B);//经营类为B，创新类为C
				//查询员工日清明细
				List<PageData> emptaskList = empDailyTaskService.listEmptaskByWeektaskId(pd);
				mv.addObject("emptaskList", emptaskList);
			}else if(pd.get("taskTypeName").toString().equals("2")){
				//创新活动类
				pd.put("taskType", Const.TASK_TYPE_C);//经营类为B，创新类为C
				//查询员工日清明细
				List<PageData> proTaskList = empDailyEventService.listEmptaskByProjectEventId(pd);
				mv.addObject("proTaskList", proTaskList);
			}else if(pd.get("taskTypeName").toString().equals("3")){
				//行政活动类
		        //通过ID获取行政日清细节列表
		        PageData detailSearchPd = new PageData();
		        detailSearchPd.put("daily_task_id",pd.get("manageId").toString());
		        List<PageData> detailList = empDailyTaskService.findDetailList(detailSearchPd);
		        mv.addObject("detailList",detailList);

		        //通过GRADE_CODE获取工作明细列表
		        PageData responseSearchPd = new PageData();
		        responseSearchPd.put("GRADE_CODE",pd.get("GRADE_CODE").toString());
		        List<PageData> responseList = empDailyTaskService.findResponseList(responseSearchPd);
		        mv.addObject("responseList",responseList);
			}
			
			mv.addObject("pd",pd);
			mv.setViewName("app/board/AppDailyTask");
		} catch (Exception e) {
			logger.error("查询日清列表出错",e);
		}
		return mv;
	}
	*//**
	 * 查询批示列表
	 * @return
	 *//*
	@RequestMapping(value="findComment")
	public ModelAndView findComment(){
		logBefore(logger, "查询批示详情");
		ModelAndView mv = new ModelAndView();
		PageData pd = this.getPageData();
		try {
			if(pd.get("taskTypeName").equals("1")){
				List<PageData> commentList = empDailyTaskService.listTaskComment(pd);
				mv.addObject("commentList", commentList);
			}else if(pd.get("taskTypeName").equals("2")){
				List<PageData> commentProList = empDailyEventService.listEventComment(pd);
				mv.addObject("commentProList",commentProList);
			}else if(pd.get("taskTypeName").equals("3")){
				   //通过ID获取批示记录
		        List<PageData> commentManList = empDailyTaskService.findComment(pd);
				mv.addObject("commentManList",commentManList);
			}

			mv.addObject("pd",pd);
			mv.setViewName("app/board/AppComment");
		} catch (Exception e) {
			logger.error("查询批示列表出错",e);
		}
		return mv;
	}
	*//**
	 * 获取计划进度
	 * @param startDate	任务开始时间
	 * @param endDate	任务结束时间
	 * @param taskTime	当前时间
	 *//*
	private double getPercent(String startDate, String endDate, String taskTime) throws Exception{
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
		Date startday = sdf.parse(startDate);
		Date endday = sdf.parse(endDate);
		//获取当前时间
		Date taskday = sdf.parse(taskTime);
		//计算任务天数
		double days = getDays(startday, endday);
		//计算已经过去的天数
		double pastDays = getDays(startday, taskday);
		//当前时间小于开始时间，计划进度为0；当前时间大于结束时间，计划进度返回1
		double planPercent = 0;
		if(taskday.before(startday)){
			planPercent = 0;
		}else if(!taskday.before(endday)){
			planPercent = 100;
		}else{//计算计划进度
			planPercent  = new Double(pastDays/days).doubleValue() * 100;
		}
		
		return planPercent;
	}
	*//**
	 * 计算间隔天数
	 *//*
	private double getDays(Date startday, Date endday){
		Calendar cal = Calendar.getInstance();
		//获取开始时间
		cal.setTime(startday);
		long starTtime = cal.getTimeInMillis();
		//获取结束时间
		cal.setTime(endday);
		long endTime = cal.getTimeInMillis();
		double days = (endTime - starTtime)/(1000*3600*24) + 1;
		
		return days;
	}
	*//**
	 * 周工作日清审核
	 * @return
	 *//*
	@ResponseBody
	@RequestMapping("validateDailyEmpTask")
	public String validateDailyEmpTask(){
		logBefore(logger, "周工作日清任务审核");
		try {
			PageData pd = this.getPageData();
			String isPass = pd.getString("isPass");
			if("1".equals(isPass)){//通过
				//计划进度
				double planPercent = getPercent(pd.getString("startDate"), pd.getString("endDate"), pd.getString("taskTime"));
				pd.put("status", Const.SYS_STATUS_YW_YSX);
				//查询已审批过的日清进度
				PageData actualPd = empDailyTaskService.findTaskActualPercent(pd);
				double actualPercent = new BigDecimal(actualPd.get("FINISH_PERCENT").toString()).doubleValue();
				if(Double.compare(actualPercent, planPercent)<0){//进度落后
					pd.put("isDelay", 1);
				}else{
					pd.put("isDelay", 0);
				}
				
				empDailyTaskService.updateDailyEmpTaskStatus(pd);
			}else{//退回
				pd.put("status", Const.SYS_STATUS_YW_YTH);
				empDailyTaskService.updateDailyEmpTaskStatus(pd);
			}
			
			userLogService.logInfo(new UserLog(getUser().getUSER_ID(), LogType.update, 
				"经营任务日清", "日清审核，状态改为：" + pd.getString("status")));
		} catch (Exception e) {
			logger.error("周工作日清任务审核出错", e);
			return "error";
		}
		return "success";
	}
	@ResponseBody
	@RequestMapping("validateEventEmpTask")
	public String validateEventEmpTask(){
		logBefore(logger, "创新活动日清-审核");
		try {
			User user = getUser();
			PageData pd = this.getPageData();
			PageData splitPd = new PageData();
			splitPd.put("empTaskId", pd.getString("id"));
			splitPd.put("user", user.getNAME());
			splitPd.put("time", new Date());
			String isPass = pd.getString("isPass");
			if("1".equals(isPass)){//通过
				//计划进度
				double planPercent = getPercent(pd.getString("startDate"), pd.getString("endDate"), pd.getString("taskTime"));
				pd.put("status", Const.SYS_STATUS_YW_YSX);
				//查询已审批过的日清进度
				PageData actualPd = empDailyEventService.findEventActualPercent(pd);
				double actualPercent = new BigDecimal(actualPd.get("FINISH_PERCENT").toString()).doubleValue();
				if(Double.compare(actualPercent, planPercent)<0){//进度落后
					pd.put("isDelay", 1);
				}else{
					pd.put("isDelay", 0);
				}
				splitPd.put("isFinish", 1);
			}else{//退回
				pd.put("status", Const.SYS_STATUS_YW_YTH);
				splitPd.put("isFinish", 0);
			}
			//更新活动日清
			empDailyEventService.updateEventEmpTaskStatus(pd);
			//更新活动分解项
			empDailyEventService.updateEventSplit(splitPd);
			
			userLogService.logInfo(new UserLog(getUser().getUSER_ID(), LogType.update, 
				"创新活动日清", "日清审核，状态改为：" + pd.getString("status")));
		} catch (Exception e) {
			logger.error("创新活动日清-审核出错", e);
			return "error";
		}
		return "success";
	}
	
	*//**
	 * 进入日清批示页面
	 * @return
	 *//*
	@RequestMapping(value="addComment")
	public ModelAndView addComment(){
		logBefore(logger, "进入添加日清批示页面");
		ModelAndView mv = new ModelAndView();
		PageData pd = this.getPageData();
		mv.addObject("pd",pd);
		mv.setViewName("app/board/AppCommentAdd");
		return mv;
	}
	
	*//**
	 * 添加批示
	 * @return
	 *//*
	@RequestMapping(value="doAdd")
	public void doAdd(PrintWriter out){
		logBefore(logger, "添加批示");
		
		try {
			User user = getUser();
			PageData pd = this.getPageData();
			pd.put("isDel", 0);
			pd.put("createUser", user.getNAME());
			pd.put("createDate", new Date());
			pd.put("weekTaskId", pd.get("weekEmpTaskId").toString());
			empDailyTaskService.saveTaskComment(pd);
			out.write("1");
		} catch (Exception e) {
			logger.error("添加批示出错",e);
		}
	}
	
	*//**
	 * 添加批示
	 * @return
	 *//*
	@RequestMapping(value="doProAdd")
	public void doProAdd(PrintWriter out){
		logBefore(logger, "添加批示");
		
		try {
			User user = getUser();
			PageData pd = this.getPageData();
			pd.put("isDel", 0);
			pd.put("createUser", user.getNAME());
			pd.put("createDate", new Date());
			empDailyEventService.saveEventComment(pd);
			out.write("1");
		} catch (Exception e) {
			logger.error("添加批示出错",e);
		}
	}
	*//**
	 * 添加批示
	 * @return
	 *//*
	@RequestMapping(value="doManAdd")
	public void doManAdd(PrintWriter out){
		logBefore(logger, "添加批示");
		try {
			User user = getUser();
			PageData pd = this.getPageData();
			pd.put("createUser", user.getNAME());
			pd.put("createDate", new Date());
			empDailyTaskService.saveManageComment(pd);
			out.write("1");
		} catch (Exception e) {
			logger.error("添加批示出错",e);
		}
	}
	*//**
	 * 订单下滑加载列表
	 *//*
	@RequestMapping(value="scrollNextPage",produces = "text/html;charset=UTF-8")
	public void scrollNextPage(HttpServletResponse response,Page page){
		logBefore(logger, "列表下滑加载");
		Map<String, Object> map = new HashMap<String, Object>();
		PageData pd = new PageData();
		try {
			pd = this.getPageData();
			// 不显示草稿状态
			pd.put("useStatus", Const.SYS_STATUS_YW_CG);
			page.setPd(pd);
			if(pd.getString("taskTypeName").equals("1")){
				// 查询周工作任务
				List<PageData> taskList = empDailyTaskService.empWeekTasklistPage(page);
				for(PageData data:taskList){
					if(!String.valueOf(data.get("ID")).equals(null)&&!String.valueOf(data.get("ID")).equals("")){
						data.put("ID", String.valueOf(data.get("ID")));
					}
					if(!String.valueOf(data.get("WEEK_COUNT")).equals(null)&&!String.valueOf(data.get("WEEK_COUNT")).equals("")){
						data.put("WEEK_COUNT", String.valueOf(data.get("WEEK_COUNT")));
					}
					if(!String.valueOf(data.get("WEEK_START_DATE")).equals(null)&&!String.valueOf(data.get("WEEK_START_DATE")).equals("")){
						data.put("WEEK_START_DATE", String.valueOf(data.get("WEEK_START_DATE")));
					}
					if(!String.valueOf(data.get("WEEK_END_DATE")).equals(null)&&!String.valueOf(data.get("WEEK_END_DATE")).equals("")){
						data.put("WEEK_END_DATE", String.valueOf(data.get("WEEK_END_DATE")));
					}
					if(!String.valueOf(data.get("actual_percent")).equals(null)&&!String.valueOf(data.get("actual_percent")).equals("")){
						data.put("actual_percent", String.valueOf(data.get("actual_percent")));
					}
					if(!String.valueOf(data.get("plan_percent")).equals(null)&&!String.valueOf(data.get("plan_percent")).equals("")){
						data.put("plan_percent", String.valueOf(data.get("plan_percent")));
					}
				}
				map.put("weekList", taskList);
			}
			if(pd.getString("taskTypeName").equals("2")){
				//查询创新活动
				List<PageData> taskList = empDailyTaskService.empProjectEventlistPage(page);
				for(PageData data:taskList){
					if(!String.valueOf(data.get("ID")).equals(null)&&!String.valueOf(data.get("ID")).equals("")){
						data.put("ID", String.valueOf(data.get("ID")));
					}
					if(!String.valueOf(data.get("WEIGHT")).equals(null)&&!String.valueOf(data.get("WEIGHT")).equals("")){
						data.put("WEIGHT", String.valueOf(data.get("WEIGHT")));
					}
					if(!String.valueOf(data.get("START_DATE")).equals(null)&&!String.valueOf(data.get("START_DATE")).equals("")){
						data.put("START_DATE", String.valueOf(data.get("START_DATE")));
					}
					if(!String.valueOf(data.get("END_DATE")).equals(null)&&!String.valueOf(data.get("END_DATE")).equals("")){
						data.put("END_DATE", String.valueOf(data.get("END_DATE")));
					}
					if(!String.valueOf(data.get("actual_percent")).equals(null)&&!String.valueOf(data.get("actual_percent")).equals("")){
						data.put("actual_percent", String.valueOf(data.get("actual_percent")));
					}
					if(!String.valueOf(data.get("plan_percent")).equals(null)&&!String.valueOf(data.get("plan_percent")).equals("")){
						data.put("plan_percent", String.valueOf(data.get("plan_percent")));
					}
				}
				map.put("taskList", taskList);
			}			
			if(pd.getString("taskTypeName").equals("3")){
				//查询行政任务
				List<PageData> taskList = empDailyTaskService.empProjectManagelistPage(page);
				for(PageData data:taskList){
					if(!String.valueOf(data.get("ID")).equals(null)&&!String.valueOf(data.get("ID")).equals("")){
						data.put("ID", String.valueOf(data.get("ID")));
					}
					if(!String.valueOf(data.get("DATETIME")).equals(null)&&!String.valueOf(data.get("DATETIME")).equals("")){
						data.put("DATETIME", String.valueOf(data.get("DATETIME")));
					}
				}
				map.put("taskList", taskList);
			}
			map.put("taskTypeName", pd.getString("taskTypeName"));
			JSONObject jo = JSONObject.fromObject(map);
			String json = jo.toString();
			response.setCharacterEncoding("UTF-8");
			response.setContentType("text/html");
			PrintWriter out = response.getWriter();
			out.write(json);
			out.flush();
			out.close();
		} catch (Exception e) {
			logger.error("日清任务列表下滑加载出错", e);
		}
	}
	@ResponseBody
	@RequestMapping(value="findDeptEmp",produces = "text/html;charset=UTF-8")
	public String findDeptEmp(String deptId, CommonService commonService){
		//查询部门员工
		List<PageData> empList;
		try {
			if(deptId.contains(",")){
				String[] idArr = deptId.split(",");
				List<Integer> deptIds =new ArrayList<Integer>();
				for(String id : idArr){
					deptIds.add(Integer.valueOf(id));
				}
				empList = employeeService.findEmpByDeptIds(deptIds);
			}else{
				empList = employeeService.findEmpByDept(deptId);
			}
			
			JSONArray array = JSONArray.fromObject(empList);
			return array.toString();
		} catch (Exception e) {
			logger.error("查询部门员工出错", e);
			return "error";
		}
	}
*/}
