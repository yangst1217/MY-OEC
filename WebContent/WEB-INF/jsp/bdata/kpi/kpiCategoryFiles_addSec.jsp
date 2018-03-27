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
<form action="kpiCategoryFiles/${msg}.do" name="kpicategoryForm" id="kpicategoryForm" method="post">
    <input type="hidden" name="ID" id="id" value="${pd.ID }"/>
    <div id="zhongxin">
        <table style="margin:10px auto;"><br>
            <tr>
                <td>
                    <label>KPI类别编号：</label>
                </td>
                <td>
                    <input type="text" name="CODE" id="code" value="${pd.CODE }" maxlength="32"
                           placeholder="输入KPI类别编码"/>
                </td>
            </tr>
            <tr>
                <td>
                    <label>KPI类别名称：</label>
                </td>
                <td>
                    <input type="text" name="NAME" id="name" value="${pd.NAME }" maxlength="32"
                           placeholder="输入KPI类别名称"/>
                </td>
            </tr>
            <tr>
                <td>
                    <label>KPI类别描述：</label>
                </td>
                <td>
                    <input type="text" name="REMARKS" id="remarks" value="${pd.REMARKS }" maxlength="32"
                           placeholder="输入KPI类别描述"/>
                </td>
            </tr>
            <tr>
                <td>
                    <label>上一级名称：</label>
                </td>
                <td>
                    <input type="text" name="parentName" id="parentName"
                           value="${pd.parentName }" maxlength="32" placeholder="这里输入上一级名称" title="上一级名称" readonly/>
                </td>
            </tr>
            <input type="hidden" name="PARENT_ID" id="parent_id" value="${pd.ID }"/>
            <!-- <tr>
                <td colspan="2" style="text-align: center;">
                    <a class="btn btn-mini btn-primary" onclick="save();">保存</a>
                    <a class="btn btn-mini btn-danger" onclick="top.Dialog.close();">取消</a>
                </td>
            </tr> -->
        </table>
    </div>
    <div style="text-align: center;">
        <a class="btn btn-mini btn-primary" onclick="save();">保存</a>&nbsp;
        <a class="btn btn-mini btn-danger" onclick="top.Dialog.close();">取消</a>
    </div>
    <!-- <div id="zhongxin2" class="center" style="display:none"><br/><br/><br/><br/>
        <img src="static/images/jiazai.gif" /><br/>
        <h4 class="lighter block green"></h4>
    </div> -->
</form>

<!-- 引入 -->
<script type="text/javascript">window.jQuery || document.write("<script src='static/js/jquery-1.9.1.min.js'>\x3C/script>");</script>
<script src="static/js/bootstrap.min.js"></script>
<script src="static/js/ace-elements.min.js"></script>
<script src="static/js/ace.min.js"></script>
<script type="text/javascript" src="static/js/chosen.jquery.min.js"></script><!-- 下拉框 -->

<script type="text/javascript">
    $(top.changeui());

    //保存
    function save() {
        var codeCheck = /\s/;
        if ($("#code").val() == "" || codeCheck.test($("#code").val())) {
            $("#code").tips({
                side: 3,
                msg: '请正确输入KPI类别编码',
                bg: '#AE81FF',
                time: 2
            });
            $("#code").focus();
            return false;
        }
        if ($("#name").val() == "") {
            $("#name").tips({
                side: 3,
                msg: '请输入KPI类别名称',
                bg: '#AE81FF',
                time: 2
            });
            $("#name").focus();
            return false;
        }

        var url = "<%=basePath%>/kpiCategoryFiles/checkKpiCategory.do?kpiCode=" + $('#code').val();
        $.get(url, function (data) {
            if (data == "true") {
                $("#kpicategoryForm").submit();
            } else {
                alert("该KPI类别编号已存在！");
                top.Dialog.close();
            }
        }, "text");

        $("#zhongxin").hide();
        $("#zhongxin2").show();
    }

</script>

</body>
</html>