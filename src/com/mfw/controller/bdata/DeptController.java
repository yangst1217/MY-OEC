package com.mfw.controller.bdata;

import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.ModelAndView;

import com.mfw.controller.base.BaseController;
import com.mfw.entity.Page;
import com.mfw.entity.system.User;
import com.mfw.service.bdata.CommonService;
import com.mfw.service.bdata.DeptService;
import com.mfw.service.bdata.EmployeeService;
import com.mfw.util.Const;
import com.mfw.util.FileDownload;
import com.mfw.util.FileUpload;
import com.mfw.util.ObjectExcelRead;
import com.mfw.util.PageData;
import com.mfw.util.PathUtil;
import com.mfw.util.Tools;
import com.mfw.util.UserUtils;

/**
 * Controller-部门管理
 * @author
 *
 */
@Controller("deptController")
@RequestMapping(value = "/dept")
public class DeptController extends BaseController {
	
	@Resource(name = "deptService")
	private DeptService deptService;

    @Resource(name = "employeeService")
    private EmployeeService employeeService;
    
    @Resource(name = "commonService")
    private CommonService commonService;
    
	/**
	 * 新增
	 */
	@RequestMapping(value = "/save")
	public ModelAndView save() throws Exception {
		ModelAndView mv = this.getModelAndView();
		PageData pd = new PageData();
		pd = this.getPageData();
		
		try {
			pd.put("CREATE_TIME", Tools.date2Str(new Date()));	//创建时间
			pd.put("CREATE_USER", getUser().getNAME());
			if(pd.get("DEPT_LEADER_ID").equals(""))
			{
				pd.put("DEPT_LEADER_ID", null);
			}
			deptService.save(pd);
			mv.addObject("msg", "success");
		} catch (Exception e) {
			mv.addObject("msg", "failed");
			e.printStackTrace();
		}
		mv.setViewName("save_result");
		return mv;
	}
	
	
	/**
	 * 删除
	 */
	@RequestMapping(value = "/delete")
	public void delete(PrintWriter out) {
		logBefore(logger, "删除Dept");
		PageData pd = new PageData();
		try {
			pd = this.getPageData();
			pd.put("IS_DELETE", 1);
			deptService.delete(pd);
			delchild(pd);
			out.write("success");
			out.close();
		} catch (Exception e) {
			logger.error(e.toString(), e);
		}

	}
	/**
	 * 删除子部门
	 */
	public void delchild(PageData pd){
		try {
			List<PageData> childList = deptService.listChild(pd);
			for(int j=0;j<childList.size();j++){
				childList.get(j).put("IS_DELETE", 1);
				deptService.delete(childList.get(j));
				delchild(childList.get(j));
			}
		}catch (Exception e) {
			logger.error(e.toString(), e);
		}
	}
	/**
	 * 修改
	 */
	@RequestMapping(value = "/edit")
	public ModelAndView edit() throws Exception {
		logBefore(logger, "修改Dept");
		ModelAndView mv = this.getModelAndView();
		PageData pd = new PageData();
		pd = this.getPageData();
		try {
			if(pd.get("DEPT_LEADER_ID").equals(""))
			{
				pd.put("DEPT_LEADER_ID", null);
			}
			deptService.edit(pd); //执行修改数据库
			List<PageData> varList = deptService.listAll(pd); //列出Dept列表
			for(int i=0;i<varList.size();i++){
				varList.get(i).put("eNum", getENum(varList.get(i)));
				if(Integer.valueOf(varList.get(i).get("ENABLED").toString())==0){
					varList.get(i).put("DEPT_NAME", varList.get(i).get("DEPT_NAME").toString()+"(未启用)");
				}else
				{
					varList.get(i).put("DEPT_NAME","["+varList.get(i).get("ORDER_NUM")+"]"+varList.get(i).get("DEPT_NAME").toString()+"("+varList.get(i).get("eNum").toString()+")");
				}
				
			}
			JSONArray arr = JSONArray.fromObject(varList); //Dept列表转为ztree可识别的类型
			List<PageData> functionList = commonService.typeListByBm("BMZN"); //部门职能列表
			List<PageData> areaList = commonService.typeListByBm("BMDY"); //部门地域列表
			mv.addObject("deptTreeNodes", arr.toString());
			mv.addObject("varList", varList);
			mv.addObject("functionList", functionList);
			mv.addObject("areaList", areaList);
			mv.addObject("msg", "success");
		} catch (Exception e) {
			mv.addObject("msg", "failed");
			e.printStackTrace();
		}
		mv.setViewName("bdata/department/dept_list");
		return mv;
	}
	
	/**
	 * 列表
	 */
	@RequestMapping(value = "/list")
	public ModelAndView list(Page page) {
		logBefore(logger, "列表Dept");
		ModelAndView mv = this.getModelAndView();
		PageData pd = new PageData();
		try {
			pd = this.getPageData();
			List<PageData> varList = deptService.listAll(pd); //列出Dept列表
			
			for(int i=0;i<varList.size();i++){
				varList.get(i).put("eNum", getENum(varList.get(i)));
				if(Integer.valueOf(varList.get(i).get("ENABLED").toString())==0){
					varList.get(i).put("DEPT_NAME", varList.get(i).get("DEPT_NAME").toString()+"(未启用)");
				}else
				{
					varList.get(i).put("DEPT_NAME","["+varList.get(i).get("ORDER_NUM")+"]"+varList.get(i).get("DEPT_NAME").toString()+"("+varList.get(i).get("eNum").toString()+")");
				}
			}
			JSONArray arr = JSONArray.fromObject(varList); //Dept列表转为ztree可识别的类型
			pd = deptService.findById(pd); //根据ID读取
			List<PageData> functionList = commonService.typeListByBm("BMZN"); //部门职能列表
			List<PageData> areaList = commonService.typeListByBm("BMDY"); //部门地域列表
			this.getHC(); //调用权限
				
			mv.setViewName("bdata/department/dept_list");
			mv.addObject("varList", varList);
			mv.addObject("functionList", functionList);
			mv.addObject("areaList", areaList);
			mv.addObject("msg", "edit");
			mv.addObject("deptTreeNodes", arr.toString());
			mv.addObject("pd", pd);
			mv.addObject("myflag", '0');
			
		} catch (Exception e) {
			logger.error(e.toString(), e);
		}
		return mv;
	}
	public int getENum(PageData p){
		int eNum = 0;
		try {
			eNum = Integer.valueOf(deptService.getENum(p).get("eNum").toString());
			List<PageData> childList = deptService.listChild(p);
			for(int j=0;j<childList.size();j++){
				 eNum +=getENum(childList.get(j));				
			}
		}catch (Exception e) {
			logger.error(e.toString(), e);
		}
		return eNum;
	}	
	/**
	 * 去新增页面
	 */
	@RequestMapping(value = "/goAdd")
	public ModelAndView goAdd() throws Exception {
		ModelAndView mv = this.getModelAndView();
		PageData pd = new PageData();
		pd = this.getPageData();
		pd = deptService.findById(pd);//根据ID查找
		List<PageData> functionList = commonService.typeListByBm("BMZN"); //部门职能列表
		List<PageData> areaList = commonService.typeListByBm("BMDY"); //部门地域列表
		mv.setViewName("bdata/department/dept_edit");
		mv.addObject("msg", "save");
		mv.addObject("pd", pd);
		mv.addObject("functionList", functionList);
		mv.addObject("areaList", areaList);
		return mv;
	}
	/**
	 * 去新增根级部门页面
	 */
	@RequestMapping(value = "/goAddr")
	public ModelAndView goAddr() throws Exception {
		ModelAndView mv = this.getModelAndView();
		PageData pd = new PageData();
		pd = this.getPageData();
		pd = deptService.findById(pd);//根据ID查找
		List<PageData> functionList = commonService.typeListByBm("BMZN"); //部门职能列表
		List<PageData> areaList = commonService.typeListByBm("BMDY"); //部门地域列表
		mv.setViewName("bdata/department/dept_addr");
		mv.addObject("msg", "save");
		mv.addObject("pd", pd);
		mv.addObject("functionList", functionList);
		mv.addObject("areaList", areaList);
		return mv;
	}
	/**
	 * 去修改页面
	 */
	@RequestMapping(value = "/goEdit")
	public ModelAndView goEdit() {
		logBefore(logger, "去修改Dept页面");
		ModelAndView mv = this.getModelAndView();
		PageData pd = new PageData();
		pd = this.getPageData();
		try {
			pd = deptService.findById(pd); //根据ID读取
			mv.setViewName("bdata/department/dept_edit");
			mv.addObject("msg", "edit");
			mv.addObject("pd", pd);
		} catch (Exception e) {
			logger.error(e.toString(), e);
		}
		return mv;
	}
	/**
	 * 验证编码和标识是否重复
	 */
	@RequestMapping(value = "/checkCodeAndSign")
	public void checkCodeAndSign(PrintWriter out) {
		logBefore(logger, "验证编码和标识是否重复");
		PageData pd = new PageData();
		try {
			pd = this.getPageData();
			int count = deptService.checkCode(pd);
			out.write(count+"");
			out.close();
		} catch (Exception e) {
			logger.error(e.toString(), e);
		}

	}
	/**
	 * 验证部门下是否有员工
	 */
	@RequestMapping(value = "/checkEmp")
	public void checkEmp(PrintWriter out) {
		logBefore(logger, "验证部门下是否有员工");
		PageData pd = new PageData();
		try {
			pd = this.getPageData();
			int count = deptService.checkEmp(pd);
			out.write(count+"");
			out.close();
		} catch (Exception e) {
			logger.error(e.toString(), e);
		}

	}
	/* ===============================导入导出================================== */
	/**
	 * 打开上传EXCEL页面
	 */
	@RequestMapping(value = "/goUploadExcel")
	public ModelAndView goUploadExcel() throws Exception {
		ModelAndView mv = this.getModelAndView();
		mv.setViewName("bdata/department/deptloadexcel");
		return mv;
		
		
	}
	/**
	 * 下载模版
	 */
	@RequestMapping(value = "/downExcel")
	public void downExcel(HttpServletResponse response) throws Exception {

		FileDownload.fileDownload(response, PathUtil.getClasspath() + Const.FILEPATHFILE + "Dept.xls", "Dept.xls");
	}
	/**
	 * 从EXCEL导入到数据库
	 */
	@SuppressWarnings({ "unchecked", "rawtypes" })
	@RequestMapping(value = "/readExcel")
	public ModelAndView readExcel(@RequestParam(value = "excel", required = false) MultipartFile file,HttpServletRequest request) throws Exception {
		ModelAndView mv = this.getModelAndView();
		PageData pd ;
		if (null != file && !file.isEmpty()) {
			String filePath = PathUtil.getClasspath() + Const.FILEPATHFILE; //文件上传路径
			String fileName = FileUpload.fileUp(file, filePath, "modelexcel"); //执行上传

			List<PageData> listPd = (List) ObjectExcelRead.readExcel(filePath, fileName, 1, 0, 0); //执行读EXCEL操作,读出的数据导入List 1:从第2行开始；0:从第A列开始；0:第0个sheet
				/* 存入数据库操作====================================== */
				User user = UserUtils.getUser(request);
				
				/**
				 * var0:第一列      var1:第二列    varN:第N+1列
				 */
				for (int i = 1; i < listPd.size(); i++) {
					if(listPd.get(i).getString("var0")==""||listPd.get(i).getString("var0")==null||listPd.get(i).getString("var1")==""||listPd.get(i).getString("var1")==null
							||listPd.get(i).getString("var2")==""||listPd.get(i).getString("var2")==null
							||listPd.get(i).getString("var6")==""||listPd.get(i).getString("var6")==null
							||listPd.get(i).getString("var7")==""||listPd.get(i).getString("var7")==null||listPd.get(i).getString("var8")==""||listPd.get(i).getString("var8")==null)
					{
						mv.addObject("msg", "第"+i+"条部门的数据不全，请检查后再导入");
						mv.setViewName("save_result");
						return mv;
					}
					pd = new PageData();
					PageData pdm =new PageData() ;
					pd.put("status", "1"); //状态--草稿
					pd.put("CREATE_USER", user.getNAME());
					pd.put("CREATE_TIME", new Date());
					
					String PARENT_SIGN = listPd.get(i).getString("var5");
					if(PARENT_SIGN==""||PARENT_SIGN==null){
						pd.put("PARENT_ID", 0);//上级部门
					}
					else{
						pd.put("DEPT_SIGN", PARENT_SIGN);
						String PARENT_ID = deptService.findIdByS(pd);
						pd.put("PARENT_ID", PARENT_ID); //上级部门
					}
					pd.put("DEPT_CODE", listPd.get(i).getString("var1")); //部门编码
					pd.put("ENABLED", "1"); //是否启用
					pd.put("DEPT_NAME", listPd.get(i).getString("var0")); //部门名称
					pd.put("DEPT_SIGN", listPd.get(i).getString("var2")); //部门标识
					/*
					//初始化时因为没有员工数据会导致部门一直导入失败
					pdm.put("EMP_CODE", listPd.get(i).getString("var3")); //部门负责人编码
					pdm = employeeService.findByCode(pdm);
					if(pdm == null)
					{
						mv.addObject("msg", "第"+i+"条部门的负责人不存在，请检查后再导入");
						mv.setViewName("save_result");
						return mv;
					}
					pd.put("DEPT_LEADER_ID", pdm.get("ID"));
					pd.put("DEPT_LEADER_NAME", pdm.get("EMP_NAME"));
					*/
//					pd.put("IS_FUNCTIONAL_DEPT", listPd.get(i).getString("var5").equals("是")?"1":"0"); //是否是预算部门
//					pd.put("IS_PREPARE_DEPT", listPd.get(i).getString("var6").equals("是")?"1":"0"); //是否是编制部门
					pd.put("IS_FUNCTIONAL_DEPT", "0"); //是否是预算部门
					pd.put("IS_PREPARE_DEPT", "0"); //是否是编制部门
					pd.put("ORDER_NUM", listPd.get(i).getString("var6"));//排序号
					pd.put("FUNCTION", listPd.get(i).getString("var7"));//职能
					pd.put("AREA", listPd.get(i).getString("var8"));//地域
					
					pd.put("deptCode", listPd.get(i).getString("var1")); //部门编码
					pd.put("deptSign", listPd.get(i).getString("var2")); //部门标识
					int count = deptService.checkCode(pd);//检验编码和部门标识是否重复
					if(count ==0)
					{
						deptService.save(pd);//存入数据库
					}else
					{

						mv.addObject("msg", "第"+i+"条的编码或者部门标识已存在，请仔细检查后再导入");
						mv.setViewName("save_result");
						return mv;
					}
				/* 存入数据库操作====================================== */

				mv.addObject("msg", "success");
			}			
		}

		mv.setViewName("save_result");
		return mv;
	}
	
    /**
     * 责任人与责任部门页面
     * author yangdw
     */
    @RequestMapping(value = "/deptAndEmp")
    public ModelAndView deptAndEmp() throws Exception {
        logBefore(logger, "deptAndEmp");

        ModelAndView mv = new ModelAndView();
        PageData pd = this.getPageData();
        List<PageData> deptList = new ArrayList<PageData>();
        if(null != pd.get("TARGET_DEPT_ID") && !"".equals(pd.get("TARGET_DEPT_ID").toString())){
            mv.addObject("ParentId",pd.get("TARGET_DEPT_ID"));
            String TARGET_DEPT_ID = pd.get("TARGET_DEPT_ID").toString();
            deptList = deptService.getAllSonDepts(TARGET_DEPT_ID);

            if(null != pd.get("DEPT_ID") && !"".equals(pd.get("DEPT_ID").toString())){
                String DEPT_ID = pd.get("DEPT_ID").toString();
                List<PageData> empList = employeeService.findEmpByDept(DEPT_ID);
                //放入员工列表
                mv.addObject("empList",empList);
                //编辑时放入DEPT_ID
                mv.addObject("DEPT_ID",DEPT_ID);
            }else {
                mv.addObject("DEPT_ID",deptList.get(0).get("ID").toString());
                List<PageData> empList = employeeService.findEmpByDept(TARGET_DEPT_ID);
                //放入员工列表
                mv.addObject("empList",empList);
            }
        }else {
            String ParentId = "0";
            mv.addObject("ParentId",ParentId);
            deptList = deptService.listAlln();
            if(null != pd.get("DEPT_ID") && !"".equals(pd.get("DEPT_ID").toString())){
                String DEPT_ID = pd.get("DEPT_ID").toString();
                List<PageData> empList = employeeService.findEmpByDept(DEPT_ID);
                //放入员工列表
                mv.addObject("empList",empList);
                //编辑时放入DEPT_ID
                mv.addObject("DEPT_ID",DEPT_ID);
            }else if(deptList.size()>0){
                mv.addObject("DEPT_ID",deptList.get(0).get("ID").toString());
                List<PageData> empList = employeeService.findEmpByDept(deptList.get(0).get("ID").toString());
                //放入员工列表
                mv.addObject("empList",empList);
            }
        }
        //放入部门列表
        mv.addObject("deptList",deptList);
        if(null != pd.get("DEPT_NAME") && !"".equals(pd.get("DEPT_NAME").toString())){
            String DEPT_NAME = pd.get("DEPT_NAME").toString();
            //编辑时放入DEPT_NAME
            mv.addObject("DEPT_NAME",DEPT_NAME);
        }else if(deptList.size()>0){
            mv.addObject("DEPT_NAME",deptList.get(0).get("DEPT_NAME").toString());
        }
        if(null != pd.get("EMP_NAME") && !"".equals(pd.get("EMP_NAME").toString())){
            String EMP_NAME = pd.get("EMP_NAME").toString();
            //编辑时放入EMP_NAME
            mv.addObject("EMP_NAME",EMP_NAME);
        }
        if(null != pd.get("EMP_ID") && !"".equals(pd.get("EMP_ID").toString())){
            String EMP_ID = pd.get("EMP_ID").toString();
            //编辑时放入EMP_ID
            mv.addObject("EMP_ID",EMP_ID);
        }
        if(null != pd.get("STATUS") && !"".equals(pd.get("STATUS").toString())){
            String STATUS = pd.get("STATUS").toString();
            //编辑时放入STATUS 1为单选 2为员工复选
            mv.addObject("STATUS",STATUS);
        }
        mv.setViewName("bdata/department/dept_and_emp");
        return mv;
    }
    
    
    
	/**
	 * 点击模板列表查询
	 */
	@RequestMapping(value = "/findDetail",produces = "text/html;charset=UTF-8")
	public void findDetail(@RequestParam String ID, HttpServletResponse response) throws Exception {
		PageData pd = new PageData();
		Map<String, Object> map = new HashMap<String, Object>();
		try {
			pd = this.getPageData();
			pd.put("ID", ID);
			List<Object> list = new ArrayList<Object>();
			
			pd = deptService.findById(pd);
			map.put("pd", pd);
			map.put("myflag", "1");
			JSONObject jo = JSONObject.fromObject(map);
			String json = jo.toString();
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
}
