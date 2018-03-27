package com.mfw.controller.project;

import java.util.ArrayList;
import java.util.List;
import java.util.Set;

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
import com.mfw.service.project.CProjectEventService;
import com.mfw.service.project.CProjectNodeService;
import com.mfw.service.project.CProjectService;
import com.mfw.service.system.UserLogService;
import com.mfw.util.Const;
import com.mfw.util.EndPointServer;
import com.mfw.util.PageData;
import com.mfw.util.TaskType;

import net.sf.json.JSONArray;

/**
 * Controller-创新项目活动
 * @author liweitao
 *
 */
@Controller
@RequestMapping("/cpEvent")
public class CProjectEventController extends BaseController{
	
	@Resource(name="userLogService")
	private UserLogService userlogService;
	@Resource(name="cpEventService")
	private CProjectEventService cpEventService;
	@Resource(name = "deptService")
	private DeptService deptService;
	@Resource(name = "employeeService")
	private EmployeeService employeeService;
	@Resource(name="cprojectService")
	private CProjectService projectService;
	@Resource(name="cpNodeService")
	private CProjectNodeService cpNodeService;
	
	/**
	 * 显示项目活动信息
	 * @return
	 */
	@RequestMapping("toEventInfo")
	public ModelAndView toEventInfo(){
		ModelAndView modelAndView = getModelAndView();
		PageData pageData = getPageData();
		try {
			pageData = cpEventService.findEventByParam(pageData);
			if(getUser().getNUMBER().equals(pageData.getString("EMP_CODE"))){
				pageData.put("hasRight", true);
			}
			modelAndView.addObject("event", pageData);
			
			List<PageData> relates = cpEventService.findRelateByEvent(pageData);
			modelAndView.addObject("relates", relates);
			
			List<PageData> splits = cpEventService.findAllSplit(pageData.get("ID"));
			modelAndView.addObject("splits", splits);
		} catch (Exception e) {
			e.printStackTrace();
		}
		modelAndView.setViewName("project/project_event_info");
		return modelAndView;
	}
	
	/**
	 * 编辑项目活动信息
	 * @return
	 */
	@RequestMapping("toEventEdit")
	public ModelAndView toEventEdit(){
		ModelAndView modelAndView = getModelAndView();
		PageData pageData = getPageData();
		modelAndView.addObject("param", pageData);
		
		try {
			//列出所有部门
//			List<PageData> deptList = deptService.listWithAuth(getUser());
			List<PageData> deptList = deptService.listAll(new PageData());
			JSONArray arr = JSONArray.fromObject(deptList);
			modelAndView.addObject("deptTreeNodes", arr.toString());
			
			PageData event = cpEventService.findEventByParam(pageData);
			modelAndView.addObject("event", event);
			
			List<PageData> emps = employeeService.findEmpByDept(
					String.valueOf(pageData.get("deptId")));
			modelAndView.addObject("emps", emps);
		} catch (Exception e) {
			e.printStackTrace();
		}
		modelAndView.setViewName("project/project_event_edit");
		return modelAndView;
	}
	
	/**
	 * 添加项目节点信息
	 * @return
	 */
	@RequestMapping("toEventAdd")
	public ModelAndView toEventAdd(){
		ModelAndView modelAndView = getModelAndView();
		PageData pageData = getPageData();
		PageData result = new PageData();
		
		try {
			//获取节点默认信息
			int pid = Integer.valueOf(pageData.getString("ID"));
			PageData parentNode = cpNodeService.findNodeByParam(pageData);
			result.put("C_PROJECT_NODE_ID", pid);
			result.put("NODE_TARGET", parentNode.getString("NODE_TARGET"));
			result.put("C_PROJECT_CODE", parentNode.get("C_PROJECT_CODE"));
			result.put("PROJECT_NAME", parentNode.get("PROJECT_NAME"));
			modelAndView.addObject("event", result);
			
			//列出所有部门
//			List<PageData> deptList = deptService.listWithAuth(getUser());
			List<PageData> deptList = deptService.listAll(new PageData());
			JSONArray arr = JSONArray.fromObject(deptList);
			modelAndView.addObject("deptTreeNodes", arr.toString());
		} catch (Exception e) {
			e.printStackTrace();
		}
		modelAndView.setViewName("project/project_event_edit");
		return modelAndView;
	}
	
	/**
	 * 保存项目活动信息
	 * @return
	 */
	@RequestMapping("saveEvent")
	public String saveEvent(){
		PageData pageData = getPageData();
		String id = pageData.getString("ID");
		String msg = "";
		try {
			//成本默认值为0
			pageData.put("COST", 0);

			if(id == null || id.equals("")){
				savePage(pageData);
				pageData.put("STATUS", Const.SYS_STATUS_YW_YSX);
				cpEventService.saveEvent(pageData);
				userlogService.logInfo(new UserLog(getUser().getUSER_ID(), LogType.add, 
						"创新项目活动", "目标：" + pageData.getString("NAME")));
				msg = "add";
			}else{
				updatePage(pageData);
				cpEventService.updateEvent(pageData);
				userlogService.logInfo(new UserLog(getUser().getUSER_ID(),LogType.update, 
						"创新项目活动", "目标："+pageData.getString("NAME")));
				msg = "update";
			}
			EndPointServer.sendMessage(getUser().getNAME(), pageData.getString("EMP_CODE"), TaskType.cprojectEvent);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return "redirect:toEventInfo.do?msg="+ msg +"&ID=" + pageData.getString("ID");
	}
	
	/**
	 * 跳转分解页面
	 * @return
	 */
	@RequestMapping("toEventSplit")
	public ModelAndView toEventSplit(){
		ModelAndView modelAndView = getModelAndView();
		PageData pageData = getPageData();
		try {
			Object id = pageData.get("ID");
			pageData = cpEventService.findEventByParam(pageData);
			List<PageData> splits = cpEventService.findAllSplit(id);
			modelAndView.addObject("splits", splits);
			modelAndView.addObject("countSum", pageData.get("COST"));
			modelAndView.addObject("ID", id);
		} catch (Exception e) {
			e.printStackTrace();
		}
		modelAndView.setViewName("project/project_event_split");
		return modelAndView;
	}
	
	/**
	 * 项目活动分解
	 * @return
	 */
	@RequestMapping("split")
	@SuppressWarnings("unchecked")
	public String split(){
		
		PageData pageData = getPageData();
		List<PageData> addList = new ArrayList<>();
		List<PageData> updateList = new ArrayList<>();
		List<String> removeList = new ArrayList<>();
		
		//删除的分解项
		String[] removeArray = pageData.getString("deleteIds").split(",");
		for(int i = 0; i < removeArray.length; i++){
			removeList.add(removeArray[i]);
		}
		
		//新增和更新的分解项
		Set<String> keys = pageData.keySet();
		keys.remove("deleteIds");
		String eventId = "";
		for(int i = 0; i < pageData.getString("NAME").split(",").length; i++){
			PageData result = new PageData();
			for(String key : keys){
				String[] strs = pageData.getString(key).split(",");
				//备注列可能为空
				if(key.equals("DESCP") && i > strs.length - 1){
					result.put(key, "");
				}else{
					//新增列ID为空
					if(key.equals("ID") && i > strs.length - 1){
						result.put(key, "");
					}else{
						result.put(key, strs[i]);
					}
				}
			}
			result.put("STATUS", Const.SYS_STATUS_YW_YSX);
			eventId = result.getString("C_PROJECT_EVENT_ID");
			
			if(result.get("flag").toString().equals("add")){
				savePage(result);
				addList.add(result);
			}else if(result.get("flag").toString().equals("update")){
				updatePage(result);
				updateList.add(result);
			}
		}
		
		try {
			cpEventService.split(addList, updateList, removeList);
			userlogService.logInfo(new UserLog(getUser().getUSER_ID(), LogType.add, 
					"创新项目活动分解", "目标：" + pageData.getString("NAME")));
		} catch (Exception e) {
			e.printStackTrace();
		}
		return "redirect:toEventInfo.do?tab=split&ID=" + eventId;
	} 
	
	/**
	 * 
	 * @return
	 */
	@ResponseBody
	@RequestMapping("checkSplitDelete")
	public boolean checkSplitDelete(String id, String eventId){
		try {
			return cpEventService.checkSplitDelete(id,eventId);
		} catch (Exception e) {
			e.printStackTrace();
			return false;
		}
	}
	
	/**
	 * 跳转至活动关联页面
	 * @return
	 */
	@RequestMapping("toEventRelate")
	public ModelAndView toEventRelate(){
		ModelAndView modelAndView = new ModelAndView();
		PageData pageData = getPageData();
		try {
			PageData currentEvent = cpEventService.findEventByParam(pageData);
			modelAndView.addObject("event", currentEvent);
			
			List<PageData> relates = cpEventService.findRelateByEvent(currentEvent);
			modelAndView.addObject("relates", relates);
			
			pageData.put("code", currentEvent.getString("C_PROJECT_CODE"));
			pageData.put("eventId", currentEvent.get("ID"));
			List<PageData> allNodes = getAllNodes(pageData);
			
			//默认选中节点
			if(relates != null){
				for(PageData node: allNodes){
					for(PageData relate : relates){
						if(node.get("id").equals("event_"+relate.get("ID"))){
							node.put("checked", true);
						}
					}
				}
			}
			
			modelAndView.addObject("treeNodes", JSONArray.fromObject(allNodes).toString());
		} catch (Exception e) {
			e.printStackTrace();
		}
		modelAndView.setViewName("project/project_event_relate");
		return modelAndView;
	}
	
	@RequestMapping("relate")
	public String relate(){
		PageData pageData = getPageData();
		try {
			cpEventService.saveRelate(pageData);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return "redirect:toEventInfo.do?msg=update&tab=relate&ID=" 
				+ pageData.getString("eventId");
	}
	
	/**
	 * 获取当前活动的相关节点
	 * @param pageData
	 * @return
	 * @throws Exception
	 */
	private List<PageData> getAllNodes(PageData pageData) throws Exception{
		List<PageData> result = new ArrayList<>();
		
		//添加项目根节点
		PageData rootNode = projectService.findByCodeForGantt(pageData);
		rootNode.put("nocheck", true);
		result.add(rootNode);
		
		//添加项目节点项
		List<PageData> nodes = cpNodeService.findNodeForGantt(pageData);
		for(PageData node : nodes){
			node.put("nocheck", true);
			node.put("isParent",true);
		}
		result.addAll(nodes);
		
		//添加项目活动项
		result.addAll(cpEventService.findEventForGantt(pageData));
		
		for(PageData item : result){
			item.put("name", item.get("text"));
		}
		
		return result;
	}
}
