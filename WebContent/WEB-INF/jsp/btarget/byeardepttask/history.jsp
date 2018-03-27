<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<%
    String path = request.getContextPath();
    String basePath = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort() + path + "/";
%>
<!DOCTYPE html>
<html>
<head>
    <title>分解历史</title>
    <base href="<%=basePath%>">
    <!-- jsp文件头和头部 -->
    <%@ include file="../../system/admin/top.jsp" %>
    <link href="static/css/style.css" rel="stylesheet"/>

    <!-- 引入 -->
    <script type="text/javascript">window.jQuery || document.write("<script src='static/js/jquery-1.9.1.min.js'>\x3C/script>");</script>
    <script src="static/js/bootstrap.min.js"></script>
    <script src="static/js/ace-elements.min.js"></script>
    <script src="static/js/ace.min.js"></script>

    <script type="text/javascript" src="static/js/chosen.jquery.min.js"></script><!-- 下拉框 -->
    <script type="text/javascript" src="static/js/bootstrap-datepicker.min.js"></script><!-- 日期框 -->
    <script type="text/javascript" src="static/js/bootbox.min.js"></script><!-- 确认窗口 -->
    <script type="text/javascript" src="static/js/jquery.tips.js"></script><!--提示框-->
    <!-- 引入 -->

    <style>
        #target_table textarea {
            margin-top: 7px;
        }

        #target_table input {
            margin-top: 7px;
        }

        #zhongxin table tbody td {
            text-align: center;
            vertical-align: middle;
        }

        #zhongxin table thead th {
            text-align: center;
            vertical-align: middle;
        }

        .label_left {
            width: 200px;
            text-align: left;
        }

        .label_right {
            width: 180px;
            text-align: right;
        }
    </style>
</head>
<body>
<input type="hidden" value="${PARENT_FRAME_ID}" name="PARENT_FRAME_ID" id="PARENT_FRAME_ID">
<div class="tabbable tabs-below">
    <ul class="nav nav-tabs" id="menuStatus">
        <li>
            <img src="static/images/ui1.png" style="margin-top:-3px;">
            任务到月分解
        </li>

        <div class="nav-search" id="nav-search"
             style="right:5px;" class="form-search">

            <div style="float:left;" class="panel panel-default">
                <div>
                    <a class="btn btn-mini btn-danger" onclick="goBack();"
                       style="float:left;margin-right:5px;">关闭</a>
                </div>
            </div>
        </div>
    </ul>
</div>
<div id="zhongxin">
    <!-- 基础信息开始-->
    <table style="width:100%; max-width: 1000px; min-width: 700px;" id="target_table"><br>
        <tr>
            <td>
                <label style="text-align:right"><span style="color: red; ">*</span>目标：</label>
            </td>
            <td colspan="3">
                <label style="text-align:left">${task.NAME}</label>
            </td>
        </tr>
        <tr>
            <td>
                <label style="text-align:right"><span style="color: red; ">*</span>年度：</label>
            </td>
            <td>
                <label style="text-align:left">${task.YEAR_NUM}</label>
            </td>
            <td>
                <label style="text-align:right"><span style="color: red; ">*</span>开始时间：</label>
            </td>
            <td>
                <label style="text-align:left">${task.START_DATE}</label>
            </td>
            <td>
                <label style="text-align:right"><span style="color: red; ">*</span>结束时间：</label>
            </td>
            <td>
                <labelstyle
                ="text-align:left">${task.END_DATE}</label>
            </td>
        </tr>
        <tr>
            <td>
                <label style="text-align:right"><span style="color: red; ">*</span>产品：</label>
            </td>
            <td>
                <label style="text-align:left">${task.PRODUCT_NAME}</label>
            </td>
            <td>
                <label style="text-align:right"><span style="color: red; ">*</span>经营指标：</label>
            </td>
            <td>
                <label style="text-align:left">${task.INDEX_NAME}</label>
            </td>
            <td>
                <label style="text-align:right"><span style="color: red; ">*</span>目标数量/金额：</label>
            </td>
            <td>
                <label style="text-align:left">${task.COUNT}</label>
            </td>
        </tr>
        <tr>
            <td>
                <label style="text-align:right"><span style="color: red; ">*</span>承接部门：</label>
            </td>
            <td>
                <label style="text-align:left">${task.DEPT_NAME}</label>
            </td>
        </tr>
    </table>
    <!-- 基础信息结束-->
    <hr style="height:1px;border:none;border-top:1px solid grey;margin: 6px 0;"/>
    <div class="row">
        <div class="span12" style="text-align: center">
            <h4>分解历史</h4>
        </div>
        <c:forEach items="${hisList}" var="his" varStatus="ss">
            <div class="span11" style="text-align: right">
                <h6>${his.USER_NAME } <fmt:formatDate value="${his.UPDATE_TIME}" type="both"/></h6>
            </div>
            <div class="span12">
                <!--分解表格-->
                <table id="explain_table" class="table table-striped table-bordered table-hover"
                       style="table-layout:fixed;"><br>
                    <thead>
                    <th></th>
                    <th>1月</th>
                    <th>2月</th>
                    <th>3月</th>
                    <th>4月</th>
                    <th>5月</th>
                    <th>6月</th>
                    <th>7月</th>
                    <th>8月</th>
                    <th>9月</th>
                    <th>10月</th>
                    <th>11月</th>
                    <th>12月</th>
                    </thead>
                    <tbody>
                    <c:forEach items="${his.hisTaskGroupByYear}" var="hisTaskGroupByYear" varStatus="vs">
                        <tr>
                            <td>${hisTaskGroupByYear.YEAR}年</td>
                            <c:forEach items="${hisTaskGroupByYear.hisMonthTaskList}" var="hisMonthTask" varStatus="us">
                                <td>${hisMonthTask.MONTH_COUNT}</td>
                            </c:forEach>
                        </tr>
                    </c:forEach>
                    <tr id="sum_tr">
                        <td colspan="12">
                            合计
                        </td>
                        <td id="sum_td">
                                ${his.MONTH_COUNT_SUM}
                        </td>
                    </tr>
                    <tr>
                        <td colspan="12">
                            目标数量/金额
                        </td>
                        <td id="count_td">
                                ${his.HIS_COUNT}
                        </td>
                    </tr>
                    </tbody>
                </table>
                <c:if test="${target.TARGET_TYPE == 'XSH'}">
                    <table id="explain_table" class="table table-striped table-bordered table-hover"
                           style="table-layout:fixed;"><br>
                        <thead>
                        <th></th>
                        <th>1月</th>
                        <th>2月</th>
                        <th>3月</th>
                        <th>4月</th>
                        <th>5月</th>
                        <th>6月</th>
                        <th>7月</th>
                        <th>8月</th>
                        <th>9月</th>
                        <th>10月</th>
                        <th>11月</th>
                        <th>12月</th>
                        </thead>
                        <tbody>
                        <c:forEach items="${his.hisTaskGroupByYear}" var="hisTaskGroupByYear" varStatus="vs">
                            <tr>
                                <td>${hisTaskGroupByYear.YEAR}年</td>
                                <c:forEach items="${hisTaskGroupByYear.hisMonthTaskList}" var="hisMonthTask"
                                           varStatus="us">
                                    <td>${hisMonthTask.MONEY_COUNT}</td>
                                </c:forEach>
                            </tr>
                        </c:forEach>
                        <tr id="sum_tr">
                            <td colspan="12">
                                合计
                            </td>
                            <td id="sum_td">
                                    ${his.MONEY_COUNT_SUM}
                            </td>
                        </tr>
                        <tr>
                            <td colspan="12">
                                目标金额
                            </td>
                            <td id="count_td">
                                    ${his.HIS_COUNT_MONEY}
                            </td>
                        </tr>
                        </tbody>
                    </table>
                </c:if>
            </div>
        </c:forEach>
    </div>
</div>
</body>
<!-- 按钮功能 -->
<script type="text/javascript">
    //关闭tab页
    function goBack() {
        $("#" + $('#PARENT_FRAME_ID').val(), window.parent.document).trigger("click");
        $("#history2", window.parent.document).children().find(".tab_close").trigger("click");
    }
</script>
</html>
