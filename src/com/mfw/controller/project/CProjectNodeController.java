package com.mfw.controller.project;

import java.util.ArrayList;
import java.util.List;

import javax.annotation.Resource;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import com.mfw.controller.base.BaseController;

import com.mfw.entity.system.UserLog;
import com.mfw.entity.system.UserLog.LogType;
import com.mfw.service.bdata.DeptService;
import com.mfw.service.bdata.EmployeeService;
import com.mfw.service.bdata.ProjectNodeLevelService;
import com.mfw.service.project.CProjectEventService;
import com.mfw.service.project.CProjectNodeService;
import com.mfw.service.project.CProjectService;
import com.mfw.service.system.UserLogService;
import com.mfw.service.system.role.RoleService;
import com.mfw.util.Const;
import com.mfw.util.EndPointServer;
import com.mfw.util.PageData;
import com.mfw.util.TaskType;

import net.sf.json.JSONArray;

/**
 * Controller-创新项目节点
 * @author liweitao
 *
 */
@Controller
@RequestMapping("/cpNode")
public class CProjectNodeController extends BaseController{

	@Resource(name="userLogService")
	private UserLogService userlogService;
	@Resource(name="cpNodeService")
	private CProjectNodeService cpNodeService;
	@Resource(name="cpEventService")
	private CProjectEventService cpEventService;
	@Resource(name = "deptService")
	private DeptService deptService;
	@Resource(name = "employeeService")
	private EmployeeService employeeService;
	@Resource(name="projectNodeLevelService")
	private ProjectNodeLevelService projectNodeLevelService;
	@Resource(name="cprojectService")
	private CProjectService projectService;
	@Resource(name="roleService")
	private RoleService roleService;
	
	/**
	 * 显示项目节点信息
	 * @return
	 */
	@RequestMapping("toNodeInfo")
	public ModelAndView toNodeInfo(){
		ModelAndView modelAndView = getModelAndView();
		PageData pageData = getPageData();
		modelAndView.addObject("param", pageData);
		
		try {
			pageData = cpNodeService.findNodeByParam(pageData);
			//权限不再从节点层级获取，改为节点的创建人
			//boolean hasRight = cpNodeService.hasRightOfNode(getUser(), pageData);
			boolean hasRight = getUser().getUSERNAME().equals(pageData.get("CREATE_USER"));
			pageData.put("hasRight", hasRight);
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		modelAndView.addObject("node", pageData);
		modelAndView.setViewName("project/project_node_info");
		return modelAndView;
	}
	
	/**
	 * 编辑项目活动信息
	 * @return
	 */
	@RequestMapping("toNodeEdit")
	public ModelAndView toNodeEdit(){
		ModelAndView modelAndView = getModelAndView();
		PageData pageData = getPageData();
		
		try {
			//列出所有部门
//			List<PageData> deptList = deptService.listWithAuth(getUser());
			List<PageData> deptList = deptService.listAll(new PageData());
			JSONArray arr = JSONArray.fromObject(deptList);
			modelAndView.addObject("deptTreeNodes", arr.toString());
			
			PageData node = cpNodeService.findNodeByParam(pageData);
			modelAndView.addObject("node", node);
			
			List<PageData> emps = employeeService.findEmpByDept(
					String.valueOf(node.get("deptId")));
			modelAndView.addObject("emps", emps);
			
			//获取节点层级
			PageData nodeLevenParam = new PageData();
			nodeLevenParam.put("PROJECT_CODE", node.getString("C_PROJECT_CODE"));
			nodeLevenParam.put("NODE_LEVEL", Integer.valueOf(pageData.getString("level")));
			modelAndView.addObject("nodelLevels", 
					projectNodeLevelService.findLevelsByNode(nodeLevenParam,getUser()));
		} catch (Exception e) {
			e.printStackTrace();
		}
		modelAndView.setViewName("project/project_node_edit");
		return modelAndView;
	}
	
	/**
	 * 添加项目节点信息
	 * @return
	 */
	@RequestMapping("toNodeAdd")
	public ModelAndView toNodeAdd(){
		ModelAndView modelAndView = getModelAndView();
		PageData pageData = getPageData();
		
		PageData result = new PageData();
		String type = pageData.getString("type");
		
		try {
			//获取节点默认信息
			if(type.equals("project")){
				String code = pageData.getString("ID");
				pageData.put("code", code);
				pageData.remove("ID");
				PageData project = projectService.findProjectByParam(pageData);
				result.put("C_PROJECT_CODE", code);
				result.put("PROJECT_NAME", project.getString("NAME"));
				result.put("PARENT_ID", 0);
				result.put("PARENT_NAME", "无");
				result.put("startDate", project.get("START_DATE"));
				result.put("endDate", project.get("END_DATE"));
			}else if(type.equals("node")){
				int pid = Integer.valueOf(pageData.getString("ID"));
				PageData parentNode = cpNodeService.findNodeByParam(pageData);
				result.put("PARENT_ID", pid);
				result.put("PARENT_NAME", parentNode.getString("NODE_TARGET"));
				result.put("C_PROJECT_CODE", parentNode.get("C_PROJECT_CODE"));
				result.put("PROJECT_NAME", parentNode.get("PROJECT_NAME"));
				result.put("endDate", parentNode.get("PLAN_DATE"));
			}
			modelAndView.addObject("node", result);
			
			//列出所有部门
//			List<PageData> deptList = deptService.listWithAuth(getUser());
			List<PageData> deptList = deptService.listAll(new PageData());
			JSONArray arr = JSONArray.fromObject(deptList);
			modelAndView.addObject("deptTreeNodes", arr.toString());
			
			//获取节点层级
			PageData nodeLevenParam = new PageData();
			nodeLevenParam.put("PROJECT_CODE", result.getString("C_PROJECT_CODE"));
			nodeLevenParam.put("NODE_LEVEL", Integer.valueOf(pageData.getString("level"))+1);
			modelAndView.addObject("nodelLevels", 
					projectNodeLevelService.findLevelsByNode(nodeLevenParam, getUser()));
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		modelAndView.setViewName("project/project_node_edit");
		return modelAndView;
	}
	
	/**
	 * 保存项目节点信息
	 * @return
	 */
	@RequestMapping("saveNode")
	public String saveNode(){
		PageData pageData = getPageData();
		String id = pageData.getString("ID");
		String msg = "";
		try {
			//权重默认值为1
			if(pageData.getString("WEIGHT").equals("")){
				pageData.put("WEIGHT", 1);
			}
			
			if(id == null || id.equals("")){
				savePage(pageData);
				if(pageData.getString("STATUS") == null 
						|| pageData.getString("STATUS").equals("")){
					pageData.put("STATUS", Const.SYS_STATUS_YW_CG);
				}
				cpNodeService.addNode(pageData);
				userlogService.logInfo(new UserLog(getUser().getUSER_ID(), LogType.add, 
						"创新项目节点", "目标：" + pageData.getString("NODE_TARGET")));
				msg = "add";
			}else{
				updatePage(pageData);
				cpNodeService.updateNode(pageData);
				userlogService.logInfo(new UserLog(getUser().getUSER_ID(), LogType.update, 
						"创新项目节点", "目标：" + pageData.getString("NODE_TARGET")));
				msg = "update";
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return "redirect:toNodeInfo.do?msg=" + msg + "&ID=" + pageData.getString("ID");
	}
	
	/**
	 * 删除项目节点
	 * @return
	 */
	@ResponseBody
	@RequestMapping("removeNodes")
	public String removeNodes(String ID,String type){
		try {
			if(type.equals("event")){
				cpEventService.removeEvent(ID);
			}else if(type.equals("node")){
				List<PageData> result = findChildrenByParentId(getPageData());
				cpNodeService.removeNodes(result);
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return "success";
	}
	
//	/**
//	 * 检查当前登录用户是否有权限
//	 * @return
//	 */
//	@ResponseBody
//	@RequestMapping("checkAuthNode")
//	public HashMap<String,Object> checkAuthNode(){
//		HashMap<String,Object> resultMap = new HashMap<>();
//		PageData pageData = getPageData();
//		pageData.put("roleId", getUser().getROLE_ID());
//		pageData.put("level", Integer.valueOf(pageData.getString("level")) + 1);
//		try {
//			List<PageData> result = cpNodeService.checkAuthNode(pageData);
//			
//			String roleId = getUser().getROLE_ID();
//			boolean hasAuth = false;
//			StringBuffer roleStr = new StringBuffer();
//			for(PageData data : result){
//				String[] ids = data.getString("ROLEIDS").split(",");
//				roleStr.append(roleService.findNameByIds(ids));
//				
//				for(String id : ids){
//					if(id.equals(roleId)){
//						hasAuth = true;
//					}
//				}
//			}
//			resultMap.put("hasAuth", hasAuth);
//			resultMap.put("roles", roleStr.substring(0, roleStr.length() - 1));
//		} catch (Exception e) {
//			e.printStackTrace();
//		}
//		return resultMap;
//	}
	
	@RequestMapping("refer")
	public String refer(){
		PageData pageData = getPageData();
		try {
			boolean result = cpNodeService.refer(pageData);
			
			if(result){
				EndPointServer.sendMessage(getUser().getNAME(), pageData.getString("EMP_CODE"), TaskType.cprojectNode);
				return "redirect:toNodeInfo.do?msg=update&ID=" + pageData.getString("ID");
			}else{
				return "";
			}
		} catch (Exception e) {
			e.printStackTrace();
			return null;
		}
	}
	
	/**
	 * 根据父节点ID获取所有子节点数据
	 * @return
	 * @throws Exception 
	 */
	private List<PageData> findChildrenByParentId(PageData pageData) throws Exception{
		PageData rootNode = cpNodeService.findNodeByParam(getPageData());
		rootNode.put("id", pageData.get("ID"));
		rootNode.put("type", pageData.get("type"));
		List<PageData> result = new ArrayList<>();
		
		List<PageData> tempParentList = new ArrayList<>();
		tempParentList.add(rootNode);
		
		boolean needWhile = true;
		while(needWhile){
			List<PageData> tempList = new ArrayList<>();
			for(PageData data : tempParentList){
				if(data.getString("type").equals("node")){
					tempList.addAll(projectService.getTreeNodes(data));
				}
			}
			needWhile = !(tempList.size() == 0);
			result.addAll(tempParentList);
			tempParentList = tempList;
		}
		return result;
	}
}
