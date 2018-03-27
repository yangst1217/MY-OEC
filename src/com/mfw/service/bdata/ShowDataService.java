package com.mfw.service.bdata;

import java.util.List;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import com.mfw.dao.DaoSupport;
import com.mfw.entity.Page;
import com.mfw.util.PageData;
@Service("showDataService")
public class ShowDataService extends DaoSupport{

	@Resource(name = "daoSupport")
	private DaoSupport dao;

	public List<PageData> findDeptByFun(PageData pd) throws Exception {
		return (List<PageData>)dao.findForList("showDataMapper.findDeptByFun",pd);
	}

	public List<PageData> findDeptByDis(PageData pd) throws Exception {
		return (List<PageData>)dao.findForList("showDataMapper.findDeptByDis", pd);
	}

	public List<PageData> findDept(PageData pd) throws Exception {
		return (List<PageData>)dao.findForList("showDataMapper.findDept", pd);
	}

	public PageData findDeptNameById(String deptId) throws Exception {
		return (PageData)dao.findForObject("showDataMapper.findDeptNameById", deptId);
	}

	public List<PageData> findEmpTaskList(Page page) throws Exception {
		return (List<PageData>)dao.findForList("showDataMapper.findEmpTasklistPage", page);
	}

	public PageData doQueryCurScore(PageData objPd) throws Exception {
		return (PageData)dao.findForObject("showDataMapper.doQueryCurScore", objPd);
	}

	public PageData queryBasicInfo(String empId) throws Exception {
		return (PageData)dao.findForObject("showDataMapper.queryBasicInfo", empId);
	}

	public List<PageData> queryRecordExp(Page page) throws Exception {
		return (List<PageData>)dao.findForList("showDataMapper.queryRecordExplistPage", page);
	}

	public List<PageData> empWeekTasklistPage(Page page) throws Exception {
		return (List<PageData>)dao.findForList("showDataMapper.empWeekTasklistPage", page);
	}

	public List<PageData> list(Page page) throws Exception {
		return (List<PageData>)dao.findForList("showDataMapper.targetlistPage", page);
	}

	public PageData queryPerInfo(PageData pageData) throws Exception {
		return (PageData)dao.findForObject("showDataMapper.queryPerInfo", pageData);
	}

	
}
