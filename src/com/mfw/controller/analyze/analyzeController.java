package com.mfw.controller.analyze;

import java.io.PrintWriter;
import java.text.DecimalFormat;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletResponse;

import net.sf.json.JSONObject;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;

import com.mfw.controller.base.BaseController;
import com.mfw.service.analyze.AnalyzeService;
import com.mfw.service.bdata.CommonService;
import com.mfw.service.project.CProjectService;
import com.mfw.util.Const;
import com.mfw.util.PageData;

/**
 * Controller-经营任务时间轴
 * @author
 *
 */
@Controller
@RequestMapping(value="/analyze")
public class analyzeController extends BaseController {
	
	@Resource(name = "analyzeService")
	private AnalyzeService analyzeService;
	@Resource(name="cprojectService")
	private CProjectService projectService;
	@Resource(name="commonService")
	private CommonService commonService;
	
	DecimalFormat dft = new DecimalFormat("##0.00");
	
	/**
     * 点击年份查询对应年度经营任务
     * @throws Exception
     */
    @RequestMapping(value = "/yearTargetCodeList")
    public void yearTargetCodeList(String YEAR, HttpServletResponse response) throws Exception{
    	Map<String, Object> map = new HashMap<String, Object>();
    	
    	List<PageData> yearCodeList = analyzeService.yearTargetCodeList(YEAR);
    	
    	map.put("yearCodeList", yearCodeList);
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
     * 经营目标时间轴--年度（一级）
     * @throws Exception
     */
    @RequestMapping(value = "/yearTargetList")
    public ModelAndView yearTargetList() throws Exception{
    	ModelAndView mv = this.getModelAndView();
    	PageData pd = this.getPageData();
    	
    	//获得有数据的年份
    	List<String> yearList = analyzeService.getYearList(pd);
    	
    	//获得年度经营目标列表(默认展示当年)
    	logBefore(logger, "获得年度经营目标列表");
    	if(null == pd.get("YEAR") || "".equals(pd.get("YEAR"))){
    		Calendar cal = Calendar.getInstance();
        	String year = cal.get(Calendar.YEAR) + "";
        	pd.put("YEAR", year);
    	}
    	
    	//查询该用户数据权限部门
    	List<PageData> deptList = commonService.getSysDeptList();
    	if(null != deptList){
    		String deptCodes = "";
    		for(int i = 0; i < deptList.size(); i++){
    			deptCodes += "'" + deptList.get(i).get("DEPT_CODE").toString() + "'";
    			if(i != deptList.size() - 1){
    				deptCodes += ",";
    			}
    		}
    		
    		pd.put("deptCodes", deptCodes);
    	}
    	
    	List<PageData> yearTargetList = analyzeService.yearTargetList(pd);
    	
    	if(null != yearTargetList && yearTargetList.size() > 0){
    		String code;
    		for(int i = 0; i < yearTargetList.size(); i++){
    			code = yearTargetList.get(i).get("CODE").toString();
    			//获得年度经营目标完成比例
    			logBefore(logger, "获得年度经营目标完成比例");
    			String percent = analyzeService.getYearTargetPercent(code);
    			float yearPercent = 0;
    			if(null != percent && !"".equals(percent)){
    				yearPercent = Float.parseFloat(percent);
    			}
    			yearTargetList.get(i).put("yearPercent", dft.format(yearPercent));
    		}
    	}
    	
    	//mv.addObject("YEAR", year);
    	mv.addObject("yearList", yearList);
    	mv.addObject("yearTargetList", yearTargetList);
    	mv.setViewName("analyze/analyzeTarget");
    	
    	return mv;
    }
    
    /**
     * 经营目标时间轴--月份（一级）
     * @throws Exception
     */
    @RequestMapping(value = "/monthTaskList")
    public void monthTaskList(String yearTargetCode, HttpServletResponse response) throws Exception{
    	Map<String, Object> map = new HashMap<String, Object>();
    	
    	//查询年度经营目标下的月份
    	logBefore(logger, "查询年度经营目标下的月份");
    	List<PageData> monthTaskList = analyzeService.getMonthByYearCode(yearTargetCode);
    	
    	if(null != monthTaskList && monthTaskList.size() > 0){
    		PageData monthData = new PageData();
    		monthData.put("YEAR_TARGET_CODE", yearTargetCode);
    		
    		for(int i = 0; i < monthTaskList.size(); i++){
    			monthData.put("MONTH", monthTaskList.get(i).get("MONTH"));
    			
    			//获得月度经营目标完成比例
    			logBefore(logger, "获得月度经营目标完成比例");
    			PageData percentData = analyzeService.getMonthTargetPercent(monthData);
    			
    			float monthPercent = 0;
    			float actual = 0;
    			float plan = 0;
    			monthTaskList.get(i).put("actual", actual);
    			monthTaskList.get(i).put("plan", plan);
    			
    			if(null != percentData){
    				if(null != percentData.get("percent")){
    					monthPercent = Float.parseFloat(percentData.get("percent").toString());
    				}
    				if(null != percentData.get("actual")){
        				monthTaskList.get(i).put("actual", percentData.get("actual").toString());
        			}
        			if(null != percentData.get("plan")){
        				monthTaskList.get(i).put("plan", percentData.get("plan").toString());
        			}
    			}
    			monthTaskList.get(i).put("monthPercent", dft.format(monthPercent));
    			
    		}
    	}
    	map.put("monthList", monthTaskList);
    	map.put("yearTargetCode", yearTargetCode);
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
     * 经营目标时间轴--部门月经营目标（二级）
     * @throws Exception
     */
    @RequestMapping(value = "/monthDeptTaskList")
    public void monthDeptTaskList(String month, String yearTargetCode, HttpServletResponse response) throws Exception{
    	Map<String, Object> map = new HashMap<String, Object>();
    	PageData pd = new PageData();
    	pd.put("month", month);
    	pd.put("yearTargetCode", yearTargetCode);
    	
    	//查询月经营任务部门
    	logBefore(logger, "查询月经营任务部门");
    	List<PageData> deptList = analyzeService.getDeptByMonth(pd);
    	
    	if(null != deptList && deptList.size() > 0){
    		PageData monthData = new PageData();
    		monthData.put("MONTH", month);
    		monthData.put("YEAR_TARGET_CODE", yearTargetCode);
    		
    		for(int i = 0; i < deptList.size(); i++){
    			monthData.put("DEPT_CODE", deptList.get(i).get("DEPT_CODE"));
    			
    			//获得月度部门经营目标完成比例
    			logBefore(logger, "获得月度部门经营目标完成比例");
    			PageData percentData = analyzeService.getDeptMonthPercent(monthData);
    			
    			float deptMonthPercent = 0;
    			float actual = 0;
    			float plan = 0;
    			deptList.get(i).put("actual", actual);
    			deptList.get(i).put("plan", plan);
    			
    			if(null != percentData){
    				if(null != percentData.get("percent")){
    					deptMonthPercent = Float.parseFloat(percentData.get("percent").toString());
    				}
    				if(null != percentData.get("actual")){
    					deptList.get(i).put("actual", percentData.get("actual").toString());
        			}
        			if(null != percentData.get("plan")){
        				deptList.get(i).put("plan", percentData.get("plan").toString());
        			}
    			}
    			deptList.get(i).put("deptMonthPercent", dft.format(deptMonthPercent));
    		}
    	}
    	map.put("deptList", deptList);
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
     * 经营目标时间轴--部门周经营目标（二级）
     * @throws Exception
     */
    @RequestMapping(value = "/weekDeptTaskList")
    public void weekDeptTaskList(String yearTargetCode, String month, String deptCode, 
    							HttpServletResponse response) throws Exception{
    	Map<String, Object> map = new HashMap<String, Object>();
    	PageData pd = new PageData();
    	pd.put("YEAR_TARGET_CODE", yearTargetCode);
    	pd.put("MONTH", month);
    	pd.put("DEPT_CODE", deptCode);
    	
    	//查询部门周经营任务
    	logBefore(logger, "查询部门周经营任务");
    	List<PageData> weekList = analyzeService.getWeekByMonth(pd);
    	
    	if(null != weekList && weekList.size() > 0){
    		PageData weekData = new PageData();
    		weekData.put("MONTH", month);
    		weekData.put("YEAR_TARGET_CODE", yearTargetCode);
    		weekData.put("DEPT_CODE", deptCode);
    		
    		for(int i = 0; i < weekList.size(); i++){
    			weekData.put("WEEK", weekList.get(i).get("WEEK"));
    			
    			//获得部门周经营目标完成比例
    			logBefore(logger, "获得部门周经营目标完成比例");
    			PageData percentData = analyzeService.getDeptWeekPercent(weekData);
    			
    			float deptWeekPercent = 0;
    			float actual = 0;
    			float plan = 0;
    			weekList.get(i).put("actual", actual);
    			weekList.get(i).put("plan", plan);
    			
    			if(null != percentData){
    				if(null != percentData.get("percent")){
    					deptWeekPercent = Float.parseFloat(percentData.get("percent").toString());
    				}
    				if(null != percentData.get("actual")){
    					weekList.get(i).put("actual", percentData.get("actual").toString());
        			}
        			if(null != percentData.get("plan")){
        				weekList.get(i).put("plan", percentData.get("plan").toString());
        			}
    					
    			}
    			weekList.get(i).put("deptWeekPercent", dft.format(deptWeekPercent));
    			
    			//将日期转换为String格式
    			SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
    			if(null != weekList.get(i).get("WEEK_START_DATE")){
    				String WEEK_START_DATE = sdf.format(weekList.get(i).get("WEEK_START_DATE"));
    				weekList.get(i).put("WEEK_START_DATE", WEEK_START_DATE);
    			}
				if(null != weekList.get(i).get("WEEK_END_DATE")){
					String WEEK_END_DATE = sdf.format(weekList.get(i).get("WEEK_END_DATE"));
	    			weekList.get(i).put("WEEK_END_DATE", WEEK_END_DATE);
				}
				
    		}
    	}
    	map.put("weekList", weekList);
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
     * 经营目标时间轴--员工周经营目标（三级）
     * @throws Exception
     */
    @RequestMapping(value = "/weekEmpTaskList")
    public void weekEmpTaskList(String yearTargetCode, String month, String deptCode, String week, 
    							HttpServletResponse response) throws Exception{
    	Map<String, Object> map = new HashMap<String, Object>();
    	PageData pd = new PageData();
    	pd.put("YEAR_TARGET_CODE", yearTargetCode);
    	pd.put("MONTH", month);
    	pd.put("DEPT_CODE", deptCode);
    	pd.put("WEEK", week);
    	
    	//查询部门周经营任务
    	logBefore(logger, "查询部门周经营任务");
    	List<PageData> empWeekList = analyzeService.getEmpWeek(pd);
    	//查询任务所对应进度
    	List<PageData> empWeekList2 = analyzeService.getEmpWeekPercent(pd);
    	
    	if(null != empWeekList && 0 < empWeekList.size()){
    		float percent = 0;
    		for(int i = 0; i < empWeekList.size(); i++){
    			if(null != empWeekList2 && 0 < empWeekList2.size()){
    				if(null != empWeekList2.get(i).get("percent")){
    					percent = Float.parseFloat(empWeekList2.get(i).get("percent").toString());
    					empWeekList.get(i).put("percent", dft.format(percent));
    					empWeekList.get(i).put("actual", empWeekList2.get(i).get("actual").toString());
    					empWeekList.get(i).put("plan", empWeekList2.get(i).get("plan").toString());
    				}
    			}else{
    				empWeekList.get(i).put("actual", 0);
    				empWeekList.get(i).put("plan", 0);
    			}
    		}
    	}
    	
    	map.put("empWeekList", empWeekList);
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
     * 点击年份查询对应创新项目
     * @throws Exception
     */
    @RequestMapping(value = "/projectList")
    public void projectList(String YEAR, HttpServletResponse response) throws Exception{
    	Map<String, Object> map = new HashMap<String, Object>();
    	
    	List<PageData> projectList = analyzeService.getProjectList(YEAR);
    	
    	map.put("projectList", projectList);
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
     * 创新项目时间轴第一层节点
     * @throws Exception
     */
    @RequestMapping(value = "/firstNodeList")
    public ModelAndView firstNodeList() throws Exception{
    	ModelAndView mv = this.getModelAndView();
    	PageData pd = this.getPageData();
    	
    	if(null != pd.get("CODE") && !"".equals(pd.get("CODE"))){
    		//用户选择了查询的创新项目，将层级赋值为1
    		pd.put("LEVEL", 1);
    	}
    	
    	//获得有数据的年份
    	List<String> yearList = analyzeService.getProjectYearList(pd);
    	List<PageData> projectList = analyzeService.getProjectList(yearList.get(0));
    	PageData proPd =  (PageData)projectList.get(0);
    	String code = proPd.get("CODE").toString();
    	pd.put("YEAR", yearList.get(0));
    	pd.put("CODE", code);
    	//查询第一层节点
    	List<PageData> nodeList = analyzeService.firstNodeList(pd);
    	if(null != nodeList && 0 < nodeList.size()){
    		for(int i = 0; i < nodeList.size(); i++){
        		float nodePercent = getNodePercent(nodeList.get(i).get("ID").toString());
        		nodeList.get(i).put("nodePercent", dft.format(nodePercent));
        	}
    	}
    	
    	mv.addObject("yearList", yearList);
    	mv.addObject("nodeList", nodeList);
    	mv.setViewName("analyze/analyzeProject");
    	
    	return mv;
    }
    
    /**
     * 根据节点获得所属活动列表
     * @throws Exception
     */
    @RequestMapping(value = "/getEventList")
    public void getEventList(String NODE_ID, HttpServletResponse response) throws Exception{
    	Map<String, Object> map = new HashMap<String, Object>();
    	
    	//查询活动列表
    	List<PageData> eventList = analyzeService.getEventList(NODE_ID);
    	
    	if(null != eventList && eventList.size() > 0){
    		for(int i = 0; i < eventList.size(); i++){
    			//获得活动完成比例
    			String percent = analyzeService.getEventPercent(eventList.get(i).get("ID"));
    			
    			float eventPercent = 0;
    			if(null != percent && !"".equals(percent)){
    				eventPercent = Float.parseFloat(percent);
    			}
    			eventList.get(i).put("eventPercent", eventPercent);
    			
    			//将日期转换为String格式
    			SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");  
    			if(null != eventList.get(i).get("START_DATE")){
    				String START_DATE = sdf.format(eventList.get(i).get("START_DATE"));
    				eventList.get(i).put("START_DATE", START_DATE);
    			}
				if(null != eventList.get(i).get("END_DATE")){
					String END_DATE = sdf.format(eventList.get(i).get("END_DATE"));
					eventList.get(i).put("END_DATE", END_DATE);
				}
				
    		}
    	}
    	map.put("eventList", eventList);
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
     * 根据父节点ID获得子节点
     * @throws Exception
     */
    @RequestMapping(value = "/getChildNode")
    public void getChildNode(String PARENT_ID, HttpServletResponse response) throws Exception{
    	Map<String, Object> map = new HashMap<String, Object>();
    	
    	//根据父节点ID获得子节点
    	List<PageData> childNodeList = analyzeService.getChildNode(PARENT_ID);
    	
    	for(int i = 0; i < childNodeList.size(); i++){
			float nodePercent = getNodePercent(childNodeList.get(i).get("ID").toString());
    		childNodeList.get(i).put("nodePercent", dft.format(nodePercent));
    		
    		//将计划完成日期转换为String格式
    		if(null != childNodeList.get(i).get("PLAN_DATE")){
    			SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
    			String PLAN_DATE = sdf.format(childNodeList.get(i).get("PLAN_DATE"));
    			childNodeList.get(i).put("PLAN_DATE", PLAN_DATE);
    		}
    	}
    		
    	map.put("childNodeList", childNodeList);
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
     * 创新项目节点进度
     * @throws Exception
     */
    @RequestMapping(value = "/getNodePercent")
    public float getNodePercent(String nodeId) throws Exception{
    	float nodePercent = 0;
    	List<PageData> childList;
    	
    	childList = getChildNodeByParent(nodeId);
    	if(null == childList || 0 == childList.size()){
    		String percent = analyzeService.getEndNodePercent(nodeId);
    		if(null != percent && percent.length() > 0){
    			nodePercent = Float.parseFloat(percent);
    		}
    		return nodePercent;
    	}
    	
    	for(int i = 0; i < childList.size(); i++){
    		//获得该节点下所有活动权重之和
        	int eventWeight = 0;
        	List<PageData> eventList = analyzeService.getEventList(nodeId);
        	for(int x = 0; x < eventList.size(); x++){
        		if(null != eventList.get(x).get("WEIGHT")){
        			int weight =Integer.valueOf(eventList.get(x).get("WEIGHT")+"");
            		eventWeight = eventWeight + weight;
        		}
        	}
        	
        	//获得所有子节点权重之和
        	int nodeWeight = 0;
        	List<String>childIdList = getAllChildNode(nodeId);
        	for(int y = 0; y < childIdList.size(); y++){
        		PageData nodeData = analyzeService.getNodeWeightById(childIdList.get(y));
        		if(null != nodeData.get("WEIGHT")){
        			int weight =Integer.valueOf(nodeData.get("WEIGHT")+"");
            		nodeWeight = nodeWeight + weight;
        		}
        		
        	}
        	
        	//获得活动进度之和
        	float eventSum = 0;
        	String eventAllSum = analyzeService.getSumEvent(nodeId);
        	if(null != eventAllSum){
        		eventSum = Float.parseFloat(eventAllSum);
        	}
        	
        	if(eventWeight + nodeWeight > 0){
        		nodePercent = (eventSum + nodePercent)/(eventWeight + nodeWeight);
        	}
        	
    	}
    	
    	for(int i = 0; i < childList.size(); i++){
    		childList = getChildNodeByParent(childList.get(i).get("ID").toString());
    		if(null != childList && 0 < childList.size()){
    			getNodePercent(childList.get(i).get("ID").toString());
    		}
    	}
    	
    	return nodePercent;
    }
    
    /**
     * 获得父节点下所有子节点
     * @throws Exception
     */
    @RequestMapping(value = "/getAllChildNode")
    public List<String> getAllChildNode(String nodeId) throws Exception{
    	List<String> nodeIdList = new ArrayList<String>();
    	List<PageData> childList;
    	
    	childList = getChildNodeByParent(nodeId);
    	if(null == childList || 0 == childList.size()){
    		return nodeIdList;
    	}
    	
    	//父节点有子节点，将子节点ID添加
    	for(int i = 0; i < childList.size(); i++){
    		nodeIdList.add(childList.get(i).get("ID").toString());
    	}
    	
    	for(int i = 0; i < childList.size(); i++ ){
    		childList = getChildNodeByParent(childList.get(i).get("ID").toString());
    	}
    	
    	return nodeIdList;
    }
    
    /**
     * 根据父节点查询子节点
     * @throws Exception
     */
    @RequestMapping(value = "/getChildNodeByParent")
    public List<PageData> getChildNodeByParent(String nodeId) throws Exception{
    	
    	List<PageData> childList = analyzeService.getChildNode(nodeId);
    	
    	return childList;
    }
    
    /**
     * 项目甘特图
     * @return
     */
    @RequestMapping(value = "gantt")
    public ModelAndView gantt(){
    	ModelAndView modelAndView = getModelAndView();
    	try {
    		PageData pageData = new PageData();
    		pageData.put("STATUS", Const.SYS_STATUS_YW_YSX);
			modelAndView.addObject("projects", projectService.findAll(pageData));
		} catch (Exception e) {
			e.printStackTrace();
		}
    	modelAndView.setViewName("analyze/gantt");
    	return modelAndView;
    }
    
}
