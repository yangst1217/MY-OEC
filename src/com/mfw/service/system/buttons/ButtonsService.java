package com.mfw.service.system.buttons;

import java.util.List;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import com.mfw.dao.DaoSupport;
import com.mfw.entity.Page;
import com.mfw.entity.system.Buttons;
import com.mfw.util.PageData;

@Service("buttonsService")
public class ButtonsService {
	
	@Resource(name = "daoSupport")
	private DaoSupport dao;

	public List<PageData> list(Page page) throws Exception {
		return (List<PageData>) dao.findForList("ButtonsMapper.datalistPage", page);
	}

	public void add(PageData pd) throws Exception {
		dao.findForList("ButtonsMapper.insert", pd);
	}

	public PageData findObjectById(PageData pd) throws Exception {
		return (PageData) dao.findForObject("ButtonsMapper.findObjectById", pd);
	}

	public PageData edit(PageData pd) throws Exception {
		return (PageData) dao.findForObject("ButtonsMapper.edit", pd);
	}

	public void deleteButtonsById(String BUTTONS_ID) throws Exception {
		// TODO Auto-generated method stub
		dao.delete("ButtonsMapper.deleteButtonsById", BUTTONS_ID);
	}

}
