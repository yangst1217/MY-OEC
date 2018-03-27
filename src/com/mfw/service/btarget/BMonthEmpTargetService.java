package com.mfw.service.btarget;

import com.mfw.controller.base.BaseService;
import com.mfw.dao.DaoSupport;
import com.mfw.entity.Page;
import com.mfw.util.PageData;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.util.List;

/**
 * 周经营任务（员工）
 * Created by yangdw on 2016/5/13.
 */
@Service("bMonthEmpTargetService")
public class BMonthEmpTargetService extends BaseService{

    @Resource(name = "daoSupport")
    private DaoSupport dao;


    /**
     *  获取目标的现有拆分
     *  @param pd
     *  @return
     *  @throws Exception
     *  author yangdw
     */
    public List<PageData> getMonthEmpTargetList(PageData pd) throws Exception {
        return (List<PageData>) dao.findForList("BMonthEmpTargetMapper.getMonthEmpTargetList", pd);
    }

    /**
     *  批量新增
     *  @param addTaskList
     *  @throws Exception
     *  author yangdw
     */
    public void batchAdd(List<PageData> addTaskList) throws Exception {
        dao.save("BMonthEmpTargetMapper.batchAdd", addTaskList);
    }

    /**
     *  批量更新
     *  @param updateTaskList
     *  @throws Exception
     *  author yangdw
     */
    public void batchUpdate(List<PageData> updateTaskList) throws Exception {
        dao.batchUpdate("BMonthEmpTargetMapper.batchUpdate", updateTaskList);
    }


    /**
     *  批量插入历史记录
     *  @param hisList
     *  @throws Exception
     *  author yangdw
     */
    public void batchHisAdd(List<PageData> hisList) throws Exception {
        dao.batchSave("BMonthEmpTargetMapper.batchHisAdd", hisList);
    }

    /**
     *  获取历史数据时间分组
     *  @param id
     *  @return
     *  @throws Exception
     *  author yangdw
     */
    public List<PageData> getHisTimeList(String id) throws Exception {
        return (List<PageData>) dao.findForList("BMonthEmpTargetMapper.getHisTimeList", id);
    }

    /**
     *  按时间获取历史记录
     *  @param hisSearchPd
     *  @return
     *  @throws Exception
     *  author yangdw
     */
    public List<PageData> getHisListByTime(PageData hisSearchPd) throws Exception {
        return (List<PageData>) dao.findForList("BMonthEmpTargetMapper.getHisListByTime", hisSearchPd);
    }

    /**
     *  下发目标分解
     *  @param updatePd
     *  @throws Exception
     *  author yangdw
     */
    public void arrange(PageData updatePd) throws Exception {
        dao.update("BMonthEmpTargetMapper.arrange", updatePd);
    }

    /**
     *  批量删除
     *  @param deletePd
     *  @throws Exception
     *  author yangdw
     */
    public void batchDelete(PageData deletePd) throws Exception {
        dao.update("BMonthEmpTargetMapper.batchDelete", deletePd);
    }

    /**
     *  月度经营任务（员工）列表
     *  @param page
     *  @return List<PageData>
     *  @throws Exception
     *  author yangdw
     */
    public List<PageData> list(Page page) throws Exception {
        return (List<PageData>) dao.findForList("BMonthEmpTargetMapper.listPage", page);
    }

    /**
     *  通过id获取月度经营目标（员工）
     *  @param pd
     *  @return List<PageData>
     *  @throws Exception
     *  author yangdw
     */
    public PageData getMonthTargetById(PageData pd) throws Exception {
        return (PageData) dao.findForObject("BMonthEmpTargetMapper.getMonthTargetById", pd);
    }

    /**
     * 根据年度经营目标编码删除员工月度经营目标
     * @param code
     * @throws Exception 
     */
	public void deleteByYearTargetCode(String code) throws Exception {
		PageData pd = updatePage(new PageData());
		pd.put("yearTargetCode", code);
		dao.update("BMonthEmpTargetMapper.deleteByYearTargetCode", pd);
	}
}
