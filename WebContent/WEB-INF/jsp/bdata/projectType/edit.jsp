<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
    String path = request.getContextPath();
    String basePath = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort() + path + "/";
%>
<!DOCTYPE html>
<html lang="zh_CN">
<head>
    <base href="<%=basePath%>">
    <meta charset="utf-8"/>
    <title></title>
    <meta name="description" content="overview & stats"/>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <link href="static/css/bootstrap.min.css" rel="stylesheet"/>
    <link href="static/css/bootstrap-responsive.min.css" rel="stylesheet"/>
    <link rel="stylesheet" href="static/css/font-awesome.min.css"/>
    <link rel="stylesheet" href="static/css/ace.min.css"/>
    <link rel="stylesheet" href="static/css/ace-responsive.min.css"/>
    <link rel="stylesheet" href="static/css/ace-skins.min.css"/>
    <script type="text/javascript" src="static/js/jquery-1.7.2.js"></script>
    <script type="text/javascript" src="static/js/jquery.tips.js"></script>
    <style>
        input[type="checkbox"], input[type="radio"] {
            opacity: 1;
            position: static;
            height: 25px;
            margin-bottom: 10px;
        }

        #zhongxin td {
            height: 40px;
        }

        #zhongxin td label {
            text-align: right;
            margin-right: 10px;
        }
    </style>
    <script type="text/javascript">
        $(function () {
            showCheckPerson();
            $("input[name=ISCHECK]").click(function () {
                showCheckPerson();
            });
        });

        function showCheckPerson() {
            switch ($("input[name=ISCHECK]:checked").attr("value")) {
                case "1":
                    //alert("one");
                    $("#checkPersonTr").show();

                    break;
                case "0":
                    $("#checkPersonTr").hide();
                    $("#EMP_NAME").val("");
                    $("#CHECK_PERSON_ID").val("");
                    break;
                default:
                    break;
            }
        }
    </script>
</head>
<body>
<form action="projectType/${msg}.do" name="completeForm" id="completeForm" method="post">
    <input type="hidden" name="ID" id="ID" value="${pd.ID }"/>
    <input type="hidden" name="CHECK_PERSON_ID" id="CHECK_PERSON_ID" value="${pd.CHECK_PERSON_ID }"/>
    <div id="zhongxin">
        <table style="margin:20px auto;">
            <tr>
                <td><span style="color: red;">*</span>项目类型名称：</td>
                <td><input type="text" name="TYPE_NAME" id="TYPE_NAME" value="${pd.TYPE_NAME }" maxlength="32"/></td>
            </tr>
            <tr>
                <td><span style="color: red;">*</span>项目节点层级结构：</td>
                <td><select class="select" name="PROJECT_NODE_LEVEL_FRAME_ID" id="PROJECT_NODE_LEVEL_FRAME_ID"
                            value="${pd.PROJECT_NODE_LEVEL_FRAME_ID }" data-placeholder="请选择结构"
                            style="vertical-align:top;z-index:999">
                    <c:forEach items="${frameList}" var="frame">
                        <option value="${frame.ID }"
                                <c:if test="${pd.PROJECT_NODE_LEVEL_FRAME_ID==frame.ID }">selected</c:if>>${frame.LEVEL_FRAME }</option>
                    </c:forEach>
                </select></td>
            </tr>
            <tr>
                <td><span style="color: red;">*</span>是否需要审批：</td>
                <td><input type="radio" name="ISCHECK" id="ISCHECK" value="1"
                           <c:if test="${pd.ISCHECK == 1 || msg == 'add'}">checked="checked"</c:if>>是
                    <input type="radio" name="ISCHECK" id="ISCHECK" value="0"
                           <c:if test="${pd.ISCHECK == 0}">checked="checked"</c:if>>否
            </tr>
            <tr id="checkPersonTr">
                <td><span style="color: red;">*</span>审批人：</td>
                <td><input type="text" name="EMP_NAME" id="EMP_NAME" value="${pd.EMP_NAME }" maxlength="32"
                           onclick="deptAndEmp()"/></td>
            </tr>
            <tr>
                <td colspan="2" style="text-align: center;">
                    <a class="btn btn-mini btn-primary" onclick="save();">保存</a>
                    <a class="btn btn-mini btn-danger" onclick="top.Dialog.close();">取消</a>
                </td>
            </tr>
        </table>
    </div>

    <div id="zhongxin2" class="center" style="display:none"><br/><br/><br/><br/><img
            src="static/images/jiazai.gif"/><br/><h4 class="lighter block green"></h4></div>

</form>

<!-- 引入 -->
<script src="static/js/bootstrap.min.js"></script>
<script src="static/js/ace-elements.min.js"></script>
<script src="static/js/ace.min.js"></script>
<script type="text/javascript" src="static/js/jquery.tips.js"></script><!--提示框-->
<script type="text/javascript">
    $(top.changeui());
    $(document).ready(function () {
        if ($("#user_id").val() != "") {
            $("#loginname").attr("readonly", "readonly");
            $("#loginname").css("color", "gray");
        }
    });

    //保存
    function save() {
        if ($("#TYPE_NAME").val().trim() == "") {
            $("#TYPE_NAME").tips({
                side: 3,
                msg: '请输入项目类型名称',
                bg: '#AE81FF',
                time: 3
            });
            $("#TYPE_NAME").focus();
            return false;
        }
        if ($("#PROJECT_NODE_LEVEL_FRAME_ID").val() == "") {
            $("#PROJECT_NODE_LEVEL_FRAME_ID").tips({
                side: 3,
                msg: '请选择节点层次结构',
                bg: '#AE81FF',
                time: 3
            });
            $("#PROJECT_NODE_LEVEL_FRAME_ID").focus();
            return false;
        }
        if ($("input[name=ISCHECK]:checked").attr("value") == "1") {
            if ($("#CHECK_PERSON_ID").val() == "" || $("#CHECK_PERSON_ID").val() == "undefined") {
                $("#EMP_NAME").tips({
                    side: 3,
                    msg: '请选择审批人',
                    bg: '#AE81FF',
                    time: 3
                });
                $("#EMP_NAME").focus();
                return false;
            }
        }

        $("#completeForm").submit();
        $("#zhongxin").hide();
    }

    function deptAndEmp() {
        var url = '';
        url += '<%=basePath%>/dept/deptAndEmp.do?TARGET_DEPT_ID=&DEPT_ID=';
        url += $('#id').val() + '&DEPT_NAME=' + $('#dept_name').val() + '&EMP_NAME=';
        url += $('#DEPT_LEADER_NAME').val() + '&EMP_ID=' + $('#DEPT_LEADER_ID').val() + '&STATUS=1';
        var diag = new top.Dialog();
        diag.Drag = true;
        diag.Title = "选择审批人";
        diag.URL = url;
        diag.Width = 1050;
        diag.Height = 520;
        diag.ShowOkButton = true;
        diag.ShowCancelButton = false;
        diag.OKEvent = function () {
            if (diag.innerFrame.contentWindow.document.getElementById('EMP_NAME').value != "undefined") {
                $('#EMP_NAME').val(diag.innerFrame.contentWindow.document.getElementById('EMP_NAME').value);
                $('#CHECK_PERSON_ID').val(diag.innerFrame.contentWindow.document.getElementById('EMP_ID').value);
            }
            diag.close();
        }
        diag.show();
    }

    function trimStr(str) {
        return str.replace(/(^\s*)|(\s*$)/g, "");
    }
</script>

</body>
</html>