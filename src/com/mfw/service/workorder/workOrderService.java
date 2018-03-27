package com.mfw.service.workorder;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import com.mfw.dao.DaoSupport;
import com.mfw.entity.Page;
import com.mfw.service.bdata.EmployeeService;
import com.mfw.util.EndPointServer;
import com.mfw.util.PageData;
import com.mfw.util.TaskType;

@Service("workOrderService")
@SuppressWarnings("unchecked")
public class workOrderService {

	@Resource(name = "daoSupport")
	private DaoSupport dao;
	
	@Resource(name = "employeeService")
	private EmployeeService employeeService;
	
	public void save(PageData pd) throws Exception {
		dao.save("workOrderMapper.save", pd);
	}

	public void delete(PageData pd) throws Exception {
		dao.save("workOrderMapper.delete", pd);
	}

	public void update(PageData pd) throws Exception {
		dao.save("workOrderMapper.update", pd);
	}
	
	public void updateExam(PageData pd) throws Exception {
		dao.save("workOrderMapper.updateExam", pd);
	}
	
	public void updateExamDail(PageData pd) throws Exception {
		dao.save("workOrderMapper.updateExamDail", pd);
	}
	
	public void updateExamDailSave(PageData pd) throws Exception {
		dao.save("workOrderMapper.updateExamDailSave", pd);
	}
	
	public void updateExamDailKpi(PageData pd) throws Exception {
		dao.save("workOrderMapper.updateExamDailKpi", pd);
	}
	
	public void updateExamDetail(PageData pd) throws Exception {
		dao.save("workOrderMapper.updateExamDetail", pd);
	}
	
	public List<PageData> findByTargeType(PageData pd) throws Exception {
		return (List<PageData>) dao.findForList("workOrderMapper.findByTargeType", pd);
	}
	
	public List<PageData> dailytaskinformationList(PageData pd) throws Exception {
		return (List<PageData>) dao.findForList("workOrderMapper.dailytaskinformationList", pd);
	}
	
	public List<PageData> dailytaskinformationListId(PageData pd) throws Exception {
		return (List<PageData>) dao.findForList("workOrderMapper.dailytaskinformationListId", pd);
	}
	
	public PageData findDeptByUserId(PageData pd) throws Exception {
		return (PageData) dao.findForObject("workOrderMapper.findDeptByUserId", pd);
	}
	
	
	public PageData FindDailyWorkById(PageData pd) throws Exception {
		return (PageData) dao.findForObject("workOrderMapper.FindDailyWorkById", pd);
	}
	
	public PageData findDeptByUserId1(PageData pd) throws Exception {
		return (PageData) dao.findForObject("workOrderMapper.findDeptByUserId1", pd);
	}
	//findDeptByEmpName
	
	public PageData findDeptByEmpName(PageData pd) throws Exception {
		return (PageData) dao.findForObject("workOrderMapper.findDeptByEmpName", pd);
	}
	
	public PageData findSysName(PageData pd) throws Exception {
		return (PageData) dao.findForObject("workOrderMapper.findSysName", pd);
	}
	
	
	public List<PageData> FindDailyIdOne(PageData pd) throws Exception {
		return (List<PageData>) dao.findForList("workOrderMapper.FindDailyIdOne", pd);
	}
	
	public List<PageData> list(Page page) throws Exception {
		return (List<PageData>) dao.findForList("workOrderMapper.dailytaskinformationlistPage", page);
	}
	
	//临时任务审核列表
	public List<PageData> checkList(Page page) throws Exception {
		return (List<PageData>) dao.findForList("workOrderMapper.dailytaskinformationChecklistPage", page);
	}
	
	public List<PageData> examlist(Page page) throws Exception {
		return (List<PageData>) dao.findForList("workOrderMapper.dailyWorklistPage", page);
	}
	
	public List<PageData> viewlist(Page page) throws Exception {
		return (List<PageData>) dao.findForList("workOrderMapper.dailytaskinformationviewlistPage", page);
	}

	public PageData findById(PageData pd) throws Exception {
		return (PageData) dao.findForObject("workOrderMapper.FinddailytaskinformationById", pd);
	}
	
	public PageData FindChkId(PageData pd) throws Exception {
		return (PageData) dao.findForObject("workOrderMapper.FindChkId", pd);
	}
	
	
	
	public List<PageData> findByPathId(PageData pd) throws Exception {
		return (List<PageData>) dao.findForList("workOrderMapper.findByPathId", pd);
	}

	public void save2(PageData pd) throws Exception {
		dao.save("workOrderMapper.save2", pd);
	}
	
	public void save3(PageData pd) throws Exception {
		dao.save("workOrderMapper.save3", pd);
	}
	
	public PageData findByCode(String id) throws Exception {
		return (PageData)dao.findForObject("workOrderMapper.findByCode", id);
	}
	
	public List<PageData> findByCode2(String id) throws Exception {
		return (List<PageData>)dao.findForList("workOrderMapper.findByCode", id);
	}
	
	public void edit2(PageData pd) throws Exception {
		dao.update("workOrderMapper.edit2", pd);
	}
	
	public void back(PageData pd) throws Exception {
		dao.update("workOrderMapper.back", pd);
	}
	
	public void updateStatus(PageData pd) throws Exception {
		dao.update("workOrderMapper.updateStatus", pd);
	}
	
	public void delById(String id) throws Exception {
		dao.delete("workOrderMapper.delById", id);
	}

	public List<PageData> listByOrderId(String id) throws Exception {
		return (List<PageData>)dao.findForList("workOrderMapper.listByOrderId", id);
	}

	@SuppressWarnings("unchecked")
	public List<PageData> s161list() throws Exception {
		return (List<PageData>) dao.findForList("workOrderMapper.s161List",null);
	}
	
	@SuppressWarnings("unchecked")
    public String getNewCode(PageData pd) throws Exception {
        return (String) dao.findForObject("workOrderMapper.getNewCode", pd);
    }
	
	@SuppressWarnings("unchecked")
	public List<PageData> listKpi(PageData pd) throws Exception {
		return (List<PageData>) dao.findForList("workOrderMapper.listKpi",pd);
	}
	
	@SuppressWarnings("unchecked")
	public List<PageData> listKpi1(PageData pd) throws Exception {
		return (List<PageData>) dao.findForList("workOrderMapper.listKpi1",pd);
	}
	
	@SuppressWarnings("unchecked")
	public List<PageData> listKpi2(PageData pd) throws Exception {
		return (List<PageData>) dao.findForList("workOrderMapper.listKpi2",pd);
	}
	
	public PageData KpiName(PageData pd) throws Exception {
		return (PageData)dao.findForObject("workOrderMapper.KpiName", pd);
	}
	
	public PageData TargetName(PageData pd) throws Exception {
		return (PageData)dao.findForObject("workOrderMapper.TargetName", pd);
	}
	
	public PageData PathName(PageData pd) throws Exception {
		return (PageData)dao.findForObject("workOrderMapper.PathName", pd);
	}
	
	public void updateExamAll(String[] ArrayDATA_IDS) throws Exception {
		dao.delete("workOrderMapper.updateExamAll", ArrayDATA_IDS);
	}
	
	public void updateExamAllList(String[] ArrayDATA_IDS) throws Exception {
		dao.update("workOrderMapper.updateExamAllList", ArrayDATA_IDS);
	}
	
	
	public void updateExamDetailAllList(PageData pd) throws Exception {
		dao.update("workOrderMapper.updateExamDetailAllList", pd);
	}

	/**
	 * 保存附件
	 * @param pd
	 * @throws Exception 
	 */
	public void saveAttachments(PageData pd) throws Exception {
		dao.save("workOrderMapper.saveAttachments", pd);
	}

	/**
	 * 根据临时工作ID获取附件
	 * @param id
	 * @return
	 * @throws Exception 
	 */
	public List<PageData> findAttchmentsByWorkId(Object id) throws Exception {
		return (List<PageData>) dao.findForList("workOrderMapper.findAttchmentsByWorkId", id);
	}
	
	public List<PageData> findByTaskCodes(String[] taskCodes) throws Exception {
		return (List<PageData>)dao.findForList("workOrderMapper.findByTaskCodes", taskCodes);
	}
	
	public void batchSaveDetail(PageData pd,String userName) throws Exception {
		Object obj = pd.get("taskCodes");
		String taskCodes[] = obj.toString().split(",");
		List<PageData> tasks = findByTaskCodes(taskCodes);
		
		dao.update("workOrderMapper.batchupdateStatus", taskCodes);
		
		for(PageData task : tasks){
			pd.put("TASK_CODE", task.get("ID"));
			pd.put("MAIN_EMP_ID", task.get("MAIN_EMP_ID"));
			pd.put("EMP_NAME", task.get("MAIN_EMP_NAME"));
			pd.put("STATUS", pd.get("status"));
			PageData pageData = new PageData();
			pageData.put("ID",pd.get("MAIN_EMP_ID"));
			pageData = employeeService.findById(pageData);
			save3(pd);
			EndPointServer.sendMessage(userName, pageData.getString("EMP_CODE"), TaskType.empDailyTask);
		}
	}
	/**
	 * 删除附件
	 * @param id
	 * @throws Exception
	 */
	public void deleteAttachment(String[] id) throws Exception {
		dao.delete("workOrderMapper.deleteAttachment", id);
	}
	/**
	 * 根据部门id查询人员
	 * @param pd
	 * @return
	 * @throws Exception 
	 */
	public List<PageData> findEmpByDept(PageData pd) throws Exception {
		return (List<PageData>)dao.findForList("workOrderMapper.findEmpByDept", pd);
	}
	/**
	 * 根据id查姓名
	 * @param pd
	 * @return
	 * @throws Exception 
	 */
	public PageData findNameById(PageData pd) throws Exception {
		return (PageData)dao.findForObject("workOrderMapper.findNameById", pd);
	}
	
}
