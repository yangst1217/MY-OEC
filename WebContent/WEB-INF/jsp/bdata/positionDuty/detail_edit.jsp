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

    <link rel="stylesheet" href="static/css/datepicker.css"/><!-- 日期框 -->
    <script type="text/javascript" src="static/js/jquery-1.7.2.js"></script>
    <script type="text/javascript" src="static/js/jquery.tips.js"></script>

</head>
<body>
<fmt:requestEncoding value="UTF-8"/>
<form action="positionDuty/${msg}.do" name="Form" id="Form" method="post">
    <input type="hidden" name="ID" id="ID" value="${pd.ID}"/>
    <input type="hidden" name="msg" id="msg" value="${msg}"/>
    <input type="hidden" name="responsibility_id" id="responsibility_id" value="${pd.responsibility_id}"/>
    <input type="hidden" id="oldName" value="${pd.detail }"/>
    <div id="zhongxin">
        <br>
        <input type="hidden" name="unit" id="unit" value="分钟" maxlength="32"/>
        <table style="margin:0 auto;">
            <tr>
                <td style="text-align: center;"><span style="color: red">*</span>工作明细：</td>
                <td style="text-align: left;"><input type="text" name="detail" id="detail" value="${pd.detail}"
                                                     style="color:black;" maxlength="255"/></td>
            </tr>
            <tr>
                <td style="text-align: center;">要求：</td>
                <td style="text-align: left;"><input type="text" name="requirement" id="requirement"
                                                     value="${pd.requirement}" style="color:black;" maxlength="255"/>
                </td>
            </tr>
            <tr>
                <td style="text-align: center;">标准时间：</td>
                <td style="text-align: left;">
                    <input type="text" name="standard_time" id="standard_time" style="color:black;"
                           value="${pd.standard_time}" maxlength="32" placeholder="请填入数字，单位为分钟"/>
                </td>
            </tr>
            <tr>
                <td style="text-align: center;">实施频率：</td>
                <td style="text-align: left;"><input type="text" name="frequency" id="frequency" style="color:black;"
                                                     value="${pd.frequency}" maxlength="500"/></td>
            </tr>
            <tr>
                <td style="text-align: center;">工作指南：</td>
                <td style="text-align: left;"><input type="text" name="guide" id="guide" value="${pd.guide}"
                                                     style="color:black;" maxlength="255"/></td>
            </tr>
            <tr>
                <td style="text-align: center;">对象：</td>
                <td style="text-align: left;"><input type="text" name="target" id="target" value="${pd.target}"
                                                     style="color:black;" maxlength="32"/></td>
            </tr>
            <tr>
                <td style="text-align: center;">是否需要审批：</td>
                <td>
                    <select name="needApprove" id="needApprove" value="${pd.needApprove }">
                        <option value=0 <c:if test="${pd.needApprove == 0}">selected</c:if>>否</option>
                        <option value=1 <c:if test="${pd.needApprove == 1}">selected</c:if>>是</option>

                    </select>
                </td>
            </tr>
            <tr>
                <td style="text-align: center;" colspan="2">
                    <br>
                    <a class="btn btn-mini btn-primary" onclick="save();">保存</a>
                    <a class="btn btn-mini btn-danger" onclick="top.Dialog.close();">取消</a>
                </td>
            </tr>
        </table>

    </div>

    <div id="zhongxin2" class="center" style="display:none"><br/><br/><br/><br/><br/><img
            src="static/images/jiazai.gif"/><br/><h4 class="lighter block green">提交中...</h4></div>

</form>


<!-- 引入 -->
<script type="text/javascript">window.jQuery || document.write("<script src='static/js/jquery-1.9.1.min.js'>\x3C/script>");</script>
<script src="static/js/bootstrap.min.js"></script>
<script src="static/js/ace-elements.min.js"></script>
<script src="static/js/ace.min.js"></script>
<script type="text/javascript" src="static/js/chosen.jquery.min.js"></script><!-- 下拉框 -->
<script type="text/javascript" src="static/js/bootstrap-datepicker.min.js"></script><!-- 日期框 -->
<script type="text/javascript">
    var reg = /^\d{1,}$/;

    //保存
    function save() {
        var time = $("#standard_time").val();
        if ($("#detail").val() == "") {

            $("#detail").tips({
                side: 3,
                msg: '请填写工作明细',
                bg: '#AE81FF',
                time: 2
            });

            $("#detail").focus();
            return false;
        } else if (time == null || time == "") {
            $("#standard_time").val(0);
        } else if (time != null && !time.match(reg)) {
            $("#standard_time").tips({
                side: 3,
                msg: '标准时间只能为数字',
                bg: '#AE81FF',
                time: 2
            });
            $("#standard_time").focus();
            return false;
        }
        //编辑工作明细时，名称没有修改
        if ($("#oldName").val() != '' && $("#oldName").val() == $('#detail').val()) {
            $("#Form").submit();
            $("#zhongxin").hide();
        } else {//新增或修改了名称之后，验证名称是否存在
            var url = "<%=basePath%>positionDuty/checkDetail.do?responsibility_id=" + $('#responsibility_id').val() + "&msg=" + $('#msg').val() + "&detail=" + $('#detail').val() + "&ID=" + $('#ID').val();
            $.get(url, function (data) {
                if (data == "true") {
                    $("#Form").submit();
                    $("#zhongxin").hide();
                } else {
                    alert("该明细已存在！");
                    $("#emp_code").focus();
                    return;
                }
            }, "text");
        }

    }


</script>

</body>
</html>