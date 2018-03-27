package com.mfw.service.flow;

import java.util.List;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import com.mfw.controller.base.BaseService;
import com.mfw.dao.DaoSupport;
import com.mfw.service.bdata.DeptService;
import com.mfw.service.bdata.EmployeeService;
import com.mfw.service.bdata.PositionLevelService;
import com.mfw.util.Const;
import com.mfw.util.FileUpload;
import com.mfw.util.ObjectExcelRead;
import com.mfw.util.PageData;
import com.mfw.util.PathUtil;

/**
 * Service - 流程模板节点
 * @author 李伟涛
 *
 */
@Service
public class FlowModelNodeService extends BaseService{

	@Resource(name = "daoSupport")
	private DaoSupport dao;
	@Resource
	private DeptService deptService;
	@Resource
	private PositionLevelService positionLevelService;
	@Resource
	private EmployeeService employeeService;
	@Resource
	private FlowModelService flowModelService;
	
	/**
	 * 根据模板获取模板节点
	 * @param id
	 * @return
	 * @throws Exception
	 */
	@SuppressWarnings("unchecked")
	public List<PageData> findNodesByModel(Integer id) throws Exception {
		return (List<PageData>) dao.findForList("FlowModelNodeMapper.findNodesByModel", id);
	}

	public void saveNode(PageData pageData) throws Exception {
		dao.save("FlowModelNodeMapper.saveNode", pageData);
	}
	
	public void updateNode(PageData pageData) throws Exception{
		dao.update("FlowModelNodeMapper.updateNode", pageData);
	}

	@SuppressWarnings({ "unchecked", "rawtypes" })
	public void saveImportExcel(MultipartFile file, String modelId) throws Exception{
		PageData pd = new PageData();
		if ( file != null && !file.isEmpty()) {
			String filePath = PathUtil.getClasspath() + Const.FILEPATHFILE; //文件上传路径
			String fileName = FileUpload.fileUp(file, filePath, "modelexcel"); //执行上传
		
			List<PageData> listPd = (List)ObjectExcelRead.readExcel(filePath, fileName, 2, 0, 0);
			
			for (int i = 0; i < listPd.size(); i++) {
				String nodeCode = listPd.get(i).getString("var0");
				if(nodeCode == null || nodeCode.length() == 0){
					break;
				}
				
				pd = new PageData();
				savePage(pd);
				
				pd.put("MODEL_ID", modelId);
				pd.put("NODE_CODE", nodeCode);
				pd.put("NODE_NAME", listPd.get(i).getString("var1")==null?"":listPd.get(i).getString("var1"));
				pd.put("PARENT_CODE", listPd.get(i).getString("var8")==null?"":listPd.get(i).getString("var8"));
				pd.put("NODE_LEVEL", Integer.valueOf(listPd.get(i).getString("var9")));
				pd.put("REMARKS", listPd.get(i).getString("var11")==null?"":listPd.get(i).getString("var11"));
				
				String timeInterval = listPd.get(i).getString("var2");
				pd.put("TIME_INTERVAL", (timeInterval == null || timeInterval.length() == 0) ? 0 : Double.valueOf(timeInterval));
				
				String costTime = listPd.get(i).getString("var3");
				pd.put("COST_TIME", (costTime == null || costTime.length() == 0) ? 0 : Double.valueOf(costTime));
				
				//部门
				String deptName = listPd.get(i).getString("var4");
				if(deptName != null && deptName.length() > 0){
					pd.put("DEPT_ID", deptService.findIdByName(deptName));
				}
				
				//岗位名称
				String positionName = listPd.get(i).getString("var5");
				if(positionName != null && positionName.toString().trim().length() > 0){
					pd.put("POSITION_ID", positionLevelService.findIdByName(positionName));
				}
				
				//责任人
				String empCode = listPd.get(i).getString("var6");
				String empName = listPd.get(i).getString("var7");
				if(empCode != null && empCode.length() > 0){
					pd.put("EMP_CODE", empCode);
				}else if(empName != null && empName.length() > 0){
					pd.put("EMP_CODE", employeeService.findCodeByName(empName));
				}
				
				//更新子流程信息
				String subFlow = listPd.get(i).getString("var10");
				if(subFlow != null && subFlow.trim().length() > 0){
					PageData flowModel = flowModelService.findByCode(subFlow.trim());
					pd.put("SUBFLOW_ID", flowModel == null ? "" : flowModel.get("ID"));
				}
				saveNode(pd);
			}
		}
	}

	public Integer findIdByCode(String code) throws Exception{
		return (Integer) dao.findForObject("FlowModelNodeMapper.findIdByCode", code);
	}

	public void delNode(String id) throws Exception {
		dao.update("FlowModelNodeMapper.delNode", id);
	}
	
}
