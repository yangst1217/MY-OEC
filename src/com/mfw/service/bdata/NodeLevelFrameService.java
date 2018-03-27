package com.mfw.service.bdata;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import com.mfw.dao.DaoSupport;
import com.mfw.entity.Page;
import com.mfw.util.PageData;

@Service("nodeLevelFrameService")
public class NodeLevelFrameService {
	
	@Resource(name = "daoSupport")
	private DaoSupport dao;
	
	public List<PageData> listAll(Page page) throws Exception {
		return (List<PageData>)dao.findForList("NodeLevelFrameMapper.listPage", page);
	}

	/**
	 * 查询所有职位，不分页
	 * @return
	 * @throws Exception
	 */
	@SuppressWarnings("unchecked")
	public List<PageData> findAll() throws Exception{
		return (List<PageData>)dao.findForList("NodeLevelFrameMapper.findAll", null);
	}
	
	public void add(PageData pd) throws Exception {
		// TODO Auto-generated method stub
		dao.findForList("NodeLevelFrameMapper.insertSelective", pd);
	}

	public PageData findById(PageData pd) throws Exception {
		// TODO Auto-generated method stub
		return (PageData) dao.findForObject("NodeLevelFrameMapper.selectByPrimaryKey", pd);
	}

	public PageData edit(PageData pd) throws Exception {
		// TODO Auto-generated method stub
		return (PageData) dao.findForObject("NodeLevelFrameMapper.updateByPrimaryKeySelective", pd);
	}

	public void delete(PageData pd) throws Exception {
		// TODO Auto-generated method stub
		dao.delete("NodeLevelFrameMapper.deleteByPrimaryKey", pd);
	}

	public void deleteAll(String[] ArrayDATA_IDS) throws Exception {
		// TODO Auto-generated method stub
		dao.delete("NodeLevelFrameMapper.deleteAll", ArrayDATA_IDS);
	}

	public int checkCode(PageData pd) throws Exception {
		// TODO Auto-generated method stub
		int count = 0;
		Map result = (Map)dao.findForObject("NodeLevelFrameMapper.checkCodeByProductCode", pd);
		if(result.size()>0){
			count = Integer.parseInt(result.get("SL").toString());
		}
		return count;
	}
	
	public List<PageData> findLevelFrameRel(PageData pd) throws Exception {
		return (List<PageData>)dao.findForList("NodeLevelFrameMapper.findLevelFrameRel", pd);
	}

	public List<PageData> findAllNodeList() throws Exception {
		// TODO Auto-generated method stub
		return (List<PageData>)dao.findForList("NodeLevelFrameMapper.findAllNodeList", null);
	}

	
	public void deleteAllRef(String[] ArrayDATA_IDS) throws Exception {
		// TODO Auto-generated method stub
		dao.delete("NodeLevelFrameMapper.deleteAllRef", ArrayDATA_IDS);
	}

	public void addLevelFrameRelBatch(List<PageData> addList) throws Exception {
		// TODO Auto-generated method stub
		dao.batchSave("NodeLevelFrameMapper.batchAdd", addList);
	}

	public void upLevelFrameRelBatch(List<PageData> upList) throws Exception {
		// TODO Auto-generated method stub
		dao.batchUpdate("NodeLevelFrameMapper.batchUpdate", upList);
	}
}
