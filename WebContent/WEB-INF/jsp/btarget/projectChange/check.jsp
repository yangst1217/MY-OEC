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
    <!-- ace styles -->
    <link rel="stylesheet" href="static/assets/css/ace.css" class="ace-main-stylesheet" id="main-ace-style"/>

    <link rel="stylesheet" href="static/assets/css/font-awesome.css"/>
    <script src="static/js/ajaxfileupload.js"></script>
    <script type="text/javascript" src="static/js/bootstrap-datepicker.min.js"></script><!-- 日期框 -->

    <style>
        input[type="checkbox"], input[type="radio"] {
            opacity: 1;
            position: static;
            height: 25px;
            margin-bottom: 10px;
        }

        #zhongxin td {
            height: 40px;
        }

        #zhongxin td label {
            text-align: right;
            margin-right: 10px;
        }

        #zx td label {
            text-align: left;
            margin-right: 0px;
        }
    </style>
    <script type="text/javascript">

    </script>
</head>
<body>
<fmt:requestEncoding value="UTF-8"/>
<form action="projectChange/check.do" name="checkForm" id="checkForm" method="post">
    <input id="delIds" type="hidden" value="" name="delIds"/>
    <input type="hidden" name="ID" id="ID" value="${pd.ID }"/>
    <input type="hidden" name="STATUS" id="STATUS" value="${pd.STATUS }"/>
    <input type="hidden" name="DOCUMENT" id="document"/>
    <input type="hidden" name="DOCUMENT_PATH" id="document_path"/>
    <input type="hidden" name="DOCUMENT_ID" id="DOCUMENT_ID" value="${pd.DOCUMENT_ID }"/>

    <div id="zhongxin">
        <table style="margin-left: 40px;margin-top:20px;">
            <tr>
                <td>重点协同项目:</td>
                <td>
                    <input type="text" value="${pd.C_PROJECT_NAME }" maxlength="32" readonly="readonly"
                           style="width: 600px;"/>
                </td>
            </tr>
            <tr>
                <td>变更完成标准:</td>
                <td>
                    <textarea type="text" name="CHANGE_COMPLETION" id="CHANGE_COMPLETION" readonly="readonly"
                              style="height: 80px;width: 600px;">${pd.CHANGE_COMPLETION }</textarea>
                </td>
            </tr>
            <tr>
                <td>变更说明:</td>
                <td>
                    <textarea type="text" name="CHANGE_DESCP" id="CHANGE_DESCP" style="height: 80px;width: 600px;"
                              readonly="readonly">${pd.CHANGE_DESCP }</textarea>
                </td>
            </tr>
            <tr id="zx">
                <td><label>指标文档上传:</label></td>
                <td>
                    <c:choose>
                        <c:when test="${not empty fileList}">
                            <c:forEach items="${fileList}" var="file" varStatus="vs">
                                <div>
                                    <a href="<%=basePath%>/uploadFiles/file/${file.FILENAME}">${file.FILENAME}</a>
                                </div>
                            </c:forEach>
                        </c:when>
                    </c:choose>
                </td>
            </tr>
        </table>
        <table class="table table-striped table-bordered table-hover"
               style="margin-left: 40px;margin-top:20px;width:70%;">
            <tbody>
            <tr>
                <td colspan="2">
                    <table class="LayoutTable" style="width:700px;">
                        <tbody>
                        <tr class="groupHeadHide">
                            <td class="interval">
                                <span><img src="static/images/ui1.png"> </span>
                                <span class="e8_grouptitle">变更内容</span>
                            </td>
                        </tr>
                        </tbody>
                    </table>
                </td>
            </tr>
            <tr style="display:">
                <td colspan="2">
                    <table id="dimtable">
                        <tr>
                            <th width="30px"></th>
                            <th width="200px">变更内容</th>
                            <th style="width:100px;">原开始时间</th>
                            <th style="width:100px;">变更后开始时间</th>
                            <th style="width:100px;">原结束时间</th>
                            <th style="width:100px;">变更后结束时间</th>
                            <th style="width:100px;">原权重(%)</th>
                            <th style="width:100px;">变更后权重(%)</th>
                        </tr>
                        <c:forEach items="${varList}" var="key">
                            <tr style="background-color: rgb(248,248,248);">
                                <td><input type="checkbox" name="lids" value="${key.ID}"/></td>
                                <input type="hidden" name="CHANGE_TYPE" id="CHANGE_TYPE" value="${key.CHANGE_TYPE}"/>
                                <td>
                                    <input type="text" name="CHANGE" id="CHANGE" value="${key.CHANGE_NAME}" readonly/>
                                </td>
                                <td style="width:20px;">
                                    <input type="hidden" name="dids" value="${key.ID}"/>
                                    <c:if test="${key.CHANGE_TYPE == 'JDBG'}">
                                        <input type="text" name="BEFORE_START_DATE" id="BEFORE_START_DATE"
                                               style="width:80px;" readonly/>
                                    </c:if>
                                    <c:if test="${key.CHANGE_TYPE == 'HDBG'}">
                                        <input type="text" name="BEFORE_START_DATE" id="BEFORE_START_DATE"
                                               style="width:80px;" value="${key.BEFORE_START_DATE}" readonly/>
                                    </c:if>
                                </td>
                                <td style="width:20px;">
                                    <c:if test="${key.CHANGE_TYPE == 'JDBG'}">
                                        <input type="text" name="AFTER_START_DATE" id="AFTER_START_DATE"
                                               style="width:90px;" readonly/>
                                    </c:if>
                                    <c:if test="${key.CHANGE_TYPE == 'HDBG'}">
                                        <input type="text" name="AFTER_START_DATE" id="AFTER_START_DATE"
                                               style="width:90px;" value="${key.AFTER_START_DATE}" readonly/>
                                    </c:if>
                                </td>
                                <td style="width:20px;">
                                    <input type="text" name="BEFORE_END_DATE" id="BEFORE_END_DATE" style="width:80px;"
                                           value="${key.BEFORE_END_DATE}" readonly/>
                                </td>
                                <td style="width:20px;">
                                    <input type="text" name="AFTER_END_DATE" id="AFTER_END_DATE" style="width:90px"
                                           value="${key.AFTER_END_DATE}" readonly/>
                                </td>
                                <td style="width:20px;">
                                    <input type="text" name="BEFORE_WEIGHT" id="BEFORE_WEIGHT" style="width:30px;"
                                           value="${key.BEFORE_WEIGHT}" readonly/>
                                </td>
                                <td style="width:20px;">
                                    <input type="text" name="AFTER_WEIGHT" id="AFTER_WEIGHT" style="width:30px;"
                                           value="${key.AFTER_WEIGHT}" readonly/>
                                </td>
                            </tr>
                        </c:forEach>
                    </table>
                </td>
            </tr>


            </tbody>
        </table>
        <table style="margin-left: 40px;margin-top:20px;">
            <tr>
                <td><span style="color:red">*</span>审批意见:</td>
                <td>
                    <c:if test="${msg == 'view'}">
                        <textarea type="text" name="OPINION" id="OPINION"
                                  style="height: 80px;width: 600px;margin-left: 40px"
                                  readonly="readonly">${auditDetail.OPINION }</textarea>
                    </c:if>
                    <c:if test="${msg == 'check'}">
                        <textarea type="text" name="OPINION" id="OPINION"
                                  style="height: 80px;width: 600px;margin-left: 40px">${auditDetail.OPINION }</textarea>
                    </c:if>
                </td>
            </tr>
        </table>
        <table style="width:100%;">
            <tr>
                <td colspan="2">
                    <hr style="border: 0;border-bottom: 1.5px solid black;">
                </td>
            </tr>


            <!-- <div colspan="2" style="text-align: center;">
                <a class="btn btn-mini btn-primary" onclick="save();">保存</a>&nbsp;
                <a class="btn btn-mini btn-danger" onclick="top.Dialog.close();">取消</a>
            </div> -->
            <c:if test="${msg != 'view'}">
                <tr>
                    <td colspan="2" style="text-align: center;">
                        <a class="btn btn-mini btn-primary" onclick="changeStatus('YW_YSX');">审核通过</a>&nbsp;
                        <a class="btn btn-mini btn-danger" onclick="changeStatus('YW_YTH');">审核退回</a>
                    </td>
                </tr>
            </c:if>
        </table>

    </div>
</form>
<!-- 引入 -->
<script type="text/javascript">window.jQuery || document.write("<script src='static/js/jquery-1.9.1.min.js'>\x3C/script>");</script>
<script src="static/js/bootstrap.min.js"></script>
<script src="static/js/ace-elements.min.js"></script>
<script src="static/js/ace.min.js"></script>
<script type="text/javascript" src="static/js/chosen.jquery.min.js"></script><!-- 下拉框 -->

<script type="text/javascript">
    //日期框
    $(function () {
        $("input[TO_USE='true']").each(function () {
            $(this).datepicker({
                format: 'yyyy-mm-dd',
                changeMonth: true,
                changeYear: true,
                showButtonPanel: true,
                autoclose: true,
                minViewMode: 0,
                maxViewMode: 2,
                startViewMode: 0,
                onClose: function (dateText, inst) {
                    var year = $("#span2 date-picker .ui-datepicker-year :selected").val();
                    $(this).datepicker('setDate', new Date(year, 1, 1));
                }
            });
        });

        /* 	        $('#AFTER_END_DATE').datepicker({
                        format:'yyyy-mm-dd',
                        changeMonth: true,
                        changeYear: true,
                        showButtonPanel: true,
                        autoclose: true,
                        minViewMode:0,
                        maxViewMode:2,
                        startViewMode:0,
                        onClose: function(dateText, inst) {
                            var year = $("#span2 date-picker .ui-datepicker-year :selected").val();
                            $(this).datepicker('setDate', new Date(year, 1, 1));
                        }
                    }); */
    });
</script>

<script type="text/javascript">


    //审批
    function changeStatus(status) {
        if ($("#OPINION").val() == "") {
            $("#OPINION").tips({
                side: 3,
                msg: '请填写审批意见',
                bg: '#AE81FF',
                time: 2
            });
            $("#OPINION").focus();
            return false;
        }
        top.jzts();
        var STATUS = status;
        var url = "<%=basePath%>/projectChange/check.do?ID=" + $("#ID").val() + "&STATUS=" + STATUS + "&OPINION=" + encodeURI(encodeURI($("#OPINION").val())) + "&CHANGE_COMPLETION=" + encodeURI(encodeURI($("#CHANGE_COMPLETION").val()));
        $.get(url, function (data) {
            if (data == "success") {
                top.Dialog.close();
            } else {
                top.Dialog.close();
            }
        });
    }


</script>

</body>
</html>