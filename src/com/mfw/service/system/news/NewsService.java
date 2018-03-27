package com.mfw.service.system.news;

import java.util.List;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import com.mfw.dao.DaoSupport;
import com.mfw.entity.Page;
import com.mfw.util.PageData;

@Service("newsService")
public class NewsService {

	@Resource(name = "daoSupport")
	private DaoSupport dao;

	//新增
	public void save(PageData pd) throws Exception {
		dao.save("NewsMapper.save", pd);
	}

	//修改
	public void edit(PageData pd) throws Exception {
		dao.update("NewsMapper.edit", pd);
	}

	//通过id获取数据
	public PageData findById(PageData pd) throws Exception {
		return (PageData) dao.findForObject("NewsMapper.findById", pd);
	}

	//查询总数
	public PageData findCount(PageData pd) throws Exception {
		return (PageData) dao.findForObject("NewsMapper.findCount", pd);
	}

	//查询某编码
	public PageData findBmCount(PageData pd) throws Exception {
		return (PageData) dao.findForObject("NewsMapper.findBmCount", pd);
	}

	//列出同一父类id下的数据
	public List<PageData> newslistPage(Page page) throws Exception {
		return (List<PageData>) dao.findForList("NewsMapper.newslistPage", page);
	}
	
	//菜单信息发送
	public List<PageData> mnewslistPage(Page page) throws Exception {
		return (List<PageData>) dao.findForList("NewsMapper.mnewslistPage", page);
	}

	//删除
	public void delete(PageData pd) throws Exception {
		dao.delete("NewsMapper.delete", pd);

	}

}
