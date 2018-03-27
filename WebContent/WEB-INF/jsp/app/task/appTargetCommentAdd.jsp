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

    <title>日清批示新增</title>
    <meta name="description" content="overview & stats"/>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <link href="static/css/bootstrap.min.css" rel="stylesheet"/>
    <link href="static/css/bootstrap-responsive.min.css" rel="stylesheet"/>
    <link rel="stylesheet" href="static/css/font-awesome.min.css"/>

    <link rel="stylesheet" href="static/css/ace.min.css"/>
    <link rel="stylesheet" href="static/css/ace-responsive.min.css"/>
    <link rel="stylesheet" href="static/css/ace-skins.min.css"/>

    <script type="text/javascript" src="static/js/jquery-1.7.2.js"></script>

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

        /*设置自适应框样式*/
        .test_box {
            width: 220px;
            min-height: 22px;
            _height: 120px;
            padding: 4px 6px;
            outline: 0;
            border: 1px solid #d5d5d5;
            font-size: 12px;
            word-wrap: break-word;
            overflow-x: hidden;
            overflow-y: auto;
            _overflow-y: visible;
        }
    </style>

    <!-- 引入 -->
    <script type="text/javascript" src="static/js/jquery-1.7.2.js"></script>
    <script src="static/js/bootstrap.min.js"></script>
    <script src="static/js/ace-elements.min.js"></script>
    <script src="static/js/ace.min.js"></script>
    <script type="text/javascript" src="static/js/chosen.jquery.min.js"></script>
    <script type="text/javascript" src="static/js/jquery-form.js"></script>
    <!--提示框-->
    <script type="text/javascript" src="static/js/jquery.tips.js"></script>
    <script type="text/javascript">
        if ("ontouchend" in document) document.write("<script src='static/js/jquery.mobile.custom.min.js'>" + "<" + "/script>");
    </script>

    <script type="text/javascript">
        //检查长度是否超出
        function checkVal(divId, inputId, length, setVal) {
            var val = $(divId).text();
            if (val.length > length) {
                $(divId).tips({
                    side: 3,
                    msg: '长度不能超过' + length + '，请重新填写!',
                    bg: '#AE81FF',
                    time: 1
                });
                $(divId).focus();
            } else if (setVal) {
                $(inputId).attr("value", val);
            }
            return val.length > length;
        }

        //保存
        function save() {
            //检查说明输入的字符是否过长
            if (checkVal('#divComment', '#comment', 255, true)) {
                return;
            }
            var commentEmpty = $("#comment").val() == "" || $("#comment").val() == null;
            if (commentEmpty) {
                $("#divComment").tips({
                    side: 3,
                    msg: '不能为空',
                    bg: '#AE81FF',
                    time: 2
                });
                $("#divComment").focus();
                return false;
            }
            var options = {
                success: function (data) {
                    $("#zhongxin").hide();
                    var url = '<%=basePath%>app_task/listBusinessEmpTask.do?showDept=1&show=${pd.show}&loadType=${pd.loadType}&weekEmpTaskId=${pd.weekTaskId}';
                    window.location.href = url;
                },
                error: function (data) {
                    alert("保存出错")
                }
            };
            $("#Form").ajaxSubmit(options);
        }

    </script>
</head>
<body>
<div class="web_title">
    <div class="back" style="top:5px">
        <a href="<%=basePath%>app_task/listBusinessEmpTask.do?showDept=1&show=${pd.show}&loadType=${pd.loadType}&weekEmpTaskId=${pd.weekTaskId}">
            <img src="static/app/images/left.png"/></a>
    </div>
    日清批示新增
</div>
<form action="<%=basePath%>app_task/saveTargetComment.do" name="Form" id="Form" method="post">
    <input type="hidden" name="weekTaskId" value="${pd.weekTaskId }">
    <div id="zhongxin" style="width:98%; margin:0 auto; ">
        <table style="margin: 10px auto; width:98%; ">
            <tr>
                <td style="width:80px"><label>批示内容：</label></td>
                <td>
                    <input type="hidden" name="comment" id="comment" placeholder="这里输入差异分析"/>
                    <div id="divComment" class="test_box" contenteditable="true"
                         onkeyup="checkVal('#divComment', '#comment', 255, false)"></div>
                </td>
            </tr>
            <tr>
                <td colspan="2" style="text-align: center;">
                    <a class="btn btn-mini btn-primary" onclick="save();">保存</a>
                </td>
            </tr>
        </table>
    </div>
    <div id="zhongxin2" class="center" style="display:none"><br/><br/><br/><br/><br/><img
            src="static/images/jiazai.gif"/><br/><h4 class="lighter block green">提交中...</h4></div>

    <div>
        <%@include file="../footer.jsp" %>
    </div>

</form>
</body>
</html>