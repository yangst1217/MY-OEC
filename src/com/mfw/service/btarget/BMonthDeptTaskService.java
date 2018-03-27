package com.mfw.service.btarget;

import com.mfw.controller.base.BaseService;
import com.mfw.dao.DaoSupport;
import com.mfw.entity.Page;
import com.mfw.service.task.EmpDailyTaskService;
import com.mfw.util.PageData;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.util.List;

/**
 * Created by yangdw on 2016/5/12.
 */
@Service("bMonthDeptTaskService")
public class BMonthDeptTaskService extends BaseService{

    @Resource(name = "daoSupport")
    private DaoSupport dao;
    @Resource(name="bMonthEmpTargetService")
    private BMonthEmpTargetService bMonthEmpTargetService;
    @Resource(name="bWeekEmpTaskService")
    private BWeekEmpTaskService bWeekEmpTaskService;
    @Resource(name="empDailyTaskService")
    private EmpDailyTaskService empDailyTaskService;
    
    /**
     * 获取部门年度目标拆解到各月的情况
     */
    @SuppressWarnings("unchecked")
	public List<PageData> getMonthDeptTaskList(PageData searchPd) throws Exception {
        return (List<PageData>)dao.findForList("BMonthDeptTaskMapper.getMonthDeptTaskList",searchPd);
    }

    /**
     * 新增部门年度经营目标
     * @param pd
     * @throws Exception 
     */
    public void add(PageData pd) throws Exception{
    	dao.save("BMonthDeptTaskMapper.add", pd);
    }
    
    /**
     *  按照年度获取任务的现有拆分
     *  @param searchPd
     *  @return
     *  @throws Exception
     *  author yangdw
     */
    public List<PageData> getMonthTaskListByYear(PageData searchPd) throws Exception {
        return (List<PageData>)dao.findForList("BMonthDeptTaskMapper.getMonthTaskListByYear",searchPd);
    }

    /**
     *  批量新增
     *  @param addTaskList
     *  @throws Exception
     *  author yangdw
     */
    public void batchAdd(List<PageData> addTaskList) throws Exception {
        dao.save("BMonthDeptTaskMapper.batchAdd", addTaskList);
    }

    /**
     *  批量更新
     *  @param updateTaskList
     *  @throws Exception
     *  author yangdw
     */
    public void batchUpdate(List<PageData> updateTaskList) throws Exception {
        dao.batchUpdate("BMonthDeptTaskMapper.batchUpdate", updateTaskList);
    }


    /**
     *  批量插入历史记录
     *  @param hisList
     *  @throws Exception
     *  author yangdw
     */
    public void batchHisAdd(List<PageData> hisList) throws Exception {
        dao.save("BMonthDeptTaskMapper.batchHisAdd", hisList);
    }

    /**
     *  获取历史数据时间分组
     *  @param pd
     *  @return
     *  @throws Exception
     *  author yangdw
     */
    public List<PageData> getHisTimeList(PageData pd) throws Exception {
        return (List<PageData>)dao.findForList("BMonthDeptTaskMapper.getHisTimeList",pd);
    }

    /**
     *  按照年度获取任务的历史拆分
     *  @param hisSearchPd
     *  @return
     *  @throws Exception
     *  author yangdw
     */
    public List<PageData> getHisMonthTaskListByYear(PageData hisSearchPd) throws Exception {
        return (List<PageData>)dao.findForList("BMonthDeptTaskMapper.getHisMonthTaskListByYear",hisSearchPd);
    }

    /**
     *  下发任务
     *  @param updatePd
     *  @throws Exception
     *  author yangdw
     */
    public void arrange(PageData updatePd) throws Exception {
        dao.update("BMonthDeptTaskMapper.arrange",updatePd);
    }

    /**
     *  获取任务的现有拆分
     *  @param pd
     *  @return
     *  @throws Exception
     *  author yangdw
     */
    public List<PageData> getMonthTaskList(PageData pd) throws Exception {
        return (List<PageData>) dao.findForList("BMonthDeptTaskMapper.getMonthTaskList", pd);
    }

    /**
     *  月度经营任务（部门）列表
     *  @param page
     *  @return List<PageData>
     *  @throws Exception
     *  author yangdw
     */
    public List<PageData> list(Page page) throws Exception {
        return (List<PageData>) dao.findForList("BMonthDeptTaskMapper.listPage", page);
    }

    /**
     *  通过id获取月度经营任务（部门）
     *  @param pd
     *  @return List<PageData>
     *  @throws Exception
     *  author yangdw
     */
    public PageData getMonthTaskById(PageData pd) throws Exception {
        return (PageData) dao.findForObject("BMonthDeptTaskMapper.getMonthTaskById", pd);
    }
    
    /**
     * 根据年度经营目标删除部门年度经营目标
     * @param code
     * @throws Exception 
     */
	public void deleteByYearTargetCode(String code) throws Exception {
		PageData pageData = updatePage(new PageData());
		pageData.put("yearTargetCode", code);
		dao.update("BMonthDeptTaskMapper.deleteByYearTargetCode", pageData);
	}

	public void deleteById(String id) throws Exception{
		PageData pageData = updatePage(new PageData());
		pageData.put("id", id);
		dao.update("BMonthDeptTaskMapper.deleteById", pageData);
	}
	
	/**
	 * 撤回
	 * @param id
	 * @throws Exception 
	 */
	public void withdraw(String id) throws Exception {
		PageData deptMonthTarget = (PageData) dao.findForObject("BMonthDeptTaskMapper.findById", id);
    	String yearTargetCode = deptMonthTarget.getString("B_YEAR_TARGET_CODE");
    	deleteById(id);
		//删除员工月度经营目标
		bMonthEmpTargetService.deleteByYearTargetCode(yearTargetCode);
		//删除员工周经营目标
		bWeekEmpTaskService.deleteByYearTargetCode(yearTargetCode);
		//删除员工日清
		empDailyTaskService.deleteByYearTargetCode(yearTargetCode);
    	
    	savePage(deptMonthTarget);
    	deptMonthTarget.put("updateUser", null);
    	deptMonthTarget.put("updateTime", null);
    	add(deptMonthTarget);
	}
}
