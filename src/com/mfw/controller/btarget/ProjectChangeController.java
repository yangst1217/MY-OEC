package com.mfw.controller.btarget;

import java.io.PrintWriter;
import java.net.URLDecoder;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;

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

import com.mfw.controller.base.BaseController;
import com.mfw.entity.GridPage;
import com.mfw.entity.Page;
import com.mfw.entity.system.User;
import com.mfw.service.bdata.EmployeeService;
import com.mfw.service.btarget.ProjectChangeService;
import com.mfw.service.project.CProjectService;
import com.mfw.util.Const;
import com.mfw.util.FileUpload;
import com.mfw.util.PageData;
import com.mfw.util.PathUtil;
import com.mfw.util.Tools;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

/**
 * Controller-项目变更 创建人：bhw 创建时间：2016-05-15
 */
@Controller
@RequestMapping(value = "/projectChange")
public class ProjectChangeController extends BaseController {

	@Resource(name = "projectChangeService")
	private ProjectChangeService ProjectChangeService;
	@Resource(name="cprojectService")
	private CProjectService projectService;
	@Resource(name = "employeeService")
	private EmployeeService employeeService;

	/**
	 * 列表
	 */
	@RequestMapping(value = "/list")
	public ModelAndView list(Page page) {
		ModelAndView mv = this.getModelAndView();
		mv.setViewName("btarget/projectChange/list");
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
		logBefore(logger, "年度经营任务（部门）列表");
		List<PageData> taskList = new ArrayList<>();
		try {
			convertPage(page, request);
			PageData pageData = page.getPd();
			Subject currentUser = SecurityUtils.getSubject();
			Session session = currentUser.getSession();
			pageData.put("USER", session.getAttribute(Const.SESSION_USERNAME)); // 登录人
			pageData.put("USERNUMBER", getUser().getNUMBER());
			page.setPd(pageData);
			if(pageData.getString("state").equals("0"))
			taskList = ProjectChangeService.findChange(page);
			else
				taskList = ProjectChangeService.findCheckChange(page);
			
		} catch (Exception e) {
			logger.error(e.toString(), e);
			e.printStackTrace();
		}
		return new GridPage(taskList, page);
	}

	/**
	 * 新增页面
	 */
	@RequestMapping(value = "/goAdd")
	public ModelAndView goAdd(Page page) {
		ModelAndView mv = this.getModelAndView();
		PageData pd = new PageData();
		try {
			pd = this.getPageData();
			Subject currentUser = SecurityUtils.getSubject();
			Session session = currentUser.getSession();
			pd.put("USER", session.getAttribute(Const.SESSION_USERNAME)); // 登录人
			List<PageData> projectList = ProjectChangeService.findProject(pd); // 查看我的项目列表
			mv.setViewName("btarget/projectChange/add");
			mv.addObject("pd", pd);
			mv.addObject("msg", "save");
			mv.addObject("projectList", projectList);
		} catch (Exception e) {
			logger.error(e.toString(), e);
		}
		return mv;
	}

	/**
	 * 保存变更单
	 */
	@RequestMapping(value = "/save", method = RequestMethod.POST)
	public ModelAndView save() throws Exception {
		ModelAndView mv = this.getModelAndView();
		PageData pd = new PageData();
		try {
			pd = this.getPageData();

			Subject currentUser = SecurityUtils.getSubject();
			Session session = currentUser.getSession();
			UUID uuid = UUID.randomUUID();
			String str = uuid.toString();

			pd.put("CREATE_USER", session.getAttribute(Const.SESSION_USERNAME)); // 创建人
			pd.put("CREATE_TIME", Tools.date2Str(new Date())); // 创建时间
			pd.put("UPDATE_USER", session.getAttribute(Const.SESSION_USERNAME)); // 最后修改人
			pd.put("UPDATE_TIME", Tools.date2Str(new Date())); // 最后更改时间
			pd.put("DOCUMENT_ID", str);

			String document = (String) pd.get("DOCUMENT");
			JSONArray json = JSONArray.fromObject(document);
			for (int i = 0; i < json.size(); i++) {
				JSONObject jo = json.getJSONObject(i);
				pd.put("DOCUMENT", jo.get("filename"));
				pd.put("PATH", jo.get("filePath"));
				ProjectChangeService.saveDocument(pd);// 将文件名称及上传路径存保存
			}
			ProjectChangeService.save(pd);
			if(pd.get("dids")!=null && !"".equals(pd.getString("dids"))){
				PageData List = ProjectChangeService.findChangeByDocID(pd); // 跟据DOCUMENT_ID找到刚才存储的变更单
	
				String delids = pd.getString("delIds");// 删除的信息ID
				if (!"".equals(delids)) {
					String ArrayDATA_IDS[] = delids.split(",");
					ProjectChangeService.batchDeleteDetail(ArrayDATA_IDS);
				}
	
				String[] dids = pd.getString("dids").split(",");
				String[] CHANGE_TYPE = pd.getString("CHANGE_TYPE").split(",", -1);
				String[] CHANGE_OBJ_ID = pd.getString("CHANGE").split(",", -1);
				String[] BEFORE_START_DATE = pd.getString("BEFORE_START_DATE")
						.split(",", -1);
				String[] AFTER_START_DATE = pd.getString("AFTER_START_DATE").split(
						",", -1);
				String[] BEFORE_END_DATE = pd.getString("BEFORE_END_DATE").split(
						",", -1);
				String[] AFTER_END_DATE = pd.getString("AFTER_END_DATE").split(",",
						-1);
				String[] BEFORE_WEIGHT = pd.getString("BEFORE_WEIGHT").split(",",-1);
				String[] AFTER_WEIGHT = pd.getString("AFTER_WEIGHT").split(",",-1);
	
				List<PageData> addList = new ArrayList<PageData>();
				List<PageData> upList = new ArrayList<PageData>();
	
				for (int i = 0; i < CHANGE_TYPE.length; i++) {
					PageData pdd = new PageData();
	
					pdd.put("UPDATE_USER",
							session.getAttribute(Const.SESSION_USERNAME)); // 最后修改人
					pdd.put("UPDATE_TIME", Tools.date2Str(new Date())); // 最后更改时间
					if (dids[i].equals("0")) {
						pdd.put("C_PROJECT_CHANGE_ID", List.get("ID"));
						pdd.put("CREATE_USER",
								session.getAttribute(Const.SESSION_USERNAME)); // 创建人
						pdd.put("CREATE_TIME", Tools.date2Str(new Date())); // 创建时间
						pdd.put("CHANGE_TYPE", CHANGE_TYPE[i]);
						pdd.put("CHANGE_OBJ_ID", Integer.valueOf(CHANGE_OBJ_ID[i]));
						if (BEFORE_START_DATE[i] != null
								&& !BEFORE_START_DATE[i].equals("")) {
							pdd.put("BEFORE_START_DATE", BEFORE_START_DATE[i]);
						} else {
							pdd.put("BEFORE_START_DATE", "2000-01-01");
						}
						if (AFTER_START_DATE[i] != null
								&& !AFTER_START_DATE[i].equals("")) {
							pdd.put("AFTER_START_DATE", AFTER_START_DATE[i]);
						} else {
							pdd.put("AFTER_START_DATE", "2000-01-01");
						}
						if (BEFORE_END_DATE[i] != null
								&& !BEFORE_END_DATE[i].equals("")) {
							pdd.put("BEFORE_END_DATE", BEFORE_END_DATE[i]);
						} else {
							pdd.put("BEFORE_END_DATE", "2000-01-01");
						}
						if (AFTER_END_DATE[i] != null
								&& !AFTER_END_DATE[i].equals("")) {
							pdd.put("AFTER_END_DATE", AFTER_END_DATE[i]);
						} else {
							pdd.put("AFTER_END_DATE", "2000-01-01");
						}
						if (AFTER_WEIGHT[i] != null
								&& !AFTER_WEIGHT[i].equals("")) {
							pdd.put("AFTER_WEIGHT", AFTER_WEIGHT[i]);
						} else if(BEFORE_WEIGHT[i] != null
								&& !BEFORE_WEIGHT[i].equals("")
								&&(AFTER_WEIGHT[i] == null||AFTER_WEIGHT[i].equals(""))){
							pdd.put("AFTER_WEIGHT", BEFORE_WEIGHT[i]);
						}else{
							pdd.put("AFTER_WEIGHT", null);
						}
						if(BEFORE_WEIGHT[i] != null
								&& !BEFORE_WEIGHT[i].equals("")){
							pdd.put("BEFORE_WEIGHT", BEFORE_WEIGHT[i]);
						}else
							pdd.put("BEFORE_WEIGHT", null);
						addList.add(pdd);
					} else {
						pdd.put("id", dids[i]);
						if (AFTER_START_DATE[i] != null
								&& !AFTER_START_DATE[i].equals("")) {
							pdd.put("AFTER_START_DATE", AFTER_START_DATE[i]);
						} else {
							pdd.put("AFTER_START_DATE", "2000-01-01");
						}
						if (AFTER_END_DATE[i] != null
								&& !AFTER_END_DATE[i].equals("")) {
							pdd.put("AFTER_END_DATE", AFTER_END_DATE[i]);
						} else {
							pdd.put("AFTER_END_DATE", "2000-01-01");
						}
						if (AFTER_WEIGHT[i] != null
								&& !AFTER_WEIGHT[i].equals("")) {
							pdd.put("AFTER_WEIGHT", AFTER_WEIGHT[i]);
						}else if(BEFORE_WEIGHT[i] != null
								&& !BEFORE_WEIGHT[i].equals("")
								&&(AFTER_WEIGHT[i] == null||AFTER_WEIGHT[i].equals(""))){
							pdd.put("AFTER_WEIGHT", BEFORE_WEIGHT[i]);
						}else{
							pdd.put("AFTER_WEIGHT", null);
						}
						upList.add(pdd);
					}
	
				}
				if (addList.size() > 0) {
					ProjectChangeService.addDetail(addList);
				}
				if (upList.size() > 0) {
					ProjectChangeService.batchUpdateDetail(upList);
				}// pd.put("id", UuidUtil.get32UUID()); //ID
			}
			//批量增加审核人信息
			this.saveChangeAuditor(pd);
			mv.addObject("msg", "操作成功");

		} catch (Exception e) {
			logger.error(e.toString(), e);
			mv.addObject("msg", "操作失败");
		}
		mv.setViewName("save_result");
		return mv;
	}
	
	private void saveChangeAuditor(PageData pd)throws Exception{
		String[] auditors = pd.getString("auditor").split(",");
		List<PageData> auditLists = new ArrayList<PageData>();
		for(int i = 0; i < auditors.length; i++){
			PageData changeAudit = new PageData();
			changeAudit.put("PROJECT_CHANGE_ID", pd.get("ID"));
			changeAudit.put("AUDITOR",auditors[i]);
			changeAudit.put("STATUS", Const.SYS_STATUS_YW_CG);
			changeAudit.put("CREATE_USER", getUser().getNUMBER());
			changeAudit.put("CREATE_TIME", Tools.date2Str(new Date()));
			auditLists.add(changeAudit);
		}
		
		try {
			ProjectChangeService.batchAddAuditors(auditLists);
		} catch (Exception e) {
			e.printStackTrace();
			throw e;
		}
	}

	/**
	 * 修改变更单
	 */
	@RequestMapping(value = "/edit", method = RequestMethod.POST)
	public ModelAndView edit() throws Exception {
		ModelAndView mv = this.getModelAndView();
		PageData pd = new PageData();
		try {
			pd = this.getPageData();

			Subject currentUser = SecurityUtils.getSubject();
			Session session = currentUser.getSession();

			pd.put("UPDATE_USER", session.getAttribute(Const.SESSION_USERNAME)); // 最后修改人
			pd.put("UPDATE_TIME", Tools.date2Str(new Date())); // 最后更改时间

			PageData Change = ProjectChangeService.findChangeByID(pd);

			pd.put("DOCUMENT_ID", Change.get("DOCUMENT_ID"));

			String document = (String) pd.get("DOCUMENT");
			JSONArray json = JSONArray.fromObject(document);
			for (int i = 0; i < json.size(); i++) {
				JSONObject jo = json.getJSONObject(i);
				pd.put("DOCUMENT", jo.get("filename"));
				pd.put("PATH", jo.get("filePath"));
				ProjectChangeService.saveDocument(pd);// 将文件名称及上传路径存保存
			}

			ProjectChangeService.edit(pd);
			//修改审核人信息表
			pd.put("ID", Change.get("ID"));
			ProjectChangeService.deleteAdudit(pd);
			this.saveChangeAuditor(pd);
			
			if(pd.get("dids")!=null && !"".equals(pd.getString("dids"))){
				String delids = pd.getString("delIds");// 删除的信息ID
	
				if (!"".equals(delids)) {
					String ArrayDATA_IDS[] = delids.split(",");
					ProjectChangeService.batchDeleteDetail(ArrayDATA_IDS);
				}
	
				String[] dids = pd.getString("dids").split(",");
				String[] CHANGE_TYPE = pd.getString("CHANGE_TYPE").split(",", -1);
				String[] CHANGE_OBJ_ID = pd.getString("CHANGE").split(",", -1);
				String[] BEFORE_START_DATE = pd.getString("BEFORE_START_DATE")
						.split(",", -1);
				String[] AFTER_START_DATE = pd.getString("AFTER_START_DATE").split(
						",", -1);
				String[] BEFORE_END_DATE = pd.getString("BEFORE_END_DATE").split(
						",", -1);
				String[] AFTER_END_DATE = pd.getString("AFTER_END_DATE").split(",",
						-1);
				String[] BEFORE_WEIGHT = pd.getString("BEFORE_WEIGHT").split(",",-1);
				String[] AFTER_WEIGHT = pd.getString("AFTER_WEIGHT").split(",",-1);
	
				List<PageData> addList = new ArrayList<PageData>();
				List<PageData> upList = new ArrayList<PageData>();
	
				for (int i = 0; i < CHANGE_TYPE.length; i++) {
					PageData pdd = new PageData();
	
					pdd.put("UPDATE_USER",
							session.getAttribute(Const.SESSION_USERNAME)); // 最后修改人
					pdd.put("UPDATE_TIME", Tools.date2Str(new Date())); // 最后更改时间
					if (dids[i].equals("0")) {
						pdd.put("C_PROJECT_CHANGE_ID", pd.get("ID"));
						pdd.put("CREATE_USER",
								session.getAttribute(Const.SESSION_USERNAME)); // 创建人
						pdd.put("CREATE_TIME", Tools.date2Str(new Date())); // 创建时间
						pdd.put("CHANGE_TYPE", CHANGE_TYPE[i]);
						pdd.put("CHANGE_OBJ_ID", Integer.valueOf(CHANGE_OBJ_ID[i]));
						if (BEFORE_START_DATE[i] != null
								&& !BEFORE_START_DATE[i].equals("")) {
							pdd.put("BEFORE_START_DATE", BEFORE_START_DATE[i]);
						} else {
							pdd.put("BEFORE_START_DATE", "2000-01-01");
						}
						if (AFTER_START_DATE[i] != null
								&& !AFTER_START_DATE[i].equals("")) {
							pdd.put("AFTER_START_DATE", AFTER_START_DATE[i]);
						} else {
							pdd.put("AFTER_START_DATE", "2000-01-01");
						}
						if (BEFORE_END_DATE[i] != null
								&& !BEFORE_END_DATE[i].equals("")) {
							pdd.put("BEFORE_END_DATE", BEFORE_END_DATE[i]);
						} else {
							pdd.put("BEFORE_END_DATE", "2000-01-01");
						}
						if (AFTER_END_DATE[i] != null
								&& !AFTER_END_DATE[i].equals("")) {
							pdd.put("AFTER_END_DATE", AFTER_END_DATE[i]);
						} else {
							pdd.put("AFTER_END_DATE", "2000-01-01");
						}
						if (AFTER_WEIGHT[i] != null
								&& !AFTER_WEIGHT[i].equals("")) {
							pdd.put("AFTER_WEIGHT", AFTER_WEIGHT[i]);
						}  else if(BEFORE_WEIGHT[i] != null
								&& !BEFORE_WEIGHT[i].equals("")
								&&(AFTER_WEIGHT[i] == null||AFTER_WEIGHT[i].equals(""))){
							pdd.put("AFTER_WEIGHT", BEFORE_WEIGHT[i]);
						}else{
							pdd.put("AFTER_WEIGHT", null);
						}
						if(BEFORE_WEIGHT[i] != null
								&& !BEFORE_WEIGHT[i].equals("")){
							pdd.put("BEFORE_WEIGHT", BEFORE_WEIGHT[i]);
						}else
							pdd.put("BEFORE_WEIGHT", null);
						addList.add(pdd);
					} else {
						pdd.put("id", dids[i]);
						if (AFTER_START_DATE[i] != null
								&& !AFTER_START_DATE[i].equals("")) {
							pdd.put("AFTER_START_DATE", AFTER_START_DATE[i]);
						} else {
							pdd.put("AFTER_START_DATE", "2000-01-01");
						}
						if (AFTER_END_DATE[i] != null
								&& !AFTER_END_DATE[i].equals("")) {
							pdd.put("AFTER_END_DATE", AFTER_END_DATE[i]);
						} else {
							pdd.put("AFTER_END_DATE", "2000-01-01");
						}
						if (AFTER_WEIGHT[i] != null
								&& !AFTER_WEIGHT[i].equals("")) {
							pdd.put("AFTER_WEIGHT", AFTER_WEIGHT[i]);
						} else if(BEFORE_WEIGHT[i] != null
								&& !BEFORE_WEIGHT[i].equals("")
								&&(AFTER_WEIGHT[i] == null||AFTER_WEIGHT[i].equals(""))){
							pdd.put("AFTER_WEIGHT", BEFORE_WEIGHT[i]);
						}else{
							pdd.put("AFTER_WEIGHT", null);
						}
						upList.add(pdd);
					}
	
				}
	
				if (addList.size() > 0) {
					ProjectChangeService.addDetail(addList);
				}
				if (upList.size() > 0) {
					ProjectChangeService.batchUpdateDetail(upList);
				}
			}
			// pd.put("id", UuidUtil.get32UUID()); //ID
			mv.addObject("msg", "操作成功");

		} catch (Exception e) {
			logger.error(e.toString(), e);
			mv.addObject("msg", "操作失败");
		}
		mv.setViewName("save_result");
		return mv;
	}

	/**
	 * 查看页面
	 */
	@RequestMapping(value = "/goView")
	public ModelAndView goView(Page page) {
		ModelAndView mv = this.getModelAndView();
		PageData pd = new PageData();
		try {
			pd = this.getPageData();

			List<PageData> varList = ProjectChangeService
					.findChangeDetailByID(pd); // 查看项目列表明细
			pd = ProjectChangeService.findChangeByID(pd);

			List<PageData> file = ProjectChangeService.findFileById(pd);
			if (file != null) {
				mv.addObject("fileList", file);
			}
			List<PageData> empCodes = employeeService.listAll(new PageData());
			List<PageData> auditors = ProjectChangeService.findAuditors(pd);
			
			mv.setViewName("btarget/projectChange/add");
			mv.addObject("pd", pd);
			mv.addObject("msg", "view");
			mv.addObject("varList", varList);
			mv.addObject("empCodes", empCodes);
			mv.addObject("auditors", auditors);
		} catch (Exception e) {
			logger.error(e.toString(), e);
		}
		return mv;
	}

	/**
	 * 修改页面
	 */
	@RequestMapping(value = "/goEdit")
	public ModelAndView goEdit(Page page) {
		ModelAndView mv = this.getModelAndView();
		PageData pd = new PageData();
		try {
			pd = this.getPageData();

			List<PageData> varList = ProjectChangeService
					.findChangeDetailByID(pd); // 查看项目列表明细
			pd = ProjectChangeService.findChangeByID(pd);
			List<PageData> empCodes = employeeService.listAll(new PageData());
			List<PageData> auditors = ProjectChangeService.findAuditors(pd);
			
			mv.setViewName("btarget/projectChange/add");
			mv.addObject("pd", pd);
			mv.addObject("msg", "edit");
			mv.addObject("varList", varList);
			mv.addObject("empCodes", empCodes);
			mv.addObject("auditors", auditors);
		} catch (Exception e) {
			logger.error(e.toString(), e);
		}
		return mv;
	}

	/**
	 * 删除
	 */
	@RequestMapping(value = "/delete")
	public void delete(PrintWriter out) {
		logBefore(logger, "删除变更单");
		PageData pd = new PageData();
		try {
			pd = this.getPageData();
			Subject currentUser = SecurityUtils.getSubject();
			Session session = currentUser.getSession();
			pd.put("UPDATE_USER", session.getAttribute(Const.SESSION_USERNAME)); // 最后修改人
			pd.put("UPDATE_TIME", Tools.date2Str(new Date())); // 最后更改时间
			ProjectChangeService.deleteChange(pd);
			out.write("success");
		} catch (Exception e) {
			out.write("error");
			logger.error(e.toString(), e);
		}
		out.close();
	}

	/**
	 * 变更状态
	 */
	@RequestMapping(value = "/changeStatus")
	public void changeStatus(PrintWriter out) {
		logBefore(logger, "提交变更单");
		PageData pd = new PageData();
		try {
			pd = this.getPageData();
			Subject currentUser = SecurityUtils.getSubject();
			Session session = currentUser.getSession();
			pd.put("UPDATE_USER", session.getAttribute(Const.SESSION_USERNAME)); // 最后修改人
			pd.put("UPDATE_TIME", Tools.date2Str(new Date())); // 最后更改时间
			ProjectChangeService.updateChangeStatus(pd);
			pd.remove("UPDATE_USER");
			pd.remove("UPDATE_TIME");
			ProjectChangeService.updateAuditStatus(pd);
			out.write("success");
		} catch (Exception e) {
			out.write("error");
			logger.error(e.toString(), e);
		}
		out.close();
	}

	/**
	 * 上传文档
	 */
	@RequestMapping(value = "/Upload", produces = "application/json;charset=UTF-8")
	@ResponseBody
	public void Upload(
			@RequestParam(value = "id-input-file-1", required = false) MultipartFile[] DOCUMENT,
			HttpServletResponse response) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		List<Map<String, Object>> list = new ArrayList<Map<String, Object>>();
		try {
			for (int i = 0; i < DOCUMENT.length; i++) {
				if (null != DOCUMENT[i] && !DOCUMENT[i].isEmpty()) {
					String filePath = PathUtil.getClasspath()
							+ Const.FILEPATHFILE; // 文件上传路径
					String filename = DOCUMENT[i].getOriginalFilename();
					FileUpload.fileUp(DOCUMENT[i], filePath, DOCUMENT[i].getOriginalFilename()
							.substring(0, DOCUMENT[i].getOriginalFilename().lastIndexOf("."))); //执行上传
					map = new HashMap<String, Object>();
					map.put("filename", filename);
					map.put("filePath", filePath);
					list.add(map);
				}
			}

			// JSONObject jo = JSONObject.fromObject(list);
			String json = JSONArray.fromObject(list).toString();
			// System.out.println(json);
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

	@RequestMapping(value = "/changeText", produces = "text/html;charset=UTF-8")
	public void changeText(@RequestParam String C_PROJECT_CODE,
			HttpServletResponse response) throws Exception {
		PageData pd = new PageData();
		Map<String, Object> map = new HashMap<String, Object>();
		try {
			pd.put("C_PROJECT_CODE", C_PROJECT_CODE);

			List<PageData> eventList = ProjectChangeService.findEvent(pd);
			List<PageData> nodeList = ProjectChangeService.findNode(pd);
			pd.put("code", C_PROJECT_CODE);
			PageData project = projectService.findProjectByParam(pd);
			List<PageData> empCodesList = employeeService.listAll(new PageData());

			map.put("eventList", eventList);
			map.put("nodeList", nodeList);
			map.put("empCodesList", empCodesList);
			map.put("auditor", project.get("AUDITOR"));
			map.put("COMPLETION", project.get("COMPLETION"));
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

	@RequestMapping(value = "/change", produces = "text/html;charset=UTF-8")
	public void change(@RequestParam String TYPE, String ID,
			HttpServletResponse response) throws Exception {
		PageData pd = new PageData();
		Map<String, Object> map = new HashMap<String, Object>();
		try {
			pd.put("TYPE", TYPE);

			PageData detail = new PageData();
			if (TYPE.equals("HDBG")) {
				pd.put("EVENT_ID", Integer.valueOf(ID));
				detail = ProjectChangeService.findEventById(pd);
			} else if (TYPE.equals("JDBG")) {
				pd.put("NODE_ID", Integer.valueOf(ID));
				detail = ProjectChangeService.findNodeById(pd);
			}

			map.put("detail", detail);
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
	 * 审批列表
	 */
	@RequestMapping(value = "/checkList")
	public ModelAndView checkList(Page page) {
		ModelAndView mv = this.getModelAndView();
		mv.setViewName("btarget/projectChange/checklist");
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
	@RequestMapping(value = "/taskList2")
	public GridPage taskList2(Page page, HttpServletRequest request) {
		logBefore(logger, "年度经营任务（部门）列表");
		List<PageData> taskList = new ArrayList<>();
		try {
			convertPage(page, request);
			PageData pageData = page.getPd();
			Subject currentUser = SecurityUtils.getSubject();
			Session session = currentUser.getSession();
			pageData.put("USER", session.getAttribute(Const.SESSION_USERNAME)); // 登录人
			page.setPd(pageData);
			taskList = ProjectChangeService.findChangeForCheck(page);// 获取月度经营任务（部门）列表
		} catch (Exception e) {
			logger.error(e.toString(), e);
			e.printStackTrace();
		}
		return new GridPage(taskList, page);
	}
	/**
	 * 查看页面
	 */
	@RequestMapping(value = "/goCheckView")
	public ModelAndView goCheckView(Page page) {
		ModelAndView mv = this.getModelAndView();
		PageData pd = new PageData();
		try {
			pd = this.getPageData();

			List<PageData> varList = ProjectChangeService
					.findChangeDetailByID(pd); // 查看项目列表明细
			pd = ProjectChangeService.findChangeByID(pd);

			List<PageData> file = ProjectChangeService.findFileById(pd);
			if (file != null) {
				mv.addObject("fileList", file);
			}
			
			pd.put("AUDITOR", getUser().getNUMBER());
			PageData auditDetail = ProjectChangeService.findAuditDetail(pd);

			mv.setViewName("btarget/projectChange/check");
			mv.addObject("pd", pd);
			mv.addObject("msg", "view");
			mv.addObject("varList", varList);
			mv.addObject("auditDetail", auditDetail);
		} catch (Exception e) {
			logger.error(e.toString(), e);
		}
		return mv;
	}

	/**
	 * 审核页面
	 */
	@RequestMapping(value = "/goCheck")
	public ModelAndView goCheck(Page page) {
		ModelAndView mv = this.getModelAndView();
		PageData pd = new PageData();
		try {
			pd = this.getPageData();

			List<PageData> varList = ProjectChangeService
					.findChangeDetailByID(pd); // 查看项目列表明细
			pd = ProjectChangeService.findChangeByID(pd);

			List<PageData> file = ProjectChangeService.findFileById(pd);
			if (file != null) {
				mv.addObject("fileList", file);
			}

			mv.setViewName("btarget/projectChange/check");
			mv.addObject("pd", pd);
			mv.addObject("msg", "check");
			mv.addObject("varList", varList);
		} catch (Exception e) {
			logger.error(e.toString(), e);
		}
		return mv;
	}

	/**
	 * 审批（修改状态）
	 */
	@RequestMapping(value = "/check")
	public void check(PrintWriter out) {
		logBefore(logger, "审批结果");
		PageData pd = new PageData();
		try {
			pd = this.getPageData();
			Subject currentUser = SecurityUtils.getSubject();
			Session session = currentUser.getSession();
			pd.put("UPDATE_USER", session.getAttribute(Const.SESSION_USERNAME)); // 最后修改人
			pd.put("UPDATE_TIME", Tools.date2Str(new Date())); // 最后更改时间
			pd.put("OPINION", URLDecoder.decode(pd.getString("OPINION"), "utf-8"));
			List<PageData> varList = ProjectChangeService
					.findChangeDetailByID(pd); // 查看项目列表明细
			//修改变更审核表状态
			pd.put("AUDITOR", getUser().getNUMBER());
			ProjectChangeService.updateAuditStatus(pd);
			
			if (pd.get("STATUS").equals("YW_YSX")) {
				Boolean isCheckedAll = ProjectChangeService.isCheckedAll(pd);
				if(isCheckedAll){
					for (int i = 0; i < varList.size(); i++) {
						PageData detail = new PageData();
						detail = varList.get(i);
						detail.put("UPDATE_USER",
								session.getAttribute(Const.SESSION_USERNAME)); // 最后修改人
						detail.put("UPDATE_TIME", Tools.date2Str(new Date())); // 最后更改时间
	
						if (detail.get("CHANGE_TYPE").equals("HDBG")) {
							ProjectChangeService.updateEvent(detail);
						} else if (detail.get("CHANGE_TYPE").equals("JDBG")) {
							ProjectChangeService.updateNode(detail);
						}
					}
					//修改项目完成标准
					if(pd.get("CHANGE_COMPLETION") != null && !"".equals(pd.getString("CHANGE_COMPLETION")))
						pd.put("CHANGE_COMPLETION", URLDecoder.decode(pd.getString("CHANGE_COMPLETION"), "utf-8"));
						projectService.updateCompletion(pd);
					ProjectChangeService.updateChangeStatus(pd);
				}
			}else if(pd.get("STATUS").equals("YW_YTH"))
				ProjectChangeService.updateChangeStatus(pd);
			out.write("success");
			// }
		} catch (Exception e) {
			logger.error(e.toString(), e);
		} finally {
			out.flush();
			out.close();
		}

	}

}
