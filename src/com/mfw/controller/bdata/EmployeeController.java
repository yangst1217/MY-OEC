package com.mfw.controller.bdata;

import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.GregorianCalendar;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.lang.time.DateUtils;
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
import com.mfw.service.bdata.CommonService;
import com.mfw.service.bdata.DeptService;
import com.mfw.service.bdata.EmployeeService;
import com.mfw.service.bdata.KpiFilesService;
import com.mfw.service.bdata.KpiIndexService;
import com.mfw.service.bdata.KpiModelLineService;
import com.mfw.service.bdata.KpiModelService;
import com.mfw.service.bdata.PositionLevelService;
import com.mfw.service.system.user.UserService;
import com.mfw.util.Const;
import com.mfw.util.FileDownload;
import com.mfw.util.FileUpload;
import com.mfw.util.ObjectExcelRead;
import com.mfw.util.ObjectExcelView;
import com.mfw.util.PageData;
import com.mfw.util.PathUtil;
import com.mfw.util.Tools;
import com.mfw.util.UserUtils;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

/**
 * Controller-员工管理
 * 创建日期：2015年12月11日
 * 修改日期：
 */
@Controller
@RequestMapping(value = "/employee")
public class EmployeeController extends BaseController {
	
	@Resource(name = "employeeService")
	private EmployeeService employeeService;
	@Resource(name="kpiModelService")
	private KpiModelService kpiModelService;
	@Resource(name="kpiModelLineService")
	private KpiModelLineService kpiModelLineService;
	@Resource(name="kpiFilesService")
	private KpiFilesService kpiFilesService;
	@Resource(name="kpiIndexService")
	private KpiIndexService kpiIndexService;
	@Resource(name="deptService")
	private DeptService deptService;
	@Resource(name="positionLevelService")
	private PositionLevelService positionLevelService;//岗位
	@Resource(name="commonService")
	private CommonService commonService;
	@Resource(name="userService")
	private UserService userService;
	
	/**
	 * 员工列表
	 */
	@RequestMapping(value = "/list")
	public ModelAndView list(Page page) {
		logBefore(logger, "查询Employee列表");
		ModelAndView mv = this.getModelAndView();
		try {
			PageData pd = new PageData();
			pd = this.getPageData();
			page.setPd(pd);
			
			List<PageData> varList = deptService.listAll(pd); //列出Dept列表
			for(int i=0;i<varList.size();i++){
				varList.get(i).put("eNum", getENum(varList.get(i)));
				if(Integer.valueOf(varList.get(i).get("ENABLED").toString())==0){
					varList.get(i).put("DEPT_NAME", varList.get(i).get("DEPT_NAME").toString()+"(未启用)");
				}
			}
			
			mv.addObject("varList", varList);
			mv.addObject("page", page);
			mv.setViewName("bdata/employee/employee_list");
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
			PageData pageData = page.getPd();
			
			if(null == pageData.get("ID") || pageData.getString("ID").isEmpty()){
				empList = employeeService.listPageEmp(page);
			}else{
				List<String> ids = deptService.finIdsByPid(pageData.get("ID").toString());
				ids.add(pageData.get("ID").toString());
				
				pageData.put("ids", ids);
				page.setPd(pageData);
				empList = employeeService.listPageEmp(page);
			}
			
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
			e.printStackTrace();
		}
		return new GridPage(empList, page);
	}
	
	/**
	 * 员工列表检索
	 */
	@RequestMapping(value = "/listSearch")
	public ModelAndView listSearch(Page page) {
		logBefore(logger, "查询Employee列表");
		ModelAndView mv = this.getModelAndView();
		try {
			PageData pd = new PageData();
			pd = this.getPageData();
			page.setPd(pd);
			//查询employee列表
			List<PageData> empList = employeeService.listAll(pd);
			//List<PageData> empList = employeeService.listPageEmp(page);
			//根据ID获取
			pd = employeeService.findById(pd);
			
			mv.addObject("empList", empList);
			mv.addObject("page", page);
			mv.setViewName("bdata/employee/employee_list");
		} catch (Exception e) {
			logger.error(e.toString(), e);
		}
		
		return mv;
	}
	
	/**
	 * 订单成员组成信息员工检索
	 */
	@RequestMapping(value = "/labourSearch")
	public ModelAndView labourSearch(Page page, String orderId) {
		ModelAndView mv = this.getModelAndView();
		try {
			PageData pd = new PageData();
			pd = this.getPageData();
			page.setPd(pd);
			
			//查询已经添加的员工
			/*logBefore(logger, "查询已经添加的员工");
			List<String> labourList = projectOrderLabourService.listEmpId(orderId);
			Map<String,Object> map = new HashMap<String,Object>();
			map.put("labourList", labourList);
			map.put("pd", pd);*/
			
			//查询未添加的employee列表
			logBefore(logger, "查询未添加的employee列表");
			List<PageData> empList = employeeService.listAllLabour(pd);
			
			//根据ID获取
			pd = employeeService.findById(pd);
			//查询分成方式列表
			List<PageData> shareTypeList = commonService.typeListByBm("FCFS");
			logBefore(logger, "查询已添加部门列表");
			List<PageData> deptList = deptService.findScaleDept(orderId);
			
			mv.addObject("empList", empList);
			mv.addObject("deptList", deptList);
			mv.addObject("shareTypeList", shareTypeList);
			mv.addObject("orderId", orderId);
			mv.addObject("page", page);
			mv.setViewName("order/projectOrderLabourAdd");
		} catch (Exception e) {
			logger.error(e.toString(), e);
		}
		
		return mv;
	}
	
	/**
	 * 新增员工页面跳转
	 */
	@RequestMapping(value = "/goAddEmp")
	public ModelAndView goAdd() throws Exception {
		logBefore(logger, "新增Employee页面跳转");
		ModelAndView mv = this.getModelAndView();
		try {
			PageData pd = new PageData();
			pd = this.getPageData();
			List<PageData> kpiModelList = kpiModelService.listAllEnable(pd);
			List<PageData> deptList = deptService.listAll(pd);
			JSONArray arr = JSONArray.fromObject(deptList);

			mv.addObject("msg", "save");
			mv.addObject("pd", pd);
			mv.addObject("kpiModelList", kpiModelList);
			mv.addObject("deptList", deptList);
			mv.addObject("deptTreeNodes", arr.toString());
			mv.setViewName("bdata/employee/new_edit");
			
		} catch (Exception e) {
			logger.error(e.toString(), e);
		}

		return mv;
	}
	
	/**
	 * 员工新增验证
	 */
	@RequestMapping(value = "/checkEmployee")
	public void checkEmployee(String empCode, String msg, String id, PrintWriter out){
		try{
			PageData pd = new PageData();
			pd.put("EMP_CODE", empCode);
			
			logBefore(logger, "bd_employee表新增验证");
			if(msg == "save"){	//新增
				PageData empData  = employeeService.findByCode(pd);
				//判断用户所填code是否重复
				if(null == empData){
					out.write("true");
				}else{
					out.write("false");
				}
			}else{	//修改
				pd.put("ID", id);
				//原有数据
				PageData emp = employeeService.findById(pd);
				//修改后的数据
				PageData empData  = employeeService.findByCode(pd);
				if(null != empData && empData.getString("EMP_CODE").equals(emp.getString("EMP_CODE"))){	//用户没有修改编号
					out.write("true");
				}else if(null != empData && !empData.getString("EMP_CODE").equals(emp.getString("EMP_CODE"))){//用户修改后的编号与原有编号重复
					out.write("false");
				}else if(null == empData){	//用户修改后的编号为唯一
					out.write("true");
				}
			}
			
		} catch(Exception e){
			logger.error(e.toString(), e);
		} finally{
			out.flush();
			out.close();
		}
	}
	
	/**
	 * 新增员工
	 */
	@RequestMapping(value = "/save")
	public ModelAndView save() throws Exception {
		ModelAndView mv = this.getModelAndView();
		try {
			PageData pd = new PageData();
			pd = this.getPageData();
			
			if(null != pd.get("EMP_GRADE_ID") && !"".equals(pd.getString("EMP_GRADE_ID").toString())){
				int gradeId = Integer.parseInt(pd.get("EMP_GRADE_ID") + "");
				PageData levelData = new PageData();
				levelData.put("id", gradeId);
				logBefore(logger, "查询岗位级别名称");
				levelData = positionLevelService.findById(levelData);
				pd.put("EMP_GRADE_NAME", levelData.get("GRADE_NAME"));
			}
			
			Subject currentUser = SecurityUtils.getSubject();
			Session session = currentUser.getSession();
			pd.put("CREATE_USER", session.getAttribute(Const.SESSION_USERNAME));	//创建人
			pd.put("CREATE_TIME", Tools.date2Str(new Date()));						//创建时间
			pd.put("LAST_UPDATE_USER", session.getAttribute(Const.SESSION_USERNAME));//最后修改人
			pd.put("LAST_UPDATE_TIME", Tools.date2Str(new Date()));					 //最后更改时间
			
			logBefore(logger, "新增Employee");
			employeeService.save(pd);
			
			
			
			List<PageData> deptList = deptService.listAll(pd);
			JSONArray arr = JSONArray.fromObject(deptList);
			mv.addObject("deptTreeNodes", arr.toString());
			
			mv.addObject("editFlag", "saveSucc");
			mv.setViewName("save_result");
			
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
		logBefore(logger, "删除Employee");
		PageData pd = new PageData();
		try {
			pd = this.getPageData();
			employeeService.delete(pd);
			out.write("success");
			out.close();
		} catch (Exception e) {
			logger.error(e.toString(), e);
		}
	}
	
	/**
	 * 修改员工页面跳转
	 */
	@RequestMapping(value="/goEditEmp",produces = "text/html;charset=UTF-8")
	public ModelAndView goEdit(HttpServletResponse response){
		logBefore(logger, "修改Employee页面跳转");
		ModelAndView mv = this.getModelAndView();
		PageData emp = new PageData();
		emp = this.getPageData();
		try {
			emp = employeeService.findById(emp);
			List<PageData> kpiModelList = kpiModelService.listAllEnable(emp);
			List<PageData> deptList = deptService.listAll(emp);
			JSONArray arr = JSONArray.fromObject(deptList);
			
			//查询该员工所属部门下的岗位列表
			String deptId = emp.get("EMP_DEPARTMENT_ID") + "";
			List<PageData> levelList = positionLevelService.findLevelByDeptId(deptId);
			
			mv.addObject("msg", "edit");
			mv.addObject("emp", emp);
			mv.addObject("deptList", deptList);
			mv.addObject("levelList", levelList);
			mv.addObject("kpiModelList", kpiModelList);
			mv.addObject("deptTreeNodes", arr.toString());
			mv.setViewName("bdata/employee/new_edit");
		} catch (Exception e) {
			logger.error(e.toString(), e);
		}						
		return mv;
	}
	
	/**
	 * 修改员工
	 */
	@RequestMapping(value = "/edit")
	public ModelAndView edit() throws Exception {
		logBefore(logger, "修改Employee");
		ModelAndView mv = this.getModelAndView();
		try {
			PageData pd = new PageData();
			pd = this.getPageData();
			
			if(null != pd.get("EMP_GRADE_ID") && !"".equals(pd.getString("EMP_GRADE_ID").toString())){
				int gradeId = Integer.parseInt(pd.get("EMP_GRADE_ID") + "");
				PageData levelData = new PageData();
				levelData.put("id", gradeId);
				logBefore(logger, "查询岗位级别名称");
				levelData = positionLevelService.findById(levelData);
				if(null != levelData){
					pd.put("EMP_GRADE_NAME", levelData.get("GRADE_NAME"));
				}
				
			}
			
			Subject currentUser = SecurityUtils.getSubject();
			Session session = currentUser.getSession();
			pd.put("LAST_UPDATE_USER", session.getAttribute(Const.SESSION_USERNAME));	//最后修改人
			pd.put("LAST_UPDATE_TIME", Tools.date2Str(new Date()));						//最后更改时间
			//执行修改Employee
			employeeService.edit(pd);
			
			PageData userPageData = new PageData();
			userPageData.put("NUMBER", pd.get("EMP_CODE"));
			userPageData = userService.findByUN(userPageData);
			if(userPageData != null){
				userPageData.put("DEPT_ID", pd.get("EMP_DEPARTMENT_ID"));
				userPageData.put("DEPT_NAME", pd.get("EMP_DEPARTMENT_NAME"));
				userService.editU(userPageData);
			}
			
						
			List<PageData> deptList = deptService.listAll(pd);
			JSONArray arr = JSONArray.fromObject(deptList);
			mv.addObject("deptTreeNodes", arr.toString());
			mv.addObject("editFlag", "updateSucc");
			mv.setViewName("save_result");
		} catch (Exception e) {
			logger.error(e.toString(), e);
		}

		return mv;
	}
	
	/**
	 * 点击模板列表查询
	 */
	@RequestMapping(value = "/modelDetail",produces = "text/html;charset=UTF-8")
	public void modelDetail(@RequestParam String ID, HttpServletResponse response) throws Exception {
		PageData pd = new PageData();
		Map<String, Object> map = new HashMap<String, Object>();
		try {
			pd = this.getPageData();
			pd.put("ID", ID);
			List<Object> list = new ArrayList<Object>();
			
			logBefore(logger, "点击模板列表查询");
			pd = kpiModelService.findById(pd);
			list = kpiModelLineService.listAllByModelId(ID);
			map.put("list", list);
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
	 * 获取所选部门信息
	 */
	@RequestMapping(value = "/findDeptById",produces = "text/html;charset=UTF-8")
	public void findDeptById(@RequestParam String ID, HttpServletResponse response) throws Exception {
		logBefore(logger, "查询department");
		try {
			PageData pd = new PageData();
			pd = this.getPageData();
			pd.put("ID", ID);
			//根据ID获取
			pd = deptService.findById(pd);
			
			response.setCharacterEncoding("UTF-8");
			response.setContentType("text/html");
			PrintWriter out = response.getWriter();
			out.write(pd.getString("DEPT_NAME"));
			out.flush();
			out.close();
			
		} catch (Exception e) {
			logger.error(e.toString(), e);
		}
		
	}
	
	/**
	 * 根据所选部门查询岗位
	 */
	@RequestMapping(value = "/findLevelByDeptId", produces = "text/html;charset=UTF-8")
	public void findLevelByDeptId(@RequestParam String deptId, HttpServletResponse response) throws Exception {
		logBefore(logger, "根据所选部门查询岗位");
		try {
			Map<String, Object> map = new HashMap<String, Object>();
			
			//根据ID获取
			List<PageData> levelList = positionLevelService.findLevelByDeptId(deptId);
			
			map.put("list", levelList);
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
	 * 根据所选岗位查询KPI模板
	 */
	@RequestMapping(value = "/findLevelKpi", produces = "text/html;charset=UTF-8")
	public void findLevelKpi(@RequestParam String kpiModelId, HttpServletResponse response) throws Exception {
		logBefore(logger, "根据所选岗位查询KPI模板ID");
		try {
			//根据ID获取
			PageData levelKpi = positionLevelService.findById2(kpiModelId);
			
			String levelKpiModelId = "";
			levelKpiModelId = levelKpi.get("ATTACH_KPI_MODEL") + "";
			
			response.setCharacterEncoding("UTF-8");
			response.setContentType("text/html");
			PrintWriter out = response.getWriter();
			out.write(levelKpiModelId);
			out.flush();
			out.close();
			
		} catch (Exception e) {
			logger.error(e.toString(), e);
		}
		
	}
	
	/**
	 * 根据所选责任部门查询员工
	 */
	@RequestMapping(value = "/findEmpByDept", produces = "text/html;charset=UTF-8")
	public void findEmpByDept(@RequestParam String deptId, HttpServletResponse response) throws Exception {
		try {
			Map<String, Object> map = new HashMap<String, Object>();
			
			logBefore(logger, "根据所选责任部门查询员工");
			
			PageData pd = new PageData();
			pd.put("ID", deptId);
			pd = deptService.findById(pd);
			List<PageData> empList = employeeService.findEmpByDept(deptId);
			for (PageData pageData : empList) {
				if(pageData.get("ID").equals(pd.get("DEPT_LEADER_ID"))){
					pageData.put("leader", true);
					break;
				}
			}
			
			map.put("list", empList);
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
	 * 根据员工编号查询员工信息
	 * @param code
	 * @return
	 */
	@ResponseBody
	@RequestMapping(value = "/findEmpByCode")
	public PageData findEmpByCode(String code){
		PageData result = new PageData();
		try {
			PageData pageData = new PageData();
			pageData.put("EMP_CODE", code);
			result = employeeService.findByCode(pageData);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return result;
	}
	
	/**
	 * 打开上传EXCEL页面（档案）
	 */
	@RequestMapping(value = "/goUploadExcelRecord")
	public ModelAndView goUploadExcelRecord() throws Exception {
		ModelAndView mv = this.getModelAndView();
		mv.setViewName("bdata/employee/recordLoadexcel");
		return mv;
	}
	/**
	 * 下载模版（档案）
	 */
	@RequestMapping(value = "/downExcelRecord")
	public void downExcelRecord(HttpServletResponse response) throws Exception {
		FileDownload.fileDownload(response, PathUtil.getClasspath() + Const.FILEPATHFILE + "EmpRecord.xls", "EmpRecord.xls");
	}
	/**
	 * 从EXCEL导入到数据库（档案）
	 */
	@SuppressWarnings({ "unchecked", "rawtypes" })
	@RequestMapping(value = "/readExcelRecord")
	public ModelAndView readExcelRecord(@RequestParam(value = "excel", required = false) MultipartFile file,HttpServletRequest request) throws Exception {
		ModelAndView mv = this.getModelAndView();
		PageData pd = new PageData();
		PageData pdm = new PageData();
		PageData pdc = new PageData();
		if (null != file && !file.isEmpty()) {
			String filePath = PathUtil.getClasspath() + Const.FILEPATHFILE; //文件上传路径
			String fileName = FileUpload.fileUp(file, filePath, "modelexcel"); //执行上传
			
			//执行读EXCEL操作,读出的数据导入List 1:从第2行开始；0:从第A列开始；0:第1个sheet
			List<PageData> listPd = (List) ObjectExcelRead.readExcel(filePath, fileName, 1, 0, 0);	//基础信息
			
			//执行读EXCEL操作,读出的数据导入List 1:从第2行开始；0:从第A列开始；0:第2个sheet
			List<PageData> exp = (List) ObjectExcelRead.readExcel(filePath, fileName, 1, 0, 1);		//工作经历

			//var0:第一列      var1:第二列    varN:第N+1列
			for (int i = 1; i < listPd.size(); i++) {
				if(listPd.get(i).getString("var0")==""||listPd.get(i).getString("var0")==null||listPd.get(i).getString("var8")==""||listPd.get(i).getString("var8")==null
						||listPd.get(i).getString("var2")==""||listPd.get(i).getString("var2")==null||listPd.get(i).getString("var3")==""||listPd.get(i).getString("var3")==null
						||listPd.get(i).getString("var4")==""||listPd.get(i).getString("var4")==null||listPd.get(i).getString("var5")==""||listPd.get(i).getString("var5")==null
						||listPd.get(i).getString("var6")==""||listPd.get(i).getString("var6")==null||listPd.get(i).getString("var7")==""||listPd.get(i).getString("var7")==null)
				{
					mv.addObject("msg", "基础数据-第"+i+"条员工的基础数据不全，请检查后再导入");
					mv.setViewName("save_result");
					return mv;
				}
				
				/* 检验编码对应员工是否存在================================= */

				pdc.put("EMP_CODE", listPd.get(i).getString("var0"));
				PageData result = employeeService.findByCode(pdc);
				if(result == null){
					mv.addObject("msg", "第"+i+"条员工的编码不存在，请检查后再导入");
					mv.setViewName("save_result");
					return mv;
				}
				pd.put("EMP_ID", result.get("ID"));	
				pd.put("NAME", result.get("EMP_NAME"));
				pd.put("GENDER", result.get("EMP_GENDER"));	
				pd.put("PHONE", result.get("EMP_PHONE"));
				pd.put("EMAIL", result.get("EMP_EMAIL"));
				Calendar c = new GregorianCalendar(1900,0,-1); 
				Date d = c.getTime();  
				int birth =  Integer.valueOf(listPd.get(i).getString("var2"));
				Date _d = DateUtils.addDays(d, birth);
				pd.put("BIRTHDAY", _d);
				pd.put("AGE", listPd.get(i).getString("var3"));
				pd.put("ADDRESS", listPd.get(i).getString("var4"));
				pd.put("SCHOOL", listPd.get(i).getString("var5"));
				pd.put("MAJOR", listPd.get(i).getString("var6"));
				int graduate =  Integer.valueOf(listPd.get(i).getString("var7"));
				_d = DateUtils.addDays(d, graduate);
				pd.put("GRADUATE_TIME",_d);
				pd.put("DEGREE", listPd.get(i).getString("var8"));
				
				PageData pdkData = employeeService.findRecord(pd);	//是否已有员工档案
				if(pdkData != null){
					employeeService.editRecord(pdkData);
				}else{
					employeeService.saveRecord(pd);
				}				
			}
			
			//var0:第一列      var1:第二列    varN:第N+1列
			for (int i = 1; i < exp.size(); i++) {
				if(exp.get(i).getString("var0")==""||exp.get(i).getString("var0")==null||exp.get(i).getString("var2")==""||exp.get(i).getString("var2")==null
						||exp.get(i).getString("var3")==""||exp.get(i).getString("var3")==null)
				{
					mv.addObject("msg", "第"+i+"条的工作经历数据不全，请检查后再导入");
					mv.setViewName("save_result");
					return mv;
				}
				
				/* 检验编码对应员工是否存在================================= */

				pdc.put("EMP_CODE", exp.get(i).getString("var0"));
				PageData result = employeeService.findByCode(pdc);
				if(result == null){
					mv.addObject("msg", "工作经历-第"+i+"条员工的编码不存在，请检查后再导入");
					mv.setViewName("save_result");
					return mv;
				}
				pdm.put("EMP_ID", result.get("ID"));	
				pdm.put("EXP", exp.get(i).getString("var2"));
				pdm.put("POSITION", exp.get(i).getString("var3"));

				employeeService.deleteAllExp(pdc);					//清空原有经历				
				employeeService.saveExp(pdm);						//导入Excel中的经历
			}
				
			mv.addObject("msg", "success");
		}
		mv.setViewName("save_result");
		return mv;
	}
	
	public int getENum(PageData p){
		int eNum = 0;
		try {
			eNum = Integer.valueOf(deptService.getENum(p).get("eNum").toString());
			List<PageData> childList = deptService.listChild(p);
			for(int j=0;j<childList.size();j++){
				 eNum +=getENum(childList.get(j));				
			}
		}catch (Exception e) {
			logger.error(e.toString(), e);
		}
		return eNum;
	}
	
	
	/**
	 * 员工档案跳转
	 */
	@RequestMapping(value = "/goRecord")
	public ModelAndView goRecord() throws Exception {
		logBefore(logger, "新增Employee页面跳转");
		ModelAndView mv = this.getModelAndView();
		try {
			PageData pd = new PageData();
			PageData pdm = new PageData();
			pd = this.getPageData();
			PageData emp = employeeService.findRecord(pd);	//基础数据
			pdm.put("ID", pd.get("EMP_ID"));
			PageData bdata = employeeService.findById(pdm); //从员工表获取的基础数据
			List<PageData> expList = employeeService.findExp(pd);//员工工作经历
			//果没有基础信息，返回add标识,如果有则返回edit标志
			if(emp == null)
			{
				mv.addObject("msg", "add");
			}
			else{
				mv.addObject("msg", "edit");
			}			
			mv.addObject("emp", emp);
			mv.addObject("bdata", bdata);
			mv.addObject("expList", expList);
			mv.addObject("PARENT_FRAME_ID", pd.get("PARENT_FRAME_ID"));
			mv.addObject("pd", pd);
			mv.setViewName("bdata/employee/employee_record");
			
		} catch (Exception e) {
			logger.error(e.toString(), e);
		}
		return mv;
	}
	
	//员工档案添加或修改
    @RequestMapping(value="/record")
    public ModelAndView record() throws Exception{
        logBefore(logger, "员工档案");
        ModelAndView mv = this.getModelAndView();
        PageData pd = this.getPageData();
        try {
        	if(pd.get("ID")!=null)
        	{
	        	String[] ids = pd.getString("ID").split(",",-1);
	        	String[] update_ids = pd.getString("ID").split(",");
	            String[] EXP = pd.getString("EXP").split(",",-1);
	            String[] POSITION = pd.getString("POSITION").split(",",-1);
	            if(EXP.length == POSITION.length){
	                List<PageData> addList = new ArrayList<PageData>();
	                
	                for(int i = 0;i < EXP.length;i ++){
	                    PageData task = new PageData();
	                    pd.put("EMP_ID",pd.get("EMP_ID"));//员工ID
	                    task.put("EMP_ID",pd.get("EMP_ID"));//员工ID
	                    task.put("ID",ids[i]);//ID
	                    task.put("EXP",EXP[i]);//工作经历
	                    task.put("POSITION",POSITION[i]);//岗位
	                    if("".equals(ids[i])){
	                        //如果id不存在，那么就是增加
	                        addList.add(task);
	                    }else {
	                        //如果id存在，就是更新
	                    	employeeService.batchUpdate(task);
	                    }
	                }
	                
	                //批量删除
	                PageData deletePd = new PageData();
	                deletePd.put("EMP_ID",pd.get("EMP_ID"));
	                if(0 != update_ids.length && !("").equals(update_ids[0])){
	                    deletePd.put("update_ids",update_ids);
	                }else {
	                    String[] new_update_ids = {"0"};
	                    deletePd.put("update_ids",new_update_ids);
	                }
	                employeeService.batchDelete(deletePd);
	
	                
	                //批量新增
	                if(null != addList && 0 != addList.size()){
	                	employeeService.batchAdd(addList);
	                }
	
	        	}
        	}
        	pd.put("EMP_ID",pd.get("EMP_ID"));//员工ID
        	if(pd.get("BIRTHDAY").equals(""))
        	{
        		pd.put("BIRTHDAY", null);
        	}
        	if(pd.get("GRADUATE_TIME").equals(""))
        	{
        		pd.put("GRADUATE_TIME", null);
        	}
            if(pd.get("msg") =="add"||pd.get("msg").equals("add"))
            {
            	//如果没有基础信息，创建
            	employeeService.saveRecord(pd);
            }
            else if(pd.get("msg") =="edit"||pd.get("msg").equals("edit"))
            {
            	//如果有基础信息，修改
            	employeeService.editRecord(pd);
            }          
            mv.addObject("flag","success");
        }catch (Exception e){
            logger.error(e.toString(), e);
            mv.addObject("flag","false");
        }
        
        PageData pdm = new PageData();
		PageData emp = employeeService.findRecord(pd);	//基础数据
		List<PageData> expList = employeeService.findExp(pd);//员工工作经历
		pdm.put("ID", pd.get("EMP_ID"));
		PageData bdata = employeeService.findById(pdm); //从员工表获取的基础数据
		mv.addObject("msg", "edit");	
		mv.addObject("emp", emp);
		mv.addObject("bdata", bdata);
		mv.addObject("expList", expList);
		mv.addObject("PARENT_FRAME_ID", pd.get("PARENT_FRAME_ID"));
		mv.addObject("pd", pd);
		mv.setViewName("bdata/employee/employee_record");
        
        return mv;
    }
    
    /**
     * 根据职位获取员工
     * @param positionId
     * @return
     */
    @ResponseBody
    @RequestMapping("findEmpByPosition")
    public List<PageData> findEmpByPosition(String positionId){
    	try {
			return employeeService.findEmpByPosition(positionId);
		} catch (Exception e) {
			e.printStackTrace();
			return null;
		}
    }
    
    
    
    
	/**
	 * 打开上传EXCEL页面
	 */
	@RequestMapping(value = "/goUploadExcel")
	public ModelAndView goUploadExcel() throws Exception {
		ModelAndView mv = this.getModelAndView();
		mv.setViewName("bdata/employee/employeeLoadExcel");
		return mv;
	}
	/**
	 * 下载模版
	 */
	@RequestMapping(value = "/downExcel")
	public void downExcel(HttpServletResponse response) throws Exception {
		FileDownload.fileDownload(response, PathUtil.getClasspath() + Const.FILEPATHFILE + "Employee.xls", "Employee.xls");
	}
	/**
	 * 从EXCEL导入到数据库
	 */
	@SuppressWarnings({ "unchecked", "rawtypes" })
	@RequestMapping(value = "/readExcel")
	public ModelAndView readExcel(@RequestParam(value = "excel", required = false) MultipartFile file,HttpServletRequest request) throws Exception {
		ModelAndView mv = this.getModelAndView();
		PageData pd ;
		PageData pdm = new PageData();
		PageData pdc = new PageData();
		if (null != file && !file.isEmpty()) {
			String filePath = PathUtil.getClasspath() + Const.FILEPATHFILE; //文件上传路径
			String fileName = FileUpload.fileUp(file, filePath, "modelexcel"); //执行上传
			
			//执行读EXCEL操作,读出的数据导入List 1:从第2行开始；0:从第A列开始；0:第0个sheet
			List<PageData> listPd = (List) ObjectExcelRead.readExcel(filePath, fileName, 1, 0, 0);

				User user = UserUtils.getUser(request);
				//var0:第一列      var1:第二列    varN:第N+1列
				for (int i = 1; i < listPd.size(); i++) {
					if(listPd.get(i).getString("var0")==""||listPd.get(i).getString("var0")==null
							||listPd.get(i).getString("var1")==""||listPd.get(i).getString("var1")==null
							||listPd.get(i).getString("var2")==""||listPd.get(i).getString("var2")==null
							||listPd.get(i).getString("var3")==""||listPd.get(i).getString("var3")==null
							||listPd.get(i).getString("var5")==""||listPd.get(i).getString("var5")==null
							||listPd.get(i).getString("var6")==""||listPd.get(i).getString("var6")==null
							||listPd.get(i).getString("var7")==""||listPd.get(i).getString("var7")==null
							||listPd.get(i).getString("var9")==""||listPd.get(i).getString("var9")==null
							||listPd.get(i).getString("var10")==""||listPd.get(i).getString("var10")==null)
					{
						mv.addObject("msg", "第"+i+"条员工的数据不全，请检查后再导入");
						mv.setViewName("save_result");
						return mv;
					}
					pd = new PageData();
					Date date = new Date();
					String username = user.getNAME();
					
					/* 检验编码和标识重复性================================= */

					pdc.put("EMP_CODE", listPd.get(i).getString("var0"));
					PageData result = employeeService.findByCode(pdc);
					if(result != null){
						mv.addObject("msg", "第"+i+"条员工的编码已存在，请检查后再导入");
						mv.setViewName("save_result");
						return mv;
					}
					
					//验证用户编号
					String num = listPd.get(i).getString("var0");
					PageData checkCodeParam = new PageData();
					checkCodeParam.put("NUMBER",num);
					if (employeeService.findByCode(checkCodeParam) != null) {
						continue;
					}
					
					//根据部门标识获取部门ID

					PageData findDeptIdParam = new PageData();
					findDeptIdParam.put("DEPT_SIGN", listPd.get(i).getString("var3"));
					String deptId = deptService.findIdByS(findDeptIdParam);
					if(deptId ==null||deptId.equals(""))
					{
						mv.addObject("msg", "第"+i+"条的部门不存在，请检查后再导入");
						mv.setViewName("save_result");
						return mv;
					}
					pdm.put("ID", deptId);
					PageData dept = deptService.findById(pdm);
					//根据岗位标识获取岗位ID
					String grade_code = listPd.get(i).getString("var7");
					String gradeId = positionLevelService.findIdByCode(grade_code);
					pdm.put("id", gradeId);
					PageData grade = positionLevelService.findById(pdm);
					
					if(gradeId ==null||gradeId.equals(""))
					{
						mv.addObject("msg", "第"+i+"条的岗位不存在，请检查后再导入");
						mv.setViewName("save_result");
						return mv;
					}					
					pd.put("EMP_CODE", num);
					pd.put("EMP_NAME", listPd.get(i).getString("var1"));
					pd.put("EMP_GENDER", listPd.get(i).getString("var2").equals("男")?'1':'2');
					pd.put("EMP_DEPARTMENT_ID", deptId);
					pd.put("EMP_DEPARTMENT_NAME", dept.get("DEPT_NAME"));
					pd.put("EMP_EMAIL", listPd.get(i).getString("var5"));
					pd.put("EMP_PHONE", listPd.get(i).getString("var6"));
					pd.put("EMP_GRADE_ID", gradeId);
					pd.put("EMP_GRADE_NAME", grade.get("GRADE_NAME"));
					pd.put("EMP_REMARK", listPd.get(i).getString("var9"));
					pd.put("ENABLED", listPd.get(i).getString("var10").equals("是")?'1':'0');
					pd.put("ATTACH_KPI_MODEL", 0);
					pd.put("EMP_POSITION_CODE", 0);
					pd.put("CREATE_USER", username);
					pd.put("CREATE_TIME", date);
					pd.put("LAST_UPDATE_USER", username);
					pd.put("LAST_UPDATE_TIME", date);
					
					employeeService.save(pd);//存入数据库
				}
				mv.addObject("msg", "success");
		}
		mv.setViewName("save_result");
		return mv;
	}
	
	/**
	 * 导出员工信息
	 */
	@RequestMapping("exportEmployee")
	public ModelAndView exportEmployee(){
		logBefore(logger, "开始导出员工信息");
		PageData pd = this.getPageData();
		try {
			List<PageData> list = employeeService.findAllEmpInfo(pd);
			String fileTile = "员工管理";
			List<String> titles = new ArrayList<String>();

			titles.add("员工编码");
			titles.add("员工名称");
			titles.add("员工性别");
			titles.add("部门标识");
			titles.add("员工部门");
			titles.add("员工邮箱");
			titles.add("员工联系电话");
			titles.add("岗位编号");
			titles.add("岗位级别");
			titles.add("备注");
			titles.add("是否有效");
			List<PageData> varList = new ArrayList<PageData>();
			for (int i = 0; i < list.size(); i++) {
				PageData data = list.get(i);
				PageData vpd = new PageData();
				vpd.put("var1", data.getString("EMP_CODE"));
				vpd.put("var2", data.getString("EMP_NAME"));
				vpd.put("var3", "1".equals(data.getString("EMP_GENDER"))? "男":"女");
				vpd.put("var4", data.getString("DEPT_SIGN"));
				vpd.put("var5", data.getString("EMP_DEPARTMENT_NAME"));
				vpd.put("var6", data.getString("EMP_EMAIL"));
				vpd.put("var7", data.getString("EMP_PHONE"));
				vpd.put("var8", data.getString("GRADE_CODE"));
				vpd.put("var9", data.getString("EMP_GRADE_NAME"));
				vpd.put("var10", data.getString("EMP_REMARK"));
				vpd.put("var11", "1".equals(data.getString("ENABLED"))? "是":"否");
				varList.add(vpd);
			}
			
			Map<String, Object> dataMap = new HashMap<String, Object>();
			dataMap.put("fileTile", fileTile);
			dataMap.put("titles", titles);
			dataMap.put("varList", varList);
			
			ObjectExcelView view = new ObjectExcelView(); //执行excel操作
			
			return new ModelAndView(view, dataMap);
		} catch (Exception e) {
			logger.error("导出员工信息-出错", e);
			return this.getModelAndView();
		}
	}
}