package com.mfw.controller.app.tem;

import java.io.File;
import java.io.PrintWriter;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

import org.apache.shiro.SecurityUtils;
import org.apache.shiro.session.Session;
import org.apache.shiro.subject.Subject;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.ModelAndView;

import com.mfw.controller.base.BaseController;
import com.mfw.entity.Page;
import com.mfw.entity.system.User;
import com.mfw.entity.system.UserLog;
import com.mfw.service.bdata.CommonService;
import com.mfw.service.bdata.DeptService;
import com.mfw.service.bdata.EmployeeService;
import com.mfw.service.system.UserLogService;
import com.mfw.service.workorder.workOrderService;
import com.mfw.util.Const;
import com.mfw.util.EndPointServer;
import com.mfw.util.FileDownload;
import com.mfw.util.FileUpload;
import com.mfw.util.PageData;
import com.mfw.util.TaskType;
import com.mfw.util.Tools;
@Controller
@RequestMapping(value="/app_temp")
public class AppTempController extends BaseController{
	@Resource(name = "commonService")
	private CommonService commonService;
	@Resource(name = "workOrderService")
	private workOrderService workOrderService;
	@Resource(name = "deptService")
	private DeptService deptService;
	@Resource(name = "employeeService")
	private EmployeeService employeeService;
	@Resource(name = "userLogService")
	private UserLogService userLogService;
    /**
     * 进入临时工作下发页面
     * @return
     */
    @RequestMapping(value="goTemp")
    public ModelAndView goTemp(){
    	ModelAndView mv = new ModelAndView();
    	PageData pd = new PageData();
		pd.put("USERNAME", getUser().getUSERNAME());
		int count = 0;
		try {
			count = commonService.checkLeader(pd);
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		mv.addObject("count", count);
    	mv.setViewName("app/temp/appTempWorkIssued");
    	return mv;
    }
    /**
     * 进入临时工作审核页面
     * @return
     */
    @RequestMapping(value="goTempCheck")
    public ModelAndView goTempCheck(){
    	ModelAndView mv = new ModelAndView();
    	mv.setViewName("app/temp/appTempWorkCheck");
    	return mv;
    }
    /**
     * 加载数据列表
     * @param request
     * @param page
     */
    @ResponseBody
    @RequestMapping(value="loadData")
    public void loadData(HttpServletResponse response, Page page){
    	logBefore(logger, "手机端临时任务下达");
    	PageData pd = this.getPageData();
    	List<PageData> taskList = new ArrayList<>();
    	Subject currentUser = SecurityUtils.getSubject();
		Session session = currentUser.getSession();
		try {
			pd.put("createUser", getUser().getUSERNAME());
			String KEYW = pd.getString("keyword");
			if(null != KEYW && !"".equals("KEYW")){
				KEYW = KEYW.trim();
				pd.put("KEYW", KEYW);
			}
			if ("all".equals(pd.get("status"))) {
				pd.remove("status");
			}
			pd.put("USERNAME", session.getAttribute(Const.SESSION_USERNAME));
			int count = commonService.checkLeader(pd);
			page.setPd(pd);
			taskList = workOrderService.list(page);// 获取临时任务列表
			
			for (int i = 0; i < taskList.size(); i++) {
				taskList.get(i).put("COUNT", count);
				taskList.get(i).put("START_TIME", taskList.get(i).get("START_TIME").toString().substring(0, 19));
				taskList.get(i).put("END_TIME", taskList.get(i).get("END_TIME").toString().substring(0, 19));
			}
			Map<String, Object> map = new HashMap<String, Object>();
			map.put("page", page);
			map.put("taskList", taskList);
			writeJson(map, response);
		} catch (Exception e) {
			logger.error(e.toString(), e);
			e.printStackTrace();
		}
    }
    /**
     * 加载数据列表
     * @param request
     * @param page
     */
    @ResponseBody
    @RequestMapping(value="loadCheckData")
    public void loadCheckData(HttpServletResponse response, Page page){
    	logBefore(logger, "手机端临时任务审核");
    	PageData pd = this.getPageData();
    	List<PageData> taskList = new ArrayList<>();
    	Subject currentUser = SecurityUtils.getSubject();
		Session session = currentUser.getSession();
		try {
			pd.put("createUser", getUser().getUSERNAME());
			String KEYW = pd.getString("keyword");
			if(null != KEYW && !"".equals("KEYW")){
				KEYW = KEYW.trim();
				pd.put("KEYW", KEYW);
			}
			if ("all".equals(pd.get("status"))) {
				pd.remove("status");
			}
			pd.put("USERNAME", session.getAttribute(Const.SESSION_USERNAME));
			int count = commonService.checkLeader(pd);
			page.setPd(pd);
			taskList = workOrderService.checkList(page);// 获取临时任务列表
			
			for (int i = 0; i < taskList.size(); i++) {
				taskList.get(i).put("COUNT", count);
				taskList.get(i).put("START_TIME", taskList.get(i).get("START_TIME").toString().substring(0, 19));
				taskList.get(i).put("END_TIME", taskList.get(i).get("END_TIME").toString().substring(0, 19));
			}
			for (int i = 0; i < taskList.size(); i++) {
				pd.put("UserId", taskList.get(i).get("CREATE_USER"));
				PageData sysname = workOrderService.findSysName(pd);
				taskList.get(i).put("CREATE_NAME", sysname.getString("NAME"));
			}
			Map<String, Object> map = new HashMap<String, Object>();
			map.put("page", page);
			map.put("taskList", taskList);
			writeJson(map, response);
		} catch (Exception e) {
			logger.error(e.toString(), e);
			e.printStackTrace();
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
	 * 跳转编辑页面
	 * @param page
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/goEdit")
	public ModelAndView goEdit(Page page) throws Exception {
		ModelAndView mv = this.getModelAndView();
		PageData pd = getPageData();
		User user = getUser();
		Integer deptID = user.getDeptId();
		try {
			pd = workOrderService.findById(pd);
			List<PageData> empList = this.workOrderService.findEmpByDept(pd);
			mv.addObject("empList",empList);
			PageData obj = new PageData();
			List<PageData> allEmpList = this.workOrderService.findEmpByDept(obj);
			mv.addObject("allEmpList",allEmpList);
			pd.put("START_TIME", pd.get("START_TIME").toString().substring(0, 19));
			pd.put("END_TIME", pd.get("END_TIME").toString().substring(0, 19));
			
			page.setPd(pd);

			
			// 查询部门列表
			logBefore(logger, "查询部门列表");
			List<PageData> deptList = deptService.listAll(pd);
			List<PageData> kpiList = workOrderService.listKpi1(pd);

			if (kpiList == null || kpiList.size() == 0) {
				kpiList = workOrderService.listKpi2(pd);
			}

			pd.put("UserId", pd.get("CHECK_PERSON"));
			PageData empname = workOrderService.findDeptByUserId1(pd);

			if (empname != null) {
				pd.put("EMP_NAME", empname.getString("EMP_NAME"));
			} else {
				pd.put("EMP_NAME", "");
			}

			mv.setViewName("app/temp/appTempWorkEdit");
			mv.addObject("kpiList", kpiList);
			mv.addObject("deptList", deptList);
			mv.addObject("msg", "edit");
			mv.addObject("DEPT_ID", deptID);
			mv.addObject("pd", pd);
		} catch (Exception e) {
			logger.error(e.toString(), e);
		}
		return mv;
	}
	/**
	 * 跳转添加页面
	 * @param page
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/goAdd")
	public ModelAndView goAdd(Page page) throws Exception {
		ModelAndView mv = this.getModelAndView();
		PageData pd = getPageData();
		try {
			PageData obj = new PageData();
			List<PageData> allEmpList = this.workOrderService.findEmpByDept(obj);
			mv.addObject("allEmpList",allEmpList);
			// 查询部门列表
			logBefore(logger, "查询部门列表");
			List<PageData> deptList = deptService.listAll(pd);
			mv.setViewName("app/temp/appTempWorkAdd");
			mv.addObject("deptList", deptList);
			mv.addObject("pd", pd);
		} catch (Exception e) {
			logger.error(e.toString(), e);
		}
		return mv;
	}
	/**
	 * 跳转详情页面
	 * @param page
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/goView")
	public ModelAndView goView(Page page) throws Exception {
		ModelAndView mv = this.getModelAndView();
		PageData pd = getPageData();
		User user = getUser();
		Integer deptID = user.getDeptId();
		List<PageData> list = new ArrayList<>();
		try {
			pd = workOrderService.findById(pd);
			if(pd.get("CHECK_PERSON")!=null){
				PageData obj = workOrderService.findNameById(pd);
				pd.put("CHECK_NAME", obj.getString("EMP_NAME"));
			}
			pd.put("id", pd.get("ID").toString());
			list = workOrderService.findAttchmentsByWorkId(pd);
			pd.put("START_TIME", pd.get("START_TIME").toString().substring(0, 19));
			pd.put("END_TIME", pd.get("END_TIME").toString().substring(0, 19));
			page.setPd(pd);

			pd.put("UserId", pd.get("CHECK_PERSON"));
			PageData empname = workOrderService.findDeptByUserId1(pd);

			if (empname != null) {
				pd.put("EMP_NAME", empname.getString("EMP_NAME"));
			} else {
				pd.put("EMP_NAME", "");
			}

			mv.setViewName("app/temp/appTempWorkEdit");
			mv.addObject("msg", "view");
			mv.addObject("DEPT_ID", deptID);
			mv.addObject("fileList",list);
			mv.addObject("pd", pd);
		} catch (Exception e) {
			logger.error(e.toString(), e);
		}
		return mv;
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
	//批量下发临时任务
	@RequestMapping(value = "/batchIssued", produces = "text/plain;charset=UTF-8")
	public void batchIssued(PrintWriter out) throws Exception {
		logBefore(logger, "批量删除目标");
		PageData pd = this.getPageData();
		Object obj = pd.get("taskCodes");
		String taskCodes[] = obj.toString().split(",");

		try {
			
			pd.put("CREATE_USER", getUser().getUSERNAME()); // 创建人
			pd.put("CREATE_TIME", Tools.date2Str(new Date())); // 创建时间
			pd.put("LAST_UPDATE_USER", getUser().getUSERNAME()); // 最后修改人
			pd.put("LAST_UPDATE_TIME", Tools.date2Str(new Date())); // 最后更改时间
			
			//workOrderService.batchupdateStatus(taskCodes);
			// 批量修改任务状态
			workOrderService.batchSaveDetail(pd,getUser().getNAME());

			userLogService.logInfo(new UserLog(getUser().getUSER_ID(), UserLog.LogType.update,
					"临时任务下发", "任务编码是" + taskCodes.toString()));// 操作日志入库

			out.write("success");
			out.close();
		} catch (Exception e) {
			logger.error(e.toString(), e);
			out.write("false");
			out.close();
		}
	}
	
	/**
	 * 根据部门查询人员
	 * @param response
	 * @throws Exception 
	 */
	@RequestMapping(value="queryEmp")
	public void queryEmp(HttpServletResponse response) throws Exception{
		PageData pd = this.getPageData();
		List<PageData> list = this.workOrderService.findEmpByDept(pd);
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("empList", list);
		writeJson(map, response);
	}
	
	/**
	 * 修改
	 */
	@ResponseBody
	@RequestMapping(value = "edit")
	public String edit() throws Exception {
		PageData pd = getPageData();
		pd.put("S161_PATH_ID", 0);
		pd.put("S161_TARGET_ID", 0);
		if ("".equals(pd.get("CHECK_PERSON"))) {
			pd.put("CHECK_PERSON", 0);
		}
		if(!pd.getString("NEED_CHECK").equals("1")){
			pd.put("CHECK_PERSON", null);
		}
		pd.put("KPI_INDEX_ID", 0);
		String targetCode = "";
		Subject currentUser = SecurityUtils.getSubject();
		Session session = currentUser.getSession();
		try {

				String deptId =  pd.getString("DEPT_ID").split("@")[0];
				String deptName =  pd.getString("DEPT_ID").split("@")[1];
				pd.put("DEPT_ID", deptId);
				pd.put("DEPT_NAME", deptName);
				String empId =  pd.getString("MAIN_EMP_ID").split("@")[0];
				String empName =  pd.getString("MAIN_EMP_ID").split("@")[1];
				pd.put("MAIN_EMP_ID", empId);
				pd.put("MAIN_EMP_NAME", empName);
				if (pd.getString("id") == null || "".equals(pd.getString("id"))) {

					String Code = workOrderService.getNewCode(pd);

					SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd");
					String date = df.format(new Date());
					String year = date.substring(0, 4);

					targetCode = year + "0" + Code;

					pd.put("TASK_CODE", targetCode);
					pd.put("CREATE_USER", session.getAttribute(Const.SESSION_USERNAME)); // 创建人
					pd.put("CREATE_TIME", Tools.date2Str(new Date())); // 创建时间
					pd.put("LAST_UPDATE_USER", session.getAttribute(Const.SESSION_USERNAME)); // 最后修改人
					pd.put("LAST_UPDATE_TIME", Tools.date2Str(new Date())); // 最后更改时间
					pd.put("USERNAME", session.getAttribute(Const.SESSION_USERNAME));
						
					pd.put("status", Const.SYS_STATUS_YW_CG);

				
					pd.put("enable", "1");
					workOrderService.save2(pd);
				} else {
					pd.put("LAST_UPDATE_USER", session.getAttribute(Const.SESSION_USERNAME)); // 最后修改人
					pd.put("LAST_UPDATE_TIME", Tools.date2Str(new Date())); // 最后更改时间

					workOrderService.edit2(pd);
				}
				return "success";
		} catch (Exception e) {
			e.printStackTrace();
			throw e;
		}
		
	}
	@RequestMapping(value = "update")
	public void update(PrintWriter out, HttpServletRequest request) {
		logBefore(logger, "编辑临时任务");
		PageData pd = new PageData();

		Subject currentUser = SecurityUtils.getSubject();
		Session session = currentUser.getSession();

		try {
			pd = this.getPageData();

			pd.put("CREATE_USER", session.getAttribute(Const.SESSION_USERNAME)); // 创建人
			pd.put("CREATE_TIME", Tools.date2Str(new Date())); // 创建时间
			pd.put("LAST_UPDATE_USER", session.getAttribute(Const.SESSION_USERNAME)); // 最后修改人
			pd.put("LAST_UPDATE_TIME", Tools.date2Str(new Date())); // 最后更改时间

			workOrderService.update(pd);

			pd.put("UserId", pd.get("MAIN_EMP_ID"));

			PageData empname = workOrderService.findDeptByUserId1(pd);

			pd.put("EMP_NAME", empname.getString("EMP_NAME"));
			
			if(Const.SYS_STATUS_YW_YSX.equals(pd.getString("status"))){
				pd.put("STATUS", pd.get("status"));
				PageData pageData = new PageData();
				pageData.put("ID",pd.get("MAIN_EMP_ID"));
				pageData = employeeService.findById(pageData);
				workOrderService.save3(pd);
				EndPointServer.sendMessage(getUser().getNAME(), pageData.getString("EMP_CODE"), TaskType.empDailyTask);
			}else if(Const.SYS_STATUS_YW_DSX.equals(pd.getString("status"))){
				PageData leader = commonService.findDeptLeader(getUser().getDeptId().toString());
				EndPointServer.sendMessage(getUser().getNAME(), leader.getString("EMP_CODE"), TaskType.empDailyTaskAudit);
			}
			
			out.write("success");
			out.close();
		} catch (Exception e) {
			logger.error(e.toString(), e);
			out.write("false");
			out.close();
		}
	}
	/**
	 * 删除
	 */
	@RequestMapping(value = "/delete")
	public void delete(PrintWriter out) {
		logBefore(logger, "删除任务");
		PageData pd = new PageData();
		try {
			pd = this.getPageData();
			workOrderService.delete(pd);
			out.write("success");
			out.close();
		} catch (Exception e) {
			logger.error(e.toString(), e);
		}
	}
	
	/**
	 * 跳转至附件上传页面
	 * @param id
	 * @return
	 * @throws Exception 
	 */
	@RequestMapping(value="goAttchmentsUpload", method=RequestMethod.GET)
	public ModelAndView goAttchmentsUpload(String id) throws Exception{
		ModelAndView modelAndView = getModelAndView();
		modelAndView.addObject("taskid", id);
		List<PageData> attchments = workOrderService.findAttchmentsByWorkId(id);
		modelAndView.addObject("fileList", attchments);
		modelAndView.setViewName("app/temp/attchments_upload");
		return modelAndView;
	}
	
	/**
	 * 上传文档
	 */		
	@ResponseBody
	@RequestMapping(value = "/Upload")
	public void upload(@RequestParam(value = "id-input-file-1", required = false) MultipartFile[] DOCUMENT,  
			HttpServletResponse response, HttpServletRequest request) throws Exception{
		Map<String, Object> map = new HashMap<String, Object>();
		List<Map<String, Object>> list = new ArrayList<Map<String, Object>>();
		try {
			for(int i=0;i<DOCUMENT.length;i++)
			{
				if (null != DOCUMENT[i] && !DOCUMENT[i].isEmpty()) {
					String filename = DOCUMENT[i].getOriginalFilename();
					String filename_server = FileUpload.uploadFileNew(request, DOCUMENT[i], Const.FILEPATHTASK);
					
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
	 * 保存附件
	 * @return
	 * @throws Exception
	 */
	@ResponseBody
	@RequestMapping(value="saveFile")
	public String saveFile() throws Exception{
		PageData pd = this.getPageData();
		try {
			if(pd.get("DOCUMENT")!=null && !pd.get("DOCUMENT").equals("")){
				String document = (String) pd.get("DOCUMENT");
				JSONArray json = JSONArray.fromObject(document);
				for(int j = 0; j < json.size(); j++){
					JSONObject jo = json.getJSONObject(j);
					pd.put("TASK_ID", pd.get("taskid"));
					pd.put("FILENAME", jo.get("filename"));
					pd.put("SERVER_FILENAME", jo.get("filename_server"));
					workOrderService.saveAttachments(pd);//将文件名称及上传路径存保存
				}
			}
			if(pd.get("ids")!=null && !pd.get("ids").equals("")){
				String ids = pd.getString("ids");
				String[] arr = ids.split(",");
				for (int i = 0; i < arr.length; i++) {
					workOrderService.deleteAttachment(arr);
				}
				
			}
			 return "success";
		} catch (Exception e) {
			e.printStackTrace();
			throw e;
		}
		
	}
	@ResponseBody
	@RequestMapping("checkFile")
	public String checkFile(String fileName, HttpServletRequest request) {
		try {
			// String name = new String(fileName.getBytes("iso8859-1"),
			// "UTF-8");
			String name = fileName;
			String filePath = request.getSession().getServletContext()
					.getRealPath(Const.FILEPATHTASK)
					+ "\\" + name;
			File f = new File(filePath);
			if (!f.exists()) {
				logger.error("附件不存在");
				return "";
			} else {
				return filePath;
			}
		} catch (Exception e) {
			logger.error("获取文件名称出错", e);
			return "";
		}
	}
	
}
