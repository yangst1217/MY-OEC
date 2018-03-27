package com.mfw.service.btarget;

import java.util.List;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import com.mfw.controller.base.BaseService;
import com.mfw.dao.DaoSupport;
import com.mfw.entity.Page;
import com.mfw.service.task.EmpDailyTaskService;
import com.mfw.util.Const;
import com.mfw.util.PageData;

/**
 * Created by yangdw on 2016/5/10.
 */
@Service("bYearTargetService")
public class BYearTargetService extends BaseService{

    @Resource(name = "daoSupport")
    private DaoSupport dao;
    
    @Resource(name="bYearDeptTaskService")
    private BYearDeptTaskService bYearDeptTaskService;
    @Resource(name="bMonthDeptTaskService")
    private BMonthDeptTaskService bMonthDeptTaskService;
    @Resource(name="bMonthEmpTargetService")
    private BMonthEmpTargetService bMonthEmpTargetService;
    @Resource(name="bWeekEmpTaskService")
    private BWeekEmpTaskService bWeekEmpTaskService;
    @Resource(name="empDailyTaskService")
    private EmpDailyTaskService empDailyTaskService;

    /**
     *  年度经营目标列表
     *  @param page
     *  @return List<PageData>
     *  @throws Exception
     *  author yangdw
     */
    public List<PageData> list(Page page) throws Exception {
        return (List<PageData>) dao.findForList("BYearTargetMapper.listPage", page);
    }

    /**
     *  获取自动生成编码
     *  @param year
     *  @return String
     *  @throws Exception
     *  author yangdw
     */
    public String getCode(String year) throws Exception {
        //编号=JY(类型)+2016(年度)+0001(编号)
        String codeSign = "JY" + year;
        //编号
        String code = (String) dao.findForObject("BYearTargetMapper.getNewCode", codeSign);
        return codeSign + code;
    }

    /**
     *  新增年度经营目标
     *  @param target
     *  @throws Exception
     *  author yangdw
     */
    public void add(PageData target) throws Exception {
        dao.save("BYearTargetMapper.add", target);
    }
    
    /**
     *  新增目标数量历史
     *  @param pd
     *  @throws Exception
     *  author hanjl
     */
    public void addCountHis(PageData pd) throws Exception {
        dao.save("BYearTargetMapper.addCountHis", pd);
    }

    /**
     *  通过code获取目标
     *  @param CODE
     *  @return target
     *  @throws Exception
     *  author yangdw
     */
    public PageData getTargetByCode(String CODE) throws Exception {
        return (PageData) dao.findForObject("BYearTargetMapper.getTargetByCode",CODE);
    }
    
    /**
     *  通过Id判断是否有数据
     *  @param pd
     *  @return pd
     *  @throws Exception
     *  author hanjl
     */
    public PageData checkById(PageData pd) throws Exception {
        return (PageData) dao.findForObject("BYearTargetMapper.checkById",pd);
    }

    /**
     *  批量删除
     *  @param pd
     *  @throws Exception
     *  author yangdw
     */
    public void del(String ids[]) throws Exception {
        dao.update("BYearTargetMapper.del",ids);
    }

    /**
     * 删除单个目标
     * @param id
     * @throws Exception 
     */
    public void delSingle(String code) throws Exception{
    	PageData pd = updatePage(new PageData());
    	pd.put("code", code);
    	dao.update("BYearTargetMapper.delSingle", pd);
    }
    
    /**
     *  修改年度经营目标
     *  @param target
     *  @throws Exception
     *  author yangdw
     */
    public void edit(PageData target) throws Exception {
        dao.update("BYearTargetMapper.edit", target);
    }
    
    /**
     *  修改目标数量
     *  @param pd
     *  @throws Exception
     *  author hanjl
     */
    public void editCount(PageData pd) throws Exception {
        dao.update("BYearTargetMapper.editCount", pd);
    }
    
    /**
     *  修改目标数量历史记录
     *  @param pd
     *  @throws Exception
     *  author hanjl
     */
    public void updateCountHis(PageData pd) throws Exception {
        dao.update("BYearTargetMapper.updateCountHis", pd);
    }

    /**
     *  下发目标
     *  @param updatePd
     *  @throws Exception
     *  author yangdw
     */
    public void arrange(PageData updatePd) throws Exception {
        dao.update("BYearTargetMapper.arrange", updatePd);
    }

    /**
     * 根据ID获取目标
     * @param id
     * @return
     * @throws Exception 
     */
    public PageData findById(String id) throws Exception{
    	return (PageData) dao.findForObject("BYearTargetMapper.findById", id);
    }
    
    /**
     * 任务撤回
     * 未生效的任务直接删除，已生效的任务删除其子任务,之后创建一条草稿状态的任务
     * @param id
     * @throws Exception 
     */
	public void withdraw(String code) throws Exception {
		PageData yearTarget = getTargetByCode(code);
		delSingle(code);
		//删除部门年度经营目标
		bYearDeptTaskService.deleteByYearTargetCode(code);
		//删除部门月度经营目标
		bMonthDeptTaskService.deleteByYearTargetCode(code);
		//删除员工月度经营目标
		bMonthEmpTargetService.deleteByYearTargetCode(code);
		//删除员工周经营目标
		bWeekEmpTaskService.deleteByYearTargetCode(code);
		//删除员工日清
		empDailyTaskService.deleteByYearTargetCode(code);
		
		savePage(yearTarget);
		yearTarget.put("CODE", getCode(yearTarget.getString("YEAR")));
		yearTarget.put("STATUS", Const.SYS_STATUS_YW_CG);
		yearTarget.put("updateUser", null);
		yearTarget.put("updateTime", null);
		add(yearTarget);
	}
}
