<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%
    String path = request.getContextPath();
    String basePath = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort() + path + "/";
%>
<!DOCTYPE html>
<html lang="zh_CN">
<head>
    <link type="text/css" rel="StyleSheet" href="plugins/Bootstrap/css/bootstrap.min.css"/>
    <link type="text/css" rel="StyleSheet" href="plugins/Bootgrid/jquery.bootgrid.min.css"/>
    <link type="text/css" rel="StyleSheet" href="static/css/dtree.css"/>
    <link type="text/css" rel="StyleSheet" href="static/css/style.css"/>
    <link rel="stylesheet" href="static/css/font-awesome.min.css"/>
    <link rel="stylesheet" href="static/css/bootgrid.change.css"/>
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
    <style type="text/css">

        body, div, ul, li {
            padding: 0;
            text-align: center;
        }

        body {
            font: 12px "宋体";
            text-align: center;
        }

        a:link {
            color: #00F;
            text-decoration: none;
        }

        a:visited {
            color: #00F;
            text-decoration: none;
        }

        a:hover {
            color: #c00;
            text-decoration: underline;
        }

        ul {
            list-style: none;
        }

        .infoTbl td {
            height: 40px;
        }

        .infoTbl td input {
            height: 30px;
            padding: 5px;
            margin-bottom: 5px;
            border: 0;
        }

        #myTab {
            margin-bottom: 0;
        }

        #myTab > li {
            background: #98c0d9;
            margin: 0;
            border: 2px solid #98c0d9;
        }

        #myTab > li.active {
            border: 2px solid #448fb9;
        }

        #myTab > li.active a {
            margin: 0;
            box-shadow: none !important;
            background: #448fb9;
        }

        #myTab > li.active a:hover {
            background: #448fb9;
        }

        #myTab > li a {
            color: #fff;
            padding: 12px 25px;
        }

        #myTab > li a:hover {
            color: #fff;
            background: #98c0d9;
        }

        .dropdown-menu > li {
            color: #98c0d9 !important;
            background: #fff !important;
        }

        .dropdown-menu > li a {
            color: #98c0d9 !important;
            background: #fff !important;
        }

        .dropdown-menu > li.active a {
            color: #fff !important;
            background: #448fb9 !important;
        }
    </style>
    <script>
        /*第一种形式 第二种形式 更换显示样式*/
        function setTab(name, cursel, n) {
            for (i = 1; i <= n; i++) {
                var menu = document.getElementById(name + i);
                var con = document.getElementById("con_" + name + "_" + i);
                menu.className = i == cursel ? "hover" : "";
                con.style.display = i == cursel ? "block" : "none";
            }
        }
    </script>
</head>
<body>


<div id="Tab1">

    <ul id="myTab" class="nav nav-tabs">
        <li class="active"><a href="#con_one_1" data-toggle="tab">工作目标</a></li>
        <li class="dropdown">
            <a href="dropdown-toggle" data-toggle="dropdown">员工任务<i
                    class="icon-caret-down bigger-110 width-auto"></i></a>
            <ul class="dropdown-menu dropdown-info" style="margin:1px;min-width:120px;left:-3px;">
                <li><a data-toggle="tab" href="#con_one_21">目标工作</a></li>
                <li><a data-toggle="tab" href="#con_one_22">重点协同工作</a></li>
                <li><a data-toggle="tab" href="#con_one_23">流程工作</a></li>
                <li><a data-toggle="tab" href="#con_one_24">日常工作</a></li>
                <li><a data-toggle="tab" href="#con_one_25">临时工作</a></li>
            </ul>
        </li>
        <li><a href="#con_one_3" data-toggle="tab">员工考核</a></li>
        <li><a href="#con_one_4" data-toggle="tab">员工简历</a></li>
        <a class="btn btn-small btn-info" onclick="location.href='javascript:history.go(-1);'"
           style="cursor: pointer;float:right;margin-top:10px;margin-right:20px;">返回</a>
    </ul>
    <div id="myTabContent" class="tab-content">
        <div id="con_one_1" class="tab-pane fade in active">
            <div class="table-responsive">

                <div style="float: left; margin:15px;">
                    员工编号:<input type="text" id="EMP_CODE1" readonly="readonly"
                                style="width:150px; height:30px; margin-left:5px; margin-right:20px; padding-left:10px;">
                    员工姓名:<input type="text" id="EMP_NAME1" readonly="readonly"
                                style="width:150px; height:30px; margin-left:5px; margin-right:20px; padding-left:10px;">
                    所属部门:<input type="text" id="DEPT_NAME1" readonly="readonly"
                                style="width:150px; height:30px; margin-left:5px; margin-right:20px; padding-left:10px;">
                </div>

                <table id="grid1" class="table table-striped table-bordered table-hover">
                    <colgroup>
                        <col style="width: 8%">
                        <col style="width: 15%">
                        <col style="width: 8%">
                        <col style="width: 8%">
                        <col style="width: 11%">
                        <col style="width: 8%">
                        <col style="width: 8%">
                        <col style="width: 8%">
                        <col style="width: 8%">
                        <col style="width: 8%">
                        <col style="width: 8%">
                    </colgroup>
                    <thead>
                    <tr>
                        <th data-column-id="CODE" data-order="asc">编号</th>
                        <th data-column-id="NAME">任务</th>
                        <th data-column-id="START_DATE">开始时间</th>
                        <th data-column-id="END_DATE">结束时间</th>
                        <th data-column-id="PRODUCT_NAME">产品</th>
                        <th data-column-id="INDEX_NAME">经营指标</th>
                        <th data-column-id="COUNT">目标数量</th>
                        <th data-column-id="UNIT_NAME">单位</th>
                        <th data-column-id="DEPT_NAME">承接部门</th>
                        <th data-column-id="EMP_NAME">承接责任人</th>
                        <th data-column-id="STATUS_NAME">状态</th>
                    </tr>
                    </thead>
                </table>

            </div><!--/.fluid-container#main-container-->
        </div>
        <div id="con_one_2" class="tab-pane fade">
            <div class="table-responsive">

                <div style="float: left; margin:15px;">
                    员工编号:<input type="text" id="EMP_CODE2" readonly="readonly"
                                style="width:150px; height:30px; margin-left:5px; margin-right:20px; padding-left:10px;">
                    员工姓名:<input type="text" id="EMP_NAME2" readonly="readonly"
                                style="width:150px; height:30px; margin-left:5px; margin-right:20px; padding-left:10px;">
                    所属部门:<input type="text" id="DEPT_NAME2" readonly="readonly"
                                style="width:150px; height:30px; margin-left:5px; margin-right:20px; padding-left:10px;">
                </div>
                <table id="grid2" class="table table-striped table-bordered table-hover">
                    <colgroup>
                        <col style="width: 15%">
                        <col style="width: 8%">
                        <col style="width: 8%">
                        <col style="width: 8%">
                        <col style="width: 8%">
                        <col style="width: 8%">
                        <col style="width: 9%">
                        <col style="width: 9%">
                        <col style="width: 9%">
                        <col style="width: 9%">
                        <col style="width: 9%">
                    </colgroup>
                    <thead>
                    <tr>
                        <th data-column-id="TARGET_NAME" data-order="asc">年度目标</th>
                        <th data-column-id="INDEX_NAME">经营指标</th>
                        <th data-column-id="PRODUCT_NAME">产品名称</th>
                        <th data-column-id="WEEK_COUNT">目标数量</th>
                        <th data-column-id="DEPT_NAME">部门</th>
                        <th data-column-id="EMP_NAME">任务对象</th>
                        <th data-column-id="actual_percent" data-formatter="actual">实际进度</th>
                        <th data-column-id="ISLATE" data-formatter="islate">进度滞后</th>
                        <th data-column-id="WEEK_START_DATE">开始时间</th>
                        <th data-column-id="WEEK_END_DATE">结束时间</th>
                        <th data-column-id="STATUS">状态</th>
                    </tr>
                    </thead>
                </table>

            </div><!--/.fluid-container#main-container-->
        </div>
        <div id="con_one_3" class="tab-pane fade">
            <div id="perfom" class="tab-content">
                <table id="tbl3" class="table table-striped table-bordered table-hover">
                </table>
            </div>
        </div>
        <div id="con_one_4" class="tab-pane fade">
            <table style="margin-left: 25px;" class="infoTbl">
                <tr>
                    <td style="padding-left: 30px;">
                        <label>员工姓名：</label>
                    </td>
                    <td>
                        <input type="text" name="NAME" id="name"
                               readonly="readonly" placeholder="姓名" title="姓名"/>
                    </td>
                    <td style="padding-left: 30px;">
                        <label>出生日期：</label>
                    </td>
                    <td>
                        <input type="text" name="BIRTHDAY" id="birthday"
                               placeholder="出生日期" title="出生日期" readonly="readonly"/>
                    </td>
                    <td style="padding-left: 30px;">
                        <label>员工性别：</label>
                    </td>
                    <td>
                        <input type="text" name="GENDER" id="gender"
                               placeholder="员工性别" title="员工性别" readonly="readonly"/>
                    </td>
                </tr>
                <tr>
                    <td style="padding-left: 30px;">
                        <label>年&nbsp;龄：</label>
                    </td>
                    <td>
                        <input type="text" name="AGE" id="age"
                               placeholder="年龄" title="年龄" readonly="readonly"/>
                    </td>
                    <td style="padding-left: 30px;">
                        <label>籍&nbsp;贯：</label>
                    </td>
                    <td colspan="3" style="width:500px">
                        <input type="text" name="ADDRESS" id="address"
                               placeholder="籍贯" title="籍贯" style="width:90.6%" readonly="readonly"/>
                    </td>
                </tr>
                <tr>
                    <td style="padding-left: 30px;">
                        <label>联系电话：</label>
                    </td>
                    <td>
                        <input type="text" name="PHONE" id="phone"
                               placeholder="联系电话" title="联系电话" readonly="readonly"/>
                    </td>
                    <td style="padding-left: 30px;">
                        <label>员工邮箱：</label>
                    </td>
                    <td>
                        <input type="text" name="EMAIL" id="email"
                               placeholder="员工邮箱" title="员工邮箱" readonly="readonly"/>
                    </td>
                    <td style="padding-left: 30px;">
                        <label>专&nbsp;业：</label>
                    </td>
                    <td>
                        <input type="text" name="MAJOR" id="major"
                               placeholder="专业" title="专业" readonly="readonly"/>
                    </td>
                </tr>
                <tr>
                    <td style="padding-left: 30px;">
                        <label>毕业学校：</label>
                    </td>
                    <td>
                        <input type="text" name="SCHOOL" id="school"
                               placeholder="毕业学校" title="毕业学校" readonly="readonly"/>
                    </td>
                    <td style="padding-left: 30px;">
                        <label>毕业时间：</label>
                    </td>
                    <td>
                        <input type="text" name="GRADUATE_TIME" id="graduate_time"
                               placeholder="毕业时间" title="毕业时间" readonly="readonly"/>
                    </td>
                    <td style="padding-left: 30px;">
                        <label>学&nbsp;位：</label>
                    </td>
                    <td>
                        <input type="text" name="DEGREE" id="degree"
                               placeholder="学位" title="学位" readonly="readonly"/>
                    </td>
                </tr>
            </table>
            <div class="table-responsive">
                <table id="grid4" class="table table-striped table-bordered table-hover">
                    <thead>
                    <tr>
                        <th data-column-id="EXP">结束时间</th>
                        <th data-column-id="POSITION">状态</th>
                    </tr>
                    </thead>
                </table>

            </div><!--/.fluid-container#main-container-->
        </div>
        <div id="con_one_21" class="tab-pane fade">
            <div class="table-responsive">
                <table id="task_grid_0" class="table table-striped table-bordered table-hover">
                    <thead>
                    <tr>
                        <th data-width="50px" data-column-id="ID" data-visible="false" data-formatter="id"
                            data-css-class="aa" data-sortable="true">ID
                        </th>
                        <th data-width="15%" data-column-id="TARGET_NAME">年度目标</th>
                        <th data-width="12%" data-column-id="INDEX_NAME">经营指标</th>
                        <th data-width="12%" data-column-id="PRODUCT_NAME">产品名称</th>
                        <th data-width="80px" data-column-id="WEEK_COUNT" data-formatter="weekCount">目标数量</th>
                        <!-- <th data-width="40px" data-column-id="">单位</th> -->
                        <c:if test="${not empty pd.showDept }"><!-- 日清看板才显示 -->
                        <th data-width="10%" data-column-id="DEPT_NAME">承接部门</th>
                        <th data-width="80px" data-column-id="EMP_NAME">承接责任人</th>
                        </c:if>
                        <th data-width="80px" data-column-id="actual_percent" data-formatter="actualPercent">实际进度</th>
                        <th data-width="80px" data-column-id="plan_percent" data-formatter="isDelay">进度滞后</th>
                        <th data-width="80px" data-column-id="WEEK_START_DATE">开始时间</th>
                        <th data-width="80px" data-column-id="WEEK_END_DATE">结束时间</th>
                        <th data-width="60px" data-column-id="STATUS">状态</th>
                    </tr>
                    </thead>
                </table>
            </div>
        </div>
        <div id="con_one_22" class="tab-pane fade">
            <div class="table-responsive">
                <table id="task_grid_1" class="table table-striped table-bordered table-hover">
                    <thead>
                    <tr>
                        <th data-width="50px" data-column-id="ID" data-visible="false" data-formatter="id"
                            data-css-class="" data-sortable="true">ID
                        </th>
                        <th data-width="15%" data-column-id="EVENT_NAME">活动名称</th>
                        <th data-width="15%" data-column-id="preTaskName">前置活动</th>
                        <th data-width="13%" data-column-id="NODE_TARGET">节点名称</th>
                        <th data-width="13%" data-column-id="PROJECT_NAME">项目名称</th>
                        <th data-width="80px" data-column-id="PROJECT_TYPE">项目类型</th>
                        <th data-width="50px" data-column-id="WEIGHT">权重</th>
                        <c:if test="${not empty pd.showDept }"><!-- 日清看板才显示 -->
                        <th data-width="10%" data-column-id="DEPT_NAME">承接部门</th>
                        <th data-width="80px" data-column-id="EMP_NAME">承接责任人</th>
                        </c:if>
                        <th data-width="80px" data-column-id="actual_percent" data-formatter="actualPercent">实际进度</th>
                        <th data-width="70px" data-column-id="plan_percent" data-formatter="isDelay">进度滞后</th>
                        <th data-width="80px" data-column-id="START_DATE">开始时间</th>
                        <th data-width="80px" data-column-id="END_DATE">结束时间</th>
                        <th data-width="60px" data-column-id="STATUS">状态</th>
                    </tr>
                    </thead>
                </table>
            </div>
        </div>
        <div id="con_one_23" class="tab-pane fade">
            <div class="table-responsive">
                <table id="task_grid_2" class="table table-striped table-bordered table-hover">
                    <thead>
                    <tr>
                        <th data-width="50px" data-column-id="ID" data-visible="false" data-formatter="id"
                            data-css-class="" data-sortable="true">ID
                        </th>
                        <th data-width="15%" data-column-id="NODE_NAME">节点名称</th>
                        <th data-width="70px" data-column-id="NODE_LEVEL">节点层级</th>
                        <th data-width="130px" data-column-id="OPERA_TIME">下发时间</th>
                        <th data-width="15%" data-column-id="OPERA_NODE">上一步节点</th>
                        <th data-width="100px" data-column-id="OPERA_REMARKS" data-formatter="operaRemarks">上一步操作</th>
                        <th data-width="15%" data-column-id="FLOW_NAME" data-formatter="flowName">流程名称</th>
                        <c:if test="${not empty pd.showDept }"><!-- 日清看板才显示 -->
                        <th data-width="10%" data-column-id="DEPT_NAME">承接部门</th>
                        <th data-width="100px" data-column-id="EMP_NAME">承接责任人</th>
                        </c:if>
                        <th data-width="80px" data-column-id="STATUS_NAME">任务状态</th>
                        <c:if test="${empty pd.showDept }">
                            <th data-width="200px" class="center" data-formatter="commandStr" data-sortable="false">操作
                            </th>
                        </c:if>
                    </tr>
                    </thead>
                </table>
            </div>
        </div>
        <div id="con_one_24" class="tab-pane fade">
            <div class="table-responsive">
                <table id="task_grid_3" class="table table-striped table-bordered table-hover">
                    <thead>
                    <tr>
                        <th data-width="50px" data-column-id="ID" data-visible="false" data-formatter="id"
                            data-css-class="" data-sortable="true">ID
                        </th>
                        <th data-width="15%" data-column-id="DATETIME">任务日期</th>
                        <th data-width="15%" data-column-id="DEPT_NAME">部门</th>
                        <th data-width="15%" data-column-id="GRADE_NAME">岗位</th>
                        <th data-width="15%" data-column-id="EMP_NAME">任务对象</th>
                        <th data-width="60px" data-column-id="STATUS">状态</th>
                        <th data-width="70px" class="center" data-formatter="commandStr" data-sortable="false">操作</th>
                    </tr>
                    </thead>
                </table>
            </div>
        </div>
        <div id="con_one_25" class="tab-pane fade">
            <div class="table-responsive">
                <table id="task_grid_4" class="table table-striped table-bordered table-hover">
                    <thead>
                    <tr>
                        <th data-width="50px" data-column-id="ID" data-visible="false" data-formatter="id"
                            data-css-class="" data-sortable="true">ID
                        </th>
                        <th data-width="10%" data-column-id="TASK_NAME">任务名称</th>
                        <th data-width="10%" data-column-id="COMPLETION">完成标准</th>
                        <th data-width="70px" data-column-id="CREATE_USER">创建人</th>
                        <th data-width="70px" data-column-id="NEED_CHECK" data-formatter="assess">需要评价</th>
                        <c:if test="${not empty pd.showDept }"><!-- 日清看板才显示 -->
                        <th data-width="10%" data-column-id="DEPT_NAME">部门</th>
                        <th data-width="80px" data-column-id="EMP_NAME">任务对象</th>
                        </c:if>
                        <th data-width="80px" data-column-id="START_TIME">开始时间</th>
                        <th data-width="80px" data-column-id="END_TIME">结束时间</th>
                        <th data-width="60px" data-column-id="statusName">状态</th>
                        <th data-width="70px" class="center" data-formatter="commandStr" data-sortable="false">操作</th>
                    </tr>
                    </thead>
                </table>
            </div>
        </div>
    </div>
</div>


<script type="text/javascript">
    $(function () {
        var path = window.location.href;
        var empId = path.split("=")[1];
        var empCode = "";
        var url = "<%=basePath%>queryBasicInfo.do?empId=" + empId;
        $.get(url, function (data) {
            var obj = eval('(' + data + ')');
            $("#EMP_CODE1").val(obj.EMP_CODE);
            $("#EMP_NAME1").val(obj.EMP_NAME);
            $("#DEPT_NAME1").val(obj.DEPT_NAME);
            $("#EMP_CODE2").val(obj.EMP_CODE);
            $("#EMP_NAME2").val(obj.EMP_NAME);
            $("#DEPT_NAME2").val(obj.DEPT_NAME);
            empCode = obj.EMP_CODE;
            //表格数据获取(tab1)
            $("#grid1").bootgrid({
                ajax: true,
                url: "queryTarget.do?empId=" + empId,
                navigation: 2,
            });
            //表格数据获取(tab2)
            $("#grid2").bootgrid({
                ajax: true,
                url: "weekTask.do?empCode=" + obj.EMP_CODE,
                navigation: 2,
                formatters: {
                    islate: function (column, row) {
                        if (row.actual_percent < row.plan_percent) {
                            return "是";
                        } else {
                            return "否";
                        }
                    },
                    actual: function (column, row) {
                        if (row.actual_percent > '100') {
                            return '<div class="progress progress-success progress-striped opacity" style="height: 20px; margin-bottom:0px"><div class="bar" style="width: 100%; line-height: 20px;"><span style="color:black">${row.actual_percent }%</span></div>';
                        } else {
                            return '<div class="progress progress-success progress-striped opacity" style="height: 20px; margin-bottom:0px"><div class="bar" style="width: ' + row.actual_percent + '%; line-height: 20px;"><span style="color:black">' + row.actual_percent + '%</span></div>';
                        }

                    }
                }
            });
            //tab3数据获取
            $.ajax({
                type: "POST",
                async: false,
                url: "<%=basePath%>queryPerInfo.do?empCode=" + empCode,
                success: function (data) {     //回调函数，result，返回值
                    var obj = eval('(' + data + ')');
                    var PERF_ID = obj.PERF_ID;
                    var SCORE = obj.SCORE;
                    var str = '<thead><tr><th style="width: 35%;">考核项</th><th style="width: 45%;">考核标准</th><th style="width: 10%;">分值</th><th style="width: 10%;">实际得分</th></tr></thead><tbody>';
                    $.ajax({
                        type: "POST",
                        async: false,
                        url: "<%=basePath%>queryPerDetail.do?empCode=" + empCode + "&PERF_ID=" + PERF_ID,
                        success: function (data2) {     //回调函数，result，返回值
                            var obj2 = eval('(' + data2 + ')');
                            $.each(obj2.kpiList, function (i, kpiList) {
                                str += '<tr><td>' + kpiList.KPI_NAME + '</td><td>' + kpiList.PREPARATION2 + '</td><td>' + kpiList.PREPARATION3 + '</td><td><input type="text" readonly name = "score" id = "score"  style = "width:40px;color:black"   value=' + kpiList.SCORE + '></td></tr>';
                            });

                        }
                    });
                    str += '<td colspan="3">合计：</td><td><input readonly type="text" id="totalScore" style = "width:40px" value=' + SCORE + '></td></tr></tbody>';
                    $("#tbl3").html(str);
                }
            });
            //tab4数据获取
            $.ajax({
                type: "POST",
                async: false,
                url: "<%=basePath%>queryRecord.do?empId=" + empId,
                success: function (data) {     //回调函数，result，返回值
                    var obj = eval('(' + data + ')');
                    $("#name").val(obj.NAME);
                    $("#birthday").val(obj.BIRTHDAY);
                    $("#gender").val(obj.GENDER);
                    $("#age").val(obj.AGE);
                    $("#address").val(obj.ADDRESS);
                    $("#phone").val(obj.PHONE);
                    $("#email").val(obj.EMAIL);
                    $("#major").val(obj.MAJOR);
                    $("#school").val(obj.SCHOOL);
                    $("#graduate_time").val(obj.GRADUATE_TIME);
                    $("#degree").val(obj.DEGREE);

                }
            });
            $("#grid4").bootgrid({
                ajax: true,
                url: "queryRecordExp.do?empId=" + empId,
                navigation: 2,
            });
            for (var i = 0; i < 5; i++) {
                findGrid(i, empCode);
            }
        });


    });

    function findGrid(i, empCode) {
        var loadType;
        if (i == 0) {
            var loadTaskUrl = "empDailyTask/listTaskForGrid.do?loadType=B";
            loadType = 'B';
        } else if (i == 1) {
            var loadTaskUrl = "empDailyTask/listTaskForGrid.do?loadType=C";
            loadType = 'C';
        } else if (i == 2) {
            var loadTaskUrl = "empDailyTask/listTaskForGrid.do?loadType=F";
            loadType = 'F';
        } else if (i == 3) {
            var loadTaskUrl = "empDailyTask/listTaskForGrid.do?loadType=D";
            loadType = 'D';
        } else if (i == 4) {
            var loadTaskUrl = "empDailyTask/listTaskForGrid.do?loadType=T";
            loadType = 'T';
        }
        loadTaskUrl += "&empCode=" + empCode;
        $("#task_grid_" + i).bootgrid({
            navigation: 2,
            ajax: true,
            url: loadTaskUrl,
            post: function () {
                return {uniqueId: (new Date()).getTime().toString()};
            },
            formatters: {
                id: function (column, row) {
                    return row.ID;
                },
                //目标数量
                weekCount: function (column, row) {
                    return row.WEEK_COUNT + " " + row.UNIT_NAME;
                },
                //实际进度
                actualPercent: function (column, row) {
                    var barWidth = row.actual_percent;//进度条宽度
                    var barStyle = 'success';//进度条样式
                    if (row.actual_percent > 100) {//实际进度大于100时，进度条宽度设为100，防止宽度超出
                        barWidth = 100;
                    } else if (row.actual_percent < row.plan_percent) {//实际进度小于计划进度，进度条样式改为‘警告’
                        barStyle = 'warning';
                    }
                    //返回进度条
                    return '<div class="progress" style="height:20px; margin:0px; background-color: #dadada; border: 1px solid #ccc;">' +
                        '<div class="progress-bar ' + barStyle + '" role="progressbar" aria-valuenow="60" aria-valuemin="0" ' +
                        'aria-valuemax="100" style="width: ' + barWidth + '%; text-align: center">' +
                        '<span style="color: black">' + row.actual_percent + '%</span></div></div>';
                },
                //进度滞后
                isDelay: function (column, row) {
                    if (row.actual_percent < row.plan_percent) {
                        return '<span style="color:red">是</span>';
                    } else {
                        return "否";
                    }
                },
                //是否评价-临时工作
                assess: function (columen, row) {
                    if (row.NEED_CHECK == '1') {
                        return '是';
                    } else if (row.NEED_CHECK == '0') {
                        return '否';
                    }
                },
                //流程节点操作
                operaRemarks: function (column, row) {
                    return row.OPERA_TYPE;
                },
                //流程名称-流程工作
                flowName: function (column, row) {
                    return '<a onclick="shwoFlowDetail(' + row.FLOW_ID + ')">' + row.FLOW_NAME + '</a>';
                }

            }
        });
    }
</script>

</body>
