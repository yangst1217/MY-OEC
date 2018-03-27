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
    <!-- 下拉框 -->
    <link rel="stylesheet" href="static/css/ace.min.css"/>
    <link rel="stylesheet" href="static/css/ace-skins.min.css"/>
    <link rel="stylesheet" href="static/css/chosen.css"/>

    <script src="static/js/ace.min.js"></script>
    <script type="text/javascript" src="static/js/bootstrap.min.js"></script>
    <script type="text/javascript" src="plugins/JQuery/jquery.min.js"></script>
    <script type="text/javascript" src="plugins/chosen/chosen.jquery.min.js"></script>
</head>
<body style="width:100%,height:100%">
<form action="cproject/submitAcceptance.do" name="cprojectForm" id="cprojectForm" method="post">
    <input type="hidden" name="id" id="id" value="${id}"/>
    <div id="zhongxin">
        <table style="margin: 10px auto;">
            <tr>
                <td>
                    <select multiple class="chzn-select" data-placeholder="点击选择验收人" name="empCodes" id="empCodes"
                            style="width:230px">
                        <option value=""></option>
                        <c:forEach items="${empCodes}" var="empcode">
                            <option value="${empcode.EMP_CODE }">${empcode.EMP_NAME }</option>
                        </c:forEach>
                    </select>
                </td>
            </tr>
            <tr>
                <td><br></br></td>
            </tr>
            <tr>
                <td><br></br></td>
            </tr>
            <tr>
                <td style="text-align: center;" colspan="4">
                    <a class="btn btn-mini btn-primary" onclick="save();">保存</a>
                    <a class="btn btn-mini btn-danger" onclick="top.Dialog.close();">取消</a>
                </td>
            </tr>
        </table>
    </div>
</form>
<script type="text/javascript">
    $(function () {
        $(".chzn-select").chosen({
            no_results_text: "没有匹配结果",
            disable_search: true
        });
    });

    function save() {
        if (checkInput("id", "请选择验收人")) {
            $("#cprojectForm").submit();
        }
    }

    //检查输入项
    function checkInput(id, msg) {
        var input = $("#" + id).val();
        if (input == null || $.trim(input) == "") {
            $("#" + id).tips({
                side: 3,
                msg: msg,
                bg: '#AE81FF',
                time: 2
            });

            $("#" + id).focus();
            return false;
        }
        return true;
    }
</script>
</body>
</html>