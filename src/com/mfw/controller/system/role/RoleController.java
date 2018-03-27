package com.mfw.controller.system.role;

import java.io.PrintWriter;
import java.math.BigInteger;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletResponse;

import org.apache.shiro.SecurityUtils;
import org.apache.shiro.session.Session;
import org.apache.shiro.subject.Subject;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import com.mfw.controller.base.BaseController;
import com.mfw.entity.Page;
import com.mfw.entity.system.Menu;
import com.mfw.entity.system.Role;
import com.mfw.service.system.menu.MenuService;
import com.mfw.service.system.role.RoleService;
import com.mfw.util.Const;
import com.mfw.util.PageData;
import com.mfw.util.RightsHelper;
import com.mfw.util.Tools;

import net.sf.json.JSONArray;

/**
 * 类名称：RoleController 创建人：mfw 创建时间：2014年6月30日
 * 
 * @version
 */
@Controller
@RequestMapping(value = "/role")
public class RoleController extends BaseController {

	@Resource(name = "menuService")
	private MenuService menuService;
	@Resource(name = "roleService")
	private RoleService roleService;

	/**
	 * 权限(增删改查)
	 */
	@RequestMapping(value = "/qx")
	public ModelAndView qx() throws Exception {
		ModelAndView mv = this.getModelAndView();
		PageData pd = new PageData();
		try {
			pd = this.getPageData();
			String msg = pd.getString("msg");
			roleService.updateQx(msg, pd);

			mv.setViewName("save_result");
			mv.addObject("msg", "success");
		} catch (Exception e) {
			logger.error(e.toString(), e);
		}
		return mv;
	}

	/**
	 * K权限
	 */
	@RequestMapping(value = "/kfqx")
	public ModelAndView kfqx() throws Exception {
		ModelAndView mv = this.getModelAndView();
		PageData pd = new PageData();
		try {
			pd = this.getPageData();
			String msg = pd.getString("msg");
			roleService.updateKFQx(msg, pd);

			mv.setViewName("save_result");
			mv.addObject("msg", "success");
		} catch (Exception e) {
			logger.error(e.toString(), e);
		}
		return mv;
	}

	/**
	 * c权限
	 */
	@RequestMapping(value = "/gysqxc")
	public ModelAndView gysqxc() throws Exception {
		ModelAndView mv = this.getModelAndView();
		PageData pd = new PageData();
		try {
			pd = this.getPageData();
			String msg = pd.getString("msg");
			roleService.gysqxc(msg, pd);

			mv.setViewName("save_result");
			mv.addObject("msg", "success");
		} catch (Exception e) {
			logger.error(e.toString(), e);
		}
		return mv;
	}

	/**
	 * 列表
	 */
	@RequestMapping
	public ModelAndView list(Page page) throws Exception {
		ModelAndView mv = this.getModelAndView();
		PageData pd = new PageData();
		pd = this.getPageData();

		String roleId = pd.getString("ROLE_ID");
		if (roleId == null || "".equals(roleId)) {
			pd.put("ROLE_ID", "1");
		}
		List<Role> roleList = roleService.listAllRoles(); //列出所有部门
		List<Role> roleList_z = roleService.listAllRolesByPId(pd); //列出此部门的所有下级

		List<PageData> kefuqxlist = roleService.listAllkefu(pd); //管理权限列表
		List<PageData> gysqxlist = roleService.listAllGysQX(pd); //用户权限列表

		/* 调用权限 */
		this.getHC(); //================================================================================
		/* 调用权限 */

		pd = roleService.findObjectById(pd); //取得点击部门

		mv.addObject("pd", pd);
		mv.addObject("kefuqxlist", kefuqxlist);
		mv.addObject("gysqxlist", gysqxlist);
		mv.addObject("roleList", roleList);
		mv.addObject("roleList_z", roleList_z);
		mv.setViewName("system/role/role_list");

		return mv;
	}

	/**
	 * 新增页面
	 */
	@RequestMapping(value = "/toAdd")
	public ModelAndView toAdd(Page page) {
		ModelAndView mv = this.getModelAndView();
		PageData pd = new PageData();
		try {
			pd = this.getPageData();
			mv.setViewName("system/role/role_add");
			mv.addObject("pd", pd);
		} catch (Exception e) {
			logger.error(e.toString(), e);
		}
		return mv;
	}

	/**
	 * 保存新增信息
	 */
	@RequestMapping(value = "/add", method = RequestMethod.POST)
	public ModelAndView add() throws Exception {
		ModelAndView mv = this.getModelAndView();
		PageData pd = new PageData();
		try {
			pd = this.getPageData();

			String parent_id = pd.getString("PARENT_ID"); //父类角色id
			pd.put("ROLE_ID", parent_id);
			if ("0".equals(parent_id)) {
				pd.put("RIGHTS", "");
			} else {
				String rights = roleService.findObjectById(pd).getString("RIGHTS");
				pd.put("RIGHTS", (null == rights) ? "" : rights);
			}

			pd.put("QX_ID", "");

			String UUID = this.get32UUID();

			pd.put("GL_ID", UUID);
			pd.put("FX_QX", 0); //发信权限
			pd.put("FW_QX", 0); //服务权限
			pd.put("QX1", 0); //操作权限
			pd.put("QX2", 0); //产品权限
			pd.put("QX3", 0); //预留权限
			pd.put("QX4", 0); //预留权限
			roleService.saveKeFu(pd); //保存到K权限表

			pd.put("U_ID", UUID);
			pd.put("C1", 0); //每日发信数量
			pd.put("C2", 0);
			pd.put("C3", 0);
			pd.put("C4", 0);
			pd.put("Q1", 0); //权限1
			pd.put("Q2", 0); //权限2
			pd.put("Q3", 0);
			pd.put("Q4", 0);
			roleService.saveGYSQX(pd); //保存到G权限表
			pd.put("QX_ID", UUID);

			pd.put("ROLE_ID", UUID);
			pd.put("ADD_QX", "0");
			pd.put("DEL_QX", "0");
			pd.put("EDIT_QX", "0");
			pd.put("CHA_QX", "0");
			roleService.add(pd);
			mv.addObject("msg", "success");
		} catch (Exception e) {
			logger.error(e.toString(), e);
			mv.addObject("msg", "failed");
		}
		mv.setViewName("save_result");
		return mv;
	}

	/**
	 * 请求编辑
	 */
	@RequestMapping(value = "/toEdit")
	public ModelAndView toEdit(String ROLE_ID) throws Exception {
		ModelAndView mv = this.getModelAndView();
		PageData pd = new PageData();
		try {
			pd = this.getPageData();
			pd.put("ROLE_ID", ROLE_ID);
			pd = roleService.findObjectById(pd);

			mv.setViewName("system/role/role_edit");
			mv.addObject("pd", pd);
		} catch (Exception e) {
			logger.error(e.toString(), e);
		}
		return mv;
	}

	/**
	 * 编辑
	 */
	@RequestMapping(value = "/edit")
	public ModelAndView edit() throws Exception {
		ModelAndView mv = this.getModelAndView();
		PageData pd = new PageData();
		try {
			pd = this.getPageData();
			pd = roleService.edit(pd);
			mv.addObject("msg", "success");
		} catch (Exception e) {
			logger.error(e.toString(), e);
			mv.addObject("msg", "failed");
		}
		mv.setViewName("save_result");
		return mv;
	}
	
	/**
	 * 返回所在组选择的菜单
	 */
	private List<Menu> getSubList(String parentRoleRights, List<Menu> parentMenuList) throws Exception{
		List<Menu> menuList = new ArrayList<Menu>();
		for (Menu menu : parentMenuList) {
			if(RightsHelper.testRights(parentRoleRights, menu.getMENU_ID())){
				List<Menu> subMenuList = menuService.listSubMenuByParentId(menu.getMENU_ID());
				menu.setSubMenu(getSubList(parentRoleRights, subMenuList));
				menuList.add(menu);
			}
		}
		
		return menuList;
	}

	/**
	 * 请求角色菜单授权页面
	 */
	@RequestMapping(value = "/auth")
	public String auth(@RequestParam String ROLE_ID, Model model) throws Exception {

		try {
			Role role = roleService.getRoleById(ROLE_ID);
			String roleRights = role.getRIGHTS();
			List<Menu> menuList = new ArrayList<Menu>();
			if("0".equals(role.getPARENT_ID())){//组菜单权限
				menuList =  menuService.listAllMenu();
			}else{//组下面的角色的菜单权限
				Role parentRole = roleService.getRoleById(role.getPARENT_ID());
				String parentRoleRights = parentRole.getRIGHTS();
				
				List<Menu> parentMenuList = menuService.listAllParentMenu();
				menuList = getSubList(parentRoleRights, parentMenuList);
			}
			
			if (Tools.notEmpty(roleRights)) {
				for (Menu menu : menuList) {
					menu.setHasMenu(RightsHelper.testRights(roleRights, menu.getMENU_ID()));
					if (menu.isHasMenu()) {
						List<Menu> subMenuList = menu.getSubMenu();
						for (Menu sub : subMenuList) {
							sub.setHasMenu(RightsHelper.testRights(roleRights, sub.getMENU_ID()));
                            if (sub.isHasMenu()) {
                                List<Menu> newSubMenuList = sub.getSubMenu();
                                for (Menu newSub : newSubMenuList) {
                                    newSub.setHasMenu(RightsHelper.testRights(roleRights, newSub.getMENU_ID()));
                                }
                            }
						}
					}
				}
			}
			JSONArray arr = JSONArray.fromObject(menuList);
			String json = arr.toString();
            json = json.replaceAll("subMenu", "nodes");
            json = json.replaceAll("MENU_ID", "id");
            json = json.replaceAll("MENU_NAME", "name");
            json = json.replaceAll("hasMenu", "checked");

			model.addAttribute("zTreeNodes", json);
			model.addAttribute("roleId", ROLE_ID);
			
			PageData pd2 = new PageData();
			List<PageData> btnRoleList = roleService.getBtnRoleListByParams(pd2);
			JSONArray arr2 = JSONArray.fromObject(btnRoleList);
			String json2 = arr2.toString();
			json2 = json2.replaceAll("BUTTONS_ID", "id").replaceAll("BUTTONS_NAME", "name")
					.replaceAll("\"false\"", "false").replaceAll("\"true\"", "true");
			model.addAttribute("zBtnTreeNodes", json2);
		} catch (Exception e) {
			logger.error(e.toString(), e);
		}

		return "authorization";
	}

	/**
	 * 请求角色按钮授权页面
	 */
	@RequestMapping(value = "/button")
	public ModelAndView button(@RequestParam String ROLE_ID, @RequestParam String msg, Model model) throws Exception {
		ModelAndView mv = this.getModelAndView();
		try {
			List<Menu> menuList = menuService.listAllMenu();
			Role role = roleService.getRoleById(ROLE_ID);

			String roleRights = "";
			if ("add_qx".equals(msg)) {
				roleRights = role.getADD_QX();
			} else if ("del_qx".equals(msg)) {
				roleRights = role.getDEL_QX();
			} else if ("edit_qx".equals(msg)) {
				roleRights = role.getEDIT_QX();
			} else if ("cha_qx".equals(msg)) {
				roleRights = role.getCHA_QX();
			}

			if (Tools.notEmpty(roleRights)) {
				for (Menu menu : menuList) {
					menu.setHasMenu(RightsHelper.testRights(roleRights, menu.getMENU_ID()));
					if (menu.isHasMenu()) {
						List<Menu> subMenuList = menu.getSubMenu();
						for (Menu sub : subMenuList) {
							sub.setHasMenu(RightsHelper.testRights(roleRights, sub.getMENU_ID()));
						}
					}
				}
			}
			JSONArray arr = JSONArray.fromObject(menuList);
			String json = arr.toString();
			//System.out.println(json);
			json = json.replaceAll("MENU_ID", "id").replaceAll("MENU_NAME", "name").replaceAll("subMenu", "nodes").replaceAll("hasMenu", "checked");
			mv.addObject("zTreeNodes", json);
			mv.addObject("roleId", ROLE_ID);
			mv.addObject("msg", msg);
		} catch (Exception e) {
			logger.error(e.toString(), e);
		}
		mv.setViewName("system/role/role_button");
		return mv;
	}

	/**
	 * 保存角色菜单权限
	 */
	@RequestMapping(value = "/auth/save")
	public void saveAuth(@RequestParam String ROLE_ID, @RequestParam String menuIds, PrintWriter out) throws Exception {
		PageData pd = new PageData();
		try {
			if (null != menuIds && !"".equals(menuIds.trim())) {
				BigInteger rights = RightsHelper.sumRights(Tools.str2StrArray(menuIds));
				Role role = roleService.getRoleById(ROLE_ID);
				role.setRIGHTS(rights.toString());
				roleService.updateRoleRights(role);
				pd.put("rights", rights.toString());
			} else {
				Role role = new Role();
				role.setRIGHTS("");
				role.setROLE_ID(ROLE_ID);
				roleService.updateRoleRights(role);
				pd.put("rights", "");
			}

			pd.put("roleId", ROLE_ID);
			roleService.setAllRights(pd);

			out.write("success");
			out.close();
		} catch (Exception e) {
			logger.error(e.toString(), e);
		}
	}

	/**
	 * 保存角色按钮权限
	 */
	@RequestMapping(value = "/roleButton/save")
	public void roleButtonSave(@RequestParam String ROLE_ID, @RequestParam String buttonIds, @RequestParam String MENU_ID,@RequestParam String events, PrintWriter out) throws Exception {
		PageData pd = new PageData();
		pd = this.getPageData();
		try {
			pd.put("roleId", ROLE_ID);
			pd.put("menuId", MENU_ID);
			
			roleService.deleteRoleButton(pd);
			pd.put("gxId", 0);
			String menuCode = pd.getString("MENU_CODE");
			if (null != buttonIds && !"".equals(buttonIds.trim())) {
				String[] buttonIdArr = buttonIds.split(",");
				String[] eventArr = pd.get("events").toString().split(","); 
 				if(buttonIdArr.length>0){
					for(int i=0;i<buttonIdArr.length;i++){
						
						pd.put("buttonsId", buttonIdArr[i]);
						pd.put("anqxCode", menuCode+":"+eventArr[i]);
						roleService.addRoleButton(pd);
					}
				}
				
			} else {
				pd.put("value", "");
			}
			pd.put("ROLE_ID", ROLE_ID);
			//roleService.updateQx( pd);

			out.write("success");
			out.close();
		} catch (Exception e) {
			logger.error(e.toString(), e);
		}
	}

	/**
	 * 删除
	 */
	@RequestMapping(value = "/delete")
	public void deleteRole(@RequestParam String ROLE_ID, PrintWriter out) throws Exception {
		PageData pd = new PageData();
		try {
			pd.put("ROLE_ID", ROLE_ID);
			List<Role> roleList_z = roleService.listAllRolesByPId(pd); //列出此部门的所有下级
			if (roleList_z.size() > 1) {//不包含角色组本身
				out.write("false");
			} else {

				List<PageData> userlist = roleService.listAllUByRid(pd);
				List<PageData> appuserlist = roleService.listAllAppUByRid(pd);
				if (userlist.size() > 0 || appuserlist.size() > 0) {
					out.write("false2");
				} else {
					roleService.deleteRoleById(ROLE_ID);
					roleService.deleteKeFuById(ROLE_ID);
					roleService.deleteGById(ROLE_ID);
					out.write("success");
				}
			}
			out.close();
		} catch (Exception e) {
			logger.error(e.toString(), e);
		}
	}
	
	/**
	 * 请求角色按钮授权页面_new
	 */
	@RequestMapping(value = "/buttonRole")
	public ModelAndView buttonRole(@RequestParam String ROLE_ID, Model model) throws Exception {
		ModelAndView mv = this.getModelAndView();
		try {
			List<Menu> menuList = menuService.listAllMenu();
			Role role = roleService.getRoleById(ROLE_ID);
			String roleRights = role.getRIGHTS();
			List<Menu> menuRoleList = new ArrayList<Menu>();
			if (Tools.notEmpty(roleRights)) {
				for (int i=0;i<menuList.size();i++) {
					Menu menu = menuList.get(i);
					if(RightsHelper.testRights(roleRights, menu.getMENU_ID())){
						menu.setHasMenu(true);
						if (menu.isHasMenu()) {
							List<Menu> subMenuList = menu.getSubMenu();
							menu.setSubMenu(null);
							List<Menu> subMenuRoleList = new ArrayList<Menu>();
							for (Menu sub : subMenuList) {
								if(RightsHelper.testRights(roleRights, sub.getMENU_ID())){
									sub.setHasMenu(true);
									subMenuRoleList.add(sub);
								}
							}
							menu.setSubMenu(subMenuRoleList);
						}
						menuRoleList.add(menu);
					}
				}
			}
			JSONArray arr = JSONArray.fromObject(menuRoleList);
			String json = arr.toString();
			json = json.replaceAll("MENU_ID", "id").replaceAll("MENU_NAME", "name").replaceAll("subMenu", "nodes").replaceAll("hasMenu", "checked");
			mv.addObject("zTreeNodes", json);
			mv.addObject("roleId", ROLE_ID);
			
			//zBtnTree
			PageData pd2 = new PageData();
			List btnRoleList = roleService.getBtnRoleListByParams(pd2);
			JSONArray arr2 = JSONArray.fromObject(btnRoleList);
			String json2 = arr2.toString();
			json2 = json2.replaceAll("BUTTONS_ID", "id").replaceAll("BUTTONS_NAME", "name").replaceAll("\"false\"", "false").replaceAll("\"true\"", "true");
			mv.addObject("zBtnTreeNodes", json2);
		} catch (Exception e) {
			logger.error(e.toString(), e);
		}
		mv.setViewName("system/role/role_button");
		return mv;
	}
	
	/**
	 * 通过角色、菜单，获取按钮权限
	 */
	@RequestMapping(value = "/getBtnRole",produces = "text/html;charset=UTF-8")
	public void getBtnRole(@RequestParam String ROLE_ID, @RequestParam String MENU_ID,  HttpServletResponse response) throws Exception {
		ModelAndView mv = this.getModelAndView();
		PageData pd = new PageData();
		try {
			pd = this.getPageData();
			List btnRoleList = roleService.getBtnRoleListByParams(pd);
			JSONArray arr = JSONArray.fromObject(btnRoleList);
			String json = arr.toString();
			//System.out.println(json);
			json = json.replaceAll("BUTTONS_ID", "id").replaceAll("BUTTONS_NAME", "name").replaceAll("\"false\"", "false").replaceAll("\"true\"", "true");
//			mv.addObject("zBtnTreeNodes", json);
//			mv.addObject("roleId", ROLE_ID);
//			mv.addObject("menuId", MENU_ID);
//			mv.addObject("msg", "success");
			response.setCharacterEncoding("UTF-8");
			response.setContentType("text/html");
			PrintWriter out = response.getWriter();
			out.write(json);
			out.flush();
			out.close();
		} catch (Exception e) {
			logger.error(e.toString(), e);
		}
	}

	/* ===============================权限================================== */
	public void getHC() {
		ModelAndView mv = this.getModelAndView();
		//shiro管理的session
		Subject currentUser = SecurityUtils.getSubject();
		Session session = currentUser.getSession();
		Map<String, Integer> map = (Map<String, Integer>) session.getAttribute(Const.SESSION_QX);
		mv.addObject(Const.SESSION_QX, map); //按钮权限
		List<Menu> menuList = (List) session.getAttribute(Const.SESSION_menuList);
		mv.addObject(Const.SESSION_menuList, menuList);//菜单权限
	}
	/* ===============================权限================================== */

}
