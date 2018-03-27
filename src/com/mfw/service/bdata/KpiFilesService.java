package com.mfw.service.bdata;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import com.mfw.dao.DaoSupport;
import com.mfw.entity.Page;
import com.mfw.util.PageData;

/**
 * bd_kpi_files表Service
 * 创建日期：2015年12月18日
 * 修改日期：
 * TODO
 */
@Service("kpiFilesService")
public class KpiFilesService {
	
	@Resource(name = "daoSupport")
	private DaoSupport dao;
	
	/*
	 * 新增
	 */
	public void save(PageData pd) throws Exception {
		dao.save("KpiFilesMapper.save", pd);
	}
	
	/*
	 * 新增
	 */
	public void saveDocument(PageData pd) throws Exception {
		dao.save("KpiFilesMapper.saveDocument", pd);
	}

	/*
	 * 删除
	 */
	public void delete(PageData pd) throws Exception {
		dao.delete("KpiFilesMapper.delete", pd);
	}

	/*
	 * 修改
	 */
	public void edit(PageData pd) throws Exception {
		dao.update("KpiFilesMapper.edit", pd);
	}

	/*
	 * 列表
	 */
	public List<PageData> list(Page page) throws Exception {
		return (List<PageData>) dao.findForList("KpiFilesMapper.datalistPage", page);
	}

	/*
	 * 列表(全部)
	 */
	public List<PageData> listAll(PageData pd) throws Exception {
		return (List<PageData>) dao.findForList("KpiFilesMapper.listAll", pd);
	}
	
	/*
	 * 验证部门KPI下是否有员工
	 */
	public int checkEmp(PageData pd) throws Exception {
		// TODO Auto-generated method stub
		int count = 0;
		Map result = (Map)dao.findForObject("KpiFilesMapper.checkEmp", pd);
		if(result.size()>0){
			count = Integer.parseInt(result.get("E").toString());
		}
		return count;
	}
	
	/*
	 * 已启用的列表
	 */
	public List<PageData> listAllEnab(PageData pd) throws Exception {
		return (List<PageData>) dao.findForList("KpiFilesMapper.listAllEnab", pd);
	}
	
	/*
	 * 列表(全部)
	 */
	public List<PageData> listAll(String[] IDS) throws Exception {
		return (List<PageData>) dao.findForList("KpiFilesMapper.listAllByIds", IDS);
	}
	
	/*
	 * 通过id获取数据
	 */
	public PageData findById(PageData pd) throws Exception {
		return (PageData) dao.findForObject("KpiFilesMapper.findById", pd);
	}
	
	/*
	 * 通过code获取数据
	 */
	public PageData findByCode(PageData pd) throws Exception {
		return (PageData) dao.findForObject("KpiFilesMapper.findByCode", pd);
	}

	/*
	 * 删除科目
	 */
	public void delTp(PageData pd) throws Exception {
		dao.update("KpiFilesMapper.delTp", pd);
	}
	
	
	/*
	 * 左侧列表(查询)
	 */
	public List<PageData> listAllByModelId(PageData pd) throws Exception {
		return (List<PageData>) dao.findForList("KpiFilesMapper.listAllByModelId", pd);
	}

	public List<PageData> findFileById(PageData pd) throws Exception  {
		return (List<PageData>) dao.findForList("KpiFilesMapper.findFileById", pd);
	}

	public PageData maxID(PageData pd) throws Exception {
		return (PageData) dao.findForObject("KpiFilesMapper.maxID", pd);
	}

	public PageData findByName(PageData pd) throws Exception {
		return (PageData) dao.findForObject("KpiFilesMapper.findByName", pd);
	}

	public List<PageData> findChildById(PageData pd) throws Exception {
		return (List<PageData>) dao.findForList("KpiFilesMapper.findChildById", pd);
	}

}
