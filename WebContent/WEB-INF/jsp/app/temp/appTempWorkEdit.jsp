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

    <title>临时任务编辑</title>
    <meta name="description" content="overview & stats"/>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <link href="static/css/bootstrap.min.css" rel="stylesheet"/>
    <link href="static/css/bootstrap-responsive.min.css" rel="stylesheet"/>
    <link rel="stylesheet" href="static/css/font-awesome.min.css"/>
    <link rel="stylesheet" href="static/css/ace.min.css"/>
    <link rel="stylesheet" href="static/css/ace-responsive.min.css"/>
    <link rel="stylesheet" href="static/css/ace-skins.min.css"/>
    <link rel="stylesheet" href="static/css/app-style.css"/>
    <!-- 引入 -->
    <script type="text/javascript" src="static/js/jquery-1.7.2.js"></script>
    <script type="text/javascript" src="static/js/jquery-form.js"></script>

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


    <script src="static/js/bootstrap.min.js"></script>
    <script src="static/js/ace-elements.min.js"></script>
    <script src="static/js/ace.min.js"></script>
    <script type="text/javascript" src="static/js/chosen.jquery.min.js"></script>

    <script type="text/javascript" src="static/js/jquery.tips.js"></script>
    <!-- 加载Mobile文件 -->
    <script src="plugins/appDate/js/mobiscroll.core.js"></script>
    <script src="plugins/appDate/js/mobiscroll.frame.js"></script>
    <script src="plugins/appDate/js/mobiscroll.scroller.js"></script>
    <script src="plugins/appDate/js/mobiscroll.util.datetime.js"></script>
    <script src="plugins/appDate/js/mobiscroll.datetimebase.js"></script>
    <script src="plugins/appDate/js/mobiscroll.datetime.js"></script>
    <script src="plugins/appDate/js/mobiscroll.frame.android.js"></script>
    <script src="plugins/appDate/js/i18n/mobiscroll.i18n.zh.js"></script>

    <link href="plugins/appDate/css/mobiscroll.frame.css" rel="stylesheet" type="text/css"/>
    <link href="plugins/appDate/css/mobiscroll.frame.android.css" rel="stylesheet" type="text/css"/>
    <link href="plugins/appDate/css/mobiscroll.scroller.css" rel="stylesheet" type="text/css"/>
    <link href="plugins/appDate/css/mobiscroll.scroller.android.css" rel="stylesheet" type="text/css"/>
    <script type="text/javascript">
        if ("ontouchend" in document) document.write("<script src='static/js/jquery.mobile.custom.min.js'>" + "<" + "/script>");
    </script>

    <script type="text/javascript">
        $(function () {
            // 初始化日期框插件内容
            $('#START_TIME').mobiscroll().datetime({
                theme: 'android',
                mode: 'scroller',
                display: 'modal',
                lang: 'zh',
                dateFormat: 'yyyy-mm-dd',
                buttons: ['set', 'cancel', 'clear']
            });
            $('#END_TIME').mobiscroll().datetime({
                theme: 'android',
                mode: 'scroller',
                display: 'modal',
                lang: 'zh',
                dateFormat: 'yyyy-mm-dd',
                buttons: ['set', 'cancel', 'clear']
            });
            //初始化页面评价人
            if ("0" == $("#NEED_CHECK").val()) {
                $("#checkContainer").hide();
            } else {
                $("#checkContainer").show();
                chkflag = 1;
            }
            $("#NEED_CHECK").change(function () {
                var chkflag = 0;
                if ("0" == $("#NEED_CHECK").val()) {
                    $("#checkContainer").hide();
                } else {
                    $("#checkContainer").show();
                    chkflag = 1;
                }
            });
        });

        //下载文件
        function loadFile(fileName) {
            var action = '<%=basePath%>app_temp/checkFile.do';
            var time = new Date().getTime();
            $.ajax({
                type: "get",
                dataType: "text",
                data: {"fileName": fileName, "time": time},
                url: action,
                success: function (data) {
                    if (data == "") {
                        alert("文件不存在！");
                        return;
                    }
                    window.location.href = '<%=basePath%>app_temp/loadFile.do?fileName=' + fileName + "&time=" + time;
                }
            });
        }

        function checkCode() {
            if ($("#TASK_CODE").val() == "") {
                $("#TASK_CODE").focus();
            }
            if ($("#TASK_NAME").val() == "") {
                $("#TASK_NAME").focus();
                alert("任务名称不能为空！");
                return false;
            }

            if ($("#START_TIME").val() == "") {
                $("#START_TIME").focus();
                alert("开始时间不能为空！");
                return false;
            }

            if ($("#END_TIME").val() == "") {
                $("#END_TIME").focus();
                alert("完成时间不能为空！");
                return false;
            }

            if ($("#COMPLETION").val() == "") {
                $("#COMPLETION").focus();
                alert("完成标准不能为空！");
                return false;
            }

            if ($("#DEPT_ID").val() == "") {
                $("#DEPT_ID").focus();
                alert("责任部门不能为空！");
                return false;
            }

            /* 	var val2 =  $("#DEPT_ID").find("option:selected").text();
                $("#DEPT_NAME").val(val2);	 */
            if ($("#MAIN_EMP_ID").val() == "") {
                $("#MAIN_EMP_ID").focus();
                alert("责任人不能为空！");
                return false;
            }

            /* 	var val3 =  $("#MAIN_EMP_ID").find("option:selected").text();
                $("#MAIN_EMP_NAME").val(val3); */

            if ($("#NEED_CHECK").val() == "") {
                $("#NEED_CHECK").focus();
                alert("是否评价不能为空！");
                return false;
            }

            if ($("#NEED_CHECK").val() == "1") {
                if ($("#CHECK_PERSON").val() == "") {
                    $("#CHECK_PERSON").focus();
                    alert("评价人不能为空！");
                    return false;
                }
            } else {
                $("#CHECK_PERSON").val("0");
            }

            var id = document.getElementById("id").value;
            save();
        }

        //保存
        function save() {
            if ("0" == $("#NEED_CHECK").val()) {
                $("#CHECK_PERSON").val("");
            }
            var options = {
                success: function (data) {
                    alert("保存成功");
                    var url = '<%=basePath %>app_temp/goTemp.do?&year=${year}&KEYW=${KEYW}&KEcurrentPageYW=${currentPage}';
                    window.location.href = url;
                },
                error: function (data) {
                    alert("保存出错");
                }
            };
            $("#Form").ajaxSubmit(options);
        }

        //根据部门查询人员
        function queryEmp() {
            //初始化任务
            var url = "app_temp/queryEmp.do?";
            var DEPT_ID = $("#DEPT_ID").val();
            $.ajax({
                type: "POST",
                url: url,
                data: {"DEPT_ID": DEPT_ID},
                success: function (data) {
                    var obj = eval('(' + data + ')');
                    $("#MAIN_EMP_ID").empty();
                    $.each(obj.empList, function (i, emp) {
                        $("#MAIN_EMP_ID").append('<option value=' + emp.ID + '@' + emp.EMP_NAME + '>' + emp.EMP_NAME + '</option>');
                    });
                }
            });
        }
    </script>
</head>
<body>
<div class="web_title">
    <div class="back" style="top:5px">
        <a onclick="window.history.go(-1)">
            <img src="static/app/images/left.png"/></a>
    </div>
    <c:if test="${msg == 'edit'}">
        临时工作编辑
    </c:if>
    <c:if test="${msg == 'view'}">
        临时工作查看
    </c:if>

</div>
<form action="<%=basePath%>app_temp/edit.do" name="Form" id="Form" method="post">
    <input type="hidden" name="attachDeptName" id="attachDeptName"/>
    <input type="hidden" name="id" id="id" value="${pd.ID}"/>
    <input type="hidden" name="TASK_TYPE1" id="TASK_TYPE1" value="${pd.TASK_TYPE}"/>
    <input type="hidden" value="${target.ID}" id="TARGET_ID" name="TARGET_ID">
    <input type="hidden" value="${target.TARGET_TYPE}" id="PATH_TYPE" name="PATH_TYPE">
    <input type="hidden" value="${target.TARGET_CODE}" id="TARGET_CODE" name="TARGET_CODE">
    <input type="hidden" id="CYCLE" name="CYCLE" value="${path.CYCLE}">
    <input type="hidden" id="CREATE_USER" name="CREATE_USER" value="${path.CREATE_USER}">
    <input type="hidden" id="CREATE_TIME" name="CREATE_TIME" value="${path.CREATE_TIME}">
    <input type="hidden" id="STATUS" name="STATUS" value="${path.STATUS}">
    <input type="hidden" id="TARGET_DEPT_ID" name="TARGET_DEPT_ID" value="${path.DEPT_ID}">
    <input type="hidden" id="TARGET_EMP_ID" name="TARGET_EMP_ID" value="${path.EMP_ID}">
    <div id="zhongxin" style="width:98%; margin:0 auto; ">
        <c:if test="${msg == 'edit'}">
            <table style="margin: 10px auto; width:98%; ">
                <tr>
                    <td style="width: 70px;"><label><span style="color: red;">*</span>任务编号：</label></td>
                    <td><input type="text" name="TASK_CODE" id="TASK_CODE" placeholder="这里输入任务编号" title="任务编号"
                               value="${pd.TASK_CODE}" readonly="readonly"/></td>
                </tr>
                <tr>
                    <td><label><span style="color: red;">*</span>任务名称：</label></td>
                    <td><input type="text" name="TASK_NAME" id="TASK_NAME" placeholder="这里输入任务名称" title="任务名称"
                               value="${pd.TASK_NAME}"/></td>
                </tr>
                <tr>
                    <td><label>任务描述：</label></td>
                    <td>
                        <textarea type="text" id="TASK_CONTECT" name="TASK_CONTECT">${pd.TASK_CONTECT}</textarea>
                    </td>
                </tr>

                <tr>
                    <td><label><span style="color: red;">*</span>开始时间：</label></td>
                    <td>
                        <input type="text" name="START_TIME" id="START_TIME"
                               value="${pd.START_TIME}" data-date-format="yyyy-mm-dd hh:ii"
                               placeholder="开始时间">
                    </td>
                </tr>

                <tr>
                    <td><label><span style="color: red;">*</span>结束时间：</label></td>
                    <td><input type="text" name="END_TIME" id="END_TIME"
                               value="${pd.END_TIME}" data-date-format="yyyy-mm-dd hh:ii"
                               placeholder="结束时间">
                    </td>
                </tr>

                <tr>
                    <td><label><span style="color: red;">*</span>完成标准：</label></td>
                    <td>
                        <textarea type="text" id="COMPLETION" name="COMPLETION">${pd.COMPLETION}</textarea>
                    </td>
                </tr>

                <tr>
                    <td><label><span style="color: red;">*</span>责任部门：</label></td>
                    <td>
                        <select id="DEPT_ID" name="DEPT_ID" onchange="queryEmp()">
                            <c:forEach items="${deptList}" var="dept" varStatus="vs">
                                <option value="${dept.ID}@${dept.DEPT_NAME}"
                                        <c:if test="${dept.ID == DEPT_ID}">selected</c:if>>
                                        ${dept.DEPT_NAME}
                                </option>
                            </c:forEach>
                        </select>
                    </td>
                </tr>

                <tr>
                    <td><label><span style="color: red;">*</span>责任人：</label></td>
                    <td>
                        <select id="MAIN_EMP_ID" name="MAIN_EMP_ID">
                            <c:forEach items="${empList}" var="emp" varStatus="vs">
                                <option value="${emp.ID}@${emp.EMP_NAME}"
                                        <c:if test="${emp.ID == pd.MAIN_EMP_ID}">selected</c:if>>
                                        ${emp.EMP_NAME}
                                </option>
                            </c:forEach>
                        </select>
                    </td>
                </tr>
                <tr>
                    <td><label><span style="color: red;">*</span>是否评价：</label></td>
                    <td>
                        <select name="NEED_CHECK" id="NEED_CHECK" data-placeholder="请选择是否评价">
                            <option value="">请选择是否评价</option>
                            <option value="0" <c:if test="${0 == pd.NEED_CHECK}">selected</c:if>>否</option>
                            <option value="1" <c:if test="${1 == pd.NEED_CHECK}">selected</c:if>>是</option>
                        </select>
                    </td>
                </tr>
                <tr id="checkContainer">
                    <td><label>评价人：</label></td>
                    <td>
                        <select id="CHECK_PERSON" name="CHECK_PERSON">
                            <c:forEach items="${allEmpList}" var="emp" varStatus="vs">
                                <option value="${emp.ID}" <c:if test="${emp.ID == pd.CHECK_PERSON}">selected</c:if>>
                                        ${emp.EMP_NAME}
                                </option>
                            </c:forEach>
                        </select>

                    </td>
                </tr>
                <tr>
                    <td colspan="2" style="text-align: center;">
                        <a class="btn btn-mini btn-primary" onclick="checkCode();">确定</a>
                    </td>
                </tr>
            </table>
        </c:if>
        <c:if test="${msg == 'view'}">
            <table style="margin: 10px auto; width:98%; ">
                <tr>
                    <td style="width: 70px;"><label>任务编号：</label></td>
                    <td>${pd.TASK_CODE }</td>
                </tr>
                <tr>
                    <td><label>任务名称：</label></td>
                    <td>${pd.TASK_NAME }</td>
                </tr>
                <tr>
                    <td><label>任务描述：</label></td>
                    <td>${pd.TASK_CONTECT }</td>
                </tr>

                <tr>
                    <td><label>开始时间：</label></td>
                    <td>${pd.START_TIME}</td>
                </tr>

                <tr>
                    <td><label>结束时间：</label></td>
                    <td>${pd.END_TIME}</td>
                </tr>

                <tr>
                    <td><label>完成标准：</label></td>
                    <td>${pd.COMPLETION}</td>
                </tr>

                <tr>
                    <td><label>责任部门：</label></td>
                    <td>${pd.DEPT_NAME }</td>
                </tr>

                <tr>
                    <td><label>责任人：</label></td>
                    <td>${pd.MAIN_EMP_NAME }</td>
                </tr>
                <tr>
                    <td><label>是否评价：</label></td>
                    <td>
                        <c:if test="${0 == pd.NEED_CHECK}">否</c:if>
                        <c:if test="${1 == pd.NEED_CHECK}">是</c:if>
                    </td>
                </tr>
                <c:if test="${1 == pd.NEED_CHECK}">
                    <tr>
                        <td><label>评价人：</label></td>
                        <td>
                                ${pd.CHECK_NAME }
                        </td>
                    </tr>
                </c:if>
                <tr>
                    <td><label>附件：</label></td>
                    <td>
                        <c:choose>
                            <c:when test="${not empty fileList }">
                                <c:forEach items="${fileList }" var="file" varStatus="vs">
                                    <a style="cursor:pointer;color: red;"
                                       onclick="loadFile('${file.SERVER_FILENAME }')">${file.FILENAME }</a><br>
                                </c:forEach>
                            </c:when>
                        </c:choose>
                    </td>
                </tr>
            </table>
        </c:if>

    </div>
    <div id="zhongxin2" class="center" style="display:none"><br/><br/><br/><br/><br/><img
            src="static/images/jiazai.gif"/><br/><h4 class="lighter block green">提交中...</h4></div>

    <div>
        <%@include file="../footer.jsp" %>
    </div>

</form>
</body>
</html>