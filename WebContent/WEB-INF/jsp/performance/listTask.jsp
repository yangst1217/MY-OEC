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
    <base href="<%=basePath%>">

    <link type="text/css" rel="StyleSheet" href="plugins/Bootstrap/css/bootstrap.min.css"/>
    <link type="text/css" rel="StyleSheet" href="plugins/Bootgrid/jquery.bootgrid.min.css"/>
    <link type="text/css" rel="StyleSheet" href="static/css/style.css"/>
    <link rel="stylesheet" href="static/css/font-awesome.min.css"/>
    <link rel="stylesheet" href="static/css/datepicker.css"/>
    <link rel="stylesheet" href="static/css/bootgrid.change.css"/>

    <style>

        td, th {
            font-size: 12px;
            color: #585858;
        }

        th {
            background: #f7f8fa;
        }

        .modal-backdrop {
            z-index: 99;
        }

        input[type=checkbox] {
            opacity: 1;
            position: inherit;
        }

        #myTab {
            margin-bottom: 0;
        }

        #myTab li {
            background: #98c0d9;
            margin: 0;
            border: 2px solid #98c0d9;
        }

        #myTab > li.active {
            border: 2px solid #448fb9;
        }

        #myTab li.active a {
            margin: 0;
            box-shadow: none !important;
            background: #448fb9;
            border: 0
        }

        #myTab li.active a:hover {
            background: #448fb9;
        }

        #myTab li a {
            color: #fff;
            padding: 12px 25px;
            line-height: 16px;
        }

        #myTab li a:hover {
            color: #fff;
            background: #98c0d9;
        }

        .tab-content {
            padding: 0;
            border: 0;
        }

        .employee_top {
            border-bottom: 2px solid #98c0d9;
            height: 40px;
            line-height: 40px;
            margin-bottom: 15px;
        }

        .employee_title {
            float: left;
            margin-left: 20px;
            border-bottom: 3px solid #448fb9;
            height: 38px;
            font-size: 18px;
            color: #448fb9;
        }

        .employee_search {
            float: right;
        }

        .progress:after {
            line-height: 20px !important;
        }

        .bootgrid-header {
            height: 30px;
            margin: 5px 10px;
        }

        .bootgrid-footer {
            height: 30px;
        }

        .success {
            background-color: #55b83b
        }

        .warning {
            background-color: #d20b44
        }

        .b {
            color: red
        }

        .bootgrid-table th > .column-header-anchor > .text {
            margin: 0px;
        }

        .btn {
            margin-right: 2px;
        }
    </style>
    <!-- 引入 -->
    <script type="text/javascript" src="plugins/JQuery/jquery.min.js"></script>
    <script type="text/javascript" src="plugins/Bootstrap/js/bootstrap.min.js"></script>
    <script type="text/javascript" src="plugins/Bootgrid/jquery.bootgrid.min.js"></script>

    <script src="static/js/ace-elements.min.js"></script>
    <script src="static/js/ace.min.js"></script>
    <script type="text/javascript" src="static/js/chosen.jquery.min.js"></script><!-- 下拉框 -->
    <script type="text/javascript" src="static/js/bootstrap-datepicker.min.js"></script>
    <!-- 引入 -->

    <script type="text/javascript">
        //页面初始化
        $(function () {
            top.changeui();
            //单选框
            $(".chzn-select").chosen();
            $(".chzn-select-deselect").chosen({allow_single_deselect: true});
            //日期框
            $('.date-picker').datepicker({
                autoclose: true
            });
            var errorMsg = "${errorMsg}";
            if (errorMsg != "") {
                top.Dialog.alert(errorMsg);
            }
            //加载任务
            loadTask('${pd.loadType}');
            getdate();
        })

        //修改tab页样式
        function setTabStyle(loadType) {
            $("#loadType").attr("value", loadType);

            $("#nav-search").css('width', '0px');
            $("#addTaskBtn").css('display', 'none');

            //$(".gridDiv").hide();//隐藏所有列表
            //$("#gridDiv_"+loadType).show();//重新显示加载的类型
            //var tabList = $("#myTab").children();
            $("#myTab li a").each(function () {
                //alert("loadType=" + loadType + "," + $(this).attr("name") + "," + (loadType== $(this).attr("name")))
                if (loadType == $(this).attr("name")) {
                    $(this).parent().addClass("active");
                } else {
                    $(this).parent().removeClass("active");
                }
            });
            $("#myTabContent > .active").removeClass("active in");
            $("#" + loadType + "Task").addClass("active in");
        }

        //加载任务列表
        function loadTask(loadType) {
            //修改tab页样式
            setTabStyle(loadType);
            //初始化任务表格
            $("#task_grid_" + loadType).bootgrid({
                ajax: true,
                url: "performance/listTaskForGrid.do?empCode=${pd.empCode}&MONTH=${pd.MONTH}&loadType=" + loadType,
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
                    //流程名称-流程工作
                    flowName: function (column, row) {
                        return '<a onclick="">' + row.FLOW_NAME + '</a>';
                    }
                }
            });
        }

        //查询部门员工
        function findEmp() {
            var deptId = "${pd.deptIdStr}";
            var deptVal = $("#deptCode").val();
            if (deptVal != "") {
                deptId = $("#deptCode").find("option:selected").attr("deptId");
            }
            //top.Dialog.alert("deptId=" + deptId + ", deptVal=" + deptVal);

            var path = "<%=basePath%>performance/findDeptEmp.do?deptId=" + deptId;
            $.ajax({
                type: "POST",
                url: path,
                async: false,
                success: function (data) {
                    if (data == 'error') {
                        top.Dialog.alert("获取部门数据出错");
                    }
                    var obj = eval('(' + data + ')');
                    //更新员工
                    $("#empCode").empty();
                    $("#empCode").append('<option value="">全部</option>');
                    $.each(obj, function (i, emp) {
                        $("#empCode").append('<option value="' + emp.EMP_CODE + '">' + emp.EMP_NAME + '</option>');
                    });
                }
            });
        }

        //查询
        function searchTask() {
            var startDate = $("#startDate").val();
            var endDate = $("#endDate").val();
            var productName = $("#productName").val();
            var projectName = $("#projectName").val();
            var loadType = $("#loadType").val();
            $("#task_grid_" + loadType).bootgrid("search",
                {
                    "startDate": startDate, "endDate": endDate, "productName": productName,
                    "projectName": projectName
                });
        }

        //查询-重置
        function resetting() {
            $("#Form")[0].reset();
        }

        //跳转到日清,type=1:周工作,type=2:创新活动,type=3:行政;show=1:查看,show=2:日清,show=3:日清批示
        function showDailyTask(id, type, show) {
            var url = "<%=basePath%>empDailyTask/";
            var param = "&show=" + show + "&showDept=${pd.showDept}&currentPage=${page.currentPage}&showCount=${page.showCount}" +
                "&deptCode=${pd.deptCode}&empCode=${pd.empCode}&productCode=${pd.productCode}&projectCode=${pd.projectCode}" +
                "&startDate=${pd.startDate}&endDate=${pd.endDate}&status=${pd.status}&parentPage=gridTask&loadType=" + $("#loadType").val();
            if (type == 1) {//周工作
                url += "listBusinessEmpTask.do?weekEmpTaskId=" + id + param;
            } else if (type == 2) {//创新活动
                url += "listCreativeEmpTask.do?eventId=" + id + param;
            } else if (type == 3) {//行政活动
                url += "listManageEmpTask.do?manageId=" + id + param;
            } else {
                top.Dialog.alert("未知的任务类型，无法查看");
                return;
            }
            window.location.href = url;
        }

        function savePerf(PERF_ID, MONTH, EMP_CODE) {

            var score = "";
            $(document).find("[name = 'score']").each(function () {
                if ($(this).val() == null || $(this).val() == "") {
                    $(this).val(0);
                }
                score = score + $(this).val() + ",";
            });

            var pdId = "";
            $(document).find("[name = 'pdId']").each(function () {
                if ($(this).val() == null || $(this).val() == "") {
                    $(this).val(0);
                }
                pdId = pdId + $(this).val() + ",";
            });

            var lId = "";
            $(document).find("[name = 'lId']").each(function () {
                if ($(this).val() == null || $(this).val() == "") {
                    $(this).val(0);
                }
                lId = lId + $(this).val() + ",";
            });


            totalScore = $("#totalScore").val();
            var url = "<%=basePath%>/performance/savePerf.do?SCORE=" + score + "&PDID=" + pdId + "&LID=" + lId + "&PERF_ID=" + PERF_ID + "&MONTH=" + MONTH + "&EMP_CODE=" + EMP_CODE + "&totalScore=" + totalScore;

            $.get(url, function (data) {
                if (data == "success") {
                    top.Dialog.alert("保存成功！");
                    location.replace("<%=basePath%>/performance/list.do");
                } else {
                    top.Dialog.alert("保存失败！");
                }
            }, "text");
        }


        $("#score").keyup(function () {
            var c = $(this);
            if (/[^\d]/.test(c.val())) {//替换非数字字符
                var temp_amount = c.val().replace(/[^\d]/g, '');
                $(this).val(temp_amount);
            }
        })

        function control(e, o, score) {
            var v = o.value | 0;
            if (v <= 0) {
                o.value = '';
                o.focus();
            } else if (v > score) {
                top.Dialog.alert("实际得分不能大于预设分值！");
                o.value = '';
                o.focus()
            }
        };

        function getdate() {
            var list = $(document).find("[name = 'score']");
            var count = 0;
            $(document).find("[name = 'score']").each(function () {
                if ($(this).val() == null || $(this).val() == "") {
                    $(this).val(0);
                }
                count = parseInt(count) + parseInt($(this).val());
            });
            $("#totalScore").val(count);
        }

        function goback() {
            window.location.href = "<%=basePath%>/performance/list.do";
        }

    </script>

</head>
<body>
<div class="container-fluid" id="main-container" style="height:1px; padding:0px">
    <div class="page-content">
        <div class="row" style="margin-right:0px">
            <div class="col-xs-12">
                <!-- PAGE CONTENT BEGINS -->

                <div class="row" style="margin-right:0px">
                    <div class="col-xs-12" style="margin-left:10px">
                        <div class="employee_top">
                            <div class="employee_title">
                                绩效管理
                            </div>
                            <div style="text-align: right;margin-right: 40px;">
                                <a class="btn btn-small btn-primary" onclick="goback()">返回 </a>
                            </div>

                            <div id="cleaner"></div>
                        </div>
                        <!-- tab页 -->
                        <ul id="myTab" class="nav nav-tabs">
                            <li class="active"><a id="tab_B" name="B" onclick="loadTask('B')" href="#BTask"
                                                  data-toggle="tab">目标工作</a></li>
                            <li><a id="tab_C" name="C" onclick="loadTask('C')" href="#CTask"
                                   data-toggle="tab">重点协同工作</a></li>
                            <li><a id="tab_F" name="F" onclick="loadTask('F')" href="#FTask" data-toggle="tab">流程工作</a>
                            </li>
                            <li><a id="tab_D" name="D" onclick="loadTask('D')" href="#DTask" data-toggle="tab">日常工作</a>
                            </li>
                            <li><a id="tab_T" name="T" onclick="loadTask('T')" href="#TTask" data-toggle="tab">临时工作</a>
                            </li>
                            <input type="hidden" id="loadType" value="${pd.loadType }"/>
                        </ul>
                        <div class="nav-search" id="nav-search"
                             style="width:100px; float: right; margin-right: 100px; margin-top: -40px;">
                            <div class="panel panel-default" style="position: absolute;">
                                <div style="margin-top: 3px;">
                                    <a data-toggle="collapse" data-parent="#accordion" href="#collapseTwo"
                                       class="btn btn-small btn-primary"
                                       style="text-decoration:none; float：right; height:32px; line-height:25px">
                                        高级搜索 </a>
                                </div>
                                <div id="collapseTwo" class="panel-collapse collapse"
                                     style="position:absolute; top:32px; z-index:999; right: -25px;">
                                    <div class="panel-body">
                                        <form id="Form">
                                            <table style="width:95%">
                                                <c:if test="${not empty pd.showDept}">
                                                    <!-- 日清看板搜索项 -->
                                                    <input type="hidden" value="${pd.queryId }" id="queryId"
                                                           name="queryId"/>
                                                    <tr>
                                                        <td style="width:100px"><label>所在部门：</label></td>
                                                        <td style="height:40px;">
                                                            <select id="deptCode" name="deptCode" onchange="findEmp()"
                                                                    style="width: 90%;">
                                                                <option value="">全部</option>
                                                                <c:forEach items="${deptList }" var="dept">
                                                                    <option value="${dept.DEPT_CODE }"
                                                                            deptId="${dept.ID }"
                                                                            <c:if test="${dept.DEPT_CODE == pd.deptCode }">selected</c:if> >${dept.DEPT_NAME }</option>
                                                                </c:forEach>
                                                            </select>
                                                        </td>
                                                        <td style="width:100px"><label>任务对象：</label></td>
                                                        <td><select name="empCode" id="empCode" data-placeholder="请选择"
                                                                    style="width: 90%; vertical-align:top;">
                                                            <option value="">全部</option>
                                                            <c:forEach items="${empList}" var="emp">
                                                                <option id="emp_${emp.EMP_DEPARTMENT_ID }"
                                                                        deptId="${emp.EMP_DEPARTMENT_ID }"
                                                                        value="${emp.EMP_CODE}"
                                                                        <c:if test="${emp.EMP_CODE == pd.empCode }">selected</c:if>>${emp.EMP_NAME}</option>
                                                            </c:forEach>
                                                        </select>
                                                        </td>
                                                    </tr>
                                                </c:if>
                                                <tr>
                                                    <td style="width:100px"><label>开始时间：</label></td>
                                                    <td>
                                                        <input type="text" id="startDate" name="startDate"
                                                               value="${pd.startDate}" placeholder="请输入时间"
                                                               class="span2 date-picker" data-date-format="yyyy-mm-dd"
                                                               style=" background: none;color: #000;"/>
                                                    </td>
                                                    <td style="width:100px"><label>结束时间：</label></td>
                                                    <td>
                                                        <input type="text" id="endDate" name="endDate"
                                                               value="${pd.endDate}" placeholder="请输入时间"
                                                               class="span2 date-picker" data-date-format="yyyy-mm-dd"
                                                               style="background: none;color: #000;"/>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td style="width:100px"><label>产品：</label></td>
                                                    <td style="height:40px;"><input id="productName" name="productName"
                                                                                    value="${pd.productName }"/></td>
                                                    <td style="width:100px"><label>项目：</label></td>
                                                    <td><input id="projectName" name="projectName"
                                                               value="${pd.projectName }"/></td>
                                                </tr>
                                            </table>

                                            <div style="margin-top:15px; margin-right:30px; text-align:right;">
                                                <a class="btn-style1" onclick="searchTask();" style="cursor: pointer;"
                                                   data-toggle="collapse" data-parent="#accordion" href="#collapseTwo">查询</a>
                                                <a class="btn-style2" onclick="resetting()"
                                                   style="cursor: pointer;">重置</a>
                                                <a data-toggle="collapse" data-parent="#accordion" class="btn-style3"
                                                   href="#collapseTwo">关闭</a>
                                            </div>
                                        </form>
                                    </div>
                                </div><!-- collapseTwo end -->
                            </div>
                        </div><!-- nav-search end -->

                        <div id="myTabContent" class="tab-content" style="overflow:inherit;">
                            <!-- 目标工作 -->
                            <div class="tab-pane fade in active" id="BTask">
                                <div class="table-responsive">
                                    <table id="task_grid_B" class="table table-striped table-bordered table-hover">
                                        <thead>
                                        <tr>
                                            <th data-width="50px" data-column-id="ID" data-visible="false"
                                                data-formatter="id" data-css-class="aa" data-sortable="true">ID
                                            </th>
                                            <th data-width="80px" data-column-id="WEEK_START_DATE"
                                                data-formatter="startDate">开始时间
                                            </th>
                                            <th data-width="80px" data-column-id="WEEK_END_DATE"
                                                data-formatter="endDate">结束时间
                                            </th>
                                            <th data-width="15%" data-column-id="TARGET_NAME"
                                                data-formatter="targetName">年度目标
                                            </th>
                                            <th data-width="12%" data-column-id="INDEX_NAME" data-formatter="indexName">
                                                经营指标
                                            </th>
                                            <th data-width="12%" data-column-id="PRODUCT_NAME"
                                                data-formatter="productName">产品名称
                                            </th>
                                            <th data-width="80px" data-column-id="WEEK_COUNT"
                                                data-formatter="weekCount">目标数量
                                            </th>
                                            <!-- <th data-width="40px" data-column-id="">单位</th> -->
                                            <th data-width="10%" data-column-id="DEPT_NAME" data-formatter="deptName">
                                                承接部门
                                            </th>
                                            <th data-width="80px" data-column-id="EMP_NAME">承接人</th>
                                            <th data-width="80px" data-column-id="actual_percent"
                                                data-formatter="actualPercent">实际进度
                                            </th>
                                            <th data-width="80px" data-column-id="plan_percent"
                                                data-formatter="isDelay">进度滞后
                                            </th>
                                            <th data-width="60px" data-column-id="STATUS">状态</th>
                                        </tr>
                                        </thead>
                                    </table>
                                </div>
                            </div>
                            <!-- 协同工作 -->
                            <div class="tab-pane fade" id="CTask">
                                <div class="table-responsive">
                                    <table id="task_grid_C" class="table table-striped table-bordered table-hover">
                                        <thead>
                                        <tr>
                                            <th data-width="50px" data-column-id="ID" data-visible="false"
                                                data-formatter="id" data-css-class="" data-sortable="true">ID
                                            </th>
                                            <th data-width="80px" data-column-id="START_DATE"
                                                data-formatter="startDate">开始时间
                                            </th>
                                            <th data-width="80px" data-column-id="END_DATE" data-formatter="endDate">
                                                结束时间
                                            </th>
                                            <th data-width="14%" data-column-id="EVENT_NAME" data-formatter="eventName">
                                                活动名称
                                            </th>
                                            <th data-width="8%" data-column-id="preTaskName"
                                                data-formatter="preTaskName">前置活动
                                            </th>
                                            <th data-width="8%" data-column-id="NODE_TARGET"
                                                data-formatter="nodeTarget">节点名称
                                            </th>
                                            <th data-width="10%" data-column-id="PROJECT_NAME"
                                                data-formatter="projectName">项目名称
                                            </th>
                                            <th data-width="80px" data-column-id="PROJECT_TYPE">项目类型</th>
                                            <th data-width="50px" data-column-id="WEIGHT">权重</th>
                                            <th data-width="10%" data-column-id="DEPT_NAME" data-formatter="deptName">
                                                承接部门
                                            </th>
                                            <th data-width="80px" data-column-id="EMP_NAME">承接人</th>
                                            <th data-width="80px" data-column-id="actual_percent"
                                                data-formatter="actualPercent">实际进度
                                            </th>
                                            <th data-width="70px" data-column-id="plan_percent"
                                                data-formatter="isDelay">进度滞后
                                            </th>
                                            <th data-width="60px" data-column-id="STATUS">状态</th>
                                        </tr>
                                        </thead>
                                    </table>
                                </div>
                            </div>
                            <!-- 流程工作 -->
                            <div class="tab-pane fade" id="FTask">
                                <div class="table-responsive">
                                    <table id="task_grid_F" class="table table-striped table-bordered table-hover">
                                        <thead>
                                        <tr>
                                            <th data-width="50px" data-column-id="ID" data-visible="false"
                                                data-formatter="id" data-css-class="" data-sortable="true">ID
                                            </th>
                                            <th data-width="130px" data-column-id="OPERA_TIME"
                                                data-formatter="startDate">下发时间
                                            </th>
                                            <th data-width="15%" data-column-id="FLOW_NAME" data-formatter="flowName">
                                                流程名称
                                            </th>
                                            <th data-width="15%" data-column-id="NODE_NAME" data-formatter="nodeName">
                                                节点名称
                                            </th>
                                            <th data-width="70px" data-column-id="NODE_LEVEL">节点层级</th>
                                            <th data-width="15%" data-column-id="OPERA_NODE" data-formatter="operaNode">
                                                上一步节点
                                            </th>
                                            <th data-width="100px" data-column-id="OPERA_REMARKS"
                                                data-formatter="operaRemarks">上一步操作
                                            </th>
                                            <th data-width="10%" data-column-id="DEPT_NAME">承接部门</th>
                                            <th data-width="100px" data-column-id="EMP_NAME">承接人</th>
                                            <th data-width="80px" data-column-id="STATUS_NAME">任务状态</th>
                                        </tr>
                                        </thead>
                                    </table>
                                </div>
                            </div>
                            <!-- 日常工作 -->
                            <div class="tab-pane fade" id="DTask">
                                <div class="table-responsive">
                                    <table id="task_grid_D" class="table table-striped table-bordered table-hover">
                                        <thead>
                                        <tr>
                                            <th data-width="50px" data-column-id="ID" data-visible="false"
                                                data-formatter="id" data-css-class="" data-sortable="true">ID
                                            </th>
                                            <th data-width="15%" data-column-id="DATETIME" data-formatter="startDate">
                                                任务日期
                                            </th>
                                            <th data-width="15%" data-column-id="DEPT_NAME">部门</th>
                                            <th data-width="15%" data-column-id="GRADE_NAME">岗位</th>
                                            <th data-width="15%" data-column-id="EMP_NAME">承接人</th>
                                            <th data-width="60px" data-column-id="STATUS">状态</th>
                                        </tr>
                                        </thead>
                                    </table>
                                </div>
                            </div>
                            <!-- 临时工作 -->
                            <div class="tab-pane fade" id="TTask">
                                <div class="table-responsive">
                                    <table id="task_grid_T" class="table table-striped table-bordered table-hover">
                                        <thead>
                                        <tr>
                                            <th data-width="50px" data-column-id="ID" data-visible="false"
                                                data-formatter="id" data-css-class="" data-sortable="true">ID
                                            </th>
                                            <th data-width="80px" data-column-id="START_TIME"
                                                data-formatter="startDate">开始时间
                                            </th>
                                            <th data-width="80px" data-column-id="END_TIME" data-formatter="endDate">
                                                结束时间
                                            </th>
                                            <th data-width="15%" data-column-id="TASK_NAME" data-formatter="taskName">
                                                任务名称
                                            </th>
                                            <th data-width="15%" data-column-id="COMPLETION"
                                                data-formatter="completion">完成标准
                                            </th>
                                            <th data-width="70px" data-column-id="CREATE_USER">创建人</th>
                                            <th data-width="70px" data-column-id="NEED_CHECK" data-formatter="assess">
                                                需要评价
                                            </th>
                                            <th data-width="10%" data-column-id="DEPT_NAME" data-formatter="deptName">
                                                承接部门
                                            </th>
                                            <th data-width="80px" data-column-id="EMP_NAME">承接人</th>
                                            <th data-width="60px" data-column-id="statusName">状态</th>
                                        </tr>
                                        </thead>
                                    </table>
                                </div>
                            </div>

                        </div><!-- /myTabContent -->

                        <div id="perfom" class="tab-content">
                            <table class="table table-striped table-bordered table-hover">
                                <thead>
                                <tr>
                                    <th style="width: 5%;">序号</th>
                                    <th style="width: 30%;">考核项</th>
                                    <th style="width: 35%;">考核标准</th>
                                    <th style="width: 10%;">百分比</th>
                                    <th style="width: 10%;">分值</th>
                                    <th style="width: 10%;">实际得分</th>
                                </tr>
                                </thead>
                                <tbody>
                                <c:choose>
                                    <c:when test="${not empty kpiList}">
                                        <c:forEach items="${kpiList}" var="kpiList" varStatus="vs">
                                            <tr>
                                                <td class='center' style="width: 30px;">${vs.index+1}</td>
                                                <td style="display: none;">${kpiList.ID }</td>
                                                <td>${kpiList.KPI_NAME }</td>
                                                <td>${kpiList.PREPARATION2 }</td>
                                                <td><fmt:formatNumber type="percent" value="${kpiList.PERCENT }"/></td>
                                                <td>${kpiList.PREPARATION3 }</td>
                                                <td>
                                                    <c:choose>
                                                        <c:when test="${kpiList.sqlFlg == '1' }">
                                                            <input type="text" name="score" id="score"
                                                                   style="width:40px;color:black"
                                                                   onkeyup="control(event,this,${kpiList.PREPARATION3})"
                                                                   onblur="getdate();" value="${kpiList.SCORE }"
                                                                   <c:if test="${flg != 1}">readonly</c:if>>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <input type="text" name="score" id="score"
                                                                   style="width:40px;color:black"
                                                                   onkeyup="control(event,this)" onblur="getdate();"
                                                                   value="${kpiList.SCORE }" readonly>
                                                        </c:otherwise>
                                                    </c:choose>
                                                    <input type="hidden" name="pdId" id="pdId" value=${kpiList.PD_ID }>
                                                    <input type="hidden" name="lId" id="lId" value=${kpiList.LID }>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                        <tr>
                                            <td colspan="5">合计：</td>
                                            <td>
                                                <input readonly type="text" id="totalScore" style="width:40px"
                                                       value="${pd.SCORE }"/>
                                            </td>
                                        </tr>
                                    </c:when>
                                    <c:otherwise>
                                        <tr class="main_info">
                                            <td colspan="100" class="center">没有相关数据</td>
                                        </tr>
                                    </c:otherwise>
                                </c:choose>
                                </tbody>
                            </table>
                            <c:if test="${flg == 1}">
                                <c:if test="${pd.SELF != 1}">
                                    <div style="text-align: right;margin-right: 40px;">
                                        <a class="btn btn-small btn-primary"
                                           onclick="savePerf('${pd.PERF_ID }','${pd.MONTH }','${pd.EMP_CODE }')">保存 </a>
                                    </div>
                                </c:if>
                            </c:if>
                        </div>

                    </div><!-- /span -->
                </div><!-- /row -->
            </div>
        </div>
    </div>
</div>

<!-- 返回顶部  -->
<a href="#" id="btn-scroll-up" class="btn btn-small btn-inverse">
    <i class="icon-double-angle-up icon-only"></i>
</a>

</body>
</html>
