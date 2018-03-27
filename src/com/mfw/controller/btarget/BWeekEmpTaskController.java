package com.mfw.controller.btarget;

import com.mfw.controller.base.BaseController;
import com.mfw.entity.system.UserLog;
import com.mfw.service.btarget.BWeekEmpTaskService;
import com.mfw.service.system.UserLogService;
import com.mfw.util.Const;
import com.mfw.util.PageData;
import com.mfw.util.Tools;
import org.apache.shiro.SecurityUtils;
import org.apache.shiro.session.Session;
import org.apache.shiro.subject.Subject;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;

import javax.annotation.Resource;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

/**
 * 周经营任务（员工） Created by yangdw on 2016/5/13.
 */
@Controller
@RequestMapping(value = "/bweekemptask")
public class BWeekEmpTaskController extends BaseController {

	@Resource(name = "bWeekEmpTaskService")
	private BWeekEmpTaskService bWeekEmpTaskService;

	@Resource(name = "userLogService")
	private UserLogService userLogService;

	@Resource(name = "bMonthEmpTargetController")
	private BMonthEmpTargetController bMonthEmpTargetController;

	/**
	 * 月度员工目标到周拆分
	 * 
	 * @return mv
	 * @throws Exception
	 *             author yangdw
	 */
	@RequestMapping(value = "/add")
	public ModelAndView add() throws Exception {

		logBefore(logger, "月度员工目标到周拆分");

		ModelAndView mv = this.getModelAndView();
		PageData pd = this.getPageData();
		Subject currentUser = SecurityUtils.getSubject();
		Session session = currentUser.getSession();
		try {
			String[] week_counts = pd.getString("WEEK_COUNTS").split(",");
			String[] money_counts = null;
            if(pd.get("WEEK_COUNTS_MONEY") != null){
            	money_counts = pd.getString("WEEK_COUNTS_MONEY").split(",");
            }
			String[] start_dates = pd.getString("START_DATES").split(",");
			String[] weeks = pd.getString("WEEKS").split(",");
			String[] end_dates = pd.getString("END_DATES").split(",");
			String[] ids = pd.getString("IDS").split(",", -1);
			String[] statuses = pd.getString("STATUSES").split(",", -1);

			if (week_counts.length == start_dates.length && statuses.length == ids.length
					&& week_counts.length == ids.length && week_counts.length == weeks.length
					&& week_counts.length == end_dates.length) {
				List<PageData> addTaskList = new ArrayList<PageData>();
				List<PageData> updateTaskList = new ArrayList<PageData>();

				for (int i = 0; i < week_counts.length; i++) {
					PageData task = new PageData();
					task.put("B_MONTH_EMP_TARGET_ID", pd.get("B_MONTH_EMP_TARGET_ID"));// 员工月度目标ID
					task.put("B_YEAR_TARGET_CODE", pd.get("B_YEAR_TARGET_CODE"));// 目标编码
					task.put("YEAR", pd.get("YEAR"));// 年度
					task.put("MONTH", pd.get("MONTH"));// 月份
					task.put("DEPT_CODE", pd.get("DEPT_CODE"));// 部门编号
					task.put("EMP_CODE", pd.get("EMP_CODE"));// 员工编号
					task.put("STATUS", statuses[i]);// 状态
					task.put("ISDEL", 0);// 是否删除
					task.put("WEEK", weeks[i]);// 是否删除
					task.put("WEEK_START_DATE", start_dates[i]);// 是否删除
					task.put("WEEK_END_DATE", end_dates[i]);// 是否删除
					task.put("PARTICIPANT", pd.get("PARTICIPANT"));
					task.put("UPDATE_USER", session.getAttribute(Const.SESSION_USERNAME));// 最后更新人
					task.put("UPDATE_TIME", Tools.date2Str(new Date()));// 最后更新时间
					task.put("WEEK_COUNT", week_counts[i]);// 数量
					
					if(pd.get("WEEK_COUNTS_MONEY") != null){
		            	task.put("MONEY_COUNT", money_counts[i]);// 数量
		            }else{
		            	task.put("MONEY_COUNT", 0);// 数量
		            }
					
					task.put("ID", ids[i]);// ID
					if ("".equals(ids[i])) {
						// 如果id不存在，那么就是增加
						task.put("CREATE_USER", session.getAttribute(Const.SESSION_USERNAME));// 创建人
						task.put("CREATE_TIME", Tools.date2Str(new Date()));// 创建时间
						addTaskList.add(task);
					} else {
						// 如果id存在，就是更新
						updateTaskList.add(task);
					}
				}

				// 批量新增
				if (null != addTaskList && 0 != addTaskList.size()) {
					bWeekEmpTaskService.batchAdd(addTaskList);
					userLogService.logInfo(new UserLog(getUser().getUSER_ID(),
							UserLog.LogType.add, "周经营目标（员工）", "批量新增"));// 操作日志入库
				}

				// 批量更新
				if (null != updateTaskList && 0 != updateTaskList.size()) {
					bWeekEmpTaskService.batchUpdate(updateTaskList);
					userLogService.logInfo(new UserLog(getUser().getUSER_ID(),
							UserLog.LogType.update, "周经营目标（员工）", "批量更新"));// 操作日志入库
				}

				// 已生效的目标需要同时添加历史数据
				if ("YW_YSX".equals(statuses[0])) {
					List<PageData> hisList = new ArrayList<PageData>();
					hisList.addAll(addTaskList);
					hisList.addAll(updateTaskList);
					bWeekEmpTaskService.batchHisAdd(hisList);
				}
			}
			pd.put("ID", pd.get("B_MONTH_EMP_TARGET_ID"));
			bMonthEmpTargetController.initExplainPage(mv, pd);
			mv.addObject("flag", "success");
		} catch (Exception e) {
			logger.error(e.toString(), e);
			mv.addObject("flag", "false");
		}

		mv.setViewName("btarget/bmonthemptarget/explain");
		return mv;
	}

}
