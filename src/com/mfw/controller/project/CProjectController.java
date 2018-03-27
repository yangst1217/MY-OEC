package com.mfw.controller.project;

import java.io.PrintWriter;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.ModelAndView;

import com.google.gson.Gson;
import com.mfw.controller.base.BaseController;
import com.mfw.entity.Page;
import com.mfw.entity.project.CProject;
import com.mfw.entity.system.UserLog;
import com.mfw.entity.system.UserLog.LogType;
import com.mfw.service.analyze.AnalyzeService;
import com.mfw.service.bdata.CommonService;
import com.mfw.service.bdata.DeptService;
import com.mfw.service.bdata.EmployeeService;
import com.mfw.service.project.CProjectEventService;
import com.mfw.service.project.CProjectNodeService;
import com.mfw.service.project.CProjectService;
import com.mfw.service.system.UserLogService;
import com.mfw.service.system.role.RoleService;
import com.mfw.service.task.TaskFileService;
import com.mfw.util.Const;
import com.mfw.util.EndPointServer;
import com.mfw.util.FileUpload;
import com.mfw.util.PageData;
import com.mfw.util.TaskType;

import net.sf.json.JSONArray;

/**
 * Controller-重点协同项目
 * @author liweitao
 *
 */
@Controller
@RequestMapping("/cproject")
public class CProjectController extends BaseController {

	@Resource(name="cprojectService")
	private CProjectService projectService;
	@Resource(name="userLogService")
	private UserLogService userlogService;
	@Resource(name = "deptService")
	private DeptService deptService;
	@Resource(name = "employeeService")
	private EmployeeService employeeService;
	@Resource(name="cpNodeService")
	private CProjectNodeService cpNodeService;
	@Resource(name="cpEventService")
	private CProjectEventService cpEventService;
	@Resource(name="analyzeService")
	private AnalyzeService analyzeService;
	@Resource(name="roleService")
	private RoleService roleService;
	@Resource(name="commonService")
	private CommonService commonService;
	@Resource(name = "taskFileService")
	private TaskFileService taskFileService;
		
	/**
	 * 分页查询
	 * @param page
	 * @param request
	 * @return
	 */
	@ResponseBody
	@RequestMapping(value="/findList")
	public HashMap<String, Object> findList(Page page, HttpServletRequest request){
		HashMap<String, Object> result = new HashMap<>();
		
		convertPage(page, request);
		PageData pageData = page.getPd();
		
		pageData.put("currentUser", getUser().getUSERNAME());
		int current = Integer.valueOf(request.getParameter("current"));
		int pageCount = Integer.valueOf(request.getParameter("rowCount"));
		page.setPd(pageData);
		page.setShowCount(pageCount);
		page.setCurrentPage(current);
		
		try {
			List<PageData> projectList = projectService.findList(page);
			for(int i = 0; i < projectList.size(); i++){
				PageData project = projectList.get(i);
				Boolean isScoed = projectService.IsScored(project.getString("CODE"));
				projectList.get(i).put("isScoed", isScoed);
			}
			int total = projectService.countCP(page);
			result.put("rows", projectList);
			result.put("current", current);
			result.put("rowCount", pageCount);
			result.put("total", total);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return result;
	} 
	
	/**
	 * 待审批列表
	 * @return
	 */
	@ResponseBody
	@RequestMapping(value="auditList",method=RequestMethod.POST)
	public HashMap<String, Object> auditList(Page page, HttpServletRequest request){
		HashMap<String, Object> result = new HashMap<>();
		convertPage(page, request);
		PageData pageData = page.getPd();
		pageData.put("user", getUser().getNUMBER());
		
		pageData.put("currentUser", getUser().getUSERNAME());
		int current = Integer.valueOf(request.getParameter("current"));
		int pageCount = Integer.valueOf(request.getParameter("rowCount"));
		page.setPd(pageData);
		page.setShowCount(pageCount);
		page.setCurrentPage(current);
		
		List<PageData> projectList = new ArrayList<>();
		int total = 0;
		try {
			projectList = projectService.auditList(page);
			//total = projectService.countAudit(page);
			total = projectList.size();
			
			result.put("rows", projectList);
			result.put("current", current);
			result.put("rowCount", pageCount);
			result.put("total", total);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return result;
	}
	
	/**
	 * 审批通过
	 * @param suggest
	 * @return
	 */
	@ResponseBody
	@RequestMapping(value="audit",method=RequestMethod.POST)
	public ModelAndView audit(CProject project){
		ModelAndView mv = this.getModelAndView();
		
		project.setUpdateTime(new Date());
		project.setUpdateUser(getUser().getNUMBER());
		
		try {
			if(project.getStatus().equals("YW_TG") || project.getStatus().equals("YW_BTG")){
				String result = projectService.sign(project);
				if(result.equals("success")){
					userlogService.logInfo(
						new UserLog(
							getUser().getUSER_ID(), 
							LogType.update,
							"重点协同项目",
							"一次会签成功，编码：" + project.getCode()
						)
					);
					mv.addObject("msg", "success");
				}
			}else if(project.getStatus().equals("YW_YYS")){
				PageData pd = this.getPageData();
				pd.put("UPDATE_USER", getUser().getNUMBER());
				pd.put("UPDATE_TIME", new Date());
				pd.put("STATE", Const.SYS_STATUS_YW_YYS);
				//更新验收分数
				projectService.updateAcceptance(pd);
				//获得项目下未验收的个数
				int unAcceptanceCount = projectService.findUnAccCount(pd);
				//如果全部都验收了，查平均数，修改项目状态
				if(unAcceptanceCount == 0){
					int avgScore = projectService.findAvgScore(pd);
					if(avgScore >= 6)
						project.setStatus(Const.SYS_STATUS_YW_YWB);
					else
						project.setStatus(Const.SYS_STATUS_YW_WWC);
					projectService.audit(project);
				}
				mv.addObject("msg", "success");
				
			}else{
				String result = projectService.audit(project);
				EndPointServer.sendMessage(getUser().getNAME(), project.getEmpCode(), TaskType.cproject);
				if(result.equals("success")){
					userlogService.logInfo(
						new UserLog(
							getUser().getUSER_ID(), 
							LogType.update,
							"重点协同项目",
							"审核成功，编码：" + project.getCode()
						)
					);
					mv.addObject("msg", "success");
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		mv.setViewName("save_result");
		return mv;
	}
	
	/**
	 * 跳转新增页面
	 * @return
	 */
	@RequestMapping("toAdd")
	public ModelAndView toAdd(HttpServletRequest request){
		ModelAndView modelAndView = getModelAndView();
		String id = request.getParameter("id");
		try {
			
			//列出所有部门
			//List<PageData> deptList = deptService.listWithAuth(getUser());
			PageData pd = getPageData();
			List<PageData> deptList = deptService.listAll(pd);
			JSONArray arr = JSONArray.fromObject(deptList);
			
			//列出所有领导
			List<PageData> leaderList = employeeService.listAll(new PageData());
			
			//列出字典中所有项目类型
			List<PageData> projectTypes = commonService.typeListByBm(Const.PROJECT_TYPE_CODE);
			//编辑
			if(id != null){
				PageData pageData = projectService.findById(Integer.valueOf(id));
				modelAndView.addObject("project", pageData);
				
				List<PageData> emps = employeeService.findEmpByDept(
						String.valueOf(pageData.get("deptId")));
				modelAndView.addObject("emps", emps);
				//列出会审人名单
				List<PageData> counterSigns = projectService.findCounterSign(Integer.valueOf(id));
				modelAndView.addObject("jointHearings", counterSigns);
				//查询上传的附件
				PageData filePd = new PageData();
				filePd.put("taskId", id);
				filePd.put("taskType", Const.PROJECT);
				List<PageData> fileList = taskFileService.findFile(filePd);
				modelAndView.addObject("fileList", fileList);
			}
			
			modelAndView.setViewName("project/project_edit");
			modelAndView.addObject("deptTreeNodes", arr.toString());
			modelAndView.addObject("leaders",leaderList);
			modelAndView.addObject("projectTypes",projectTypes);

		} catch (Exception e) {
			e.printStackTrace();
		}
		return modelAndView;
	}
	
	/**
	 * 跳转详情页
	 * @param id
	 * @return
	 */
	@RequestMapping("info")
	public ModelAndView info(){
		ModelAndView modelAndView = getModelAndView();
		try {
			PageData pageData = projectService.findProjectByParam(getPageData());
			//获取会签人信息
			PageData signName = projectService.findAllSigners(pageData);
			//获取所有会签信息（包含历史）
			List<PageData> signAll = projectService.fidAllSignInfo(pageData);
			//查询上传的附件
			PageData filePd = new PageData();
			filePd.put("taskId", pageData.get("ID"));
			filePd.put("taskType", Const.PROJECT);
			List<PageData> fileList = taskFileService.findFile(filePd);
			
			modelAndView.addObject("fileList", fileList);
			modelAndView.addObject("signAll",signAll);
			modelAndView.addObject("signName",signName);
			modelAndView.addObject("project", pageData);
			modelAndView.setViewName("project/project_info");
		} catch (Exception e) {
			e.printStackTrace();
		}
		return modelAndView;
	}
	
	/**
	 * 跳转审核页面
	 * @param id
	 * @return
	 */
	@RequestMapping("toAudit")
	public ModelAndView toAudit(){
		ModelAndView modelAndView = getModelAndView();
		try {
			PageData pageData = projectService.findProjectByParam(getPageData());
			pageData.put("stamp", getPageData().get("stamp"));
			modelAndView.addObject("project", pageData);
			modelAndView.setViewName("project/project_audit");
		} catch (Exception e) {
			e.printStackTrace();
		}
		return modelAndView;
	}
	
	/**
	 * 跳转会审页面
	 * @param id
	 * @return
	 */
	@RequestMapping("toSign")
	public ModelAndView toSign(){
		ModelAndView modelAndView = getModelAndView();
		try {
			PageData pd = getPageData();
			pd.put("author", getUser().getNUMBER());
			PageData pageData = new PageData();
			pageData = projectService.findProSignByParam(pd);
			pageData.put("preparation1", pageData.get("OPINION_DETAIL"));

			pageData.put("stamp", getPageData().get("stamp"));
			modelAndView.addObject("project", pageData);
			modelAndView.setViewName("project/project_audit");
		} catch (Exception e) {
			e.printStackTrace();
		}
		return modelAndView;
	}
	
	/**
	 * 保存上传的附件
	 */
	private Integer saveTaskFile(String fileName, String fileName_server,
			String taskType, String taskId, String userName) throws Exception {
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
	 * 异步上传附件
	 */
	@ResponseBody
	@RequestMapping(value = "/uploadFile")
	public void uploadFile(@RequestParam(required = false) MultipartFile[] fileArr,  
			HttpServletResponse response, HttpServletRequest request) throws Exception{
		Map<String, Object> map = new HashMap<String, Object>();
		List<Map<String, Object>> list = new ArrayList<Map<String, Object>>();
		try {
			for(int i=0; i<fileArr.length; i++){
				if (null != fileArr[i] && !fileArr[i].isEmpty()) {
					String filename = fileArr[i].getOriginalFilename();
					String filename_server = FileUpload.uploadFileNew(request, fileArr[i], Const.FILEPATHTASK);
					map = new HashMap<String, Object>();
					map.put("filename", filename);
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
		}catch (Exception e){
			logger.error(e.toString(), e);
		}
	}
	
	/**
	 * 处理上传的附件
	 */
	private void saveFile(MultipartFile[] fileArr, String fileNameArray,  HttpServletRequest request, 
			String projectId) throws Exception{
		//上传附件框中的文件
		if (null != fileArr && fileArr.length>0) {
			logBefore(logger, "开始上传文件");
			for(MultipartFile file : fileArr){
				if(file.isEmpty()){
					continue;
				}
				String str = FileUpload.uploadFile(request, file, Const.FILEPATHTASK);
				String fileName = str.split(",")[0];
				String fileName_server = str.split(",")[1];
				saveTaskFile(fileName, fileName_server, Const.PROJECT, projectId, getUser().getUSERNAME());
			}
		}
		//关联之前上传的文件
		if(null != fileNameArray && !fileNameArray.isEmpty()){
			String[] fileNameArr = fileNameArray.split(";");
			for(String str : fileNameArr){
				String fileName = str.split(",")[0];
				String fileName_server = str.split(",")[1];
				saveTaskFile(fileName, fileName_server, Const.PROJECT, projectId, getUser().getUSERNAME());
			}
		}
	}
	
	/**
	 * 新增或修改重点协同项目信息
	 * @param project
	 * @return
	 */
	@RequestMapping(value="/saveOrUpdate", method=RequestMethod.POST)
	public ModelAndView saveOrUpdate(@RequestParam(required = false) MultipartFile[] fileArr, 
			@RequestParam(required = false) String fileNameArray, CProject project, HttpServletRequest request){
		ModelAndView mv = this.getModelAndView();
		try {
			//新增
			if(null == project.getId() || project.getId().equals("")){
				project.setCode(getCurrentCode(project));
				project.setCreateTime(new Date());
				project.setCreateUser(getUser().getUSERNAME());
				project.setStatus(Const.SYS_STATUS_YW_CG);
				projectService.add(project);
				//增加会审人信息
				if(project.getJointHearing()!=null && !"".equals(project.getJointHearing())){
					String[] jointHearings = project.getJointHearing().split(",");
					List<PageData> counters = employeeService.getAllByCodes(jointHearings);
					project.setCreateUser(getUser().getNUMBER());
					projectService.addSigns(counters,project);
				}
				//保存上传的附件
				saveFile(fileArr, fileNameArray, request, project.getId());
				mv.addObject("msg", "success");
				userlogService.logInfo(new UserLog(getUser().getUSER_ID(), LogType.add, 
						"重点协同项目", "编码："+project.getCode()));
			}else{//编辑
				project.setUpdateTime(new Date());
				project.setUpdateUser(getUser().getUSERNAME());
				projectService.update(project);
				//先删除后修改会签人信息
				projectService.deleteSigns(Integer.valueOf(project.getId()));
				if(project.getJointHearing()!=null && !"".equals(project.getJointHearing())){
					String[] jointHearings = project.getJointHearing().split(",");
					List<PageData> counters = employeeService.getAllByCodes(jointHearings);
					PageData pageData = projectService.findById(Integer.valueOf(project.getId()));
					project.setCreateTime((Date) pageData.get("CREATE_TIME"));
					project.setCreateUser(getUser().getUSERNAME());
					project.setUpdateUser(getUser().getNUMBER());
					projectService.addSigns(counters,project);
				}
				saveFile(fileArr, fileNameArray, request, project.getId());
				mv.addObject("msg", "success");
				userlogService.logInfo(new UserLog(getUser().getUSER_ID(), LogType.update, 
						"重点协同项目", "编码："+project.getCode()));
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		mv.setViewName("save_result");
		return mv;
	}
	
	/**
	 * 提交审核
	 * @param id
	 * @return
	 */
	@ResponseBody
	@RequestMapping(value="/refer", method=RequestMethod.POST)
	public String refer(String id){
		String result = "";
		int param = Integer.valueOf(id);
		try {
			PageData pageData = projectService.findById(param);
			pageData.put("STATUS", Const.SYS_STATUS_YW_DSX);
			pageData.put("UPDATE_USER", getUser().getNUMBER());
			pageData.put("UPDATE_TIME", new Date());
			pageData.put("MARKER", (Integer)pageData.get("MARKER")+1);
			result = projectService.refer(pageData);
			
			EndPointServer.sendMessage(getUser().getNAME(), pageData.getString("EMP_CODE"), TaskType.cprojectAudit);
			
			userlogService.logInfo(new UserLog(getUser().getUSER_ID(), LogType.update, 
					"重点协同项目", "提交审核，编码："+ pageData.getString("CODE")));
		} catch (NumberFormatException e) {
			e.printStackTrace();
		} catch (Exception e) {
			e.printStackTrace();
		}
		return result;
	}
	
	/**
	 * 终止重点协同项目
	 * @param id
	 * @return
	 */
	@ResponseBody
	@RequestMapping(value="/stopProject", method=RequestMethod.POST)
	public String stopProject(String id){
		String result = "";
		int param = Integer.valueOf(id);
		try {
			PageData pageData = projectService.findById(param);
			
			pageData.put("UPDATE_USER", getUser().getNUMBER());
			pageData.put("UPDATE_TIME", new Date());
			pageData.put("STATUS", Const.SYS_STATUS_YW_YZZ);
			result = projectService.stopProject(pageData);
			
			userlogService.logInfo(new UserLog(getUser().getUSER_ID(), LogType.update, 
					"重点协同项目", "提交审核，编码："+ pageData.getString("CODE")));
		} catch (NumberFormatException e) {
			e.printStackTrace();
		} catch (Exception e) {
			e.printStackTrace();
		}
		return result;
	}
	
	/**
	 * 批量删除
	 * @param ids
	 * @return
	 */
	@ResponseBody
	@RequestMapping(value="delete",method=RequestMethod.POST)
	public String delete(@RequestParam("ids[]") List<String> ids){
		try {
			//批量删除项目关联的会签人信息
			projectService.deleteSignByIds(ids.toArray(new String[ids.size()]));
			//TODO 批量删除日志
			return projectService.delete(ids);
		} catch (Exception e) {
			return e.getMessage();
		}
	}
	
	@RequestMapping(value="nodesList")
	public ModelAndView nodesList(){
		ModelAndView modelAndView = new ModelAndView();
		PageData data = getPageData();
		data.put("ROLE_ID", getUser().getROLE_ID());
		data.put("user", getUser());
		try {
			PageData role = roleService.findObjectById(data);
			data.put("P_ROLE_ID", role.get("PARENT_ID").toString());
			
			List<PageData> rootNodes = projectService.getTreeNodes(data);
			rootNodes = joinNodeName(rootNodes);
			modelAndView.addObject("rootNodes", new Gson().toJson(rootNodes));
			//列出字典中所有项目类型
			List<PageData> projectTypes = commonService.typeListByBm(Const.PROJECT_TYPE_CODE);
			modelAndView.addObject("projectType", projectTypes);
			modelAndView.addObject("userid", getUser().getNUMBER());
		} catch (Exception e) {
			e.printStackTrace();
		}
		modelAndView.setViewName("project/project_nodeList");
		return modelAndView;
	}
	
	/**
	 * 项目节点和项目活动树
	 * @param map
	 * @return
	 */
	@ResponseBody
	@RequestMapping(value="treeNodes",method=RequestMethod.POST)
	public List<PageData> treeNodes(ModelMap map){
		PageData pageData = getPageData();
		pageData.put("ROLE_ID", getUser().getROLE_ID());
		pageData.put("user", getUser());
		List<PageData> result = new ArrayList<PageData>();
		try {
			PageData role = roleService.findObjectById(pageData);
			pageData.put("P_ROLE_ID", role.get("PARENT_ID").toString());
			if(pageData.get("project_starttime")!=null && !"".equals(pageData.get("project_starttime"))){
				String endDate = getLastDayOfMonth(pageData.getString("project_starttime"));
				pageData.put("project_endtime", endDate);
			}
			result = projectService.getTreeNodes(pageData);
			result = joinNodeName(result);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return result;
	}
	
	/**
	 * 获得查询条件时间的下限
	 * 
	 */
	private String getLastDayOfMonth(String startDate){
		SimpleDateFormat sdfDate = new SimpleDateFormat("yyyy-MM");
		try {
			Date date = sdfDate.parse(startDate);
			int year = date.getYear()+1900;
			int month = date.getMonth()+1;
			Calendar cal = Calendar.getInstance();
			//设置年份
			cal.set(Calendar.YEAR,year);
			//设置月份
			cal.set(Calendar.MONTH, month-1);
			//获取某月最大天数
			int lastDay = cal.getActualMaximum(Calendar.DAY_OF_MONTH);
			//设置日历中月份的最大天数
			cal.set(Calendar.DAY_OF_MONTH, lastDay);
			//格式化日期
			SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
			String lastDayOfMonth = sdf.format(cal.getTime());
			return lastDayOfMonth;
		} catch (ParseException e) {
			e.printStackTrace();
		}
		return "";
	}

	/**
	 * 显示项目信息
	 * @return
	 */
	@RequestMapping("toProjectInfo")
	public ModelAndView toProjectInfo(){
		ModelAndView modelAndView = getModelAndView();
		PageData pageData = getPageData();
		PageData signName = getPageData();
		List<PageData> acceptanceAll = new ArrayList<PageData>();
		List<PageData> signAll = new ArrayList<PageData>();
		try {
			pageData = projectService.findProjectByParam(pageData);
			//获取会签人信息
			signName = projectService.findAllSigners(pageData);
			//获取所有会签信息（包含历史）
			signAll = projectService.fidAllSignInfo(pageData);
			//查询上传的附件
			PageData filePd = new PageData();
			filePd.put("taskId", pageData.get("ID"));
			filePd.put("taskType", Const.PROJECT);
			List<PageData> fileList = taskFileService.findFile(filePd);
			modelAndView.addObject("fileList", fileList);
			//验收人信息
			acceptanceAll = projectService.findAccInfo(pageData);
		} catch (Exception e) {
			e.printStackTrace();
		}
		modelAndView.addObject("acceptanceAll", acceptanceAll);
		modelAndView.addObject("project", pageData);
		modelAndView.addObject("signAll",signAll);
		modelAndView.addObject("signName",signName);
		modelAndView.setViewName("project/project_info");
		return modelAndView;
	}

	/**
	 * 根据项目ID获取相关树节点
	 * @return
	 */
	@ResponseBody
	@RequestMapping("findTreeByProjectId")
	public HashMap<String, List<PageData>> findTreeByProjectId(){
		PageData pageData = getPageData();
		HashMap<String, List<PageData>> result = new HashMap<>();
		
		List<PageData> data = new ArrayList<>();
		List<PageData> links = new ArrayList<>();
		try {
			//添加项目根节点
			data.add(projectService.findByCodeForGantt(pageData));
			
			//添加项目节点项
			List<PageData> nodes = cpNodeService.findNodeForGantt(pageData);
			for(PageData node : nodes){
				float progress = analyzeService.getNodePercent(node.getString("id").split("_")[1]);
				node.put("progress", progress/100);
			}
			data.addAll(nodes);
			
			//添加项目活动项
			List<PageData> events = cpEventService.findEventForGantt(pageData);
			data.addAll(events);
			
			String relateId = "";
			PageData link = new PageData();
			int i = 1;
			for(PageData event : events){
				relateId = event.getString("RELATEEVENTS");
				if(relateId != null && relateId.length() > 0){
					for(String source: relateId.split(",")){
						link = new PageData();
//						link.put("id", System.currentTimeMillis());
						link.put("id", i++);
						link.put("source", "event_"+source);
						link.put("target", event.get("id"));
						link.put("type", 0);
						links.add(link);
					}
				}
			}
		} catch (NumberFormatException e) {
			e.printStackTrace();
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		result.put("data", data);
		result.put("links", links);
		return result;
	}
	
	/**
	 * 根据项目信息获取当前的编号
	 * @param project
	 * @return
	 * @throws Exception 
	 */
	private String getCurrentCode(CProject project) throws Exception{
		String code_sign = new StringBuffer()
				.append("CX")
				.append(deptService.getSignByCode(project.getDeptCode()))
				.append(project.getYear())
				.toString();
		return new StringBuffer().append(code_sign)
				.append(projectService.getCurrentCode(code_sign))
				.toString();
	}
	
	/**
	 * 拼接节点Name属性
	 * @param data
	 * @return
	 */
	private List<PageData> joinNodeName(List<PageData> datas){
		for(PageData data : datas){
			StringBuffer nodeName = new StringBuffer();
			if(data.get("STATUS").equals(Const.SYS_STATUS_YW_YSX)){
				data.put("status", "已生效");
			}else if(data.get("STATUS").equals(Const.SYS_STATUS_YW_YZZ)) {
				data.put("status", "已终止");
			}else if(data.get("STATUS").equals(Const.SYS_STATUS_YW_YSZ)){
				data.put("status", "验收中");
			}else if(data.get("STATUS").equals(Const.SYS_STATUS_YW_WWC)){
				data.put("status", "未完成");
			}else if(data.get("STATUS").equals(Const.SYS_STATUS_YW_YWB)){
				data.put("status", "已完毕");
			}else{
				data.put("status", "未生效");
			}
			
			nodeName.append("<span data-toggle='popover' data-html='true' data-toggle='popover'")
					.append(" onmouseover='showPopover(this)' onmouseout='hidePopover(this)'")
					.append(" data-content='<div style=\"margin: 6px;\">")
					.append(" 当前状态：").append(data.get("status")).append("</br>")
					.append(" 责任部门：").append(data.get("DEPT_NAME")).append("</br>")
					.append(" 责任人：").append(data.get("EMP_NAME")).append("</br>")
					.append(" 开始时间：").append(data.get("START_DATE")).append("</br>")
					.append(" 结束时间：").append(data.get("END_DATE"));
			
			//根据类型拼接持续时间
			if(!data.get("type").equals("node")){
				nodeName.append("</br>").append(" 持续时间：")
				.append(data.get("duration")).append("天");
			}
			
			nodeName.append("</div>'>").append(data.getString("name"));
			
			//拼接状态图标
			if(data.get("STATUS").equals(Const.SYS_STATUS_YW_YSX)){
				nodeName.append("<img style=\"margin-left: 3px;margin-bottom:4px;\" src='static/img/refer_y.png'>");
			}else{
				nodeName.append("<img style=\"margin-left: 3px;margin-bottom:4px;\" src='static/img/refer_n.png'>");
			}
			nodeName.append("</span>");
			data.put("name", nodeName.toString());
		}
		return datas;
	}
	
	/**
	 * 删除协同项目关联的附件
	 */
	@ResponseBody
	@RequestMapping("deleteFile")
	public String deleteFile(){
		logBefore(logger, "开始删除协同项目关联的附件");
		try {
			PageData pd = this.getPageData();
			taskFileService.deleteFileByFileId(Integer.parseInt(pd.getString("id")));
		} catch (Exception e) {
			logger.error("删除协同项目关联的附件出错", e);
			return "error";
		}
		return "success";
	}
	
	@ResponseBody
	@RequestMapping("toAcceptance")
	public ModelAndView toAcceptance(){
		ModelAndView modelAndView = getModelAndView();
		PageData pd = this.getPageData();
		List<PageData> counters = new ArrayList<PageData>();
		try {
			counters = employeeService.listAll(pd);
		}catch (Exception e) {
			e.printStackTrace();
		}
		modelAndView.addObject("empCodes", counters);
		modelAndView.addObject("id", pd.get("id"));
		modelAndView.setViewName("project/project_acceptance");
		return modelAndView;
	}
	
	@ResponseBody
	@RequestMapping("submitAcceptance")
	public ModelAndView submitAcceptance(){
		ModelAndView mv = new ModelAndView();
		PageData pd = this.getPageData();
		Integer param = Integer.valueOf(pd.getString("id"));
		try{
			PageData pageData = projectService.findById(param);
			if(pd.get("empCodes")!=null && !"".equals(pd.getString("empCodes"))){
				//删除已存在的验收记录
				projectService.deleteAcceptance(pd);
				
				//增加验收记录
				pd.put("STATE", Const.SYS_STATUS_YW_CG);
				String[] empCodes = pd.getString("empCodes").split(",");
				List<PageData> counters = employeeService.getAllByCodes(empCodes);
				pd.put("CREATE_USER", getUser().getNUMBER());
				pd.put("CREATE_NAME", getUser().getNAME());
				pd.put("CREATE_TIME", new Date());
				projectService.addAcceptance(counters,pd);
				
				//修改重点协同项目状态为未完成
				CProject cp = new CProject();
				cp.setId(pd.getString("id"));
				cp.setStatus(Const.SYS_STATUS_YW_YSZ);
				cp.setUpdateUser(getUser().getNUMBER());
				cp.setUpdateTime(new Date());
				projectService.audit(cp);
			}
			mv.addObject("msg", "success");
			userlogService.logInfo(new UserLog(getUser().getUSER_ID(), LogType.update, 
					"重点协同项目", "提交验收，编码："+ pageData.getString("CODE")));
		}catch(Exception e){
			e.printStackTrace();
		}
		mv.setViewName("save_result");
		return mv;
	}
}