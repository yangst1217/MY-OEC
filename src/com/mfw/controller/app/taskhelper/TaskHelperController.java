package com.mfw.controller.app.taskhelper;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;
import java.util.Set;
import java.util.concurrent.ConcurrentHashMap;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import com.google.gson.Gson;
import com.mfw.controller.base.BaseController;
import com.mfw.entity.system.User;
import com.mfw.service.bdata.PositionDutyService;
import com.mfw.service.dailytask.PositionDailyTaskService;
import com.mfw.util.Const;
import com.mfw.util.PageData;

/**
 * 手机端日清助手
 * @author liweitao
 *
 */
@Controller
@RequestMapping(value="app_taskHelper")
public class TaskHelperController extends BaseController{

	@Resource(name="positionDailyTaskService")
    private PositionDailyTaskService positionDailyTaskService;
	@Resource(name="positionDutyService")
	private PositionDutyService positionDutyService;
	
	/**
	 * 获取助手列表
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="list")
	public ModelAndView list(HttpServletRequest request) throws Exception{
		ModelAndView modelAndView = getModelAndView();
		User user = getUser();
		String type = getPageData().getString("type");
		if("all".equals(type)){
			//获取全部岗位职责
			List<PageData> dutys = positionDutyService.findDutyByUser(user);
			modelAndView.addObject("helpers", dutys);
		}else{
			//获取已收藏的岗位职责
			List<PageData> commonDutys = positionDutyService.findCommonDuty(user);
			modelAndView.addObject("helpers", commonDutys);
		}
		
		//获取当天所有的日常工作
		PageData param = new PageData();
		param.put("EMP_CODE", getUser().getNUMBER());
		List<PageData> result = positionDailyTaskService.getToadyDailyTask(param);
		
		//获取当天所有的分组(groups)和状态(status)
		ConcurrentHashMap<String, String> statusMap = new ConcurrentHashMap<>();
		for(int i = 0; i < result.size(); i++){
			statusMap.put(result.get(i).get("groups").toString(), 
					result.get(i).get("status").toString());
		}
		
		//获取状态不为end的分组(groups),此操作后statusMap中保存的为最终状态
		Set<String> statusKey = statusMap.keySet();
		for(String key : statusKey){
			if(statusMap.get(key).equals(Const.DAILY_TASK_OPERA_END)){
				statusMap.remove(key);
			}
		}
		
		//获取未结束的节点列表
		for(int i = result.size() -1 ; i >= 0; i--){
			if(!statusMap.containsKey(result.get(i).get("groups").toString())){
				result.remove(i);
			}
		}
		
		//确定正在进行的持续时间，防止客户端计算导致时间不正确
		for(int i = 0; i < result.size(); i++){
			PageData data = result.get(i);
			SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
			if(data.get("end_time") == null){
				long time = (new Date().getTime() - sdf.parse(data.get("start_time").toString()).getTime())/1000;
				data.put("duration", time);
			}
		}
		
		modelAndView.addObject("resultList", new Gson().toJson(result));
		
		modelAndView.addObject("type", type);
		modelAndView.setViewName("app/taskhelper/taskhelper");
		return modelAndView;
	}
	
	/**
	 * 开始日清工作
	 * @return
	 */
	@ResponseBody
    @RequestMapping(value="startDailyTask", method=RequestMethod.POST)
    public String startDailyTask(){
    	try {
    		Integer taskid = 0;
    		Integer detailId = 0;
    		
    		PageData pageData = getPageData();
    		pageData.put("EMP_CODE",getUser().getNUMBER());
			String status = positionDailyTaskService.checkAdd(pageData);
			Integer paramId = Integer.valueOf((String)pageData.get("detailid"));
			
			if(status.equals("false")){//当天已存在日清记录，获取日请记录并查询是否有当前职责明细的对应日清明细
				pageData.put("date_flag", "true");
				PageData dailyTask = positionDailyTaskService.find(pageData);
				taskid = (Integer) dailyTask.get("ID");
				
				//获取日清明细
				PageData newDetail = new PageData();
				newDetail.put("daily_task_id", taskid);
				newDetail.put("detail_id", paramId);
				List<PageData> details = positionDailyTaskService.findDetailList(newDetail);
				
				if(details.size() == 0){//当天日清内不包含此条详情,需要先新增详情
					//新增日清明细
					detailId = addDetail(taskid, paramId);
				}else{//当天日清内包含此条详情，获取详情并将次数加一
					PageData detail = details.get(0);
					detailId = (Integer) detail.get("ID");
					addCount(detail);
				}
			}else{//当天未存在日清记录
				PageData addPd = new PageData();
	            addPd.put("EMP_CODE",getUser().getNUMBER());
	            addPd.put("STATUS", Const.SYS_STATUS_YW_CG);
	            savePage(addPd);
	            taskid = (Integer) positionDailyTaskService.add(addPd);
	            //新增日清明细
	            detailId = addDetail(taskid, paramId);
			}
			
			PageData detailTime = new PageData();
			detailTime.put("task_detail_id", detailId);
			detailTime.put("start_time", new Date());
			detailTime.put("groups", ""+taskid + detailId + positionDailyTaskService.findTaskDetailById(detailId).get("count").toString());
			detailTime.put("status", Const.DAILY_TASK_OPERA_DOING);
			savePage(detailTime);
			return positionDailyTaskService.addDetailTime(detailTime).toString();
		} catch (Exception e) {
			e.printStackTrace();
		}
    	return null;
    }
    
	/**
     * 暂停日清助手
     * @return
     */
    @ResponseBody
    @RequestMapping(value="pauseDailyTask", method=RequestMethod.POST)
    public String pauseDailyTask(){
    	String timeId = getPageData().get("timeId").toString();
    	PageData time = new PageData();
		try {
			time = positionDailyTaskService.findDetailTime(timeId);
			time.put("end_time", new Date());
			time.put("status", Const.DAILY_TASK_OPERA_PAUSE);
			updatePage(time);
			return positionDailyTaskService.updateDetailTime(time).toString();
		} catch (Exception e) {
			e.printStackTrace();
			return null;
		}
    }
	
    /**
     * 继续日清助手
     * @return
     */
    @ResponseBody
    @RequestMapping(value="continueDailyTask", method=RequestMethod.POST)
    public String continueDailyTask(){
    	String timeId = getPageData().get("timeId").toString();
    	PageData time = new PageData();
		try {
			time = positionDailyTaskService.findDetailTime(timeId);
			time.put("status", Const.DAILY_TASK_OPERA_DOING);
			time.put("start_time", new Date());
			time.put("end_time", null);
			savePage(time);
			return positionDailyTaskService.addDetailTime(time).toString();
		} catch (Exception e) {
			e.printStackTrace();
			return null;
		}
    }
    
	/**
	 * 结束日清工作
	 * @return
	 */
    @ResponseBody
    @RequestMapping(value="endDailyTask", method=RequestMethod.POST)
    public String endDailyTask(){
        PageData pageData = getPageData();
        try {
        	String timeId = pageData.get("timeId").toString();
			PageData time = positionDailyTaskService.findDetailTime(timeId);
			time.put("end_time", new Date());
			time.put("status", Const.DAILY_TASK_OPERA_END);
			updatePage(time);
			return positionDailyTaskService.updateDetailTime(time).toString();
		} catch (Exception e) {
			e.printStackTrace();
		}
        return null;
    }
    
    /**
	 * 添加收藏
	 * @return
	 * @throws Exception 
	 */
	@ResponseBody
	@RequestMapping(value="addCollection", method=RequestMethod.POST)
	public Integer addCollection() throws Exception{
		PageData pageData = getPageData();
		pageData.put("user",getUser().getNUMBER());
		if(positionDutyService.checkCollection(pageData) == 0){
			return positionDutyService.addCollection(pageData);
		}
		return null;
	}
    
    /**
	 * 移除收藏
	 * @return
	 * @throws Exception 
	 */
	@ResponseBody
	@RequestMapping(value="removeCollection", method=RequestMethod.POST)
	public Integer removeCollection() throws Exception{
		PageData pageData = getPageData();
		pageData.put("user",getUser().getNUMBER());
		return positionDutyService.removeCollection(pageData);
	}
    
    /**
     * 添加新日清明细
     * @param taskId
     * @param detailId
     * @return
     * @throws Exception
     */
    private Integer addDetail(Integer taskId,Integer detailId) throws Exception{
    	PageData detail = new PageData();
		detail.put("daily_task_id", taskId);
		detail.put("detail_id", detailId);
		detail.put("count", 1);
		detail.put("status", Const.SYS_STATUS_YW_CG);
		detail.put("CREATE_TIME", new Date());
		detail.put("CREATE_USER", getUser().getUSERNAME());
		positionDailyTaskService.addDetail(detail);
		return Integer.valueOf(detail.get("ID").toString()); 
    }
   
    /**
     * 增加日清明细次数
     * @param detail
     * @throws Exception
     */
    private void addCount(PageData detail) throws Exception{
		detail.put("count",((Integer)detail.get("count")) + 1);
		detail.put("UPDATE_TIME", new Date());
		detail.put("UPDATE_USER", getUser().getUSERNAME());
		positionDailyTaskService.updateDetail(detail);
    }
}
