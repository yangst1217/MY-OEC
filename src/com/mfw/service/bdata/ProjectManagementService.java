package com.mfw.service.bdata;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import com.mfw.dao.DaoSupport;
import com.mfw.entity.Page;
import com.mfw.util.PageData;

@Service("projectManagementService")
public class ProjectManagementService {
	
	@Resource(name = "daoSupport")
	private DaoSupport dao;
	
	public List<PageData> listAll(Page page) throws Exception {
		return (List<PageData>)dao.findForList("ProjectManagementMapper.listPage", page);
	}

	/**
	 * 查询所有职位，不分页
	 * @return
	 * @throws Exception
	 */
	@SuppressWarnings("unchecked")
	public List<PageData> findAll() throws Exception{
		return (List<PageData>)dao.findForList("ProjectManagementMapper.findAll", null);
	}
	
	public void add(PageData pd) throws Exception {
		// TODO Auto-generated method stub
		dao.findForList("ProjectManagementMapper.insertSelective", pd);
	}

	public PageData findById(PageData pd) throws Exception {
		// TODO Auto-generated method stub
		return (PageData) dao.findForObject("ProjectManagementMapper.findObjectById", pd);
	}
	
	public PageData findByViewId(PageData pd) throws Exception {
		// TODO Auto-generated method stub
		return (PageData) dao.findForObject("ProjectManagementMapper.findByViewId", pd);
	}
	
	public PageData findByCode(PageData pd) throws Exception {
		// TODO Auto-generated method stub
		return (PageData) dao.findForObject("ProjectManagementMapper.findByCode", pd);
	}
	
	public PageData findByName(PageData pd) throws Exception {
		// TODO Auto-generated method stub
		return (PageData) dao.findForObject("ProjectManagementMapper.findByName", pd);
	}
	
	public void deleteAll(String[] ArrayDATA_IDS) throws Exception {
		// TODO Auto-generated method stub
		dao.delete("ProjectManagementMapper.deleteAll", ArrayDATA_IDS);
	}

	public int checkCode(PageData pd) throws Exception {
		// TODO Auto-generated method stub
		int count = 0;
		Map result = (Map)dao.findForObject("ProjectManagementMapper.checkCodeByGradeCode", pd);
		if(result.size()>0){
			count = Integer.parseInt(result.get("SL").toString());
		}
		return count;
	}
	
	public List<PageData> findLevelByDeptId(String deptId) throws Exception {
		return (List<PageData>)dao.findForList("ProjectManagementMapper.findLevelByDeptId", deptId);
	}
	
	/*
	 * depList列表(全部)
	 */
	public List<PageData> depList(PageData pd) throws Exception {
		return (List<PageData>) dao.findForList("ProjectManagementMapper.depList", pd);
	}
	
	/*
	 * salary列表(全部)
	 */
	public List<PageData> salaryList(PageData pd) throws Exception {
		return (List<PageData>) dao.findForList("ProjectManagementMapper.salaryList", pd);
	}
	
	/*
	 * operList列表(全部)
	 */
	public List<PageData> operList(PageData pd) throws Exception {
		return (List<PageData>) dao.findForList("ProjectManagementMapper.operList", pd);
	}
	
	/*
	 * edit列表(全部)
	 */
	public List<PageData> findByEditId(PageData pd) throws Exception {
		return (List<PageData>) dao.findForList("ProjectManagementMapper.findByEditId", pd);
	}
	
	public PageData findById2(String pd) throws Exception {
		return (PageData) dao.findForObject("ProjectManagementMapper.findById", pd);
	}
	
	/*
	 * 保存薪资方案
	 */
	public void save(PageData pd) throws Exception {
		dao.save("ProjectManagementMapper.save", pd);
	}
	
	/*
	 * 保存薪资方案明细
	 */
	public void saveDet(PageData pd) throws Exception {
		dao.save("ProjectManagementMapper.saveDet", pd);
	}
	
	/*
	 * 修改薪资方案
	 */
	public void update(PageData pd) throws Exception {
		dao.update("ProjectManagementMapper.edit", pd);
	}
	
	/*
	 * 删除薪资方案明细
	 */
	public void deleteDet(PageData pd) throws Exception {
		dao.delete("ProjectManagementMapper.deleteDet", pd);
	}
	
	/*
	 * 删除薪资方案
	 */
	public void delete(PageData pd) throws Exception {
		dao.update("ProjectManagementMapper.delete", pd);
		dao.delete("PositionFormulaMapper.delete", pd);
	}
	
	/*
	 * 获取最大编码
	 */
	public String maxCode(PageData pd) throws Exception {
		return (String) dao.findForObject("ProjectManagementMapper.maxCode", pd);
	}
	
}
