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
    <title></title>
    <meta name="description" content="overview & stats"/>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <link href="static/css/bootstrap.min.css" rel="stylesheet"/>
    <link href="static/css/bootstrap-responsive.min.css" rel="stylesheet"/>
    <link rel="stylesheet" href="static/css/font-awesome.min.css"/>
    <!-- 下拉框 -->
    <link rel="stylesheet" href="static/css/chosen.css"/>
    <link rel="stylesheet" href="static/css/ace.min.css"/>
    <link rel="stylesheet" href="static/css/ace-responsive.min.css"/>
    <link rel="stylesheet" href="static/css/ace-skins.min.css"/>
    <script type="text/javascript" src="static/js/jquery-1.7.2.js"></script>
    <!--提示框-->
    <script type="text/javascript" src="static/js/jquery.tips.js"></script>

    <style>
        input[type="checkbox"], input[type="radio"] {
            opacity: 1;
            position: static;
            height: 25px;
            margin-bottom: 10px;
        }

        td > label {
            text-align: right;
            margin-right: 8px;
        }

    </style>
</head>
<body>
<form action="dept/${msg}.do" name="deptForm" id="deptForm" method="post">
    <div id="zhongxin" style="width:350px; margin:10px auto;">
        <input type="hidden" name="PARENT_ID" id="parent_id" value="0" readonly/></td>
        <input type="hidden" name="DEPT_LEADER_ID" id="DEPT_LEADER_ID" value="${pd.DEPT_LEADER_ID }"/>
        <table>
            <tr>
                <td style="height:40px;"><label><span style="color:red">*</span>部门编码：</label></td>
                <td><input type="text" name="DEPT_CODE" id="dept_code" value="" maxlength="32" placeholder="这里输入部门编码"
                           title="部门编码"/></td>
            </tr>
            <tr>
                <td style="height:40px;"><label><span style="color:red">*</span>部门名称：</label></td>
                <td><input type="text" name="DEPT_NAME" id="dept_name" value="" maxlength="32" placeholder="这里输入部门名称"
                           title="部门名称"/></td>
            </tr>
            <tr>
                <td style="height:40px;"><label><span style="color:red">*</span>部门标识：</label></td>
                <td><input type="text" name="DEPT_SIGN" id="dept_sign" value="" maxlength="32" placeholder="这里输入部门标识"
                           title="部门标识"/></td>
            </tr>
            <tr>
                <td style="height:40px;"><label>部门负责人：</label></td>
                <td><input value="${pd.DEPT_LEADER_NAME}" type="text" name="DEPT_LEADER_NAME" id="DEPT_LEADER_NAME"
                           style="background:white!important;" readonly="readonly" onclick="deptAndEmp()"/>
            </tr>
            <tr>
                <td style="height:40px;"><label><span style="color:red">*</span>排序：</label></td>
                <td><input type="number" name="ORDER_NUM" id="order_num" placeholder="这里输入序号" value="${pd.ORDER_NUM}"
                           title="序号"/></td>
            </tr>
            <tr>
                <td style="height:40px;"><label>部门职能：</label></td>
                <td><select name="FUNCTION" id="FUNCTION" data-placeholder="部门职能">
                    <c:forEach items="${functionList}" var="function">
                        <option value="${function.BIANMA}">${function.NAME}</option>
                    </c:forEach>
                </select>
                </td>
            </tr>
            <tr>
                <td style="height:40px;"><label>部门地域：</label></td>
                <td><select name="AREA" id="AREA" data-placeholder="部门地域">
                    <c:forEach items="${areaList}" var="area">
                        <option value="${area.BIANMA}">${area.NAME}</option>
                    </c:forEach>
                </select>
                </td>
            </tr>
            <tr>
                <td style="height:40px;"><label>是否为预算部门：</label></td>
                <td><input type="radio" name="IS_FUNCTIONAL_DEPT" value="1" checked="checked">是
                    <input type="radio" name="IS_FUNCTIONAL_DEPT" value="0">否
            </tr>
            <tr>
                <td style="height:40px;"><label>是否为编制部门：</label></td>
                <td><input type="radio" name="IS_PREPARE_DEPT" value="1" checked="checked">是
                    <input type="radio" name="IS_PREPARE_DEPT" value="0">否
            </tr>
            <tr>
                <td style="height:40px;"><label>是否启用：</label></td>
                <td><input type="radio" name="ENABLED" value="1" checked="checked">是
                    <input type="radio" name="ENABLED" value="0">否
            </tr>
            <tr>
                <td colspan="2" style="text-align: center;">
                    <a class="btn btn-mini btn-primary" onclick="check();">保存</a>
                    <a class="btn btn-mini btn-danger" onclick="top.Dialog.close();">取消</a>
                </td>
            </tr>
        </table>
    </div>

    <div id="zhongxin2" class="center" style="display:none"><br/><br/><br/><br/><img
            src="static/images/jiazai.gif"/><br/><h4 class="lighter block green"></h4></div>

</form>

<!-- 引入 -->
<script type="text/javascript">window.jQuery || document.write("<script src='static/js/jquery-1.9.1.min.js'>\x3C/script>");</script>
<script src="static/js/bootstrap.min.js"></script>
<script src="static/js/ace-elements.min.js"></script>
<script src="static/js/ace.min.js"></script>
<script type="text/javascript" src="static/js/chosen.jquery.min.js"></script><!-- 下拉框 -->

<script type="text/javascript">
    $(top.changeui());
    $(document).ready(function () {
        if ($("#user_id").val() != "") {
            $("#loginname").attr("readonly", "readonly");
            $("#loginname").css("color", "gray");
        }
    });

    //保存
    function check() {

        if ($("#dept_name").val() == "") {

            $("#dept_name").tips({
                side: 3,
                msg: '请输入部门名称',
                bg: '#AE81FF',
                time: 3
            });
            $("#dept_name").focus();
            return false;
        }

        if ($("#dept_sign").val() == "") {

            $("#dept_sign").tips({
                side: 3,
                msg: '请输入部门标识',
                bg: '#AE81FF',
                time: 3
            });
            $("#dept_sign").focus();
            return false;
        }

        if ($("#order_num").val() == "") {

            $("#order_num").tips({
                side: 3,
                msg: '请输入排序',
                bg: '#AE81FF',
                time: 3
            });
            $("#order_num").focus();
            return false;
        }
        //判断编码和标识是否是否
        var deptCode = $('#dept_code').val();
        var deptSign = $('#dept_sign').val();
        var url = "<%=basePath%>/dept/checkCodeAndSign.do?deptCode=" + deptCode + "&deptSign=" + deptSign;
        $.get(url, function (data) {
            if (data == "0") {
                save();
            } else {
                alert("编码和标识不能重复，请重新输入");
                return false;
            }
        }, "text");
    }

    function save() {
        $("#deptForm").submit();
        $("#zhongxin").hide();
    }

    function deptAndEmp() {
        var url = '';
        url += '<%=basePath%>/dept/deptAndEmp.do?TARGET_DEPT_ID=&DEPT_ID=';
        url += $('#id').val() + '&DEPT_NAME=' + $('#dept_name').val() + '&EMP_NAME=';
        url += $('#DEPT_LEADER_NAME').val() + '&EMP_ID=' + $('#DEPT_LEADER_ID').val() + '&STATUS=1';
        var diag = new top.Dialog();
        diag.Drag = true;
        diag.Title = "选择责任人";
        diag.URL = url;
        diag.Width = 1050;
        diag.Height = 520;
        diag.ShowOkButton = true;
        diag.ShowCancelButton = false;
        diag.OKEvent = function () {
            $('#DEPT_LEADER_NAME').val(diag.innerFrame.contentWindow.document.getElementById('EMP_NAME').value);
            $('#DEPT_LEADER_ID').val(diag.innerFrame.contentWindow.document.getElementById('EMP_ID').value);
            diag.close();
        }
        diag.show();
    }

    $(function () {

        //单选框
        $(".chzn-select").chosen();
        $(".chzn-select-deselect").chosen({allow_single_deselect: true});

    });

</script>

</body>
</html>