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
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import com.mfw.controller.base.BaseController;
import com.mfw.entity.GridPage;
import com.mfw.entity.Page;
import com.mfw.service.bdata.BussinessIndexService;
import com.mfw.util.Const;
import com.mfw.util.PageData;
import com.mfw.util.Tools;


/** 
 * Controller-经营指标
 * 创建人：bhw 
 * 创建时间：2016-05-11
 */
@Controller
@RequestMapping(value="/bussinessIndex")
public class BussinessIndexController extends BaseController {
	
	@Resource(name = "bussinessIndexService")
	private BussinessIndexService bussinessIndexService;
	
	/**
	 * 列表
	 */
	@RequestMapping(value = "/list")
	public ModelAndView list(Page page) {
		ModelAndView mv = this.getModelAndView();
		//PageData pd = new PageData();
			
		try {
			/*pd = this.getPageData();
			page.setPd(pd);
			
			List<PageData> List = bussinessIndexService.list(page);
			
			mv.addObject("List", List);
			mv.addObject("pd", pd);*/
			mv.setViewName("bdata/bussinessIndex/list");
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
			//PageData pageData = page.getPd();
			
			empList = bussinessIndexService.list(page);
			
			
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
			e.printStackTrace();
		}
		return new GridPage(empList, page);
	}
	
	/**
	 * 删除
	 */
	@RequestMapping(value = "/delete")
	public void delete(PrintWriter out) {
		PageData pd = new PageData();
		try {
			pd = this.getPageData();
			
			Subject currentUser = SecurityUtils.getSubject();
			Session session = currentUser.getSession();
				        
			pd.put("UPDATE_USER", session.getAttribute(Const.SESSION_USERNAME));	//最后修改人
			pd.put("UPDATE_TIME", Tools.date2Str(new Date()));						//最后更改时间
			bussinessIndexService.delete(pd);			
			out.write("success");
			
		} catch (Exception e) {
			logger.error(e.toString(), e);
		} finally{
			out.flush();
			out.close();
		}

	}
	
	/**
	 * 去新增界面
	 */
	@RequestMapping(value="/goAdd")
	public ModelAndView goAdd(){
		logBefore(logger, "去新增页面");
		ModelAndView mv = this.getModelAndView();
		PageData pd = new PageData();
		pd = this.getPageData();		
		try {			
			mv.addObject("msg", "save");
			mv.addObject("pd", pd);
			mv.setViewName("bdata/bussinessIndex/edit");
		} catch (Exception e) {
			logger.error(e.toString(), e);
		}					
		return mv;
	}	
	
	/**
	 * 新增
	 */
	@RequestMapping(value="/save")
	public ModelAndView save() throws Exception {
		logBefore(logger, "修改");
		PageData pd = this.getPageData();
		ModelAndView mv = this.getModelAndView();
		try{
			Subject currentUser = SecurityUtils.getSubject();
			Session session = currentUser.getSession();
				        
			pd.put("CREATE_USER", session.getAttribute(Const.SESSION_USERNAME));		//创建人
			pd.put("CREATE_TIME", Tools.date2Str(new Date()));							//创建时间
			pd.put("UPDATE_USER", session.getAttribute(Const.SESSION_USERNAME));	//最后修改人
			pd.put("UPDATE_TIME", Tools.date2Str(new Date()));						//最后更改时间
			
			bussinessIndexService.save(pd);
			mv.addObject("editFlag", "saveSucc");
			mv.setViewName("save_result");
			
		} catch (Exception e) {
			mv.addObject("editFlag", "savefail");
			logger.error(e.toString(), e);
		}
		
		return mv;
		
	}	
	/**
	 * 去修改界面
	 */
	@RequestMapping(value="/goEdit")
	public ModelAndView goEdit(){
		logBefore(logger, "去修改页面");
		ModelAndView mv = this.getModelAndView();
		PageData pd = this.getPageData();
		try {
			pd = bussinessIndexService.findById(pd);
			
			mv.addObject("msg", "edit");
			mv.addObject("pd", pd);
			mv.setViewName("bdata/bussinessIndex/edit");
		} catch (Exception e) {
			logger.error(e.toString(), e);
		}					
		return mv;
	}	
	
	/**
	 * 修改
	 */
	@RequestMapping(value="/edit")
	public ModelAndView edit() throws Exception {
		logBefore(logger, "修改");
		ModelAndView mv = this.getModelAndView();
		PageData pd = this.getPageData();
		try{
			Subject currentUser = SecurityUtils.getSubject();
			Session session = currentUser.getSession();
				        
			pd.put("UPDATE_USER", session.getAttribute(Const.SESSION_USERNAME));	//最后修改人
			pd.put("UPDATE_TIME", Tools.date2Str(new Date()));						//最后更改时间
			bussinessIndexService.edit(pd);
			mv.addObject("editFlag", "updateSucc");
			mv.setViewName("save_result");
		} catch (Exception e) {
			logger.error(e.toString(), e);
		}

		return mv;
	}
	
	/**
	 * 验证
	 */
	@RequestMapping(value = "/checkIndexCode",produces="text/html;charset=UTF-8")
	public void checkIndexCode(String index_code, String msg, String id, PrintWriter out){
		try{
			PageData pd = new PageData();
			pd.put("INDEX_CODE", index_code);
			
			logBefore(logger, "验证");
			if(msg.equals("save")){		//新增
				PageData indexData  = bussinessIndexService.findByCode(pd);
				if(null == indexData){
					out.write("true");
				}else{
					out.write("false");
				}
			}else{	//修改
				pd.put("ID", id);
				//原有数据
				PageData index = bussinessIndexService.findById(pd);
				//修改后的数据
				PageData indexData  = bussinessIndexService.findByCode(pd);
				if(null != indexData && indexData.getString("INDEX_CODE").equals(index.getString("INDEX_CODE"))){	//用户没有修改编号
					out.write("true");
				}else if(null != indexData && !indexData.getString("INDEX_CODE").equals(index.getString("INDEX_CODE"))){//用户修改后的编号与原有编号重复
					out.write("false");
				}else if(null == indexData){	//用户修改后的编号为唯一
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
	 * 检查是否被使用
	 */
	@ResponseBody
	@RequestMapping("checkBusiIndexUsed")
	public String checkBusiIndexUsed(@RequestParam Integer id){
		logBefore(logger, "检查经营指标是否被使用");
		try {
			int num = bussinessIndexService.checkBusiIndexUsed(id);
			return String.valueOf(num);
		} catch (Exception e) {
			logger.error("检查经营指标是否被使用-出错", e);
			return "error";
		}
	}
}
