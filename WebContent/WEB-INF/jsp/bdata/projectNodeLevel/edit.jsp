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

</head>
<body>
<form action="projectNodeLevel/${msg}.do" name="completeForm" id="completeForm" method="post">
    <input type="hidden" name="ID" id="ID" value="${pd.ID }"/>
    <div id="zhongxin">
        <table style="margin:20px auto;">
            <tr>
                <td><label>节点层级名称：</label></td>
                <td><input type="text" name="NODE_LEVEL" id="NODE_LEVEL" value="${pd.NODE_LEVEL }" maxlength="32"/></td>
            </tr>
            <tr>
                <td colspan="2" style="text-align: center;">
                    <a class="btn btn-mini btn-primary" onclick="save();">保存</a>
                    <a class="btn btn-mini btn-danger" onclick="top.Dialog.close();">取消</a>
                </td>
            </tr>
        </table>
    </div>
</form>
<script type="text/javascript" src="static/js/jquery-1.7.2.js"></script>
<script type="text/javascript" src="static/js/jquery.tips.js"></script>
<script src="static/js/bootstrap.min.js"></script>
<script src="static/js/ace-elements.min.js"></script>
<script src="static/js/ace.min.js"></script>
<script type="text/javascript" src="static/js/bootbox.min.js"></script><!-- 确认窗口 -->
<script type="text/javascript">
    $(top.changeui());

    //保存
    function save() {
        if ($("#NODE_LEVEL").val().trim() == "") {
            $("#NODE_LEVEL").tips({
                side: 3,
                msg: '请输入节点层级名称',
                bg: '#AE81FF',
                time: 3
            });
            $("#NODE_LEVEL").focus();
            return false;
        }
        $("#completeForm").submit();
        $("#zhongxin").hide();
    }
</script>
</body>
</html>