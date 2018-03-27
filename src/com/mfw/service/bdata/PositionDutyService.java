/**
 * 
 */
package com.mfw.service.bdata;

import java.util.List;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import com.mfw.dao.DaoSupport;
import com.mfw.entity.system.User;
import com.mfw.util.PageData;

/**
 * bd_positions表Service
 * 创建日期：2016年5月13日
 * 修改日期：
 */

@Service("positionDutyService")
public class PositionDutyService {
	
	@Resource(name = "daoSupport")
	private DaoSupport dao;

	/*
	 * 新增
	 */
	public void save(PageData pd) throws Exception {
		dao.save("PositionDutyMapper.save", pd);
	}
	

	/*
	 * 删除
	 */
	public void delete(PageData pd) throws Exception {
		dao.delete("PositionDutyMapper.delete", pd);
	}
	

	/*
	 * 修改
	 */
	public void edit(PageData pd) throws Exception {
		dao.update("PositionDutyMapper.edit", pd);
	}

	/*
	 * 列表
	 */
	public List<PageData> listDuty(PageData pd) throws Exception {
		return (List<PageData>) dao.findForList("PositionDutyMapper.listDuty", pd);
	}
	
	/*
	 * 列表
	 */
	public PageData findCode(PageData pd) throws Exception {
		return (PageData) dao.findForObject("PositionDutyMapper.findCode", pd);
	}
	
	/*
	 * 根据岗位CODE查岗位
	 */
	public PageData findDutyByCode(PageData pd) throws Exception {
		return (PageData) dao.findForObject("PositionDutyMapper.findDutyByCode", pd);
	}
	
	
	/*
	 * 根据岗位ID查询岗位CODE
	 */
	public PageData findCodeById(PageData pd) throws Exception {
		return (PageData) dao.findForObject("PositionDutyMapper.findCodeById", pd);
	}
	/*
	 * 新增明细
	 */
	public void saveDetail(PageData pd) throws Exception {
		dao.save("PositionDutyMapper.saveDetail", pd);
	}
	

	/*
	 * 批量删除明细
	 */
	public void batchDeleteDetail(PageData pd) throws Exception {
		dao.delete("PositionDutyMapper.batchDeleteDetail", pd);
	}
	
	/*
	 * 删除明细
	 */
	public void deleteDetail(PageData pd) throws Exception {
		dao.delete("PositionDutyMapper.deleteDetail", pd);
	}

	/*
	 * 修改 明细
	 */
	public void editDetail(PageData pd) throws Exception {
		dao.update("PositionDutyMapper.editDetail", pd);
	}

	/*
	 * 跟据ID查询岗位职责
	 */
	public PageData findById(PageData pd) throws Exception{
		return (PageData) dao.findForObject("PositionDutyMapper.findById", pd);
	}


	/*
	 * 跟据岗位ID查询明细
	 */
	public List<PageData> findDetailByPId(PageData pd) throws Exception {
		return (List<PageData>) dao.findForList("PositionDutyMapper.findDetailByPId", pd);
	}
	
	/*
	 * 跟据ID查询明细
	 */
	public PageData findDetailById(PageData pd) throws Exception{
		return (PageData) dao.findForObject("PositionDutyMapper.findDetailById", pd);
	}


	/*
	 * 查询岗位
	 */
	public List<PageData> findPosition(PageData pd) throws Exception {
		return (List<PageData>) dao.findForList("PositionDutyMapper.findPosition", pd);
	}

	/**
	 * 根据登录用户获取未收藏的岗位职业
	 * @param user
	 * @throws Exception 
	 */
	@SuppressWarnings("unchecked")
	public List<PageData> findDutyByUser(User user) throws Exception {
		return (List<PageData>)dao.findForList("PositionDutyMapper.findDutyByUser", user.getNUMBER());
	}

	/**
	 * 根据登录用户获取常用的岗位职责
	 * @param user
	 * @return
	 * @throws Exception 
	 */
	@SuppressWarnings("unchecked")
	public List<PageData> findCommonDuty(User user) throws Exception {
		return (List<PageData>)dao.findForList("PositionDutyMapper.findCommonDury", user.getNUMBER());
	}
	
	/**
	 * 检查当前日晴助手是否已收藏
	 */
	public Integer checkCollection(PageData pageData) throws Exception{
		return (Integer) dao.findForObject("PositionDutyMapper.checkCollection", pageData);
	}

	/**
	 * 收藏日清助手
	 */
	public Integer addCollection(PageData pageData) throws Exception{
		return (Integer) dao.save("PositionDutyMapper.addCollection", pageData);
	}

	/**
	 * 移除日清助手收藏
	 */
	public Integer removeCollection(PageData pageData) throws Exception{
		return (Integer) dao.delete("PositionDutyMapper.removeCollection", pageData);
	}


	/**
	 * 查询所有岗位职责
	 * @return
	 * @throws Exception
	 */
	@SuppressWarnings("unchecked")
	public List<PageData> findAll() throws Exception{
		return (List<PageData>)dao.findForList("PositionDutyMapper.findAll", null);
	}


	/**
	 * 查询当前岗位下是否有某一职责
	 * @return
	 * @throws Exception
	 */
	public PageData findByRes(PageData pd) throws Exception{
		return (PageData) dao.findForObject("PositionDutyMapper.findByRes", pd);
	}


	public PageData findDetailByRes(PageData pd) throws Exception{
		return (PageData) dao.findForObject("PositionDutyMapper.findDetailByRes", pd);
	}

	/**
	 * 查询岗位所有的岗位职责明细
	 */
	@SuppressWarnings("unchecked")
	public List<PageData> findAllDetailByEmpCode(String empCode) throws Exception{
		return (List<PageData>) dao.findForList("PositionDutyMapper.findAllDetailByEmpCode", empCode);
	}
}