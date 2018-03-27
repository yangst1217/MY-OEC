<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

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

        #explain_table tbody td {
            width: 75px;
        }

        #explain_table thead th {
            text-align: center;
        }

        .label_left {
            width: 200px;
            text-align: left;
        }

        .label_right {
            width: 180px;
            text-align: right;
        }

        .span12 {
            width: 95%;
        }

        .table {
            width: initial;
        }
    </style>
</head>
<body>
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
                    <a class="btn btn-mini btn-primary" onclick="saveAndArrange();"
                       style="float:left;margin-right:5px;">保存并生效</a>
                    <c:if test="${task.ISEXPLAIN != '已分解（已生效）'}">
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
                <label class="label_left">${task.NAME}</label>
            </td>
        </tr>
        <tr>
            <td>
                <label class="label_right"><span style="color: red; ">*</span>年度：</label>
            </td>
            <td>
                <label class="label_left">${task.YEAR_NUM}</label>
            </td>
            <td>
                <label class="label_right"><span style="color: red; ">*</span>开始时间：</label>
            </td>
            <td>
                <label class="label_left">${task.START_DATE}</label>
            </td>
            <td>
                <label class="label_right"><span style="color: red; ">*</span>结束时间：</label>
            </td>
            <td>
                <label class="label_left">${task.END_DATE}</label>
            </td>
        </tr>
        <tr>
            <td>
                <label class="label_right"><span style="color: red; ">*</span>产品：</label>
            </td>
            <td>
                <label class="label_left">${task.PRODUCT_NAME}</label>
            </td>
            <td>
                <label class="label_right"><span style="color: red; ">*</span>经营指标：</label>
            </td>
            <td>
                <label class="label_left">${task.INDEX_NAME}</label>
            </td>
            <td>
                <label class="label_right"><span style="color: red; ">*</span>目标数量/金额：</label>
            </td>
            <td>
                <label class="label_left">${task.COUNT}</label>
            </td>
        </tr>
        <tr>
            <td>
                <label class="label_right"><span style="color: red; ">*</span>承接部门：</label>
            </td>
            <td>
                <label class="label_left">${task.DEPT_NAME}</label>
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
        <form action="bmonthdepttask/add.do" name="Form" id="Form" method="post">
            <input type="hidden" value="${task.B_YEAR_TARGET_CODE}" name="B_YEAR_TARGET_CODE"/>
            <input type="hidden" value="${task.DEPT_CODE}" name="DEPT_CODE"/>
            <input type="hidden" value="${task.EMP_CODE}" name="EMP_CODE"/>
            <input type="hidden" value="${task.ID}" name="B_YEAR_DEPT_TASK_ID"/>
            <input type="hidden" value="${task.ID}" name="ID"/>
            <input type="hidden" value="${PARENT_FRAME_ID}" name="PARENT_FRAME_ID" id="PARENT_FRAME_ID">
            <c:if test="${not empty isExplainEmp }">
                <input type="hidden" value="1" name="isExplainEmp"/>
            </c:if>
            <div class="span12" style="width:95%">
                <!--分解表格-->
                <table id="explain_table" class="table table-striped table-bordered table-hover" style="">
                    <thead>
                    <th style="width: 70px;"></th>
                    <th colspan="3" style="width: 150px">1月</th>
                    <th colspan="3" style="width: 150px">2月</th>
                    <th colspan="3" style="width: 150px">3月</th>
                    <th colspan="3" style="width: 150px">4月</th>
                    <th colspan="3" style="width: 150px">5月</th>
                    <th colspan="3" style="width: 150px">6月</th>
                    <th colspan="3" style="width: 150px">7月</th>
                    <th colspan="3" style="width: 150px">8月</th>
                    <th colspan="3" style="width: 150px">9月</th>
                    <th colspan="3" style="width: 150px">10月</th>
                    <th colspan="3" style="width: 150px">11月</th>
                    <th colspan="3" style="width: 150px">12月</th>
                    </thead>
                    <tbody>
                    <c:forEach items="${taskGroupByYear}" var="taskGroupByYear" varStatus="vs">
                        <tr>
                            <td>${taskGroupByYear.YEAR}年</td>
                            <c:forEach items="${taskGroupByYear.monthTaskList}" var="monthTask" varStatus="vs">
                                <c:if test="${monthTask.TO_USE == 'false'}">
                                    <td colspan="3"></td>
                                </c:if>
                                <c:if test="${monthTask.TO_USE == 'true'}">

                                    <input value="${monthTask.ID}" name="IDS" type="hidden"/>
                                    <input value="${monthTask.YEAR}" name="YEARS" type="hidden"/>
                                    <input value="${monthTask.MONTH}" name="MONTHS" type="hidden"/>
                                    <input value="${monthTask.MONTH_START_DATE_CUL}" name="MONTH_START_DATES"
                                           type="hidden"/>
                                    <input value="${monthTask.MONTH_END_DATE_CUL}" name="MONTH_END_DATES"
                                           type="hidden"/>
                                    <input
                                            <c:choose>
                                                <c:when test="${null != monthTask.STATUS && '' != monthTask.STATUS}">
                                                    value="${monthTask.STATUS}"
                                                </c:when>
                                                <c:otherwise>
                                                    value="YW_CG"
                                                </c:otherwise>
                                            </c:choose> name="STATUSES" type="hidden"/>
                                    <td colspan="3" style="background-color:skyblue;">
                                        <input value="${monthTask.MONTH_COUNT}" name="MONTH_COUNTS" style="width:95%;"
                                               onchange='checkNum($(this), ${vs.index }, "num");getSum();'
                                               <c:if test="${monthTask.TO_CHANGE == 'false'}">type="hidden"</c:if>/>
                                        <div style="width: 150px;background-color:skyblue;"
                                             <c:if test="${monthTask.TO_CHANGE}">colspan="3"</c:if> >
                                            <c:if test="${!monthTask.TO_CHANGE}">${monthTask.MONTH_COUNT}</c:if>
                                        </div>
                                        <c:if test="${!monthTask.TO_CHANGE}">
                                            <div style="width: 150px;background-color:#CCE8CC">${monthTask.REAL_COUNT}</div>
                                        </c:if>
                                        <c:if test="${!monthTask.TO_CHANGE}">
                                            <div style="width: 150px;background-color:#FFFF99"
                                                 name="real_td">${monthTask.DIFF_COUNT}</div>
                                        </c:if>
                                    </td>
                                </c:if>
                            </c:forEach>
                        </tr>
                    </c:forEach>
                    <tr id="sum_tr">
                        <td colspan="34">
                            合计
                        </td>
                        <td id="sum_td" colspan="3">
                        </td>
                    </tr>
                    <tr>
                        <td colspan="34">
                            目标数量/金额
                        </td>
                        <td id="count_td" colspan="3">
                            ${task.COUNT}
                        </td>
                    </tr>
                    <tr>
                        <td colspan="34">
                            实际
                        </td>
                        <td id="real_td" colspan="3">

                        </td>
                    </tr>
                    </tbody>
                </table>
                <c:if test="${task.TARGET_TYPE == 'XSH'}">
                    <table id="explain_table" class="table table-striped table-bordered table-hover">
                        <thead>
                        <th style="width: 70px;"></th>
                        <th colspan="3" style="width: 150px">1月</th>
                        <th colspan="3" style="width: 150px">2月</th>
                        <th colspan="3" style="width: 150px">3月</th>
                        <th colspan="3" style="width: 150px">4月</th>
                        <th colspan="3" style="width: 150px">5月</th>
                        <th colspan="3" style="width: 150px">6月</th>
                        <th colspan="3" style="width: 150px">7月</th>
                        <th colspan="3" style="width: 150px">8月</th>
                        <th colspan="3" style="width: 150px">9月</th>
                        <th colspan="3" style="width: 150px">10月</th>
                        <th colspan="3" style="width: 150px">11月</th>
                        <th colspan="3" style="width: 150px">12月</th>
                        </thead>
                        <tbody>
                        <c:forEach items="${taskGroupByYear}" var="taskGroupByYear" varStatus="vs">
                            <tr>
                                <td>${taskGroupByYear.YEAR}年</td>
                                <c:forEach items="${taskGroupByYear.monthTaskList}" var="monthTask" varStatus="vs">
                                    <c:if test="${monthTask.TO_USE == 'false'}">
                                        <td colspan="3"></td>
                                    </c:if>
                                    <c:if test="${monthTask.TO_USE == 'true'}">
                                        <td colspan="3" style="background-color:skyblue;">
                                            <input value="${monthTask.MONEY_COUNT}" name="MONEY_COUNT"
                                                   style="width:95%;"
                                                   onchange='checkNum($(this), ${vs.index }, "money");getMoneySum();'
                                                   <c:if test="${monthTask.TO_CHANGE == 'false'}">type="hidden"</c:if>/>
                                            <div style="width: 150px;background-color:skyblue;"
                                                 <c:if test="${monthTask.TO_CHANGE}">colspan="3"</c:if> >
                                                <c:if test="${!monthTask.TO_CHANGE}">${monthTask.MONEY_COUNT}</c:if>
                                            </div>
                                            <c:if test="${!monthTask.TO_CHANGE}">
                                                <div style="width: 150px;background-color:#CCE8CC">${monthTask.REAL_COUNT_MONEY}</div>
                                            </c:if>
                                            <c:if test="${!monthTask.TO_CHANGE}">
                                                <div style="width: 150px;background-color:#FFFF99"
                                                     name="real_td_money">${monthTask.DIFF_COUNT_MONEY}</div>
                                            </c:if>
                                        </td>
                                    </c:if>
                                </c:forEach>
                            </tr>
                        </c:forEach>
                        <tr id="sum_tr_money">
                            <td colspan="34">
                                合计
                            </td>
                            <td id="sum_td_money" colspan="3">
                            </td>
                        </tr>
                        <tr>
                            <td colspan="34">
                                销售量（吨）
                            </td>
                            <td id="count_td_money" colspan="3">
                                    ${task.MONEY_COUNT}
                            </td>
                        </tr>
                        <tr>
                            <td colspan="34">
                                实际
                            </td>
                            <td id="real_td_money" colspan="3">

                            </td>
                        </tr>
                        </tbody>
                    </table>
                </c:if>
            </div>
        </form>
    </div>
</div>
</body>

<!-- 行为js -->
<script type="text/javascript">
    //检验是否是数字
    function checkNum($obj, index, type) {
        if (!(/^(([1-9]\d*)|0)(\.\d{1,4})?$/).test($obj.val())) {
            $obj.tips({
                side: 3,
                msg: '只可填入数字，最多四位小数',
                bg: '#AE81FF',
                time: 2
            });
            $obj.focus();
            $obj.val("");
            return;
        }
        var numList = $("input[name='MONTH_COUNTS']");
        var moneyList = $("input[name='MONEY_COUNT']");
        var price = (${task.COUNT}/${task.MONEY_COUNT}).toFixed(4);
        if (type == 'num') {//金额
            $("input[name='MONEY_COUNT']:eq(" + index + ")").val((Number(numList[index].value) / price).toFixed(4));
        } else {//吨
            $("input[name='MONTH_COUNTS']:eq(" + index + ")").val((Number(moneyList[index].value) * price).toFixed(4));
        }
    }

    //求和
    function getSum() {
        var tdList = $("input[name='MONTH_COUNTS']");
        var sum = Number(0);
        for (var i = 0; i < tdList.length; i++) {
            sum += Number(tdList[i].value);
        }
        $("input[name='MONTH_COUNTS'][type='hidden']").each(function () {
            sum = Number(sum) - Number($(this).val());
        });
        sum = Number(sum) + Number($('#real_td').html());
        sum = parseFloat(sum).toFixed(4);
        $("#sum_td").html(sum);
    }

    function getMoneySum() {
        var tdList = $("input[name='MONEY_COUNT']");
        var sum = Number(0);
        for (var i = 0; i < tdList.length; i++) {
            sum += Number(tdList[i].value);
        }
        $("input[name='MONEY_COUNT'][type='hidden']").each(function () {
            sum = Number(sum) - Number($(this).val());
        });
        sum = Number(sum) + Number($('#real_td_money').html());
        sum = parseFloat(sum).toFixed(4);
        $("#sum_td_money").html(sum);
    }
</script>
<!-- 行为js -->

<!-- 按钮js -->
<script type="text/javascript">

    //关闭tab页
    function goBack() {
        $("#" + $('#PARENT_FRAME_ID').val(), window.parent.document).trigger("click");
        $("#page_" + $('#PARENT_FRAME_ID').val(), window.parent.document).attr('src', $("#page_" + $('#PARENT_FRAME_ID').val(), window.parent.document).attr('src'));
        $("#explain2", window.parent.document).children().find(".tab_close").trigger("click");
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
        var countList = document.getElementsByName('MONTH_COUNTS');
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
        //实际和
        var real_sum = 0;
        $("div[name = 'real_td']").each(function () {
            real_sum = Number(real_sum) + Number($(this).html())
        });
        $('#real_td').append(real_sum);

        //拆分和
        var tdList = $("input[name='MONTH_COUNTS']");
        var sum = Number(0);
        for (var i = 0; i < tdList.length; i++) {
            sum += Number(tdList[i].value);
        }
        $("input[name='MONTH_COUNTS'][type='hidden']").each(function () {
            sum = Number(sum) - Number($(this).val());
        });
        sum = Number(sum) + Number(real_sum);
        $('#sum_td').append(sum);


        //实际和
        var real_sum_money = 0;
        $("div[name = 'real_td_money']").each(function () {
            real_sum_money = Number(real_sum_money) + Number($(this).html())
        });
        $('#real_td_money').append(real_sum_money);

        //拆分和
        var tdList = $("input[name='MONEY_COUNT']");
        var sum_money = Number(0);
        for (var i = 0; i < tdList.length; i++) {
            sum_money += Number(tdList[i].value);
        }
        $("input[name='MONEY_COUNT'][type='hidden']").each(function () {
            sum_money = Number(sum_money) - Number($(this).val());
        });
        sum_money = Number(sum_money) + Number(real_sum_money);
        $('#sum_td_money').append(sum_money);
    });

</script>
<!-- 预加载js -->

</html>
