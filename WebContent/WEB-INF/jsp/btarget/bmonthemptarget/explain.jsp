<%--
  Created by IntelliJ IDEA.
  User: yangdw
  Date: 2016/5/16
  Time: 11:03
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
    <title>任务分解页面</title>
    <base href="<%=basePath%>">
    <!-- jsp文件头和头部 -->
    <%@ include file="../../system/admin/top.jsp" %>
    <link href="static/css/style.css" rel="stylesheet"/>
    <link type="text/css" rel="stylesheet" href="plugins/zTree/zTreeStyle.css"/>

    <!-- 引入 -->
    <script type="text/javascript">window.jQuery || document.write("<script src='static/js/jquery-1.9.1.min.js'>\x3C/script>");</script>
    <script src="static/js/bootstrap.min.js"></script>
    <script src="static/js/ace-elements.min.js"></script>
    <script src="static/js/ace.min.js"></script>

    <script type="text/javascript" src="static/js/chosen.jquery.min.js"></script><!-- 下拉框 -->
    <script type="text/javascript" src="static/js/bootstrap-datepicker.min.js"></script><!-- 日期框 -->
    <script type="text/javascript" src="static/js/bootbox.min.js"></script><!-- 确认窗口 -->
    <script type="text/javascript" src="static/js/jquery.tips.js"></script><!--提示框-->
    <script type="text/javascript" src="plugins/zTree/jquery.ztree-2.6.min.js"></script>
    <script type="text/javascript" src="static/deptTree/deptTree.js"></script>
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
<div class="tabbable tabs-below">
    <ul class="nav nav-tabs" id="menuStatus">
        <li>
            <img src="static/images/ui1.png" style="margin-top:-3px;">
            任务到员工分解
        </li>

        <div class="nav-search" id="nav-search"
             style="right:5px;" class="form-search">

            <div style="float:left;" class="panel panel-default">
                <div>
                    <a class="btn btn-mini btn-primary" onclick="saveAndArrange();"
                       style="float:left;margin-right:5px;">保存并生效</a>
                    <c:if test="${monthEmpTarget.ISEXPLAIN != '已分解（已生效）'}">
                        <a class="btn btn-mini btn-primary" onclick="save();"
                           style="float:left;margin-right:5px;">仅保存为草稿</a>
                    </c:if>
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
                <label class="label_left">${monthEmpTarget.NAME}</label>
            </td>
        </tr>
        <tr>
            <td>
                <label class="label_right"><span style="color: red; ">*</span>年度：</label>
            </td>
            <td>
                <label class="label_left">${monthEmpTarget.YEAR}</label>
            </td>
            <td>
                <label class="label_right"><span style="color: red; ">*</span>开始时间：</label>
            </td>
            <td>
                <label class="label_left">${monthEmpTarget.MONTH_START_DATE}</label>
            </td>
            <td>
                <label class="label_right"><span style="color: red; ">*</span>结束时间：</label>
            </td>
            <td>
                <label class="label_left">${monthEmpTarget.MONTH_END_DATE}</label>
            </td>
        </tr>
        <tr>
            <td>
                <label class="label_right"><span style="color: red; ">*</span>产品：</label>
            </td>
            <td>
                <label class="label_left">${monthEmpTarget.PRODUCT_NAME}</label>
            </td>
            <td>
                <label class="label_right"><span style="color: red; ">*</span>经营指标：</label>
            </td>
            <td>
                <label class="label_left">${monthEmpTarget.INDEX_NAME}</label>
            </td>
            <td>
                <label class="label_right"><span style="color: red; ">*</span>目标数量/金额：</label>
            </td>
            <td>
                <label class="label_left">${monthEmpTarget.MONTH_COUNT}</label>
            </td>
        </tr>
        <tr>
            <td>
                <label class="label_right"><span style="color: red; ">*</span>承接部门：</label>
            </td>
            <td>
                <label class="label_left">${monthEmpTarget.DEPT_NAME}</label>
            </td>
            <td>
                <label class="label_right"><span style="color: red; ">*</span>参与人：</label>
            </td>
            <td>
                <label class="label_left">${monthEmpTarget.PAR_NAME}</label>
            </td>
        </tr>
    </table>
    <!-- 基础信息结束-->
    <hr style="height:1px;border:none;border-top:1px solid grey;margin: 6px 0;"/>
    <div class="row">
        <div class="span4">
            <h4>分解列表</h4>
        </div>
        <div class="span8">
            <div class="row" style="text-align: right;">
                <div class="span6" style="text-align: right;">
                    <h5></h5>
                </div>
                <div class="span1" style="text-align: left">
                    <li>
                        <i class="icon-stop" style="color: skyblue"></i>
                        预算
                    </li>
                    <li>
                        <i class="icon-stop" style="color: #CCE8CC"></i>
                        实际
                    </li>
                    <li>
                        <i class="icon-stop" style="color: #FFFF99"></i>
                        差额
                    </li>
                </div>
            </div>
        </div>
        <form action="bweekemptask/add.do" name="Form" id="Form" method="post">
            <input type="hidden" value="${monthEmpTarget.ID}" name="B_MONTH_EMP_TARGET_ID"/>
            <input type="hidden" value="${monthEmpTarget.B_YEAR_TARGET_CODE}" name="B_YEAR_TARGET_CODE"/>
            <input type="hidden" value="${monthEmpTarget.DEPT_CODE}" name="DEPT_CODE"/>
            <input type="hidden" value="${monthEmpTarget.EMP_CODE}" name="EMP_CODE"/>
            <input type="hidden" value="${monthEmpTarget.YEAR}" name="YEAR"/>
            <input type="hidden" value="${monthEmpTarget.MONTH}" name="MONTH"/>
            <input type="hidden" value="${PARENT_FRAME_ID}" name="PARENT_FRAME_ID" id="PARENT_FRAME_ID">
            <input type="hidden" value="${monthEmpTarget.PARTICIPANT}" name="PARTICIPANT" id="PARTICIPANT">
            <div class="span12">
                <!--分解表格-->
                <table id="explain_table" class="table table-striped table-bordered table-hover"
                       style="table-layout: fixed"><br>
                    <thead>
                    <th style="width: 70px;">周次</th>
                    <c:forEach items="${monthEmpTarget.weekEmpTaskList}" var="weekEmpTask" varStatus="vs">
                        <th colspan="3" style="width: 180px">第${weekEmpTask.DC_WEEK}周
                            <br>(${weekEmpTask.DC_START_DATE}至${weekEmpTask.DC_END_DATE})
                        </th>
                    </c:forEach>
                    <th style="width: 70px;">合计</th>
                    <th style="width: 70px;">目标</th>
                    <th style="width: 70px;">实际</th>
                    </thead>
                    <tbody>
                    <tr>
                        <td>数量/金额</td>
                        <c:forEach items="${monthEmpTarget.weekEmpTaskList}" var="weekEmpTask" varStatus="vs">
                            <td colspan="3" style="background-color:skyblue;">
                                <div style="background-color:skyblue;"
                                     <c:if test="${!weekEmpTask.TO_CHANGE}">colspan="3" </c:if>>
                                    <c:if test="${weekEmpTask.TO_CHANGE}">${weekEmpTask.WEEK_COUNT}</c:if>
                                </div>
                                <input value='${weekEmpTask.WEEK_COUNT}' onchange='checkNum($(this));getSum();'
                                       name='WEEK_COUNTS'
                                       style="width: 95%" <c:if test="${weekEmpTask.TO_CHANGE}">type="hidden"</c:if>/>
                                <input value='${weekEmpTask.DC_START_DATE}' name='START_DATES' type="hidden"/>
                                <input value='${weekEmpTask.DC_END_DATE}' name='END_DATES' type="hidden"/>
                                <input value='${weekEmpTask.DC_WEEK}' name='WEEKS' type="hidden"/>
                                <input value='${weekEmpTask.ID}' name='IDS' type="hidden"/>
                                <input
                                        <c:choose>
                                            <c:when test="${null != weekEmpTask.STATUS && '' != weekEmpTask.STATUS}">
                                                value="${weekEmpTask.STATUS}"
                                            </c:when>
                                            <c:otherwise>
                                                value="YW_CG"
                                            </c:otherwise>
                                        </c:choose> name="STATUSES" type="hidden"/>
                                <c:if test="${weekEmpTask.TO_CHANGE}">
                                    <div style="background-color:#CCE8CC;">${weekEmpTask.REAL_COUNT}</div>
                                </c:if>
                                <c:if test="${weekEmpTask.TO_CHANGE}">
                                    <div style="background-color:#FFFF99;">${weekEmpTask.DIFF_COUNT}</div>
                                </c:if>
                            </td>
                        </c:forEach>
                        <td id="sum_td">
                        </td>
                        <td id="count_td">
                            ${monthEmpTarget.MONTH_COUNT}
                        </td>
                        <td id="real_td">
                            ${monthEmpTarget.REAL_COUNT_SUM}
                        </td>
                    </tr>
                    <c:if test="${monthEmpTarget.TARGET_TYPE == 'XSH'}">
                        <tr>
                            <td>销售量(吨)</td>
                            <c:forEach items="${monthEmpTarget.weekEmpTaskList}" var="weekEmpTask" varStatus="vs">
                                <td colspan="3" style="background-color:skyblue;">
                                    <div style="background-color:skyblue;"
                                         <c:if test="${!weekEmpTask.TO_CHANGE}">colspan="3" </c:if>>
                                        <c:if test="${weekEmpTask.TO_CHANGE}">${weekEmpTask.MONEY_COUNT}</c:if>
                                    </div>
                                    <input value='${weekEmpTask.MONEY_COUNT}'
                                           onchange='checkNum($(this));getMoneySum();' name='WEEK_COUNTS_MONEY'
                                           style="width: 95%"
                                           <c:if test="${weekEmpTask.TO_CHANGE}">type="hidden"</c:if>/>
                                    <c:if test="${weekEmpTask.TO_CHANGE}">
                                        <div style="background-color:#CCE8CC;">${weekEmpTask.REAL_COUNT_MONEY}</div>
                                    </c:if>
                                    <c:if test="${weekEmpTask.TO_CHANGE}">
                                        <div style="background-color:#FFFF99;">${weekEmpTask.DIFF_COUNT_MONEY}</div>
                                    </c:if>
                                </td>
                            </c:forEach>
                            <td id="sum_td_money">
                            </td>
                            <td id="count_td_money">
                                    ${monthEmpTarget.MONTH_COUNT_MONEY}
                            </td>
                            <td id="real_td_money">
                                    ${monthEmpTarget.REAL_COUNT_SUM_MONEY}
                            </td>
                        </tr>
                    </c:if>
                    </tbody>
                </table>
            </div>
        </form>
    </div>
</div>
</div>
</body>

<!-- 按钮js -->
<script type="text/javascript">

    //关闭tab页
    function goBack() {
        $("#" + $('#PARENT_FRAME_ID').val(), window.parent.document).trigger("click");
        $("#page_" + $('#PARENT_FRAME_ID').val(), window.parent.document).attr('src', $("#page_" + $('#PARENT_FRAME_ID').val(), window.parent.document).attr('src'));
        $("#explain4", window.parent.document).children().find(".tab_close").trigger("click");
    }

    //保存并生效
    function saveAndArrange() {
        $("input[name='STATUSES']").each(function () {
            $(this).val("YW_YSX");
        })
        save();
    }

    //仅保存为草稿
    function save() {
        var countList = document.getElementsByName('WEEK_COUNTS');
        var sum = Number($("#sum_td").html());
        if (Number(sum) < Number($("#count_td").html())) {
            top.Dialog.alert("您的拆分合计小于总目标！");
            return false;
        }

        for (var i = 0; i < countList.length; i++) {
            if (null == countList[i].value || "" == countList[i].value) {
                $(countList[i]).tips({
                    side: 3,
                    msg: '请填写数字！',
                    bg: '#AE81FF',
                    time: 2
                });
                $(countList[i]).focus();
                return false;
            }
            ;
        }
        $("#Form").submit();
    }
</script>
<!-- 按钮js -->

<!-- 预加载js -->
<script type="text/javascript">

    //是否保存成功
    window.onload = function () {
        if ($("#flag").val() == "success") {
            top.Dialog.alert("保存成功！");
        } else if ($("#flag").val() == "false") {
            top.Dialog.alert("保存失败！");
        }
    };

    $(document).ready(function () {
        //拆分和
        var tdList = $("input[name='WEEK_COUNTS']");
        var sum = Number(0);
        for (var i = 0; i < tdList.length; i++) {
            sum += Number(tdList[i].value);
        }
        $("input[name='WEEK_COUNTS'][type='hidden']").each(function () {
            sum = Number(sum) - Number($(this).val());
        });
        sum = Number(sum) + Number($('#real_td').html());
        $('#sum_td').append(sum);

        //拆分和
        var tdList = $("input[name='WEEK_COUNTS_MONEY']");
        var sum = Number(0);
        for (var i = 0; i < tdList.length; i++) {
            sum += Number(tdList[i].value);
        }
        $("input[name='WEEK_COUNTS_MONEY'][type='hidden']").each(function () {
            sum = Number(sum) - Number($(this).val());
        });
        sum = Number(sum) + Number($('#real_td_money').html());
        $('#sum_td_money').append(sum);
    });

</script>
<!-- 预加载js -->

<!-- 行为js -->
<script type="text/javascript">
    //检验是否是数字
    function checkNum($obj) {
        if (!(/^(([0-9]\d*)|0)(\.\d{1,4})?$/).test($obj.val())) {
            $obj.tips({
                side: 3,
                msg: '只可填入数字，最多四位小数',
                bg: '#AE81FF',
                time: 2
            });
            $obj.focus();
            $obj.val("0.00");
        }
    }

    //求和
    function getSum() {
        var tdList = $("input[name='WEEK_COUNTS']");
        var sum = Number(0);
        for (var i = 0; i < tdList.length; i++) {
            sum += Number(tdList[i].value);
        }
        $("input[name='WEEK_COUNTS'][type='hidden']").each(function () {
            sum = Number(sum) - Number($(this).val());
        });
        sum = Number(sum) + Number($('#real_td').html());
        sum = parseFloat(sum).toFixed(4);
        $("#sum_td").html(sum);
    }

    function getMoneySum() {
        var tdList = $("input[name='WEEK_COUNTS_MONEY']");
        var sum = Number(0);
        for (var i = 0; i < tdList.length; i++) {
            sum += Number(tdList[i].value);
        }
        $("input[name='WEEK_COUNTS_MONEY'][type='hidden']").each(function () {
            sum = Number(sum) - Number($(this).val());
        });
        sum = Number(sum) + Number($('#real_td_money').html());
        sum = parseFloat(sum).toFixed(4);
        $("#sum_td_money").html(sum);
    }
</script>
<!-- 行为js -->

</html>
