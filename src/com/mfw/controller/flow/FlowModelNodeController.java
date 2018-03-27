package com.mfw.controller.flow;

import java.io.IOException;

import javax.annotation.Resource;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.ModelAndView;

import com.mfw.controller.base.BaseController;
import com.mfw.entity.GridPage;
import com.mfw.service.flow.FlowModelNodeService;
import com.mfw.util.PageData;

/**
 * Controller - 流程模板节点
 * @author 李伟涛
 *
 */
@Controller
@RequestMapping("flowModelNode")
public class FlowModelNodeController extends BaseController {

	@Resource
	private FlowModelNodeService flowModelNodeService;
	
	/**
	 * 根据流程模板获取对应的模板节点
	 * @param id
	 * @return
	 */
	@ResponseBody
	@RequestMapping("findNodesByModel")
	public GridPage findNodesByModel(Integer id){
		try {
			if(id != null){
				return new GridPage(flowModelNodeService.findNodesByModel(id), 0, 0, 0);
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return null;
	}
	
	/**
	 * 保存流程模板节点
	 * @param pageData
	 * @return
	 */
	@ResponseBody
	@RequestMapping("saveNode")
	public String saveNode(){
		PageData pageData = parseFormData(getPageData());
		try {
			if(pageData.get("ID") == null){
				savePage(pageData);
				flowModelNodeService.saveNode(pageData);
			}else{
				updatePage(pageData);
				flowModelNodeService.updateNode(pageData);
			}
		} catch (Exception e) {
			e.printStackTrace();
			return "failed";
		}
		return "success";
	}
	
	/**
	 * 从Excel中导入
	 * @param file
	 * @return
	 */
	@RequestMapping("readExcel")
	public ModelAndView readExcel(@RequestParam(value = "excel", required = false) MultipartFile file, String modelId){
		ModelAndView modelAndView = new ModelAndView();
		try {
			flowModelNodeService.saveImportExcel(file, modelId);
			modelAndView.setViewName("save_result");
		} catch (IOException e) {
			e.printStackTrace();
		} catch (Exception e) {
			e.printStackTrace();
		}
		return modelAndView;
	}
	
	/**
	 * 上传界面跳转
	 * @return
	 */
	@RequestMapping("toUpload")
	public ModelAndView toUpload(String modelId){
		ModelAndView modelAndView = new ModelAndView();
		modelAndView.addObject("modelId", modelId);
		modelAndView.setViewName("flow/flow_import");
		return modelAndView;
	}
	
	/**
	 * 删除流程节点
	 * @param id
	 * @return
	 */
	@ResponseBody
	@RequestMapping("delNode")
	public String delNode(String id){
		try {
			flowModelNodeService.delNode(id);
		} catch (Exception e) {
			e.printStackTrace();
			return "failed";
		}
		return "success";
	}
	
	private PageData parseFormData(PageData pageData){
		PageData result = new PageData();
		for(int i = 0; i < pageData.size() / 2; i++){
			result.put(pageData.get("nodes[" + i + "][name]"), pageData.get("nodes[" + i + "][value]"));
		}
		
		String deptId = (String) result.get("DEPT_ID");
		result.put("DEPT_ID", deptId.equals("") ? null : Integer.valueOf(deptId));
		
		String positionId = (String) result.get("POSITION_ID");
		if(positionId != null && !positionId.equals("")){
			result.put("POSITION_ID", Integer.valueOf(positionId));
		}
		
		return result;
	}
	
}
