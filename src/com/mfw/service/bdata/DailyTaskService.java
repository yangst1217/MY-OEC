package com.mfw.service.bdata;

import java.util.List;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import com.mfw.dao.DaoSupport;
import com.mfw.entity.Page;
import com.mfw.util.PageData;

@Service("dailytaskService")
public class DailyTaskService {

	@Resource(name = "daoSupport")
	private DaoSupport dao;

	/*
	 * 新增
	 */
	public void save(PageData pd) throws Exception {
		dao.save("DailyTaskMapper.save", pd);
	}

	/*
	 * 删除
	 */
	public void delete(PageData pd) throws Exception {
		dao.delete("DailyTaskMapper.delete", pd);
	}

	/*
	 * 修改
	 */
	public void edit(PageData pd) throws Exception {
		dao.update("DailyTaskMapper.edit", pd);
	}

	/*
	 * 列表
	 */
	public List<PageData> list(Page page) throws Exception {
		return (List<PageData>) dao.findForList("DailyTaskMapper.datalistPage", page);
	}

	/*
	 * 列表(全部)
	 */
	public List<PageData> listAll(PageData pd) throws Exception {
		return (List<PageData>) dao.findForList("DailyTaskMapper.listAll", pd);
	}
	
	/*
	 * 列表(全部)
	 */
	public List<PageData> listAllByModelId(PageData pd) throws Exception {
		return (List<PageData>) dao.findForList("DailyTaskMapper.listAllByIds", pd);
	}

	/*
	 * 通过id获取数据
	 */
	public PageData findById(PageData pd) throws Exception {
		return (PageData) dao.findForObject("DailyTaskMapper.findById", pd);
	}
	
	/*
	 * 通过根据上级ID获取最大编码
	 */
	public String maxCode(PageData pd) throws Exception {
		return (String) dao.findForObject("DailyTaskMapper.maxCode", pd);
	}
	/*
	 * 通过名称获取ID
	 */
	public String findIdByN(PageData pd) throws Exception {
		return (String) dao.findForObject("DailyTaskMapper.findIdByN", pd);
	}
	/*
	 * 通过code获取数据
	 */
	public PageData findByCode(PageData pd) throws Exception {
		return (PageData) dao.findForObject("DailyTaskMapper.findByCode", pd);
	}

	/*
	 * 批量删除
	 */
	public void deleteAll(String[] ArrayDATA_IDS) throws Exception {
		dao.delete("DailyTaskMapper.deleteAll", ArrayDATA_IDS);
	}

	/*
	 * 批量获取
	 */
	public List<PageData> getAllById(String[] ArrayDATA_IDS) throws Exception {
		return (List<PageData>) dao.findForList("DailyTaskMapper.getAllById", ArrayDATA_IDS);
	}

	/*
	 * 删除科目
	 */
	public void delTp(PageData pd) throws Exception {
		dao.update("DailyTaskMapper.delTp", pd);
	}

}
