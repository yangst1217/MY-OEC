<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<%
    String path = request.getContextPath();
    String basePath = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort() + path + "/";
%>
<!DOCTYPE html>
<html>
<head>
    <title>修改目标数量</title>
    <base href="<%=basePath%>">
    <!-- jsp文件头和头部 -->
    <%@ include file="../../system/admin/top.jsp" %>
    <link href="static/css/style.css" rel="stylesheet"/>
    <link type="text/css" rel="stylesheet" href="plugins/zTree/zTreeStyle.css"/>

    <!-- 引入 -->
    <script type="text/javascript">window.jQuery || document.write("<script src='static/js/jquery-1.9.1.min.js'>\x3C/script>");</script>
    <script src="static/js/bootstrap.min.js"></script>
    <script src="static/js/ace-elements.min.js"></script>
    <script src="static/js/ace.min.js"></script>

    <script type="text/javascript" src="static/js/chosen.jquery.min.js"></script><!-- 下拉框 -->
    <script type="text/javascript" src="static/js/bootstrap-datepicker.min.js"></script><!-- 日期框 -->
    <script type="text/javascript" src="static/js/bootbox.min.js"></script><!-- 确认窗口 -->
    <script type="text/javascript" src="static/js/jquery.tips.js"></script><!--提示框-->
    <script type="text/javascript" src="plugins/zTree/jquery.ztree-2.6.min.js"></script>
    <script type="text/javascript" src="static/deptTree/deptTree.js"></script>
    <!-- 引入 -->

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
<form action="byeartarget/editCount.do" name="Form" id="Form" method="post">
    <input type="hidden" value="${resultpd.ID}" id="TARGET_ID" name="TARGET_ID">
    <input type="hidden" value="${resultpd.COUNT}" id="OLD_COUNT" name="OLD_COUNT">
    <div id="zhongxin">
        <table style="margin-left: 50px;"><br>
            <tr>
                <td>
                    <label><span style="color: red; ">*</span>目标数量/金额：</label>
                </td>
                <td>
                    <input onchange="checkNum($(this));"
                           value="${resultpd.COUNT}" type="text" id="COUNT" name="COUNT"
                           placeholder="只可填入两位小数！"/>
                </td>
            </tr>
        </table>
    </div>
    <br/><br/>
    <!--按钮组-->
    <div style="text-align: center;">
        <a class="btn btn-mini btn-primary" onclick="save();">保存</a>&nbsp;
        <a class="btn btn-mini btn-danger" onclick="top.Dialog.close();">取消</a>
    </div>
    <!--按钮组-->
</form>
</body>

<!-- 行为js -->
<script type="text/javascript">

    //检验是否是数字
    function checkNum($obj) {
        if (!(/^(([1-9]\d*)|0)(\.\d{1,2})?$/).test($obj.val())) {
            $obj.tips({
                side: 3,
                msg: '只可填入两位小数',
                bg: '#AE81FF',
                time: 2
            });
            $obj.focus();
            $obj.val("");
        }
    }

</script>
<!-- 行为js -->

<!-- 按钮功能 -->
<script type="text/javascript">
    //保存
    function save() {

        var cycleCheck = /^(([1-9]\d*)|0)(\.\d{1,2})?$/;
        if ($("#COUNT").val() == "" || !cycleCheck.test($("#COUNT").val())) {
            $("#COUNT").tips({
                side: 3,
                msg: '请正确填写目标数目',
                bg: '#AE81FF',
                time: 2
            });
            $("#COUNT").focus();
            return false;
        }
        $("#Form").submit();
    };
</script>
<!-- 按钮功能 -->
</html>
