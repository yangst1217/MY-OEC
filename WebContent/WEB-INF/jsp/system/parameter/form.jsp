<%--
  Created by IntelliJ IDEA.
  User: yangdw
  Date: 2015/12/8
  Time: 8:53
  To change this template use File | Settings | File Templates.
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%
    String path = request.getContextPath();
    String basePath = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort() + path + "/";
%>
<!DOCTYPE html>
<html>
<head>
    <title>系统参数提交</title>
    <base href="<%=basePath%>">
    <!-- jsp文件头和头部 -->
    <%@ include file="../admin/top.jsp" %>
    <script type="text/javascript">
        function checkandsubmit() {
            var systemKey = $("#systemKey").val();
            var systemOrder = $("#systemOrder").val();
            var systemValue = $("#systemValue").val();
            var startDate = $("#startDate").val();
            var endDate = $("#endDate").val();
            var define1 = $("#define1").val();
            var define2 = $("#define2").val();
            var define3 = $("#define3").val();
            var define4 = $("#define4").val();
            var define5 = $("#define5").val();
            if (startDate == "" || endDate == "" || startDate == null || endDate == null
                || systemKey == "" || systemKey == null || systemOrder == "" || systemOrder == null
                || systemValue == "" || systemValue == null) {
                alert("请输入各项值!")
                return;
            }
            if (isNaN(Number(startDate)) || isNaN(Number(endDate))) {
                alert("请确保起止日期格式正确!");
                return;
            }
            if (isNaN(Number(systemValue))) {
                alert("请确保手工录入值正确!");
                return;
            }
            if (startDate.length != 4 && startDate.length != 6 && startDate.length != 8) {
                alert("请确保起止日期格式正确!");
                return;
            }

            if (Number(startDate) > Number(endDate)) {
                alert("请确保截止日期大于起始日期!");
                return;
            }

            if (startDate.length != endDate.length) {
                alert("请确保起止日期格式一致!");
                return;
            }
            $.ajax({
                type: "POST",
                url: '<%=basePath%>parameter/addOredit.do',
                data: {
                    systemKey: systemKey,
                    systemOrder: systemOrder,
                    systemValue: systemValue,
                    startDate: startDate,
                    endDate: endDate,
                    define1: define1,
                    define2: define2,
                    define3: define3,
                    define4: define4,
                    define5: define5
                },
                dataType: 'json',
                //beforeSend: validateData,
                cache: false,
                success: function (data) {
                    alert(data.msg);
                    //将页面中已经填好的值清空
                    window.location.reload();
                    $("#systemValue").val('');
                    $("#startDate").val('');
                    $("#endDate").val('');
                    $("#systemKey").val('');
                    $("#systemOrder").val('');
                    $("#define1").val('');
                    $("#define2").val('');
                    $("#define3").val('');
                    $("#define4").val('');
                    $("#define5").val('');
                }
            });
        }

        top.changeui();

        function setReport() {
            var reportCode = $("#systemKey").val();
            $.ajax({
                type: "POST",
                url: '<%=basePath%>parameter/getReportParameter.do',
                data: {reportCode: reportCode},
                dataType: 'json',
                cache: false,
                success: function (data) {

                    var dateFormat = "（例：" + data.parameterList[0].define1 + "）"

                    $("#systemOrder option").remove();
                    $("#dateFormat").empty();
                    var option = "";
                    for (var i = 0; i < data.parameterList.length; i++) {
                        option += "<option value='" + data.parameterList[i].parameter_CODE + "'>" + data.parameterList[i].parameter_NAME + "</option>";
                    }
                    $("#systemOrder").append(option);
                    $("#dateFormat").append(dateFormat);
                }
            })
        }
    </script>
</head>

<div style="height: 100%;margin-bottom: 20px">
    <div class="controls-row" style="margin-top: 20px">

        <div class="control-group span3">
            <label class="control-label" for="systemKey">报表名:</label>
            <div class="controls">
                <select name="systemKey" id="systemKey" class="input_txt" onchange="setReport()" title="报表">
                    <c:forEach items="${reportList}" var="report">
                        <option value="${report.REPORT_CODE}">${report.REPORT_NAME }</option>
                    </c:forEach>
                </select>
            </div>
        </div>
        <div class="control-group span3">
            <label class="control-label" for="systemOrder">手工录入项:</label>
            <div class="controls">
                <select name="systemOrder" id="systemOrder" title="参数">
                    <c:forEach items="${firstParameterList}" var="parameter">
                        <option value="${parameter.PARAMETER_CODE}">${parameter.PARAMETER_NAME}</option>
                    </c:forEach>
                </select>
            </div>
        </div>
        <div class="control-group span2">
            <label class="control-label" for="systemValue">手工录入值:</label>
            <div class="controls">
                <input type="text" name="systemValue" id="systemValue" size="60" class="span2">
            </div>
        </div>

        <div class="control-group span5">
            <label class="control-label" for="startDate">有效时间（起止）:<b id="dateFormat" style="color: red">（例：<c:out
                    value="${reportList[0].DEFINE1}"></c:out>）</b></label>
            <div class="controls controls-row">
                <input type="text" name="startDate" id="startDate" size="60" class="span2" placeholder="开始日期">
                <span class="span1" style="margin-left: 0;text-align: center;margin-top:1%;">到</span>
                <input type="text" name="endDate" id="endDate" size="60" class="span2" placeholder="结束日期"
                       style="margin-left: 0">
            </div>
        </div>

    </div>

    <div class="controls-row" style="margin-top: 20px;position: relative">

        <div class="control-group span3">
            <label class="control-label" for="define1">自定义1:</label>
            <div class="controls">
                <select name="define1" id="define1" title="内/外销">
                    <option value="" style="font-size: 1.5em">&nbsp;</option>
                    <option value="内销">内销</option>
                    <option value="外销">外销</option>
                    <option value="内销-外贸公司">内销-外贸公司</option>
                </select>
            </div>
        </div>

        <div class="control-group span3">
            <label class="control-label" for="define2">自定义2:</label>
            <div class="controls">
                <select name="define2" id="define2" title="预算/实际">
                    <option value="" style="font-size: 1.5em">&nbsp;</option>
                    <option value="预算">预算</option>
                    <option value="实际">实际</option>
                </select>
            </div>
        </div>

    </div>
    <div class="controls-row" style="margin-top: 20px;position: relative">

        <div class="control-group span2">
            <label class="control-label" for="define3">自定义3:</label>
            <div class="controls">
                <input type="text" name="define3" id="define3" class="span2" readonly="readonly">
            </div>
        </div>

        <div class="control-group span2">
            <label class="control-label" for="define4">自定义4:</label>
            <div class="controls">
                <input type="text" name="define4" id="define4" class="span2" readonly="readonly">
            </div>
        </div>

        <div class="control-group span2">
            <label class="control-label" for="define5">自定义5:</label>
            <div class="controls">
                <input type="text" name="define5" id="define5" class="span2" readonly="readonly">
            </div>
        </div>

        <input type="button" class="btn btn-mini btn-primary span1" value="提交" style="position:absolute;bottom:19%;"
               onclick="checkandsubmit()">

    </div>
</div>

<hr style="height:1px;border:none;border-top:1px solid grey;margin: 6px 0;"/>

<div style="height: 100%;margin-top: 20px;margin-left: 2%">
    <h3 style="color: red">
        使用说明 &nbsp;&nbsp;&nbsp;&nbsp;
        <a href="<%=basePath%>uploadFiles/file/详细说明.doc" style="font-size: 0.8em">详细说明下载</a>
    </h3>
    <p>1.此功能仅限于熟悉报表系统的业务人员使用，非相关人员禁止使用</p>
    <p>2.有效时间可精确到年，月，日，举例如："2015","201503","20150316"</p>
    <p>3.有效时间为一个时间点时，只需将起止时间设为相同即可</p>
    <p>4.手工录入值只可以填入数字</p>
</div>
</body>
</html>
