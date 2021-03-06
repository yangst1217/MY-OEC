<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
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
            分解历史
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
    <table style="margin-left: 50px;" id="target_table"><br>
        <tr>
            <td>
                <label class="label_right"><span style="color: red; ">*</span>目标：</label>
            </td>
            <td colspan="3">
                <label class="label_left">${target.NAME}</label>
            </td>
        </tr>
        <tr>
            <td>
                <label class="label_right"><span style="color: red; ">*</span>年度：</label>
            </td>
            <td>
                <label class="label_left">${target.YEAR}</label>
            </td>
            <td>
                <label class="label_right"><span style="color: red; ">*</span>开始时间：</label>
            </td>
            <td>
                <label class="label_left">${target.START_DATE}</label>
            </td>
            <td>
                <label class="label_right"><span style="color: red; ">*</span>结束时间：</label>
            </td>
            <td>
                <label class="label_left">${target.END_DATE}</label>
            </td>
        </tr>
        <tr>
            <td>
                <label class="label_right"><span style="color: red; ">*</span>承接部门：</label>
            </td>
            <td>
                <label class="label_left">${target.DEPT_NAME}</label>
            </td>
            <td>
                <label class="label_right"><span style="color: red; ">*</span>承接责任人：</label>
            </td>
            <td>
                <label class="label_left">${target.EMP_NAME}</label>
            </td>
            <td>
                <label class="label_right"><span style="color: red; ">*</span>产品：</label>
            </td>
            <td>
                <label class="label_left">${target.PRODUCT_NAME}</label>
            </td>
        </tr>
        <tr>
            <td>
                <label class="label_right"><span style="color: red; ">*</span>经营指标：</label>
            </td>
            <td>
                <label class="label_left">${target.INDEX_NAME}</label>
            </td>
            <td>
                <label class="label_right"><span style="color: red; ">*</span>目标数量/金额：</label>
            </td>
            <td>
                <label class="label_left">${target.COUNT}</label>
            </td>
            <td>
                <label class="label_right"><span style="color: red; ">*</span>单位：</label>
            </td>
            <td>
                <label class="label_left">${target.UNIT_NAME}</label>
            </td>
        </tr>
        <tr>
            <td>
                <label class="label_right">完成标准：</label>
            </td>
            <td colspan="3">
                <label class="label_left">${target.STANDARD}</label>
            </td>
        </tr>
    </table>
    <!-- 基础信息结束-->
    <hr style="height:1px;border:none;border-top:1px solid grey;margin: 6px 0;"/>
    <div class="row">
        <div class="span12" style="text-align: center">
            <h4>目标数量修改历史</h4>
        </div>
        <div class="span12">
            <!--目标数量表格-->
            <table id="explain_table" class="table table-striped table-bordered table-hover"><br>
                <thead>
                <th>修改前目标数量</th>
                <th>修改后目标数量</th>
                <th>修改人</th>
                <th>修改时间</th>
                </thead>
                <tbody>
                <tr>
                    <td>${countHis.OLD_COUNT}</td>
                    <td>${countHis.COUNT}</td>
                    <td>${countHis.REVISER}</td>
                    <td><fmt:formatDate value="${countHis.UPDATE_TIME}" type="both"/></td>
                </tr>
                </tbody>
            </table>
            <!--目标数量表格-->
        </div>
    </div>
    <div class="row">
        <div class="span12" style="text-align: center">
            <h4>分解历史</h4>
        </div>
        <c:forEach items="${hisList}" var="his" varStatus="vs">
            <div class="span11" style="text-align: right">
                <h6><fmt:formatDate value="${his.UPDATE_TIME}" type="both"/></h6>
            </div>
            <div class="span12">
                <!--分解表格-->
                <table id="explain_table" class="table table-striped table-bordered table-hover"><br>
                    <thead>
                    <th>序号</th>
                    <th>承接部门</th>
                    <th>负责人</th>
                    <th>产品</th>
                    <th>承接数量/金额</th>
                    <c:if test="${target.TARGET_TYPE == 'XSH'}">
                        <th>销售量(吨)</th>
                    </c:if>
                    </thead>
                    <tbody>
                    <c:forEach items="${his.hisSearchList}" var="hisDetail" varStatus="vs">
                        <tr>
                            <td class='center' style="width: 30px;">${vs.index+1}</td>
                            <td>${hisDetail.DEPT_NAME}</td>
                            <td>${hisDetail.EMP_NAME}</td>
                            <td>${hisDetail.PRODUCT_NAME}</td>
                            <td>${hisDetail.COUNT}</td>
                            <c:if test="${target.TARGET_TYPE == 'XSH'}">
                                <td>${hisDetail.MONEY_COUNT}</td>
                            </c:if>
                        </tr>
                    </c:forEach>
                    <tr id="sum_tr">
                        <td colspan="4">
                            合计
                        </td>
                        <td id="sum_td">
                                ${his.COUNT_SUM}
                        </td>
                        <c:if test="${target.TARGET_TYPE == 'XSH'}">
                            <td></td>
                        </c:if>
                    </tr>
                    <tr>
                        <td colspan="4">
                            年度目标
                        </td>
                        <td id="count_td">
                                ${target.COUNT}
                        </td>
                        <c:if test="${target.TARGET_TYPE == 'XSH'}">
                            <td></td>
                        </c:if>
                    </tr>
                    </tbody>
                </table>
                <!--分解表格-->
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
        $("#history1", window.parent.document).children().find(".tab_close").trigger("click");
    }
</script>
</html>
