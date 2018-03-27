package com.mfw.controller.btarget;

import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.apache.shiro.SecurityUtils;
import org.apache.shiro.session.Session;
import org.apache.shiro.subject.Subject;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import com.google.gson.Gson;
import com.mfw.controller.base.BaseController;
import com.mfw.entity.GridPage;
import com.mfw.entity.Page;
import com.mfw.entity.system.User;
import com.mfw.entity.system.UserLog;
import com.mfw.service.bdata.BussinessIndexService;
import com.mfw.service.bdata.CommonService;
import com.mfw.service.bdata.DeptService;
import com.mfw.service.bdata.EmployeeService;
import com.mfw.service.bdata.ProductService;
import com.mfw.service.bdata.UnitService;
import com.mfw.service.btarget.BYearDeptTaskService;
import com.mfw.service.btarget.BYearTargetService;
import com.mfw.service.system.UserLogService;
import com.mfw.service.system.dictionaries.DictionariesService;
import com.mfw.util.Const;
import com.mfw.util.EndPointServer;
import com.mfw.util.PageData;
import com.mfw.util.TaskType;
import com.mfw.util.Tools;

/**
 * 年度经营目标 Created by yangdw on 2016/5/10.
 */
@Controller("bYearTargetController")
@RequestMapping(value = "/byeartarget")
public class BYearTargetController extends BaseController {

	@Resource(name = "bYearTargetService")
	private BYearTargetService bYearTargetService;

	@Resource(name = "deptService")
	private DeptService deptService;

	@Resource(name = "employeeService")
	private EmployeeService employeeService;

	@Resource(name = "userLogService")
	private UserLogService userLogService;

	@Resource(name = "bYearDeptTaskService")
	private BYearDeptTaskService bYearDeptTaskService;

	@Resource(name = "bussinessIndexService")
	private BussinessIndexService bussinessIndexService;

	@Resource(name = "productService")
	private ProductService productService;

	@Resource(name = "unitService")
	private UnitService unitService;

	@Resource(name = "commonService")
	private CommonService commonService;
	@Resource(name="dictionariesService")
	private DictionariesService dictionariesService;

	/**
	 * 年度经营目标列表
	 * 
	 * @param page
	 * @return mv
	 * @throws Exception
	 *             author yangdw
	 */
	@RequestMapping(value = "/list")
	public ModelAndView list(Page page) throws Exception {
		ModelAndView mv = this.getModelAndView();
		Subject currentUser = SecurityUtils.getSubject();
		Session session = currentUser.getSession();
		User user =(User) session.getAttribute(Const.SESSION_USER);
		String roleId = user.getROLE_ID();
		if(roleId != null){
			int count = commonService.checkFzRole(roleId);
			if(count==1){
				mv.addObject("fuzong", "1");
			}
		}
		mv.setViewName("btarget/byeartarget/list");
		return mv;
	}

	/**
	 * 页面表格数据获取
	 * 
	 * @param page
	 * @param request
	 * @return
	 */
	@ResponseBody
	@RequestMapping(value = "/targetList")
	public GridPage targetList(Page page, HttpServletRequest request) {
		logBefore(logger, "年度经营目标列表");
		List<PageData> targetList = new ArrayList<>();
		try {
			convertPage(page, request);
			PageData searchPd = page.getPd();

			User user = getUser();
			searchPd.put("USER_NAME",user.getUSERNAME());
			searchPd.put("USER_NUMBER", user.getNUMBER());

			// 2016-07-07 yangdw 加入数据权限
			List<PageData> sysDeptList = commonService.getSysDeptList();
			if (null != sysDeptList && 0 != sysDeptList.size()
					&& null != sysDeptList.get(0)) {
				String[] sysDeptArr = new String[sysDeptList.size()];
				for (int i = 0; i < sysDeptList.size(); i++) {
					sysDeptArr[i] = sysDeptList.get(i).get("DEPT_CODE").toString();
				}
				searchPd.put("sysDeptArr", sysDeptArr);
			}
			page.setPd(searchPd);
			targetList = bYearTargetService.list(page);// 获取年度经营目标列表

			for(int i = 0; i < targetList.size(); i++){
				PageData target = targetList.get(i);
				String productCode = target.get("PRODUCT_CODE").toString();
				if(productCode.contains(",")){
					String[] projectCodes = productCode.split(",");
					List<PageData> names = productService.findByCodes(projectCodes);
					StringBuffer str = new StringBuffer();
					for(int j = 0; j < names.size(); j++){
						str.append(",").append(names.get(j).get("PRODUCT_NAME"));
					}
					target.put("PRODUCT_NAME", str.toString().substring(1));
				}
			}
			
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
			e.printStackTrace();
		}
		return new GridPage(targetList, page);
	}
	
	/**
	 * 跳转目标新增页面
	 * 
	 * @return mv
	 * @throws Exception
	 *             author yangdw
	 */
	@RequestMapping(value = "/goAdd")
	public ModelAndView goAdd() throws Exception {
		logBefore(logger, "跳转目标新增页面");
		ModelAndView mv = this.getModelAndView();
		try {
			// 部门树所需要的数据
			deptTreeNodes(mv, deptService.listAlln());
			// 单位列表
			mv.addObject("unitList", unitService.findAll());
			// 指标列表
			mv.addObject("indexList", bussinessIndexService.findAll());
			//目标类型
			List<PageData> types = dictionariesService.typeListByBm(Const.DICTIONARIES_BM_CPLX);
			mv.addObject("productType", types);
			// 默认销售类产品列表
			mv.addObject("proList", productService.findByType(types.get(0).getString("BIANMA")));
		} catch (Exception e) {
			logger.error(e.toString(), e);
		}
		mv.addObject("msg", "add");
		mv.setViewName("btarget/byeartarget/add_or_edit");
		return mv;
	}

	/**
	 * 添加新年度经营目标
	 * 
	 * @return mv
	 * @throws Exception
	 *             author yangdw
	 */
	@RequestMapping(value = "/add")
	public ModelAndView add() throws Exception {
		logBefore(logger, "添加新年度经营目标");
		ModelAndView mv = this.getModelAndView();
		PageData target = this.getPageData();
		try {
			savePage(target);
			target.put("STATUS", "YW_CG");// 设置状态为草稿
			// 计算目标编号
			String code = bYearTargetService.getCode(target.get("YEAR").toString());
			target.put("CODE", code);

			if(target.get("MONEY_COUNT").toString().length() == 0){
				target.put("MONEY_COUNT", 0);
			}
			
			bYearTargetService.add(target);
			EndPointServer.sendMessage(getUser().getNAME(), target.getString("EMP_CODE"), TaskType.yeartarget);
			userLogService.logInfo(new UserLog(getUser().getUSER_ID(), UserLog.LogType.add,
					"年度经营目标", "id是" + target.get("ID").toString()));// 操作日志入库

			mv.addObject("msg", "success");
		} catch (Exception e) {
			logger.error(e.toString(), e);
			mv.addObject("msg", "false");
		}

		mv.setViewName("save_result");
		return mv;
	}

	/**
	 * 跳转目标修改页面
	 * 
	 * @return mv
	 * @throws Exception
	 *             author yangdw
	 */
	@RequestMapping(value = "/goEdit")
	public ModelAndView goEdit() throws Exception {

		logBefore(logger, "跳转目标修改页面");

		ModelAndView mv = this.getModelAndView();
		PageData searchPd = this.getPageData();
		try {
			// 获取目标
			PageData target = bYearTargetService.getTargetByCode(searchPd.get("CODE").toString());
			mv.addObject("target", target);
			mv.addObject("projectSelected",target.getString("PRODUCT_CODE").split(","));
			// 塞入部门树所需要的数据
			deptTreeNodes(mv, deptService.listAlln());
			// 单位列表
			mv.addObject("unitList", unitService.findAll());
			// 指标列表
			mv.addObject("indexList", bussinessIndexService.findAll());
			// 员工列表
			mv.addObject("empList", employeeService.findEmpByDept(target.get("DEPT_ID").toString()));
			
			//目标类型
			List<PageData> types = dictionariesService.typeListByBm(Const.DICTIONARIES_BM_CPLX);
			mv.addObject("productType", types);
			// 默认产品列表
			mv.addObject("proList", productService.findByType(target.getString("TARGET_TYPE")));
		} catch (Exception e) {
			logger.error(e.toString(), e);
		}
		mv.addObject("msg", "edit");
		mv.setViewName("btarget/byeartarget/add_or_edit");
		return mv;
	}
	
	/**
	 * 跳转修改目标数量页面
	 * 
	 * @return mv
	 * @throws Exception
	 *             author hanjl
	 */
	@RequestMapping(value = "/goEditCount")
	public ModelAndView goEditCount() throws Exception {

		logBefore(logger, "跳转修改目标数量页面");

		ModelAndView mv = this.getModelAndView();
		PageData pd = this.getPageData();
		try {
			// 获取目标数量
			mv.addObject("resultpd", pd);
			
		} catch (Exception e) {
			logger.error(e.toString(), e);
		}
		mv.setViewName("btarget/byeartarget/editCount");
		return mv;
	}
	
	/**
	 * 修改目标数量
	 * 
	 * @return mv
	 * @throws Exception
	 *             author hanjl
	 */
	@RequestMapping(value = "/editCount")
	public ModelAndView editCount() throws Exception {

		logBefore(logger, "修改目标数量");

		ModelAndView mv = this.getModelAndView();
		PageData pd = this.getPageData();
		Subject currentUser = SecurityUtils.getSubject();
		Session session = currentUser.getSession();
		User user =(User) session.getAttribute(Const.SESSION_USER);
		try {

			pd.put("REVISER",user.getNAME());// 修改人
			pd.put("UPDATE_USER",
					session.getAttribute(Const.SESSION_USERNAME));// 最后更新人
			pd.put("UPDATE_TIME", Tools.date2Str(new Date()));// 修改时间
			bYearTargetService.editCount(pd);
			
			PageData checkPd = bYearTargetService.checkById(pd);
			if(null == checkPd){
				bYearTargetService.addCountHis(pd);
			}else{
				bYearTargetService.updateCountHis(pd);
			}

			mv.addObject("msg", "success");
		} catch (Exception e) {
			logger.error(e.toString(), e);
			mv.addObject("msg", "success");
		}

		mv.setViewName("save_result");
		return mv;
	}

	/**
	 * 编辑新年度经营目标
	 * 
	 * @return mv
	 * @throws Exception
	 *             author yangdw
	 */
	@RequestMapping(value = "/edit")
	public ModelAndView edit() throws Exception {

		logBefore(logger, "编辑新年度经营目标");

		ModelAndView mv = this.getModelAndView();
		PageData target = this.getPageData();
		Subject currentUser = SecurityUtils.getSubject();
		Session session = currentUser.getSession();
		try {

			target.put("UPDATE_USER",
					session.getAttribute(Const.SESSION_USERNAME));// 最后更新人
			target.put("UPDATE_TIME", Tools.date2Str(new Date()));// 最后更新时间

			bYearTargetService.edit(target);
			userLogService.logInfo(new UserLog(getUser().getUSER_ID(), UserLog.LogType.add,
					"年度经营目标", "id是" + target.get("ID").toString()));// 操作日志入库

			mv.addObject("msg", "success");
		} catch (Exception e) {
			logger.error(e.toString(), e);
			mv.addObject("msg", "success");
		}

		mv.setViewName("save_result");
		return mv;
	}

	/**
	 * 跳转目标分解页面
	 * 
	 * @return mv
	 * @throws Exception
	 *             author yangdw
	 */
	@RequestMapping(value = "/goExplain")
	public ModelAndView goExplain() throws Exception {

		logBefore(logger, "跳转目标分解页面");

		ModelAndView mv = this.getModelAndView();
		PageData pd = this.getPageData();
		try {
			// 初始化explain页面
			initExplainPage(mv, pd);
		} catch (Exception e) {
			logger.error(e.toString(), e);
		}
		mv.setViewName("btarget/byeartarget/explain");
		return mv;
	}

	/**
	 * 跳转分解历史页面
	 * 
	 * @return mv
	 * @throws Exception
	 *             author yangdw
	 */
	@RequestMapping(value = "/goHistory")
	public ModelAndView goHistory() throws Exception {
		ModelAndView mv = this.getModelAndView();
		PageData pd = this.getPageData();
		try {
			// 获取目标数量修改历史
			PageData countHis = bYearTargetService.checkById(pd);
			mv.addObject("countHis", countHis);
			
			// 获取目标
			PageData target = bYearTargetService.getTargetByCode(pd.get("CODE").toString());
			mv.addObject("target", target);

			// 获取历史数据时间分组
			List<PageData> hisTimeList = bYearDeptTaskService.getHisTimeList(pd
					.get("CODE").toString());
			PageData hisSearchPd = new PageData();
			List<PageData> hisList = new ArrayList<PageData>();
			hisSearchPd.put("CODE", pd.get("CODE").toString());
			for (int i = 0; i < hisTimeList.size(); i++) {
				hisSearchPd.put("UPDATE_TIME",hisTimeList.get(i).get("UPDATE_TIME"));
				List<PageData> hisSearchList = bYearDeptTaskService
						.getHisListByTime(hisSearchPd);
				PageData his = new PageData();
				his.put("UPDATE_TIME", hisTimeList.get(i).get("UPDATE_TIME"));
				his.put("COUNT_SUM", hisTimeList.get(i).get("COUNT_SUM"));
				his.put("hisSearchList", hisSearchList);
				hisList.add(his);
			}
			mv.addObject("hisList", hisList);
			// 放入上级frameId用于返回
			mv.addObject("PARENT_FRAME_ID", pd.get("PARENT_FRAME_ID"));
		} catch (Exception e) {
			logger.error(e.toString(), e);
		}
		mv.setViewName("btarget/byeartarget/history");
		return mv;
	}

	/**
	 * 下发目标
	 * 
	 * @param out
	 * @throws Exception
	 *             author yangdw
	 */
	@RequestMapping(value = "/arrange", produces = "text/plain;charset=UTF-8")
	public void arrange(PrintWriter out) throws Exception {
		logBefore(logger, "下发目标");
		PageData pd = this.getPageData();

		try {
			PageData updatePd = new PageData();
			updatePd.put("CODE", pd.get("CODE").toString());// 编号
			updatePd.put("UPDATE_USER", getUser().getUSERNAME());// 最后更新人
			updatePd.put("UPDATE_TIME", Tools.date2Str(new Date()));// 最后更新时间

			bYearTargetService.arrange(updatePd);// 下发目标
			bYearDeptTaskService.arrange(updatePd);// 下发目标分解
			List<PageData> taskList = bYearDeptTaskService.getTaskList(pd.get("CODE").toString());
			bYearDeptTaskService.batchHisAdd(taskList);// 目标分解存入历史库

			userLogService.logInfo(new UserLog(getUser().getUSER_ID(), UserLog.LogType.update,
					"下发目标", "code是" + pd.get("CODE").toString()));// 操作日志入库

			out.write("success");
			out.close();
		} catch (Exception e) {
			logger.error(e.toString(), e);
			out.write("false");
			out.close();
		}
	}

	/**
	 * 批量删除目标
	 * 
	 * @param out
	 * @throws Exception
	 *             author yangdw
	 */
	@RequestMapping(value = "/del", produces = "text/plain;charset=UTF-8")
	public void del(PrintWriter out) throws Exception {
		logBefore(logger, "批量删除目标");
		PageData pd = this.getPageData();
		Object obj = pd.get("ids[]");
		String ids[] = obj.toString().split(",");

		try {
			bYearTargetService.del(ids);// 批量删除

			userLogService.logInfo(new UserLog(getUser().getUSER_ID(), UserLog.LogType.delete,
					"年度经营目标", "id是" + ids.toString()));// 操作日志入库

			out.write("success");
			out.close();
		} catch (Exception e) {
			logger.error(e.toString(), e);
			out.write("false");
			out.close();
		}
	}

	/**
	 * 初始化分解页面
	 * 
	 * @param mv
	 *            ,pd
	 * @throws Exception
	 *             author yangdw
	 */
	public void initExplainPage(ModelAndView mv, PageData pd) throws Exception {
		// 获取目标
		PageData target = bYearTargetService.getTargetByCode(pd.get("CODE").toString());
		
		//获取产品名
		String productCode = target.get("PRODUCT_CODE").toString();
		if(productCode.contains(",")){
			String[] projectCodes = productCode.split(",");
			List<PageData> names = productService.findByCodes(projectCodes);
			StringBuffer str = new StringBuffer();
			for(int j = 0; j < names.size(); j++){
				str.append(",").append(names.get(j).get("PRODUCT_NAME"));
			}
			target.put("PRODUCT_NAME", str.toString().substring(1));
		}
		
		// 获取目标的现有拆分
		List<PageData> supTaskList = bYearDeptTaskService.getSupTaskList(pd.get("CODE").toString());
		for(PageData supTask : supTaskList){
			List<PageData> tasks = bYearDeptTaskService.getExplainTaskList(supTask);
			supTask.put("explain", tasks);
			
			String deptId = supTask.get("DEPT_ID").toString();
			List<PageData> empList = employeeService.findEmpByDept(deptId);
			supTask.put("empList", empList);
		}
		
		mv.addObject("target", target);
		mv.addObject("supTaskList", supTaskList);
		// 塞入部门树
		deptTreeNodes(mv, deptService.listAlln());
		
		String[] codes = target.get("PRODUCT_CODE").toString().split(",");
		List<PageData> products = productService.findByCodes(codes);
		mv.addObject("productList", products);
		mv.addObject("products", new Gson().toJson(products));
		
		// 放入上级frameId用于返回
		mv.addObject("PARENT_FRAME_ID", pd.get("PARENT_FRAME_ID"));
	}
	
	/**
	 * 任务撤回
	 * @return
	 */
	@ResponseBody
	@RequestMapping(value="withdraw")
	public String withdraw(String code){
		try {
			bYearTargetService.withdraw(code);
		} catch (Exception e) {
			e.printStackTrace();
			return "faild";
		}
		return "success";
	}
	
}
