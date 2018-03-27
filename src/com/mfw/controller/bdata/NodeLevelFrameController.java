package com.mfw.controller.bdata;

import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import com.mfw.controller.base.BaseController;
import com.mfw.entity.GridPage;
import com.mfw.entity.Page;
import com.mfw.service.bdata.NodeLevelFrameService;
import com.mfw.util.AppUtil;
import com.mfw.util.PageData;

/**
 * Controller-节点层级结构
 * @author ll
 * @date 2016-5-10
 *
 */

@Controller
@RequestMapping(value="/nodeLevelFrame")
public class NodeLevelFrameController extends BaseController {
	
	@Resource(name="nodeLevelFrameService")
	private NodeLevelFrameService nodeLevelFrameService;
	/**
	 * 列表
	 */
	@RequestMapping(value="/list")
	public ModelAndView list(Page page){
		logBefore(logger, "列表岗位维护");
		ModelAndView mv = this.getModelAndView();
		//PageData pd = new PageData();
		try {
			/*pd = this.getPageData();
			String KEYW = pd.getString("keyword");
			if (null != KEYW && !"".equals(KEYW)) {
				KEYW = KEYW.trim();
				pd.put("KEYW", KEYW);
			}
			page.setPd(pd);
			List<PageData> varList = nodeLevelFrameService.listAll(page); 
			
			mv.addObject("varList", varList);
			mv.addObject("pd", pd);*/
			mv.setViewName("bdata/nodelevelframe/list");
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
			
			empList = nodeLevelFrameService.listAll(page); 
			
			
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
			e.printStackTrace();
		}
		return new GridPage(empList, page);
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
			mv.setViewName("bdata/nodelevelframe/add");
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
			savePage(pd);
			nodeLevelFrameService.add(pd);
			mv.addObject("msg", "success");
		} catch (Exception e) {
			logger.error(e.toString(), e);
			mv.addObject("msg", "failed");
		}
		mv.setViewName("save_result");
		return mv;
	}
	
	/**
	 * 去修改页面
	 */
	@RequestMapping(value = "/goEdit")
	public ModelAndView goEdit() {
		logBefore(logger, "去修改nodelevelframe页面");
		ModelAndView mv = this.getModelAndView();
		PageData pd = new PageData();
		pd = this.getPageData();
		try {
			pd = nodeLevelFrameService.findById(pd); //根据ID读取
			mv.setViewName("bdata/nodelevelframe/edit");
			mv.addObject("msg", "edit");
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
			updatePage(pd);
			nodeLevelFrameService.edit(pd);
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
	public void delete(PrintWriter out) {
		logBefore(logger, "删除nodelevelframe");
		PageData pd = new PageData();
		try {
			pd = this.getPageData();
			updatePage(pd);
			nodeLevelFrameService.delete(pd);
			out.write("success");
		} catch (Exception e) {
			out.write("error");
			logger.error(e.toString(), e);
		}
		out.close();
	}
	
	/**
	 * 批量删除
	 */
	@RequestMapping(value = "/deleteAll")
	@ResponseBody
	public Object deleteAll() {
		logBefore(logger, "批量删除nodelevelframe");
		PageData pd = new PageData();		
		Map<String,Object> map = new HashMap<String,Object>();
		try {
			pd = this.getPageData();
			List<PageData> pdList = new ArrayList<PageData>();
			String DATA_IDS = pd.getString("DATA_IDS");
			if(null != DATA_IDS && !"".equals(DATA_IDS)){
				String ArrayDATA_IDS[] = DATA_IDS.split(",");
				nodeLevelFrameService.deleteAll(ArrayDATA_IDS);
				pd.put("msg", "ok");
			}else{
				pd.put("msg", "no");
			}
			pdList.add(pd);
			map.put("list", pdList);
		} catch (Exception e) {
			logger.error(e.toString(), e);
		} finally {
			logAfter(logger);
		}
		return AppUtil.returnObject(pd, map);
	}
	
	/**
	 * 去修改层级配置页面
	 */
	@RequestMapping(value = "/goEditLevels")
	public ModelAndView goEditLevels() {
		logBefore(logger, "去修改nodelevelframe层级配置页面");
		ModelAndView mv = this.getModelAndView();
		PageData pd = new PageData();
		pd = this.getPageData();
		try {
			pd = nodeLevelFrameService.findById(pd); //根据ID读取
			List<PageData> varList = nodeLevelFrameService.findLevelFrameRel(pd); //获取层级结构配置
			List<PageData> nodeList = nodeLevelFrameService.findAllNodeList(); //获取所有层级
			mv.setViewName("bdata/nodelevelframe/editLevels");
			mv.addObject("varList", varList);
			mv.addObject("nodeList", nodeList);
			mv.addObject("msg", "edit");
			mv.addObject("pd", pd);
		} catch (Exception e) {
			logger.error(e.toString(), e);
		}
		return mv;
	}
	
	/**
	 * 修改层级配置页面
	 */
	@RequestMapping(value="/editLevels")
	public ModelAndView editLevels() throws Exception{
		ModelAndView mv = this.getModelAndView();
		PageData pd = new PageData();
		pd = this.getPageData();
		
		String delids = pd.getString("delIds");//删除的信息ID
		if(!"".equals(delids)){
			String ArrayDATA_IDS[] = delids.split(",");
			nodeLevelFrameService.deleteAllRef(ArrayDATA_IDS);
		}
		
		String ids = pd.getString("dids");
		
		//如果ID为空，则直接返回
		if(ids == null){
			mv.addObject("msg","success");
			mv.setViewName("save_result");
			return mv;
		}
		
		String[] dids = pd.getString("dids").split(",");
		String[] levels = pd.getString("level").split(",");
		String[] projectNodeLevel = pd.getString("projectNodeLevel").split(",");
		
		List<PageData> addList = new ArrayList<>();
		List<PageData> upList = new ArrayList<>();
		for (int i = 0; i < dids.length; i++) {
			PageData pdd = new PageData();
			pdd.put("projectNodeLevelFrameId",pd.get("projectNodeLevelFrameId"));
			
			if (dids[i].equals("0")) {
				pdd.put("level", levels[i]);
				pdd.put("projectNodeLevel", projectNodeLevel[i]);
				addList.add(pdd);
			}else {
				pdd.put("ID", dids[i]);
				pdd.put("level", levels[i]);
				pdd.put("projectNodeLevel", projectNodeLevel[i]);
				upList.add(pdd);
			}
		}
		
		if(addList.size()>0){
			nodeLevelFrameService.addLevelFrameRelBatch(addList);
		}
		
		if(upList.size()>0){
			nodeLevelFrameService.upLevelFrameRelBatch(upList);
		}
		
		mv.addObject("msg","success");
		mv.setViewName("save_result");
		return mv;
	}
}
