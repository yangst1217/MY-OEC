<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="shiro" uri="http://shiro.apache.org/tags" %>
<%
    String path = request.getContextPath();
    String basePath = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort() + path + "/";
%>
<!DOCTYPE html>
<html lang="zh_CN">
<head>
    <base href="<%=basePath%>">
    <%@ include file="../../system/admin/top.jsp" %>
    <script type="text/javascript">
        top.changeui();

        //保存
        function save() {
            $("#form1").submit();
            $("#zhongxin").hide();
            $("#zhongxin2").show();
        }

        function checkCode() {
            if ($("#productCode").val() == "" || trimStr($("#productCode").val()) == "") {
                $("#productCode").tips({
                    side: 3,
                    msg: '请输入',
                    bg: '#AE81FF',
                    time: 2
                });
                $("#productCode").focus();
                return false;
            }
            if ($("#productName").val() == "") {
                $("#productName").tips({
                    side: 3,
                    msg: '请输入',
                    bg: '#AE81FF',
                    time: 2
                });
                $("#productName").focus();
                return false;
            }

            var productCode = $("#productCode").val();
            var id = $("#id").val();
            top.jzts();
            var url = "<%=basePath%>/product/checkCode.do?productCode=" + productCode + "&id=" + id;
            $.get(
                "<%=basePath%>/product/checkCode.do?productCode=" + productCode + "&id=" + id,
                function (data) {
                    if (data == "0") {
                        $("#codetip").attr("hidden", true);
                        save();
                    } else {
                        $("#codetip").attr("hidden", false);
                        $("#productCode").tips({
                            side: 3,
                            msg: '编码已存在',
                            bg: '#AE81FF',
                            time: 2
                        });
                        $("#productCode").focus();
                        return false;
                    }
                }
            );
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

        .need {
            color: red;
        }
    </style>
</head>
<body>
<form action="product/edit.do" name="form1" id="form1" method="post">
    <input type="hidden" name="id" id="id" value="${pd.ID}"/>
    <div id="zhongxin" align="center" style="margin-top:20px;">
        <table>
            <tr>
                <td><span class="need">*</span>产品编码：</td>
                <td><input type="text" name="productCode" maxlength="20" id="productCode" placeholder="这里输入产品编码"
                           title="产品编码" value="${pd.PRODUCT_CODE }"/></td>
            </tr>
            <tr>
                <td><span class="need">*</span>产品名称：</td>
                <td><input type="text" name="productName" maxlength="50" id="productName" placeholder="这里输入产品名称"
                           title="产品名称" value="${pd.PRODUCT_NAME }"/></td>
            </tr>
            <%-- <tr>
                <td><label>产品类型</label></td>
                <td>
                    <input type="text" name="productType" id="productType" maxlength="50" placeholder="这里输入产品类型" title="产品类型" value="${pd.PRODUCT_TYPE }"/>
                </td>
            </tr> --%>
            <tr>
                <td><label><span class="need">*</span>产品类型</label></td>
                <td>
                    <!-- <input type="text" name="productType" id="productType"
                        maxlength="50" placeholder="这里输入产品类型" title="产品类型" /> -->
                    <select name="productType">
                        <c:if test="${productType != null}">
                            <c:forEach items="${productType}" var="type">
                                <option value="${type.BIANMA }"
                                        <c:if test="${pd.PRODUCT_TYPE == type.BIANMA }">selected</c:if> >${type.NAME}</option>
                            </c:forEach>
                        </c:if>
                    </select>
                </td>
            </tr>
            <tr>
                <td><label>尺寸：</label></td>
                <td>
                    <input type="text" name="productSize" maxlength="50" id="productSize" placeholder="这里输入产品尺寸"
                           title="产品尺寸" value="${pd.SIZE }"/>
                </td>
            </tr>

            <tr>
                <td><label>生产材料：</label></td>
                <td>
                    <input type="text" name="material" id="material" maxlength="100" placeholder="这里输入生产材料" title="生产材料"
                           value="${pd.MATERIAL }"/>
                </td>
            </tr>
            <tr>
                <td><label>产品描述：</label></td>
                <td><input type="text" name="descp" id="descp" maxlength="255" placeholder="这里输入产品描述" title="描述"
                           value="${pd.DESCP }"></td>
            </tr>

            <tr>

                <td colspan="2" style="text-align: center;">
                    <a class="btn btn-mini btn-primary" onclick="checkCode();">保存</a>
                    <a class="btn btn-mini btn-danger" onclick="top.Dialog.close();">取消</a>
                </td>
            </tr>
        </table>
    </div>
</form>

<div id="zhongxin2" class="center" style="display:none">
    <img src="static/images/jzx.gif" style="width: 50px;"/><br/>
    <h4 class="lighter block green"></h4>
</div>
<script type="text/javascript">
    function changeNumber(objTxt) {
        objTxt.value = objTxt.value.replace(/\D/g, '');
    }
</script>
</body>
</html>