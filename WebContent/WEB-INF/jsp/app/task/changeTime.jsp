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
    <meta charset="utf-8"/>

    <title>查看时间段</title>
    <meta name="description" content="overview & stats"/>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <link href="static/css/bootstrap.min.css" rel="stylesheet"/>
    <link href="static/css/bootstrap-responsive.min.css" rel="stylesheet"/>
    <link rel="stylesheet" href="static/css/font-awesome.min.css"/>

    <link rel="stylesheet" href="static/css/ace.min.css"/>
    <link rel="stylesheet" href="static/css/ace-responsive.min.css"/>
    <link rel="stylesheet" href="static/css/ace-skins.min.css"/>
    <link rel="stylesheet" href="plugins/bootstrap-datetimepicker/bootstrap-datetimepicker.min.css"/>

    <script type="text/javascript" src="static/js/jquery-1.7.2.js"></script>
    <script type="text/javascript" src="plugins/bootstrap-datetimepicker/bootstrap-datetimepicker.min.js"></script>
    <script type="text/javascript" src="plugins/bootstrap-datetimepicker/bootstrap-datetimepicker.zh-CN.js"></script>
    <!-- 引入 -->

    <link rel="stylesheet" href="static/css/app-style.css"/>

    <style>
        #zhongxin td {
            height: 35px;
        }

        #zhongxin td label {
            text-align: right;
        }

        body {
            background: #f4f4f4;
        }

        .keytask table tr td {
            line-height: 1.3
        }

        /*设置自适应框样式*/
        .test_box {
            width: 220px;
            min-height: 22px;
            _height: 120px;
            padding: 4px 6px;
            outline: 0;
            border: 1px solid #d5d5d5;
            font-size: 12px;
            word-wrap: break-word;
            overflow-x: hidden;
            overflow-y: auto;
            _overflow-y: visible;
        }
    </style>

    <!-- 引入 -->
    <script type="text/javascript" src="static/js/jquery-1.7.2.js"></script>
    <script src="static/js/bootstrap.min.js"></script>
    <script src="static/js/ace-elements.min.js"></script>
    <script src="static/js/ace.min.js"></script>
    <script type="text/javascript" src="static/js/chosen.jquery.min.js"></script>
    <script type="text/javascript" src="static/js/jquery-form.js"></script>
    <!--提示框-->
    <script type="text/javascript" src="static/js/jquery.tips.js"></script>
    <script type="text/javascript">
        if ("ontouchend" in document) document.write("<script src='static/js/jquery.mobile.custom.min.js'>" + "<" + "/script>");
    </script>

    <!-- 预加载js -->
    <script type="text/javascript">
        $(function () {
            if ('${taskStatus}' == 'YW_CG') {
                //时间框
                //initDateInput();
            }

        });

        //复选框
        $('#timeTable th input:checkbox').on('click', function () {
            var that = this;
            $(this).closest('table').find('tr > td:first-child input:checkbox').not(':disabled')
                .each(function () {
                    this.checked = that.checked;
                    $(this).closest('tr').toggleClass('selected');
                });
        });
    </script>
    <!-- 预加载js -->

    <!-- 行为js -->
    <script type="text/javascript">
        //初始化时间框
        function initDateInput() {
            $("input[name='start_time']").each(function () {
                $(this).datetimepicker({
                    language: 'zh-CN',
                    format: 'hh:ii',
                    startDate: '${Date} 00:00:00',
                    endDate: '${Date} 23:59:59',
                    autoclose: 1,
                    startView: 1,
                    minView: 0,
                    maxView: 1,
                    forceParse: 0
                });
            });
            $("input[name='end_time']").each(function () {
                $(this).datetimepicker({
                    language: 'zh-CN',
                    format: 'hh:ii',
                    startDate: '${Date} 00:00:00',
                    endDate: '${Date} 23:59:59',
                    autoclose: 1,
                    startView: 1,
                    minView: 0,
                    maxView: 1,
                    forceParse: 0
                });
            });
        }

        //每当时间修改时
        function changeTime() {
            timeArr();
        }

        //将所有时间归纳成一个数组
        function timeArr() {
            var START_TIME_ARR = [];
            var END_TIME_ARR = [];
            $("input[name='start_time']").each(function () {
                START_TIME_ARR.push($(this).val());
            });
            $("input[name='end_time']").each(function () {
                END_TIME_ARR.push($(this).val());
            });
            $("#START_TIME_ARR").val(START_TIME_ARR.toString().replace(',', ';'));
            $("#END_TIME_ARR").val(END_TIME_ARR.toString().replace(',', ';'));
        }
    </script>

</head>
<body>
<div class="web_title">
    <div class="back" style="top:5px">
        <a href="<%=basePath%>app_task/empDailyTaskInfo.do?manageId=${pd.manageId}&startDate=${pd.startDate}&endDate=${pd.endDate }&productCode=${pd.productCode }&projectCode=${pd.projectCode }&flowName=${pd.flowName }&tempTaskName=${pd.tempTaskName }&show=${pd.show }&showDept=${pd.showDept }&loadType=${pd.loadType }&deptCode=${pd.deptCode }&empCode=${pd.empCode }&currentPage=${pd.currentPage }">
            <img src="static/app/images/left.png"/></a>
    </div>
    日清批示
</div>
<form action="<%=basePath%>app_task/saveImportComment.do" name="Form" id="Form" method="post">
    <input type="hidden" name="eventId" value="${pd.projectEventId }">
    <input type="hidden" id="START_TIME_ARR"/>
    <input type="hidden" id="END_TIME_ARR"/>
    <div id="zhongxin" style="width:98%; margin:0 auto; ">
        <table class="table table-striped table-bordered table-hover" id="timeTable">
            <thead>
            <tr>
                <!--
                <th class="center">
                    <label><input type="checkbox" id="zcheckbox" /><span class="lbl"></span></label>
                </th>
                 -->
                <th>开始时间</th>
                <th>结束时间</th>
            </tr>
            </thead>
            <tbody>
            <c:forEach items="${timeList}" var="time" varStatus="vs">
                <tr>
                    <td>
                        <input type="text" name="start_time" style="width:50%;background:#fff!important;"
                               value="${time.start_time}" onchange="changeTime()"
                               class="date-picker" data-date-format="hh:ii" placeholder="请输入时间！" readonly="readonly"/>
                    </td>
                    <td>
                        <input type="text" name="end_time" style="width:50%;background:#fff!important;"
                               value="${time.end_time}" onchange="changeTime()"
                               class="date-picker" data-date-format="hh:ii" placeholder="请输入时间！" readonly="readonly"/>
                    </td>
                </tr>
            </c:forEach>
            </tbody>
        </table>
    </div>
    <div id="zhongxin2" class="center" style="display:none"><br/><br/><br/><br/><br/><img
            src="static/images/jiazai.gif"/><br/><h4 class="lighter block green">提交中...</h4></div>

    <div>
        <%@include file="../footer.jsp" %>
    </div>

</form>
</body>
</html>