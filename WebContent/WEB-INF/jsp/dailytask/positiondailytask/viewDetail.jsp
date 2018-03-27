<%--
  Created by IntelliJ IDEA.
  User: yangdw
  Date: 2016/7/1
  Time: 10:11
  To change this template use File | Settings | File Templates.
--%>
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
    <title>查看日清详情</title>
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
        #detail_table thead th {
            text-align: center;
            vertical-align: middle;
        }

        #detail_table tbody tr td {
            text-align: center;
            vertical-align: middle;
        }
    </style>
</head>
<body>
<input type="hidden" value="${PARENT_FRAME_ID}" name="PARENT_FRAME_ID" id="PARENT_FRAME_ID">
<input type="hidden" name="flag" id="flag" value="${flag}" title="新增修改成功标志"/>
<div class="tabbable tabs-below">
    <ul class="nav nav-tabs" id="menuStatus">
        <li>
            <img src="static/images/ui1.png" style="margin-top:-3px;">
            日清详情
        </li>

        <div class="nav-search" id="nav-search" style="right:5px;" class="form-search">
            <div style="float:left;" class="panel panel-default">
                <div>
                    <a class="btn btn-mini btn-primary" onclick="save();"
                       style="float:left;margin-right:5px;">保存</a>
                    <a class="btn btn-mini btn-danger" onclick="goBack();"
                       style="float:left;margin-right:5px;">关闭</a>
                </div>
            </div>
        </div>
    </ul>
</div>
<div id="zhongxin">
    <!-- 基础信息开始-->
    <table style="margin-left: 50px;" id="target_table"><br>
        <tr>
            <td>
                <label>姓名：</label>
            </td>
            <td>
                <input value="${baseDate.EMP_NAME}" type="text" readonly="readonly"/>
            </td>
            <td>
                <label>日期：</label>
            </td>
            <td>
                <input value="<fmt:formatDate value="${baseDate.DATE}" type="date"/>" type="text" readonly="readonly"/>
            </td>
        </tr>
        <tr>
            <td>
                <label>岗位：</label>
            </td>
            <td>
                <input value="${baseDate.GRADE_NAME}" type="text" readonly="readonly"/>
            </td>
            <td>
                <label>部门：</label>
            </td>
            <td>
                <input value="${baseDate.DEPT_NAME}" type="text" readonly="readonly"/>
            </td>
        </tr>
    </table>
    <!-- 基础信息结束-->

    <hr style="height:1px;border:none;border-top:1px solid grey;margin: 6px 0;"/>
    <div class="row">
        <div class="span12">
            <div class="span6" style="text-align: left">
                <h4>分解列表</h4>
            </div>
            <div class="span5" style="text-align: right">
                <h4>
                    <a style="cursor:pointer;" title="添加日清详情" onclick="add()" class='btn btn-small btn-success'
                       data-rel="tooltip" data-placement="left">
                        <i class="icon-book"></i>
                    </a>
                </h4>
            </div>
        </div>
        <form action="positionDailyTask/detailChange.do" name="Form" id="Form" method="post">
            <input type="hidden" value="${positionDailyTask.ID}" name="daily_task_id"/>
            <input value="<fmt:formatDate value="${baseDate.DATE}" type="date"/>" type="hidden" name="date"/>
            <div class="span12">
                <!--详情表格开始-->
                <table id="detail_table" class="table table-striped table-bordered table-hover"><br>
                    <thead>
                    <th>工作明细选择</th>
                    <th>数量</th>
                    <th>单位</th>
                    </thead>
                    <tbody>
                    <c:forEach items="${detailList}" var="detail" varStatus="vs">
                        <tr>
                            <td>
                                <c:forEach items="${responseList}" var="response" varStatus="us">
                                    <c:if test="${response.ID == detail.detail_id}">${response.detail}</c:if>
                                </c:forEach>
                            </td>
                            <td>
                                    ${detail.count}
                            </td>
                            <td name="unit_td">
                                <c:forEach items="${responseList}" var="response" varStatus="us">
                                    <c:if test="${response.ID == detail.detail_id}">${response.unit}</c:if>
                                </c:forEach>
                            </td>
                            <input type="hidden" name="ID" value="${detail.ID}">
                            <input type="hidden" name="START_TIME_ARR" value="${detail.START_TIME_ARR}">
                            <input type="hidden" name="END_TIME_ARR" value="${detail.END_TIME_ARR}">
                        </tr>
                    </c:forEach>
                    </tbody>
                </table>
                <!--详情表格结束-->
            </div>
        </form>
    </div>
</div>
</body>

<!-- 按钮js -->
<script type="text/javascript">
    //关闭
    function goBack() {
        $("#" + $('#PARENT_FRAME_ID').val(), window.parent.document).trigger("click");
        $("#page_" + $('#PARENT_FRAME_ID').val(), window.parent.document).attr('src', $("#page_" + $('#PARENT_FRAME_ID').val(), window.parent.document).attr('src'));
        $("#positionDailyTaskDetail", window.parent.document).children().find(".tab_close").trigger("click");
    }
</script>
<!-- 按钮js -->
</html>
