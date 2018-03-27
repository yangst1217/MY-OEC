<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%
    String path = request.getContextPath();
    String basePath = request.getScheme() + "://"
            + request.getServerName() + ":" + request.getServerPort()
            + path + "/";
%>

<!DOCTYPE html>
<html lang="zh_CN">
<head>
    <base href="<%=basePath%>">
    <link type="text/css" rel="StyleSheet" href="plugins/Bootstrap/css/bootstrap.min.css"/>
    <link type="text/css" rel="StyleSheet" href="plugins/Bootgrid/jquery.bootgrid.min.css"/>
    <link type="text/css" rel="StyleSheet" href="static/css/dtree.css"/>
    <link type="text/css" rel="StyleSheet" href="static/css/style.css"/>
    <link rel="stylesheet" href="static/css/font-awesome.min.css"/>
    <link rel="stylesheet" href="static/css/bootgrid.change.css"/>
    <link rel="stylesheet" href="static/css/datepicker.css"/><!-- 日期框 -->
</head>

<body>
<div class="container-fluid" id="main-container">
    <div class="row">
        <div class="col-md-12">
            <div class="nav-search" id="nav-search"
                 style="right:5px;margin-top: 20px;" class="form-search">
                <div class="panel panel-default"
                     style="float:left;position: absolute;z-index: 1000;">
                    <div>
                        <a data-toggle="collapse" data-parent="#accordion"
                           href="#collapseTwo" class="btn btn-small btn-primary"
                           style="margin-right:5px;float:left;text-decoration:none;">高级搜索 </a>
                        <a class="btn btn-small btn-info" onclick="toExcel();" style="float:left;">导出全部员工绩效</a>
                    </div>
                    <div id="collapseTwo" class="panel-collapse collapse"
                         style="position:absolute; top:32px; z-index:999">
                        <form id="searchForm">
                            <div class="panel-body">
                                <table>

                                    <tr>
                                        <td>姓名:</td>
                                        <td><input name="EMP_NAME" id="EMP_NAME" type="text"></td>
                                        <td>工号:</td>
                                        <td><input name="EMP_CODE" id="EMP_CODE" type="text"></td>
                                    </tr>
                                    <tr>
                                        <td>部门:</td>
                                        <td><input name="DEPT_NAME" id="DEPT_NAME" type="text"></td>
                                        <td>年月:</td>
                                        <td><input type="text" id="MONTH" name="MONTH"
                                                   style="width:160px;background:#fff!important;"
                                                   class="date-picker" data-date-format="yyyy-mm" placeholder="请输入年月"
                                                   readonly="readonly"/></td>
                                    </tr>

                                </table>
                                <div style="margin-right:30px;float: right;">
                                    <a class="btn-style1" onclick="toSearch();"
                                       data-toggle="collapse" data-parent="#accordion"
                                       href="#collapseTwo" style="cursor: pointer;">查询</a> <a
                                        class="btn-style2" onclick="emptySearch()"
                                        style="cursor: pointer;">重置</a> <a data-toggle="collapse"
                                                                           data-parent="#accordion" class="btn-style3"
                                                                           href="#collapseTwo">关闭</a>
                                </div>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
            <table id="task_grid"
                   class="table table-striped table-bordered table-hover">
                <thead>
                <tr>
                    <th data-column-id="EMP_CODE">员工号</th>
                    <th data-column-id="EMP_NAME" data-formatter="links">员工姓名</th>
                    <th data-column-id="EMP_GRADE_NAME">岗位</th>
                    <th data-column-id="EMP_DEPARTMENT_NAME">部门</th>
                    <th data-column-id="MONTH">年月</th>
                    <th data-column-id="LASTMONTH_SCORE">上月得分</th>
                    <th data-column-id="AVERAGE_SCORE">平均得分</th>
                    <th data-column-id="SCORE">当月得分</th>
                    <th data-column-id="RANKING">当月排名</th>
                </tr>
                </thead>
            </table>
        </div>
    </div>
</div>
<script type="text/javascript" src="plugins/JQuery/jquery.min.js"></script>
<script type="text/javascript" src="plugins/Bootstrap/js/bootstrap.min.js"></script>
<script type="text/javascript" src="plugins/Bootgrid/jquery.bootgrid.min.js"></script>
<script type="text/javascript" src="static/js/bootbox.min.js"></script>
<script src="static/js/ace-elements.min.js"></script>
<script src="static/js/ace.min.js"></script>
<script type="text/javascript" src="static/js/chosen.jquery.min.js"></script><!-- 下拉框 -->
<script type="text/javascript" src="static/js/bootstrap-datepicker.min.js"></script><!-- 日期框 -->
<script type="text/javascript" src="static/js/bootbox.min.js"></script><!-- 确认窗口 -->
<script type="text/javascript" src="static/js/jquery.tips.js"></script><!--提示框-->
<script type="text/javascript">
    $(function () {

        //日期框
        $('.date-picker').datepicker({
            format: 'yyyy-mm',
            autoclose: true,
            startViewMode: 2,
            minViewMode: 1,
            maxViewMode: 1

        });

        //表格数据获取
        $("#task_grid").bootgrid({
            ajax: true,
            url: "performance/empList.do",
            formatters: {
                links: function (column, row) {
                    if ("${isLeader}" == "1") {
                        return "<a href='<%=basePath%>/performance/listTask.do?empCode=" + row.EMP_CODE + "&MONTH=" + row.MONTH + "&PERF_ID=" + row.PERF_ID + "&SCORE=" + row.SCORE + "'>" + row.EMP_NAME + "</a>";
                    } else if ("${EMP_CODE}" == row.EMP_CODE) {
                        return "<a href='<%=basePath%>/performance/listTask.do?empCode=" + row.EMP_CODE + "&MONTH=" + row.MONTH + "&PERF_ID=" + row.PERF_ID + "&SCORE=" + row.SCORE + "&SELF=1'>" + row.EMP_NAME + "</a>";
                    } else {
                        return row.EMP_NAME;
                    }
                }
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

    });


    //检索
    function toSearch() {
        var DEPT_NAME = $("#DEPT_NAME").val();
        var EMP_NAME = $("#EMP_NAME").val();
        var EMP_CODE = $("#EMP_CODE").val();
        var MONTH = $("#MONTH").val();
        $("#task_grid").bootgrid("search",
            {"DEPT_NAME": DEPT_NAME, "EMP_NAME": EMP_NAME, "EMP_CODE": EMP_CODE, "MONTH": MONTH});
    }

    //导出excel
    function toExcel() {
        window.location.href = '<%=basePath%>/performance/excel.do';
    }

    //重置
    function emptySearch() {
        $("#searchForm")[0].reset();
    }

</script>
</body>
</html>
