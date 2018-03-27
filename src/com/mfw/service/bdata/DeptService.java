package com.mfw.service.bdata;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import com.mfw.dao.DaoSupport;
import com.mfw.entity.Page;
import com.mfw.entity.system.User;
import com.mfw.util.PageData;

@Service("deptService")
@SuppressWarnings("unchecked")
public class DeptService {

	@Resource(name = "daoSupport")
	private DaoSupport dao;
	
	/*
	 * 获取最大编码
	 */
	public String maxCode(PageData pd) throws Exception {
		return (String)dao.findForObject("DeptMapper.maxCode", pd);
	}
	
	/*
	 * 新增
	 */
	public void save(PageData pd) throws Exception {
		dao.save("DeptMapper.save", pd);
	}

	/*
	 * 删除
	 */
	public void delete(PageData pd) throws Exception {
		dao.delete("DeptMapper.delete", pd);
	}

	/*
	 * 修改
	 */
	public void edit(PageData pd) throws Exception {
		dao.update("DeptMapper.edit", pd);
	}

	/*
	 * 列表
	 */
	public List<PageData> list(Page page) throws Exception {
		return (List<PageData>) dao.findForList("DeptMapper.datalistPage", page);
	}

	/*
	 * 列表(全部)
	 */
	public List<PageData> listAll(PageData pd) throws Exception {
		return (List<PageData>) dao.findForList("DeptMapper.listAll", pd);
	}
	
	/*
	 * 列表(无参全部)
	 */
	public List<PageData> listAlln() throws Exception {
		return (List<PageData>) dao.findForList("DeptMapper.listAlln", null);
	}
	
	/**
	 * 根据当前登陆人的数据权限获取部门树节点
	 * @return
	 * @throws Exception
	 */
	public List<PageData> listWithAuth(User user) throws Exception{
		return (List<PageData>) dao.findForList("DeptMapper.listWithAuth", user);
	}

	/*
	 * 子部门列表(全部)
	 */
	public List<PageData> listChild(PageData pd) throws Exception {
		return (List<PageData>) dao.findForList("DeptMapper.listChild", pd);
	}
	/*
	 * 获取部门人数
	 */
	public PageData getENum(PageData pd) throws Exception {
		return (PageData)dao.findForObject("DeptMapper.getENum", pd);
	}
	
	/*
	 * 通过id获取数据
	 */
	public PageData findById(PageData pd) throws Exception {
		return (PageData) dao.findForObject("DeptMapper.findById", pd);
	}

	/*
	 * 通过标识获取ID
	 */
	public String findIdByS(PageData pd) throws Exception {
		return (String) dao.findForObject("DeptMapper.findIdByS", pd);
	}
	
	/*
	 * 批量删除
	 */
	public void deleteAll(String[] ArrayDATA_IDS) throws Exception {
		dao.delete("DeptMapper.deleteAll", ArrayDATA_IDS);
	}

	/*
	 * 批量获取
	 */
	public List<PageData> getAllById(String[] ArrayDATA_IDS) throws Exception {
		return (List<PageData>) dao.findForList("DeptMapper.getAllById", ArrayDATA_IDS);
	}

	/*
	 * 删除图片
	 */
	public void delTp(PageData pd) throws Exception {
		dao.update("DeptMapper.delTp", pd);
	}
	
	public List<PageData> findBudgetDeptList() throws Exception{
		
		return (List<PageData>) dao.findForList("DeptMapper.findBudgetDeptList", null);
	}
	
	public List<PageData> findForecastDeptList() throws Exception{
		
		return (List<PageData>) dao.findForList("DeptMapper.findForecastDeptList", null);
	}
	/*
	 * 验证编码和标识是否重复
	 */
	public int checkCode(PageData pd) throws Exception {
		// TODO Auto-generated method stub
		int count = 0;
		Map result = (Map)dao.findForObject("DeptMapper.checkCodeAndSign", pd);
		if(result.size()>0){
			count = Integer.parseInt(result.get("SL").toString());
		}
		return count;
	}
	/*
	 * 验证部门下是否有员工
	 */
	public int checkEmp(PageData pd) throws Exception {
		// TODO Auto-generated method stub
		int count = 0;
		Map result = (Map)dao.findForObject("DeptMapper.checkEmp", pd);
		if(result.size()>0){
			count = Integer.parseInt(result.get("E").toString());
		}
		return count;
	}
//--------------------------订单提交模块方法---------------------------
	/*
	 * 查询订单中未添加的部门
	 */
	public List<PageData> listnotInScall(PageData scaleData) throws Exception {
		return (List<PageData>) dao.findForList("DeptMapper.listnotInScall", scaleData);
	}
	/*
	 * 查询订单已添加的部门
	 */
	public List<PageData> findScaleDept(String orderId) throws Exception {
		return (List<PageData>)dao.findForList("DeptMapper.findScaleDept", orderId);
	}
//--------------------------订单提交模块方法---------------------------

    /**
     *  通过ID查询子部门
     *  @param ID
     *  @throws Exception
     *  author yangdw
     */
    public List<PageData> findSonDeptsById(String ID) throws Exception{
        return (List<PageData>)dao.findForList("DeptMapper.findSonDeptsById",ID);
    }

    /**
     * 根据部门名称获取部门ID
     * @param deptName
     * @return
     * @throws Exception
     */
	public String findIdByName(String deptName) throws Exception {
		PageData pageData = (PageData) dao.findForObject("DeptMapper.findIdByName",deptName);
		return pageData == null ? null : pageData.get("ID").toString();
	}

	/**
	 * 根据上级部门ID获取子部门ID
	 * @param pid
	 * @return
	 * @throws Exception 
	 */
	public List<String> finIdsByPid(String pid) throws Exception {
		return (List<String>) dao.findForList("DeptMapper.finIdsByPid", pid);
	}

    /**
     * 获得节点下所有经营体
     * @param deptId
     * @throws Exception
     * author yangdw
     */
    public List<PageData> getAllSonDepts(String deptId) throws Exception {

        List<PageData> deptList = new ArrayList<PageData>();

        PageData deptSearchpd = new PageData();
        deptSearchpd.put("ID",deptId);
        //加入它本身
        PageData dept = findById(deptSearchpd);
        deptList.add(dept);

        List<PageData> sonDeptList = findSonDeptsById(dept.get("ID").toString());
        if(null != sonDeptList && 0 < sonDeptList.size()){
            for (int i = 0;i < sonDeptList.size(); i ++){
                //放入它下一节点支上的所有部门
                deptList.addAll(getAllSonDepts(sonDeptList.get(i).get("ID").toString()));
            }
            return deptList;
        }else {
            return deptList;
        }
    }

    /**
     * 根据部门编码获取部门标识
     * @param deptCode
     * @return
     * @throws Exception
     */
	public String getSignByCode(String deptCode) throws Exception {
		return (String) dao.findForObject("DeptMapper.getSignByCode", deptCode);
	}
	
	/**
	 * 根据ID获取部门名称
	 * @param ids
	 * @return
	 * @throws Exception
	 */
	public List<String> findNameByIds(String[] ids) throws Exception{
		return (List<String>) dao.findForList("DeptMapper.getNameByIds", ids);
	}
	/**
	 * 根据标识获取部门
	 */
	public PageData findIdBySign(PageData pdc) throws Exception{
		return (PageData) dao.findForObject("DeptMapper.findIdBySign", pdc);
	}
	
}
