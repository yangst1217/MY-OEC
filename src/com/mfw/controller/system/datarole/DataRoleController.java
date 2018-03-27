package com.mfw.controller.system.datarole;

import java.util.List;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import com.mfw.controller.base.BaseController;
import com.mfw.service.bdata.DeptService;
import com.mfw.service.system.datarole.DataRoleService;
import com.mfw.util.PageData;
import com.mfw.util.UserUtils;

import net.sf.json.JSONArray;

/**
 * 数据权限控制类
 * @author liweitao
 *
 * 修改时间		修改人		修改内容
 * 2016-03-18	李伟涛		新建
 */
@Controller
@RequestMapping("/data_role")
public class DataRoleController extends BaseController {

	@Resource(name="deptService")
	private DeptService deptService;
	@Resource(name="dataroleService")
	private DataRoleService dataroleService;
	
	/**
	 * 根据用户ID获取数据权限
	 * @return
	 * 修改时间		修改人		修改内容</br>
	 * 2016-03-18	李伟涛		新建</br>
	 */
	@RequestMapping(value="findByUser",method=RequestMethod.GET)
	public String findDataRoleByUser(String USER_ID,Model model){
		try {
			List<PageData> depts = deptService.listAlln();
			List<PageData> dataRoles = dataroleService.findByUser(USER_ID);
			for(PageData dataRole : dataRoles){
				for(PageData pageData : depts){
					if( dataRole.get("DEPT_ID").equals(pageData.get("ID")) ){
						pageData.put("checked", "true");
					}
				}
			}
			JSONArray arr = JSONArray.fromObject(depts);
			model.addAttribute("zTreeNodes", arr.toString());
			model.addAttribute("userId", USER_ID);
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
		}
		return "data_role";
	}
	
	/**
	 * 保存用户数据权限，需先删除用户之前的数据
	 * @param userId
	 * @param deptIds
	 * @return
	 * 修改时间		修改人		修改内容
	 * 2016-03-18	李伟涛		新建
	 */
	@ResponseBody
	@RequestMapping(value="/save",method=RequestMethod.POST)
	public String save(String userId, String deptIds, HttpServletRequest request){
		try {
			String currentUserId = UserUtils.getUser(request).getUSER_ID();
			dataroleService.save(userId, deptIds, currentUserId);
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
			return "failed";
		}
		return "success";
	}
}
