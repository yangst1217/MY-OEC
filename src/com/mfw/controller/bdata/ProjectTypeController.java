package com.mfw.controller.bdata;

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
import com.mfw.service.bdata.CommonService;
import com.mfw.service.bdata.EmployeeService;
import com.mfw.service.bdata.NodeLevelFrameService;
import com.mfw.service.bdata.ProjectTypeService;
import com.mfw.util.Const;
import com.mfw.util.PageData;
import com.mfw.util.Tools;

/**
 * Controller-项目类型
 * @author
 *
 */
@Controller
@RequestMapping(value = "/projectType")
public class ProjectTypeController extends BaseController {
	
	@Resource(name = "projectTypeService")
	private ProjectTypeService projectTypeService;
	@Resource(name = "commonService")
	private CommonService commonService;
	@Resource(name = "nodeLevelFrameService")
	private NodeLevelFrameService nodeLevelFrameService;
	@Resource(name = "employeeService")
	private EmployeeService employeeService;
	/**
	 * 新增
	 */
	@RequestMapping(value = "/add")
	public ModelAndView add() throws Exception {
		ModelAndView mv = this.getModelAndView();
		PageData pd = new PageData();
		Subject currentUser = SecurityUtils.getSubject();
		Session session = currentUser.getSession();
		User user =(User) session.getAttribute(Const.SESSION_USER);
		try {
			pd = this.getPageData();
			PageData empcode = new PageData();
			if("1".equals(pd.get("ISCHECK"))){
				empcode.put("ID", pd.get("CHECK_PERSON_ID"));
				empcode = employeeService.findById(empcode);
				pd.put("CHECK_PERSON_CODE", empcode.get("EMP_CODE"));
			}
			pd.put("ISDEL", 0);
			pd.put("CREATE_TIME", Tools.date2Str(new Date()));
			pd.put("CREATE_USER", user.getNAME());
			projectTypeService.add(pd);
		} catch (Exception e) {
			mv.addObject("msg", "保存失败");
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
		logBefore(logger, "删除pType");
		PageData pd = new PageData();
		try {
			pd = this.getPageData();
			projectTypeService.delete(pd);
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
		Subject currentUser = SecurityUtils.getSubject();
		Session session = currentUser.getSession();
		User user =(User) session.getAttribute(Const.SESSION_USER);
		PageData pd = new PageData();
		try {
			pd = this.getPageData();
			if("1".equals(pd.get("ISCHECK"))){
				PageData empcode = new PageData();
				empcode.put("ID", pd.get("CHECK_PERSON_ID"));
				empcode = employeeService.findById(empcode);
				pd.put("CHECK_PERSON_CODE", empcode.get("EMP_CODE"));
			}else{
				pd.put("CHECK_PERSON_CODE", " ");
			}
			
			pd.put("UPDATE_TIME", Tools.date2Str(new Date()));
			pd.put("UPDATE_USER", user.getNAME());
			projectTypeService.edit(pd);
		} catch (Exception e) {
			mv.addObject("msg", "保存失败");
			e.printStackTrace();
		}
		mv.setViewName("save_result");
		return mv;
	}
	/**
	 * 列表
	 */
	@RequestMapping(value = "/list")
	public ModelAndView list(Page page) {
		logBefore(logger, "列表pType");
		ModelAndView mv = this.getModelAndView();
		Subject currentUser = SecurityUtils.getSubject();
		Session session = currentUser.getSession();
		User user =(User) session.getAttribute(Const.SESSION_USER);
		PageData pd = new PageData();		
		try {	
			pd = this.getPageData();
			String roleId = user.getROLE_ID();
			if(roleId != null){
				int count = commonService.checkSysRole(roleId);
				if(count==0){
					pd.put("userCode", user.getNUMBER());
				}
			}
			page.setPd(pd);	
//			List<PageData> pTypeList = projectTypeService.list(page); //列出员工日清列表
//			mv.addObject("pTypeList", pTypeList);
			mv.addObject("msg", "edit");
			mv.addObject("pd", pd);
			mv.setViewName("bdata/projectType/list");

		} catch (Exception e) {
			logger.error(e.toString(), e);
		}
		return mv;
	}
	
	@ResponseBody
	@RequestMapping(value = "/empList")
	public GridPage employeeList(Page page, HttpServletRequest request){
		List<PageData> empList = new ArrayList<>();
		try {
			convertPage(page, request);
//			PageData pageData = page.getPd();
			
			empList = projectTypeService.list(page); //列出员工日清列表
			
			
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
			e.printStackTrace();
		}
		return new GridPage(empList, page);
	}
	
	/**
	 * 去修改页面
	 */
	@RequestMapping(value = "/goEdit")
	public ModelAndView goEdit(Page page) throws Exception {
		ModelAndView mv = this.getModelAndView();
		PageData pd = new PageData();
 		pd = this.getPageData();
 		page.setPd(pd);	
 		List<PageData> frameList = nodeLevelFrameService.listAll(page); //列出结构列表
 		pd= projectTypeService.findById(pd);
		mv.setViewName("bdata/projectType/edit");
		mv.addObject("frameList", frameList);
		mv.addObject("msg", "edit");
		mv.addObject("pd", pd);

		return mv;
	}
	/**
	 * 去新增页面
	 */
	@RequestMapping(value = "/goAdd")
	public ModelAndView goAdd(Page page) throws Exception {
		ModelAndView mv = this.getModelAndView();
		PageData pd = new PageData();
 		pd = this.getPageData();
 		page.setPd(pd);	
 		List<PageData> frameList = nodeLevelFrameService.listAll(page); //列出结构列表
		mv.setViewName("bdata/projectType/edit");
		mv.addObject("frameList", frameList);
		mv.addObject("msg", "add");
		mv.addObject("pd", pd);

		return mv;
	}
}
