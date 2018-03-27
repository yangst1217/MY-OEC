package com.mfw.service.system.role;

import java.util.HashSet;
import java.util.List;
import java.util.Set;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import com.mfw.dao.DaoSupport;
import com.mfw.entity.system.Role;
import com.mfw.util.PageData;

@Service("roleService")
public class RoleService {

	@Resource(name = "daoSupport")
	private DaoSupport dao;

	@SuppressWarnings("unchecked")
	public List<Role> listAllERRoles() throws Exception {
		return (List<Role>) dao.findForList("RoleMapper.listAllERRoles", null);

	}

	public List<Role> listAllappERRoles() throws Exception {
		return (List<Role>) dao.findForList("RoleMapper.listAllappERRoles", null);

	}

	public List<Role> listAllRoles() throws Exception {
		return (List<Role>) dao.findForList("RoleMapper.listAllRoles", null);

	}

	//通过当前登录用的角色id获取管理权限数据
	public PageData findGLbyrid(PageData pd) throws Exception {
		return (PageData) dao.findForObject("RoleMapper.findGLbyrid", pd);
	}

	//通过当前登录用的角色id获取用户权限数据
	public PageData findYHbyrid(PageData pd) throws Exception {
		return (PageData) dao.findForObject("RoleMapper.findYHbyrid", pd);
	}

	//列出此角色下的所有用户
	public List<PageData> listAllUByRid(PageData pd) throws Exception {
		return (List<PageData>) dao.findForList("RoleMapper.listAllUByRid", pd);

	}

	//列出此角色下的所有会员
	public List<PageData> listAllAppUByRid(PageData pd) throws Exception {
		return (List<PageData>) dao.findForList("RoleMapper.listAllAppUByRid", pd);

	}

	/**
	 * 列出此部门的所有下级
	 */
	public List<Role> listAllRolesByPId(PageData pd) throws Exception {
		return (List<Role>) dao.findForList("RoleMapper.listAllRolesByPId", pd);

	}

	//列出K权限表里的数据 
	public List<PageData> listAllkefu(PageData pd) throws Exception {
		return (List<PageData>) dao.findForList("RoleMapper.listAllkefu", pd);
	}

	//列出G权限表里的数据 
	public List<PageData> listAllGysQX(PageData pd) throws Exception {
		return (List<PageData>) dao.findForList("RoleMapper.listAllGysQX", pd);
	}

	//删除K权限表里对应的数据
	public void deleteKeFuById(String ROLE_ID) throws Exception {
		dao.delete("RoleMapper.deleteKeFuById", ROLE_ID);
	}

	//删除G权限表里对应的数据
	public void deleteGById(String ROLE_ID) throws Exception {
		dao.delete("RoleMapper.deleteGById", ROLE_ID);
	}

	public void deleteRoleById(String ROLE_ID) throws Exception {
		dao.delete("RoleMapper.deleteRoleById", ROLE_ID);

	}

	public Role getRoleById(String roleId) throws Exception {
		return (Role) dao.findForObject("RoleMapper.getRoleById", roleId);

	}

	public void updateRoleRights(Role role) throws Exception {
		dao.update("RoleMapper.updateRoleRights", role);
	}

	/**
	 * 权限(增删改查)
	 */
	public void updateQx(String msg, PageData pd) throws Exception {
		dao.update("RoleMapper." + msg, pd);
	}

	/**
	 * 客服权限
	 */
	public void updateKFQx(String msg, PageData pd) throws Exception {
		dao.update("RoleMapper." + msg, pd);
	}

	/**
	 * Gc权限
	 */
	public void gysqxc(String msg, PageData pd) throws Exception {
		dao.update("RoleMapper." + msg, pd);
	}

	/**
	 * 给全部子职位加菜单权限
	 */
	public void setAllRights(PageData pd) throws Exception {
		dao.update("RoleMapper.setAllRights", pd);

	}

	/**
	 * 添加
	 */
	public void add(PageData pd) throws Exception {
		dao.findForList("RoleMapper.insert", pd);
	}

	/**
	 * 保存客服权限
	 */
	public void saveKeFu(PageData pd) throws Exception {
		dao.findForList("RoleMapper.saveKeFu", pd);
	}

	/**
	 * 保存G权限
	 */
	public void saveGYSQX(PageData pd) throws Exception {
		dao.findForList("RoleMapper.saveGYSQX", pd);
	}

	/**
	 * 通过id查找
	 */
	public PageData findObjectById(PageData pd) throws Exception {
		return (PageData) dao.findForObject("RoleMapper.findObjectById", pd);
	}

	/**
	 * 编辑角色
	 */
	public PageData edit(PageData pd) throws Exception {
		return (PageData) dao.findForObject("RoleMapper.edit", pd);
	}
	
	/**
	 * 通过用户名获取所有角色
	 * 目前用户与角色为一一对应关系，即user表中包含role_id字段
	 * @param username
	 * @return
	 * @throws Exception 
	 */
	public Set<String> findRoles(String username) throws Exception {
		// TODO Auto-generated method stub
		List<String> list = (List<String>)dao.findForList("RoleMapper.getRolesByName", username);
		Set<String> set=new HashSet<String>(); 
		if(list.size()>0){
			set.addAll(list);//给set填充
		}
		return set;
	}
	
	/**
	 * 通过用户名获取所有按钮权限
	 * @param username
	 * @return
	 * @throws Exception 
	 */
	public Set<String> findPermissions(String username) throws Exception {
		// TODO Auto-generated method stub
		List<String> list = (List<String>)dao.findForList("RoleMapper.getPermissionsByName", username);
		Set<String> set=new HashSet<String>(); 
		if(list.size()>0){
			set.addAll(list);//给set填充
		}
		return set;
	}

	@SuppressWarnings("unchecked")
	public List<PageData> getBtnRoleListByParams(PageData pd) throws Exception {
		return (List<PageData>) dao.findForList("RoleMapper.getBtnRoleListByParams", pd);
	}

	public void addRoleButton(PageData pd) throws Exception {
		dao.findForList("RoleButtonMapper.insert", pd);
	}

	public void deleteRoleButton(PageData pd) throws Exception {
		dao.findForList("RoleButtonMapper.delete", pd);
	}
	
	/**
	 * 根据角色名获取角色ID
	 * @param deptName
	 * @return
	 * @throws Exception
	 * 修改时间		修改人		修改内容
	 * 2016-03-28	李伟涛		新增
	 */
	public String findRoleIdByName(String deptName) throws Exception{
		String result = "";
		List<String> queryList = (List<String>) dao.findForList("RoleMapper.findRoleIdByName", deptName);
		if(queryList.size() > 0){
			result = queryList.get(0);
		}
		return result;		
	}

	/**
	 * 根据ID数组获取角色名
	 * @param ids
	 * @return
	 * @throws Exception
	 */
	@SuppressWarnings("unchecked")
	public String findNameByIds(String[] ids) throws Exception {
		List<String> result =  (List<String>) dao.findForList("RoleMapper.findNameByIds", ids);
		StringBuffer stringBuffer = new StringBuffer();
		for(String str : result){
			stringBuffer.append(str).append("、");
		}
		return stringBuffer.toString();
	}

}
