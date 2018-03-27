package com.mfw.service.btarget;

import com.mfw.controller.base.BaseService;
import com.mfw.dao.DaoSupport;
import com.mfw.util.PageData;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.util.List;

/**
 * Created by yangdw on 2016/5/16.
 */
@Service("bWeekEmpTaskService")
public class BWeekEmpTaskService extends BaseService{
    @Resource(name = "daoSupport")
    private DaoSupport dao;


    /**
     *  获取目标的现有拆分
     *  @param pd
     *  @return
     *  @throws Exception
     *  author yangdw
     */
    public List<PageData> getWeekEmpTaskList(PageData pd) throws Exception {
        return (List<PageData>) dao.findForList("BWeekEmpTaskMapper.getWeekEmpTaskList", pd);
    }

    /**
     *  批量新增
     *  @param addTaskList
     *  @throws Exception
     *  author yangdw
     */
    public void batchAdd(List<PageData> addTaskList) throws Exception {
        dao.save("BWeekEmpTaskMapper.batchAdd", addTaskList);
    }

    /**
     *  批量更新
     *  @param updateTaskList
     *  @throws Exception
     *  author yangdw
     */
    public void batchUpdate(List<PageData> updateTaskList) throws Exception {
        dao.batchUpdate("BWeekEmpTaskMapper.batchUpdate", updateTaskList);
    }

    /**
     *  批量插入历史记录
     *  @param hisList
     *  @throws Exception
     *  author yangdw
     */
    public void batchHisAdd(List<PageData> hisList) throws Exception {
        dao.save("BWeekEmpTaskMapper.batchHisAdd", hisList);
    }

    /**
     *  获取历史数据时间分组
     *  @param pd
     *  @return
     *  @throws Exception
     *  author yangdw
     */
    public List<PageData> getHisTimeList(PageData pd) throws Exception {
        return (List<PageData>) dao.findForList("BWeekEmpTaskMapper.getHisTimeList", pd);
    }

    /**
     *  按时间获取历史记录
     *  @param hisSearchPd
     *  @return
     *  @throws Exception
     *  author yangdw
     */
    public List<PageData> getHisListByTime(PageData hisSearchPd) throws Exception {
        return (List<PageData>) dao.findForList("BWeekEmpTaskMapper.getHisListByTime", hisSearchPd);
    }

    /**
     *  下发目标分解
     *  @param updatePd
     *  @throws Exception
     *  author yangdw
     */
    public void arrange(PageData updatePd) throws Exception {
        dao.update("BWeekEmpTaskMapper.arrange", updatePd);
    }

	public void deleteByYearTargetCode(String code) throws Exception {
		PageData pageData = updatePage(new PageData());
		pageData.put("yearTargetCode", code);
		dao.update("BWeekEmpTaskMapper.deleteByYearTargetCode", pageData);
	}
}
