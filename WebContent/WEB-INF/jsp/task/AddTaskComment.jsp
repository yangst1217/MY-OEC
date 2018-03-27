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

    <style>

        #zhongxin td {
            height: 40px;
        }

        #zhongxin td label {
            width: 100px;
            text-align: right;
        }

    </style>

    <!-- 引入 -->
    <script type="text/javascript">window.jQuery || document.write("<script src='static/js/jquery-1.9.1.min.js'>\x3C/script>");</script>
    <script src="static/js/bootstrap.min.js"></script>
    <script src="static/js/ace-elements.min.js"></script>
    <script src="static/js/ace.min.js"></script>

    <!--提示框-->
    <script type="text/javascript" src="static/js/jquery.tips.js"></script>

    <script type="text/javascript">
        $(top.changeui());

        //保存
        function save() {
            if (null == $("#comment").val() || $("#comment").val() == "") {
                $("#comment").tips({
                    side: 3,
                    msg: '不能为空',
                    bg: '#AE81FF',
                    time: 2
                });
                $("#comment").focus();
                return false;
            }
            $("#Form").submit();
            $("#zhongxin").hide();
        }

    </script>
</head>
<body>
<form action="<%=basePath%>empDailyTask/saveTaskComment.do" name="Form" id="Form" method="post">
    <input type="hidden" name="weekTaskId" value="${pd.weekTaskId }">
    <div id="zhongxin" style="margin:20px auto;">
        <table>
            <tr>
                <td><label>批示内容：</label></td>
                <td><textarea id="comment" name="comment" rows="4" cols="2" maxlength="255"></textarea></td>
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

</body>
</html>