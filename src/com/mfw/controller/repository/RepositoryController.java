package com.mfw.controller.repository;

import java.io.PrintWriter;
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
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.ModelAndView;

import com.mfw.controller.base.BaseController;
import com.mfw.entity.GridPage;
import com.mfw.entity.Page;
import com.mfw.entity.system.User;
import com.mfw.service.bdata.DeptService;
import com.mfw.service.bdata.EmployeeService;
import com.mfw.service.repository.RepositoryService;
import com.mfw.service.system.datarole.DataRoleService;
import com.mfw.util.Const;
import com.mfw.util.FileDownload;
import com.mfw.util.FileUpload;
import com.mfw.util.PageData;
import com.mfw.util.PathUtil;
import com.mfw.util.Tools;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

@Controller
@RequestMapping("/repository")
public class RepositoryController extends BaseController{

	@Resource(name="repositoryService")
	private RepositoryService repositoryService;
	
	@Resource(name="dataroleService")
	private DataRoleService dataroleService;
	
	@Resource(name = "deptService")
	private DeptService deptService;
	
	@Resource(name = "employeeService")
	private EmployeeService employeeService;
	/**
	 * 初始化进入页面跳转
	 * @return
	 */
	@RequestMapping(value= "/list")
	public ModelAndView list(){
		ModelAndView mv = this.getModelAndView();
		Subject currentUser = SecurityUtils.getSubject();
		Session session = currentUser.getSession();
		User user = (User) session.getAttribute(Const.SESSION_USERROL);
		mv.addObject("USER_NAME",user.getUSERNAME());
		mv.setViewName("repository/list");
		return mv;
	}
	/**
	 * 获取表格数据
	 * @param page
	 * @return
	 * @throws Exception 
	 */
	@ResponseBody
	@RequestMapping(value="/taskList")
	public GridPage taskList(Page page,HttpServletRequest request) throws Exception{
		logBefore(logger, "知识库列表");
		List<PageData> taskList = new ArrayList<>();
		convertPage(page, request);
		PageData pageData = page.getPd();
		String DEPT_NAME = pageData.getString("DEPT_NAME");
		if(null != DEPT_NAME && !"".equals(DEPT_NAME)){//trim
			DEPT_NAME = DEPT_NAME.trim();
			pageData.put("DEPT_NAME", DEPT_NAME);
		}
		
		Subject currentUser = SecurityUtils.getSubject();
		Session session = currentUser.getSession();
		User user = (User) session.getAttribute(Const.SESSION_USERROL);
//		List<PageData> dataRoles = dataroleService.findByUser(user.getUSER_ID());
//		String DEPT_IDS = "";
//		String USER_ID = user.getUSER_ID();
//		for(PageData dataRole : dataRoles){
//			DEPT_IDS+=(dataRole.get("DEPT_ID")+",");
//		}
//		if (DEPT_IDS!=null&&!DEPT_IDS.equals("")) {
//			DEPT_IDS = DEPT_IDS.substring(0, DEPT_IDS.length()-1);
//		}
//		pageData.put("DEPT_IDS", DEPT_IDS);
		pageData.put("UPLOADPERSON_ID", user.getUSER_ID());
		pageData.put("EMP_CODE", user.getNUMBER());
		
		page.setPd(pageData);
		taskList = repositoryService.list(page);
		
		return new GridPage(taskList,page);
		
	}
	
	
	@RequestMapping(value = "/showUpload")
	public ModelAndView showUpload() throws Exception {
		ModelAndView mv = this.getModelAndView();
		PageData pd = this.getPageData();
		mv.addObject("pd", pd);
		// 塞入部门树所需要的数据
		List<PageData> deptLists = new ArrayList<PageData>();
		deptLists = deptService.listAlln();
		List<PageData> employeeLists = new ArrayList<PageData>();
		for(PageData dept : deptLists){
			dept.put("nocheck", true);
			employeeLists.addAll(employeeService.findEmpByDeptPd(dept));
		}
		deptLists.addAll(employeeLists);
		
		JSONArray arr = JSONArray.fromObject(deptLists);
        mv.addObject("deptTreeNodes", arr.toString());
		mv.setViewName("repository/uploadFile");
		return mv;
	}
	
	/**
	 * 上传文档
	 */		
	@RequestMapping(value = "/Upload",produces="application/json;charset=UTF-8")
	@ResponseBody
	public void RepoUpload(
			@RequestParam(value = "id-input-file-1", required = false) MultipartFile[] DOCUMENT,  HttpServletResponse response, HttpServletRequest request
	) throws Exception{
		Map<String, Object> map = new HashMap<String, Object>();
		List<Map<String, Object>> list = new ArrayList<Map<String, Object>>();
		try {
			for(int i=0;i<DOCUMENT.length;i++)
			{
				if (null != DOCUMENT[i] && !DOCUMENT[i].isEmpty()) {
					String filePath = PathUtil.getClasspath() + Const.FILEPATHZSK; //文件上传路径
					String filename = DOCUMENT[i].getOriginalFilename();
//					FileUpload.fileUp(DOCUMENT[i], filePath, DOCUMENT[i].getOriginalFilename()
//							.substring(0, DOCUMENT[i].getOriginalFilename().lastIndexOf("."))); //执行上传
					String filename_server = FileUpload.uploadFileNew(request, DOCUMENT[i], Const.FILEPATHZSK);
					
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
		}catch (Exception e){
			logger.error(e.toString(), e);
			
		}
		
	}
	
	
	/**
	 * 新增
	 */
	@RequestMapping(value = "/save")
	public ModelAndView save() throws Exception {
		logBefore(logger, "新增知识库记录");
		ModelAndView mv = this.getModelAndView();
		try {
			PageData pd = new PageData();
			pd = this.getPageData();
			
			Subject currentUser = SecurityUtils.getSubject();
			Session session = currentUser.getSession();
			
			User user = (User) session.getAttribute(Const.SESSION_USERROL);
			pd.put("DEPT_ID", user.getDeptId());		//部门ID
			pd.put("DEPT_NAME", user.getDeptName());		//部门名称
			pd.put("UPLOADPERSON", session.getAttribute(Const.SESSION_USERNAME));		//创建人
			pd.put("UPLOADPERSON_ID", user.getUSER_ID());		//创建人
			pd.put("UPLOADTIME", Tools.date2Str(new Date()));							//创建时间			
			pd.put("REMARK", pd.get("REMARK"));							//创建时间	
			
			String emp_ids = pd.getString("EMP_ID");
			String[] empIdlist = null;
			String[] empCodelist = null;
			if(emp_ids != null && !"".equals(emp_ids)){
				empIdlist = emp_ids.split(",");
				empCodelist = pd.getString("EMP_CODE").split(",");
			}
			if(pd.getString("DOC_TYPE").equals("1"))
				pd.put("DEPT_CLASSIFY", null);
			String document = (String) pd.get("DOCUMENT");
			JSONArray json = JSONArray.fromObject(document);
			for(int i = 0; i < json.size(); i++){
				JSONObject jo = json.getJSONObject(i);
				pd.put("FILENAME", jo.get("filename"));
				pd.put("FILENAME_SERVER", jo.get("filename_server"));
				pd.put("FILEPATH", jo.get("filePath"));
				repositoryService.save(pd);//将文件名称及上传路径存保存
				if(empIdlist != null){
					for(int j = 0; j < empIdlist.length; j++){
						pd.put("EMP_ID", empIdlist[j]);
						pd.put("EMP_CODE", empCodelist[j]);
						pd.put("ISSUED_TIME", Tools.date2Str(new Date()));
						repositoryService.saveIssued(pd);
					}
				}
			}
			
			mv.addObject("msg", "saveSucc");
			mv.addObject("info", "上传成功");
			mv.setViewName("save_result");
			
		} catch (Exception e) {
			mv.addObject("editFlag", "savefail");
			logger.error(e.toString(), e);
		}
		
		return mv;
	}
	
	@RequestMapping(value = "/delete")
	private void delete(PrintWriter out) throws Exception{
       
		logBefore(logger, "知识库记录删除");
		PageData pd = this.getPageData();
		repositoryService.delete(pd);
		repositoryService.deleteIssued(pd);
		out.write("success");
		out.close();
    }
	
	/**
	 * 请求编辑意见
	 */
	@RequestMapping(value = "/toEditOpinion")
	public ModelAndView toEditOpinion(String DOC_ID) throws Exception {
		ModelAndView mv = this.getModelAndView();
		PageData pd = new PageData();
		try {
			pd = this.getPageData();
			pd.put("DOC_ID", DOC_ID);
			
			Subject currentUser = SecurityUtils.getSubject();
			Session session = currentUser.getSession();
			User user = (User) session.getAttribute(Const.SESSION_USERROL);
			pd.put("EMP_CODE", user.getNUMBER());
			pd = repositoryService.findIssuedById(pd);

			mv.setViewName("repository/opinion_edit");
			mv.addObject("pd", pd);
		} catch (Exception e) {
			logger.error(e.toString(), e);
		}
		return mv;
	}
	/**
	 * 保存意见
	 */
	@RequestMapping(value = "/saveOpinion")
	public ModelAndView saveOpinion() throws Exception {
		ModelAndView mv = this.getModelAndView();
		PageData pd = new PageData();
		try {
			pd = this.getPageData();
			pd.put("UPDATETIME", new Date());
			repositoryService.updateIssued(pd);
			mv.addObject("msg", "success");
		} catch (Exception e) {
			logger.error(e.toString(), e);
			mv.addObject("msg", "failed");
		}
		mv.setViewName("save_result");
		return mv;
	}
	
	/**
	 * 查看编辑意见
	 */
	@RequestMapping(value = "/toCheckOpinion")
	public ModelAndView toCheckOpinion(String DOC_ID) throws Exception {
		ModelAndView mv = this.getModelAndView();
		PageData pd = new PageData();
		try {
			pd = this.getPageData();
			pd.put("doc_id", DOC_ID);
			mv.setViewName("repository/opinion_check");
			mv.addObject("pd", pd);
		} catch (Exception e) {
			logger.error(e.toString(), e);
		}
		return mv;
	}
	@ResponseBody
	@RequestMapping(value="/opinionList")
	public GridPage opinionList(Page page,HttpServletRequest request) throws Exception{
		logBefore(logger, "意见列表");
		List<PageData> pdList = new ArrayList<PageData>();
		convertPage(page, request);
		PageData pd = page.getPd();
		pd = this.getPageData();
		pdList = repositoryService.findIssuedOpinions(pd);
		page.setPd(pd);
		return new GridPage(pdList,page);

	}
	
	@RequestMapping(value = "/info_list")
	public ModelAndView infoList(Page page) {
		logBefore(logger, "部门列表");
		ModelAndView mv = this.getModelAndView();
		
		try {
			List<PageData> dtreeList = new ArrayList<PageData>() ;
			dtreeList = deptService.listAlln();
			PageData all = new PageData();
			all.put("ID", "-2");
			all.put("PARENT_ID", "0");
			all.put("ORDER_NUM", "1");
			all.put("DEPT_CODE", "ALL");
			all.put("DEPT_NAME", "公共文件");
			dtreeList.add(all);
			mv.addObject("USER_NAME",getUser().getUSERNAME());
			mv.addObject("varList",dtreeList);			
			mv.setViewName("repository/information_list");
		} catch (Exception e) {
			logger.error(e.toString(), e);
		}
		return mv;
	}
	
	@ResponseBody
	@RequestMapping(value = "/taskListByDeptId")
	public GridPage taskListByDeptId(Page page,HttpServletRequest request) throws Exception{
		logBefore(logger, "资源列表");
		List<PageData> taskList = new ArrayList<>();
		convertPage(page, request);
		PageData pageData = page.getPd();
		String DEPT_ID = pageData.getString("DEPT_CLASSIFY");
		if(null != DEPT_ID && !"".equals(DEPT_ID)){//trim
			pageData.put("DEPT_CLASSIFY", DEPT_ID);
		}else
			pageData.put("DEPT_CLASSIFY", "");
		pageData.put("DOC_TYPE", "0");
		
		User user = getUser();
		pageData.put("UPLOADPERSON_ID", user.getUSER_ID());
		pageData.put("EMP_CODE", user.getNUMBER());
		
		page.setPd(pageData);
		taskList = repositoryService.listByDeptId(page);
		
		return new GridPage(taskList,page);
	}
	
	/**
	 * 下载
	 */
	@RequestMapping(value = "/downLoad")
	public void downLoad(HttpServletResponse response) throws Exception {
		PageData pd = getPageData();
		FileDownload.fileDownload(response, PathUtil.getClasspath() + Const.FILEPATHZSK + pd.getString("fileName"), pd.getString("fileName"));
	}
}
