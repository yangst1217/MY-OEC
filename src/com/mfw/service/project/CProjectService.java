package com.mfw.service.project;

import java.util.Date;
import java.util.List;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import com.mfw.dao.DaoSupport;
import com.mfw.entity.Page;
import com.mfw.entity.project.CProject;
import com.mfw.util.Const;
import com.mfw.util.EndPointServer;
import com.mfw.util.PageData;
import com.mfw.util.TaskType;

/**
 * 创新项目Service
 * @author liweitao
 *
 */
@Service("cprojectService")
public class CProjectService {

	@Resource(name = "daoSupport")
	private DaoSupport dao;
	
	/**
	 * 获取所有创新项目
	 * @return 
	 * @throws Exception 
	 */
	@SuppressWarnings("unchecked")
	public List<PageData> findAll(PageData pageData) throws Exception{
		return (List<PageData>) dao.findForList("CProjectMapper.findAll", pageData);
	}

	public void add(CProject project) throws Exception {
		dao.save("CProjectMapper.add", project);
	}
	
	/**
	 * 保存节点信息
	 * @param pageData
	 * @throws Exception 
	 */
	public void saveNode(PageData pageData) throws Exception {
		dao.save("CProjectMapper.saveNode", pageData);
	}
	
	/**
	 * 获取分页列表
	 * @param page
	 * @return
	 * @throws Exception
	 */
	@SuppressWarnings("unchecked")
	public List<PageData> findList(Page page) throws Exception{
		return (List<PageData>) dao.findForList("CProjectMapper.listPage", page);
	}

	/**
	 * 根据当前登录人审核列表
	 * @param page
	 * @return
	 * @throws Exception
	 */
	@SuppressWarnings("unchecked")
	public List<PageData> auditList(Page page) throws Exception{
		return (List<PageData>) dao.findForList("CProjectMapper.auditList", page);
	}
	
	public int countCP(Page page) throws Exception {
		return (int) dao.findForObject("CProjectMapper.countCP", page);
	}
	
	public int countAudit(Page page) throws Exception{
		return (int) dao.findForObject("CProjectMapper.countAudit", page);
	}

	/**
	 * 检查当前编码是否可用
	 * @param code
	 * @return
	 * @throws Exception
	 */
//	public String checkCode(PageData pageData) throws Exception {
//		int count = (int) dao.findForObject("CProjectMapper.checkCode", pageData);
//		if(count == 0){
//			return "success";
//		}else{
//			return "failed";
//		}
//	}

	/**
	 * 根据ID数组删除项目
	 * @param ids
	 * @throws Exception 
	 */
	public String delete(List<String> ids) throws Exception {
		int result = (int) dao.batchDelete("CProjectMapper.delete", ids);
		if(result == ids.size()){
			return "success";
		}else{
			throw new RuntimeException("只有草稿和退回状态的项目可以删除");
		}
	}
	
	/**
	 * 修改项目信息
	 * @param cProject
	 * @return
	 * @throws Exception
	 */
	public void update(CProject cProject) throws Exception{
		dao.update("CProjectMapper.update", cProject);
	}

	/**
	 * 根据Id获取项目名
	 * @param id
	 * @return
	 * @throws Exception 
	 */
	public PageData findById(int id) throws Exception {
		return (PageData) dao.findForObject("CProjectMapper.findById", id);
	}
	public PageData findByCodeForGantt(PageData pageData) throws Exception {
		return (PageData) dao.findForObject(
				"CProjectMapper.findByCodeForGantt", pageData);
	}
	
	/**
	 * 根据Id获取项目名
	 * @param id
	 * @return
	 * @throws Exception 
	 */
	public PageData findProSignById(int id) throws Exception {
		return (PageData) dao.findForObject("CProjectMapper.findProSignById", id);
	}
		
	
	/**
	 * 提交审核
	 * @param id
	 * @return
	 * @throws Exception 
	 */
	public String refer(PageData pageData) throws Exception {
		//项目提交修改状态和marker标记
		int result = (int) dao.update("CProjectMapper.refer", pageData);
		if(result == 1){
			//会签信息中修改marker标记
			dao.update("CProjectMapper.referSign", pageData);
		}
		if(result == 1){
			return "success";
		}else{
			return "failed";
		}
	}

	/**
	 * 审批
	 * @param cproject
	 * @return
	 * @throws Exception 
	 */
	public String audit(CProject cproject) throws Exception {
		int result = (int) dao.update("CProjectMapper.audit", cproject);
		if(result != 0 && cproject.getStatus().equals(Const.SYS_STATUS_YW_YTH)){
			//如果是审核退回，复制出一份marker为0的会签信息
			dao.save("CProjectMapper.backupSigners", cproject);
		}
		if(result == 0){
			return "failed";
		}else{
			return "success";
		}
	}
	/**
	 * 会审
	 * @param cproject
	 * @return
	 * @throws Exception 
	 */
	public String sign(CProject cproject) throws Exception {
		int result = (int) dao.update("CProjectMapper.sign", cproject);
		if(result == 0){
			return "failed";
		}else{
			return "success";
		}
	}
	
	
	/**
	 * 获取树节点列表
	 * @param pageData
	 * @return
	 * @throws Exception
	 */
	@SuppressWarnings("unchecked")
	public List<PageData> getTreeNodes(PageData pageData) throws Exception {
		String nodeType = pageData.getString("type");
		String sqlMapper = "";
		if(nodeType == null){
			sqlMapper = "CProjectMapper.findProjects";
		}else if(nodeType.equals("project")){
			sqlMapper = "CProjectNodeMapper.findNodesByProject";
		}else if(nodeType.equals("node")){
			sqlMapper = "CProjectNodeMapper.findChildByNodeID";
		}
		return (List<PageData>) dao.findForList(sqlMapper, pageData);
	}

	/**
	 * 根据编码获取项目信息
	 * @param code
	 * @return
	 * @throws Exception 
	 */
	public PageData findProjectByParam(PageData pageData) throws Exception {
		return (PageData) dao.findForObject("CProjectMapper.findProjectByParam", pageData);
	}
	
	/**
	 * 根据项目信息获得所有会签人信息
	 */
	public PageData findAllSigners(PageData pageData) throws Exception {
		return (PageData) dao.findForObject("CProjectMapper.findAllSigners", pageData);
	}
	
	/**
	 * 根据项目信息获得所有会签信息(包含历史数据)
	 */
	public List<PageData> fidAllSignInfo(PageData pageData) throws Exception {
		return (List<PageData>) dao.findForList("CProjectMapper.fidAllSignInfo", pageData);
	}
	
	/**
	 * 根据编码获取项目和会签信息
	 * @param code
	 * @return
	 * @throws Exception 
	 */
	public PageData findProSignByParam(PageData pageData) throws Exception {
		return (PageData) dao.findForObject("CProjectMapper.findProSignByParam", pageData);
	}
	
	/**
	 * 根据编码标识获取当前项目编码
	 * @param code_sign
	 * @return
	 * @throws Exception
	 */
	public String getCurrentCode(String code_sign) throws Exception {
		return (String) dao.findForObject("CProjectMapper.getCurrentCode", code_sign);
	}
	
	/**
	 * 终止重点协同项目及其下层的项目和节点
	 * @param id
	 * @return
	 * @throws Exception 
	 */
	public String stopProject(PageData pageData) throws Exception {
		
		int resultNode = (int) dao.update("CProjectMapper.stopNodes", pageData);
		int resultEventSplit = (int) dao.update("CProjectMapper.stopEventSplits", pageData);
		int resultEvent = (int) dao.update("CProjectMapper.stopEvents", pageData);
		int resultProject = (int) dao.update("CProjectMapper.stopProject", pageData);
		if(resultProject > 0 && resultNode >=0 && resultEvent>=0 && resultEventSplit>=0){
			return "success";
		}else{
			return "failed";
		}
	}
	/**
	 * 根据Id获取项目会签人名单
	 * @param id
	 * @return
	 * @throws Exception 
	 */
	public List<PageData> findCounterSign(Integer id) throws Exception {
		return (List<PageData>) dao.findForList("CProjectMapper.findCounterSign", id);
	}
	
	/**
	 * 增加会签人信息
	 * @param counters,project
	 * @return
	 * @throws Exception 
	 */
	public void addSigns(List<PageData> counters,CProject project) throws Exception{
		
		for(PageData conterSign:counters){
			conterSign.put("PROJECT_ID", project.getId());
			conterSign.put("AUDITOR",conterSign.get("ID"));
			conterSign.put("CREATE_USER", project.getCreateUser());
			conterSign.put("CREATE_TIME", project.getCreateTime());
			if(project.getUpdateUser()!=null && !"".equals(project.getUpdateUser())){
				conterSign.put("UPDATE_TIME", project.getUpdateTime());
			}
			dao.save("CProjectMapper.saveCounterSign", conterSign);
		}
	}
	
	public void deleteSigns(Integer id) throws Exception{
		dao.delete("CProjectMapper.deleteSigns", id);
	}
	
	public void deleteSignByIds(String[] ids) throws Exception{
		dao.delete("CProjectMapper.deleteSignByIds", ids);
	}
	
	/**
	 * 增加验收人信息
	 * @param counters,project
	 * @return
	 * @throws Exception 
	 */
	public void addAcceptance(List<PageData> counters,PageData pd) throws Exception{
		
		for(PageData acceptance:counters){
			acceptance.put("PROJECT_ID", pd.get("id"));
			acceptance.put("STATE",pd.get("STATE"));
			acceptance.put("CREATE_USER", pd.get("CREATE_USER"));
			acceptance.put("CREATE_TIME", pd.get("CREATE_TIME"));
			
			dao.save("CProjectMapper.saveAcceptance", acceptance);
			EndPointServer.sendMessage(pd.getString("CREATE_NAME"), acceptance.getString("EMP_CODE"), TaskType.projectAcceptance);
		}
	}
	/**
	 * 删除验收信息
	 * @param pd
	 * @throws Exception
	 */
	public void deleteAcceptance(PageData pd) throws Exception{
		dao.delete("CProjectMapper.deleteAcceptance", pd);
	}

	public void updateAcceptance(PageData pd) throws Exception{
		dao.update("CProjectMapper.updateAcceptance", pd);
	}
	
	public int findUnAccCount(PageData pd) throws Exception{
		return (int) dao.findForObject("CProjectMapper.findUnAccCount", pd);
	}
	
	public int findAvgScore(PageData pd) throws Exception{
		return (int) dao.findForObject("CProjectMapper.findAvgScore", pd);
	}
	
	public List<PageData> findAccInfo(PageData pd)throws Exception{
		return (List<PageData>) dao.findForList("CProjectMapper.findAccInfo", pd);
	}
	
	public void updateCompletion(PageData pd) throws Exception{
		dao.update("CProjectMapper.updateCompletion", pd);
	}

	public Boolean IsScored(String C_PROJECT_CODE) {
		Boolean result = false;
		try {
			int allEvents = (int) dao.findForObject("CProjectMapper.findAllEvents", C_PROJECT_CODE);
			int isScoredEvents = (int) dao.findForObject("CProjectMapper.findIsScoredEvents", C_PROJECT_CODE);
			if(allEvents == isScoredEvents)
				result = true;
		} catch (Exception e) {
			e.printStackTrace();
		}
		return result;
	}
}
