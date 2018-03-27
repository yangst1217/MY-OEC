package com.mfw.controller.bdata;

import java.io.PrintWriter;
import java.text.DecimalFormat;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.print.DocFlavor.STRING;
import javax.script.ScriptEngine;
import javax.script.ScriptEngineManager;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import net.sf.json.JSONObject;

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
import com.mfw.service.bdata.SalaryShowService;
import com.mfw.util.Const;
import com.mfw.util.FileDownload;
import com.mfw.util.FileUpload;
import com.mfw.util.ObjectExcelRead;
import com.mfw.util.PageData;
import com.mfw.util.PathUtil;
import com.mfw.util.Tools;
import com.mfw.util.UserUtils;

/**
 * 员工薪资展示controller
 * 
 * @author yangst
 * 
 */
@Controller
@RequestMapping(value = "/salary")
public class SalaryShowController extends BaseController {
	@Resource(name = "salaryShowService")
	private SalaryShowService service;

	 private ScriptEngine jse = new ScriptEngineManager().getEngineByName("JavaScript"); 
	/**
	 * 页面初始化
	 * 
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/list")
	public ModelAndView list() throws Exception {
		ModelAndView mv = this.getModelAndView();
		PageData pd = this.getPageData();
		List<PageData> deptList = this.service.queryDept(pd);
		List<PageData> posList = this.service.queryPos(pd);
		mv.addObject("deptList", deptList);
		mv.addObject("posList", posList);
		mv.setViewName("bdata/salary/list");
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
		logBefore(logger, "员工薪资展示表格数据获取");
		List<PageData> taskList = new ArrayList<>();
		try {
			convertPage(page, request);
			taskList = this.service.list(page);
		} catch (Exception e) {
			logger.error(e.toString(), e);
			e.printStackTrace();
		}
		return new GridPage(taskList, page);
	}

	/**
	 * 进入查看页面
	 * 
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/goView")
	public ModelAndView goView() throws Exception {
		ModelAndView mv = this.getModelAndView();
		PageData pd = this.getPageData();
		PageData infoPd = this.service.findById(pd);
		mv.addObject("pd", infoPd);
		List<PageData> itemList = this.service.queryItem(pd);
		mv.addObject("itemList", itemList);
		mv.setViewName("bdata/salary/view");
		return mv;
	}

	/**
	 * 进入编辑页面
	 * 
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/goEdit")
	public ModelAndView goEdit() throws Exception {
		ModelAndView mv = this.getModelAndView();
		PageData pd = this.getPageData();
		PageData infoPd = this.service.findById(pd);
		mv.addObject("pd", infoPd);
		List<PageData> itemList = this.service.queryItem(pd);
		mv.addObject("itemList", itemList);
//		PageData perInfo = this.service.queryPer(infoPd);
//		int result = 100;
//		if(perInfo != null){
//			if(perInfo.get("SCORE") != null){
//				result = Integer.parseInt(perInfo.get("SCORE").toString());
//			}
//		}
//		float num= (float)result/100;   
//		DecimalFormat df = new DecimalFormat("0.00");//格式化小数   
//		String s = df.format(num);//返回的是String类型 
		mv.setViewName("bdata/salary/edit");
		return mv;
	}

	/**
	 * 修改
	 * 
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/edit")
	public ModelAndView edit() throws Exception {
		ModelAndView mv = this.getModelAndView();
		PageData pd = this.getPageData();
		try {
			Subject currentUser = SecurityUtils.getSubject();
			Session session = currentUser.getSession();
			pd.put("LAST_UPDATE_USER",
					session.getAttribute(Const.SESSION_USERNAME));
			pd.put("LAST_UPDATE_TIME", Tools.date2Str(new Date()));
			String remarks = new String(pd.getString("remarks").getBytes(
					"iso-8859-1"), "UTF-8");
			pd.put("remarks", remarks);
			// 更新薪资主表
			this.service.updateSal(pd);
			String str = pd.getString("info");
			String sal[] = str.split(",");
			for (int i = 0; i < sal.length; i++) {
				String BS_ID = sal[i].split("@")[0];
				String BS_AMOUNT = sal[i].split("@")[1];
				pd.put("BS_ID", BS_ID);
				pd.put("BS_AMOUNT", BS_AMOUNT);
				this.service.updateDetail(pd);
			}
			mv.addObject("msg", "saveSuccess");
		} catch (Exception e) {
			e.printStackTrace();
			mv.addObject("msg", "false");
		}
		mv.setViewName("save_result");
		return mv;
	}

	/**
	 * 打开上传EXCEL页面
	 */
	@RequestMapping(value = "/goUploadExcel")
	public ModelAndView goUploadExcel() throws Exception {
		ModelAndView mv = this.getModelAndView();
		mv.setViewName("bdata/salary/deptloadexcel");
		return mv;
	}

	/**
	 * 下载模版
	 */
	@RequestMapping(value = "/downExcel")
	public void downExcel(HttpServletResponse response) throws Exception {

		FileDownload.fileDownload(response, PathUtil.getClasspath()
				+ Const.FILEPATHFILE + "ShowSalary.xls", "ShowSalary.xls");
	}

	/**
	 * 读取excel
	 * 
	 * @param file
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@SuppressWarnings({ "unchecked", "rawtypes" })
	@RequestMapping(value = "/readExcel")
	public ModelAndView readExcel(
			@RequestParam(value = "excel", required = false) MultipartFile file,
			HttpServletRequest request) throws Exception {
		ModelAndView mv = this.getModelAndView();
		PageData pd;
		List errorList = new ArrayList<>();
		if (null != file && !file.isEmpty()) {
			String filePath = PathUtil.getClasspath() + Const.FILEPATHFILE;
			String fileName = FileUpload.fileUp(file, filePath, "modelexcel");
			List<PageData> listPd = (List) ObjectExcelRead.readExcel(filePath,
					fileName, 1, 0, 0);
			User user = UserUtils.getUser(request);
			for (int i = 0; i < listPd.size(); i++) {
				try {
					pd = new PageData();
					pd.put("EMP_CODE", listPd.get(i).getString("var1"));
					String YM = listPd.get(i).getString("var8");
					YM = YM.substring(0, 4) + "-" + YM.substring(4, 6);
					pd.put("YM", YM);
					//查询数据是否存在
					List<PageData> numList = this.service.checkExist(pd);
					int num = numList.size();
					pd.put("POS_CODE", listPd.get(i).getString("var5"));
					//查询岗位对应的薪资公式
					PageData infoPd = this.service.queryFormula(pd);
					pd.put("SALARY_AMOUNT", 0);
					pd.put("F_ID", infoPd.get("ID").toString());
					pd.put("FORMULA", infoPd.getString("FORMULA"));
					pd.put("NO", listPd.get(i).getString("var0"));
					pd.put("EMP_NAME", listPd.get(i).getString("var2"));
					pd.put("DEPT_ID", listPd.get(i).getString("var3"));
					pd.put("DEPT_NAME", listPd.get(i).getString("var4"));
					pd.put("POS_NAME", listPd.get(i).getString("var6"));
					pd.put("REMARKS", listPd.get(i).getString("var9"));
					if(num!=0){
						//已有薪资存在
						PageData existPd = (PageData) (numList.get(0));
						pd.put("ID", existPd.get("ID").toString());
						// 删除已有薪酬的子项
						this.service.delDetail(pd);
						
					}
					//查询考核系数
					PageData perInfo = this.service.queryPer(pd);
					int result = 100;
					if(perInfo != null){
						if(perInfo.get("SCORE") != null){
							result = Integer.parseInt(perInfo.get("SCORE").toString());
						}
					}
					float perNum= (float)result/100;   
					DecimalFormat df = new DecimalFormat("0.00");//格式化小数   
					String s = df.format(perNum);//返回的是String类型 
					// 查询薪资子项目
					List<PageData> salPd = this.service.queryDetail(pd);
					String queryStr = "";
					if(salPd!=null && salPd.size()!=0){
						for (int j = 0; j < salPd.size(); j++) {
							salPd.get(j).put("BS_ID", salPd.get(j).get("ID").toString());
							if (salPd.get(j).get("TYPE").equals("1")) {
								//非运算符项
								if(salPd.get(j).get("NAME").equals("考核系数")){
									salPd.get(j).put("BS_AMOUNT",
											s);
								}else{
									String str[] = listPd.get(i).getString("var7")
											.split(",");
									salPd.get(j).put("BS_AMOUNT", 0);
									if (str != null && str.length != 0) {
										for (int k = 0; k < str.length; k++) {
											String formulaName = str[k].split(":")[0];
											String formulaNum = str[k].split(":")[1];
											if (salPd.get(j).getString("NAME")
													.equals(formulaName)) {
												salPd.get(j).put("BS_AMOUNT",
														Integer.parseInt(formulaNum));
											}
										}

									}
								}
									queryStr += salPd.get(j).get("BS_AMOUNT");
								}else{
									//是运算符项
									queryStr += salPd.get(j).get("NAME");
								}
	
						}
					}
					String amount = jse.eval(queryStr).toString();
					pd.put("CREATE_USER", user.getNAME());
					pd.put("CREATE_TIME", new Date());
					pd.put("SALARY_AMOUNT", amount);
					String id = "";
					if (num == 0) {
						// 数据保存入库
						this.service.addData(pd);
						id = pd.get("ID").toString();

					} else {
						// 编辑现有数据
						PageData existPd = (PageData) (numList.get(0));
						pd.put("ID", existPd.get("ID").toString());
						this.service.editData(pd);
						id = existPd.get("ID").toString();
					}

					for (int j = 0; j < salPd.size(); j++) {
						salPd.get(j).put("PID", id);
						salPd.get(j).put("BS_ID", salPd.get(j).get("ID").toString());
						this.service.saveDetail(salPd.get(j));
					}
				} catch (Exception e) {
					e.printStackTrace();
					errorList.add(i);
				}

			}
			
		}
		if(errorList == null || errorList.size() == 0){
			mv.addObject("msg","数据导入成功!");
		}else{
			StringBuffer errorInfo = new StringBuffer("数据导入失败!出错的数据序号为:");
			for (int j = 0; j < errorList.size(); j++) {
				int NO = Integer.parseInt(errorList.get(j).toString())+1;
				if(j == 0){
					errorInfo.append(NO);
				}else{
					
					errorInfo.append(","+NO);
				}
			}
			mv.addObject("msg",errorInfo);
		}
		mv.setViewName("save_result");
		return mv;

	}
	@RequestMapping(value="buildData",produces = "text/html;charset=UTF-8")
	public void buildData(HttpServletResponse response) throws Exception{
		logBefore(logger, "生成当月薪资");
		Map<String, Object> map = new HashMap<String, Object>();
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM");
		String ym = sdf.format(new Date());
		PageData pd = new PageData();
		pd.put("YM", ym);
		List<PageData> list;
		try {
			list = this.service.findCurData(pd);
			if(list!=null && list.size()!=0){
				for (PageData data:list) {
					data.put("YM", ym);
					//查询考核系数
					PageData perInfo = this.service.queryPer(data);
					int result = 100;
					if(perInfo != null){
						if(perInfo.get("SCORE") != null){
							result = Integer.parseInt(perInfo.get("SCORE").toString());
						}
					}
					float num= (float)result/100;   
					DecimalFormat df = new DecimalFormat("0.00");//格式化小数   
					String s = df.format(num);//返回的是String类型 
					if(data.get("ID") == null){
						//没有当月数据
						String lastYm = sdf.format(getLastMonth(new Date()));
						data.put("lastYm", lastYm);
						List<PageData> lastData =  this.service.findLastData(data);
						if(lastData != null && lastData.size() != 0){
							//上月有数据
							String queryStr = "";
							for (int i = 0; i < lastData.size(); i++) {
									PageData insertPd = (PageData)lastData.get(i);
									if(insertPd.get("BS_TYPE").toString().equals("1")){
										if(!insertPd.get("BS_NAME").toString().equals("考核系数")){
											queryStr += insertPd.get("BS_AMOUNT").toString();
										}else{
											queryStr += s;
										}
										
									}else{
										queryStr += insertPd.get("BS_NAME").toString();
									}
									

							}
							String amount = jse.eval(queryStr).toString();
							
							PageData firstData = (PageData)lastData.get(0);
							Subject currentUser = SecurityUtils.getSubject();  
							Session session = currentUser.getSession();
							User user = (User)session.getAttribute(Const.SESSION_USER);
						
							firstData.put("CREATE_USER",user.getUSERNAME());
							firstData.put("CREATE_TIME",new Date());
							firstData.put("YM", ym);
							firstData.put("SALARY_AMOUNT", amount);
							this.service.doAddSal(firstData);
							String PID = "";
							PID = firstData.get("ID").toString();
							for (int i = 0; i < lastData.size(); i++) {
								PageData addPd = (PageData)lastData.get(i);
								addPd.put("ID", PID);
								if(addPd.get("BS_NAME").toString().equals("考核系数")){
									addPd.put("BS_AMOUNT", s);
								}
								this.service.doAddSalDetail(addPd);
							}
						}else{
							//上月无数据
							String ID = "";
							List<PageData> dataList = this.service.findSalInfo(data);
							if (dataList != null && dataList.size() != 0) {
								for (int i = 0; i < dataList.size(); i++) {
									if(i == 0){
									//插入薪资主表	
									PageData firstInfo = (PageData)dataList.get(i);
									firstInfo.put("YM", ym);
									firstInfo.put("SALARY_AMOUNT", 0);
									Subject currentUser = SecurityUtils.getSubject();  
									Session session = currentUser.getSession();
									User user = (User)session.getAttribute(Const.SESSION_USER);
									firstInfo.put("CREATE_USER",user.getUSERNAME());
									firstInfo.put("CREATE_TIME",new Date());
									firstInfo.put("REMARKS", "");
									this.service.doAddSal(firstInfo);
									ID = firstInfo.get("ID").toString();
									}
									PageData insertInfo = (PageData)dataList.get(i);
									insertInfo.put("ID", ID);
									if(insertInfo.getString("BS_TYPE").equals("1")&&!insertInfo.getString("BS_NAME").equals("考核系数")){
										
										insertInfo.put("BS_AMOUNT", 0);
									}
									if(insertInfo.getString("BS_TYPE").equals("1")&&insertInfo.getString("BS_NAME").equals("考核系数")){
										insertInfo.put("BS_AMOUNT", s);
									}
									this.service.doAddSalDetail(insertInfo);
								}
							}
						}
					}
				}
				map.put("msg", "生成薪资成功!");
			}else{
				map.put("msg", "没有员工!");
			}

		} catch (Exception e) {
			map.put("msg", "生成薪资失败!出错原因："+e.toString());
		}
		JSONObject obj = JSONObject.fromObject(map);
		String json = obj.toString();
		response.setCharacterEncoding("utf-8");
		response.setContentType("text/html");
		PrintWriter out = response.getWriter();
		out.print(json);
		out.flush();
		out.close();
	}
	//获取上月月份
	private  Date getLastMonth(Date date){
		 Calendar c = Calendar.getInstance();
		c.setTime(date);
		c.add(Calendar.MONTH, -1);
		return c.getTime();
	}
}
