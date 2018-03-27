package com.mfw.controller.bdata;

import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.List;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import com.mfw.controller.base.BaseController;
import com.mfw.entity.GridPage;
import com.mfw.entity.Page;
import com.mfw.entity.system.User;
import com.mfw.service.bdata.CommonService;
import com.mfw.service.bdata.ProjectNodeLevelService;
import com.mfw.service.system.role.RoleService;
import com.mfw.util.PageData;

/**
 * Controller-项目节点层级
 * @author
 *
 */
@Controller
@RequestMapping(value = "/projectNodeLevel")
public class ProjectNodeLevelController extends BaseController {

	@Resource(name = "commonService")
	private CommonService commonService;
	@Resource(name = "projectNodeLevelService")
	private ProjectNodeLevelService projectNodeLevelService;
	@Resource(name = "roleService")
	private RoleService roleService;
	/**
	 * 新增
	 */
	@RequestMapping(value = "/add")
	public ModelAndView add() throws Exception {
		ModelAndView mv = this.getModelAndView();
		PageData pd = this.getPageData();
		try {
//			pd.put("ROLEIDS", pd.getString("selectGroups"));
			savePage(pd);
			projectNodeLevelService.add(pd);
		} catch (Exception e) {
			mv.addObject("msg", "add");
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
			projectNodeLevelService.delete(pd);
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
		PageData pd = this.getPageData();
		try {
//			if(pd.get("selectGroups")!=null){
//				pd.put("ROLEIDS", pd.get("selectGroups"));
//			}else{
//				pd.put("ROLEIDS", "");
//			}
			updatePage(pd);
			projectNodeLevelService.edit(pd);
		} catch (Exception e) {
			mv.addObject("msg", "edit");
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
		User user = getUser();
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
//			List<PageData> pnList = projectNodeLevelService.list(page); //列出节点层级列表
//			List<PageData> roleList = projectNodeLevelService.roleListAll(pd);; //列出角色列表
//			mv.addObject("pnList", pnList);
//			mv.addObject("roleList", roleList);
			mv.addObject("pd", pd);
			mv.setViewName("bdata/projectNodeLevel/list");
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
			
			empList = projectNodeLevelService.list(page);
			
			
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
		PageData pd = this.getPageData();
 		pd= projectNodeLevelService.findById(pd);
// 		String ArrayRoleIds[];
// 		List<PageData> subList = new ArrayList<>();
// 		List<PageData> subCheckedList = new ArrayList<PageData>();
// 		if(!"".equals(pd.get("ROLEIDS"))){
//			ArrayRoleIds = pd.getString("ROLEIDS").split(",");
//	 		for(int i=0;i<ArrayRoleIds.length;i++){
//	 			PageData tempdata = new PageData();
//	 			tempdata.put("ROLE_ID", ArrayRoleIds[i]);
//	 			tempdata = roleService.findObjectById(tempdata);
//	 			subCheckedList.add(tempdata);
//	 		}
//	 		subList = projectNodeLevelService.roleList(ArrayRoleIds);
// 		}else{
// 			subList = projectNodeLevelService.roleListAll(null);
// 		}
 		
// 		List<Role> roleList = roleService.listAllRoles(); //列出角色列表
 		
		mv.setViewName("bdata/projectNodeLevel/edit");
//		mv.addObject("roleList", roleList);
//		mv.addObject("subCheckedList", subCheckedList);
//		mv.addObject("subList", subList);
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
		PageData pd = this.getPageData();
		mv.setViewName("bdata/projectNodeLevel/edit");
		mv.addObject("msg", "add");
		mv.addObject("pd", pd);
		return mv;
	}
}
