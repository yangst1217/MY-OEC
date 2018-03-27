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
import com.mfw.service.bdata.PaymentService;
import com.mfw.util.Const;
import com.mfw.util.PageData;
import com.mfw.util.Tools;
/**
 *	薪酬基础数据controller
 * @author yangst
 *
 */
@Controller
@RequestMapping(value="/payment")
public class PaymentController extends BaseController{
	@Resource(name="paymentService")
	private PaymentService paymentService;
	/**
	 * 初始化进入页面跳转
	 * @return
	 */
	@RequestMapping(value= "/list")
	public ModelAndView list(){
		ModelAndView mv = this.getModelAndView();
		mv.setViewName("bdata/payment/list");
		return mv;
	}
	/**
	 * 获取表格数据
	 * @param page
	 * @return
	 * @throws Exception 
	 */
	@ResponseBody
	@RequestMapping(value="/taskList")
	public GridPage taskList(Page page,HttpServletRequest request) throws Exception{
		logBefore(logger, "薪酬基础数据");
		List<PageData> taskList = new ArrayList<>();
		convertPage(page, request);
		PageData pageData = page.getPd();
		String KEYW = pageData.getString("keyword");
		if(null != KEYW && !"".equals(KEYW)){
			KEYW = KEYW.trim();
			pageData.put("KEYW", KEYW);
		}
		page.setPd(pageData);
		taskList = paymentService.list(page);
		
		return new GridPage(taskList,page);
		
	}
	/**
	 * 进入新增页面
	 * @return
	 */
	@RequestMapping(value="/goAdd")
	public ModelAndView goAdd(){
		logBefore(logger, "跳转到新增页面");
		ModelAndView mv = this.getModelAndView();
		mv.setViewName("bdata/payment/add");
		return mv;
	}
	/**
	 * 添加方法
	 * @return
	 */
	@RequestMapping(value="/add")
	public ModelAndView add(){
		logBefore(logger, "添加薪酬数据");
		ModelAndView mv = this.getModelAndView();
		try {
			
			PageData pd = this.getPageData();
			boolean flag = checkExist(pd.getString("NAME"),pd.getString("CODE"),null);
			if(flag == true){
				mv.addObject("msg","编码和名称不得与已存在数据重复!");
			}else{
				Subject currentUser = SecurityUtils.getSubject();
				Session session = currentUser.getSession();
				pd.put("CREATE_USER",session.getAttribute(Const.SESSION_USERNAME));
				pd.put("CREATE_TIME", Tools.date2Str(new Date()));
				paymentService.add(pd);
				mv.addObject("msg","saveSuccess");
			}
		} catch (Exception e) {
			logger.error(e.toString(),e);
			mv.addObject("msg","添加失败!");
		}
		mv.setViewName("save_result");
		return mv;
	}
	public boolean checkExist(String name,String code,String ID) throws Exception{
		PageData pd = new PageData();
		pd.put("NAME", name);
		pd.put("CODE", code);
		pd.put("ID", ID);
		List<PageData> list = this.paymentService.checkExist(pd);
		if(list != null && list.size() != 0){
			return true;
		}else{
			return false;
		}
	}
	/**
	 * 跳转到编辑页面
	 * @return
	 * @throws Exception 
	 */
	@RequestMapping(value="/goEdit")
	public ModelAndView goEdit() throws Exception{
		logBefore(logger, "跳转到编辑页面");
		ModelAndView mv = this.getModelAndView();
		PageData pd = this.getPageData();
		pd = this.paymentService.findById(pd);
		mv.addObject("pd",pd);
		mv.setViewName("bdata/payment/edit");
		return mv;
	}
	/**
	 * 修改
	 * @throws Exception 
	 */
	@RequestMapping(value="/edit")
	public ModelAndView edit() throws Exception{
		ModelAndView mv = this.getModelAndView();
		try {
			PageData pd = this.getPageData();
			boolean flag = checkExist(pd.getString("NAME"),pd.getString("CODE"),pd.getString("ID"));
			if(flag == true){
				mv.addObject("msg","编码和名称不得与已存在数据重复!");
			}else{
			paymentService.edit(pd);
			mv.addObject("msg","saveSuccess");
			}
		} catch (Exception e) {
			e.printStackTrace();
			mv.addObject("msg","编辑失败!");
		}
		mv.setViewName("save_result");
		return mv;
	}
	/**
	 * 删除
	 * @throws Exception 
	 */
	@RequestMapping(value="/delete")
	public void delete(PrintWriter out) throws Exception{
		logBefore(logger, "删除数据");
		PageData pd = this.getPageData();
		paymentService.delete(pd);
		out.write("success");
		out.close();
	}
}
