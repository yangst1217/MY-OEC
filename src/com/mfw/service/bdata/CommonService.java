package com.mfw.service.bdata;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import com.mfw.entity.system.User;
import com.mfw.util.Const;

import org.apache.shiro.SecurityUtils;
import org.apache.shiro.session.Session;
import org.apache.shiro.subject.Subject;
import org.springframework.stereotype.Service;

import com.mfw.dao.DaoSupport;
import com.mfw.util.PageData;

@Service("commonService")
public class CommonService {
	
	@Resource(name = "daoSupport")
	private DaoSupport dao;
	
	
	/**
	 * 获取数据字典中子类类型
	 * @param bianma 父节点的编码名
	 * @return list
	 * @throws Exception
	 */
	public List<PageData> typeListByBm(String bianma) throws Exception {
		return (List<PageData>) dao.findForList("DictionariesMapper.typeListByBm", bianma);
	}

	/**
	 * 获取数据字典中ZD_ID
	 * @param bianma 编码名
	 * @return list
	 * @throws Exception
	 */
	public String findIdByBm(String bianma) throws Exception {
		// TODO Auto-generated method stub
		return (String) dao.findForObject("DictionariesMapper.findIdByBm", bianma);
	}

	public String getKpiRatio(String bianma) throws Exception {
		// TODO Auto-generated method stub
		return (String) dao.findForObject("RatioModelMapper.getKpiRatio", bianma);
	}
	/*
	* 获取部门数据(除了公司以外)
	*/
	public List<PageData> findDeptNoCom(PageData pd)throws Exception{
		return (List<PageData>)dao.findForList("DeptMapper.findDeptNoCom", pd);
	}
	
	/*
	* 获取用户部门数据(根据当前用户)
	*/
	public String findDeptByUser(PageData pd)throws Exception{
		return (String)dao.findForObject("ProjectMapper.findDeptByUser", pd);
	}
	
	/*
	* 获取用户部门数据(根据ID)
	*/
	public PageData findDeptById(String dept_id)throws Exception{
		return (PageData)dao.findForObject("ProjectMapper.findDeptById",dept_id);
	}
	
	/*
	* 获取订单数据(根据部门)
	*/
	public List<PageData> findProByDept(PageData pd)throws Exception{
		return (List<PageData>)dao.findForList("ProjectMapper.findProByDept", pd);
	}
	
	
	/*
	* 获取下级部门数据(根据ID)
	*/		
	public List<PageData> findChildDeptById(PageData pd)throws Exception{
		return (List<PageData>)dao.findForList("ProjectMapper.findChildDeptById", pd);
	}

    /**
     * 获取员工数据权限部门
     * @throws Exception
     * author yangdw
     */
    public List<PageData> getSysDeptList() throws Exception {
        Subject currentUser = SecurityUtils.getSubject();
        Session session = currentUser.getSession();
        //获得登录用户
        User user = (User) session.getAttribute(Const.SESSION_USER);
        String USER_ID = "";
        PageData pd = new PageData();
        if(!"admin".equals(user.getUSERNAME())){
            USER_ID = user.getUSER_ID().toString();
            pd.put("USER_ID",USER_ID);
            return (List<PageData>) dao.findForList("DeptMapper.getSysDeptList", pd);
        }else {
            pd.put("USER_ID",USER_ID);
            return (List<PageData>) dao.findForList("DeptMapper.getSysDeptList", pd);
        }
    }
    
	public int checkSysRole(String roleId) throws Exception {
		// TODO Auto-generated method stub
		int count = 0;
		Map result = (Map)dao.findForObject("RoleMapper.checkSysRole", roleId);
		if(result.size()>0){
			count = Integer.parseInt(result.get("SL").toString());
		}
		return count;
	}
	
	
	/**
     * 获取所有状态
     * @throws Exception
     * author yyz
     */
    public List<PageData> getStatusList(PageData pd) throws Exception {
           return (List<PageData>) dao.findForList("StatusMapper.listAll", pd);
    }
    
    /**
	* 根据部门ID获取下级部门列表
	*/		
	@SuppressWarnings("unchecked")
	public List<PageData> findChildDeptByDeptId(PageData pd)throws Exception{
		return (List<PageData>)dao.findForList("DeptMapper.findChildDeptById", pd);
	}
	
	/**
	 * 根据员工编码（empCode）查询员工所在部门
	 */
	public PageData findDeptByEmpCode(String empCode) throws Exception{
		return (PageData) dao.findForObject("EmployeeMapper.findDeptByEmpCode", empCode);
	}
	
	
    /**
	* 查看是否是领导
	*/
	public int checkLeader(PageData pd) throws Exception {
		// TODO Auto-generated method stub
		int count = 0;
		PageData result = (PageData) dao.findForObject("RoleMapper.checkLeader", pd);
		if(result!=null){
			count = 1;
		}
		return count;
	}
	
	/**
	 * 获取消息提醒收据
	 * @param EMP_CODE
	 * @return
	 * @throws Exception
	 */
	@SuppressWarnings("unchecked")
	public List<PageData> showMsgData(String EMP_CODE) throws Exception{
		return (List<PageData>) dao.findForList("showDataMapper.showMsgData", EMP_CODE);
	}
	
	/**
	 * 查询部门负责人
	 */
	public PageData findDeptLeader(String deptId) throws Exception{
		return (PageData) dao.findForObject("DeptMapper.findDeptLeader", deptId);
	}
	
	/**
	 * 查询员工负责的部门
	 */
	@SuppressWarnings("unchecked")
	public List<PageData> findDeptInCharge(String empCode) throws Exception{
		return (List<PageData>) dao.findForList("DeptMapper.findDeptInCharge", empCode);
	}
	
	/**
	 * 查询拥有某个部门数据权限的部长级别以上的领导
	 */
	@SuppressWarnings("unchecked")
	public List<PageData> findEmpCodeInDataRoleByDeptId(Integer detptId) throws Exception{
		return (List<PageData>) dao.findForList("dataroleMapper.findEmpCodeInDataRoleByDeptId", detptId);
	}
	
	/**
	 * 获取是否为副总权限
	 * @param roleId
	 * @return
	 * @throws Exception 
	 */
	public int checkFzRole(String roleId) throws Exception {
		// TODO Auto-generated method stub
		int count = 0;

		Map result = (Map)dao.findForObject("RoleMapper.checkFzRole", roleId);		
		
		if(result.size()>0){
			count = Integer.parseInt(result.get("SL").toString());
		}
		return count;
	}
}
