package com.mfw.service.performance;

import java.util.List;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import com.mfw.dao.DaoSupport;
import com.mfw.entity.Page;
import com.mfw.util.PageData;

@Service("performanceService")
public class PerformanceService {
	
	@Resource(name = "daoSupport")
	private DaoSupport dao;

	@SuppressWarnings("unchecked")
	public List<PageData> list(Page page) throws Exception{
		return (List<PageData>)dao.findForList("performanceMapper.listPage", page);
	}
	
	public List<PageData> excelList(PageData pd) throws Exception{
		return (List<PageData>)dao.findForList("performanceMapper.excelList", pd);
	}

	//保存绩效主表
	public Object savePerf(PageData pd) throws Exception {
		return dao.save("performanceMapper.savePerf", pd);
	}
	
	//保存绩效子表
	public void savePerfDetail(PageData pd) throws Exception {
		dao.save("performanceMapper.savePerfDetail", pd);
		
	}
	
	//编辑绩效主表
	public Object editPerf(PageData pd) throws Exception {
		return dao.save("performanceMapper.editPerf", pd);
	}
	
	//编辑绩效子表
	public void editPerfDetail(PageData pd) throws Exception {
		dao.save("performanceMapper.editPerfDetail", pd);
		
	}

	public PageData findById(PageData pd) throws Exception {
		return (PageData)dao.findForObject("performanceMapper.findById", pd);
	}

	public void edit(PageData pd) throws Exception {
		dao.update("performanceMapper.edit", pd);
		
	}

//	public void delete(PageData pd) throws Exception {
//		dao.update("performanceMapper.delete", pd);
//		
//	}

	//已有打分记录，通过绩效考核主表id在考核表取值
	@SuppressWarnings("unchecked")
	public List<PageData> getScoreByPerfId(PageData pd) throws Exception{
		return (List<PageData>)dao.findForList("performanceMapper.getScoreByPerfId", pd);
	}
	
	//未打分，通过人员对应的kpi模板id去kpi库中取值
	@SuppressWarnings("unchecked")
	public List<PageData> getScoreByEmpCode(PageData pd) throws Exception{
		return (List<PageData>)dao.findForList("performanceMapper.getScoreByEmpCode", pd);
	}
	
	/*
	 * 通过sql获取百分比小数
	 */
	public String getPercent(PageData pd) throws Exception {
		return (String) dao.findForObject("performanceMapper.getPercent", pd);
	}
	
	/**
	 * 根据员工（请求参数：empCode）查询周工作任务列表;
	 * 领导（请求参数：deptCode）可以查看部门下所有的任务
	 */
	@SuppressWarnings("unchecked")
	public List<PageData> empWeekTasklistPage(Page page) throws Exception{
		return (List<PageData>) dao.findForList("performanceMapper.empWeekTasklistPage", page);
	}
}
