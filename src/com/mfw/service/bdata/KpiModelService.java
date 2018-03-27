package com.mfw.service.bdata;

import java.util.List;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import com.mfw.dao.DaoSupport;
import com.mfw.entity.Page;
import com.mfw.util.PageData;

/**
 * bd_kpi_model表Service
 * 创建日期：2015年12月22日
 * 修改日期：
 * TODO
 */
@Service("kpiModelService")
public class KpiModelService {
	
	@Resource(name = "daoSupport")
	private DaoSupport dao;
	
	/*
	* 新增
	*/
	public Object save(PageData pd)throws Exception{
		return dao.save("KpiModelMapper.save", pd);
	}
	
//	/*
//	* 删除
//	*/
//	public void delete(PageData pd)throws Exception{
//		dao.delete("KpiModelMapper.delete", pd);
//	}
	
	/*
	 * 逻辑删除
	 */
	public void delete(PageData pd)throws Exception{
		dao.update("KpiModelMapper.delete", pd);
	}
	
	/*
	 * 逻辑删除
	 */
	public void delete(String MODEL_ID)throws Exception{
		dao.update("KpiModelMapper.delete", MODEL_ID);
	}
	
	/*
	* 修改
	*/
	public void edit(PageData pd)throws Exception{
		dao.update("KpiModelMapper.edit", pd);
	}
	
	/*
	*列表
	*/
	public List<PageData> list(Page page)throws Exception{
		return (List<PageData>)dao.findForList("KpiModelMapper.datalistPage", page);
	}
	
	/*
	*列表(全部)
	*/
	public List<PageData> listAll(PageData pd)throws Exception{
		return (List<PageData>)dao.findForList("KpiModelMapper.listAll", pd);
	}
	
	/*
	*列表(全部)
	*/
	public PageData listAllForCount(PageData pd)throws Exception{
		return (PageData)dao.findForObject("KpiModelMapper.listAllForCount", pd);
	}
	
	/*
	 * 查询已启用列表
	 */
	public List<PageData> listAllEnable(PageData pd)throws Exception{
		return (List<PageData>)dao.findForList("KpiModelMapper.listAllEnable", pd);
	}
	
	/*
	 *再用模板列表(全部)
	 */
	public List<PageData> listAllUsedModel(PageData pd)throws Exception{
		return (List<PageData>)dao.findForList("KpiModelMapper.listAllUsedModel", pd);
	}
	
	/*
	* 通过id获取数据
	*/
	public PageData findById(PageData pd)throws Exception{
		return (PageData)dao.findForObject("KpiModelMapper.findById", pd);
	}
	
	/*
	 * 通过id获取数据
	 */
	public PageData findById(String MODEL_ID)throws Exception{
		return (PageData)dao.findForObject("KpiModelMapper.findById", MODEL_ID);
	}
	
	/*
	* 批量删除
	*/
	public void deleteAll(String[] ArrayDATA_IDS)throws Exception{
		dao.delete("KpiModelMapper.deleteAll", ArrayDATA_IDS);
	}

	public PageData findByCode(PageData pdc)throws Exception{
		return (PageData)dao.findForObject("KpiModelMapper.findByCode", pdc);
	}
}
