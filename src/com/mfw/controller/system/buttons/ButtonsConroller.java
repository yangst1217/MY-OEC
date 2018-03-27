package com.mfw.controller.system.buttons;

import java.io.PrintWriter;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.apache.shiro.SecurityUtils;
import org.apache.shiro.session.Session;
import org.apache.shiro.subject.Subject;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import com.mfw.controller.base.BaseController;
import com.mfw.entity.Page;
import com.mfw.entity.system.Menu;
import com.mfw.service.system.buttons.ButtonsService;
import com.mfw.util.Const;
import com.mfw.util.PageData;

/**
 * 类名称：RoleController 创建人：ll 创建时间：2015年10月21日
 * 
 * @version
 */
@Controller
@RequestMapping(value = "/buttons")
public class ButtonsConroller extends BaseController{

	@Resource(name = "buttonsService")
	private ButtonsService buttonsService;
	/**
	 * 列表
	 */
	@RequestMapping(value = "/list")
	public ModelAndView list(Page page) throws Exception {
		logBefore(logger, "列表Buttons");
		ModelAndView mv = this.getModelAndView();
		PageData pd = new PageData();
		try {
			pd = this.getPageData();

			String KEYW = pd.getString("keyword");
			String ENABLED = pd.getString("enabled");
			if (null != KEYW && !"".equals(KEYW)) {
				KEYW = KEYW.trim();
				pd.put("KEYW", KEYW);
			}
			
			if (null != ENABLED && !"".equals(ENABLED)) {
				ENABLED = ENABLED.trim();
				pd.put("ENABLED", ENABLED);
			}

			page.setPd(pd);
			List<PageData> varList = buttonsService.list(page); //列出buttons列表
			this.getHC(); //调用权限
			mv.setViewName("system/buttons/buttons_list");
			mv.addObject("varList", varList);
			mv.addObject("pd", pd);
		} catch (Exception e) {
			logger.error(e.toString(), e);
		}
		return mv;
	}
	
	/**
	 * 新增页面
	 */
	@RequestMapping(value = "/toAdd")
	public ModelAndView toAdd(Page page) {
		ModelAndView mv = this.getModelAndView();
		PageData pd = new PageData();
		try {
			pd = this.getPageData();
			mv.setViewName("system/buttons/buttons_add");
			mv.addObject("pd", pd);
		} catch (Exception e) {
			logger.error(e.toString(), e);
		}
		return mv;
	}
	
	/**
	 * 保存新增信息
	 */
	@RequestMapping(value = "/add", method = RequestMethod.POST)
	public ModelAndView add() throws Exception {
		ModelAndView mv = this.getModelAndView();
		PageData pd = new PageData();
		try {
			pd = this.getPageData();
			String UUID = this.get32UUID();

			pd.put("BUTTONS_ID", UUID);//主键
//			pd.put("BUTTONS_NAME", 0); //按钮名称
//			pd.put("BUTTONS_EVENT", 0); //按钮事件
//			pd.put("BUTTONS_ORDER", 0); //按钮排序
			pd.put("BUTTONS_ICON", ""); //按钮图标
			pd.put("ENABLED",1);//有效性
			buttonsService.add(pd);
			mv.addObject("msg", "success");
		} catch (Exception e) {
			logger.error(e.toString(), e);
			mv.addObject("msg", "failed");
		}
		mv.setViewName("save_result");
		return mv;
	}
	
	
	/**
	 * 请求编辑
	 */
	@RequestMapping(value = "/toEdit")
	public ModelAndView toEdit(String BUTTONS_ID) throws Exception {
		ModelAndView mv = this.getModelAndView();
		PageData pd = new PageData();
		try {
			pd = this.getPageData();
			pd.put("BUTTONS_ID", BUTTONS_ID);
			pd = buttonsService.findObjectById(pd);

			mv.setViewName("system/buttons/buttons_edit");
			mv.addObject("pd", pd);
		} catch (Exception e) {
			logger.error(e.toString(), e);
		}
		return mv;
	}

	/**
	 * 编辑
	 */
	@RequestMapping(value = "/edit")
	public ModelAndView edit() throws Exception {
		ModelAndView mv = this.getModelAndView();
		PageData pd = new PageData();
		try {
			pd = this.getPageData();
			
			if(!pd.containsKey("ENABLED")){
				pd.put("ENABLED","0");
			}
			pd = buttonsService.edit(pd);
			mv.addObject("msg", "success");
		} catch (Exception e) {
			logger.error(e.toString(), e);
			mv.addObject("msg", "failed");
		}
		mv.setViewName("save_result");
		return mv;
	}
	
	/**
	 * 删除
	 */
	@RequestMapping(value = "/delete")
	public void deleteButtons(@RequestParam String BUTTONS_ID, PrintWriter out) throws Exception {
		PageData pd = new PageData();
		try {
			pd.put("BUTTONS_ID", BUTTONS_ID);
			buttonsService.deleteButtonsById(BUTTONS_ID);
			out.write("success");
			out.close();
		} catch (Exception e) {
			logger.error(e.toString(), e);
		}
	}
	
	/* ===============================权限================================== */
	public void getHC() {
		ModelAndView mv = this.getModelAndView();
		//shiro管理的session
		Subject currentUser = SecurityUtils.getSubject();
		Session session = currentUser.getSession();
		Map<String, Integer> map = (Map<String, Integer>) session.getAttribute(Const.SESSION_QX);
		mv.addObject(Const.SESSION_QX, map); //按钮权限
		List<Menu> menuList = (List) session.getAttribute(Const.SESSION_menuList);
		mv.addObject(Const.SESSION_menuList, menuList);//菜单权限
	}
	/* ===============================权限================================== */
}
