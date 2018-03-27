package com.mfw.controller.workorder;

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

import com.google.gson.Gson;
import com.mfw.controller.base.BaseController;
import com.mfw.entity.GridPage;
import com.mfw.entity.Page;
import com.mfw.entity.system.User;
import com.mfw.entity.system.UserLog;
import com.mfw.service.bdata.CommonService;
import com.mfw.service.bdata.DeptService;
import com.mfw.service.bdata.EmployeeService;
import com.mfw.service.bdata.KpiModelService;
import com.mfw.service.system.UserLogService;
import com.mfw.service.system.dictionaries.DictionariesService;
import com.mfw.service.workorder.workOrderService;
import com.mfw.util.AppUtil;
import com.mfw.util.Const;
import com.mfw.util.EndPointServer;
import com.mfw.util.FileUpload;
import com.mfw.util.PageData;
import com.mfw.util.TaskType;
import com.mfw.util.Tools;
import com.mfw.util.UserUtils;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

/**
 * Controller-临时任务
 * @author 
 *
 */
@Controller
@RequestMapping(value = "/workOrder")
public class workOrderController extends BaseController {

	@Resource(name = "workOrderService")
	private workOrderService workOrderService;
	@Resource(name = "commonService")
	private CommonService commonService;
	@Resource(name = "employeeService")
	private EmployeeService employeeService;
	@Resource(name = "userLogService")
	private UserLogService userLogService;

	/**
	 *
	 */
	@RequestMapping(value = "/findByTargetType", produces = "text/html;charset=UTF-8")
	public void findByTargetType(@RequestParam String TARGET_ID, HttpServletResponse response) throws Exception {
		try {
			Map<String, Object> map = new HashMap<String, Object>();

			PageData pd = new PageData();
			pd = this.getPageData();

			Subject currentUser = SecurityUtils.getSubject();
			Session session = currentUser.getSession();
			String UserId = session.getAttribute(Const.SESSION_USERNAME).toString();

			pd.put("UserId", UserId);
			PageData deptId = workOrderService.findDeptByUserId(pd);

			pd.put("TARGET_DEPT_ID", deptId.get("EMP_DEPARTMENT_ID"));

			pd.put("TARGET_TYPE", pd.getString("TARGET_ID"));

			List<PageData> pathList = workOrderService.findByTargeType(pd);

			map.put("list", pathList);
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
	 * 点击模板列表查询
	 */
	@RequestMapping(value = "/modelDetail", produces = "text/html;charset=UTF-8")
	public void modelDetail(@RequestParam String ID, HttpServletResponse response) throws Exception {
		PageData pd = new PageData();
		Map<String, Object> map = new HashMap<String, Object>();
		try {
			pd = this.getPageData();
			pd.put("ID", ID);
			List<PageData> kpiList = workOrderService.listKpi(pd);
			map.put("list", kpiList);
			map.put("pd", pd);
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
	 * 新增
	 */
	@RequestMapping(value = "/save")
	public ModelAndView save() throws Exception {
		ModelAndView mv = this.getModelAndView();
		PageData pd = new PageData();
		pd = this.getPageData();
		try {
			if (pd.get("empKpiIndexId") != null) {
				pd.put("preparation1", pd.get("empKpiIndexId"));
			}
			String selectGroups = pd.getString("txtGroupsSelect").replace(',', '&');
			Subject currentUser = SecurityUtils.getSubject();
			Session session = currentUser.getSession();
			pd.put("taskToWhoId", selectGroups);
			pd.put("taskInOrderId", pd.getString("taskInOrderId"));
			pd.put("taskInOrderName", pd.getString("taskInOrderName"));
			pd.put("createUser", session.getAttribute(Const.SESSION_USERNAME)); // 创建人
			pd.put("createTime", Tools.date2Str(new Date())); // 创建时间
			pd.put("lastUpdateUser", session.getAttribute(Const.SESSION_USERNAME)); // 最后修改人
			pd.put("lastUpdateTime", Tools.date2Str(new Date())); // 最后更改时间
			pd.put("status", Const.SYS_STATUS_YW_CG);
			pd.put("enable", "1");

			workOrderService.save(pd);
			mv.addObject("msg", "success");
		} catch (Exception e) {
			mv.addObject("msg", "failed");
			e.printStackTrace();
		}
		mv.setViewName("save_result");
		return mv;
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

	@RequestMapping(value = "/update")
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

	@RequestMapping(value = "/updateExam")
	public void updateExam(PrintWriter out) {
		logBefore(logger, "删除任务");
		PageData pd = new PageData();

		Subject currentUser = SecurityUtils.getSubject();
		Session session = currentUser.getSession();
		pd = this.getPageData();

		String strList = pd.getString("list");
		String[] arrList = strList.split(",");
		String[] arrTemp = new String[4];

		try {

			pd.put("last_update_user", session.getAttribute(Const.SESSION_USERNAME)); // 最后修改人
			pd.put("last_update_time", Tools.date2Str(new Date())); // 最后更改时间
			int n = 0;
			for (int m = 0; m < arrList.length; m++) {
				arrTemp[n] = arrList[m];
				n = n + 1;
				if (n == 4) {

					if (arrTemp[0] != null || !"".equals(arrTemp[0])) {
						pd.put("nchk", arrTemp[0]);
					} else {
						pd.put("nchk", null);
					}
					if ("".equals(pd.get("nchk"))) {
						pd.put("nchk", null);
					}

					if (arrTemp[1] != null || !"".equals(arrTemp[1])) {
						pd.put("empid", arrTemp[1]);
					} else {
						pd.put("empid", 0);
					}

					if ("".equals(pd.get("empid"))) {
						pd.put("empid", 0);
					}

					if (arrTemp[2] != null || !"".equals(arrTemp[2])) {
						pd.put("kpiid", arrTemp[2]);
					} else {
						pd.put("kpiid", 0);
					}

					if ("".equals(pd.get("kpiid"))) {
						pd.put("kpiid", 0);
					}

					pd.put("id", arrTemp[3]);

					workOrderService.updateExamDailSave(pd);

					n = 0;
				}
			}

			out.write("success");
			out.close();
		} catch (Exception e) {
			logger.error(e.toString(), e);
		}
	}

	@RequestMapping(value = "/updateExamOne")
	public void updateExamOne(PrintWriter out) {
		PageData pd = new PageData();

		PageData pdg = new PageData();

		Subject currentUser = SecurityUtils.getSubject();
		Session session = currentUser.getSession();
		try {
			pd = this.getPageData();
			pd.put("last_update_user", session.getAttribute(Const.SESSION_USERNAME));
			pd.put("last_update_time", Tools.date2Str(new Date()));
			workOrderService.updateExam(pd);

			pdg.put("WORKLIST_ID", pd.get("id"));

			List<PageData> dailInfoList = workOrderService.FindDailyIdOne(pdg);
			for (int i = 0; i < dailInfoList.size(); i++) {
				pdg.put("id", dailInfoList.get(i).get("ID"));
				workOrderService.updateExamDail(pdg);
			}

			List<PageData> WORKLIST_List = workOrderService.dailytaskinformationList(pd);
			for (int i = 0; i < WORKLIST_List.size(); i++) {
				pd.put("DAILY_TASK_ID", WORKLIST_List.get(i).get("ID"));
				workOrderService.updateExamDetail(pd);
			}

			out.write("success");
			out.close();
		} catch (Exception e) {
			logger.error(e.toString(), e);
		}
	}

	@RequestMapping(value = "/updateExamAll")
	@ResponseBody
	public Object updateExamAll() {
		PageData pd = new PageData();

		PageData pdg = new PageData();

		Map<String, Object> map = new HashMap<String, Object>();
		List<PageData> pdList = new ArrayList<PageData>();

		Subject currentUser = SecurityUtils.getSubject();
		Session session = currentUser.getSession();
		try {
			pd = this.getPageData();
			pd.put("last_update_user", session.getAttribute(Const.SESSION_USERNAME));
			pd.put("last_update_time", Tools.date2Str(new Date()));

			pdg.put("last_update_user", session.getAttribute(Const.SESSION_USERNAME));
			pdg.put("last_update_time", Tools.date2Str(new Date()));

			String DATA_IDS = pd.getString("DATA_IDS");
			if (null != DATA_IDS && !"".equals(DATA_IDS)) {

				String ArrayDATA_IDS[] = DATA_IDS.split(",");

				workOrderService.updateExamAll(ArrayDATA_IDS);

				for (int j = 0; j < ArrayDATA_IDS.length; j++) {

					pdg.put("WORKLIST_ID", ArrayDATA_IDS[j]);

					List<PageData> dailInfoList = workOrderService.FindDailyIdOne(pdg);
					for (int i = 0; i < dailInfoList.size(); i++) {
						pdg.put("id", dailInfoList.get(i).get("ID"));
						workOrderService.updateExamDail(pdg);

						pd.put("DAILY_TASK_ID", pdg.get("id"));
						workOrderService.updateExamDetail(pd);
					}
				}
			}

			pd.put("msg", "ok");
			pdList.add(pd);
			map.put("list", pdList);
		} catch (Exception e) {
			logger.error(e.toString(), e);
		}
		return AppUtil.returnObject(pd, map);
	}

	@RequestMapping(value = "/updateExamkpi")
	public void updateExamkpi(PrintWriter out) {
		logBefore(logger, "删除任务");
		PageData pd = new PageData();

		Subject currentUser = SecurityUtils.getSubject();
		Session session = currentUser.getSession();
		pd = this.getPageData();

		try {

			pd.put("last_update_user", session.getAttribute(Const.SESSION_USERNAME)); // 最后修改人
			pd.put("last_update_time", Tools.date2Str(new Date())); // 最后更改时间

			workOrderService.updateExamDailKpi(pd);

			out.write("success");
			out.close();
		} catch (Exception e) {
			logger.error(e.toString(), e);
		}
	}

	/**
	 * 修改
	 */
	@RequestMapping(value = "/edit")
	public ModelAndView edit() throws Exception {
		ModelAndView mv = this.getModelAndView();
		PageData pd = getPageData();
		pd.put("S161_PATH_ID", 0);
		pd.put("S161_TARGET_ID", 0);
		if ("".equals(pd.get("CHECK_PERSON"))) {
			pd.put("CHECK_PERSON", 0);
		}
		pd.put("KPI_INDEX_ID", 0);
		String targetCode = "";
		Subject currentUser = SecurityUtils.getSubject();
		Session session = currentUser.getSession();
		try {

			String strMainUserName = pd.getString("MAIN_EMP_NAME");
			String[] arrMainUserName = strMainUserName.split(",");

			String strMainUserId = pd.getString("MAIN_EMP_ID");
			String[] arrMainUserId = strMainUserId.split(",");

			for (int i = 0; i < arrMainUserId.length; i++) {

				pd.put("MAIN_EMP_ID", arrMainUserId[i]);
				pd.put("MAIN_EMP_NAME", arrMainUserName[i]);

				if (pd.getString("id") == null || "".equals(pd.getString("id"))) {

					String Code = workOrderService.getNewCode(pd);

					SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd");
					String date = df.format(new Date());
					String year = date.substring(0, 4);

					targetCode = year + "0" + Code;

					pd.put("TASK_CODE", targetCode);

					PageData empid = workOrderService.findDeptByEmpName(pd);

					if (empid != null) {
						pd.put("CHECK_PERSON", empid.get("ID"));
					} else {
						if ("admin".equals(pd.get("CHECK_PERSON"))) {
							pd.put("UserId", pd.get("CHECK_PERSON"));
							PageData empcode = workOrderService.findDeptByUserId(pd);
							if (empcode != null) {
								pd.put("CHECK_PERSON", empcode.get("ID"));
							}
						} else {
							pd.put("CHECK_PERSON", null);
						}
					}

					pd.put("CREATE_USER", session.getAttribute(Const.SESSION_USERNAME)); // 创建人
					pd.put("CREATE_TIME", Tools.date2Str(new Date())); // 创建时间
					pd.put("LAST_UPDATE_USER", session.getAttribute(Const.SESSION_USERNAME)); // 最后修改人
					pd.put("LAST_UPDATE_TIME", Tools.date2Str(new Date())); // 最后更改时间
					pd.put("USERNAME", session.getAttribute(Const.SESSION_USERNAME));
					int count = commonService.checkLeader(pd);
						
					pd.put("status", Const.SYS_STATUS_YW_CG);

				
					pd.put("enable", "1");
					workOrderService.save2(pd);
					mv.addObject("count", count);
				} else {
					pd.put("LAST_UPDATE_USER", session.getAttribute(Const.SESSION_USERNAME)); // 最后修改人
					pd.put("LAST_UPDATE_TIME", Tools.date2Str(new Date())); // 最后更改时间

					workOrderService.edit2(pd);
				}
			}			
			mv.addObject("msg", "success");
		} catch (Exception e) {
			mv.addObject("msg", "failed");
			e.printStackTrace();
		}
		mv.setViewName("save_result");
		return mv;
	}
	/**
	 * 保存附件
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="saveFile")
	public ModelAndView saveFile() throws Exception{
		ModelAndView mv = new ModelAndView();
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
			 mv.addObject("msg", "saveSuccess");
		} catch (Exception e) {
			mv.addObject("msg", "failed");
			e.printStackTrace();
		}
		mv.setViewName("save_result");
		return mv;
		
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
	 * 列表
	 */
	@RequestMapping(value = "/list")
	public ModelAndView list(Page page) {
		ModelAndView mv = this.getModelAndView();
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
		mv.setViewName("workorder/list");
		mv.addObject("msg", "edit");
		return mv;
	}
	
	/**
	 * 列表
	 */
	@RequestMapping(value = "/listCheck")
	public ModelAndView listCheck(Page page) {
		ModelAndView mv = this.getModelAndView();
			mv.setViewName("workorder/check");
			mv.addObject("msg", "edit");
			return mv;

	}
	
	

	/**
	 * 获取表格数据
	 * 
	 * @param page
	 * @param request
	 * @return
	 */
	@ResponseBody
	@RequestMapping(value = "/taskList")
	public GridPage taskList(Page page, HttpServletRequest request) {
		logBefore(logger, "工作下达");
		List<PageData> taskList = new ArrayList<>();
		PageData pd = new PageData();
		pd = this.getPageData();
		Subject currentUser = SecurityUtils.getSubject();
		Session session = currentUser.getSession();
		try {
			convertPage(page, request);
			PageData pageData = page.getPd();
			pageData.put("createUser", getUser().getUSERNAME()); // 创建人
			String KEYW = pageData.getString("keyword");
			if (null != KEYW && !"".equals(KEYW)) {
				KEYW = KEYW.trim();
				pageData.put("KEYW", KEYW);
			}
			if ("all".equals(pageData.get("status"))) {
				pageData.remove("status");
			}
			

			pd.put("USERNAME", session.getAttribute(Const.SESSION_USERNAME));
			int count = commonService.checkLeader(pd);

			
			page.setPd(pageData);
			taskList = workOrderService.list(page);// 获取临时任务列表
			
			for (int i = 0; i < taskList.size(); i++) {
				taskList.get(i).put("COUNT", count);
				taskList.get(i).put("START_TIME", taskList.get(i).get("START_TIME").toString().substring(0, 19));
				taskList.get(i).put("END_TIME", taskList.get(i).get("END_TIME").toString().substring(0, 19));
			}
//			for (int i = 0; i < taskList.size(); i++) {
//				PageData kpiListPd = new PageData();
//				kpiListPd.put("ID", taskList.get(i).get("MAIN_EMP_ID"));
//				List<PageData> kpiList = workOrderService.listKpi(kpiListPd);

//				pageData.put("UserId", taskList.get(i).get("CREATE_USER"));
//				PageData sysname = workOrderService.findSysName(pageData);
//				taskList.get(i).put("CREATE_NAME", sysname.getString("NAME"));

//				if (kpiList == null || kpiList.size() == 0) {
//					kpiList = workOrderService.listKpi2(kpiListPd);
//				}
//
//				taskList.get(i).put("kpiList", kpiList);
//			}
		} catch (Exception e) {
			logger.error(e.toString(), e);
			e.printStackTrace();
		}
		return new GridPage(taskList, page);
	}
	
	/**
	 * 获取表格数据
	 * 
	 * @param page
	 * @param request
	 * @return
	 */
	@ResponseBody
	@RequestMapping(value = "/checkList")
	public GridPage checkList(Page page, HttpServletRequest request) {
		logBefore(logger, "工作下达");
		List<PageData> taskList = new ArrayList<>();
		PageData pd = new PageData();
		pd = this.getPageData();
		Subject currentUser = SecurityUtils.getSubject();
		Session session = currentUser.getSession();
		try {
			convertPage(page, request);
			PageData pageData = page.getPd();
			pageData.put("createUser", getUser().getUSERNAME()); // 创建人
			String KEYW = pageData.getString("keyword");
			if (null != KEYW && !"".equals(KEYW)) {
				KEYW = KEYW.trim();
				pageData.put("KEYW", KEYW);
			}
			if ("all".equals(pageData.get("status"))) {
				pageData.remove("status");
			}
			

			pd.put("USERNAME", session.getAttribute(Const.SESSION_USERNAME));
			int count = commonService.checkLeader(pd);

			
			page.setPd(pageData);
			taskList = workOrderService.checkList(page);// 获取审核列表
			
			for (int i = 0; i < taskList.size(); i++) {
				taskList.get(i).put("COUNT", count);
				taskList.get(i).put("START_TIME", taskList.get(i).get("START_TIME").toString().substring(0, 19));
				taskList.get(i).put("END_TIME", taskList.get(i).get("END_TIME").toString().substring(0, 19));
			}
			for (int i = 0; i < taskList.size(); i++) {
//				PageData kpiListPd = new PageData();
//				kpiListPd.put("ID", taskList.get(i).get("MAIN_EMP_ID"));
//				List<PageData> kpiList = workOrderService.listKpi(kpiListPd);

				pageData.put("UserId", taskList.get(i).get("CREATE_USER"));
				PageData sysname = workOrderService.findSysName(pageData);
				taskList.get(i).put("CREATE_NAME", sysname.getString("NAME"));
//
//				if (kpiList == null || kpiList.size() == 0) {
//					kpiList = workOrderService.listKpi2(kpiListPd);
//				}
//
//				taskList.get(i).put("kpiList", kpiList);
			}
		} catch (Exception e) {
			logger.error(e.toString(), e);
			e.printStackTrace();
		}
		return new GridPage(taskList, page);
	}
	/**
	 * 列表
	 */
	@RequestMapping(value = "/examlist")
	public ModelAndView examlist(Page page, HttpServletRequest request) {
		logBefore(logger, "列表dailytask");
		ModelAndView mv = this.getModelAndView();
		PageData pd = new PageData();
		pd = this.getPageData();

		User user = UserUtils.getUser(request);

		Integer deptID = user.getDeptId();

		try {

			Subject currentUser = SecurityUtils.getSubject();
			Session session = currentUser.getSession();
			pd.put("createUser", session.getAttribute(Const.SESSION_USERNAME)); // 创建人

			pd.put("USERNAME", session.getAttribute(Const.SESSION_USERNAME)); // 创建人

			String KEYW = pd.getString("keyword");

			if (null != KEYW && !"".equals(KEYW)) {
				KEYW = KEYW.trim();
				pd.put("KEYW", KEYW);
			}

			if (pd.get("STATUS") == null || "".equals(pd.get("STATUS"))) {
				pd.put("STATUS", "YW_DSX");
			}

			if ("0".equals(pd.get("STATUS"))) {
				pd.remove("STATUS");
			}

			pd.put("DEPT_ID", deptID);
			page.setPd(pd);
			List<PageData> varList = workOrderService.examlist(page); // 列出dailytask列表

			for (int i = 0; i < varList.size(); i++) {
				pd.put("UserId", varList.get(i).get("CREATE_USER"));
				PageData sysname = workOrderService.findSysName(pd);
				varList.get(i).put("CREATE_NAME", sysname.getString("NAME"));
			}

			mv.setViewName("workexam/list");
			mv.addObject("varList", varList);

			mv.addObject("msg", "edit");
			mv.addObject("pd", pd);
		} catch (Exception e) {
			logger.error(e.toString(), e);
		}
		return mv;
	}

	/**
	 * 去新增页面
	 */
	@RequestMapping(value = "/goAdd")
	public ModelAndView goAdd(Page page, HttpServletRequest request) throws Exception {
		ModelAndView mv = this.getModelAndView();
		PageData pd = new PageData();
		pd = this.getPageData();

		Subject currentUser = SecurityUtils.getSubject();
		Session session = currentUser.getSession();

		User user = UserUtils.getUser(request);

		String User = user.getNUMBER();
		pd.put("User", User);
		String deptID = commonService.findDeptByUser(pd);

		try {
			page.setPd(pd);
			List<PageData> kpiList = new ArrayList<PageData>();
			kpiList = workOrderService.listKpi1(pd);

			if (kpiList == null || kpiList.size() == 0) {
				kpiList = workOrderService.listKpi2(pd);
			}

			mv.setViewName("workorder/add");
			mv.addObject("kpiList", kpiList);

			pd.put("UserId", session.getAttribute(Const.SESSION_USERNAME));
			pd.put("CHECK_PERSON", session.getAttribute(Const.SESSION_USERNAME));

			PageData sysname = workOrderService.findSysName(pd);
			pd.put("EMP_NAME", sysname.getString("NAME")); // 最后修改人

			//pd.put("DEPT_ID", deptID);
			mv.addObject("msg", "edit");
			mv.addObject("pd", pd);
		} catch (Exception e) {
			logger.error(e.toString(), e);
		}
		return mv;
	}

	@Resource(name = "deptService")
	private DeptService deptService;
	@Resource(name = "dictionariesService")
	private DictionariesService dictionariesService;
	@Resource(name = "kpiModelService")
	private KpiModelService kpiModelService;

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

			mv.setViewName("workorder/edit");
			mv.addObject("kpiList", kpiList);
			mv.addObject("improveList", deptList);
			mv.addObject("msg", "edit");
			mv.addObject("DEPT_ID", deptID);
			mv.addObject("pd", pd);
		} catch (Exception e) {
			logger.error(e.toString(), e);
		}
		return mv;
	}

	@RequestMapping(value = "/goBack")
	public ModelAndView goBack(Page page) throws Exception {
		ModelAndView mv = this.getModelAndView();
		PageData pd = new PageData();
		pd = this.getPageData();
		try {

			mv.setViewName("workexam/edit");
			mv.addObject("msg", "edit");
			mv.addObject("pd", pd);
		} catch (Exception e) {
			logger.error(e.toString(), e);
		}
		return mv;
	}

	@RequestMapping(value = "/back")
	public ModelAndView back() throws Exception {
		ModelAndView mv = this.getModelAndView();
		PageData pd = new PageData();
		pd = this.getPageData();

		Subject currentUser = SecurityUtils.getSubject();
		Session session = currentUser.getSession();
		try {

			pd.put("LAST_UPDATE_USER", session.getAttribute(Const.SESSION_USERNAME)); // 最后修改人
			pd.put("LAST_UPDATE_TIME", Tools.date2Str(new Date())); // 最后更改时间

			workOrderService.back(pd);

			mv.addObject("msg", "success");
		} catch (Exception e) {
			mv.addObject("msg", "failed");
			e.printStackTrace();
		}
		mv.setViewName("save_result");
		return mv;
	}

	/**
	 * 去修改页面
	 */
	@RequestMapping(value = "/goView")
	public ModelAndView goView(Page page) throws Exception {
		ModelAndView mv = this.getModelAndView();
		PageData pd = new PageData();
		pd = this.getPageData();

		PageData ChkPd = new PageData();
		ChkPd = this.getPageData();
		List<PageData> list = new ArrayList<>();
		try {

			pd = workOrderService.findById(pd);
			pd.put("START_TIME", pd.get("START_TIME").toString().substring(0, 19));
			pd.put("END_TIME", pd.get("END_TIME").toString().substring(0, 19));
			pd.put("id", pd.get("ID").toString());
			list = workOrderService.findAttchmentsByWorkId(pd);
			
			List<PageData> modellist = commonService.typeListByBm("RQRW");

			pd.put("taskTypeId", pd.get("task_type_id"));

			pd.put("UserId", pd.get("CHECK_PERSON"));

			ChkPd = workOrderService.findDeptByUserId1(pd);

			if (ChkPd != null) {
				pd.put("CHECK_PERSON", ChkPd.getString("EMP_NAME"));
			} else {
				pd.put("CHECK_PERSON", "");
			}

			mv.setViewName("workorder/view");
			mv.addObject("modellist", modellist);
			mv.addObject("fileList",list);
			mv.addObject("msg", "edit");
			mv.addObject("pd", pd);
		} catch (Exception e) {
			logger.error(e.toString(), e);
		}
		return mv;
	}

	@RequestMapping(value = "/goViewExam")
	public ModelAndView goViewExam(Page page) throws Exception {
		ModelAndView mv = this.getModelAndView();
		PageData pd = new PageData();
		PageData pd1 = new PageData();

		try {
			pd = this.getPageData();
			Subject currentUser = SecurityUtils.getSubject();
			Session session = currentUser.getSession();
			pd.put("createUser", session.getAttribute(Const.SESSION_USERNAME)); // 创建人

			if ("all".equals(pd.get("status"))) {
				pd.remove("status");
			}

			page.setPd(pd);
			List<PageData> varList = workOrderService.viewlist(page); // 列出dailytask列表
			for (int i = 0; i < varList.size(); i++) {
				PageData kpiPd = new PageData();
				PageData userPd = new PageData();
				PageData kpiListPd = new PageData();

				kpiListPd.put("ID", varList.get(i).get("MAIN_EMP_ID"));
				List<PageData> kpiList = workOrderService.listKpi(kpiListPd);

				if (kpiList == null || kpiList.size() == 0) {
					kpiList = workOrderService.listKpi2(kpiListPd);
				}

				varList.get(i).put("kpiList", kpiList);

				List<PageData> empList = employeeService.listAll(pd1);

				// 放入员工列表
				varList.get(i).put("empList", empList);

				kpiPd.put("KPIID", varList.get(i).get("KPI_INDEX_ID"));
				kpiPd = workOrderService.KpiName(kpiPd);

				pd.put("UserId", varList.get(i).get("MAIN_EMP_ID"));
				userPd = workOrderService.findDeptByUserId1(pd);

				if (userPd != null) {
					varList.get(i).put("MAIN_EMP_NAME", userPd.get("EMP_NAME"));
				} else {
					varList.get(i).put("MAIN_EMP_NAME", "");
				}

			}

			mv.setViewName("workexam/view");
			mv.addObject("varList", varList);

			mv.addObject("msg", "edit");
			mv.addObject("pd", pd);
		} catch (Exception e) {
			logger.error(e.toString(), e);
		}
		return mv;
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
		modelAndView.setViewName("workorder/attchments_upload");
		return modelAndView;
	}
	
	//批量下发临时任务
	@RequestMapping(value = "/batchIssued", produces = "text/plain;charset=UTF-8")
	public void batchIssued(PrintWriter out) throws Exception {
		logBefore(logger, "批量删除目标");
		PageData pd = this.getPageData();
		Object obj = pd.get("taskCodes[]");
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

}