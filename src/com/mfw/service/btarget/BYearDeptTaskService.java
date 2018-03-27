package com.mfw.service.btarget;

import java.util.List;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import com.mfw.controller.base.BaseService;
import com.mfw.dao.DaoSupport;
import com.mfw.entity.Page;
import com.mfw.service.task.EmpDailyTaskService;
import com.mfw.util.PageData;

/**
 * Created by yangdw on 2016/5/11.
 */
@Service("bYearDeptTaskService")
public class BYearDeptTaskService extends BaseService{

    @Resource(name = "daoSupport")
    private DaoSupport dao;
    @Resource(name="bMonthDeptTaskService")
    private BMonthDeptTaskService bMonthDeptTaskService;
    @Resource(name="bMonthEmpTargetService")
    private BMonthEmpTargetService bMonthEmpTargetService;
    @Resource(name="bWeekEmpTaskService")
    private BWeekEmpTaskService bWeekEmpTaskService;
    @Resource(name="empDailyTaskService")
    private EmpDailyTaskService empDailyTaskService;

    /**
     *  批量新增
     *  @param addTaskList
     *  @throws Exception
     *  author yangdw
     */
    public void batchAdd(List<PageData> addTaskList) throws Exception {
        dao.save("BYearDeptTaskMapper.batchAdd", addTaskList);
    }

    /**
     * 新增部门年度经营目标
     * @param pd
     * @throws Exception 
     */
    public void add(PageData pd) throws Exception{
    	dao.save("BYearDeptTaskMapper.add", pd);
    }
    
    /**
     *  批量更新
     *  @param updateTaskList
     *  @throws Exception
     *  author yangdw
     */
    public void batchUpdate(List<PageData> updateTaskList) throws Exception {
        dao.batchUpdate("BYearDeptTaskMapper.batchUpdate", updateTaskList);
    }

    /**
     *  批量删除
     *  @param deletePd
     *  @throws Exception
     *  author yangdw
     */
    public void batchDelete(PageData deletePd) throws Exception {
        dao.update("BYearDeptTaskMapper.batchDelete", deletePd);
    }

    /**
     * 根据ID删除部门年度经营目标
     * @param id
     * @throws Exception 
     */
    public void delete(String id) throws Exception{
    	PageData pd = updatePage(new PageData());
    	pd.put("id", id);
    	dao.update("BYearDeptTaskMapper.delete", pd);
    }
    
    /**
     * 根据年度经营目标删除年度部门经营目标
     * @param yearTargetCode
     * @throws Exception 
     */
    public void deleteByYearTargetCode(String yearTargetCode) throws Exception{
    	PageData pd = updatePage(new PageData());
    	pd.put("yearTargetCode", yearTargetCode);
    	dao.update("BYearDeptTaskMapper.deleteByYearTargetCode", pd);
    }
    
    /**
     *  批量插入历史记录
     *  @param hisList
     *  @throws Exception
     *  author yangdw
     */
    public void batchHisAdd(List<PageData> hisList) throws Exception {
        dao.save("BYearDeptTaskMapper.batchHisAdd", hisList);
    }

    /**
     *  获取历史数据时间分组
     *  @param code
     *  @return
     *  @throws Exception
     *  author yangdw
     */
    public List<PageData> getHisTimeList(String code) throws Exception {
        return (List<PageData>) dao.findForList("BYearDeptTaskMapper.getHisTimeList", code);
    }

    /**
     *  按时间获取历史记录
     *  @param hisSearchPd
     *  @return
     *  @throws Exception
     *  author yangdw
     */
    public List<PageData> getHisListByTime(PageData hisSearchPd) throws Exception {
        return (List<PageData>) dao.findForList("BYearDeptTaskMapper.getHisListByTime", hisSearchPd);
    }

    /**
     *  获取目标的现有拆分
     *  @param code
     *  @return
     *  @throws Exception
     *  author yangdw
     */
    public List<PageData> getTaskList(String code) throws Exception {
        return (List<PageData>) dao.findForList("BYearDeptTaskMapper.getTaskList", code);
    }
    
    /**
     *  获取一级目标的现有拆分
     *  @param code
     *  @return
     *  @throws Exception
     *  author yangdw
     */
    @SuppressWarnings("unchecked")
	public List<PageData> getSupTaskList(String code) throws Exception {
        return (List<PageData>) dao.findForList("BYearDeptTaskMapper.getSupTaskList", code);
    }

    /**
     *  下发目标分解
     *  @param updatePd
     *  @throws Exception
     *  author yangdw
     */
    public void arrange(PageData updatePd) throws Exception {
        dao.update("BYearDeptTaskMapper.arrange", updatePd);
    }

    /**
     *  年度经营任务（部门）列表
     *  @param page
     *  @return
     *  @throws Exception
     *  author yangdw
     */
    public List<PageData> list(Page page) throws Exception {
        return (List<PageData>) dao.findForList("BYearDeptTaskMapper.listPage", page);
    }

    /**
     *  获取任务
     *  @param pd
     *  @return
     *  @throws Exception
     *  author yangdw
     */
    public PageData getTaskById(PageData pd) throws Exception {
        return (PageData)dao.findForObject("BYearDeptTaskMapper.getTaskById", pd);
    }
    
    /**
     * 撤回部门年度经营目标
     * @param id
     * @throws Exception 
     */
    public void withdraw(String id) throws Exception{
    	PageData deptYearTarget = (PageData) dao.findForObject("BYearDeptTaskMapper.findById", id);
    	String yearTargetCode = deptYearTarget.getString("B_YEAR_TARGET_CODE");
    	delete(id);
		//删除部门月度经营目标
		bMonthDeptTaskService.deleteByYearTargetCode(yearTargetCode);
		//删除员工月度经营目标
		bMonthEmpTargetService.deleteByYearTargetCode(yearTargetCode);
		//删除员工周经营目标
		bWeekEmpTaskService.deleteByYearTargetCode(yearTargetCode);
		//删除员工日清
		empDailyTaskService.deleteByYearTargetCode(yearTargetCode);
    	
    	savePage(deptYearTarget);
    	deptYearTarget.put("updateUser", null);
    	deptYearTarget.put("updateTime", null);
    	add(deptYearTarget);
    }

    /**
     * 根据一级分解获取子分解
     * @param supTask
     * @return
     * @throws Exception
     */
	@SuppressWarnings("unchecked")
	public List<PageData> getExplainTaskList(PageData supTask) throws Exception {
		return (List<PageData>) dao.findForList("BYearDeptTaskMapper.getTaskBySuper", supTask);
	}

	/**
	 * 更新部门年度目标的指定分解人
	 */
	public void updateExplainEmp(PageData pd) throws Exception{
		dao.update("BYearDeptTaskMapper.updateExplainEmp", pd);
	}
}
