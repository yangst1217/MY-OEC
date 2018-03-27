package com.mfw.controller.bdata;

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
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.ModelAndView;

import com.mfw.controller.base.BaseController;
import com.mfw.entity.Page;
import com.mfw.entity.system.User;
import com.mfw.service.bdata.PositionDutyService;
import com.mfw.service.bdata.PositionLevelService;
import com.mfw.util.Const;
import com.mfw.util.FileDownload;
import com.mfw.util.FileUpload;
import com.mfw.util.ObjectExcelRead;
import com.mfw.util.PageData;
import com.mfw.util.PathUtil;
import com.mfw.util.Tools;
import com.mfw.util.UserUtils;

import net.sf.json.JSONObject;

/**
 * Controller-岗位职责
 * 创建日期：2015年12月23日
 * 修改日期：
 */

@Controller
@RequestMapping(value="/positionDuty")
public class positionDutyController extends BaseController {
	
	@Resource(name="positionDutyService")
	private PositionDutyService positionDutyService;
	
	@Resource(name="positionLevelService")
	private PositionLevelService positionLevelService;
	
	/*
	 * 列表
	 */
	@RequestMapping(value="/list")
	public ModelAndView list(Page page){
		logBefore(logger, "bd_kpi_model列表");
		ModelAndView mv = this.getModelAndView();
		try{
			PageData pd = new PageData();
			pd = this.getPageData();						
			List<PageData> varList = positionDutyService.listDuty(pd);
			
			mv.addObject("PARENT_FRAME_ID", pd.get("PARENT_FRAME_ID"));
			mv.addObject("varList", varList);
			mv.addObject("pd", pd);
			mv.setViewName("bdata/positionDuty/list");
			
		} catch(Exception e){
			logger.error(e.toString(), e);
		}
		
		return mv;
	}
	
	/*
	  新增岗位职责页面跳转
	*/
	@RequestMapping(value="/goAdd")
	public ModelAndView goAdd(){
		logBefore(logger, "新增页面跳转");
		ModelAndView mv = this.getModelAndView();
		try {
			PageData pd = new PageData();
			PageData pdm = new PageData();
			pd = this.getPageData();
			pdm = positionLevelService.findById(pd);
			pd.put("GRADE_CODE", pdm.get("GRADE_CODE"));
			mv.addObject("msg", "save");
			mv.addObject("pd", pd);
			mv.setViewName("bdata/positionDuty/duty_edit");
		} catch (Exception e) {
			logger.error(e.toString(), e);
		}						
		return mv;
	}
	
	/*
	 新增岗位职责
	*/
	@RequestMapping(value="/save")
	public ModelAndView save() throws Exception{
		logBefore(logger, "新增");
		ModelAndView mv = this.getModelAndView();
		try {
			PageData pd = new PageData();

			pd = this.getPageData();
			
			PageData pdCode = positionDutyService.findCodeById(pd);
			pd.put("GRADE_CODE", pdCode.get("GRADE_CODE"));
			pd.put("CREATE_USER", getUser().getUSERNAME());	//创建人
			pd.put("CREATE_TIME", Tools.date2Str(new Date()));						//创建时间
			pd.put("UPDATE_USER", getUser().getUSERNAME());//最后修改人
			pd.put("UPDATE_TIME", Tools.date2Str(new Date()));					//最后更改时间
			
			positionDutyService.save(pd);
			
			mv.addObject("msg", "success");
			mv.setViewName("save_result");
		} catch (Exception e) {
			logger.error(e.toString(), e);
		}
		
		return mv;
	}
	
	
	/*
	  新增明细页面跳转
	*/
	@RequestMapping(value="/goAddDetail")
	public ModelAndView goAddDetail(){
		logBefore(logger, "新增明细页面跳转");
		ModelAndView mv = this.getModelAndView();
		try {
			PageData pd = new PageData();
			pd = this.getPageData();
			
			mv.addObject("msg", "saveDetail");
			mv.addObject("pd", pd);
			mv.setViewName("bdata/positionDuty/detail_edit");
		} catch (Exception e) {
			logger.error(e.toString(), e);
		}						
		return mv;
	}
	
	/*
	 新增明细
	*/
	@RequestMapping(value="/saveDetail")
	public ModelAndView saveDetail() throws Exception{
		logBefore(logger, "新增明细");
		ModelAndView mv = this.getModelAndView();
		try {
			PageData pd = new PageData();
			
			pd = this.getPageData();
			
			Subject currentUser = SecurityUtils.getSubject();
			Session session = currentUser.getSession();
						
			pd.put("CREATE_USER", session.getAttribute(Const.SESSION_USERNAME));	//创建人
			pd.put("CREATE_TIME", Tools.date2Str(new Date()));						//创建时间
			pd.put("UPDATE_USER", session.getAttribute(Const.SESSION_USERNAME));//最后修改人
			pd.put("UPDATE_TIME", Tools.date2Str(new Date()));					//最后更改时间
			
			positionDutyService.saveDetail(pd);
			
			mv.addObject("msg", "success");
			mv.setViewName("save_result");
		} catch (Exception e) {
			logger.error(e.toString(), e);
		}
		
		return mv;
	}
	
	
	//修改页面跳转
	@RequestMapping(value="/goEdit")
	public ModelAndView goEdit(String ID){
		logBefore(logger, "修改页面跳转");
		ModelAndView mv = this.getModelAndView();
		PageData pd = new PageData();
		pd = this.getPageData();
		try {
			
			pd = positionDutyService.findById(pd);
			mv.addObject("msg", "edit");
			mv.addObject("pd", pd);
			mv.setViewName("bdata/positionDuty/duty_edit");
			
		} catch (Exception e) {
			logger.error(e.toString(), e);
		}
		
		return mv;
	}
	
	
	/*
	修改岗位职责
	*/
	@RequestMapping(value="/edit")
	public ModelAndView edit() throws Exception{
		logBefore(logger, "修改");
		ModelAndView mv = this.getModelAndView();
		try {
			PageData pd = new PageData();
			
			pd = this.getPageData();
			
			Subject currentUser = SecurityUtils.getSubject();
			Session session = currentUser.getSession();
			

			pd.put("UPDATE_USER", session.getAttribute(Const.SESSION_USERNAME));//最后修改人
			pd.put("UPDATE_TIME", Tools.date2Str(new Date()));//最后更改时间
			
			positionDutyService.edit(pd);
			
			mv.addObject("msg", "success");
			mv.setViewName("save_result");
		} catch (Exception e) {
			logger.error(e.toString(), e);
		}
		
		return mv;
	}
	
	//明细修改页面跳转
		@RequestMapping(value="/goEditDetail")
		public ModelAndView goEditDetail(){
			logBefore(logger, "修改页面跳转");
			ModelAndView mv = this.getModelAndView();
			PageData pd = new PageData();
			pd = this.getPageData();
			try {
				
				pd = positionDutyService.findDetailById(pd);
				mv.addObject("msg", "editDetail");
				mv.addObject("pd", pd);
				mv.setViewName("bdata/positionDuty/detail_edit");
				
			} catch (Exception e) {
				logger.error(e.toString(), e);
			}
			
			return mv;
		}
		
		
		/*
		修改明细
		*/
		@RequestMapping(value="/editDetail")
		public ModelAndView editDetail() throws Exception{
			logBefore(logger, "修改");
			ModelAndView mv = this.getModelAndView();
			try {
				PageData pd = new PageData();
				
				pd = this.getPageData();
				
				Subject currentUser = SecurityUtils.getSubject();
				Session session = currentUser.getSession();
				

				pd.put("UPDATE_USER", session.getAttribute(Const.SESSION_USERNAME));//最后修改人
				pd.put("UPDATE_TIME", Tools.date2Str(new Date()));					//最后更改时间
				
				positionDutyService.editDetail(pd);
				
				mv.addObject("msg", "success");
				mv.setViewName("save_result");
			} catch (Exception e) {
				logger.error(e.toString(), e);
			}
			
			return mv;
		}
	
	
	//删除岗位职责
	@RequestMapping(value="/delete")
	public void delete(PrintWriter out, String DUTY_ID){
		logBefore(logger, "删除");
		PageData pd = new PageData();
		try{
			pd = this.getPageData();
			pd.put("ID", DUTY_ID);
			positionDutyService.delete(pd);
			positionDutyService.batchDeleteDetail(pd);
			out.write("success");

		} catch(Exception e){
			logger.error(e.toString(), e);
		} finally{
			out.flush();
			out.close();
		}
		
	}
	
	//删除明细
	@RequestMapping(value="/delDetail")
	public void delDetail(PrintWriter out){
		logBefore(logger, "删除");
		PageData pd = new PageData();
		try{
			pd = this.getPageData();
			
			positionDutyService.deleteDetail(pd);
			out.write("success");

		} catch(Exception e){
			logger.error(e.toString(), e);
		} finally{
			out.flush();
			out.close();
		}
		
	}
	
	
	@RequestMapping(value = "/showDetail",produces = "text/html;charset=UTF-8")
	public void showDetail(@RequestParam String ID, HttpServletResponse response) throws Exception {
		PageData pd = new PageData();
		Map<String, Object> map = new HashMap<String, Object>();
		try {
			pd = this.getPageData();
			pd.put("ID", ID);
			List<PageData> list = new ArrayList<PageData>();
			
			pd = positionDutyService.findById(pd);
			list = positionDutyService.findDetailByPId(pd);
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
	 * 添加收藏
	 * @return
	 * @throws Exception 
	 */
	@ResponseBody
	@RequestMapping(value="addCollection", method=RequestMethod.POST)
	public Integer addCollection() throws Exception{
		PageData pageData = getPageData();
		pageData.put("user",getUser().getNUMBER());
		if(positionDutyService.checkCollection(pageData) == 0){
			return positionDutyService.addCollection(pageData);
		}
		return null;
	}

	/**
	 * 移除收藏
	 * @return
	 * @throws Exception 
	 */
	@ResponseBody
	@RequestMapping(value="removeCollection", method=RequestMethod.POST)
	public Integer removeCollection() throws Exception{
		PageData pageData = getPageData();
		pageData.put("user",getUser().getNUMBER());
		return positionDutyService.removeCollection(pageData);
	}
	
	
	/**
	 * 岗位职责新增验证
	 */
	@RequestMapping(value = "/checkDuty")
	public void checkDuty(String responsibility, String GRADE_CODE,String msg,String ID, PrintWriter out){
		try{
			PageData pd = new PageData();
			
			pd.put("GRADE_CODE", GRADE_CODE);
			pd.put("responsibility", responsibility);
			pd.put("msg", msg);
			
			
			logBefore(logger, "新增验证");
			if(msg == "save"||msg.equals("save")){	//新增
				PageData res  = positionDutyService.findByRes(pd);
				//判断当前岗位下是否有相同职责
				if(null == res){
					out.write("true");
				}else{
					out.write("false");
				}
			}else{	//修改
				pd.put("ID", Integer.parseInt(ID));
				PageData res  = positionDutyService.findByRes(pd);
				if(null == res){
					out.write("true");
				}else{
					//判断当前岗位下的相同职责与修改的岗位职责ID是否相同
					if(res.get("ID") == pd.get("ID")){
						out.write("true");
					}else{
						out.write("false");
					}
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
	 * 岗位职责明细新增验证
	 */
	@RequestMapping(value = "/checkDetail")
	public void checkDetail(String responsibility_id,String msg,String detail, String ID ,PrintWriter out){
		try{
			PageData pd = new PageData();
			
			pd.put("detail", detail);
			pd.put("responsibility_id", responsibility_id);
			pd.put("msg", msg);
			
			
			logBefore(logger, "新增验证");
			if(msg == "saveDetail"||msg.equals("saveDetail")){	//新增
				PageData res  = positionDutyService.findDetailByRes(pd);
				//判断当前岗位职责下是否有相同明细
				if(null == res){
					out.write("true");
				}else{
					out.write("false");
				}
			}else{	//修改
				pd.put("ID", Integer.parseInt(ID));
				PageData res  = positionDutyService.findDetailByRes(pd);
				if(null == res){
					out.write("true");
				}else{
					//判断当前岗位下的相同职责与修改的岗位职责ID是否相同
					if(res.get("ID") == pd.get("ID")){
						out.write("true");
					}else{
						out.write("false");
					}
				}
			}
			
		} catch(Exception e){
			logger.error(e.toString(), e);
		} finally{
			out.flush();
			out.close();
		}
	}
	
	
	/* ===============================导入导出================================== */
	/**
	 * 打开上传EXCEL页面
	 */
	@RequestMapping(value = "/goUploadExcel")
	public ModelAndView goUploadExcel() throws Exception {
		ModelAndView mv = this.getModelAndView();
		mv.setViewName("bdata/positionDuty/loadexcel");
		return mv;
	}
	/**
	 * 下载模版
	 */
	@RequestMapping(value = "/downExcel")
	public void downExcel(HttpServletResponse response) throws Exception {
		FileDownload.fileDownload(response, PathUtil.getClasspath() + Const.FILEPATHFILE + "PositionDuty.xls", "PositionDuty.xls");
	}
	
	/**
	 * 从EXCEL导入到数据库
	 */
	@SuppressWarnings({ "unchecked", "rawtypes" })
	@RequestMapping(value = "/readExcel")
	public ModelAndView readExcel(@RequestParam(value = "excel", required = false) MultipartFile file,HttpServletRequest request) throws Exception {
		ModelAndView mv = this.getModelAndView();
		PageData pd = new PageData();
		PageData pdm = new PageData();
		
		if (null != file && !file.isEmpty()) {
			String filePath = PathUtil.getClasspath() + Const.FILEPATHFILE; //文件上传路径
			String fileName = FileUpload.fileUp(file, filePath, "modelexcel"); //执行上传

			List<PageData> listPd = (List) ObjectExcelRead.readExcel(filePath, fileName, 1, 0, 0); //执行读EXCEL操作,读出的数据导入List 1:从第2行开始；0:从第A列开始；0:第0个sheet
			List<PageData> listDetail = (List) ObjectExcelRead.readExcel(filePath, fileName, 1, 0, 1); //执行读EXCEL操作,读出的数据导入List 1:从第2行开始；0:从第A列开始；1:第1个sheet
			
			User user = UserUtils.getUser(request);
			pd.put("CREATE_USER", user.getNAME());
			pd.put("CREATE_TIME", new Date());
			pd.put("UPDATE_USER", user.getNAME());
			pd.put("UPDATE_TIME", new Date());
			
			pdm.put("CREATE_USER", user.getNAME());
			pdm.put("CREATE_TIME", new Date());
			pdm.put("UPDATE_USER", user.getNAME());
			pdm.put("UPDATE_TIME", new Date());
			
			for (int i = 1; i < listPd.size(); i++) {
				if(listPd.get(i).getString("var0")==""||listPd.get(i).getString("var0")==null||listPd.get(i).getString("var1")==""||listPd.get(i).getString("var1")==null
						||listPd.get(i).getString("var2")==""||listPd.get(i).getString("var2")==null||listPd.get(i).getString("var3")==""||listPd.get(i).getString("var3")==null
						||listPd.get(i).getString("var4")==""||listPd.get(i).getString("var4")==null)
				{
					mv.addObject("msg", "第"+(i+1)+"条岗位职责的数据不全，请检查后再导入");
					mv.setViewName("save_result");
					return mv;
				}
				pd.put("GRADE_CODE", listPd.get(i).getString("var2")); 	//岗位编号
				pd.put("responsibility", listPd.get(i).getString("var4")); 	//岗位职责
				String flag = positionLevelService.findIdByCode(listPd.get(i).getString("var2"));//该岗位是否存在
				if(flag!=null)
				{
					PageData res  = positionDutyService.findByRes(pd);//该岗位职责是否已有相同的
					//如果不存在，新增，否则不进行操作
					if(res == null)
					{
						positionDutyService.save(pd);
					}
				}
				else{
					mv.addObject("msg", "第"+(i+1)+"条的岗位不存在，请先添加岗位");
					mv.setViewName("save_result");
					return mv;
				}			
			}
			
			for (int i = 1; i < listDetail.size(); i++) {
				if(listDetail.get(i).getString("var0")==""||listDetail.get(i).getString("var0")==null||listDetail.get(i).getString("var1")==""||listDetail.get(i).getString("var1")==null
						||listDetail.get(i).getString("var2")==""||listDetail.get(i).getString("var2")==null||listDetail.get(i).getString("var3")==""||listDetail.get(i).getString("var3")==null
//						||listDetail.get(i).getString("var4")==""||listDetail.get(i).getString("var4")==null||listDetail.get(i).getString("var5")==""||listDetail.get(i).getString("var5")==null
//						||listDetail.get(i).getString("var6")==""||listDetail.get(i).getString("var6")==null||listDetail.get(i).getString("var7")==""||listDetail.get(i).getString("var7")==null
//						||listDetail.get(i).getString("var8")==""||listDetail.get(i).getString("var8")==null||listDetail.get(i).getString("var9")==""||listDetail.get(i).getString("var9")==null
				)
				{
					mv.addObject("msg", "第"+(i+1)+"条职责详情的数据不全，请检查后再导入");
					mv.setViewName("save_result");
					return mv;
				}
				pdm.put("GRADE_CODE", listDetail.get(i).getString("var0"));	//岗位编码
				pdm.put("responsibility", listDetail.get(i).getString("var1"));	//岗位职责名称
				PageData res  = positionDutyService.findByRes(pdm);	//对应岗位职责是否存在
				if(res !=null)
				{	
					pdm.put("responsibility_id", res.get("ID")); 	//岗位职责ID
					pdm.put("detail", listDetail.get(i).getString("var3")); 	//工作明细
					pdm.put("requirement", null==listDetail.get(i).get("var4") ? "" : listDetail.get(i).getString("var4")); 	//要求
					pdm.put("frequency", null==listDetail.get(i).get("var5") ? "" : listDetail.get(i).getString("var5")); 	//频率
					pdm.put("guide", null==listDetail.get(i).get("var6") ? "" : listDetail.get(i).getString("var6")); 	//工作指南、
					pdm.put("standard_time", null==listDetail.get(i).get("var7") || listDetail.get(i).getString("var7").isEmpty() ? 60 : listDetail.get(i).getString("var7")); 	//参考时间
					pdm.put("unit", "分钟"); 	//单位
					pdm.put("target", null==listDetail.get(i).get("var8") ? "" : listDetail.get(i).getString("var8")); 	//对象
					pdm.put("needApprove", null==listDetail.get(i).get("var9") || listDetail.get(i).getString("var9").isEmpty() ? "1" : listDetail.get(i).getString("var9").equals("是")?"1":"0");	//是否需要审批
					PageData DetailRes  = positionDutyService.findDetailByRes(pdm);	//明细是否存在相同的
					//如果有相同的则更新，否则创建
					if(DetailRes!=null)
					{
						pdm.put("ID", DetailRes.get("ID"));
						positionDutyService.editDetail(pdm);
					}else{
						positionDutyService.saveDetail(pdm);
					}					
				}
				else{
					mv.addObject("msg", "第"+(i+1)+"条的职责详情对应的岗位职责不存在，请检查后再导入");
					mv.setViewName("save_result");
					return mv;
				}		
			}
			mv.addObject("msg", "导入成功");
		}

		mv.setViewName("save_result");
		return mv;
	}
}