package com.mfw.service.task;

import java.util.List;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import com.mfw.dao.DaoSupport;
import com.mfw.util.PageData;

@Service("flowTaskService")
public class FlowTaskService {
	
	@Resource(name="daoSupport")
	private DaoSupport dao;

	/**
	 * 更新流程工作节点信息
	 */
	public void updateFlowWorkNode(PageData pd) throws Exception{
		dao.update("FlowTaskMapper.updateFlowWorkNode", pd);
	}
	
	/**
	 * 保存流程工作历史记录
	 */
	public void saveFlowWorkHistory(PageData pd) throws Exception{
		dao.save("FlowTaskMapper.saveFlowWorkHistory", pd);
	}
	
	/**
	 * 保存流程节点时间信息
	 */
	public void saveFlowNodeTime(PageData pd) throws Exception{
		dao.save("FlowTaskMapper.saveFlowNodeTime", pd);
	}

	/**
	 * 更新节点时间
	 */
	public void updateFlowNodeTime(PageData pd) throws Exception{
		dao.update("FlowTaskMapper.updateFlowNodeTime", pd);
	}
	
	/**
	 * 查询当前节点实例上可以启动的子流程模板
	 */
	@SuppressWarnings("unchecked")
	public List<PageData> findFlowByFlowWorkNodeId(PageData pd) throws Exception{
		return (List<PageData>) dao.findForList("FlowTaskMapper.findFlowByFlowWorkNodeId", pd);
	}
	
	/**
	 * 查询流程实例下的所有节点实例
	 */
	@SuppressWarnings("unchecked")
	public List<PageData> findAllNodeByFLowWorkId(PageData pd) throws Exception{
		return (List<PageData>) dao.findForList("FlowTaskMapper.findAllNodeByFLowWorkId", pd);
	}

	/**
	 * 更新流程状态
	 */
	public void endFlow(PageData pd)  throws Exception{
		dao.update("FlowTaskMapper.endFlow", pd);
	}
	
	/**
	 * 根据节点ID查询节点信息
	 */
	public PageData findFlowWorkNodeById(Integer id) throws Exception{
		return (PageData) dao.findForObject("FlowTaskMapper.findFlowWorkNodeById", id);
	}
}
