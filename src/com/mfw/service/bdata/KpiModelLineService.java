package com.mfw.service.bdata;

import java.util.List;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import com.mfw.dao.DaoSupport;
import com.mfw.entity.Page;
import com.mfw.util.PageData;

/**
 * bd_kpi_model_line表Service
 * 创建日期：2015年12月23日
 * 修改日期：
 * TODO
 */
@Service("kpiModelLineService")
public class KpiModelLineService {
	
	@Resource(name = "daoSupport")
	private DaoSupport dao;
	
	/*
	* 新增
	*/
	public void save(PageData pd)throws Exception{
		dao.save("KpiModelLineMapper.save", pd);
	}
	
	/*
	* 删除
	*/
	public void delete(PageData pd)throws Exception{
		dao.delete("KpiModelLineMapper.delete", pd);
	}
	
	/*
	 * 修改
	 */
	public void edit(PageData pd)throws Exception{
		dao.update("KpiModelLineMapper.edit", pd);
	}
	
	/*
	 * 通过kpicode修改
	 */
	public void updateByKpicode(PageData pd)throws Exception{
		dao.update("KpiModelLineMapper.updateByKpicode", pd);
	}
	
	/*
	*列表
	*/
	public List<PageData> list(Page page)throws Exception{
		return (List<PageData>)dao.findForList("KpiModelLineMapper.datalistPage", page);
	}
	
	/*
	*列表(全部)
	*/
	public List<PageData> listAll(PageData pd)throws Exception{
		return (List<PageData>)dao.findForList("KpiModelLineMapper.listAll", pd);
	}
	
	/*
	 *列表(全部)名称根据模板ID
	 */
	public List<Object> listAllByModelId(String model_id)throws Exception{
		return (List<Object>)dao.findForList("KpiModelLineMapper.listAllByModelId", model_id);
	}
	
	/*
	*列表该预算模板下该部门可用的科目（属于该模板且其余部门未使用的）
	*/
	public List<Object> listAllByModelId(PageData pd)throws Exception{
		return (List<Object>)dao.findForList("KpiModelLineMapper.listAllByModelIdAndDeptId", pd);
	}
	
	/*
	*列表(全部)科目根据模板ID
	*/
	public List<PageData> listAllSubByModelId(String model_id)throws Exception{
		return (List<PageData>)dao.findForList("KpiModelLineMapper.listAllSubByModelId", model_id);
	}
	
	/*
	* 通过id获取数据
	*/
	public PageData findById(PageData pd)throws Exception{
		return (PageData)dao.findForObject("KpiModelLineMapper.findById", pd);
	}
	
	/*
	 * 通过code获取数据
	 */
	public PageData findByCode(PageData pd)throws Exception{
		return (PageData)dao.findForObject("KpiModelLineMapper.findByCode", pd);
	}
	
	/*
	* 批量删除
	*/
	public void deleteAll(String[] ArrayDATA_IDS)throws Exception{
		dao.delete("KpiModelLineMapper.deleteAll", ArrayDATA_IDS);
	}
	
	/*
	* 批量删除
	*/
	public void deleteAllByModelId(PageData pd)throws Exception{
		dao.delete("KpiModelLineMapper.deleteAllByModelId", pd);
	}
	
	/*
	 * 根据kpicode删除
	 */
	public void deleteByKpicode(PageData pd)throws Exception{
		dao.delete("KpiModelLineMapper.deleteByKpicode", pd);
	}
	
	
	/*
	 * 更新
	 */
	public void updateScore(PageData pd) throws Exception{
    	dao.save("KpiModelLineMapper.updateScore", pd);
    }	
}
