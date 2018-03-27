package com.mfw.service.system.menu;

import java.util.List;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import com.mfw.dao.DaoSupport;
import com.mfw.entity.system.Menu;
import com.mfw.util.PageData;

@Service("menuService")
public class MenuService {

	@Resource(name = "daoSupport")
	private DaoSupport dao;

	public void deleteMenuById(String MENU_ID) throws Exception {
		dao.save("MenuMapper.deleteMenuById", MENU_ID);

	}

	public PageData getMenuById(PageData pd) throws Exception {
		return (PageData) dao.findForObject("MenuMapper.getMenuById", pd);

	}

	//取最大id
	public PageData findMaxId(PageData pd) throws Exception {
		return (PageData) dao.findForObject("MenuMapper.findMaxId", pd);

	}

	public List<Menu> listAllParentMenu() throws Exception {
		return (List<Menu>) dao.findForList("MenuMapper.listAllParentMenu", null);

	}

    /**
     * 列出所有可供增加子菜单的菜单
     * @return
     * @throws Exception
     */
    public List<Menu> listAlltoAddMenu() throws Exception {
        return (List<Menu>) dao.findForList("MenuMapper.listAlltoAddMenu", null);

    }

	public void saveMenu(Menu menu) throws Exception {
		if (menu.getMENU_ID() != null && menu.getMENU_ID() != "") {
			//dao.update("MenuMapper.updateMenu", menu);
			dao.save("MenuMapper.insertMenu", menu);
		} else {
			dao.save("MenuMapper.insertMenu", menu);
		}
	}

	public List<Menu> listSubMenuByParentId(String parentId) throws Exception {
		return (List<Menu>) dao.findForList("MenuMapper.listSubMenuByParentId", parentId);

	}

	public List<Menu> listAllMenu() throws Exception {
		List<Menu> rl = this.listAllParentMenu();
		for (Menu menu : rl) {
			List<Menu> subList = this.listSubMenuByParentId(menu.getMENU_ID());
			menu.setSubMenu(subList);
            for(Menu newMenu : subList){
                List<Menu> newSubList = this.listSubMenuByParentId(newMenu.getMENU_ID());
                newMenu.setSubMenu(newSubList);
            }
		}
		return rl;
	}

	public List<Menu> listAllSubMenu() throws Exception {
		return (List<Menu>) dao.findForList("MenuMapper.listAllSubMenu", null);

	}

	/**
	 * 编辑
	 */
	public PageData edit(PageData pd) throws Exception {
		return (PageData) dao.findForObject("MenuMapper.updateMenu", pd);
	}

	/**
	 * 保存菜单图标 (顶部菜单)
	 */
	public PageData editicon(PageData pd) throws Exception {
		return (PageData) dao.findForObject("MenuMapper.editicon", pd);
	}

	/**
	 * 更新子菜单类型菜单
	 */
	public PageData editType(PageData pd) throws Exception {
		return (PageData) dao.findForObject("MenuMapper.editType", pd);
	}
	
	@SuppressWarnings("unchecked")
	public List<Menu> listAppMenu() throws Exception {
		return (List<Menu>) dao.findForList("MenuMapper.listAppMenu", null);
	}

	/**
	 * 根据URL获取菜单详情
	 * @param url
	 * @return
	 * @throws Exception 
	 */
	public PageData findByUrl(String url) throws Exception {
		return (PageData) dao.findForObject("MenuMapper.findByUrl", url);
	}
}
