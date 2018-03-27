<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%
    String path = request.getContextPath();
    String basePath = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort() + path + "/";
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <base href="<%=basePath%>">
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <!-- basic styles -->
    <link type="text/css" rel="StyleSheet" href="plugins/Bootstrap/css/bootstrap.min.css"/>
    <link href="static/css/bootstrap-responsive.min.css" rel="stylesheet"/>
    <link rel="stylesheet" href="static/css/font-awesome.min.css"/>
    <link type="text/css" rel="StyleSheet" href="static/css/dtree.css"/>
    <link type="text/css" rel="StyleSheet" href="static/css/style.css"/>
    <!-- page specific plugin styles -->
    <!-- 下拉框-->
    <link rel="stylesheet" href="static/css/chosen.css"/>
    <!-- ace styles -->
    <link rel="stylesheet" href="static/css/ace.min.css"/>
    <link rel="stylesheet" href="static/css/ace-rtl.min.css"/>
    <link rel="stylesheet" href="static/css/ace-responsive.min.css"/>
    <link rel="stylesheet" href="static/css/ace-skins.min.css"/>
    <link type="text/css" rel="stylesheet" href="plugins/zTree/zTreeStyle.css"/>
    <link rel="StyleSheet" href="plugins/Bootgrid/jquery.bootgrid.min.css"/>
    <link rel="stylesheet" href="static/css/bootgrid.change.css"/>
    <style>
        input[type=checkbox], input[type=radio] {
            opacity: 1;
            position: inherit;
        }
    </style>
</head>
<body>
<div class="container-fluid" id="main-container">
    <div id="page-content" class="clearfix">
        <div class="row-fluid">
            <div class="row-fluid">
                <!-- 检索  -->
                <table>
                    <tr>
                        <td>
										<span class="input-icon">
											<input autocomplete="off" id="USERNAME" type="text" name="USERNAME"
                                                   value="${pd.USERNAME }" style="height:28px;" placeholder="这里输入关键词"/>
										</span>
                        </td>
                        <td><input class="span10 date-picker" name="lastLoginStart" id="lastLoginStart"
                                   value="${pd.lastLoginStart}" type="text" data-date-format="yyyy-mm-dd"
                                   style="width:88px;height:28px;" placeholder="开始日期" title="最近登录开始"/></td>
                        <td><input class="span10 date-picker" name="lastLoginEnd" id="lastLoginEnd"
                                   value="${pd.lastLoginEnd}" type="text" data-date-format="yyyy-mm-dd"
                                   style="width:88px;height:28px;" placeholder="结束日期" title="最近登录结束"/></td>
                        <td style="vertical-align:top;">
                            <select name="ROLE_ID" id="role_id" data-placeholder="请选择职位"
                                    style="vertical-align:top;width: 120px;height:28px;">
                                <option value="">请选择职位</option>
                                <c:forEach items="${roleList}" var="role">
                                    <option value="${role.ROLE_ID }"
                                            <c:if test="${pd.ROLE_ID==role.ROLE_ID}">selected</c:if>>${role.ROLE_NAME }</option>
                                </c:forEach>
                            </select>
                        </td>
                        <td style="vertical-align:top;">
										<span class="input-icon">
											<input autocomplete="off" id="dept_id" name="DEPT_NAME"
                                                   onclick="showDeptTree(this)" type="text" style="height:28px;"
                                                   value="${pd.deptNames }" placeholder="点击选择组织机构"/>
											<input type="hidden" id="deptid" name="DEPT_ID" value="${pd.deptIds}">
										</span>
                            <div id="deptTreePanel" style="background-color:white;z-index: 1000;">
                                <ul id="deptTree" class="tree"></ul>
                            </div>
                        </td>
                        <c:if test="${QX.cha == 1 }">
                            <td style="vertical-align:top;">
                                <button class="btn btn-mini btn-light" onclick="search();" title="检索"><i
                                        id="nav-search-icon" class="icon-search"></i></button>
                            </td>
                            <%-- <td style="vertical-align:top;"><a class="btn btn-mini btn-light" onclick="window.location.href='<%=basePath%>/user/listtabUsers.do';" title="切换模式"><i id="nav-search-icon" class="icon-exchange"></i></a></td> --%>
                            <td style="vertical-align:top;"><a class="btn btn-mini btn-light" onclick="toExcel();"
                                                               title="导出到EXCEL"><i id="nav-search-icon"
                                                                                   class="icon-download-alt"></i></a>
                            </td>
                            <c:if test="${QX.edit == 1 }">
                                <td style="vertical-align:top;"><a class="btn btn-mini btn-light" onclick="fromExcel();"
                                                                   title="从EXCEL导入"><i id="nav-search-icon"
                                                                                       class="icon-cloud-upload"></i></a>
                                </td>
                            </c:if>
                        </c:if>
                    </tr>
                </table>
                <!-- 检索  -->
                <table id="table_report" class="table table-striped table-bordered table-hover">
                    <!-- <thead>
                        <tr>
                            <th class="center">
                                <label><input type="checkbox" id="zcheckbox" /><span class="lbl"></span></label>
                            </th>
                            <th>序号</th>
                            <th>员工编号</th>
                            <th>用户名</th>
                            <th>姓名</th>
                            <th>部门</th>
                            <th>角色</th>
                            <th><i class="icon-envelope"></i>邮箱</th>
                            <th><i class="icon-time hidden-phone"></i>最近登录</th>
                            <th>上次登录IP</th>
                            <th class="center">操作</th>
                        </tr>
                    </thead> -->

                    <thead>
                    <tr>
                        <th data-column-id="USER_ID" data-visible="false" data-identifier="true">用户ID</th>
                        <th data-column-id="NUMBER">员工编号</th>
                        <th data-column-id="USERNAME" data-width="80px">用户名</th>
                        <th data-column-id="NAME" data-width="80px">姓名</th>
                        <th data-column-id="DEPT_NAME">部门</th>
                        <th data-column-id="ROLE_NAME">角色</th>
                        <th data-column-id="EMAIL" data-formatter="email">邮箱</th>
                        <th data-column-id="LAST_LOGIN">最近登录</th>
                        <th data-column-id="IP">上次登录IP</th>
                        <th align="center" data-align="center" data-width="150px" data-sortable="false"
                            data-formatter="btns">操作
                        </th>
                    </tr>
                    </thead>

                    <%-- <tbody>
                        <!-- 开始循环 -->
                        <c:choose>
                            <c:when test="${not empty userList}">
                                <c:if test="${QX.cha == 1 }">
                                    <c:forEach items="${userList}" var="user" varStatus="vs">
                                        <tr>
                                            <td class='center' style="width: 30px;">
                                                <c:if test="${user.USERNAME != 'admin'}"><label><input type='checkbox' name='ids' value="${user.USER_ID }" id="${user.EMAIL }" alt="${user.PHONE }"/><span class="lbl"></span></label></c:if>
                                                <c:if test="${user.USERNAME == 'admin'}"><label><input type='checkbox' disabled="disabled" /><span class="lbl"></span></label></c:if>
                                            </td>
                                            <td class='center' style="width: 30px;">${vs.index+1}</td>
                                            <td>${user.NUMBER }</td>
                                            <td>${user.USERNAME }</td>
                                            <td>${user.NAME }</td>
                                            <td>${user.DEPT_NAME }</td>
                                            <td>${user.ROLE_NAME }</td>
                                            <c:if test="${QX.FX_QX == 1 }">
                                                <td><a title="发送电子邮件" style="text-decoration:none;cursor:pointer;" onclick="sendEmail('${user.EMAIL }');">${user.EMAIL }&nbsp;<i class="icon-envelope"></i></a></td>
                                            </c:if>
                                            <c:if test="${QX.FX_QX != 1 }">
                                                <td><a title="您无权发送电子邮件" style="text-decoration:none;cursor:pointer;">${user.EMAIL }&nbsp;<i class="icon-envelope"></i></a></td>
                                            </c:if>
                                            <td>${user.LAST_LOGIN}</td>
                                            <td>${user.IP}</td>
                                            <td style="width: 60px;">
                                                <div class='hidden-phone visible-desktop btn-group'>
                                                    <a class="btn btn-mini btn-purple" onclick="editRights('${user.USER_ID }');"><i class="icon-pencil"></i>数据权限</a>
                                                    <c:if test="${QX.edit == 1 }">
                                                        <c:if test="${user.USERNAME != 'admin'}"><a class='btn btn-mini btn-info' title="编辑" onclick="editUser('${user.USER_ID }');"><i class='icon-edit'></i></a></c:if>
                                                        <c:if test="${user.USERNAME == 'admin'}"><a class='btn btn-mini btn-info' title="您不能编辑"><i class='icon-edit'></i></a></c:if>
                                                    </c:if>
                                                    <c:choose>
                                                        <c:when test="${user.USERNAME=='admin'}">
                                                            <a class='btn btn-mini btn-danger' title="不能删除"><i class='icon-trash'></i></a>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <c:if test="${QX.del == 1 }">
                                                                <a class='btn btn-mini btn-danger' title="删除" onclick="delUser('${user.USER_ID }','${user.USERNAME }');"><i class='icon-trash'></i></a>
                                                            </c:if>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </div>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </c:if>
                                <c:if test="${QX.cha == 0 }">
                                    <tr>
                                        <td colspan="10" class="center">您无权查看</td>
                                    </tr>
                                </c:if>
                            </c:when>
                            <c:otherwise>
                                <tr class="main_info">
                                    <td colspan="10" class="center">没有相关数据</td>
                                </tr>
                            </c:otherwise>
                        </c:choose>
                    </tbody> --%>
                </table>
                <div class="page-header position-relative">
                    <table style="width:100%;">
                        <tr>
                            <td style="vertical-align:top;">
                                <c:if test="${QX.add == 1 }">
                                    <a class="btn btn-small btn-success" onclick="add();">新增</a>
                                </c:if>
                                <c:if test="${QX.FX_QX == 1 }">
                                    <a title="批量发送电子邮件" class="btn btn-small btn-info"
                                       onclick="makeAll('确定要给选中的用户发送邮件吗?');"><i class="icon-envelope-alt"></i></a>
                                </c:if>
                                <c:if test="${QX.del == 1 }">
                                    <a title="批量删除" class="btn btn-small btn-danger" onclick="makeAll('确定要删除选中的数据吗?');"><i
                                            class='icon-trash'></i></a>
                                </c:if>
                            </td>
                            <%-- <td style="vertical-align:top;"><div class="pagination" style="float: right;padding-top: 0px;margin-top: 0px;">${page.pageStr}</div></td> --%>
                        </tr>
                    </table>
                </div>
                </form>
            </div>
        </div>
    </div>
</div>
<!-- 返回顶部  -->
<a href="#" id="btn-scroll-up" class="btn btn-small btn-inverse">
    <i class="icon-double-angle-up icon-only"></i>
</a>
<!-- 引入 -->
<script type="text/javascript" src="static/1.9.1/jquery.min.js"></script>
<script type="text/javascript" src="plugins/Bootstrap/js/bootstrap.min.js"></script>
<script src="static/js/ace-elements.min.js"></script>
<script src="static/js/ace.min.js"></script>
<script type="text/javascript" src="static/js/chosen.jquery.min.js"></script><!-- 下拉框 -->
<script type="text/javascript" src="static/js/bootstrap-datepicker.min.js"></script><!-- 日期框 -->
<script type="text/javascript" src="plugins/zTree/jquery.ztree-2.6.min.js"></script>
<script type="text/javascript" src="static/deptTree/deptTree.js"></script>
<script type="text/javascript" src="plugins/Bootgrid/jquery.bootgrid.min.js"></script>
<!-- 引入 -->
<!--引入弹窗组件start-->
<!-- <script type="text/javascript" src="static/js/attention/zDialog/zDrag.js"></script>
<script type="text/javascript" src="static/js/attention/zDialog/zDialog.js"></script> -->
<!--引入弹窗组件end-->
<script type="text/javascript" src="static/js/jquery.tips.js"></script><!--提示框-->
<script type="text/javascript" src="static/js/bootbox.min.js"></script><!-- 确认窗口 -->
<script type="text/javascript">
    $(top.changeui());

    $(function () {
        $("#table_report").bootgrid({
            ajax: true,
            url: "user/userList.do",
            selection: true,
            multiSelect: true,
            navigation: 2,
            formatters: {
                email: function (column, row) {
                    if ("${QX.FX_QX}" == 1) {
                        return '<a title="发送电子邮件" style="text-decoration:none;cursor:pointer;" onclick="sendEmail(\'' + row.EMAIL + '\');">' + row.EMAIL + '&nbsp;<i class="icon-envelope"></i></a>'
                    } else {
                        return '<a title="您无权发送电子邮件" style="text-decoration:none;cursor:pointer;">' + row.EMAIL + '&nbsp;<i class="icon-envelope"></i></a>'
                    }
                },
                btns: function (column, row) {
                    var result = "<div class='hidden-phone visible-desktop btn-group'>" +
                        '<a class="btn btn-mini btn-purple" onclick="editRights(\'' + row.USER_ID + '\');"><i class="icon-pencil"></i>数据权限</a>';
                    if ("${QX.edit}" == 1) {
                        if ("${user.USERNAME}" != 'admin') {
                            result += '<a class="btn btn-mini btn-info" title="编辑" onclick="editUser(\'' + row.USER_ID + '\');"><i class="icon-edit"></i></a>';
                        } else {
                            result += '<a class="btn btn-mini btn-info" title="您不能编辑"><i class="icon-edit"></i></a>';
                        }
                    }
                    if ("${user.USERNAME}" == 'admin') {
                        result += '<a class="btn btn-mini btn-danger" title="不能删除"><i class="icon-trash"></i></a>';
                    } else if ("${QX.del}" == 1) {
                        result += '<a class="btn btn-mini btn-danger" title="删除" onclick="delUser(\'' + row.USER_ID + '\',\'' + row.USERNAME + '\');"><i class="icon-trash"></i></a>';
                    }
                    result += '</div>';

                    return result;
                }
            },

        });
    });

    //检索
    function search() {
        $("#table_report").bootgrid("search", {
            "USERNAME": $("#USERNAME").val(),
            "lastLoginStart": $("#lastLoginStart").val(),
            "lastLoginEnd": $("#lastLoginEnd").val(),
            "ROLE_ID": $("#role_id").val(),
            "DEPT_ID": $("#deptid").val()
        });
    }


    //去发送电子邮件页面
    function sendEmail(EMAIL) {
        top.jzts();
        var diag = new top.Dialog();
        diag.Drag = true;
        diag.Title = "发送电子邮件";
        diag.URL = '<%=basePath%>/head/goSendEmail.do?EMAIL=' + EMAIL;
        diag.Width = 600;
        diag.Height = 470;
        diag.CancelEvent = function () { //关闭事件
            diag.close();
        };
        diag.show();
    }

    //去发送短信页面
    function sendSms(phone) {
        top.jzts();
        var diag = new top.Dialog();
        diag.Drag = true;
        diag.Title = "发送短信";
        diag.URL = '<%=basePath%>/head/goSendSms.do?PHONE=' + phone + '&msg=appuser';
        diag.Width = 600;
        diag.Height = 265;
        diag.CancelEvent = function () { //关闭事件
            diag.close();
        };
        diag.show();
    }

    //新增
    function add() {
        top.jzts();
        var diag = new top.Dialog();
        diag.Drag = true;
        diag.Title = "新增";
        diag.URL = 'user/goAddU.do';
        diag.Width = 240;
        diag.Height = 350;
        diag.CancelEvent = function () { //关闭事件
            if (diag.innerFrame.contentWindow.document.getElementById('zhongxin').style.display == 'none') {
                if ('${page.currentPage}' == '0') {
                    $("#table_report").bootgrid("reload");
                } else {
                    $("#table_report").bootgrid("reload");
                }
            }
            diag.close();
        };
        diag.show();
    }

    //修改
    function editUser(user_id) {
        top.jzts();
        var diag = new top.Dialog();
        diag.Drag = true;
        diag.Title = "资料";
        diag.URL = 'user/goEditU.do?USER_ID=' + user_id;
        diag.Width = 240;
        diag.Height = 350;
        diag.CancelEvent = function () { //关闭事件
            if (diag.innerFrame.contentWindow.document.getElementById('zhongxin').style.display == 'none') {
                $("#table_report").bootgrid("reload");
            }
            diag.close();
        };
        diag.show();
    }

    //删除
    function delUser(userId, msg) {
        bootbox.confirm("确定要删除[" + msg + "]吗?", function (result) {
            if (result) {
                top.jzts();
                var url = "user/deleteU.do?USER_ID=" + userId + "&tm=" + new Date().getTime();
                $.get(url, function (data) {
                    if (data == "success") {
                        $("#table_report").bootgrid("reload");
                    }
                });
            }
        });
    }

    //批量操作
    function makeAll(msg) {
        bootbox.confirm(msg, function (result) {
            if (result) {
                //var str = '';
                //var emstr = '';
                //var phones = '';
                var objList = $("#table_report").bootgrid("getSelectedRows");

                /* for(var i=0;i < document.getElementsByName('ids').length;i++)
                {
                      if(document.getElementsByName('ids')[i].checked){
                          if(str=='') str += document.getElementsByName('ids')[i].value;
                          else str += ',' + document.getElementsByName('ids')[i].value;

                          if(emstr=='') emstr += document.getElementsByName('ids')[i].id;
                          else emstr += ';' + document.getElementsByName('ids')[i].id;

                          if(phones=='') phones += document.getElementsByName('ids')[i].alt;
                          else phones += ';' + document.getElementsByName('ids')[i].alt;
                      }
                } */
                if (objList == null || objList.length == 0) {
                    bootbox.dialog("您没有选择任何内容!",
                        [
                            {
                                "label": "关闭",
                                "class": "btn-small btn-success",
                                "callback": function () {
                                    //Example.show("great success");
                                }
                            }
                        ]
                    );

                    return;
                } else {
                    if (msg == '确定要删除选中的数据吗?') {
                        top.jzts();
                        $.ajax({
                            type: "POST",
                            url: 'user/deleteAllU.do?tm=' + new Date().getTime(),
                            data: {USER_IDS: objList},
                            dataType: 'json',
                            //beforeSend: validateData,
                            cache: false,
                            success: function (data) {
                                $.each(data.list, function (i, list) {
                                    $("#table_report").bootgrid("reload");
                                });
                            }
                        });
                    }
                    /* else if(msg == '确定要给选中的用户发送邮件吗?'){
                        sendEmail(emstr);
                    }else if(msg == '确定要给选中的用户发送短信吗?'){
                        sendSms(phones);
                    } */

                }
            }
        });
    }

    var setting = {
        checkable: false,
        checkType: {"Y": "", "N": ""}
    };

    $(function () {

//日期框
        $('.date-picker')
            .datepicker(
                {
                    format: 'yyyy-mm-dd',
                    changeMonth: true,
                    changeYear: true,
                    showButtonPanel: true,
                    autoclose: true,
                    minViewMode: 0,
                    maxViewMode: 2,
                    startViewMode: 0,
                    onClose: function (dateText, inst) {
                        var year = $(
                            "#span2 date-picker .ui-datepicker-year :selected")
                            .val();
                        $(this).datepicker('setDate',
                            new Date(year, 1, 1));
                    }
                });

        //下拉框
        $(".chzn-select").chosen();
        $(".chzn-select-deselect").chosen({allow_single_deselect: true});

        //复选框
        $('table th input:checkbox').on('click', function () {
            var that = this;
            $(this).closest('table').find('tr > td:first-child input:checkbox')
                .each(function () {
                    this.checked = that.checked;
                    $(this).closest('tr').toggleClass('selected');
                });
        });

        $("#deptTree").deptTree(setting, ${deptTreeNodes}, 200, 236);
    });

    //导出excel
    function toExcel() {
        var USERNAME = $("#USERNAME").val();
        var lastLoginStart = $("#lastLoginStart").val();
        var lastLoginEnd = $("#lastLoginEnd").val();
        var ROLE_ID = $("#role_id").val();
        window.location.href = '<%=basePath%>/user/excel.do?USERNAME=' + USERNAME + '&lastLoginStart=' + lastLoginStart + '&lastLoginEnd=' + lastLoginEnd + '&ROLE_ID=' + ROLE_ID;
    }

    //打开上传excel页面
    function fromExcel() {
        top.jzts();
        var diag = new top.Dialog();
        diag.Drag = true;
        diag.Title = "EXCEL 导入到数据库";
        diag.URL = 'user/goUploadExcel.do';
        diag.Width = 300;
        diag.Height = 150;
        diag.CancelEvent = function () { //关闭事件
            //nextPage(${page.currentPage});
            $("#table_report").bootgrid("reload");
            diag.close();
        };
        diag.show();
    }

    //数据权限
    function editRights(USER_ID) {
        top.jzts();
        var diag = new top.Dialog();
        diag.Drag = true;
        diag.Title = "数据权限";
        diag.URL = 'data_role/findByUser.do?USER_ID=' + USER_ID;
        diag.Width = 280;
        diag.Height = 370;
        diag.CancelEvent = function () { //关闭事件
            $("#table_report").bootgrid("reload");
            diag.close();
        };
        diag.show();
    }
</script>
</body>
</html>

