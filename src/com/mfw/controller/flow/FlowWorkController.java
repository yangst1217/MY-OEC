package com.mfw.controller.flow;

import java.io.PrintWriter;
import java.net.URLDecoder;
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
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import com.google.gson.Gson;
import com.mfw.controller.base.BaseController;
import com.mfw.entity.GridPage;
import com.mfw.entity.Page;
import com.mfw.entity.system.User;
import com.mfw.service.bdata.DeptService;
import com.mfw.service.flow.FlowWorkService;
import com.mfw.util.Const;
import com.mfw.util.EndPointServer;
import com.mfw.util.PageData;
import com.mfw.util.TaskType;
import com.mfw.util.Tools;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

/**
 * Controller-流程工作管理
 * @author 韩佳良
 *
 */
@Controller
@RequestMapping(value="/flowWork")
public class FlowWorkController extends BaseController {
	
	@Resource(name="flowWorkService")
	private FlowWorkService flowWorkService;
	@Resource(name="deptService")
	private DeptService deptService;
	
	@ResponseBody
	@RequestMapping(value = "/flowWorkList")
	public GridPage employeeList(Page page, HttpServletRequest request){
		List<PageData> flowWorkList = new ArrayList<>();
		Subject currentUser = SecurityUtils.getSubject();
		Session session = currentUser.getSession();
		try {
			convertPage(page, request);
			PageData pageData = page.getPd();
			String str = pageData.getString("NAME");
			String strfn = pageData.getString("FLOW_NAME");
			if(null != str){
				String name = URLDecoder.decode(str, "utf-8");
				pageData.put("NAME", name);
			}
			if(null != strfn){
				String FLOW_NAME = URLDecoder.decode(strfn, "utf-8");
				pageData.put("FLOW_NAME", FLOW_NAME);
			}
			if(null != pageData.getString("FLOW_MODEL_NAME")){
				String FLOW_MODEL_NAME = URLDecoder.decode(pageData.getString("FLOW_MODEL_NAME"),"utf-8");
				pageData.put("FLOW_MODEL_NAME", FLOW_MODEL_NAME);
			}
			if("1".equals(pageData.getString("flg"))){
				User user = (User)session.getAttribute(Const.SESSION_USER);
				pageData.put("EMP_CODE", user.getNUMBER());
				page.setPd(pageData);
				flowWorkList = flowWorkService.listAll(page); 
			}else{
				pageData.put("CREATE_USER", session.getAttribute(Const.SESSION_USERNAME));
				page.setPd(pageData);
				flowWorkList = flowWorkService.listAll(page); 
			}
			
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
			e.printStackTrace();
		}
		return new GridPage(flowWorkList, page);
	}
	
	/**
	 * 新增页面
	 */
	@RequestMapping(value = "/toAdd")
	public ModelAndView toAdd(Page page) {
		ModelAndView mv = this.getModelAndView();
		Subject currentUser = SecurityUtils.getSubject();
		Session session = currentUser.getSession();
		List<PageData> nodeList = new ArrayList<>();
		List<PageData> temList = new ArrayList<>();
		PageData pd = new PageData();
		try {
			pd = this.getPageData();
			User user = (User)session.getAttribute(Const.SESSION_USER);
			pd.put("EMP_CODE", user.getNUMBER());
			pd.put("DEPT_ID", user.getDeptId().toString());
			pd.put("STATUS", Const.SYS_STATUS_YW_YJS);
			List<PageData> tempList = flowWorkService.temList(pd);
			for(PageData tl : tempList){
				nodeList = flowWorkService.nodeList(tl);
				if(nodeList.size() != 0){
					temList.add(tl);
				}
			}
			List<PageData> empList = flowWorkService.empList(pd);
			List<PageData> parentList = flowWorkService.parentList(pd);
			
			//获取部门列表
			List<PageData> deptList = deptService.listAlln();
			JSONArray arr = JSONArray.fromObject(deptList);
			mv.addObject("depts", arr.toString());

			mv.setViewName("flow/flow_work_add");
			mv.addObject("temList", temList);
			mv.addObject("empList", empList);
			mv.addObject("parentList", parentList);
			mv.addObject("pd", pd);
		} catch (Exception e) {
			logger.error(e.toString(), e);
		}
		return mv;
	}
	
	/**
     * 根据节点获得所属活动列表
     * @throws Exception
     */
    @RequestMapping(value = "/getInfo")
    public void getInfo(HttpServletResponse response) throws Exception{
    	Map<String, Object> map = new HashMap<String, Object>();
    	PageData pd = new PageData();
    	List<PageData> nodeList = new ArrayList<>();
    	pd = this.getPageData();
    	
//    	pd = flowWorkService.findById(pd);
    	pd = flowWorkService.findFlowModelById(pd);
    	if(null != pd){
    		pd.put("CREATE_TIME", pd.get("CREATE_TIME").toString());
        	nodeList = flowWorkService.nodeList(pd);
    	}
    	
    	map.put("pd", pd);
    	map.put("nodeList", nodeList);
		JSONObject jo = JSONObject.fromObject(map);
		String json = jo.toString();
    	
		response.setCharacterEncoding("UTF-8");
		response.setContentType("text/html");
		PrintWriter out = response.getWriter();
		out.write(json);
		out.flush();
		out.close();
    }
    
    @ResponseBody
	@RequestMapping(value = "/flowList")
	public GridPage flowList(Page page, HttpServletRequest request){
		List<PageData> flowList = new ArrayList<>();
		try {
			convertPage(page, request);
			PageData pageData = page.getPd();
			if(pageData.get("ID") != null){
				
				flowList = flowWorkService.flowList(page); 
			}
			
			
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
			e.printStackTrace();
		}
		return new GridPage(flowList, page);
	}
    
    @RequestMapping(value = "/save")
    public ModelAndView save(HttpServletRequest request) throws Exception{
    	ModelAndView mv = this.getModelAndView();
		PageData pd = new PageData();
		PageData pdwn = new PageData();
		PageData historyPd = new PageData();
		Subject currentUser = SecurityUtils.getSubject();
		Session session = currentUser.getSession();
		List<PageData> nodeList = new ArrayList<>();
		try {
			pd = this.getPageData();
			String[] deptID = pd.getString("DEPT_ID").split(",");
			String[] empCode = pd.getString("EMP_CODE").split(",");
			String[] posId = pd.getString("POSITION_ID").split(",");
			pd.put("CREATE_USER", session.getAttribute(Const.SESSION_USERNAME));
			pd.put("CREATE_TIME", Tools.date2Str(new Date()));	
			User user = (User)session.getAttribute(Const.SESSION_USER);
			pd.put("DEPT_ID", user.getDeptId());
			String deptName = flowWorkService.findNameByID(pd);
			pd.put("DEPT_NAME", deptName);
			if(pd.get("PARENT_NODE").equals("")){
				pd.put("PARENT_NODE", null);
			}
			pd.put("FOCUS_EMP", pd.get("FOCUS_EMP[]"));
			
			String flowModelCode = flowWorkService.findCodeByID(pd);
			String format = "yyyyMMddHHmmss";
			SimpleDateFormat sdf = new SimpleDateFormat(format);
			String dateTime = sdf.format(new Date());
			String flowCode = flowModelCode+dateTime;
			pd.put("FLOW_CODE", flowCode);
			flowWorkService.save(pd);
			PageData pdw = flowWorkService.findForId(pd);
			nodeList = flowWorkService.nodeList(pd);
			int index = Integer.valueOf(pd.getString("INDEX"));
			
			for(int i=index;i<nodeList.size();i++){
				PageData pdn = new PageData();
				pdn.put("FLOW_ID", pdw.get("max(ID)"));
				pdn.put("NODE_LEVEL", nodeList.get(i).get("NODE_LEVEL"));
				pdn.put("NODE_NAME", nodeList.get(i).get("NODE_NAME"));
				pdn.put("TIME_INTERVAL", nodeList.get(i).get("TIME_INTERVAL"));
				pdn.put("COST_TIME", nodeList.get(i).get("COST_TIME"));
				if("undefined".equals(deptID[i]) ){
					pdn.put("DEPT_ID", null);
				}else{
					pdn.put("DEPT_ID", deptID[i]);
				}
				if("请选择...".equals(posId[i])){
					pdn.put("POSITION_ID", null);
				}else{
					pdn.put("POSITION_ID", posId[i]);
				}
				if("请选择...".equals(empCode[i])){
					pdn.put("EMP_CODE", null);
				}else{
					pdn.put("EMP_CODE", empCode[i]);
				}
				pdn.put("SUBFLOW_ID", nodeList.get(i).get("SUBFLOW_ID"));
				if(i == index){
					pdn.put("STATUS", Const.SYS_STATUS_YW_YSX);
				}else{
					pdn.put("STATUS", Const.SYS_STATUS_YW_DSX);
				}
				pdn.put("REMARKS", nodeList.get(i).get("REMARKS"));
				pdn.put("CREATE_USER", session.getAttribute(Const.SESSION_USERNAME));
				pdn.put("CREATE_TIME", Tools.date2Str(new Date()));
				flowWorkService.saveNode(pdn);
				if(i == index){
					pdwn = flowWorkService.findForNodeId(pd);
					EndPointServer.sendMessage(getUser().getNAME(), empCode[i], TaskType.flow);
				}
				
			}
			historyPd.put("FLOW_ID", pdw.get("max(ID)"));
			historyPd.put("OPERA_TIME", Tools.date2Str(new Date()));
			historyPd.put("OPERATOR", user.getNAME());
			historyPd.put("NEXT_NODE", pdwn.get("max(ID)"));
			historyPd.put("OPERA_TYPE", Const.FLOW_OPERA_TYPE_FQ);
			historyPd.put("NEXT_NODE_EMP_CODE", empCode[0]);
			flowWorkService.saveFlowWorkHistory(historyPd);
			//从日清工作台发起子流程
			if(null!=pd.get("fromPage") && !"".equals(pd.getString("fromPage"))){
				PageData reqPd = new PageData();
				reqPd.put("empCode", user.getNUMBER());
				reqPd.put("loadType", "F");
				mv.addObject("pd", reqPd);
				mv.setViewName("task/listTask");
				return mv;
			}
			mv.setViewName("flow/flow_work_list");
			mv.addObject("success", "success");
		} catch (Exception e) {
			logger.error(e.toString(), e);
		}
		return mv;
    }
	
    /**
     * 根据流程ID获取流程明细，包括节点明细、流程历史等
     * @param flowId
     * @return
     */
    @RequestMapping("showDetail")
    public ModelAndView showDetail(String ID){
    	ModelAndView modelAndView = new ModelAndView();
    	try {
    		Gson gson = new Gson();
			PageData flowWork = flowWorkService.findById(ID);
			modelAndView.addObject("flowWork", flowWork);
			
			modelAndView.addObject("flowNodes", flowWorkService.findNodesById(ID));
			modelAndView.addObject("nodesGson", gson.toJson(flowWorkService.findNodesById(ID)));
			
			List<PageData> flowWorkHistory = flowWorkService.findHistoryById(ID);
			for (PageData pd:flowWorkHistory) {
				String score = "0";
				if(pd.get("SCORE")!=null){
					if(!pd.getString("SCORE").equals("0")){
						 score = pd.getString("SCORE");
						 score = score.substring(1);
					}
				}
				pd.put("SCORE", score);
				if(pd.get("FILE_ID")!=null&&!pd.get("FILE_ID").toString().equals("")){
					String fileId = pd.getString("FILE_ID");
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
					pd.put("fileNameStr", fileNameStr);
					pd.put("fileList", fileList);
				}else{
					pd.put("fileList", null);
					pd.put("fileNameStr", "");
				}
			}
			modelAndView.addObject("flowHistory", flowWorkHistory);
		} catch (Exception e) {
			e.printStackTrace();
		}
    	
    	modelAndView.setViewName("flow/flow_work_detail");
    	return modelAndView;
    }
    
    /**
     * 查询节点上的岗位职责明细
     */
    @RequestMapping("showNodeDetail")
    public ModelAndView showNodeDetail(String workNodeId){
    	ModelAndView mv = new ModelAndView();
    	try {
			List<PageData> dutyList = flowWorkService.findDutyDetailByNodeId(workNodeId);
			PageData pd = flowWorkService.findFileIdByNodeId(workNodeId);
			String fileNameStr = "";
				if(pd.get("FILE_ID")!=null&&!pd.get("FILE_ID").toString().equals("")){
					String fileId = pd.getString("FILE_ID");
					String[] arr = fileId.split(",");
					List<PageData> fileList = flowWorkService.findFileList(arr);
					if(fileList!=null){
						for (PageData filePd:fileList) {
							if(filePd.get("FILENAME_SERVER")!=null){
								fileNameStr+=","+filePd.getString("FILENAME_SERVER");
							}
						}
						if(fileNameStr!=""){
							fileNameStr=fileNameStr.substring(1);
						}
					}
				}
			mv.addObject("fileNameStr", fileNameStr);
			mv.addObject("dutyList", dutyList);
		} catch (Exception e) {
			logger.error("查询节点上的岗位职责明细出错", e);
		}
    	mv.setViewName("flow/flow_work_node_detail");
    	return mv;
    }
}
