package com.mfw.controller.flow;

import java.util.List;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletResponse;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import com.google.gson.Gson;
import com.mfw.controller.base.BaseController;
import com.mfw.service.bdata.DeptService;
import com.mfw.service.flow.FlowModelNodeService;
import com.mfw.service.flow.FlowModelService;
import com.mfw.util.Const;
import com.mfw.util.FileDownload;
import com.mfw.util.PageData;
import com.mfw.util.PathUtil;

import net.sf.json.JSONArray;

/**
 * Controller - 流程模板
 * @author 李伟涛
 *
 */
@Controller
@RequestMapping("flowModel")
public class FlowModelController extends BaseController {

	@Resource
	private FlowModelService flowModelService;
	@Resource(name = "deptService")
	private DeptService deptService;
	@Resource
	private FlowModelNodeService flowModelNodeService;
	
	/**
	 * 跳转流程模板页面
	 * @return
	 */
	@RequestMapping("flowModelList")
	public ModelAndView flowModelList(){
		ModelAndView modelAndView = new ModelAndView();
		
		try {
			List<PageData> deptList = deptService.listAlln();
			JSONArray arr = JSONArray.fromObject(deptList);
			modelAndView.addObject("depts", arr.toString());
			
			
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		modelAndView.setViewName("flow/flow_model_list");
		return modelAndView;
	}
	
	/**
	 * 获取流程模板树节点
	 * @param id
	 * @return
	 */
	@ResponseBody
	@RequestMapping("getFlowModelTreeNode")
	public List<PageData> getFlowModelTreeNode(Integer ID){
		try {
			return flowModelService.getFlowModelTreeNode(ID);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return null;
	}
	
	/**
	 * 打开流程模板新增页面
	 * @return
	 */
	@RequestMapping("goAdd")
	public ModelAndView goAdd(Integer pid){
		ModelAndView modelAndView = new ModelAndView();
		try {
			//列出所有部门
			List<PageData> deptList = deptService.listWithAuth(getUser());
			JSONArray arr = JSONArray.fromObject(deptList);
			modelAndView.addObject("deptTreeNodes", arr.toString());
			
			PageData pageData = getPageData();
			pageData.put("PARENT_ID", pid);
			modelAndView.addObject("flowModel", pageData);
			modelAndView.setViewName("flow/flow_model_add");
		} catch (Exception e) {
			e.printStackTrace();
		}
		return modelAndView;
	}
	
	/**
	 * 下载模版
	 */
	@RequestMapping(value = "/downExcel")
	public void downExcel(HttpServletResponse response) throws Exception {
		FileDownload.fileDownload(response, PathUtil.getClasspath() + Const.FILEPATHFILE + "流程模板.xls", "流程模板.xls");
	}
	
	/**
	 * 跳转至流程模板编辑页面
	 * @param id
	 * @return
	 */
	@ResponseBody
	@RequestMapping("goEdit")
	public ModelAndView goEdit(Integer id){
		ModelAndView modelAndView = getModelAndView();
		try {
			PageData flowModel = flowModelService.findById(id);
			
			//列出所有部门
			List<PageData> deptList = deptService.listWithAuth(getUser());
			for(String nodeId : flowModel.get("DEPT_ID").toString().split(",")){
				for(PageData pageData : deptList){
					if( nodeId.equals(pageData.get("ID").toString()) ){
						pageData.put("checked", "true");
					}
				}
			}
			JSONArray arr = JSONArray.fromObject(deptList);
			modelAndView.addObject("deptTreeNodes", arr.toString());
			
			modelAndView.addObject("flowModel", flowModelService.findById(id));
		} catch (Exception e) {
			e.printStackTrace();
		}
		modelAndView.setViewName("flow/flow_model_add");
		return modelAndView;
	}
	
	/**
	 * 保存
	 * @param pageData
	 * @return
	 */
	@RequestMapping("save")
	public ModelAndView save(){
		PageData pageData = getPageData();
		ModelAndView mv = this.getModelAndView();
		try {
			String id = (String) pageData.get("ID");
			if(id.length() == 0){
				savePage(pageData);
				flowModelService.save(pageData);
			}else{
				updatePage(pageData);
				flowModelService.update(pageData);
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		mv.addObject("msg", "success");
		mv.setViewName("save_result");
		return mv;
	}
	
	/**
	 * 检查模板编码是否可用
	 * @return
	 */
	@ResponseBody
	@RequestMapping("checkCode")
	public String checkCode(){
		PageData pageData = getPageData();
		try {
			return flowModelService.checkCode(pageData);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return "false";
	}
	
	/**
	 * 删除节点及其子节点
	 * @param id
	 * @return
	 */
	@ResponseBody
	@RequestMapping("removeModel")
	public String removeModel(Integer id){
		try {
			flowModelService.removeModel(id);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return "success";
	}
	
	@ResponseBody
	@RequestMapping("countNode")
	public Integer countNode(String pid){
		try {
			return flowModelService.countNode(pid);
		} catch (Exception e) {
			e.printStackTrace();
			return 0;
		}
	}
	
	/**
	 * 显示流程图
	 * @return
	 */
	@RequestMapping("showImage")
	public ModelAndView showImage(Integer id){
		ModelAndView modelAndView = new ModelAndView();
		Gson gson = new Gson();
		try {
			modelAndView.addObject("nodes", gson.toJson(flowModelNodeService.findNodesByModel(id)));
		} catch (Exception e) {
			e.printStackTrace();
		}
		modelAndView.setViewName("flow/flow_model_image");
		return modelAndView;
	}
}
