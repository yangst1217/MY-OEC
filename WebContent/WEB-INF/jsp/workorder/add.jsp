<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
    String path = request.getContextPath();
    String basePath = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort()
            + path + "/";
%>
<!DOCTYPE html>
<html lang="zh_CN">
<head>
    <base href="<%=basePath%>">
    <meta name="description" content="overview & stats"/>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <link href="static/css/bootstrap.min.css" rel="stylesheet"/>
    <link href="static/css/bootstrap-responsive.min.css" rel="stylesheet"/>
    <link rel="stylesheet" href="static/css/font-awesome.min.css"/>
    <link rel="stylesheet" href="static/css/ace.min.css"/>
    <link rel="stylesheet" href="static/css/ace-responsive.min.css"/>
    <link rel="stylesheet" href="static/css/ace-skins.min.css"/>
    <link rel="stylesheet" href="static/css/font-awesome.min.css"/>
    <link rel="stylesheet" href="plugins/bootstrap-datetimepicker/bootstrap-datetimepicker.min.css"/>
    <style>
        #zhongxin td {
            height: 40px;
        }

        #zhongxin td label {
            text-align: right;
            margin-right: 10px;
        }
    </style>
</head>
<body>
<form action="workOrder/edit.do" name="form1" id="form1" method="post">
    <input type="hidden" name="attachDeptName" id="attachDeptName"/>
    <input type="hidden" name="id" id="id" value="${pd.ID}"/>
    <input type="hidden" id="MAIN_EMP_ID" name="MAIN_EMP_ID" value="${pd.MAIN_EMP_ID}">
    <input type="hidden" id="CHECK_PERSON" name="CHECK_PERSON" value="${pd.CHECK_PERSON}">
    <input type="hidden" name="DEPT_ID" id="DEPT_ID" value="${pd.DEPT_ID}"/>
    <div id="zhongxin" align="center">
        <table>
            <tr>
                <td><span style="color: red;">*</span>任务名称：</td>
                <td><input type="text" name="TASK_NAME" id="TASK_NAME"
                           placeholder="这里输入任务名称" title="任务名称" value="${pd.TASK_NAME}"/></td>
            </tr>
            <tr>
                <td><label>任务描述：</label></td>
                <td><textarea id="TASK_CONTECT"
                              name="TASK_CONTECT">${pd.TASK_CONTECT}</textarea></td>
            </tr>
            <tr>
                <td><span style="color: red;">*</span>开始时间：</td>
                <td><input type="text" name="START_TIME"
                           id="START_TIME" value="${pd.START_TIME}"
                           data-date-format="yyyy-mm-dd hh:ii" placeholder="开始时间"></td>
            </tr>
            <tr>
                <td><span style="color: red;">*</span>结束时间：</td>
                <td><input type="text" name="END_TIME"
                           id="END_TIME" value="${pd.END_TIME}" data-date-format="yyyy-mm-dd hh:ii"
                           placeholder="结束时间"></td>
            </tr>
            <tr>
                <td><span style="color: red;">*</span>完成标准：</td>
                <td>
                    <textarea id="COMPLETION" name="COMPLETION">${pd.COMPLETION}</textarea>
                </td>
            </tr>
            <tr>
                <td><span style="color: red;">*</span>责任部门：</td>
                <td><input value="${pd.DEPT_NAME}" type="text" id="DEPT_NAME"
                           name="DEPT_NAME" readonly="readonly" onclick="deptAndEmp()"/></td>
            </tr>
            <tr>
                <td><span style="color: red;">*</span>责任人：</td>
                <td><input value="${pd.MAIN_EMP_NAME}" type="text"
                           id="MAIN_EMP_NAME" name="MAIN_EMP_NAME" readonly="readonly"/></td>
            </tr>
            <tr>
                <td><span style="color: red;">*</span>是否评价：</td>
                <td>
                    <select name="NEED_CHECK" id="NEED_CHECK" data-placeholder="请选择是否评价">
                        <option value="">请选择是否评价</option>
                        <option value="0" <c:if test="${0 == pd.NEED_CHECK}">selected</c:if>>否</option>
                        <option value="1" <c:if test="${1 == pd.NEED_CHECK}">selected</c:if>>是</option>
                    </select>
                </td>
            </tr>
            <tr id="checkContainer">
                <td><label>评价人：</label></td>
                <td><input value="${pd.EMP_NAME}" type="text" id="EMP_NAME"
                           name="EMP_NAME" readonly="readonly" onclick="deptAndEmp1()"/></td>
            </tr>
            <tr>
                <td colspan="2" style="text-align: center;"><a
                        class="btn btn-mini btn-primary" onclick="checkCode();">确定</a> <a
                        class="btn btn-mini btn-danger" onclick="top.Dialog.close();">取消</a>
                </td>
            </tr>
        </table>
    </div>
</form>
<div id="zhongxin2" class="center" style="display: none">
    <img src="static/images/jzx.gif" style="width: 50px;"/><br/>
    <h4 class="lighter block green"></h4>
</div>
<script type="text/javascript" src="static/js/jquery-1.7.2.js"></script>
<script src="static/js/bootstrap.min.js"></script>
<script src="static/js/ace-elements.min.js"></script>
<script src="static/js/ace.min.js"></script>
<script type="text/javascript" src="static/js/jquery.tips.js"></script>
<script type="text/javascript" src="plugins/bootstrap-datetimepicker/bootstrap-datetimepicker.min.js"></script>
<script type="text/javascript" src="plugins/bootstrap-datetimepicker/bootstrap-datetimepicker.zh-CN.js"></script>
<script type="text/javascript" src="static/js/attention/zDialog/zDrag.js"></script>
<script type="text/javascript" src="static/js/attention/zDialog/zDialog.js"></script>
<script type="text/javascript">
    $(top.changeui());

    //日期框
    $('#START_TIME').datetimepicker({
        language: 'zh-CN',
        minView: 0,
        format: 'yyyy-mm-dd hh:ii',
        autoclose: true,
        endDate: '${param.endDate}'
    });

    $('#END_TIME').datetimepicker({
        language: 'zh-CN',
        minView: 0,
        format: 'yyyy-mm-dd hh:ii',
        autoclose: true,
        endDate: '${param.endDate}'
    });

    $('#START_TIME').datetimepicker().on('changeDate', function (ev) {
        $('#END_TIME').datetimepicker("setStartDate", ev.date);
    });

    $('#END_TIME').datetimepicker().on('changeDate', function (ev) {
        $('#START_TIME').datetimepicker("setEndDate", ev.date);
    });

    //保存
    function save() {
        if ("0" == $("#NEED_CHECK").val()) {
            $("#EMP_NAME").val("");
        }
        $("#form1").submit();
        $("#zhongxin").hide();
        $("#zhongxin2").show();

    }

    function checkCode() {
        if ($("#TASK_CODE").val() == "") {
            $("#TASK_CODE").focus();

        }
        if ($("#TASK_NAME").val() == "") {
            $("#TASK_NAME").focus();
            top.Dialog.alert("任务名称不能为空！");
            return false;
        }

        if ($("#START_TIME").val() == "") {
            $("#START_TIME").focus();
            top.Dialog.alert("开始时间不能为空！");
            return false;
        }

        if ($("#END_TIME").val() == "") {
            $("#END_TIME").focus();
            top.Dialog.alert("完成时间不能为空！");
            return false;
        }

        if ($("#COMPLETION").val() == "") {
            $("#COMPLETION").focus();
            top.Dialog.alert("完成标准不能为空！");
            return false;
        }


        if ($("#DEPT_ID").val() == "") {
            $("#DEPT_ID").focus();
            top.Dialog.alert("责任部门不能为空！");
            return false;
        }

        if ($("#MAIN_EMP_NAME").val() == "") {
            $("MAIN_EMP_NAME").focus();
            top.Dialog.alert("责任人不能为空！");
            return false;
        }

        if ($("#NEED_CHECK").val() == "") {
            $("#NEED_CHECK").focus();
            top.Dialog.alert("评价是否不能为空！");
            return false;
        }

        if ($("#NEED_CHECK").val() == "1") {
            if ($("#CHECK_PERSON").val() == "") {
                $("#CHECK_PERSON").focus();
                top.Dialog.alert("评价人不能为空！");
                return false;
            }
        } else {
            $("#CHECK_PERSON").val(0);
        }

        var id = document.getElementById("id").value;
        top.jzts();

        save();
    }

    function deptAndEmp() {
        var url = '';
        url += '<%=basePath%>/dept/deptAndEmp.do?EMP_ID=1&STATUS=2';
        var diag = new top.Dialog();
        diag.Drag = true;
        diag.Title = "部门人员选择";
        diag.URL = url;
        diag.Width = 1050;
        diag.Height = 520;
        diag.ShowOkButton = true;
        diag.ShowCancelButton = false;
        diag.OKEvent = function () {
            $('#DEPT_ID').val(diag.innerFrame.contentWindow.document.getElementById('DEPT_ID').value);
            $('#DEPT_NAME').val(diag.innerFrame.contentWindow.document.getElementById('DEPT_NAME').value);
            $('#MAIN_EMP_NAME').val(diag.innerFrame.contentWindow.document.getElementById('EMP_NAME').value);
            $('#MAIN_EMP_ID').val(diag.innerFrame.contentWindow.document.getElementById('EMP_ID').value);
            diag.close();
        }
        diag.show();
    }

    function deptAndEmp1() {
        var url = '';
        url += '<%=basePath%>/dept/deptAndEmp.do?TARGET_DEPT_ID=' + '&DEPT_ID=';
        url += '&DEPT_NAME=' + '&EMP_NAME=';
        url += '&EMP_ID=1' + '&STATUS=1';
        var diag = new top.Dialog();
        diag.Drag = true;
        diag.Title = "部门人员选择";
        diag.URL = url;
        diag.Width = 1050;
        diag.Height = 520;
        diag.ShowOkButton = true;
        diag.ShowCancelButton = false;
        diag.OKEvent = function () {
            $('#EMP_NAME').val(diag.innerFrame.contentWindow.document.getElementById('EMP_NAME').value);
            $('#CHECK_PERSON').val(diag.innerFrame.contentWindow.document.getElementById('EMP_ID').value);
            diag.close();
        }
        diag.show();
    }

    $("#NEED_CHECK").change(function () {
        var chkflag = 0;
        if ("0" == $("#NEED_CHECK").val()) {
            $("#checkContainer").hide();
        } else {
            $("#checkContainer").show();
            chkflag = 1;
        }
    });

</script>
</body>
</html>