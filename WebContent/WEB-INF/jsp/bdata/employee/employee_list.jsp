<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
    String path = request.getContextPath();
    String basePath = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort() + path + "/";
%>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <base href="<%=basePath%>">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta http-equiv="content-Type" content="text/html; charset=UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>员工管理</title>
    <link type="text/css" rel="StyleSheet" href="static/css/ace.min.css"/>
    <link type="text/css" rel="StyleSheet" href="plugins/Bootstrap/css/bootstrap.min.css"/>
    <link type="text/css" rel="StyleSheet" href="plugins/Bootgrid/jquery.bootgrid.min.css"/>
    <link type="text/css" rel="StyleSheet" href="static/css/dtree.css"/>
    <link type="text/css" rel="StyleSheet" href="static/css/style.css"/>
    <link rel="stylesheet" href="static/css/font-awesome.min.css"/>
    <link rel="stylesheet" href="static/css/bootgrid.change.css"/>
    <script type="text/javascript" src="static/js/dtree.js"></script>
    <script src="static/js/jquery-2.0.3.min.js"></script>
    <script>
        $(function () {
            var browser_height = $(document).height();
            $("div.main-container-left").css("min-height", browser_height);
            $(window).resize(function () {
                var browser_height = $(window).height();
                $("div.main-container-left").css("min-height", browser_height);
            });
        });
    </script>

    <script>
        $(function () {
            $(".m-c-l_show").click(function () {
                $(".main-container-left").toggle();
                $(".main-container-left").toggleClass("m-c-l_width");
                $(".m-c-l_show").toggleClass("m-c-l_hide");
            });
        });
    </script>
    <script>
        $(function () {

            $(".m-c-l_show").click(function () {
                var div_width = $(".main-container-left").width();
                $("div.main-content").css("margin-left", div_width + 2);
            });
        });
    </script>

    <script type="text/javascript">
        window.jQuery || document.write("<script src='static/js/jquery-2.0.3.min.js'>" + "<" + "/script>");
    </script>

    <style>
        #zhongxin input[type="checkbox"], input[type="radio"] {
            opacity: 1;
            position: static;
            height: 25px;
            margin-bottom: 10px;
        }

        #zhongxin td {
            height: 40px;
        }

        #zhongxin td label {
            text-align: right;
            margin-right: 10px;
        }

        .container-fluid:before .row:before {
            display: inline;
        }
    </style>
</head>
<body>
<div class="container-fluid" id="main-container">
    <div id="page-content">
        <div class="row-fluid">
            <div class="main-container-left">
                <div class="m-c-l-top">
                    <img src="static/images/ui1.png" style="margin-top:-5px;">员工管理
                </div>
                <script type="text/javascript">
                    varList = new dTree('varList', 'static/img', 'treeForm');
                    varList.config.useIcons = true;
                    varList.add(0, -1, '组织机构', '');
                    <c:forEach items="${varList}" var="var" varStatus="vs">
                    varList.add('${var.ID}', '${var.PARENT_ID}', '[${var.ORDER_NUM}]${var.DEPT_NAME}(${var.eNum})', 'javascript:searchByTree();');
                    </c:forEach>
                    document.write(varList);
                    varList.openAll();
                </script>
            </div>


            <div class="main-content" style="margin-left:220px">
                <div class="breadcrumbs" id="breadcrumbs">
                    <div class="m-c-l_show"></div>
                    员工管理详情
                    <div style="position:absolute; top:5px; right:25px;">

                        <div>
                            <a class="btn btn-small btn-info" onclick="add();"
                               style="margin-right:5px;float:left;">新增</a>
                            <a class="btn btn-small btn-primary" onclick="fromExcel();" title="从EXCEL导入"
                               style="margin-right:5px;float:left;">导入</a>
                            <a class="btn btn-small btn-primary" onclick="exportEmployee();" title="导出员工数据"
                               style="margin-right:5px;float:left;">导出</a>
                            <a class="btn btn-small btn-primary" onclick="fromExcel1();" title="从EXCEL导入"
                               style="margin-right:5px;float:left;">导入档案</a>
                            <a data-toggle="collapse" data-parent="#accordion" href="#collapseTwo"
                               class="btn btn-small btn-primary" style="float:left;text-decoration:none;">高级搜索 </a>
                        </div>
                        <div id="collapseTwo" class="panel-collapse collapse"
                             style="position:absolute; top:32px; right:0; z-index:999">
                            <div class="panel-body">
                                <form id="searchForm">
                                    <table>
                                        <tr>
                                            <td><label>员工编码：</label></td>
                                            <td><input type="text" id="empCode" name="EMP_CODE" style="height:30px;"/>
                                            </td>
                                            <td><label>姓名：</label></td>
                                            <td><input type="text" id="empName" name="EMP_NAME" style="height:30px;"/>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td><label>启用状态：</label></td>
                                            <td>
                                                <select name="ENABLED" id="enabled">
                                                    <option value="">全部</option>
                                                    <option value="1">是</option>
                                                    <option value="0">否</option>
                                                </select>
                                            </td>
                                        </tr>
                                    </table>
                                    <div style="margin-right:30px;float: right;">
                                        <a class="btn-style1" onclick="search2();" data-toggle="collapse"
                                           data-parent="#accordion" href="#collapseTwo" style="cursor: pointer;">查询</a>
                                        <a class="btn-style2" onclick="resetting()" style="cursor: pointer;">重置</a>
                                        <a data-toggle="collapse" data-parent="#accordion" class="btn-style3"
                                           href="#collapseTwo">关闭</a>
                                    </div>
                                </form>
                            </div>
                        </div>


                    </div>
                </div>


                <table id="employee_grid" class="table table-striped table-bordered table-hover">
                    <thead>
                    <tr>
                        <th data-column-id="EMP_CODE" data-width="100px" data-order="asc">员工编号</th>
                        <th data-column-id="EMP_NAME" data-width="70px">姓名</th>
                        <th data-column-id="EMP_GENDER" data-width="70px" data-formatter="gender">性别</th>
                        <th data-column-id="EMP_DEPARTMENT_NAME">员工部门名称</th>
                        <th data-column-id="EMP_EMAIL" data-width="120px">员工邮箱</th>
                        <th data-column-id="EMP_PHONE" data-width="120px">联系电话</th>
                        <th data-column-id="EMP_GRADE_NAME" data-formatter="empGradeName">级别(岗位)名称</th>
                        <th data-column-id="EMP_REMARK">备注</th>
                        <th align="center" data-align="center" data-width="100px" data-sortable="false"
                            data-formatter="btns">操作
                        </th>
                    </tr>
                    </thead>
                </table>
            </div>
        </div>
    </div>
</div>
<script type="text/javascript" src="plugins/JQuery/jquery.min.js"></script>
<script type="text/javascript" src="plugins/Bootstrap/js/bootstrap.min.js"></script>
<script type="text/javascript" src="plugins/Bootgrid/jquery.bootgrid.min.js"></script>
<script type="text/javascript" src="static/js/bootbox.min.js"></script>
<script type="text/javascript">
    $(function () {
        $("#employee_grid").bootgrid({
            ajax: true,
            url: "employee/empList.do",
            navigation: 2,
            formatters: {
                gender: function (column, row) {
                    var value = row.EMP_GENDER;
                    if (value == "1") {
                        return "男";
                    } else if (value == "2") {
                        return "女";
                    } else {
                        return "";
                    }
                },
                empGradeName: function (column, row) {
                    return '<span title="' + row.EMP_GRADE_NAME + '">' + row.EMP_GRADE_NAME + '</span>';
                },
                btns: function (column, row) {
                    return '<a style="cursor:pointer;margin:1px;" title="编辑" onclick="edit(' + row.ID + ');" class="btn btn-mini btn-info" data-rel="tooltip" data-placement="left">' +
                        '<i class="icon-edit"></i></a>' +
                        '<a style="cursor:pointer;margin:1px;" title="删除" onclick="del(' + row.ID + ');" class="btn btn-mini btn-danger" data-rel="tooltip"  data-placement="left">' +
                        '<i class="icon-trash"></i></a>' +
                        '<a style="cursor:pointer;margin:1px;" title="员工档案" onclick="view(' + row.ID + ');" class="btn btn-mini btn-info" data-rel="tooltip"  data-placement="left">' +
                        '<i class="icon-pencil"></i></a>';
                }
            }
        });
    });

    //检索
    function search2() {
        var emp_code = $("#empCode").val();
        var emp_name = $("#empName").val();
        var enabled = $("#enabled").val();
        $("#employee_grid").bootgrid("search",
            {"EMP_CODE": emp_code, "EMP_NAME": emp_name, "ENABLED": enabled});
    }

    function searchByTree() {
        var deptId = varList.getSelected();
        $("#employee_grid").bootgrid("search", {"ID": deptId});
    }

    //新增员工
    function add() {
        top.jzts();
        var diag = new top.Dialog();
        diag.Drag = true;
        diag.Title = "新增员工";
        diag.URL = "<%=basePath%>/employee/goAddEmp.do?";
        diag.Width = 450;
        diag.Height = 480;
        diag.CancelEvent = function () { //关闭事件
            searchByTree();
            diag.close();
        };
        diag.show();
    }

    //修改
    function edit(id) {
        var diag = new top.Dialog();
        diag.Drag = true;
        diag.Title = "编辑";
        diag.URL = '<%=basePath%>/employee/goEditEmp.do?ID=' + id;
        diag.Width = 450;
        diag.Height = 480;
        diag.CancelEvent = function () { //关闭事件
            searchByTree();
            diag.close();
        };
        diag.show();
    }

    //员工档案编辑
    function view(id) {
        top.mainFrame.tabAddHandler(1, "编辑员工档案", "<%=basePath%>/employee/goRecord.do?EMP_ID=" + id);
    }

    //删除
    function del(id) {
        bootbox.confirm("确定要删除该记录吗?", function (result) {
            if (result) {
                var url = "employee/delete.do?ID=" + id;
                $.get(url, function (data) {
                    if (data == "success") {
                        alert("删除员工成功！");
                        $("#employee_grid").bootgrid("reload");
                    }
                }, "text");
            }
        });
    }

    //打开上传excel页面
    function fromExcel() {
        top.jzts();
        var diag = new top.Dialog();
        diag.Drag = true;
        diag.Title = "EXCEL 导入到数据库";
        diag.URL = 'employee/goUploadExcel.do';
        diag.Width = 400;
        diag.Height = 150;
        diag.CancelEvent = function () { //关闭事件
            diag.close();
            location.replace("<%=basePath%>/employee/list.do");
        };
        diag.show();
    }

    //打开上传excel页面
    function fromExcel1() {
        top.jzts();
        var diag = new top.Dialog();
        diag.Drag = true;
        diag.Title = "EXCEL 导入到数据库";
        diag.URL = 'employee/goUploadExcelRecord.do';
        diag.Width = 400;
        diag.Height = 150;
        diag.CancelEvent = function () { //关闭事件
            diag.close();
            location.replace("<%=basePath%>/employee/list.do");
        };
        diag.show();
    }

    //重置
    function resetting() {
        $("#searchForm")[0].reset();
    }

    //导出员工
    function exportEmployee() {
        top.Dialog.confirm("确定导出员工数据？", function () {
            var emp_code = $("#empCode").val();
            var emp_name = $("#empName").val();
            var enabled = $("#enabled").val();
            window.location.href = "<%=basePath%>employee/exportEmployee.do?EMP_CODE=" + emp_code +
                "&EMP_NAME=" + emp_name + "&ENABLED=" + enabled;
        });
    }

    function nextPage(page) {
        top.jzts();
        if (true && document.forms[0]) {
            var url = document.forms[0].getAttribute("action");
            if (url.indexOf('?') > -1) {
                url += "&currentPage=";
            }
            else {
                url += "?currentPage=";
            }
            url = url + page + "&showCount=10";
            document.forms[0].action = url;
            document.forms[0].submit();
        } else {
            var url = document.location + '';
            if (url.indexOf('?') > -1) {
                if (url.indexOf('currentPage') > -1) {
                    var reg = /currentPage=\d*/g;
                    url = url.replace(reg, 'currentPage=');
                } else {
                    url += "&currentPage=";
                }
            } else {
                url += "?currentPage=";
            }
            url = url + page + "&showCount=10";
            document.location = url;
        }
    }
</script>
</body>
</html>