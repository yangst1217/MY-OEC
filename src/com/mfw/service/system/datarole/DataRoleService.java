package com.mfw.service.system.datarole;

import java.util.Date;
import java.util.List;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import com.mfw.dao.DaoSupport;
import com.mfw.entity.system.DataRole;
import com.mfw.util.PageData;
import com.mfw.util.UuidUtil;

/**
 * 用户数据权限Service层
 * @author liweitao
 *
 * 修改时间		修改人		修改内容
 * 2016-03-18	李伟涛		新建
 */
@Service("dataroleService")
public class DataRoleService {

	@Resource(name = "daoSupport")
	private DaoSupport dao;
	
	/**
	 * 根据用户ID获取数据权限
	 * @param userid
	 * @return
	 * @throws Exception
	 * 修改时间		修改人		修改内容
	 * 2016-03-18	李伟涛		新建
	 */
	@SuppressWarnings("unchecked")
	public List<PageData> findByUser(String userid) throws Exception{
		return (List<PageData>) dao.findForList("dataroleMapper.findByUser", userid);
	}
	
	/**
	 * 保存用户权限数据
	 * @param userId
	 * @param deptIds
	 * @param currentUserId
	 * @throws Exception
	 * 
	 * 修改时间		修改人		修改内容
	 * 2016-03-18	李伟涛		新建
	 */
	public void save(String userId, String deptIds, String currentUserId) throws Exception{
		//第一步，删除用户权限
		deleteByUser(userId);
		
		//第二步，根据组织机构拼成的字符串重新保存权限数据
		Date date = new Date();
		
		if(deptIds.length() > 0){
			String[] deptIdAry = deptIds.split(",");
			for(String deptId : deptIdAry){
				DataRole dataRole = new DataRole();
				dataRole.setID(UuidUtil.get32UUID());
				dataRole.setUSER_ID(userId);
				dataRole.setDEPT_ID(Integer.valueOf(deptId));
				dataRole.setCREATE_USER(currentUserId);
				dataRole.setCREATE_TIME(date);
				dao.save("dataroleMapper.save", dataRole);
			}
		}
	}
	
	/**
	 * 根据用户ID删除其相关数据权限
	 * @param userid
	 * @throws Exception 
	 * 修改时间		修改人		修改内容
	 * 2016-03-18	李伟涛		新建
	 */
	public void deleteByUser(String userid) throws Exception{
		dao.delete("dataroleMapper.delete", userid);
	}
}
