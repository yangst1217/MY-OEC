package com.mfw.service.repository;

import java.util.List;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import com.mfw.dao.DaoSupport;
import com.mfw.entity.Page;
import com.mfw.util.PageData;

@Service("repositoryService")
public class RepositoryService {
	
	@Resource(name = "daoSupport")
	private DaoSupport dao;

	@SuppressWarnings("unchecked")
	public List<PageData> list(Page page) throws Exception{
		return (List<PageData>)dao.findForList("repositoryMapper.listPage", page);
	}

	public void save(PageData pd) throws Exception {
		dao.save("repositoryMapper.save", pd);
	}

	public PageData findById(PageData pd) throws Exception {
		return (PageData)dao.findForObject("repositoryMapper.findById", pd);
	}

	public void edit(PageData pd) throws Exception {
		dao.update("repositoryMapper.edit", pd);
		
	}

	public void delete(PageData pd) throws Exception {
		dao.update("repositoryMapper.delete", pd);
		
	}
	
	public void saveIssued(PageData pd) throws Exception {
		dao.save("repositoryMapper.saveIssued", pd);
	}
	
	public void deleteIssued(PageData pd) throws Exception {
		dao.update("repositoryMapper.deleteIssued", pd);
		
	}
	public PageData findIssuedById(PageData pd) throws Exception{
		return (PageData)dao.findForObject("repositoryMapper.findIssuedById", pd);
	}
	
	public void updateIssued(PageData pd) throws Exception{
		dao.update("repositoryMapper.updateIssued", pd);
	}
	
	public List<PageData> findIssuedOpinions(PageData pd) throws Exception{
		return (List<PageData>) dao.findForList("repositoryMapper.findIssuedOpinions", pd);
	}
	
	public List<PageData> listByDeptId(Page page) throws Exception{
		return (List<PageData>) dao.findForList("repositoryMapper.findByDeptIdlistPage", page);
	}
}
