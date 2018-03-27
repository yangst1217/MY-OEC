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
    <script type="text/javascript" src="static/js/jquery-1.7.2.js"></script>
    <script type="text/javascript" src="static/js/jquery.tips.js"></script>
    <script type="text/javascript">
        top.changeui();

        //保存
        function save() {
            if ($("#levelFrame").val() == ""
                || trimStr($("#levelFrame").val()) == "") {
                $("#levelFrame").tips({
                    side: 3,
                    msg: '请输入',
                    bg: '#AE81FF',
                    time: 2
                });
                $("#levelFrame").focus();
                return false;
            } else {
                $("#form1").submit();
                $("#zhongxin").hide();
                $("#zhongxin2").show();
            }

        }

        function trimStr(str) {
            return str.replace(/(^\s*)|(\s*$)/g, "");
        }
    </script>
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
<form action="nodeLevelFrame/add.do" name="form1" id="form1" method="post">
    <div id="zhongxin" align="center" style="margin-top: 20px;">
        <table>
            <tr>
                <td><span style="color: red;">*</span>节点层级结构：</td>
                <td><input type="text" name="levelFrame" id="levelFrame"
                           placeholder="这里输入节点层级结构名称" maxlength="255" title="节点层级结构"/></td>
            </tr>
            <tr>
                <td><label>描述：</label></td>
                <td><input type="text" name="descp" id="descp"
                           placeholder="这里输入描述" maxlength="255" title="描述"/></td>
            </tr>
            <tr>
                <td colspan="2" style="text-align: center;"><a
                        class="btn btn-mini btn-primary" onclick="save();">保存</a> <a
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
</body>
</html>