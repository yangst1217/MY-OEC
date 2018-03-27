package com.mfw.service.bdata;

import java.util.List;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import com.mfw.dao.DaoSupport;
import com.mfw.entity.Page;
import com.mfw.util.PageData;

/**
 * 员工表Service
 * 创建日期：2015年12月11日
 * 修改日期：
 * TODO
 */

@Service("employeeService")
public class EmployeeService {
	
	@Resource(name = "daoSupport")
	private DaoSupport dao;
	
	/*
	 * 新增
	 */
	public void save(PageData pd) throws Exception {
		dao.save("EmployeeMapper.save", pd);
	}

	/*
	 * 删除
	 */
	public void delete(PageData pd) throws Exception {
		dao.delete("EmployeeMapper.delete", pd);
	}

	/*
	 * 修改
	 */
	public void edit(PageData pd) throws Exception {
		dao.update("EmployeeMapper.edit", pd);
	}

	/*
	 * 列表(全部)
	 */
	public List<PageData> listAll(String[] IDS) throws Exception {
		return (List<PageData>) dao.findForList("EmployeeMapper.listAllByIds", IDS);
	}

	/*
	 * 列表(全部)
	 */
	public List<PageData> listAll(PageData pd) throws Exception {
		return (List<PageData>) dao.findForList("EmployeeMapper.listAll", pd);
	}
	
	/*
	 * 列表(全部)
	 */
	public List<PageData> listAllLabour(PageData pd) throws Exception {
		return (List<PageData>) dao.findForList("EmployeeMapper.listAllLabour", pd);
	}
	
	/*
	 *列表(全部)
	 */
	public List<PageData> listPageEmp(Page page)throws Exception{
		return (List<PageData>)dao.findForList("EmployeeMapper.listPage", page);
	}
	
	public int countEmp(Page page) throws Exception{
		return (int) dao.findForObject("EmployeeMapper.countEmp", page);
	}
	
	/**
	 * 查找没有系统登录用户的员工
	 * @return
	 * 修改时间		修改人		修改内容
	 * 2016-03-24	李伟涛		新增
	 * @throws Exception 
	 */
	@SuppressWarnings("unchecked")
	public List<PageData> findEmpNotInUser() throws Exception{
		return (List<PageData>)dao.findForList("EmployeeMapper.findEmpNotInUser", null);
	}
	
	/*
	 * 通过部门id查找员工
	 */
	public List<PageData> findEmpByDept(String deptId) throws Exception {
		return (List<PageData>)dao.findForList("EmployeeMapper.findEmpByDept", deptId);
	}
	
	/*
	 * 通过id获取数据
	 */
	public PageData findById(PageData pd) throws Exception {
		return (PageData) dao.findForObject("EmployeeMapper.findById", pd);
	}
	
	/*
	 * 通过code获取数据
	 */
	public PageData findByCode(PageData pd) throws Exception {
		return (PageData) dao.findForObject("EmployeeMapper.findByCode", pd);
	}

	/*
	 * 批量删除
	 */
	public void deleteAll(String[] ArrayDATA_IDS) throws Exception {
		dao.delete("EmployeeMapper.deleteAll", ArrayDATA_IDS);
	}

	/*
	 * 批量获取
	 */
	public List<PageData> getAllById(String[] ArrayDATA_IDS) throws Exception {
		return (List<PageData>) dao.findForList("EmployeeMapper.getAllById", ArrayDATA_IDS);
	}
	
	/**
	 * 根据岗位ID查询该岗位的员工数
	 */
	public Integer findEmpByGradeId(Integer gradeId) throws Exception {
		return (Integer) dao.findForObject("EmployeeMapper.findEmpByGradeId", gradeId);
	}

	public List<PageData> findByDeptIds(List<String> ids) throws Exception {
		return (List<PageData>) dao.findForList("EmployeeMapper.findByDeptIds", ids);
	}

	/**
	 * 根据员工编码查询员工所在部门
	 */
	public PageData findDeptByEmpCode(String empCode) throws Exception{
		return (PageData) dao.findForObject("EmployeeMapper.findDeptByEmpCode", empCode);
	}

	/**
	 * 根据部门编码获取员工列表
	 * @param string
	 * @return
	 * @throws Exception 
	 */
	@SuppressWarnings("unchecked")
	public List<PageData> findEmpByDeptCode(String code) throws Exception {
		return (List<PageData>) dao.findForList("EmployeeMapper.findEmpByDeptCode", code);
	}
	
	/**
	 * 根据多个部门Id查询员工
	 */
	@SuppressWarnings("unchecked")
	public List<PageData> findEmpByDeptIds(List<Integer> deptIds) throws Exception{
		return (List<PageData>) dao.findForList("EmployeeMapper.findEmpByDeptIds", deptIds);
	}
	
	/**
	 * 根据用户编码批量查找
	 */
	public List<PageData> getAllByCodes(String[] ArrayDATA_CODES) throws Exception{
		return (List<PageData>) dao.findForList("EmployeeMapper.getAllByCodes", ArrayDATA_CODES);
	}
	
	/**
	 * 通过员工ID获取员工档案基础信息
	 */
	public PageData findRecord(PageData pd) throws Exception{
		return (PageData) dao.findForObject("EmployeeMapper.findRecord", pd);
	}
	
	/**
	 * 通过员工ID获取员工工作经历
	 */
	public List<PageData> findExp(PageData pd) throws Exception {
		return (List<PageData>) dao.findForList("EmployeeMapper.findExp", pd);
	}
	
	
	/**
	 * 新增员工档案基础信息
	 */
	public void saveRecord(PageData pd) throws Exception {
		dao.save("EmployeeMapper.saveRecord", pd);
	}
	
	/**
	 * 新增员工工作经历
	 */
	public void saveExp(PageData pd) throws Exception {
		dao.save("EmployeeMapper.saveExp", pd);
	}


	/**
	 * 修改员工档案基础信息
	 */
	public void editRecord(PageData pd) throws Exception {
		dao.update("EmployeeMapper.editRecord", pd);
	}
	
	
	
    /**
     *  批量新增工作经历
     */
    public void batchAdd(List<PageData> addList) throws Exception {
        dao.save("EmployeeMapper.batchAdd", addList);
    }

    /**
     *  批量更新工作经历
     */
    public void batchUpdate(PageData pd) throws Exception {
        dao.update("EmployeeMapper.batchUpdate", pd);
    }

    /**
     *  批量删除工作经历
     */
    public void batchDelete(PageData deletePd) throws Exception {
        dao.delete("EmployeeMapper.batchDelete", deletePd);
    }
    
    /**
     *  删除工作经历
     */
    public void deleteAllExp(PageData deletePd) throws Exception {
        dao.delete("EmployeeMapper.deleteAllExp", deletePd);
    }

    /**
     * 根据编码获取员工姓名
     * @param code
     * @return
     * @throws Exception
     */
    public String findCodeByName(String name) throws Exception{
    	return (String) dao.findForObject("EmployeeMapper.findCodeByName", name);
    }

    /**
     * 根据职位获取员工
     * @param positionId
     * @return
     * @throws Exception 
     */
	@SuppressWarnings("unchecked")
	public List<PageData> findEmpByPosition(String positionId) throws Exception {
		return (List<PageData>) dao.findForList("EmployeeMapper.findEmpByPosition", positionId);
	}
	
	/*
	 * 通过部门id查找员工，形成组织人员树查到的人员信息
	 */
	public List<PageData> findEmpByDeptPd(PageData pd) throws Exception {
		return (List<PageData>)dao.findForList("EmployeeMapper.findEmpByDeptPd", pd);
	}
	
	/**
	 *  根据员工编码查询岗位信息
	 */
	public PageData findPositionByEmpCode(String empCode) throws Exception {
		return (PageData) dao.findForObject("EmployeeMapper.findPositionByEmpCode", empCode);
	}
	
	/*
	 * 列表(全部)
	 */
	@SuppressWarnings("unchecked")
	public List<PageData> findAllEmpInfo(PageData pd) throws Exception {
		return (List<PageData>) dao.findForList("EmployeeMapper.findAllEmpInfo", pd);
	}
}
