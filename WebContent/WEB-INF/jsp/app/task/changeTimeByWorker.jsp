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
    <title>修改时间</title>
    <base href="<%=basePath%>">
    <!-- jsp文件头和头部 -->
    <%@ include file="../../system/admin/top.jsp" %>
    <link href="static/css/style.css" rel="stylesheet"/>
    <link rel="stylesheet" href="plugins/bootstrap-datetimepicker/bootstrap-datetimepicker.min.css"/>
    <!-- 引入 -->
    <script type="text/javascript">window.jQuery || document.write("<script src='static/js/jquery-1.9.1.min.js'>\x3C/script>");</script>
    <script src="static/js/bootstrap.min.js"></script>
    <script src="static/js/ace-elements.min.js"></script>
    <script src="static/js/ace.min.js"></script>

    <script type="text/javascript" src="static/js/chosen.jquery.min.js"></script><!-- 下拉框 -->
    <script type="text/javascript" src="static/js/bootbox.min.js"></script><!-- 确认窗口 -->
    <script type="text/javascript" src="static/js/jquery.tips.js"></script><!--提示框-->

    <!--时间框-->
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
    </style>
</head>
<body>
<input type="hidden" id="START_TIME_ARR"/>
<input type="hidden" id="END_TIME_ARR"/>
<div class="web_title">
    <div class="back" style="top:5px">
        <a href="<%=basePath%>app_task/empDailyTaskInfo.do?manageId=${pd.manageId}&startDate=${pd.startDate}&endDate=${pd.endDate }&productCode=${pd.productCode }&projectCode=${pd.projectCode }&flowName=${pd.flowName }&tempTaskName=${pd.tempTaskName }&show=${pd.show }&showDept=${pd.showDept }&loadType=${pd.loadType }&deptCode=${pd.deptCode }&empCode=${pd.empCode }&currentPage=${pd.currentPage }">
            <img src="static/app/images/left.png"/></a>
    </div>
    修改时间
</div>
<div id="normal" class="normal" style="width: 100%;">
    <div style="right:5px;">
        <div>
            <c:if test="${taskStatus=='YW_CG' }">
                <a class="btn btn-mini btn-info" onclick="add();"
                   style="float:right;margin-right:5px;">新增</a>
                <a class="btn btn-mini btn-danger" onclick="del();"
                   style="float:right;margin-right:5px;">删除</a>
                <a class="btn btn-mini btn-info" onclick="save();"
                   style="float:right;margin-right:5px;">保存</a>
            </c:if>
        </div>
    </div>
</div>
<div id="normal" class="normal" style="width: 100%;">
    <input type="hidden" name="ID" id="ID" value='${pd.ID}'/>
    <input type="hidden" name="detail_id" id="detail_id" value='${pd.detail_id}'/>
    <input type="hidden" name="daily_task_id" id="daily_task_id" value='${pd.daily_task_id}'/>
    <input type="hidden" name="date" id="date" value='${pd.Date}'/>
    <input type="hidden" name="pdInfo" id="pdInfo" value='${pd}'/>
    <!-- 列表开始 -->
    <table class="table table-striped table-bordered table-hover" id="timeTable">
        <thead>
        <tr>
            <th class="center">
                <label><input type="checkbox" id="zcheckbox"/><span class="lbl"></span></label>
            </th>
            <th>开始时间</th>
            <th>结束时间</th>
        </tr>
        </thead>
        <tbody>
        <c:forEach items="${timeList}" var="time" varStatus="vs">
            <tr>
                <td>
                    <label>
                        <input type='checkbox' name='ids'/>
                        <span class='lbl'></span>
                    </label>
                </td>
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


</body>

<!-- 预加载js -->
<script type="text/javascript">
    $(function () {
        if ('${taskStatus}' == 'YW_CG') {
            //时间框
            initDateInput();
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
    $(function () {
        timeArr();
    });

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
        $("#START_TIME_ARR").val(START_TIME_ARR.toString().replace(new RegExp(',', 'gm'), ';'));
        $("#END_TIME_ARR").val(END_TIME_ARR.toString().replace(new RegExp(',', 'gm'), ';'));
    }
</script>
<!-- 行为js -->

<!-- 按钮js -->
<script type="text/javascript">
    //添加新的时间分组
    function add() {
        var shtml = "<tr>";
        shtml += "<td><label><input type='checkbox' name='ids'/><span class='lbl'></span></label></td>";
        shtml += "<td><input type='text' name='start_time' style='width:50%;background:#fff!important;' onchange='changeTime()' class='date-picker' data-date-format='hh:ii' placeholder='请输入时间！' readonly='readonly'/></td>";
        shtml += "<td><input type='text' name='end_time' style='width:50%;background:#fff!important;' onchange='changeTime()' class='date-picker' data-date-format='hh:ii' placeholder='请输入时间！' readonly='readonly'/></td>";
        shtml += "</tr>"
        $("#timeTable tbody").append(shtml);

        initDateInput();
    }

    //删除时间分组
    function del() {
        var objList = document.getElementsByName('ids');
        var status = 'false';
        for (var i = 0; i < objList.length; i++) {
            if (objList[i].checked) {
                status = 'true';
            }
        }
        if (status == 'false') {
            bootbox.alert("您没有勾选任何内容，不能删除");
            $("#zcheckbox").tips({
                side: 3,
                msg: '点这里全选',
                bg: '#AE81FF',
                time: 8
            });

            return;
        } else {
            bootbox.confirm("确定要批量删除吗?", function (result) {
                if (result) {
                    var removeList = new Array();
                    for (var i = 0; i < objList.length; i++) {
                        if (objList[i].checked) {
                            removeList.push($(objList[i]).parents("tr"));
                        }
                    }
                    for (var i = 0; i < removeList.length; i++) {
                        removeList[i].remove();
                    }
                    $("#zcheckbox").attr("checked", false);
                    timeArr();
                    bootbox.hideAll();
                }
            })
        }
    }

    function save() {
        var isChecked = true;
        isChecked = check();
        if (isChecked) {
            var url = '<%=basePath%>app_task/saveDetailChange.do?';
            var param = '&start_time_arrs=' + $("#START_TIME_ARR").val() + '&end_time_arrs=' + $("#END_TIME_ARR").val()
                + '&daily_task_id=' + $("#daily_task_id").val()
                + '&detail_id=' + $("#detail_id").val()
                + '&ID=' + $("#ID").val() + '&date=' + $("#date").val();
            window.location.href = url + param;
        } else {
            bootbox.alert("填写起始、结束时间不允许为空！");
        }
    }

    function check() {
        var status = true;
        var startTimeList = document.getElementsByName('start_time');
        var endTimeList = document.getElementsByName('end_time');
        $(startTimeList).each(function () {
            if (null == $(this).val() || "" == $(this).val() || "0" == $(this).val()) {
                $(this).tips({
                    side: 3,
                    msg: '尚未添加时间段！',
                    bg: '#AE81FF',
                    time: 2
                });
                status = false;
            }
            ;
        });
        $(endTimeList).each(function () {
            if (null == $(this).val() || "" == $(this).val() || "0" == $(this).val()) {
                $(this).tips({
                    side: 3,
                    msg: '尚未添加时间段！',
                    bg: '#AE81FF',
                    time: 2
                });
                status = false;
            }
            ;
        });
        return status;
    }
</script>
<!-- 按钮js -->
</html>