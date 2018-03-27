package com.mfw.service.bdata;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import com.mfw.dao.DaoSupport;
import com.mfw.entity.Page;
import com.mfw.util.PageData;

@Service("salaryShowService")
@SuppressWarnings("unchecked")
public class SalaryShowService {
	@Resource(name = "daoSupport")
	private DaoSupport dao;


	public List<PageData> list(Page page) throws Exception {
		return (List<PageData>)dao.findForList("salaryShowMapper.listPage", page);
	}


	public List<PageData> queryDept(PageData pd) throws Exception {
		return (List<PageData>)dao.findForList("salaryShowMapper.queryDept",pd);
		
	}


	public List<PageData> queryPos(PageData pd) throws Exception {
		return (List<PageData>)dao.findForList("salaryShowMapper.queryPos", pd);
	}


	public PageData findById(PageData pd) throws Exception {
		return (PageData)dao.findForObject("salaryShowMapper.findById", pd);
	}


	public List<PageData> queryItem(PageData pd) throws Exception {
		return (List<PageData>)dao.findForList("salaryShowMapper.queryItem", pd);
	}


	public void updateSal(PageData pd) throws Exception {
		dao.update("salaryShowMapper.updateSal", pd);
	}


	public void updateDetail(PageData pd) throws Exception {
		dao.update("salaryShowMapper.updateDetail", pd);
	}

	/**
	 * 查询员工薪酬数据是否存在
	 * @param pd
	 * @return
	 * @throws Exception
	 */
	public List<PageData> checkExist(PageData pd) throws Exception {
		return (List<PageData>)dao.findForList("salaryShowMapper.checkExist", pd);
	}


	public void addData(PageData pd) throws Exception {
		dao.save("salaryShowMapper.addData", pd);
	}


	public void editData(PageData pd) throws Exception {
		dao.update("salaryShowMapper.editData", pd);
		
	}


	public PageData queryFormula(PageData pd) throws Exception {
		return (PageData)dao.findForObject("salaryShowMapper.queryFormula", pd);
	}


	public List<PageData> queryDetail(PageData pd) throws Exception {
		return (List<PageData>)dao.findForList("salaryShowMapper.queryDetail", pd);
	}


	public void saveDetail(PageData pd) throws Exception {
		dao.save("salaryShowMapper.saveDetail", pd);
		
	}


	public void delDetail(PageData pd) throws Exception {
		dao.delete("salaryShowMapper.delDetail", pd);
	}


	public List<PageData> findCurData(PageData pd) throws Exception {
		return (List<PageData>)dao.findForList("salaryShowMapper.findCurData", pd);
	}


	public List<PageData> findLastData(PageData pd) throws Exception {
		return (List<PageData>)dao.findForList("salaryShowMapper.findLastData", pd);
	}


	public void doAddSal(PageData pd) throws Exception {
		dao.save("salaryShowMapper.doAddSal", pd);
	}


	public void doAddSalDetail(PageData pd) throws Exception {
		dao.save("salaryShowMapper.doAddSalDetail", pd);
	}


	public List<PageData> findSalInfo(PageData pd) throws Exception {
		return (List<PageData>)dao.findForList("salaryShowMapper.findSalInfo", pd);
	}


	public PageData queryPer(PageData pd) throws Exception {
		return (PageData)dao.findForObject("salaryShowMapper.queryPer", pd);
	}
}
