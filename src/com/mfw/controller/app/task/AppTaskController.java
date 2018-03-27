package com.mfw.controller.app.task;

import java.io.BufferedInputStream;
import java.io.BufferedOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.io.PrintWriter;
import java.math.BigDecimal;
import java.net.URLEncoder;
import java.text.DecimalFormat;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Properties;
import java.util.zip.ZipEntry;
import java.util.zip.ZipOutputStream;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.shiro.SecurityUtils;
import org.apache.shiro.session.Session;
import org.apache.shiro.subject.Subject;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.ModelAndView;

import com.google.gson.Gson;
import com.mfw.controller.base.BaseController;
import com.mfw.entity.Page;
import com.mfw.entity.system.User;
import com.mfw.entity.system.UserLog;
import com.mfw.entity.system.UserLog.LogType;
import com.mfw.service.bdata.CommonService;
import com.mfw.service.bdata.DeptService;
import com.mfw.service.bdata.EmployeeService;
import com.mfw.service.bdata.PositionDutyService;
import com.mfw.service.bdata.PositionLevelService;
import com.mfw.service.dailytask.PositionDailyTaskService;
import com.mfw.service.dailytask.WorkEntryService;
import com.mfw.service.flow.FlowWorkService;
import com.mfw.service.system.UserLogService;
import com.mfw.service.system.datarole.DataRoleService;
import com.mfw.service.task.EmpDailyEventService;
import com.mfw.service.task.EmpDailyTaskService;
import com.mfw.service.task.FlowTaskService;
import com.mfw.service.task.TaskFileService;
import com.mfw.util.AppUtil;
import com.mfw.util.Const;
import com.mfw.util.FileDownload;
import com.mfw.util.FileUpload;
import com.mfw.util.PageData;
import com.mfw.util.PathUtil;
import com.mfw.util.Tools;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;
@Controller
@RequestMapping(value="/app_task")
public class AppTaskController extends BaseController{
	@Resource(name="empDailyTaskService")
	private EmpDailyTaskService empDailyTaskService;
	@Resource(name = "commonService")
	private CommonService commonService;
	@Resource(name="empDailyEventService")
	private EmpDailyEventService empDailyEventService;
	@Resource(name="userLogService")
	private UserLogService userLogService;
	@Resource(name="taskFileService")
	private TaskFileService taskFileService;
	@Resource(name="employeeService")
	private EmployeeService employeeService;
	@Resource(name="dataroleService")
	private DataRoleService dataRoleService;
	@Resource(name="deptService")
	private DeptService deptService;
	@Resource(name="WorkEntryService")
	private WorkEntryService workEntryService;
	@Resource(name="positionDailyTaskService")
	private PositionDailyTaskService positionDailyTaskService;
	@Resource(name="flowTaskService")
	private FlowTaskService flowTaskService;
	@Resource(name = "positionDutyService")
	private PositionDutyService positionDutyService;
	@Resource(name="positionLevelService")
	private PositionLevelService positionLevelService;
	@Resource(name="flowWorkService")
	private FlowWorkService flowWorkService;
	
	/**
	 * 跳转到手机端日清工作台
	 * @return
	 * @throws Exception 
	 */
	@RequestMapping(value="listDesk")
	public ModelAndView listDesk(Page page){
		logBefore(logger, "跳转到日清工作台");
		ModelAndView mv = this.getModelAndView();
		PageData pd = this.getPageData();
		User user = getUser();
		String empCode = user.getNUMBER();
		List<PageData> productList = new ArrayList<PageData>();//产品列表
		List<PageData> projectList = new ArrayList<PageData>();//项目列表
		try {
			//查询产品列表
			productList = empDailyTaskService.findProductByEmp(empCode);
			//查询项目列表
			projectList = empDailyTaskService.findProjectByEmp(empCode);
			mv.addObject("productList", productList);
			mv.addObject("projectList", projectList);
			//默认加载目标工作
			if(null == pd.get("loadType")){
				pd.put("loadType", Const.TASK_TYPE_B);
			}
			pd.put("empCode", empCode);
			mv.addObject("pd", pd);
			// 查询员工是否可以添加日常工作
			String addAvailable = positionDailyTaskService.checkAdd(pd);
			mv.addObject("addAvailable", addAvailable);
		} catch (Exception e) {
			logger.error("跳转到日清工作台出错", e);
			mv.addObject("errorMsg", "跳转到日清工作台出错");
		}
		mv.setViewName("app/task/taskList");
		
		return mv;
	}
	
	/**
	 * 跳转到手机端日清看板
	 * @return
	 */
	@RequestMapping(value="listBoard")
	public ModelAndView listBoard(){
		logBefore(logger, "跳转到日清看板");
		ModelAndView mv = this.getModelAndView();
		PageData pd = this.getPageData();
		User user = getUser();
		String empCode = user.getNUMBER();
		List<PageData> productList = new ArrayList<PageData>();//产品列表
		List<PageData> projectList = new ArrayList<PageData>();//项目列表
		try {
			//查询产品列表
			productList = empDailyTaskService.findProductByEmp(empCode);
			//查询项目列表
			projectList = empDailyTaskService.findProjectByEmp(empCode);
			mv.addObject("productList", productList);
			mv.addObject("projectList", projectList);
			//默认加载目标工作
			if(null == pd.get("loadType")){
				pd.put("loadType", Const.TASK_TYPE_B);
			}
			//表示领导查看的日清看板
			pd.put("showDept", 1);

			//查询是否领导，1为领导，0为普通员工
			PageData userPd = new PageData();
			userPd.put("USERNAME", getUser().getUSERNAME());
			int count = commonService.checkLeader(userPd);

			//查询当前员工可以查看的部门列表
			List<PageData> deptList = dataRoleService.findByUser(getUser().getUSER_ID());
			//查询当前员工的岗位等级
			PageData empPositionLevel = employeeService.findPositionByEmpCode(getUser().getNUMBER());
			pd.put("positionLevel", empPositionLevel.get("JOB_RANK"));
			
			String deptIdStr = "";//用于页面上选择部门时查询员工
			String deptCodeStr = "";//用于查询所有部门下的员工周工作
			if(count==0){//普通员工
				//普通员工只能查看本部门员工的工作
				pd.put("readTask", 1);
				//把当前员工的部门添加到部门列表中
				PageData deptPd = new PageData();
				deptPd.put("ID", getUser().getDeptId());
				PageData empDeptpd = deptService.findById(deptPd);
				if(null == empDeptpd){
					logger.error("没有配置所属部门！");
					pd.put("selfDept", "none");
					mv.addObject("pd", pd);
					return mv;
				}
				empDeptpd.put("DEPT_ID", deptPd.get("ID"));
				deptList = new ArrayList<PageData>();
				deptList.add(empDeptpd);
				pd.put("deptCode", empDeptpd.get("DEPT_CODE"));
				mv.addObject("deptList", deptList);
			}else{//领导
				mv.addObject("selfEmpCode", getUser().getNUMBER());
				
				//配有部门数据权限的
				if(deptList.size()>0){
					for(PageData dept : deptList){
						deptIdStr += "," + dept.get("DEPT_ID");
						deptCodeStr += "," + "'" + dept.getString("DEPT_CODE") + "'";
					}
					deptIdStr = deptIdStr.substring(1);
					deptCodeStr = "(" + deptCodeStr.substring(1) + ")";
					
					pd.put("deptCodeStr", deptCodeStr);
					pd.put("deptIdStr", deptIdStr);
					mv.addObject("deptList", deptList);
				}else{
					//把当前员工的部门添加到部门列表中
					PageData deptPd = new PageData();
					deptPd.put("ID", getUser().getDeptId());
					PageData empDeptpd = deptService.findById(deptPd);
					if(null == empDeptpd){
						logger.error("没有配置所属部门！");
						pd.put("selfDept", "none");
						mv.addObject("pd", pd);
						return mv;
					}
					empDeptpd.put("DEPT_ID", deptPd.get("ID"));
					deptList = new ArrayList<PageData>();
					deptList.add(empDeptpd);
					pd.put("deptCode", empDeptpd.get("DEPT_CODE"));
					mv.addObject("deptList", deptList);
//					logger.error( "没有配置部门数据权限！");
//					pd.put("dataDept", "none");
//					mv.addObject("pd", pd);
//					return mv;
				}
			}
			//查询页面显示的部门员工列表
			List<Integer> deptIdList = new ArrayList<Integer>();
			if(null == pd.get("deptCode") || pd.get("deptCode").toString().isEmpty()){//没有选择部门
				if(deptList.size()>0){
					for(PageData dept : deptList){
						deptIdList.add(Integer.valueOf(dept.get("DEPT_ID").toString()));
					}
				}
			}else{//已选部门
				for(PageData dept : deptList){
					if(dept.getString("DEPT_CODE").equals(pd.getString("deptCode"))){
						deptIdList.add(Integer.valueOf(dept.get("DEPT_ID").toString()));
						break;
					}
				}
			}
			List<PageData> empList = employeeService.findEmpByDeptIds(deptIdList);
			mv.addObject("empList", empList);
		
			pd.put("currentUser", getUser().getNUMBER());
			mv.addObject("pd", pd);
		} catch (Exception e) {
			logger.error("跳转到日清看板出错", e);
			mv.addObject("errorMsg", "跳转到日清看板出错");
		}
		mv.setViewName("app/task/taskList");
		
		return mv;
	}
	
	/**
	 * 加载任务列表
	 */
	@ResponseBody
	@RequestMapping(value = "loadTask", produces = "text/html;charset=UTF-8")
	public void loadTask(HttpServletResponse response, Page page){
		logBefore(logger, "加载任务列表");
		try {
			PageData pd = this.getPageData();
			List<PageData> taskList = new ArrayList<PageData>();//工作列表
			//获取查询的任务类型
			String loadType = pd.getString("loadType");
			if(Const.TASK_TYPE_B.equals(loadType) || Const.TASK_TYPE_C.equals(loadType) || Const.TASK_TYPE_D.equals(loadType)){//目标工作不返回草稿状态的
				pd.put("useStatus", Const.SYS_STATUS_YW_CG);
			}
			page.setPd(pd);
			//page.setShowCount(5);
			//查询工作
			if(Const.TASK_TYPE_B.equals(loadType)){
				//查询周工作目标
				taskList = empDailyTaskService.empWeekTasklistPage(page);
			}else if(Const.TASK_TYPE_C.equals(loadType)){
				//查询项目工作
				taskList = empDailyTaskService.empProjectEventlistPage(page);
			}else if(Const.TASK_TYPE_F.equals(loadType)){
				//查询流程工作
				taskList = empDailyTaskService.empFlowWorklistPage(page);
				Properties pro = new Properties();
				String filePath = String.valueOf(Thread.currentThread().getContextClassLoader().getResource("")); //项目路径
				filePath = filePath.replaceAll("file:/", "");
				filePath = filePath.replaceAll("%20", " ");
				filePath = filePath.trim() + "config.properties";
				FileInputStream in = new FileInputStream(filePath);
				pro.load(in);
				String scoreTime = pro.getProperty("scoreTime");
				String score = pro.getProperty("score");
				in.close(); 
				for(PageData task:taskList){
					List<PageData> flowWorkHistory = empDailyTaskService.findHistoryById(task.get("FLOW_ID").toString());
					String num = "0";
					if(flowWorkHistory!=null&&flowWorkHistory.size()!=0){
						PageData obj = flowWorkHistory.get(flowWorkHistory.size()-1);
						SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
						Date operTime = sdf.parse(obj.get("operTime").toString());
						long intervalMilli = new Date().getTime() - operTime.getTime();
						int time = Integer.parseInt(scoreTime);
						int mul = Integer.parseInt(score);
					    num =  String.valueOf((intervalMilli / (time * 60 * 60 * 1000)) * mul);
					}
					if(num.equals("0")){
						task.put("LATE", "false");
					}else{
						task.put("LATE", "true");
					}
					task.put("SCORE", "-"+num);
				}
			}else if(Const.TASK_TYPE_D.equals(loadType)){
				//查询日常工作
				taskList = empDailyTaskService.empPositionTasklistPage(page);
			}else if(Const.TASK_TYPE_T.equals(loadType)){
				//查询临时工作
				taskList = empDailyTaskService.tempTasklistPage(page);
			}
			Map<String, Object> map = new HashMap<String, Object>();
			map.put("page", page);
			map.put("taskList", taskList);
			writeJson(map, response);
		} catch (Exception e) {
			logger.error("加载任务列表出错", e);
		}
	}
	
	/**
	 * 返回json
	 */
	private void writeJson(Map<String, Object> map, HttpServletResponse response) throws Exception{
		JSONObject jo = JSONObject.fromObject(map);
		String json = jo.toString();
		response.setCharacterEncoding("UTF-8");
		response.setContentType("text/html");
		PrintWriter out = response.getWriter();
		out.write(json);
		out.flush();
		out.close();
	}
	
	/**
	 * 跳转到目标工作明细页面
	 */
	@RequestMapping("listBusinessEmpTask")
	public ModelAndView listBusinessEmpTask(){
		logBefore(logger, "跳转到目标工作明细页面");
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
			weekTask.put("overWidth", Double.compare(actual_percent, 100));
			weekTask.put("overProgress", Double.compare(actual_percent, planPercent));
			//显示领导的日清批示列表
			List<PageData> commentList = empDailyTaskService.listTaskComment(pd);
			
			mv.addObject("commentList", commentList);
			mv.addObject("emptaskList", emptaskList);
			mv.addObject("weekTask", weekTask);

			//查询当前用户角色
			pd.put("userRoleName", getUserRole().getRole().getROLE_NAME());
			//判断任务是否超期
			Date now = sdf.parse(sdf.format(new Date()));
			Date endDay = sdf.parse(weekTask.getString("WEEK_END_DATE"));
			pd.put("overDays", getDays(endDay, now)-1);
			pd.put("isOverDay", now.after(endDay));
		} catch (Exception e) {
			mv.addObject("errorMsg", "查询员工经营类日清列表出错");
			logger.error("查询员工经营类日清列表出错", e);
		}
		mv.addObject("pd", pd);
		mv.setViewName("app/task/appTargetDetail");
		return mv;
	}
	/**
	 * 重点协同工作明细
	 * @return
	 */
	@RequestMapping("listCreativeEmpTask")
	public ModelAndView listCreativeEmpTask(){
		logBefore(logger, "查询重点协同明细页面");
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
			projectEvent.put("overProgress", Double.compare(actual_percent, planPercent));
			//显示领导的日清批示列表
			List<PageData> commentList = empDailyEventService.listEventComment(pd);
			mv.addObject("commentList", commentList);
			mv.addObject("emptaskList", emptaskList);
			mv.addObject("projectEvent", projectEvent);
			//查询当前用户角色
			pd.put("userRoleName", getUserRole().getRole().getROLE_NAME());
			//判断任务是否超期
			pd.put("overDays", getDays(endday, now)-1);
			pd.put("isOverDay", now.after(endday));
		} catch (Exception e) {
			mv.addObject("errorMsg", "查询员工重点协同工作明细出错");
			logger.error("查询员工重点协同工作明细出错", e);
		}
		String page = "currentPage=" + pd.get("currentPage");
		pd.put("page", page);
		mv.addObject("pd", pd);
		mv.setViewName("app/task/appImportDetail");
		return mv;
	}
	/**
	 * 重点协同工作日清列表
	 * @return
	 */
	@RequestMapping("listImportTask")
	public ModelAndView listImportTask(){
		logBefore(logger, "查询重点协同日清列表");
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
			projectEvent.put("overProgress", Double.compare(actual_percent, planPercent));
			mv.addObject("emptaskList", emptaskList);
			mv.addObject("projectEvent", projectEvent);
			//查询当前用户角色
			pd.put("userRoleName", getUserRole().getRole().getROLE_NAME());
			//判断任务是否超期
			pd.put("overDays", getDays(endday, now)-1);
			pd.put("isOverDay", now.after(endday));
		} catch (Exception e) {
			mv.addObject("errorMsg", "查询员工重点协同工作日清列表出错");
			logger.error("查询员工重点协同工作日清列表出错", e);
		}
		String page = "currentPage=" + pd.get("currentPage");
		pd.put("page", page);
		mv.addObject("pd", pd);
		mv.setViewName("app/task/appTargetTaskList");
		return mv;
	}
	/**
	 * 获取计划进度
	 * @param startDate	任务开始时间
	 * @param endDate	任务结束时间
	 * @param taskTime	当前时间
	 */
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
	
	/**
	 * 计算间隔天数
	 */
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

	/**
	 * 删除目标工作日清
	 */
	@ResponseBody
	@RequestMapping("deleteTargetTask")
	public String deleteTargetTask(){
		logBefore(logger, "删除目标工作日清任务");
		try {
			PageData pd = this.getPageData();
			empDailyTaskService.delDailyEmpTask(pd);
			userLogService.logInfo(new UserLog(getUser().getUSER_ID(), LogType.update, 
				"目标工作日清", "逻辑删除id=" + pd.getString("id") + "，更新删除字段"));
		} catch (Exception e) {
			logger.error("删除目标工作日清任务出错", e);
			return "error";
		}
		return "success";
	}
	/**
	 * 删除重点协同工作日清
	 */
	@ResponseBody
	@RequestMapping("deleteImportTask")
	public String deleteImportTask(){
		logBefore(logger, "删除重点协同活动日清任务");
		try {
			PageData pd = this.getPageData();
			empDailyEventService.deleteEventEmpTask(pd);
			User user = getUser();
			userLogService.logInfo(new UserLog(user.getUSER_ID(), LogType.update, 
					"重点协同活动日清", "逻辑删除id=" + pd.getString("id") + "，更新删除字段"));
			//删除时，需要修改活动分解项
			PageData splitPd = new PageData();
			splitPd.put("empTaskId", pd.getString("id"));
			splitPd.put("isFinish", 0);
			splitPd.put("user", user.getNAME());
			splitPd.put("time", new Date());
			empDailyEventService.updateEventSplit(splitPd);
		} catch (Exception e) {
			logger.error("删除重点协同活动日清任务出错", e);
			return "error";
		}
		return "success";
	}
	
	/**
	 * 跳转到目标工作日清添加界面
	 */
	@RequestMapping("toAddTargetTask")
	public ModelAndView toAddTargetTask(){
		logBefore(logger, "跳转到目标工作日清添加界面");
		ModelAndView mv = this.getModelAndView();
		PageData pd = this.getPageData();
		pd.put("id", pd.getString("weekTaskId"));
		try {
			PageData task = empDailyTaskService.findWeekTaskDetail(pd);
			mv.addObject("task", task);
		} catch (Exception e) {
			e.printStackTrace();
		}
		mv.setViewName("app/task/appTargetTaskAdd");
		mv.addObject("pd", pd);
		return mv;
	}
	@RequestMapping("toAddImportTask")
	public ModelAndView toAddImportTask(){
		logBefore(logger, "跳转到重点协同日清添加界面");
		ModelAndView mv = this.getModelAndView();
		PageData pd = this.getPageData();
		//查询创新活动分解列表
		pd.put("status", Const.SYS_STATUS_YW_YSX);
		try {
			List<PageData> splitList = empDailyEventService.listUnfinishEventSplit(pd);
			mv.addObject("splitList", splitList);
		} catch (Exception e) {
			logger.error("查询重点协同分解列表出错", e);
		}
		mv.setViewName("app/task/appImportTaskAdd");
		mv.addObject("pd", pd);
		return mv;
	}

	@RequestMapping("toAddTargetComment")
	public ModelAndView toAddTargetComment(){
		logBefore(logger, "跳转到添加批示界面");
		ModelAndView mv = new ModelAndView();
		PageData pd = this.getPageData();
		
		mv.addObject("pd", pd);
		mv.setViewName("app/task/appTargetCommentAdd");
		return mv;
	}
	@RequestMapping("toAddImportComment")
	public ModelAndView toAddImportComment(){
		logBefore(logger, "跳转到添加批示界面");
		ModelAndView mv = new ModelAndView();
		PageData pd = this.getPageData();
		
		mv.addObject("pd", pd);
		mv.setViewName("app/task/appImportCommentAdd");
		return mv;
	}
	/**
	 * 保存目标活动批示
	 * @return
	 */
	@ResponseBody
	@RequestMapping("saveTargetComment")
	public String saveTargetComment(){
		logBefore(logger, "保存日清任务批示");
		try {
			PageData pd = this.getPageData();
			User user = getUser();
			pd.put("isDel", 0);
			pd.put("createUser", user.getNAME());
			pd.put("createDate", new Date());
			empDailyTaskService.saveTaskComment(pd);
		} catch (Exception e) {
			logger.error("保存日清任务批示出错", e);
			return "error";
		}
		return "success";
	}
	/**
	 * 保存重点协同活动批示
	 * @return
	 */
	@ResponseBody
	@RequestMapping("saveImportComment")
	public String saveImportComment(){
		logBefore(logger, "保存日清任务批示");
		try {
			PageData pd = this.getPageData();
			User user = getUser();
			pd.put("isDel", 0);
			pd.put("createUser", user.getNAME());
			pd.put("createDate", new Date());
			empDailyEventService.saveEventComment(pd);
		} catch (Exception e) {
			logger.error("保存日清任务批示出错", e);
			return "error";
		}
		return "success";
	}
	
	@ResponseBody
	@RequestMapping("checkFile")
	public String checkFile(String fileName, HttpServletRequest request){
		try {
			//String name = new String(fileName.getBytes("iso8859-1"), "UTF-8");
			String name = fileName;
			String filePath = request.getSession().getServletContext().getRealPath(Const.FILEPATHTASK) + "\\" + name;
			
			File f = new File(filePath);
			if (!f.exists()) {
				logger.error("附件不存在");
				return "";
			}else{
				return filePath;
			}
		} catch (Exception e) {
			logger.error("获取文件名称出错", e);
			return "";
		}
	}
	
	@RequestMapping("loadFile")
	public void loadFile(String fileName, HttpServletRequest request, HttpServletResponse response) throws Exception{
		logBefore(logger, "下载附件");
		try {
//			String name = new String(fileName.getBytes("iso8859-1"), "UTF-8");
			String name = fileName;
			String path = request.getSession().getServletContext().getRealPath(Const.FILEPATHTASK) + "\\" + name;
			
			FileDownload.fileDownload(response, path, name);
		} catch (Exception e) {
			logger.error("下载附件出错", e);
		}
	}
	@RequestMapping("loadAllFile")
	public void loadAllFile(String fileName, HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		logBefore(logger, "打包下载附件");
		try {
			String name = fileName;
			List<File> list = new ArrayList<>();
			if (fileName != null && fileName != "") {
				String[] arr = fileName.split(",");
				for (int i = 0; i < arr.length; i++) {
					String path = request.getSession().getServletContext()
							.getRealPath(Const.FILEPATHTASK)
							+ "\\" + arr[i];
					File file = new File(path);
					list.add(file);
				}
				if (list.size() != 0) {
					String zipName = String.valueOf(new Date().getTime())
							+ "打包下载.rar";
					File file = new File("d://" + zipName);
					if (!file.exists()) {
						file.createNewFile();
					}
					response.reset();
					FileOutputStream fous = new FileOutputStream(file);
					ZipOutputStream zipOut = new ZipOutputStream(fous);
					zipFile(list, zipOut);
					zipOut.close();
					fous.close();
					downloadZip(file, response);
				}
			}
		} catch (Exception e) {
			logger.error("下载附件出错", e);
		}
	}
	public static void zipFile(List files, ZipOutputStream outputStream) {
		int size = files.size();
		for (int i = 0; i < size; i++) {
			File file = (File) files.get(i);
			zipFile(file, outputStream);
		}
	}
	public static HttpServletResponse downloadZip(File file,
			HttpServletResponse response) {
		try {
			// 以流的形式下载文件。
			InputStream fis = new BufferedInputStream(new FileInputStream(file.getPath()));
			byte[] buffer = new byte[fis.available()];
			fis.read(buffer);
			fis.close();
			// 清空response
			response.reset();

			OutputStream toClient = new BufferedOutputStream(
					response.getOutputStream());
			response.setContentType("application/octet-stream");

			// 如果输出的是中文名的文件，在此处就要用URLEncoder.encode方法进行处理
			response.setHeader("Content-Disposition", "attachment;filename="
					+ URLEncoder.encode(file.getName(), "UTF-8"));
			toClient.write(buffer);
			toClient.flush();
			toClient.close();
		} catch (IOException ex) {
			ex.printStackTrace();
		} finally {
			try {
				File f = new File(file.getPath());
				f.delete();
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
		return response;
	}
	/**
	 * 根据输入的文件与输出流对文件进行打包
	 * 
	 * @param inputFile
	 * @param ouputStream
	 */

	public static void zipFile(File inputFile, ZipOutputStream ouputStream) {
		try {
			if (inputFile.exists()) {
				/**
				 * 如果是目录的话这里是不采取操作的， 至于目录的打包正在研究中
				 */
				if (inputFile.isFile()) {
					FileInputStream IN = new FileInputStream(inputFile);
					BufferedInputStream bins = new BufferedInputStream(IN, 512);
					// org.apache.tools.zip.ZipEntry
					ZipEntry entry = new ZipEntry(inputFile.getName());
					ouputStream.putNextEntry(entry);
					// 向压缩文件中输出数据
					int nNumber;
					byte[] buffer = new byte[512];
					while ((nNumber = bins.read(buffer)) != -1) {
						ouputStream.write(buffer, 0, nNumber);
					}
					// 关闭创建的流对象
					bins.close();
					IN.close();
				} else {
					try {
						File[] files = inputFile.listFiles();
						for (int i = 0; i < files.length; i++) {
							zipFile(files[i], ouputStream);
						}
					} catch (Exception e) {
						e.printStackTrace();
					}
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
	/**
	 * 保存目标工作日清
	 */
	@ResponseBody
	@RequestMapping(value="/saveTargetTask")
	public String saveTargetTask(@RequestParam(required=false) MultipartFile file, HttpServletRequest request) throws Exception{
		logBefore(logger, "保存目标工作日清");
		PageData pd = new PageData(request);
		try {
			User user = getUser();
			String dailyCount = pd.getString("dailyCount");
			String weekCount = pd.getString("weekCount");
			//计算本次完成百分比
			double d1 = new Double(dailyCount).doubleValue();
			double d2 = new Double(weekCount).doubleValue();
			if (Double.valueOf(weekCount).equals(Double.valueOf("0"))) {
				d2 = d1;
			}
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
				saveTaskFile(fileName, Const.TASK_TYPE_B, id, user.getUSERNAME());
			}
			//EndPointServer.sendMessage(targetEmpCode, TaskType);
		} catch (Exception e) {
			logger.error("目标工作日清出错", e);
			return "error";
		}
		return "success";
	}
	/**
	 * 保存重点协同工作日清
	 */
	@ResponseBody
	@RequestMapping(value="/saveImportTask")
	public String saveImportTask(@RequestParam(required=false) MultipartFile file, HttpServletRequest request) throws Exception{
		logBefore(logger, "保存重点协同工作日清");
		PageData pd = new PageData(request);
		try {
			User user = getUser();
			//本次完成百分比
			Double d = new Double(pd.getString("finishPercent"));
			String finishPercent = String.format("%.2f", d.doubleValue());
			pd.put("finishPercent", finishPercent);
			pd.put("status", Const.SYS_STATUS_YW_CG);//草稿状态
			pd.put("isDel", 0);
			pd.put("user", user.getNAME());
			pd.put("time", new Date());
			pd.put("preparation1", pd.get("splitNames"));//完成的活动名称
			//保存日清
			empDailyEventService.saveEventEmpTask(pd);
			String id = pd.get("id").toString();
			userLogService.logInfo(new UserLog(getUser().getUSER_ID(), LogType.add, "重点协同活动日清", "新增日清id=" + id));
			//更新活动分解项为已完成
			String eventSplitIds = pd.getString("eventSplitIds");
			PageData splitPd = new PageData();
			splitPd.put("eventSplitIdArr", eventSplitIds.split(","));
			splitPd.put("empTaskId", id);
			splitPd.put("user", user.getNAME());
			splitPd.put("time", new Date());
			empDailyEventService.finishEventSplit(splitPd);
			//上传附件
			if(null != file && !file.isEmpty()){
				logBefore(logger, "开始上传文件"); 
				String fileName = FileUpload.uploadFile(request, file, Const.FILEPATHTASK);
				saveTaskFile(fileName, Const.TASK_TYPE_C, id, user.getUSERNAME());
			}
		} catch (Exception e) {
			logger.error("保存重点协同工作日清", e);
			return "error";
		}
		return "success";
	}

	/**
	 * 保存任务日清时上传的附件
	 */
	private void saveTaskFile(String fileName, String taskType, String taskId, String userName) throws Exception{
		PageData filePd = new PageData();
		filePd.put("fileName", fileName);
		filePd.put("taskType", taskType);
		filePd.put("taskId", taskId);
		filePd.put("createUser", userName);
		filePd.put("createDate", new Date());
		taskFileService.saveFile(filePd);
	}
	
	/**
	 * 周工作日清任务审核
	 */
	@ResponseBody
	@RequestMapping("validateDailyEmpTask")
	public String validateDailyEmpTask(){
		logBefore(logger, "周工作日清任务审核");
		try {
			PageData pd = this.getPageData();
			pd.put("updateUser", getUser().getUSERNAME());
			pd.put("updateTime", new Date());
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
	/**
	 * 重点协同工作日清任务审核
	 */
	@ResponseBody
	@RequestMapping("validateEventEmpTask")
	public String validateEventEmpTask(){
		logBefore(logger, "重点协同活动日清-审核");
		try {
			User user = getUser();
			PageData pd = this.getPageData();
			PageData splitPd = new PageData();
			splitPd.put("empTaskId", pd.getString("id"));
			splitPd.put("user", user.getUSERNAME());
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
			pd.put("updateUser", getUser().getUSERNAME());
			pd.put("updateTime", new Date());
			//更新活动日清
			empDailyEventService.updateEventEmpTaskStatus(pd);
			//更新活动分解项
			empDailyEventService.updateEventSplit(splitPd);
			
			userLogService.logInfo(new UserLog(getUser().getUSER_ID(), LogType.update, 
				"重点协同活动日清", "日清审核，状态改为：" + pd.getString("status")));
		} catch (Exception e) {
			logger.error("重点协同活动日清-审核出错", e);
			return "error";
		}
		return "success";
	}
	/**
	 * 去临时任务完成页面
	 */
	@RequestMapping(value = "/toTempTask")
	public ModelAndView toTempTask() throws Exception {
		ModelAndView mv = this.getModelAndView();
		PageData reqPd = this.getPageData();
		reqPd.put("TASK_TYPE",Const.TASK_TYPE_T);
 		PageData pd= workEntryService.findById(reqPd);
 		pd.put("id", pd.get("DAILY_TASK_ID").toString());
 		List<PageData> list = new ArrayList<>();
 		list = this.workEntryService.findAttchmentsByWorkId(pd);
 		if (pd.getString("CHECK_PERSON_CODE")==null) {
 			mv.addObject("isCheckPerson", false);
		}else {
			mv.addObject("isCheckPerson", pd.getString("CHECK_PERSON_CODE").equals(getUser().getNUMBER()));
		}
		mv.setViewName("app/task/appTempTaskComplete");
		mv.addObject("fileList", list);
		mv.addObject("msg", "complete");
		mv.addObject("pd", pd);
		mv.addObject("reqPd", reqPd);

		return mv;
	}
	
	/**
	 * 临时工作-确认完成
	 */
	@ResponseBody
	@RequestMapping(value = "/complete")
	public String complete(@RequestParam(required=false) MultipartFile file, HttpServletRequest request) throws Exception {
		PageData pd = new PageData(request);
		try {
			pd.put("STATUS", Const.SYS_STATUS_YW_YWB);//日清状态改为已完成
			if(null != pd.get("QA") && !pd.getString("QA").isEmpty()){
				pd.put("STATUS", Const.SYS_STATUS_YW_YPJ);//日清状态改为已评价
			}
			pd.put("lastUpdateUser", getUser().getNAME());
			pd.put("lastUpdateTime", new Date());
			workEntryService.edit(pd);
			//上传附件
			if(null != file && !file.isEmpty()){
				logBefore(logger, "开始上传文件"); 
				String str = FileUpload.uploadFile(request, file, Const.FILEPATHTASK);
				String fileName = str.split(",")[0];
				String fileName_server = str.split(",")[1];
				User user = getUser();
				String id = pd.getString("ID");
				saveTaskFile(fileName,fileName_server, Const.TASK_TYPE_T, id, user.getUSERNAME());
			}
		} catch (Exception e) {
			logger.error("临时工作确认完成出错", e);
			return "error";
		}
		return "success";
	}
	
	/**
	 * 上传文档
	 */
	@RequestMapping(value = "/Upload", produces = "application/json;charset=UTF-8")
	@ResponseBody
	public void RepoUpload(
			@RequestParam(value = "file", required = false) MultipartFile[] DOCUMENT,
			HttpServletResponse response, HttpServletRequest request)
			throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		List<Map<String, Object>> list = new ArrayList<Map<String, Object>>();
		try {
			for (int i = 0; i < DOCUMENT.length; i++) {
				if (null != DOCUMENT[i] && !DOCUMENT[i].isEmpty()) {
					String filePath = PathUtil.getClasspath()
							+ Const.FILEPATHTASK; // 文件上传路径
					String filename = DOCUMENT[i].getOriginalFilename();
					String filename_server = FileUpload.uploadFileNew(request,
							DOCUMENT[i], Const.FILEPATHTASK);

					map = new HashMap<String, Object>();
					map.put("filename", filename);
					map.put("filePath", filePath);
					map.put("filename_server", filename_server);
					list.add(map);
				}
			}

			String json = JSONArray.fromObject(list).toString();
			response.setCharacterEncoding("UTF-8");
			response.setContentType("text/html");
			PrintWriter out = response.getWriter();
			out.write(json);
			out.flush();
			out.close();
		} catch (Exception e) {
			logger.error(e.toString(), e);

		}

	}
	
	/**
	 * 保存任务日清时上传的附件
	 */
	private Integer saveTaskFile(String fileName,String fileName_server, String taskType, String taskId, String userName) throws Exception{
		PageData filePd = new PageData();
		filePd.put("fileName", fileName);
		filePd.put("fileName_server", fileName_server);
		filePd.put("taskType", taskType);
		filePd.put("taskId", taskId);
		filePd.put("createUser", userName);
		filePd.put("createDate", new Date());
		taskFileService.saveFile(filePd);
		return Integer.parseInt(filePd.get("id").toString());
	}
	
	/**
	 * 获取员工日常工作详情
	 * @return
	 */
	@RequestMapping(value="empDailyTaskInfo")
	public ModelAndView empDailyTaskInfo(){
		ModelAndView mv = new ModelAndView();
		PageData pd = this.getPageData();
	    try {
	    	listDailyTaskDetail(this.getPageData().get("manageId").toString(),mv,getUser());
	    	//获取shiro权限,是否配置了修改日常工作时间的权限
			pd.put("allowChangTime", SecurityUtils.getSubject().isPermitted("listTask:add()"));
		} catch (Exception e) {
			logger.error(e.toString(),e);
		}
	    mv.addObject("flag",this.getPageData().get("show").toString());
	    mv.addObject("pd",pd);
	    mv.setViewName("app/task/appDailyTask");
		return mv;
	}
	
	/**
	 * 查询提交的岗位日清是否都结束
	 */
	@ResponseBody
	@RequestMapping(value="checkDetailStatus", produces = "text/html;charset=UTF-8")
	public String checkDetailStatus(HttpServletRequest request,String manageId){
		try {
			//获取对应的所有工作时间信息
			List<PageData> detailList = empDailyTaskService.findPositionDailyTaskDetailById(Integer.parseInt(manageId));
			String groups = "";
			int groupCount = 0;
			int endCount = 0;
			for(PageData pd : detailList){
				if(!groups.equals(pd.getString("groups"))){
					groups = pd.getString("groups");
					groupCount++;
				}
				if("end".equals(pd.getString("status"))){
					endCount ++;
				}
			}
			return "" + (groupCount-endCount);
		} catch (Exception e) {
			logger.error("查询提交的岗位日清状态",e);
			return "error";
		}
	}
	
	@ResponseBody
	@RequestMapping(value="submitInfo", produces = "text/html;charset=UTF-8")
	public String submitInfo(HttpServletRequest request,String manageId){
		logBefore(logger, "提交");
		try {
			PageData pd = this.getPageData();
			pd.put("manageId", manageId);
			pd.put("status", "YW_YSX");
			savePage(pd);
			empDailyTaskService.submitInfo(pd);
			return "success";
		} catch (Exception e) {
			logger.error("删除查询项出错",e);
			return "error";
		}
	}
	
	/**
     * 查询日常工作详细信息
     */
    private void listDailyTaskDetail(String dailyTaskId,ModelAndView mv,User user) throws Exception {
        //通过ID获取行政日清
        PageData searchPd = new PageData();
        searchPd.put("ID",dailyTaskId);
        PageData positionDailyTask = positionDailyTaskService.find(searchPd);
        mv.addObject("task",positionDailyTask);
        
        //通过ID获取行政日清细节列表
        PageData detailSearchPd = new PageData();
        detailSearchPd.put("dailyTaskId",dailyTaskId);
        detailSearchPd.put("gradeCode", positionDailyTask.get("GRADE_CODE"));
        List<PageData> detailList = positionDailyTaskService.findPositionDailyTaskDetail(detailSearchPd);
        mv.addObject("detailList",detailList);
        String flag = "1";
		if(detailList!=null && detailList.size()!=0){
			for(PageData obj:detailList){
				if(obj.get("statusName")!=null){
					String status = obj.getString("statusName");
					if(status.equals("草稿")){
						flag = "0";
					}
				}
			}
			
		}
		mv.addObject("status",flag);
        //显示领导的日清批示列表
        PageData commmentPd = new PageData();
        commmentPd.put("manage_id", dailyTaskId);
		List<PageData> infoList = empDailyTaskService.findComment(commmentPd);
		mv.addObject("infoList", infoList);
    }
    @RequestMapping(value="/showTime")
    public ModelAndView showTime() throws Exception {
        PageData pd = this.getPageData();
        ModelAndView mv = this.getModelAndView();

        if(null != pd.get("START_TIME_ARR") && !"".equals(pd.get("START_TIME_ARR").toString())
                && null != pd.get("END_TIME_ARR") && !"".equals(pd.get("END_TIME_ARR").toString())){
            List<PageData> timeList = new ArrayList<PageData>();
            String[] start_time_arrs =  pd.get("START_TIME_ARR").toString().split(";");
            String[] end_time_arrs =  pd.get("END_TIME_ARR").toString().split(";");
            for(int i = 0; i < start_time_arrs.length;i ++){
                PageData timePd = new PageData();
                timePd.put("start_time",start_time_arrs[i]);
                timePd.put("end_time",end_time_arrs[i]);
                timeList.add(timePd);
            }
            mv.addObject("timeList",timeList);
        }
        //将日期放入
        mv.addObject("Date",pd.get("Date"));
        mv.addObject("pd",pd);
        mv.addObject("taskStatus", pd.get("taskStatus"));
        mv.setViewName("app/task/changeTime");
        return mv;
    }
	/**
	 * 处理流程
	 * @return
	 */
	@ResponseBody
	@RequestMapping("findSubFlowModel")
	public String findSubFlowModel(){
		PageData pd = this.getPageData();
		try {
			List<PageData> flowModelList = flowTaskService.findFlowByFlowWorkNodeId(pd);
			return String.valueOf(flowModelList.size());
		} catch (Exception e) {
			logger.error("查询节点下对应的子流程出错", e);
			return "error";
		}
	} 
	/**
	 * 接收流程工作
	 */
	@ResponseBody
	@RequestMapping("receiveFlowWork")
	public String receiveFlowWork( HttpServletRequest request){
		logBefore(logger, "处理流程工作");
		try {
			PageData pd = new PageData(request);
			String handleType = pd.getString("handleType");
			String nextNodeId = pd.getString("nextNodeId");
			User user = getUser();
			Date now = new Date();
			//更新当前节点状态
			if("receive".equals(handleType)){//接收
				pd.put("status", Const.SYS_STATUS_YW_YJS);
				flowTaskService.updateFlowWorkNode(pd);
				//记录操作历史
				saveFlowWorkHistory(pd.getString("flowId"), pd.getString("nodeId"), nextNodeId,null,
						handleType, pd.getString("remarks"), null, now, user, request, pd.getString("score"));
			}
			
			//记录节点的时间情况
			PageData nodePd = new PageData();
			nodePd.put("nodeId", pd.get("nodeId"));
			if("receive".equals(handleType)){//接收
				nodePd.put("startTime", now);
				//接收后保存开始时间
				flowTaskService.saveFlowNodeTime(nodePd);
				if(null != pd.get("childFlowModel") && !pd.getString("childFlowModel").isEmpty()){
				}
			}
			return "success";
		} catch (Exception e) {
			logger.error("接收流程工作出错", e);
			return "error";
		}
	}
	/**
	 * 保存操作历史记
	 */
	private void saveFlowWorkHistory(String flowId, String currentNodeId, String nextNodeId, String nextNodeEmp, String handleType, 
			String remarks, String fileId, Date now, User user, HttpServletRequest request, String score) throws Exception{
		PageData historyPd = new PageData();
		historyPd.put("flowId", flowId);
		historyPd.put("operaTime", now);
		historyPd.put("perator", user.getNAME());
		historyPd.put("currentNode", currentNodeId);
		if("receive".equals(handleType)){//接收
			historyPd.put("operaType", Const.FLOW_OPERA_TYPE_JS);
			historyPd.put("score", score);
		}else if("back".equals(handleType)){//退回
			historyPd.put("nextNode", nextNodeId);
			historyPd.put("nextNodeEmp", nextNodeEmp);
			historyPd.put("operaType", Const.FLOW_OPERA_TYPE_TH);
			historyPd.put("score", score);
		}else if("next".equals(handleType)){//下一步
			historyPd.put("nextNode", nextNodeId);
			historyPd.put("nextNodeEmp", nextNodeEmp);
			historyPd.put("operaType", Const.FLOW_OPERA_TYPE_XYB);
			historyPd.put("score", "0");
		}else if("end".equals(handleType)){//结束
			historyPd.put("operaType", Const.FLOW_OPERA_TYPE_END);
			historyPd.put("score", "0");
		}
		historyPd.put("remarks", remarks);
		historyPd.put("fileId", fileId);
		flowTaskService.saveFlowWorkHistory(historyPd);
	}
	/**
	 * 保存任务日清时上传的附件
	 */
	private Integer saveTaskFile2(String fileName, String taskType, String taskId, String userName) throws Exception{
		PageData filePd = new PageData();
		filePd.put("fileName", fileName);
		filePd.put("taskType", taskType);
		filePd.put("taskId", taskId);
		filePd.put("createUser", userName);
		filePd.put("createDate", new Date());
		taskFileService.saveFile(filePd);
		return Integer.parseInt(filePd.get("id").toString());
	}
	@RequestMapping("toHandleFlowTask")
	public ModelAndView toHandleFlowTask(){
		logBefore(logger, "跳转到流程工作处理界面");
		ModelAndView mv = this.getModelAndView();
		PageData pd = this.getPageData();
		try {
			String handleType = pd.getString("handleType");
			if("receive".equals(handleType)){
				//查询当前节点是否对应子流程模板
				List<PageData> flowModelList = flowTaskService.findFlowByFlowWorkNodeId(pd);
				mv.addObject("flowModelList", flowModelList);
			}else if("next".equals(handleType)||"back".equals(handleType)){
				//查询员工的岗位职责明细
				List<PageData> dutyList = positionDutyService.findAllDetailByEmpCode(getUser().getNUMBER());
				mv.addObject("dutyList", dutyList);
//				pd.put("availableStatus", Const.SYS_STATUS_YW_DSX);
				pd.put("finishStatus", Const.SYS_STATUS_YW_YWB);
				List<PageData> flowNodeList = flowTaskService.findAllNodeByFLowWorkId(pd);
				mv.addObject("flowNodeList", flowNodeList);
			}
			//获取部门列表
			List<PageData> deptList = deptService.listAlln();
			mv.addObject("deptList", deptList);
			mv.addObject("score",pd.getString("score"));
		} catch (Exception e) {
			logger.error("查询当前节点是否对应子流程出错", e);
		}
		
		mv.setViewName("app/task/appHandleFlowTask");
		mv.addObject("pd", pd);
		return mv;
	}
	
	/**
	 * 根据部门编码获取岗位
	 * @param deptIds
	 * @return
	 */
	@ResponseBody
	@RequestMapping("findPositionByDeptId")
	public List<PageData> findPositionByDeptId(String deptId){
		try {
			return positionLevelService.findPositionByDeptId(deptId);
		} catch (Exception e) {
			e.printStackTrace();
			return null;
		}
	}
    /**
     * 根据职位获取员工
     * @param positionId
     * @return
     */
    @ResponseBody
    @RequestMapping("findEmpByPosition")
    public List<PageData> findEmpByPosition(String positionId){
    	try {
			return employeeService.findEmpByPosition(positionId);
		} catch (Exception e) {
			e.printStackTrace();
			return null;
		}
    }
    
    /**
     * 日常任务上传附件
     */
    @ResponseBody
    @RequestMapping(value = "/saveFile")
    public String saveFile(@RequestParam(required=false) MultipartFile file, HttpServletRequest request){
		PageData pd = new PageData(request);
		try {
			User user = getUser();
			//上传附件
			if(null != file && !file.isEmpty()){
				String daily_task_id = pd.get("daily_task_id").toString();
				pd.put("taskId", daily_task_id);
				pd.put("taskType", Const.TASK_TYPE_D);
				taskFileService.deleteFile(pd);
				
				logBefore(logger, "开始上传文件"); 
				String fileName = FileUpload.uploadFile(request, file, Const.FILEPATHTASK);
				saveTaskFile(fileName, Const.TASK_TYPE_D, daily_task_id, user.getUSERNAME());
			}
		}catch (Exception e) {
			e.printStackTrace();
		}
		return "success";
    }

    /**
     * 处理流程工作
     * @param request
     * @return
     */
    @ResponseBody
    @RequestMapping(value="handleFlowWork")
    public String handleFlowWork(HttpServletRequest request){
		logBefore(logger, "处理流程工作");
		try {
			PageData pd = new PageData(request);
			String handleType = pd.getString("handleType");
			String nextNodeId = pd.getString("nextNodeId");
			User user = getUser();
			Date now = new Date();
			String document = (String) pd.get("DOCUMENT");
			JSONArray json = JSONArray.fromObject(document);
			String str = "";// 上传的附件ID
			if (json != null && json.size() != 0) {
				for (int i = 0; i < json.size(); i++) {
					JSONObject jo = json.getJSONObject(i);
					String fileName = jo.get("filename").toString();
					String fileName_server = jo.get("filename_server")
							.toString();
					Integer fileId = null;
					fileId = saveTaskFile(fileName, fileName_server,
							Const.TASK_TYPE_F, pd.getString("nodeId"),
							user.getUSERNAME());
					str += "," + String.valueOf(fileId);
				}
				str = str.substring(1);
			}
			if (str.isEmpty()) {
				str = null;
			}
			//更新当前节点状态
			if("receive".equals(handleType)){//接收
				pd.put("status", Const.SYS_STATUS_YW_YJS);
				flowTaskService.updateFlowWorkNode(pd);
				//记录操作历史
				saveFlowWorkHistory(pd.getString("flowId"), pd.getString("nodeId"), nextNodeId,null,
						handleType, pd.getString("remarks"), str, now, user, request, pd.getString("score"));
			}else if("back".equals(handleType) || "next".equals(handleType)){//退回//下一步
				//下一个节点状态
				String nextNodeStatus = "";
				//当前节点更新状态
				if("back".equals(handleType)){//退回
					pd.put("status", Const.SYS_STATUS_YW_DSX);
					nextNodeStatus = Const.SYS_STATUS_YW_YTH;
				}else{//下一步
					pd.put("status", Const.SYS_STATUS_YW_YWB);
					nextNodeStatus = Const.SYS_STATUS_YW_YSX;
				}
				flowTaskService.updateFlowWorkNode(pd);//更新当前节点状态
				//处理页面传递的参数
				String inputStr = pd.getString("inputStr");
				String[] inputArr = inputStr.split(";");
				for(int i=0; i<inputArr.length; i++){
					PageData nextNodePd = new PageData();
					//拆分页面输入框保存的id
					String[] idArr = inputArr[i].split(",");
					//先查询下一步节点信息
					PageData nextFlowNode = flowTaskService.findFlowWorkNodeById(Integer.parseInt(idArr[0]));
					String nextNodeEmp = "";
					if(idArr.length>1){//页面重新选择了人员信息
						nextNodePd.put("deptId", idArr[1]);
						nextNodePd.put("positionId", idArr[2]);
						nextNodePd.put("empCode", idArr[3]);
						nextNodeEmp = idArr[3];
					}else{//页面没有选择
						nextNodeEmp = nextFlowNode.getString("EMP_CODE");
					}
					if("next".equals(handleType)){
							// 更新下一步节点状态
							nextNodePd.put("nodeId", idArr[0]);
							nextNodePd.put("status", nextNodeStatus);
							flowTaskService.updateFlowWorkNode(nextNodePd);
//						}
							// 记录操作历史
							saveFlowWorkHistory(pd.getString("flowId"),
									pd.getString("nodeId"), idArr[0], nextNodeEmp, handleType,
									pd.getString("remarks"), str, now, user, request,"0");
					}else if("back".equals(handleType)){
						// 更新下一步节点状态
						nextNodePd.put("nodeId", idArr[0]);
						nextNodePd.put("status", nextNodeStatus);
						flowTaskService.updateFlowWorkNode(nextNodePd);
						// 记录操作历史
						saveFlowWorkHistory(pd.getString("flowId"),
								pd.getString("nodeId"), idArr[0], nextNodeEmp, handleType,
								pd.getString("remarks"), str, now, user, request, pd.getString("score"));
					}
				}
			}else if("end".equals(handleType)){//结束
				//结束流程
				PageData flowPd = new PageData();
				flowPd.put("flowId", pd.get("flowId"));
				flowPd.put("status", Const.SYS_STATUS_YW_YZZ);
				flowTaskService.endFlow(flowPd);
				//记录操作历史
				saveFlowWorkHistory(pd.getString("flowId"),
						pd.getString("nodeId"), nextNodeId, null,  handleType,
						pd.getString("remarks"), str, now, user, request,"0");
			}
			
			//记录节点的时间情况
			PageData nodePd = new PageData();
			nodePd.put("nodeId", pd.get("nodeId"));
			if("receive".equals(handleType)){//接收
				nodePd.put("startTime", now);
				//接收后保存开始时间
				flowTaskService.saveFlowNodeTime(nodePd);
			}else{//保存结束时间
				nodePd.put("endTime", now);
				flowTaskService.updateFlowNodeTime(nodePd);
			}
			
		} catch (Exception e) {
			logger.error("接收流程工作出错", e);
			return "fail";
		}
		
		return "success";
    	
    }
    /**
     * 根据流程ID获取流程明细，包括节点明细、流程历史等
     * @param flowId
     * @return
     */
    @RequestMapping("showDetail")
    public ModelAndView showDetail(){
    	ModelAndView modelAndView = new ModelAndView();
    	PageData pd = this.getPageData();
    	String ID = pd.getString("ID");
    	try {
    		Gson gson = new Gson();
			PageData flowWork = flowWorkService.findById(ID);
			modelAndView.addObject("flowWork", flowWork);
			modelAndView.addObject("flowNodes", flowWorkService.findNodesById(ID));
			modelAndView.addObject("nodesGson", gson.toJson(flowWorkService.findNodesById(ID)));
			List<PageData> flowWorkHistory = flowWorkService.findHistoryById(ID);
			for (PageData flow:flowWorkHistory) {
				String score = "0";
				if(flow.get("SCORE")!=null){
					if(!flow.getString("SCORE").equals("0")){
						 score = flow.getString("SCORE");
						 score = score.substring(1);
					}
				}
				flow.put("SCORE", score);
				if(flow.get("FILE_ID")!=null&&!flow.get("FILE_ID").toString().equals("")){
					String fileId = flow.getString("FILE_ID");
					String[] arr = fileId.split(",");
					List<PageData> fileList = flowWorkService.findFileList(arr);
					String fileNameStr="";
					for (PageData filePd:fileList) {
						if(filePd.get("FILENAME_SERVER")!=null){
							fileNameStr+=","+filePd.getString("FILENAME_SERVER");
						}
					}
					if(fileNameStr!=""){
						fileNameStr = fileNameStr.substring(1);
					}
					flow.put("fileNameStr", fileNameStr);
					flow.put("fileList", fileList);
				}else{
					flow.put("fileList", null);
					flow.put("fileNameStr", "");
				}
			}
			modelAndView.addObject("flowHistory", flowWorkHistory);
		} catch (Exception e) {
			e.printStackTrace();
		}
    	modelAndView.addObject("pd",pd);
    	modelAndView.setViewName("app/task/appFlowWorkDetail");
    	return modelAndView;
    }
    
    @ResponseBody
    @RequestMapping(value="saveManageComment")
	public String saveManageComment(){
		ModelAndView mv = new ModelAndView();
		try {
			PageData pd = this.getPageData();
			savePage(pd);
			//保存批示内容
			empDailyTaskService.saveManageComment(pd);
			//保存评分
			pd.put("scorePerson", getUser().getNUMBER());
			empDailyTaskService.saveScore(pd);
		} catch (Exception e) {
			mv.addObject("msg", "保存行政批示出错");
			logger.error("保存行政批示出错", e);
		}
		return "success";
	}
    /**
     * 查询节点上的岗位职责明细
     */
    @RequestMapping("showNodeDetail")
    public ModelAndView showNodeDetail(){
    	ModelAndView mv = new ModelAndView();
     	PageData pd = this.getPageData();
     	String workNodeId = pd.getString("workNodeId");
    	try {
			List<PageData> dutyList = flowWorkService.findDutyDetailByNodeId(workNodeId);
//			PageData file = flowWorkService.findFileNameByNodeId(workNodeId);
//			mv.addObject("file", file);
			mv.addObject("dutyList", dutyList);
		} catch (Exception e) {
			logger.error("查询节点上的岗位职责明细出错", e);
		}
    	mv.addObject("pd",pd);
    	mv.setViewName("app/task/flowWorkNodeDetail");
    	return mv;
    }
    
    /**
	 * 根据所选责任部门查询员工
	 */
	@RequestMapping(value = "/findEmpByDept", produces = "text/html;charset=UTF-8")
	public void findEmpByDept(@RequestParam String deptId, HttpServletResponse response) throws Exception {
		try {
			Map<String, Object> map = new HashMap<String, Object>();
			
			logBefore(logger, "根据所选责任部门查询员工");
			
			PageData pd = new PageData();
			pd.put("ID", deptId);
			pd = deptService.findById(pd);
			List<PageData> empList = employeeService.findEmpByDept(deptId);
			for (PageData pageData : empList) {
				if(pageData.get("ID").equals(pd.get("DEPT_LEADER_ID"))){
					pageData.put("leader", true);
					break;
				}
			}
			
			map.put("list", empList);
			JSONObject jo = JSONObject.fromObject(map);
			String json = jo.toString();
			
			response.setCharacterEncoding("UTF-8");
			response.setContentType("text/html");
			PrintWriter out = response.getWriter();
			out.write(json);
			out.flush();
			out.close();
			
		} catch (Exception e) {
			logger.error(e.toString(), e);
		}
		
	}
	/**
     * 日常类目标检查Statge是否可用
     * @throws Exception
     * author yangdw
     */
    @RequestMapping(value = "/checkAdd")
    @ResponseBody
    public Object checkAdd() throws Exception {
        Map<String, Object> map = new HashMap<String, Object>();
        PageData pd = this.getPageData();
        try{
            pd.put("EMP_CODE",getUser().getNUMBER());
            String status = positionDailyTaskService.checkAdd(pd);
            map.put("status",status);
        }catch (Exception e){
            logger.error(e.toString(), e);
        }
        return AppUtil.returnObject(pd,map);
    }
	

	/**
	 * 评价活动
	 */
	@ResponseBody
	@RequestMapping("assessEvent")
	public String assessEvent() {
		logBefore(logger, "评价活动");
		//更新活动审核人
		try {
			PageData eventPd = this.getPageData();
			eventPd.put("status", Const.SYS_STATUS_YW_YPJ);
			empDailyEventService.updateProjectEventByID(eventPd);
			return "success";
		} catch (Exception e) {
			return "error";
		}
	}
	

    /**
     * 添加日常日清
     * @return mv
     * @throws Exception
     * author yangdw
     */
    @RequestMapping(value="/add")
    public ModelAndView add() throws Exception {
        logBefore(logger, "添加行政日清");
        ModelAndView mv = this.getModelAndView();
        User user = getUser();
        try {
            PageData addPd = new PageData();
            addPd.put("EMP_CODE",user.getNUMBER());
            addPd.put("STATUS", "YW_CG");//设置状态为草稿
            savePage(addPd);
            positionDailyTaskService.add(addPd);//新增行政日清列表
            listDailyTaskDetail(addPd.get("ID").toString(), mv, user);
        }catch (Exception e){
            logger.error(e.toString(), e);
        }
        mv.addObject("PARENT_FRAME_ID",this.getPageData().get("PARENT_FRAME_ID"));
        PageData pd = this.getPageData();
	    //获取shiro权限,是否配置了修改日常工作时间的权限
		pd.put("allowChangTime", SecurityUtils.getSubject().isPermitted("listTask:add()"));
	    mv.addObject("flag",this.getPageData().get("show").toString());
	    mv.addObject("pd",pd);
	    mv.setViewName("app/task/appDailyTask");
        return mv;
    }
    /**
     * 车间人员维护日清时间
     * @return mv
     * @throws Exception
     * author yangdw
     */
    @RequestMapping(value="/changeTimeByWorker")
    public ModelAndView changeTimeByWorker() throws Exception {
        logBefore(logger, "修改某个日清详情的时间");

        PageData pd = this.getPageData();
        ModelAndView mv = this.getModelAndView();

        if(null != pd.get("START_TIME_ARR") && !"".equals(pd.get("START_TIME_ARR").toString())
                && null != pd.get("END_TIME_ARR") && !"".equals(pd.get("END_TIME_ARR").toString())){
            List<PageData> timeList = new ArrayList<PageData>();
            String[] start_time_arrs =  pd.get("START_TIME_ARR").toString().split(";");
            String[] end_time_arrs =  pd.get("END_TIME_ARR").toString().split(";");
            for(int i = 0; i < start_time_arrs.length;i ++){
                PageData timePd = new PageData();
                timePd.put("start_time",start_time_arrs[i]);
                timePd.put("end_time",end_time_arrs[i]);
                timeList.add(timePd);
            }
            mv.addObject("timeList",timeList);
        }
        //将日期放入
        mv.addObject("Date",pd.get("Date"));
        mv.addObject("pd",pd);
        mv.addObject("taskStatus", pd.get("taskStatus"));
        mv.setViewName("app/task/changeTimeByWorker");
        return mv;
    }
	
    @RequestMapping(value="/saveDetailChange")
    public ModelAndView saveDetailChange() throws Exception {
    	ModelAndView mv = this.getModelAndView();
        PageData pd = this.getPageData();
        Subject currentUser = SecurityUtils.getSubject();
        Session session = currentUser.getSession();

        try{
        	String id = pd.getString("ID");
        	String start_time_arrs = pd.getString("start_time_arrs");
            String end_time_arrs = pd.getString("end_time_arrs");
            String counts = Integer.valueOf(start_time_arrs.split(";").length).toString();
        	List<PageData> addDetailList = new ArrayList<PageData>();
            List<PageData> updateDetailList = new ArrayList<PageData>();
            
            PageData detail = new PageData();
            detail.put("daily_task_id",pd.get("daily_task_id"));//行政日清id
            detail.put("UPDATE_USER", session.getAttribute(Const.SESSION_USERNAME));//最后更新人
            detail.put("UPDATE_TIME", Tools.date2Str(new Date()));//最后更新时间
            detail.put("detail_id",pd.getString("detail_id"));//细节ID
            detail.put("count",counts);//数量
            detail.put("score","0");//分数
            detail.put("status","YW_CG");//状态
            detail.put("start_time_arrs",start_time_arrs);//起始时间数组
            detail.put("end_time_arrs",end_time_arrs);//结束时间数组
            if("".equals(id)){
                //如果id不存在，那么就是增加
                detail.put("CREATE_USER", session.getAttribute(Const.SESSION_USERNAME));//创建人
                detail.put("CREATE_TIME", Tools.date2Str(new Date()));//创建时间
                addDetailList.add(detail);
            }else {
                //如果id存在，就是更新
                detail.put("ID",id);//ID
                updateDetailList.add(detail);
            }
            
          //批量删除
            PageData deletePd = new PageData();
            deletePd.put("daily_task_id",pd.get("daily_task_id"));
            List<String> update_ids = new ArrayList<String>();
            List<String> updateCount0_ids = new ArrayList<String>();
            if(null != id&& !("").equals(id) && null != counts && !("0").equals(counts) && !("").equals(counts)){
                update_ids.add(id);
            }else if(null != id && !("").equals(id) && null != counts && ("0").equals(counts) && !("").equals(counts)){
            	updateCount0_ids.add(id);
            }
            //2016-07-08 yangdw 考虑到第一次新增时可能update_ids为空
            update_ids.add("0");
            deletePd.put("update_ids",update_ids);
            deletePd.put("new_update_ids",updateCount0_ids);
            positionDailyTaskService.batchDeleteDetail(deletePd);//细节表
            userLogService.logInfo(new UserLog(getUser().getUSER_ID()
                    , UserLog.LogType.delete, "行政日清细节", "批量删除"));//操作日志入库

            //新增
            if(null != addDetailList && 0 != addDetailList.size()){
                    //新增行政日清细节
                    PageData addDeatail = addDetailList.get(0);
                    if(!addDeatail.getString("count").equals("0")){
                        positionDailyTaskService.addDetail(addDeatail);
                        //批量新增行政日清详情时间
                        batchAddDetaiTime(pd,addDeatail);
                    }
                }
                userLogService.logInfo(new UserLog(getUser().getUSER_ID()
                        , UserLog.LogType.add, "行政日清细节", "新增"));//操作日志入库

            //更新
            if(null != updateDetailList && 0 != updateDetailList.size()){
                    //更新行政日清细节
                    PageData updateDetail = updateDetailList.get(0);
                    positionDailyTaskService.updateDetail(updateDetail);
                    PageData newDeletePd = new PageData();
                    String[] new_update_ids = updateDetail.get("ID").toString().split(",");
                    newDeletePd.put("new_update_ids",new_update_ids);
                    //批量删除行政日清详情时间
                    positionDailyTaskService.batchDeleteDetailTime(newDeletePd);
                    if(!updateDetail.getString("count").equals("0")){
                        //批量新增行政日清详情时间
                        batchAddDetaiTime(pd,updateDetail);
                    }
                userLogService.logInfo(new UserLog(getUser().getUSER_ID()
                        , UserLog.LogType.add, "行政日清细节", "更新"));//操作日志入库
            }
            mv.addObject("flag","success");
        	
        }catch(Exception e){
        	logger.error(e.toString(), e);
            mv.addObject("flag","false");
        }
    	
        //获取shiro权限,是否配置了修改日常工作时间的权限
      	pd.put("allowChangTime", SecurityUtils.getSubject().isPermitted("listTask:add()"));
      	pd.put("show", "2");
	    mv.addObject("pd",pd);
	    listDailyTaskDetail(pd.getString("daily_task_id"),mv,getUser());
	    mv.addObject("flag",pd.get("show").toString());
	    mv.setViewName("app/task/appDailyTask");
        return mv;
    }
    
    /**
     * 批量新增行政日清详情时间
     * @param pd
     * @param detail
     * @throws Exception
     * author yangdw
     */
    private void batchAddDetaiTime(PageData pd,PageData detail) throws Exception{
        String[] new_start_time_arrs = detail.getString("start_time_arrs").split(";");
        String[] new_end_time_arrs = detail.getString("end_time_arrs").split(";");
        if(new_start_time_arrs.length == new_end_time_arrs.length){
            for(int j = 0;j < new_start_time_arrs.length;j ++){
                //新增行政日清细节时间
                PageData addDetailTime = new PageData();
                addDetailTime.put("task_detail_id",detail.get("ID"));
                addDetailTime.put("start_time",pd.get("date") + " " + new_start_time_arrs[j]);
                addDetailTime.put("end_time",pd.get("date") + " " + new_end_time_arrs[j]);
                addDetailTime.put("groups", ""+detail.get("daily_task_id") + detail.get("ID") + Integer.valueOf((j+1)).toString());
                addDetailTime.put("status", Const.DAILY_TASK_OPERA_END);
                SimpleDateFormat formatter = new SimpleDateFormat( "yyyy-MM-dd HH:mm");
                Date start = formatter.parse(addDetailTime.getString("start_time"));
                Date end = formatter.parse(addDetailTime.getString("end_time"));
                addDetailTime.put("duration", (end.getTime()-start.getTime())/1000);
                savePage(addDetailTime);
                positionDailyTaskService.addDetailTime(addDetailTime);//细节表
            }
        }
    }

}
