<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%
    String path = request.getContextPath();
    String basePath = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort() + path + "/";
%>
<!DOCTYPE html>
<html lang="zh_CN">
<head>
    <base href="<%=basePath%>">
    <link type="text/css" rel="StyleSheet" href="static/css/ace.min.css"/>
    <link type="text/css" rel="StyleSheet"
          href="plugins/Bootstrap/css/bootstrap.min.css"/>
    <link type="text/css" rel="StyleSheet"
          href="plugins/Bootgrid/jquery.bootgrid.min.css"/>
    <link type="text/css" rel="StyleSheet" href="static/css/dtree.css"/>
    <link type="text/css" rel="StyleSheet" href="static/css/style.css"/>
    <link rel="stylesheet" href="static/css/font-awesome.min.css"/>
    <link rel="stylesheet" href="static/css/bootgrid.change.css"/>
    <style type="text/css">
        li {
            list-style-type: none;
        }
    </style>
</head>
<body>
<div class="container-fluid" id="main-container">
    <div id="page-content" class="clearfix">
        <div class="breadcrumbs" id="breadcrumbs">
            &nbsp; &nbsp; 员工薪资展示
            <div style="position:absolute; top:5px; right:25px;">
                <div>
                    <a class="btn btn-small btn-primary" onclick="fromExcel();" title="从EXCEL导入"
                       style="margin-right:5px;float:left;">导入</a>
                    <a class="btn btn-small btn-primary" onclick="buildData()" title="生成薪资数据"
                       style="margin-right:5px;float:left;">生成薪资</a>
                    <a data-toggle="collapse" data-parent="#accordion" href="#collapseTwo"
                       class="btn btn-small btn-primary" style="float:left;text-decoration:none;">高级搜索 </a>
                </div>
                <div id="collapseTwo" class="panel-collapse collapse"
                     style="position:absolute;  top:32px;right:0; z-index:999">
                    <div class="panel-body">
                        <%-- <span class="input-icon">
                            关键字：<input autocomplete="off" id="nav-search-input" type="text" name="keyword" value="${pd.keyword}" placeholder="这里输入关键词" />
                            <i id="nav-search-icon" class="icon-search"></i>
                        </span> --%>
                        <table>
                            <tr>

                                <td>所属部门:</td>
                                <td><select id="DEPT_ID" name="DEPT_ID">
                                    <option value="">全部</option>
                                    <c:forEach items="${deptList }" var="dept" varStatus="vs">
                                        <option value="${dept.ID }">${dept.DEPT_NAME}</option>
                                    </c:forEach>
                                </select>
                                </td>
                                <td>岗位类别:</td>
                                <td><select id="POS_ID" name="POS_ID">
                                    <option value="">全部</option>
                                    <c:forEach items="${posList }" var="pos" varStatus="vs">
                                        <option value="${pos.ID }">${pos.GRADE_NAME}</option>
                                    </c:forEach>
                                </select></td>

                            </tr>
                            <tr>
                                <td>年月:</td>
                                <td><input type="text" id="YM" name="YM"
                                           style="background:#fff!important;width: 170px;"
                                           class="date-picker" data-date-format="yyyy-mm"
                                           placeholder="请输入年月！" readonly="readonly"/></td>
                            </tr>
                        </table>
                        <div
                                style="margin-top:15px; margin-right:30px; text-align:right;">
                            <a class="btn-style1" onclick="search2();" data-toggle="collapse" data-parent="#accordion"
                               href="#collapseTwo" style="cursor: pointer;">查询</a>
                            <a class="btn-style2" onclick="resetting()" style="cursor: pointer;">重置</a>
                            <a data-toggle="collapse" data-parent="#accordion" class="btn-style3"
                               href="#collapseTwo">关闭</a>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <div class="row-fluid">

        <%-- <div class="nav-search" id="nav-search"
            style="right:5px;margin-top: 20px;" class="form-search">
            <div class="panel panel-default"
                style="float:left;position: absolute;z-index: 1000;">
                <div>
                    <a data-toggle="collapse" data-parent="#accordion"
                        href="#collapseTwo" class="btn btn-small btn-primary"
                        style="float:left;text-decoration:none;">高级搜索 </a> <a
                        class="btn btn-small btn-primary" onclick="fromExcel();"
                        title="从EXCEL导入" style="margin-left:30px;">导入</a> <a
                        class="btn btn-small btn-primary" onclick="buildData()"
                        title="生成薪资数据" style="margin-left:30px;">生成薪资</a>
                </div>
                <div id="collapseTwo" class="panel-collapse collapse"
                    style="position:absolute; top:32px; z-index:999">
                    <div class="panel-body">
                        <form id="searchForm">
                            <table>

                                <tr>

                                    <td>所属部门:</td>
                                    <td><select id="DEPT_ID" name="DEPT_ID">
                                            <option value="">全部</option>
                                            <c:forEach items="${deptList }" var="dept" varStatus="vs">
                                                <option value="${dept.ID }">${dept.DEPT_NAME}</option>
                                            </c:forEach>
                                    </select>
                                    </td>
                                    <td>岗位类别:</td>
                                    <td><select id="POS_ID" name="POS_ID">
                                            <option value="">全部</option>
                                            <c:forEach items="${posList }" var="pos" varStatus="vs">
                                                <option value="${pos.ID }">${pos.GRADE_NAME}</option>
                                            </c:forEach>
                                    </select></td>

                                </tr>
                                <tr>
                                    <td>年月:</td>
                                    <td><input type="text" id="YM" name="YM"
                                        style="background:#fff!important;width: 170px;"
                                        class="date-picker" data-date-format="yyyy-mm"
                                        placeholder="请输入年月！" readonly="readonly" /></td>
                                </tr>

                            </table>
                            <div style="margin-right:30px;float: right;">
                                <a class="btn-style1" onclick="search2();"
                                    data-toggle="collapse" data-parent="#accordion"
                                    href="#collapseTwo" style="cursor: pointer;">查询</a> <a
                                    class="btn-style2" onclick="resetting()"
                                    style="cursor: pointer;">重置</a> <a data-toggle="collapse"
                                    data-parent="#accordion" class="btn-style3"
                                    href="#collapseTwo">关闭</a>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        </div> --%>
        <table id="task_grid"
               class="table table-striped table-bordered table-hover">
            <colgroup>
                <col style="width: 10%">
                <col style="width: 10%">
                <col style="width: 10%">
                <col style="width: 10%">
                <col style="width: 10%">
                <col style="width: 20%">
                <col style="width: 10%">
                <col style="width: 10%">
                <col style="width: 10%">
            </colgroup>
            <thead>
            <tr>
                <th data-column-id="EMP_CODE">员工编号</th>
                <th data-column-id="EMP_NAME">姓名</th>
                <th data-column-id="EMP_GENDER" data-formatter="gender">性别</th>
                <th data-column-id="DEPT_NAME">所属部门</th>
                <th data-column-id="POS_NAME">岗位类别</th>
                <th data-column-id="FORMULA">所属公式</th>
                <th data-column-id="YM">年月</th>
                <th data-column-id="SALARY_AMOUNT">工资</th>
                <th align="center" data-align="center" data-sortable="false"
                    data-formatter="btns">操作
                </th>
            </tr>
            </thead>
        </table>
    </div>
</div>

<!--/.fluid-container#main-container-->
<script type="text/javascript" src="plugins/JQuery/jquery.min.js"></script>
<script type="text/javascript"
        src="plugins/Bootstrap/js/bootstrap.min.js"></script>
<script type="text/javascript"
        src="plugins/Bootgrid/jquery.bootgrid.min.js"></script>
<script type="text/javascript" src="static/js/bootbox.min.js"></script>
<script src="static/js/ace-elements.min.js"></script>
<script src="static/js/ace.min.js"></script>
<script type="text/javascript" src="static/js/chosen.jquery.min.js"></script>
<!-- 下拉框 -->
<script type="text/javascript"
        src="static/js/bootstrap-datepicker.min.js"></script>
<!-- 日期框 -->
<script type="text/javascript" src="static/js/bootbox.min.js"></script>
<!-- 确认窗口 -->
<script type="text/javascript" src="static/js/jquery.tips.js"></script>
<!--提示框-->
<script type="text/javascript">
    $(function () {
        //表格数据获取
        $("#task_grid").bootgrid({
            ajax: true,
            url: "salary/taskList.do",
            navigation: 2,
            formatters: {
                btns: function (column, row) {
                    var res = row.STATUS;
                    return '<a style="cursor:pointer;margin-left: 2px;" title="查看" onclick="view(\'' + row.ID + '\');" class="btn btn-mini btn-info" data-rel="tooltip" data-placement="left">' +
                        '查看</a>' +
                        '<a style="cursor:pointer;margin-left: 2px;" title="编辑" onclick="edit(\'' + row.ID + '\',\'' + row.POS_ID + '\');" class="btn btn-mini btn-primary" data-rel="tooltip" data-placement="left">' +
                        '编辑</a>';
                },
                gender: function (column, row) {
                    var type = row.EMP_GENDER;
                    if (type == '1') {
                        return '男';
                    } else if (type == '2') {
                        return '女';
                    }
                },

            },
            labels: {
                infos: "{{ctx.start}}至{{ctx.end}}条，共{{ctx.total}}条",
                refresh: "刷新",
                noResults: "未查询到数据",
                loading: "正在加载...",
                all: "全选"
            },
            rowCount: [10, 25, 50, 100]
        });
        //日期框
        $('.date-picker').datepicker({
            format: 'yyyy-mm',
            changeMonth: true,
            changeYear: true,
            showButtonPanel: true,
            autoclose: true,
            minViewMode: 0,
            maxViewMode: 2,
            startViewMode: 0,
            onClose: function (dateText, inst) {
                var year = $("#span2 date-picker .ui-datepicker-year :selected").val();
                $(this).datepicker('setDate', new Date(year, 1));
            }
        });
    });


    //重置
    function resetting() {
        $("#DEPT_ID").val("");
        $("#POS_ID").val("");
        $("#YM").val("");
    }

    //检索
    function search2() {
        var deptId = $("#DEPT_ID").val();
        var posId = $("#POS_ID").val();
        var YM = $("#YM").val();
        $("#task_grid").bootgrid("search",
            {"DEPT_ID": deptId, "POS_ID": posId, "YM": YM});
    }


    // 查看
    function view(id) {
        top.jzts();
        var diag = new top.Dialog();
        diag.Drag = true;
        diag.Title = "查看";
        diag.URL = '<%=basePath%>/salary/goView.do?id=' + id;
        diag.Width = 700;
        diag.Height = 480;
        diag.CancelEvent = function () { //关闭事件
            location.replace('<%=basePath%>/salary/list.do');
            diag.close();
        };
        diag.show();
    }

    //修改
    function edit(id) {
        top.jzts();
        var diag = new top.Dialog();
        diag.Drag = true;
        diag.Title = "编辑";
        diag.URL = '<%=basePath%>/salary/goEdit.do?id=' + id;
        diag.Width = 700;
        diag.Height = 480;
        diag.CancelEvent = function () { //关闭事件
            location.replace('<%=basePath%>/salary/list.do');
            diag.close();
        };
        diag.show();
    }

    //打开上传excel页面
    function fromExcel() {
        top.jzts();
        var diag = new top.Dialog();
        diag.Drag = true;
        diag.Title = "EXCEL 导入到数据库";
        diag.URL = 'salary/goUploadExcel.do';
        diag.Width = 400;
        diag.Height = 150;
        diag.CancelEvent = function () { //关闭事件
            location.replace('<%=basePath%>/salary/list.do');
            diag.close();
        };
        diag.show();
    }

    //生成数据
    function buildData() {
        var url = '<%=basePath%>salary/buildData.do';
        $.ajax({
            type: "POST",
            url: url,
            success: function (data) {
                var obj = eval('(' + data + ')');
                alert(obj.msg);
                location.replace('<%=basePath%>/salary/list.do');
            }
        });
    }
</script>
</body>
</html>
