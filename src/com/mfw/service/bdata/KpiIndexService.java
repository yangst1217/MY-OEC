package com.mfw.service.bdata;

import java.util.List;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import com.mfw.dao.DaoSupport;
import com.mfw.util.PageData;

/**
 * emp_kpi_index表Service
 * 创建日期：2015年12月29日
 * 修改日期：
 * TODO
 */
@Service("kpiIndexService")
public class KpiIndexService {
	
	@Resource(name = "daoSupport")
	private DaoSupport dao;
	
	/*
	 * 新增
	 */
	public void save(PageData pd) throws Exception {
		dao.save("KpiIndexMapper.save", pd);
	}
	
	/*
	 * 修改
	 */
	public void edit(PageData pd) throws Exception {
		dao.update("KpiIndexMapper.edit", pd);
	}
	
	/*
	 * 删除
	 */
	public void delete(PageData pd) throws Exception {
		dao.delete("KpiIndexMapper.delete", pd);
	}
	
	/*
	 * 根据kpicode删除
	 */
	public void deleteByKpicode(PageData pd)throws Exception{
		dao.delete("KpiIndexMapper.deleteByKpicode", pd);
	}
	
	/*
	 * 通过EMP_ID获取数据列表
	 */
	public List<Object> findByEmpid(String empId)throws Exception{
		return (List<Object>)dao.findForList("KpiIndexMapper.findByEmpid", empId);
	}
	
}
