package com.mfw.util;

/**
 * WebSocket使用，表示提示的任务类型
 * @author 李伟涛
 *
 */
public enum TaskType {

	/**
	 * 年度经营目标
	 */
	yeartarget,
	/**
	 * 部门年度经营部门
	 */
	yeardepttask,
	/**
	 * 重点协同项目
	 */
	cproject, 
	/**
	 * 员工月度经营目标
	 */
	bmonthemptarget,
	/**
	 * 创新项目审核
	 */
	cprojectAudit,
	/**
	 * 重点协同项目节点
	 */
	cprojectNode,
	/**
	 * 重点协同项目活动
	 */
	cprojectEvent, 
	/**
	 * 流程工作
	 */
	flow, 
	/**
	 * 临时工作
	 */
	empDailyTask, 
	/**
	 * 临时工作审核
	 */
	empDailyTaskAudit,
	/**
	 * 目标工作日清提报
	 */
	commitBusinessTask,
	/**
	 *	重点协同工作日清提报
	 */
	commitCreativeTask,
	/**
	 * 日常工作日清提报
	 */
	commitDailyTask,
	/**
	 * 临时工作日清提报
	 */
	commitTempTask,
	/**
	 * 临时工作评价
	 */
	commitTempTaskAssess,
	/**
	 * 日常工作审核完毕
	 */
	dailyTaskCheckComplete,
	/**
	 * 重点协同项目开始验收
	 */
	projectAcceptance
}
