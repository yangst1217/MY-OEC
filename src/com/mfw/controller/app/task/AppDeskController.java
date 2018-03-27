package com.mfw.controller.app.task;


import com.mfw.controller.base.BaseController;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
@RequestMapping(value="/app_desk")
public class AppDeskController extends BaseController{/*
	@Resource(name="empDailyEventService")
	private EmpDailyEventService empDailyEventService;
	@Resource(name = "commonService")
	private CommonService commonService;
	@Resource(name="userLogService")
	private UserLogService userLogService;
	@Resource(name="taskFileService")
	private TaskFileService taskFileService;
	@Resource(name="empDailyTaskService")
	private EmpDailyTaskService empDailyTaskService;
	String test = "RQKB";
	
	@RequestMapping("listDesk")
	public ModelAndView listDesk(Page page){
		logBefore(logger, "查询任务列表");
		ModelAndView mv = this.getModelAndView();
		List<PageData> taskList = new ArrayList<PageData>();
		List<PageData> eventList = new ArrayList<PageData>();
		List<PageData> productList = new ArrayList<PageData>();//产品列表
		List<PageData> projectList = new ArrayList<PageData>();//项目列表
		List<PageData> manageList = new ArrayList<PageData>();//行政任务列表
		List<PageData> modellist = new ArrayList<PageData>();//任务类型列表
		
		PageData pd = this.getPageData();
		try {
			User user = getUser();
			String empCode = user.getNUMBER();
			
			//查询产品列表
			productList = empDailyTaskService.findProductByEmp(empCode);
			//查询项目列表
			projectList = empDailyTaskService.findProjectByEmp(empCode);
			if(pd.get("taskTypeName")==null || pd.get("taskTypeName").equals(""))
			{
				pd.put("taskTypeName", "周工作任务");
				pd.put("taskType", "1");
			}			
			pd.put("empCode", empCode);
			pd.put("useStatus", Const.SYS_STATUS_YW_CG);
			page.setPd(pd);
			//用于查询创新活动
			Page proPage = new Page();
			if(null != pd.get("currentPage")){
				proPage.setCurrentPage(Integer.parseInt(pd.getString("currentPage")));
				proPage.setShowCount(Integer.parseInt(pd.getString("showCount")));
			}
			proPage.setPd(pd);
			
			modellist = commonService.typeListByBm(test);
			
			if(pd.get("taskTypeName").equals("周工作任务"))
			{
			//查询周工作任务
			taskList = empDailyTaskService.empWeekTasklistPage(page);
			pd.put("taskType", "1");
			}
			if(pd.get("taskTypeName").equals("创新类活动"))
			{
			//查询创新活动
			eventList = empDailyTaskService.empProjectEventlistPage(page);
			pd.put("taskType", "2");
			}
			if(pd.get("taskTypeName").equals("行政类活动"))
			{
			//查询行政任务
			manageList = empDailyTaskService.empProjectManagelistPage(page);
			pd.put("taskType", "3");
			}
			
			if(proPage.getTotalResult()>page.getTotalResult()){
				page = proPage;
			}
			
			
		} catch (Exception e) {
			mv.addObject("errorMsg", "查询任务列表出错");
			logger.error("查询任务列表出错", e);
		}
		 
		mv.addObject("modellist", modellist);
		mv.addObject("productList", productList);
		mv.addObject("projectList", projectList);
		mv.addObject("taskList", taskList);
		mv.addObject("eventList", eventList);
		mv.addObject("manageList",manageList);
		mv.addObject("pd", pd);
		mv.addObject("page", page);
		mv.setViewName("app/desk/appDesk");
		return mv;
	}
	
	
	*//**
	 * 去周工作明细页面
	 *//*
	@RequestMapping(value = "/showTaskDetail")
	public ModelAndView showTaskDetail(Page page) throws Exception {
		logBefore(logger, "查询周工作日清列表");
		ModelAndView mv = new ModelAndView();
		PageData pd = this.getPageData();
		try {
			pd.put("taskType", Const.TASK_TYPE_B);//经营类为B，创新类为C
			//查询周工作详情
			PageData weekTaskPd = new PageData();
			pd.put("weekEmpTaskId", pd.get("id"));
			weekTaskPd.put("id", pd.get("id"));
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
				String bigDecimal = emptaskList.get(i).get("FINISH_PERCENT").toString();
				if(bigDecimal == null|| bigDecimal =="")
				{
					bigDecimal = "0";
				}
				double taskPercent = new BigDecimal(bigDecimal).doubleValue();
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
			List<PageData> commentList = empDailyTaskService.listTaskComment(pd);
			
			mv.addObject("commentList", commentList);
			mv.addObject("emptaskList", emptaskList);
			mv.addObject("weekTask", weekTask);
			
		} catch (Exception e) {
			mv.addObject("errorMsg", "查询员工经营类日清列表出错");
			logger.error("查询员工经营类日清列表出错", e);
		}
		String page1 = "currentPage=" + pd.get("currentPage") + "&showCount=" + pd.getString("showCount");
		pd.put("page", page1);
		pd.put("taskTypeName", "周工作任务");
		pd.put("taskType", "1");
		mv.addObject("pd", pd);
		mv.setViewName("app/desk/appTaskDetail");
		return mv;
	}
	
	
	*//**
	 * 去周工作批示页面
	 *//*
	@RequestMapping(value = "/taskComment")
	public ModelAndView taskComment(Page page) throws Exception {
		logBefore(logger, "查询员周工作日清列表");
		ModelAndView mv = new ModelAndView();
		PageData pd = this.getPageData();
		try {
			
			//查询周工作详情
			PageData weekTaskPd = new PageData();
			pd.put("weekEmpTaskId", pd.get("id"));
			weekTaskPd.put("id", pd.get("id"));

			List<PageData> commentList = empDailyTaskService.listTaskComment(pd);
			
			mv.addObject("commentList", commentList);
			
		} catch (Exception e) {
			mv.addObject("errorMsg", "查询员工经营类日清列表出错");
			logger.error("查询员工经营类日清列表出错", e);
		}

		mv.addObject("pd", pd);
		mv.setViewName("app/desk/appTaskComment");
		return mv;
	}
	
	*//**
	 * 删除周工作日清
	 *//*
	@ResponseBody
	@RequestMapping("deleteTaskDetail")
	public String deleteTaskDetail(){
		logBefore(logger, "删除周工作日清任务");
		try {
			PageData pd = this.getPageData();
			empDailyTaskService.delDailyEmpTask(pd);
			userLogService.logInfo(new UserLog(getUser().getUSER_ID(), LogType.update, 
				"周工作日清", "逻辑删除id=" + pd.getString("id") + "，更新删除字段"));
		} catch (Exception e) {
			logger.error("删除周工作日清任务出错", e);
			return "error";
		}
		return "success";
	}
	
	
	
	*//**
	 * 去周工作日清界面
	 *//*
	@RequestMapping(value = "/taskAnalyze")
	public ModelAndView taskAnalyze(Page page) throws Exception {
		logBefore(logger, "查询员周工作日清列表");
		ModelAndView mv = new ModelAndView();
		PageData pd = this.getPageData();
		try {
			pd.put("taskType", Const.TASK_TYPE_B);//经营类为B，创新类为C
			//查询周工作详情
			PageData weekTaskPd = new PageData();
			pd.put("weekEmpTaskId", pd.get("id"));
			weekTaskPd.put("id", pd.get("id"));
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
				String bigDecimal = emptaskList.get(i).get("FINISH_PERCENT").toString();
				if(bigDecimal == null|| bigDecimal =="")
				{
					bigDecimal = "0";
				}
				double taskPercent = new BigDecimal(bigDecimal).doubleValue();
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
			List<PageData> commentList = empDailyTaskService.listTaskComment(pd);
			
			mv.addObject("commentList", commentList);
			mv.addObject("emptaskList", emptaskList);
			mv.addObject("weekTask", weekTask);
			
		} catch (Exception e) {
			mv.addObject("errorMsg", "查询员工经营类日清列表出错");
			logger.error("查询员工经营类日清列表出错", e);
		}
		String page1 = "currentPage=" + pd.get("currentPage") + "&showCount=" + pd.getString("showCount");
		pd.put("page", page1);
		pd.put("taskTypeName", "周工作任务");
		mv.addObject("pd", pd);
		mv.setViewName("app/desk/appTaskAnalyze");
		return mv;
	}
	*//**
	 * 保存周任务日清页面
	 *//*
	@RequestMapping("toAddDailyTask")
	public ModelAndView toAddDailyTask(){
		logBefore(logger, "跳转到周工作日清添加界面");
		ModelAndView mv = this.getModelAndView();
		PageData pd = this.getPageData();
		mv.setViewName("app/desk/appAddDailyTaskAnalyze");
		mv.addObject("pd", pd);
		return mv;
	}
	
	*//**
	 * 保存创新类活动日清页面
	 *//*
	@RequestMapping("toAddEventTask")
	public ModelAndView toAddEventTask(){		
		logBefore(logger, "跳转到创新活动日清添加界面");
		ModelAndView mv = this.getModelAndView();
		PageData pd = this.getPageData();
		//查询创新活动分解列表
		pd.put("status", Const.SYS_STATUS_YW_YSX);
		try {
			List<PageData> splitList = empDailyEventService.listUnfinishEventSplit(pd);
			mv.addObject("splitList", splitList);
		} catch (Exception e) {
			logger.error("查询创新活动分解列表出错", e);
		}
		
		mv.setViewName("app/desk/appAddEventAnalyze");
		mv.addObject("pd", pd);
		return mv;
	}
	
	*//**
	 * 上传文档
	 *//*	
	@ResponseBody
	@RequestMapping(value = "/appCompleteWithFile")
	public String appCompleteWithFile(@RequestParam(value = "file", required = false)MultipartFile file, 
			HttpServletRequest request){
//		ModelAndView mv = this.getModelAndView();
		PageData pd = new PageData(request);
		String type = pd.getString("type");
		try {
			//上传文件
			if(null != file && !file.isEmpty()){
				logBefore(logger, "开始上传文件"); 
				String path = request.getSession().getServletContext().getRealPath("upload");  
				String fileName = new Date().getTime() + "_" + file.getOriginalFilename();
				File targetFile = new File(path, fileName);
				if(!targetFile.exists()){  
					targetFile.mkdirs();  
				}
				//保存  
				try {  
				    file.transferTo(targetFile);
				    logAfter(logger);
				} catch (Exception e) {  
				   logger.error("上传文件出错", e);
				   return "error";
				}
				pd.put("fileName", fileName);
			}
			if(type == "1"||type.equals("1")){
				saveDailyTask(pd);
			}
			if(type == "2"||type.equals("2")){
				saveEventTask(pd);
			}
			
		} catch (Exception e) {
			logger.error("确认完成出错", e);
			return "error";
		}
		return "success";
	}
	
	*//**
	 * 保存创新类活动日清
	 *//*	
	@RequestMapping(value="/saveEventTask")
	@ResponseBody
	private void saveEventTask(PageData pd) throws Exception{
			User user = getUser();
			//本次完成百分比
			Double d = new Double(pd.getString("finishPercent"));
			String finishPercent = String.format("%.2f", d.doubleValue());
			String fileName = pd.getString("fileName");
			pd.put("finishPercent", finishPercent);
			pd.put("status", Const.SYS_STATUS_YW_CG);//草稿状态
			pd.put("isDel", 0);
			pd.put("user", user.getNAME());
			pd.put("time", new Date());
			pd.put("preparation1", pd.get("splitNames"));//完成的活动名称
			//保存日清
			empDailyEventService.saveEventEmpTask(pd);
			String id = pd.get("id").toString();
			userLogService.logInfo(new UserLog(getUser().getUSER_ID(), LogType.add, "创新活动日清", "新增日清id=" + id));
			//更新活动分解项为已完成
			String eventSplitIds = pd.getString("eventSplitIds");
			PageData splitPd = new PageData();
			splitPd.put("eventSplitIdArr", eventSplitIds.split(","));
			splitPd.put("empTaskId", id);
			splitPd.put("user", user.getNAME());
			splitPd.put("time", new Date());
			empDailyEventService.finishEventSplit(splitPd);
			//上传附件
			
			if(null != fileName && fileName!=""){
				logBefore(logger, "开始上传文件"); 
				saveTaskFile(fileName, Const.TASK_TYPE_C, id, user.getUSERNAME());
			}

	}
	
	
	*//**
	 * 保存周工作日清
	 *//*
	@RequestMapping(value="/saveDailyTask")
	@ResponseBody
	private void saveDailyTask(PageData pd) throws Exception{

		User user = getUser();
		String finishPercent =new String();
		String dailyCount = pd.getString("dailyCount");
		String weekCount = pd.getString("weekCount");
//		String endDate = pd.getString("endDate");
		String fileName = pd.getString("fileName");
		//计算本次完成百分比
		double d1 = new Double(dailyCount).doubleValue();
		double d2 = new Double(weekCount).doubleValue();
		if(d2 == 0)
		{ 
			finishPercent = "0";
		}
		else{
			finishPercent = new DecimalFormat("0.00").format(new Double(d1/d2).doubleValue()*100);
		}
		pd.put("finishPercent", finishPercent);
		pd.put("status", Const.SYS_STATUS_YW_CG);//草稿状态
		pd.put("isDel", 0);
		pd.put("user", user.getNAME());
		pd.put("time", new Date());
		pd.put("isDelay", 0);
		
		
		empDailyTaskService.saveDailyEmpTask(pd);
		String id = pd.get("id").toString();
		userLogService.logInfo(new UserLog(getUser().getUSER_ID(), LogType.add, "周任务日清", "新增日清id=" + id));
		
		if(null != fileName && fileName!=""){
			logBefore(logger, "开始上传文件"); 
			saveTaskFile(fileName, Const.TASK_TYPE_B, id, user.getUSERNAME());
		}
	}
	
	
	@RequestMapping("saveDailyTask")
	public  ModelAndView saveDailyTask(@RequestParam(required=false) MultipartFile file, HttpServletRequest request){
		logBefore(logger, "保存周工作任务日清");
		ModelAndView mv = this.getModelAndView();
		
		try {
			PageData pd = new PageData(request);
			User user = getUser();
			String dailyCount = pd.getString("dailyCount");
			String weekCount = pd.getString("weekCount");
//			String endDate = pd.getString("endDate");
			
			//计算本次完成百分比
			double d1 = new Double(dailyCount).doubleValue();
			double d2 = new Double(weekCount).doubleValue();
			String finishPercent = new DecimalFormat("0.00").format(new Double(d1/d2).doubleValue()*100);

			pd.put("finishPercent", finishPercent);
			pd.put("status", Const.SYS_STATUS_YW_CG);//草稿状态
			pd.put("isDel", 0);
			pd.put("user", user.getNAME());
			pd.put("time", new Date());
			
			empDailyTaskService.saveDailyEmpTask(pd);
			String id = pd.get("id").toString();
			userLogService.logInfo(new UserLog(getUser().getUSER_ID(), LogType.add, "经营任务日清", "新增日清id=" + id));
			//上传附件
			if(null != file && !file.isEmpty()){
				logBefore(logger, "开始上传文件"); 
				String fileName = FileUpload.uploadFile(request, file, Const.FILEPATHTASK);
				saveTaskFile(fileName, Const.TASK_FILE_TYPE_B, id, user.getUSERNAME());
			}
			mv.addObject("msg", "success");
		} catch (Exception e) {
			mv.addObject("msg", "保存周工作任务日清出错");
			logger.error("保存周工作任务日清出错", e);
		}
		mv.setViewName("save_result");
		return mv;
	}
	
	*//**
	 * 去行政类活动明细页面
	 *//*
	@RequestMapping(value="showManageDetail")
	public ModelAndView showManageDetail(){
		logBefore(logger, "查询员工行政日清列表");
		ModelAndView mv = new ModelAndView();
		PageData pd = this.getPageData();
		
		Subject currentUser = SecurityUtils.getSubject();
	    Session session = currentUser.getSession();
	    User user = (User)session.getAttribute(Const.SESSION_USER);
	    try {
			initDetailPage(this.getPageData().get("id").toString(),mv,user);
		} catch (Exception e) {
			logger.error(e.toString(),e);
		}
	    pd.put("taskTypeName", "行政类活动");
	    pd.put("taskType", "3");
	    mv.addObject("pd",pd);
	    mv.setViewName("app/desk/appManageDetail");
		return mv;
	}
	
	*//**
	 * 查看行政类活动分解
	 *//*
	@RequestMapping(value="manageAnalyze")
	public ModelAndView manageAnalyze(){
		logBefore(logger, "查询员工行政日清列表");
		ModelAndView mv = new ModelAndView();
		PageData pd = this.getPageData();
		
		Subject currentUser = SecurityUtils.getSubject();
	    Session session = currentUser.getSession();
	    User user = (User)session.getAttribute(Const.SESSION_USER);
	    try {
			initDetailPage(this.getPageData().get("id").toString(),mv,user);
		} catch (Exception e) {
			logger.error(e.toString(),e);
		}
	    pd.put("taskTypeName", "行政类活动");
	    mv.addObject("pd",pd);
	    mv.setViewName("app/desk/appManageAnalyze");
		return mv;
	}
	
	*//**
	 * 查看行政类活动批示
	 *//*
	@RequestMapping(value="manageComment")
	public ModelAndView manageComment(){
		logBefore(logger, "查询员工行政日清列表");
		ModelAndView mv = new ModelAndView();
		PageData pd = this.getPageData();
		
		Subject currentUser = SecurityUtils.getSubject();
	    Session session = currentUser.getSession();
	    User user = (User)session.getAttribute(Const.SESSION_USER);
	    try {
			initDetailPage(this.getPageData().get("id").toString(),mv,user);
		} catch (Exception e) {
			logger.error(e.toString(),e);
		}
	    pd.put("taskTypeName", "行政类活动");
	    mv.addObject("pd",pd);
	    mv.setViewName("app/desk/appManageComment");
		return mv;
	}
	
	*//**
	 * 查看创新类活动
	 *//*
	@RequestMapping("showEventDetail")
	public ModelAndView showEventDetail(){
		logBefore(logger, "查询员工创新类日清列表");
		ModelAndView mv = new ModelAndView();
		PageData pd = this.getPageData();
		try {
			pd.put("taskType", Const.TASK_TYPE_C);//经营类为B，创新类为C
			//查询任务详情
			PageData eventPd = new PageData();
			eventPd.put("id", pd.get("id"));
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
				String bigDecimal = emptaskList.get(i).get("FINISH_PERCENT").toString();
				if(bigDecimal == null|| bigDecimal =="")
				{
					bigDecimal = "0";
				}
				double taskPercent = new BigDecimal(bigDecimal).doubleValue();
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
		String page1 = "currentPage=" + pd.get("currentPage") + "&showCount=" + pd.getString("showCount");
		pd.put("page", page1);
		pd.put("taskTypeName", "创新类活动");
		pd.put("taskType", "2");
		mv.addObject("pd", pd);
		mv.setViewName("app/desk/appEventDetail");
		return mv;
	}
	
	*//**
	 * 查看创新类活动日清
	 *//*
	@RequestMapping("eventAnalyze")
	public ModelAndView eventAnalyze(){
		logBefore(logger, "查询员工创新类日清列表");
		ModelAndView mv = new ModelAndView();
		PageData pd = this.getPageData();
		try {
			pd.put("taskType", Const.TASK_TYPE_C);//经营类为B，创新类为C
			//查询任务详情
			PageData eventPd = new PageData();
			eventPd.put("id", pd.get("id"));
			pd.put("eventId", pd.get("id"));
			
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
				String bigDecimal = emptaskList.get(i).get("FINISH_PERCENT").toString();
				if(bigDecimal == null|| bigDecimal =="")
				{
					bigDecimal = "0";
				}
				double taskPercent = new BigDecimal(bigDecimal).doubleValue();
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
		String page1 = "currentPage=" + pd.get("currentPage") + "&showCount=" + pd.getString("showCount");
		pd.put("page", page1);
		pd.put("taskTypeName", "创新类活动");
		mv.addObject("pd", pd);
		mv.setViewName("app/desk/appEventAnalyze");
		return mv;
	}
	
	
	*//**
	 * 查看创新类活动批示
	 *//*
	@RequestMapping("eventComment")
	public ModelAndView eventComment(){
		logBefore(logger, "查询员工创新类日清列表");
		ModelAndView mv = new ModelAndView();
		PageData pd = this.getPageData();
		try {
			pd.put("taskType", Const.TASK_TYPE_C);//经营类为B，创新类为C
			//查询任务详情
			PageData eventPd = new PageData();
			eventPd.put("id", pd.get("id"));
			
			//显示领导的日清批示列表
			List<PageData> commentList = empDailyEventService.listEventComment(pd);
			
			mv.addObject("commentList", commentList);

			
		} catch (Exception e) {
			mv.addObject("errorMsg", "查询员工创新类日清列表出错");
			logger.error("查询员工创新类日清列表出错", e);
		}
		String page1 = "currentPage=" + pd.get("currentPage") + "&showCount=" + pd.getString("showCount");
		pd.put("page", page1);
		pd.put("taskTypeName", "创新类活动");
		mv.addObject("pd", pd);
		mv.setViewName("app/desk/appEventComment");
		return mv;
	}
	
	
	@ResponseBody
	@RequestMapping("deleteEventTask")
	public String deleteEventEmpTask(){
		logBefore(logger, "删除创新活动日清任务");
		try {
			PageData pd = this.getPageData();
			empDailyEventService.deleteEventEmpTask(pd);
			User user = getUser();
			userLogService.logInfo(new UserLog(user.getUSER_ID(), LogType.update, 
					"创新活动日清", "逻辑删除id=" + pd.getString("id") + "，更新删除字段"));
			//删除时，需要修改活动分解项
			PageData splitPd = new PageData();
			splitPd.put("empTaskId", pd.getString("id"));
			splitPd.put("isFinish", 0);
			splitPd.put("user", user.getNAME());
			splitPd.put("time", new Date());
			empDailyEventService.updateEventSplit(splitPd);
		} catch (Exception e) {
			logger.error("删除创新活动日清任务出错", e);
			return "error";
		}
		return "success";
	}
	*//**
	 * 初始化细节页面
	 * @param manageId
	 * @param mv
	 * @param user
	 * @throws Exception 
	 *//*
	private void initDetailPage(String manageId,ModelAndView mv,User user) throws Exception{
		PageData searchPd = new PageData();
		searchPd.put("ID", manageId);
		PageData manageDailyTask = empDailyTaskService.find(searchPd);
		mv.addObject("manageDailyTask",manageDailyTask);
        //通过ID获取行政日清细节列表
        PageData detailSearchPd = new PageData();
        detailSearchPd.put("daily_task_id",manageId);
        List<PageData> detailList = empDailyTaskService.findDetailList(detailSearchPd);
        mv.addObject("detailList",detailList);
        //通过员工CODE获得员工名，部门等基本信息
        PageData positionSearchPd = new PageData();
        positionSearchPd.put("EMP_CODE",user.getNUMBER());
        PageData baseData = empDailyTaskService.findBaseDate(positionSearchPd);
        baseData.put("DATE",new Date());
        mv.addObject("baseData",baseData);
        //通过GRADE_CODE获取工作明细列表
        PageData responseSearchPd = new PageData();
        responseSearchPd.put("GRADE_CODE",baseData.get("GRADE_CODE"));
        List<PageData> responseList = empDailyTaskService.findResponseList(responseSearchPd);
        mv.addObject("responseList",responseList);
        //通过ID获取批示记录
        PageData comPd = new PageData();
        comPd.put("manage_id", manageId);
        List<PageData> comList = empDailyTaskService.findComment(comPd);
        mv.addObject("infoList",comList);
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
	
	
	
	@ResponseBody
	@RequestMapping("checkFile")
	public String checkFile(String fileName, HttpServletRequest request){
		try {
			String name = new String(fileName.getBytes("iso8859-1"), "UTF-8");
			String filePath = request.getSession().getServletContext().getRealPath(Const.FILEPATHTASK) + "\\" + name;
			File f = new File(filePath);
			if (!f.exists()) {
				logger.error("附件不存在");
				return "";
			}else{
				return filePath;
			}
		} catch (UnsupportedEncodingException e) {
			logger.error("获取文件名称出错", e);
			return "";
		}
	}
	
	
	@RequestMapping("loadFile")
	public void loadFile(String fileName, HttpServletRequest request, HttpServletResponse response) throws Exception{
		logBefore(logger, "下载附件");
		try {
			String name = new String(fileName.getBytes("iso8859-1"), "UTF-8");
			String path = request.getSession().getServletContext().getRealPath(Const.FILEPATHTASK) + "\\" + name;
			
			FileDownload.fileDownload(response, path, name);
		} catch (Exception e) {
			logger.error("下载附件出错", e);
		}
	}
	
	
	*//**
	 * 保存任务日清时上传的附件
	 *//*
	private void saveTaskFile(String fileName, String taskType, String taskId, String userName) throws Exception{
		PageData filePd = new PageData();
		filePd.put("fileName", fileName);
		filePd.put("taskType", taskType);
		filePd.put("taskId", taskId);
		filePd.put("createUser", userName);
		filePd.put("createDate", new Date());
		taskFileService.saveFile(filePd);
	}
	
	
	
	
	*//**
	 * 下滑加载列表
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
			
			
			User user = getUser();
			String empCode = user.getNUMBER();			
			pd.put("empCode", empCode);
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
				map.put("taskList", taskList);
				map.put("taskType", "1");
				map.put("taskTypeName", "周工作任务");
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
				map.put("taskType", "2");
				map.put("taskTypeName", "创新类活动");
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
				map.put("taskType", "3");
				map.put("taskTypeName", "行政类活动");
			}
			
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

*/}
