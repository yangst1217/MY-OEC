package com.mfw.controller.base;

import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Map;
import java.util.Set;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.apache.shiro.SecurityUtils;
import org.apache.shiro.session.Session;
import org.apache.shiro.subject.Subject;
import org.springframework.beans.propertyeditors.CustomDateEditor;
import org.springframework.web.bind.WebDataBinder;
import org.springframework.web.bind.annotation.InitBinder;
import org.springframework.web.context.request.RequestContextHolder;
import org.springframework.web.context.request.ServletRequestAttributes;
import org.springframework.web.servlet.ModelAndView;

import com.mfw.entity.Page;
import com.mfw.entity.system.Menu;
import com.mfw.entity.system.User;
import com.mfw.service.bdata.CommonService;
import com.mfw.util.Const;
import com.mfw.util.Logger;
import com.mfw.util.PageData;
import com.mfw.util.UserUtils;
import com.mfw.util.UuidUtil;

import net.sf.json.JSONArray;

/**
 * Controller基类
 * @author
 *
 */
public class BaseController {

	protected Logger logger = Logger.getLogger(this.getClass());

	/**
	 * 得到PageData
	 */
	public PageData getPageData() {
		return new PageData(this.getRequest());
	}
	
	/**
	 * 得到ModelAndView
	 */
	public ModelAndView getModelAndView() {
		return new ModelAndView();
	}

	/**
	 * 得到request对象
	 */
	public HttpServletRequest getRequest() {
		HttpServletRequest request = 
				((ServletRequestAttributes) RequestContextHolder.getRequestAttributes()).getRequest();
		return request;
	}

	/**
	 * 得到32位的uuid
	 * 
	 * @return
	 */
	public String get32UUID() {
		return UuidUtil.get32UUID();
	}

	public static void logBefore(Logger logger, String interfaceName) {
		logger.info("");
		logger.info("start");
		logger.info(interfaceName);
	}

	public static void logAfter(Logger logger) {
		logger.info("end");
		logger.info("");
	}
	
	/**
	 * 转换列表分页实体类
	 * @param pageData
	 * @param request
	 */
	public void convertPage(Page page, HttpServletRequest request){
		PageData pageData = getPageData();
		
		getSortMethod(pageData, request);
		getSearchPhrase(pageData, request);
		
		page.setPd(pageData);
		page.setShowCount(Integer.valueOf(request.getParameter("rowCount")));
		page.setCurrentPage(Integer.valueOf(request.getParameter("current")));
		
	}
	
	/**
	 * 获取用户信息
	 * @return
	 */
	public User getUser(){
		Subject currentUser = SecurityUtils.getSubject();  
		Session session = currentUser.getSession();
		User user = (User)session.getAttribute(Const.SESSION_USER);
		return user;
	}
	
	/**
	 * 获取用户角色信息
	 * @return
	 */
	public User getUserRole(){
		Subject currentUser = SecurityUtils.getSubject();  
		Session session = currentUser.getSession();
		User user = (User)session.getAttribute(Const.SESSION_USERROL);
		return user;
	}
	
	/**
	 * 新增数据时设置默认信息
	 * @param pd
	 * @return
	 */
	public PageData savePage(PageData pd){
		User user=getUser();
		pd.put("isdel","0");//0 有效，1或者null 无效
		pd.put("createUser", user.getUSERNAME());
		pd.put("createTime", new Date());
		return pd;
	}
	
	/**
	 * 更新数据时组装更新信息
	 * @param pd
	 * @return
	 */
	public PageData updatePage(PageData pd){
		User user=getUser();
		pd.put("updateUser", user.getUSERNAME());
		pd.put("updateTime", new Date());
		return pd;
	}
	
    /**
     * 为MV内放入部门树
     * @param mv
     * @throws Exception
     * author yangdw
     */
    public void deptTreeNodes(ModelAndView mv, List<PageData> deptList) throws Exception {
        //获取部门树
        List<PageData> tdeptList = new ArrayList<PageData>();
        for(int i =0; i< deptList.size();i++){
            PageData dept = deptList.get(i);
            dept.put("open",true);
            tdeptList.add(dept);
        }
        JSONArray arr = JSONArray.fromObject(tdeptList);
        mv.addObject("deptTreeNodes", arr.toString());
    }
    
    /**
     * 调用权限
     */
    @SuppressWarnings("unchecked")
	public void getHC(){
		ModelAndView mv = this.getModelAndView();
		HttpSession session = this.getRequest().getSession();
		Map<String, String> map = (Map<String, String>) session.getAttribute(Const.SESSION_QX);
		mv.addObject(Const.SESSION_QX,map);	//按钮权限
		List<Menu> menuList = (List<Menu>) session.getAttribute(Const.SESSION_menuList);
		mv.addObject(Const.SESSION_menuList, menuList);//菜单权限
	}
    
    /**
     * 绑定Bean中的日期对象
     * @param binder
     */
    @InitBinder
	public void initBinder(WebDataBinder binder){
		DateFormat format = new SimpleDateFormat("yyyy-MM-dd");
		binder.registerCustomEditor(Date.class, new CustomDateEditor(format,true));
	}
    
    /**
	 * 获取搜索参数
	 * @param request
	 * @return
	 */
	public void getSearchPhrase(PageData pageData, HttpServletRequest request){
		if(null == request.getParameter("searchPhrase")){
			Set<String> paramKeys = request.getParameterMap().keySet();
			String searchKey = "";
			String searchPhrase = "";
			for(String str : paramKeys){
				if(str.startsWith("searchPhrase")){
					searchKey = str.substring(13, str.length()-1);
					searchPhrase = request.getParameter(str);
					pageData.put(searchKey, searchPhrase);
				}
			}
		}
	}
	
	/**
	 * 获取排序方法
	 * @param pageData
	 * @param request
	 */
	public void getSortMethod(PageData pageData,HttpServletRequest request){
		for(String str : request.getParameterMap().keySet()){
			if(str.startsWith("sort")){
				pageData.put("sortKey", str.substring(5, str.length()-1));
				pageData.put("sortMethod", request.getParameter(str));
				break;
			}
		}
		
	}
    /**
	 * 获取当前用户的下属部门列表
	 */
	public List<PageData> getDeptList(HttpServletRequest request, CommonService commonService){
		User user = UserUtils.getUser(request);
		PageData pd = new PageData();
		
		List<PageData> myList = new ArrayList<PageData>();
		try {
			String roleId = user.getRole().getROLE_ID();
			if(roleId != null){
				int count = commonService.checkSysRole(roleId);
				if(count==0){//不是管理员
					PageData dep = commonService.findDeptByEmpCode(user.getNUMBER());//当前部门信息
					myList = findAllChild(dep, commonService);//当前部门及其下属部门
				}else{//管理员
					myList = commonService.findDeptNoCom(pd);
				}
			}
		} catch (Exception e) {
			logger.error("获取当前用户的下属部门列表出错", e);
		}
		
		return myList;
	}
	/**
	 * 查询当前部门的下一级部门
	 */
	public List<PageData> findAllChild(PageData dep, CommonService commonService) throws Exception{
        List<PageData> childList = commonService.findChildDeptByDeptId(dep);
        List<PageData> myList = new ArrayList<PageData>();
        if(childList == null){//没有子部门则只添加当前部门
            myList.add(dep);
        }else {//有子部门，则循环查询是否存在下一级部门
        	myList.add(dep);
            for (int i = 0;i< childList.size();i++){
            	PageData eachChild = childList.get(i);
                myList.addAll(findAllChild(eachChild, commonService));
            }
        }
        return myList;
    }
	
	/**
	 * 查询员工所在部门的负责人，部门负责人则查询上一级领导
	 */
	public List<String> findLeaderByEmp(CommonService commonService) throws Exception{
		List<String> leaderEmpCodeList = new ArrayList<String>();
		PageData leader = commonService.findDeptLeader(getUser().getDeptId().toString());
		if(null!=leader){//部门负责人不为空时，判断是否是查询部门负责人的领导
			String leaderEmpCode = leader.getString("EMP_CODE");
			String empCode = getUser().getNUMBER();
			//当前员工为部门负责人则需要查询上级领导
			if(empCode!=null && empCode.equals(leaderEmpCode)){
				List<PageData> leaderList= commonService.findEmpCodeInDataRoleByDeptId(getUser().getDeptId());
				for(PageData leaderPd : leaderList){
					leaderEmpCodeList.add(leaderPd.getString("NUMBER"));
				}
			}else{//当前员工为普通员工
				leaderEmpCodeList.add(leaderEmpCode);
			}
		}
		
		return leaderEmpCodeList;
	}
	
}
