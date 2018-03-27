<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
    String path = request.getContextPath();
    String basePath = request.getScheme() + "://"
            + request.getServerName() + ":" + request.getServerPort()
            + path + "/";
%>

<!DOCTYPE HTML>
<html>
<head>
    <base href="<%=basePath%>">
    <%@ include file="../../system/admin/top.jsp" %>
    <title>修改</title>
    <script type="text/javascript">
        window.jQuery
        || document
            .write("<script src='static/js/jquery-1.9.1.min.js'>\x3C/script>");
    </script>
    <script src="static/js/bootstrap.min.js"></script>
    <script src="static/js/ace-elements.min.js"></script>
    <script src="static/js/ace.min.js"></script>
    <script type="text/javascript" src="static/js/chosen.jquery.min.js"></script>
    <!-- 下拉框 -->
    <script type="text/javascript" src="static/js/bootbox.min.js"></script>
    <!-- 确认窗口 -->
    <script type="text/javascript" src="static/js/jquery.tips.js"></script>
    <!--提示框-->
    <style>
        #targetForm #zhongxin table tr label {
            margin-top: 7px;
        }

        #targetForm #zhongxin table tr input {
            margin-top: 7px;
        }

        #targetForm #zhongxin table tr select {
            margin-top: 7px;
        }

        #targetForm #zhongxin table tr textarea {
            margin-top: 7px;
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
<form action="payment/edit.do" name="targetForm" id="targetForm"
      method="post">
    <input type="hidden" name="ID" id="ID" value="${pd.ID}"/>
    <div id="zhongxin">
        <table style="margin-left: 40px;">
            <tr>
                <td><label><span style="color: red;">*</span>编号:</label></td>
                <td><input value="${pd.CODE }" type="text" id="CODE"
                           name="CODE" style="background:#fff!important;" maxlength="50"/></td>
            </tr>
            <tr>
                <td><label><span style="color: red;">*</span>名称:</label></td>
                <td><input value="${pd.NAME }" type="text" id="NAME"
                           name="NAME" style="background:#fff!important;" maxlength="50"/></td>
            </tr>
            <tr>
                <td><label><span style="color: red;">*</span>类型:</label></td>
                <td>
                    <select id="TYPE" name="TYPE">
                        <option value="">请选择</option>
                        <option value="1" <c:if test="${1 == pd.TYPE}">selected</c:if>>基础项</option>
                        <option value="2" <c:if test="${2 == pd.TYPE}">selected</c:if>>运算符</option>
                    </select>
                </td>
            </tr>
        </table>
    </div>
    <br/>
    <br/>
    <!--按钮组-->
    <div style="text-align: center;">
        <a class="btn btn-mini btn-primary" onclick="save();">保存</a>&nbsp; <a
            class="btn btn-mini btn-danger" onclick="top.Dialog.close();">取消</a>
    </div>
</form>
<script type="text/javascript">
    function save() {
        if (null == $("#CODE").val() || "" == $("#CODE").val()) {
            $("#CODE").tips({
                side: 3,
                msg: "请填写编码!",
                bg: "#AE81FF",
                time: 2
            });
            $("#CODE").focus();
            return false;
        }
        if (null == $("#NAME").val() || "" == $("#NAME").val()) {
            $("#NAME").tips({
                side: 3,
                msg: "请填写名称!",
                bg: "#AE81FF",
                time: 2
            });
            $("#NAME").focus();
            return false;
        }
        if ("" == $("#TYPE").val()) {
            $("#TYPE").tips({
                side: 3,
                msg: "请选择类型!",
                bg: "#AE81FF",
                time: 2
            });
            $("#TYPE").focus();
            return false;
        }
        $("#targetForm").submit();
    }
</script>
</body>
</html>
