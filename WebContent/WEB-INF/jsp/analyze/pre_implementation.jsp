<%--
  Created by IntelliJ IDEA.
  User: yangdw
  Date: 2016/5/23
  Time: 10:29
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
    <title>经营目标预实显差表（预实分析）</title>
    <base href="<%=basePath%>">
    <!-- jsp文件头和头部 -->
    <%@ include file="../system/admin/top.jsp" %>
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
        #table tbody td {
            text-align: center;
            vertical-align: middle;
            word-break: keep-all;
            white-space: nowrap;
        }

        #table thead th {
            text-align: center;
            vertical-align: middle;
        }

    </style>

</head>
<body>
<div class="container-fluid" id="main-container">
    <div id="page-content" class="clearfix">
        <div class="row-fluid">
            <div class="row-fluid">
                <div class="tabbable tabs-below">
                    <ul class="nav nav-tabs" id="menuStatus">

                        <li>
                            <!-- <a data-toggle="tab"> </a> -->
                            <img src="static/images/ui1.png" style="margin-top:-3px;">
                            经营目标预实显差表（预实分析）
                        </li>

                        <div class="nav-search" id="nav-search" style="right:5px;" class="form-search">
                            <div style="float:left;" class="panel panel-default">
                                <div>
                                    <a data-toggle="collapse" data-parent="#accordion" href="#collapseTwo"
                                       class="btn btn-small btn-primary">
                                        高级搜索
                                    </a>
                                    <!-- 搜索弹出面板开始 -->
                                    <div id="collapseTwo" class="panel-collapse collapse"
                                         style="position:absolute; right:-5px; top:32px; z-index:999">
                                        <div class="panel-body">

                                            <!-- 搜索表单开始 -->
                                            <form action="preRealDiff/pre_implementation.do" method="post" name="form"
                                                  id="form">
                                                <table border='0'>
                                                    <tr>
                                                        <td style="vertical-align:top;">
                                                            年度：
                                                            <input type="text" id="YEAR" name="YEAR"
                                                                   style="width:160px;background:#fff!important;"
                                                                   value="${pd.YEAR}" onchange="getTargetList()"
                                                                   class="date-picker" data-date-format="yyyy"
                                                                   placeholder="请输入年月日！" readonly="readonly"/>
                                                        </td>
                                                        <td style="vertical-align:top;">
                                                            目标：
                                                            <select id='B_YEAR_TARGET_CODE' name='B_YEAR_TARGET_CODE'>
                                                                <option value="">请选择</option>
                                                                <c:forEach items="${targetList}" var="target"
                                                                           varStatus="us">
                                                                    <option value="${target.CODE}"
                                                                            <c:if test="${target.CODE == pd.B_YEAR_TARGET_CODE}">selected</c:if>>${target.CODE}:${target.NAME}</option>
                                                                </c:forEach>
                                                            </select>
                                                        </td>
                                                    </tr>
                                                </table>
                                            </form>
                                            <!-- 搜索表单结束 -->

                                            <!-- 高级搜索按钮组开始 -->
                                            <div style="margin-top:15px; margin-right:30px; text-align:right;">
                                                <a class="btn-style1" style="cursor: pointer;" id="searchButton"
                                                   onclick="toSearch();">查询</a>
                                                <a class="btn-style2" onclick="emptySearch();" style="cursor: pointer;">重置</a>
                                                <a data-toggle="collapse" data-parent="#accordion" class="btn-style3"
                                                   href="#collapseTwo">关闭</a>
                                            </div>
                                            <!-- 高级搜索按钮组结束 -->

                                        </div>
                                    </div>
                                    <!-- 搜索弹出面板结束 -->
                                </div>
                            </div>
                        </div>
                    </ul>
                </div>
            </div>

            <c:choose>
                <c:when test="${not empty yearMonthList}">
                    <div class="row">
                        <div class="span12" style="text-align: center">
                            <h3>[${bYearTarget.CODE}] ${bYearTarget.NAME}</h3>
                        </div>
                    </div>
                </c:when>
            </c:choose>

            <!-- 列表开始 -->
            <table class="table table-striped table-bordered table-hover" id="table">
                <c:choose>
                    <c:when test="${not empty yearMonthList}">
                        <thead>
                        <tr>
                            <th>时间</th>
                            <c:forEach items="${yearMonthList}" var="yearMonth" varStatus="vs">
                                <th colspan="3">${yearMonth.YEAR_MONTH}</th>
                            </c:forEach>
                            <th colspan="3">合计</th>
                        </tr>
                        <tr>
                            <th></th>
                            <c:forEach items="${yearMonthList}">
                                <th>预</th>
                                <th>实</th>
                                <th>差</th>
                            </c:forEach>
                            <th>预</th>
                            <th>实</th>
                            <th>差</th>
                        </tr>
                        </thead>
                        <tbody>
                        <c:forEach items="${deptList}" var="dept" varStatus="vs">
                            <tr>
                                <td><a DEPT_CODE='${dept.DEPT_CODE}' href="javascript:;"
                                       onclick="getEmpPreImplementationList($(this));">${dept.DEPT_NAME}</a></td>
                                <c:forEach items="${dept.preImplementationList}" var="preImplementation" varStatus="us">
                                    <td>${preImplementation.PRE}</td>
                                    <td>${preImplementation.REAL}</td>
                                    <td><font color="red">${preImplementation.DIFF}</font></td>
                                </c:forEach>
                                <td>${dept.PRE_SUM}</td>
                                <td>${dept.REAL_SUM}</td>
                                <td><font color="red">${dept.DIFF_SUM}</font></td>
                            </tr>
                        </c:forEach>
                        <tr>
                            <td>合计</td>
                            <c:forEach items="${yearMonthList}" var="yearMonth" varStatus="vs">
                                <td>${yearMonth.PRE_SUM}</td>
                                <td>${yearMonth.REAL_SUM}</td>
                                <td><font color="red">${yearMonth.DIFF_SUM}</font></td>
                            </c:forEach>
                            <td>${PRE_SUM}</td>
                            <td>${REAL_SUM}</td>
                            <td><font color="red">${DIFF_SUM}</font></td>
                        </tr>
                        </tbody>
                    </c:when>
                    <c:otherwise>
                        <tr class="main_info">
                            <td colspan="100" class="center">请选择查询条件！</td>
                        </tr>
                    </c:otherwise>
                </c:choose>
            </table>
        </div>
    </div>
</div>
</body>
<!-- 按钮js -->
<script type="text/javascript">

    //检索
    function toSearch() {
        if (null != $('#B_YEAR_TARGET_CODE').val() && '' != $('#B_YEAR_TARGET_CODE').val()) {
            $("#form").submit();
        } else {
            alert('请选择目标再做查询！')
        }
    }

    //清空查询条件
    function emptySearch() {
        $("#YEAR").val("");
        $("#B_YEAR_TARGET_CODE").val("");
        $("#B_YEAR_TARGET_CODE option").remove();
    }
</script>
<!-- 按钮js -->

<!-- 行为js -->
<script type="text/javascript">

    //年度变化时目标列表也变化
    function getTargetList() {
        $.ajax({
            type: "POST",
            dataType: 'json',
            cache: false,
            data: {YEAR: $('#YEAR').val()},
            url: "<%=basePath%>preRealDiff/getTargetList.do",
            success: function (data) {     //回调函数，result，返回值
                $("#B_YEAR_TARGET_CODE option").remove();
                var shtml = "<option value=''>请选择</option>";
                $.each(data.targetList, function (i, list) {
                    shtml += '<option value=' + list.CODE + '>' + list.CODE + ':' + list.NAME + '</option>';
                });

                $("#B_YEAR_TARGET_CODE").append(shtml);
            }
        });
    }

    //获得部门下员工预实差
    function getEmpPreImplementationList(obj) {
        var DEPT_CODE = $(obj).attr("DEPT_CODE");
        if ($("tr[EMP_DEPT_CODE = '" + DEPT_CODE + "']").length == 0) {
            $.ajax({
                type: "POST",
                dataType: 'json',
                cache: false,
                data: {DEPT_CODE: DEPT_CODE, B_YEAR_TARGET_CODE: $('#B_YEAR_TARGET_CODE').val()},
                url: "<%=basePath%>preRealDiff/getEmpPreImplementationList.do",
                success: function (data) {     //回调函数，result，返回值
                    var shtml = '';
                    $.each(data.empList, function (i, emp) {
                        shtml += "<tr EMP_DEPT_CODE = '" + DEPT_CODE + "'>";
                        shtml += "<td style='text-align: right'>" + emp.EMP_NAME + "</td>";
                        $.each(emp.empPreImplementationList, function (j, preImplementation) {
                            shtml += "<td>" + preImplementation.PRE + "</td>";
                            shtml += "<td>" + preImplementation.REAL + "</td>";
                            shtml += "<td>" + preImplementation.DIFF + "</td>";
                        })
                        shtml += "<td>" + emp.PRE_SUM + "</td>";
                        shtml += "<td>" + emp.REAL_SUM + "</td>";
                        shtml += "<td>" + emp.DIFF_SUM + "</td>";
                        shtml += "</td>";
                    })
                    $(obj).parent().parent().after(shtml);
                }
            });
        } else {
            $("tr[EMP_DEPT_CODE = '" + DEPT_CODE + "']").each(function () {
                $(this).remove();
            })
        }

    }

</script>
<!-- 行为js -->

<!-- 预加载js -->
<script type="text/javascript">
    $(function () {
        //日期框
        $('.date-picker').datepicker({
            format: 'yyyy',
            changeMonth: true,
            changeYear: true,
            showButtonPanel: true,
            autoclose: true,
            minViewMode: 2,
            maxViewMode: 2,
            startViewMode: 2,
            onClose: function (dateText, inst) {
                var year = $("#span2 date-picker .ui-datepicker-year :selected").val();
                $(this).datepicker('setDate', new Date(year, 1, 1));
            }
        });
    });
</script>
<!-- 预加载js -->
</html>
