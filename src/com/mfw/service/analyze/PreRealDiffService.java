package com.mfw.service.analyze;

import com.mfw.dao.DaoSupport;
import com.mfw.entity.system.User;
import com.mfw.util.Const;
import com.mfw.util.PageData;
import org.apache.shiro.SecurityUtils;
import org.apache.shiro.session.Session;
import org.apache.shiro.subject.Subject;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.util.List;

/**
 * Created by yangdw on 2016/5/25.
 */
@Service("preRealDiffService")
public class PreRealDiffService {


    @Resource(name = "daoSupport")
    private DaoSupport dao;
    
    /**
     *  获取可供选择的目标列表
     *  @param pd
     *  @return
     *  @throws Exception
     *  author yangdw
     */
    public List<PageData> getTargetList(PageData pd) throws Exception{
        Subject currentUser = SecurityUtils.getSubject();
        Session session = currentUser.getSession();
        User user = (User)session.getAttribute(Const.SESSION_USER);
        pd.put("USER_NUMBER", user.getNUMBER());
        pd.put("CREATE_USER",session.getAttribute(Const.SESSION_USERNAME));
        return (List<PageData>)dao.findForList("PreRealDiffMapper.getTargetList", pd);
    }

    /**
     *  获取员工列表
     *  @param pd
     *  @return
     *  @throws Exception
     *  author yangdw
     */
    public List<PageData> getEmpList(PageData pd) throws Exception{
        return (List<PageData>)dao.findForList("PreRealDiffMapper.getEmpList", pd);
    }

    /**
     *  获取员工预实差
     *  @param pd
     *  @return
     *  @throws Exception
     *  author yangdw
     */
    public List<PageData> getEmpPreImplementationList(PageData pd)  throws Exception{
        return (List<PageData>)dao.findForList("PreRealDiffMapper.getEmpPreImplementationList", pd);
    }


    /**
     *  获取年月列表
     *  @param pd
     *  @return
     *  @throws Exception
     *  author yangdw
     */
    public List<PageData> getYearMonth(PageData pd) throws Exception{
        return (List<PageData>)dao.findForList("PreRealDiffMapper.getYearMonth", pd);
    }

    /**
     *  获取部门列表
     *  @param pd
     *  @return
     *  @throws Exception
     *  author yangdw
     */
    public List<PageData> getDeptList(PageData pd) throws Exception{
        return (List<PageData>)dao.findForList("PreRealDiffMapper.getDeptList", pd);
    }

    /**
     *  获取预实差
     *  @param searchPd
     *  @return
     *  @throws Exception
     *  author yangdw
     */
    public List<PageData> getPreImplementationList(PageData searchPd)  throws Exception{
        return (List<PageData>)dao.findForList("PreRealDiffMapper.getPreImplementationList", searchPd);
    }
}
