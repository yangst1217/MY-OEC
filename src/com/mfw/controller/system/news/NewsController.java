package com.mfw.controller.system.news;

import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

import javax.annotation.Resource;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;

import com.mfw.controller.base.BaseController;
import com.mfw.entity.Page;
import com.mfw.service.system.dictionaries.DictionariesService;
import com.mfw.service.system.menu.MenuService;
import com.mfw.service.system.news.NewsService;
import com.mfw.util.PageData;

/**
 * 类名称：DictionariesController 创建人：mfw 创建时间：2014年9月2日
 * 
 * @version
 */
@Controller
@RequestMapping(value = "/news")
public class NewsController extends BaseController {

	@Resource(name = "menuService")
	private MenuService menuService;
	@Resource(name = "dictionariesService")
	private DictionariesService dictionariesService;
	
	@Resource(name = "newsService")
	private NewsService newsService;

	/**
	 * 保存
	 */
	@RequestMapping(value = "/save")
	public ModelAndView save(PrintWriter out) throws Exception {
		ModelAndView mv = this.getModelAndView();
		PageData pd = new PageData();
		pd = this.getPageData();
		PageData pdp = new PageData();
		pdp = this.getPageData();

		String NEWS_ID = pd.getString("NEWS_ID");
		pdp.put("NEWS_ID", NEWS_ID);

		if (null == NEWS_ID || "".equals(NEWS_ID)) {
				pd.put("NOTICE", pd.getString("NOTICE"));
			newsService.save(pd);
		} else {
			pdp = newsService.findById(pdp);
			pd.put("NOTICE", pd.getString("NOTICE"));
			newsService.edit(pd);
		}

		mv.setViewName("system/news/news_list");
		mv.addObject("msg", "success");
		///mv.setViewName("save_result");
		return mv;

	}

	/**
	 * 列表
	 */
	List<PageData> newsList;

	@RequestMapping(value = "/list")
	public ModelAndView list(Page page) throws Exception {

		ModelAndView mv = this.getModelAndView();
		PageData pd = new PageData();
		pd = this.getPageData();
		String NEWS_ID = pd.getString("NEWS_ID");

		if (null != NEWS_ID && !"".equals(NEWS_ID) && !"0".equals(NEWS_ID)) {

			//返回按钮用
			PageData pdp = new PageData();
			pdp = this.getPageData();

			pdp.put("NEWS_ID", NEWS_ID);
			
			pdp = newsService.findById(pdp);
			
			//pdp = dictionariesService.findById(pdp);
			mv.addObject("pdp", pdp);

			//头部导航
			newsList = new ArrayList<PageData>();
			this.getZDname(NEWS_ID); //	逆序
			Collections.reverse(newsList);

		}

		String NAME = pd.getString("NAME");
		if (null != NAME && !"".equals(NAME)) {
			NAME = NAME.trim();
			pd.put("NAME", NAME);
		}
		page.setShowCount(5); //设置每页显示条数
		page.setPd(pd);
		
		// newsService
		//List<PageData> varList = dictionariesService.dictlistPage(page);
		List<PageData> varList = newsService.newslistPage(page);
		
		
		mv.setViewName("system/news/news_list");
		mv.addObject("varList", varList);
		mv.addObject("varsList", newsList);
		mv.addObject("pd", pd);

		return mv;
	}

	
	@RequestMapping(value = "/mlist")
	public ModelAndView mlist(Page page) throws Exception {

		ModelAndView mv = this.getModelAndView();
		PageData pd = new PageData();
		pd = this.getPageData();
		String NEWS_ID = pd.getString("NEWS_ID");

		if (null != NEWS_ID && !"".equals(NEWS_ID) && !"0".equals(NEWS_ID)) {

			//返回按钮用
			PageData pdp = new PageData();
			pdp = this.getPageData();

			pdp.put("NEWS_ID", NEWS_ID);
			
			pdp = newsService.findById(pdp);
			
			//pdp = dictionariesService.findById(pdp);
			mv.addObject("pdp", pdp);

			//头部导航
			newsList = new ArrayList<PageData>();
			this.getZDname(NEWS_ID); //	逆序
			Collections.reverse(newsList);

		}

		String NAME = pd.getString("NAME");
		if (null != NAME && !"".equals(NAME)) {
			NAME = NAME.trim();
			pd.put("NAME", NAME);
		}
		page.setShowCount(5); //设置每页显示条数
		page.setPd(pd);
		
		// newsService
		//List<PageData> varList = dictionariesService.dictlistPage(page);
		List<PageData> varList = newsService.mnewslistPage(page);
		
		
		mv.setViewName("system/news/mnews_list");
		mv.addObject("varList", varList);
		mv.addObject("varsList", newsList);
		mv.addObject("pd", pd);

		return mv;
	}
	
	
	//递归
	public void getZDname(String NEWS_ID) {
		logBefore(logger, "递归");
		try {
			PageData pdps = new PageData();
			;
			pdps.put("NEWS_ID", NEWS_ID);
			
			// newsService
			pdps = newsService.findById(pdps);
			//pdps = dictionariesService.findById(pdps);
			if (pdps != null) {
				newsList.add(pdps);
				String NEWS_IDs = pdps.getString("NEWS_ID");
				this.getZDname(NEWS_IDs);
			}
		} catch (Exception e) {
			logger.error(e.toString(), e);
		}
	}

	/**
	 * 去新增页面
	 */
	@RequestMapping(value = "/toAdd")
	public ModelAndView toAdd(Page page) {
		ModelAndView mv = this.getModelAndView();
		PageData pd = new PageData();
		try {
			pd = this.getPageData();
			mv.setViewName("system/news/news_edit");
			mv.addObject("pd", pd);
		} catch (Exception e) {
			logger.error(e.toString(), e);
		}

		return mv;
	}

	/**
	 * 去编辑页面
	 */
	@RequestMapping(value = "/toEdit")
	public ModelAndView toEdit(String ROLE_ID) throws Exception {
		ModelAndView mv = this.getModelAndView();
		PageData pd = new PageData();
		pd = this.getPageData();
		pd = newsService.findById(pd);
	/*	if (Integer.parseInt(dictionariesService.findCount(pd).get("ZS").toString()) != 0) {
			mv.addObject("msg", "no");
		} else {
			mv.addObject("msg", "ok");
		}*/
		mv.setViewName("system/news/news_edit");
		mv.addObject("pd", pd);
		return mv;
	}

	/**
	 * 判断编码是否存在
	 */
	@RequestMapping(value = "/has")
	public void has(PrintWriter out) {
		PageData pd = new PageData();
		try {
			pd = this.getPageData();
			if (dictionariesService.findBmCount(pd) != null) {
				out.write("error");
			} else {
				out.write("success");
			}
			out.close();
		} catch (Exception e) {
			logger.error(e.toString(), e);
		}

	}

	/**
	 * 删除用户
	 */
	@RequestMapping(value = "/del")
	public ModelAndView del(PrintWriter out) {
		ModelAndView mv = this.getModelAndView();
		
		PageData pd = new PageData();
		try {
			pd = this.getPageData();
			
			newsService.delete(pd);

		} catch (Exception e) {
			logger.error(e.toString(), e);
		}

		mv.setViewName("system/news/news_list");
		mv.addObject("pd", pd);
		mv.addObject("msg", "success");
		return mv;
		
	}

}
