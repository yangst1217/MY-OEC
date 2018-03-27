package com.mfw.service.bdata;

import java.util.List;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import com.mfw.dao.DaoSupport;
import com.mfw.entity.Page;
import com.mfw.util.PageData;

@Service("paymentService")
public class PaymentService {
	@Resource(name = "daoSupport")
	private DaoSupport dao;

	@SuppressWarnings("unchecked")
	public List<PageData> list(Page page) throws Exception{
		return (List<PageData>)dao.findForList("paymentMapper.listPage", page);
	}

	public void add(PageData pd) throws Exception {
		dao.save("paymentMapper.add", pd);
	}

	public PageData findById(PageData pd) throws Exception {
		return (PageData)dao.findForObject("paymentMapper.findById", pd);
	}

	public void edit(PageData pd) throws Exception {
		dao.update("paymentMapper.edit", pd);
		
	}

	public void delete(PageData pd) throws Exception {
		dao.update("paymentMapper.delete", pd);
		
	}

	public List<PageData> checkExist(PageData pd) throws Exception {
		return (List<PageData>)dao.findForList("paymentMapper.checkExist", pd);
	}

}
