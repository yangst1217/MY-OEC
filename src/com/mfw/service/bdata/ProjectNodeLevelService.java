package com.mfw.service.bdata;

import java.util.ArrayList;
import java.util.List;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import com.mfw.dao.DaoSupport;
import com.mfw.entity.Page;
import com.mfw.entity.system.User;
import com.mfw.util.PageData;

@Service("projectNodeLevelService")
public class ProjectNodeLevelService {

	@Resource(name = "daoSupport")
	private DaoSupport dao;
	/*
	 * 新增
	 */
	public void add(PageData pd) throws Exception {
		dao.save("ProjectNodeLevelMapper.insert", pd);
	}
	/*
	 * 删除
	 */
	public void delete(PageData pd) throws Exception {
		dao.save("ProjectNodeLevelMapper.delete", pd);
	}
	/*
	 * 修改
	 */
	public void edit(PageData pd) throws Exception {
		dao.save("ProjectNodeLevelMapper.edit", pd);
	}
	/*
	 * 列表
	 */
	public List<PageData> list(Page page) throws Exception {
		return (List<PageData>) dao.findForList("ProjectNodeLevelMapper.listPage", page);
	}
	/*
	 * 列表
	 */
	public List<PageData> listP(PageData pd) throws Exception {
		return (List<PageData>) dao.findForList("ProjectNodeLevelMapper.listP", pd);
	}
	/*
	 * 通过ID获取
	 */
	public PageData findById(PageData pd) throws Exception {
		return (PageData) dao.findForObject("ProjectNodeLevelMapper.findById", pd);
	}
	/*
	* 可选角色
	*/
	public List<PageData> roleList(String[] IDS) throws Exception{
		return (List<PageData>) dao.findForList("ProjectNodeLevelMapper.roleList",IDS);
	}
	
	/*
	* 所有角色
	*/
	public List<PageData> roleListAll(PageData pd) throws Exception{
		return (List<PageData>) dao.findForList("ProjectNodeLevelMapper.roleListAll",pd);
	}

	/**
	 * 根据节点获取下级可用节点层级
	 * @param pageData
	 * @param user 
	 * @return
	 * @throws Exception 
	 */
	@SuppressWarnings("unchecked")
	public List<PageData> findLevelsByNode(PageData pageData, User user) throws Exception {
		List<PageData> temp_result = (List<PageData>) dao.findForList(
				"ProjectNodeLevelMapper.findLevelsByNode", pageData);
		List<PageData> result = new ArrayList<>();
		
		String roleId = user.getROLE_ID();
		for(PageData data : temp_result){
			String[] ids = data.getString("ROLEIDS").split(",");
			for(String id : ids){
				if(id.equals(roleId)){
					result.add(data);
				}
			}
		}
		return result;
	}
}
