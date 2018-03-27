package com.mfw.service.flow;

import java.util.ArrayList;
import java.util.List;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import com.mfw.dao.DaoSupport;
import com.mfw.service.bdata.DeptService;
import com.mfw.util.PageData;

/**
 * Service - 流程模板
 * @author 李伟涛
 *
 */
@Service
public class FlowModelService {

	@Resource(name = "daoSupport")
	private DaoSupport dao;
	@Resource(name = "deptService")
	private DeptService deptService;
	
	/**
	 * 获取流程模板树节点
	 * @param id 如果ID为空则获取根节点
	 * @return
	 * @throws Exception 
	 */
	@SuppressWarnings("unchecked")
	public List<PageData> getFlowModelTreeNode(Integer id) throws Exception{
		id = (id == null ? 0 : id);
		return (List<PageData>) dao.findForList("FlowModelMapper.getFlowModelTreeNode", id);
	}

	/**
	 * 保存流程模板信息
	 * @param pageData
	 * @throws Exception 
	 */
	public void save(PageData pageData) throws Exception {
		dao.save("FlowModelMapper.save", pageData);
	}

	public void update(PageData pageData) throws Exception {
		dao.update("FlowModelMapper.update", pageData);
	}

	/**
	 * 检查模板编码是否可用
	 * @param code
	 * @throws Exception 
	 */
	public String checkCode(PageData pageData) throws Exception {
		int count = (int) dao.findForObject("FlowModelMapper.checkCode", pageData);
		return count == 0 ? "true" : "false";
	}

	/**
	 * 根据ID获取流程模板信息
	 * @param id
	 * @return
	 * @throws Exception 
	 */
	public PageData findById(Integer id) throws Exception {
		PageData flowModel = (PageData) dao.findForObject("FlowModelMapper.findById", id);
		String[] deptIds = flowModel.get("DEPT_ID").toString().split(",");
		String names = deptService.findNameByIds(deptIds).toString();
		flowModel.put("DEPT_NAME", names.substring(1,names.length()-1));
		return flowModel;
	}
	
	/**
	 * 根据ID删除节点及其字节点
	 * @param id
	 * @throws Exception 
	 */
	public void removeModel(Integer id) throws Exception {
		List<Integer> ids = new ArrayList<>();
		ids.add(id);
		
		if(getFlowModelTreeNode(id).size() > 0){
			ids.addAll(getChildIds(id)) ;
		}
		
		dao.update("FlowModelMapper.removeModel", ids);
	}
	
	private List<Integer> getChildIds(Integer id) throws Exception{
		List<Integer> ids = new ArrayList<>();
		List<PageData> nodes = (List<PageData>) getFlowModelTreeNode(id);
		
		for(PageData pageData : nodes){
			int currentId = Integer.valueOf(pageData.get("ID").toString());
			ids.add(currentId);
			if(getFlowModelTreeNode(id).size() > 0){
				getChildIds(currentId);
			}
		}
		
		return ids;
	}

	/**
	 * 根据模板ID获取流程节点数量
	 * @param pid
	 * @return
	 * @throws Exception
	 */
	public Integer countNode(String pid) throws Exception {
		return (Integer) dao.findForObject("FlowModelMapper.checkNode", pid);
	}

	/**
	 * 根据模板编号获取模板对象
	 * @param code
	 * @return
	 * @throws Exception 
	 */
	public PageData findByCode(String code) throws Exception {
		return (PageData) dao.findForObject("FlowModelMapper.findByCode", code);
	}
}
