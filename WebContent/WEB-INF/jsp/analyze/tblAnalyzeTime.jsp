<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
    String path = request.getContextPath();
    String basePath = request.getScheme() + "://"
            + request.getServerName() + ":" + request.getServerPort()
            + path + "/";
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <base href="<%=basePath%>">
    <link type="text/css" rel="StyleSheet"
          href="plugins/Bootstrap/css/bootstrap.min.css"/>
    <link type="text/css" rel="StyleSheet"
          href="plugins/Bootgrid/jquery.bootgrid.min.css"/>
    <link type="text/css" rel="StyleSheet" href="static/css/dtree.css"/>
    <link type="text/css" rel="StyleSheet" href="static/css/style.css"/>
    <link rel="stylesheet" href="static/css/font-awesome.min.css"/>
    <link rel="stylesheet" href="static/css/bootgrid.change.css"/>

</head>

<body>
<div class="container-fluid" id="main-container">
    <div class="row">
        <div class="col-md-12">
            <div class="nav-search" id="nav-search"
                 style="right:5px;margin-top: 20px;" class="form-search">
                <div class="panel panel-default"
                     style="float:left;position: absolute;z-index: 1000;">
                    <div style="width: 100%;height: 20%;">
                        <table>
                            <tr>
                                <td id="deptTd">&nbsp;&nbsp;&nbsp;&nbsp;部门名称： <select id="dept_select"
                                                                                      style="width:170px;">
                                    <option value="">全部</option>
                                    <c:forEach items="${deptList}" var="dept">
                                        <option value="${dept.DEPT_ID }">${dept.DEPT_NAME }</option>
                                    </c:forEach>
                                </select></td>
                                <td>&nbsp;&nbsp;&nbsp;&nbsp;开始时间： <input class="date-picker" id="startTime"
                                                                         name="startTime" type="text"
                                                                         data-date-format="yyyy-mm-dd"
                                                                         style="width:170px;"/>
                                </td>
                                <td>&nbsp;&nbsp;&nbsp;&nbsp;结束时间： <input class="date-picker" id="endTime"
                                                                         name="endTime" type="text"
                                                                         data-date-format="yyyy-mm-dd"
                                                                         style="width:170px;"/>
                                </td>
                                <td>&nbsp;&nbsp;&nbsp;&nbsp;工作类型：<select id="type_select"
                                                                         style="width:170px;">
                                    <option value="1">日常类工作</option>
                                    <option value="2">流程类工作</option>

                                </select>
                                </td>
                                <td>
                                    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<button type="button"
                                                                                            class="btn btn-info btn-small"
                                                                                            onClick="queryChart()">
                                    查询 <i class="icon-search icon-on-right bigger-110"></i>
                                </button>
                                </td>

                            </tr>

                        </table>
                    </div>
                </div>
            </div>
            <div id="taskDiv" style="margin-top: 50px;">
                <table id="sample-table-1"
                       class="table table-striped table-bordered table-hover">
                    <thead>
                    <tr>
                        <th data-column-id="EMP_NAME">员工</th>
                        <th data-column-id="AVGTIME" data-formatter="changeAVG">平均工作时间(小时)</th>
                        <th data-column-id="MINTIME" data-formatter="changeMIN">最低工作时间(小时)</th>
                        <th data-column-id="MAXTIME" data-formatter="changeMAX">最高工作时间(小时)</th>
                        <th data-column-id="SUMTIME" data-formatter="changeSUM">工作时间累计(小时)</th>
                    </tr>
                    </thead>
                </table>
            </div>
            <div style="display: none;margin-top: 50px;" id="flowDiv">
                <table id="sample-table-2"
                       class="table table-striped table-bordered table-hover">
                    <thead>
                    <tr>
                        <th data-column-id="EMP_NAME">员工</th>
                        <th data-column-id="AVGTIME" data-formatter="changeAVG">平均工作时间(小时)</th>
                        <th data-column-id="MINTIME" data-formatter="changeMIN">最低工作时间(小时)</th>
                        <th data-column-id="MAXTIME" data-formatter="changeMAX">最高工作时间(小时)</th>
                        <th data-column-id="SUMTIME" data-formatter="changeSUM">工作时间累计(小时)</th>
                    </tr>
                    </thead>
                </table>
            </div>
        </div>
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
        //获取表格数据
        $("#sample-table-1").bootgrid({
            ajax: true,
            navigation: 2,
            url: "tblanalyze/taksList.do",
            formatters: {
                changeAVG: function (column, row) {
                    var avg = row.AVGTIME;
                    avg = avg / 3600;
                    avg = avg.toFixed(2);
                    return avg;
                },
                changeMIN: function (column, row) {
                    var avg = row.MINTIME;
                    avg = avg / 3600;
                    avg = avg.toFixed(2);
                    return avg;
                },
                changeMAX: function (column, row) {
                    var avg = row.MAXTIME;
                    avg = avg / 3600;
                    avg = avg.toFixed(2);
                    return avg;
                },
                changeSUM: function (column, row) {
                    var avg = row.SUMTIME;
                    avg = avg / 3600;
                    avg = avg.toFixed(2);
                    return avg;
                },
            }

        });
        //获取表格数据
        $("#sample-table-2").bootgrid({
            ajax: true,
            navigation: 2,
            url: "tblanalyze/taksList2.do",
            formatters: {
                changeAVG: function (column, row) {
                    var avg = row.AVGTIME;
                    avg = avg / 3600;
                    avg = avg.toFixed(2);
                    return avg;
                },
                changeMIN: function (column, row) {
                    var avg = row.MINTIME;
                    avg = avg / 3600;
                    avg = avg.toFixed(2);
                    return avg;
                },
                changeMAX: function (column, row) {
                    var avg = row.MAXTIME;
                    avg = avg / 3600;
                    avg = avg.toFixed(2);
                    return avg;
                },
                changeSUM: function (column, row) {
                    var avg = row.SUMTIME;
                    avg = avg / 3600;
                    avg = avg.toFixed(2);
                    return avg;
                },
            }

        });
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
    });

    //查询按钮
    function queryChart() {
        var startTime = $("#startTime").val();
        var endTime = $("#endTime").val();
        if (startTime > endTime) {
            top.Dialog.alert("开始时间不能晚于结束时间!");
            return;
        }
        var type = $("#type_select").val();
        if (type == 1) {
            $("#taskDiv").show();
            $("#flowDiv").hide();
            if ($("#dept_select").val() == "") {
                $("#sample-table-1").bootgrid("search", {
                    "startTime": startTime,
                    "endTime": endTime
                });
            } else {
                var dept_id = $("#dept_select").val();
                $("#sample-table-1").bootgrid("search", {
                    "DEPT_ID": dept_id,
                    "startTime": startTime,
                    "endTime": endTime
                });
            }
        } else {
            $("#flowDiv").show();
            $("#taskDiv").hide();
            if ($("#dept_select").val() == "") {
                $("#sample-table-2").bootgrid("search", {
                    "startTime": startTime,
                    "endTime": endTime
                });
            } else {
                var dept_id = $("#dept_select").val();
                $("#sample-table-2").bootgrid("search", {
                    "DEPT_ID": dept_id,
                    "startTime": startTime,
                    "endTime": endTime
                });
            }
        }


    }
</script>
</body>
</html>
