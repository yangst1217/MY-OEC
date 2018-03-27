package com.mfw.service.task;

import java.util.List;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import com.mfw.dao.DaoSupport;
import com.mfw.util.PageData;

@Service("taskFileService")
public class TaskFileService {

	@Resource(name="daoSupport")
	private DaoSupport dao;
	
	/**
	 * 保存上传的附件
	 */
	public void saveFile(PageData pd) throws Exception{
		dao.save("TaskFileMapper.saveFile", pd);
	}
	
	/**
	 * 删除任务关联的所有文件
	 */
	public void deleteFile(PageData pd) throws Exception{
		dao.delete("TaskFileMapper.deleteFile", pd);
	}

	/**
	 * 根据文件ID删除与任务的关联
	 */
	public void deleteFileByFileId(Integer id) throws Exception{
		dao.delete("TaskFileMapper.deleteFileByFileId", id);
	}
	
	/**
	 * 查询任务对应的文件列表
	 */
	@SuppressWarnings("unchecked")
	public List<PageData> findFile(PageData pd) throws Exception{
		return (List<PageData>) dao.findForList("TaskFileMapper.findFile", pd);
	}
}
