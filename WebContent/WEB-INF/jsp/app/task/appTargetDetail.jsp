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
    <title>任务详情</title>
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
    <link rel="stylesheet" href="static/css/app-style.css"/>

    <style type="text/css">
        #zhognxin td {
            height: 35px;
        }

        #zhognxin td label {
            text-align: left;
            margin-right: 10px;
        }

        #zhongxin td input {
            width: 90%;
            padding: 4px 0;
        }

        .progress {
            width: 90%;
        }

        .success {
            background-color: #55b83b
        }

        .warning {
            background-color: #d20b44
        }

        .tab-content {
            padding: 0;
        }

        .nav-tabs > li > a {
            color: white;
        }

        .keytask {
            width: 100%;
            padding: 0;
        }

        .keytask table {
            width: 98%;
            margin: 0 auto;
        }

        .keytask table tr td {
            line-height: 1.3;
            word-break: break-word;
            overflow: visible;
            white-space: normal;
        }

        .btn-mini {
            padding: 0 2px;
        }

        .web_footer {
            z-index: 11;
        }
    </style>
    <!-- 引入 -->
    <script type="text/javascript">window.jQuery || document.write("<script src='static/js/jquery-1.9.1.min.js'>\x3C/script>");</script>
    <script src="static/js/bootstrap.min.js"></script>
    <script src="static/js/ace-elements.min.js"></script>
    <script src="static/js/ace.min.js"></script>
    <script type="text/javascript">
        //补录日清
        function addDailyTaskByPI() {
            if (${pd.overDays>3}) {
                alert("超过3天不能补录");
                return;
            }
            showTaskDialog('pi');
        }

        //员工日清
        function addDailyTask() {
            showTaskDialog('');
        }

        //添加日清
        function showTaskDialog(type) {
            //员工日清-超期不能填写
            if (type == '' && '${pd.isOverDay}' == 'true') {
                alert("已超过任务结束时间，不能填报日清");
                return;
            }
            //本次日清需要完成的量
            var taskCount = "${weekTask.taskCount}";
            //本周的工作量
            var weekCount = "${weekTask.WEEK_COUNT }";
            var endDate = "${weekTask.WEEK_END_DATE }";
            window.location.href = '<%=basePath%>app_task/toAddTargetTask.do?show=${pd.show}&loadType=${pd.loadType}&taskCount=' + taskCount +
                "&weekCount=" + weekCount + "&weekTaskId=" + ${weekTask.ID} +"&endDate=" + endDate;
        }

        //删除任务
        function delTask(id) {
            if (confirm("确定要删除?")) {
                var url = "<%=basePath%>app_task/deleteTargetTask.do?id=" + id;
                $.get(url, function (data) {
                    if (data == "success") {
                        alert("删除成功！");
                        window.location.reload();
                    } else {
                        alert("删除失败！");
                    }
                }, "text");
            }
        }

        //日清任务-审核
        function validate(taskTime, id, isPass) {
            var cmd = "";
            if (isPass == 1) {
                cmd = "通过";
            } else {
                cmd = "退回";
            }
            if (confirm("确认" + cmd + "?")) {
                var url = "<%=basePath%>app_task/validateDailyEmpTask.do?id=" + id + "&isPass=" + isPass;
                url += "&weekTaskId=${weekTask.ID}" + "&taskTime=" + taskTime +
                    "&startDate=${weekTask.WEEK_START_DATE }&endDate=${weekTask.WEEK_END_DATE }";
                $.get(url, function (data) {
                    if (data == "success") {
                        alert("审核成功！");
                        window.location.reload();
                    } else {
                        alert("审核失败！");
                    }
                }, "text");
            }
        }

        //添加日清批示
        function addComment() {
            window.location.href = '<%=basePath%>app_task/toAddTargetComment.do?weekTaskId=${weekTask.ID}&show=${pd.show}&loadType=${pd.loadType}';
        }

        //下载文件
        function loadFile(fileName) {
            var action = '<%=basePath%>app_task/checkFile.do';
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
                    window.location.href = '<%=basePath%>app_task/loadFile.do?fileName=' + fileName + "&time=" + time;
                }
            });
        }
    </script>
</head>
<body>
<div class="web_title">
    <!-- 返回 -->
    <div class="back" style="top:5px">
        <c:choose>
        <c:when test="${empty pd.showDept }">
        <a href="<%=basePath %>app_task/listDesk.do?loadType=${pd.loadType }">
            </c:when>
            <c:otherwise>
            <a href="<%=basePath %>app_task/listBoard.do?loadType=${pd.loadType }">
                </c:otherwise>
                </c:choose>

                <img src="static/app/images/left.png"/></a>
    </div>
    <!-- tab页 -->
    <div class="web_menu" style="width:90%; margin-left:20px;">
        <ul id="myTab" class="nav nav-tabs">
            <li class="active" style="width:30%;"><a style="width:100%; padding-right:0; padding-left:0;" href="#detail"
                                                     data-toggle="tab">目标详情</a></li>
            <li style="width:30%;"><a style="width:100%; padding-right:0; padding-left:0;" href="#taskList"
                                      data-toggle="tab">工作列表</a></li>
            <li style="width:30%;"><a style="width:100%; padding-right:0; padding-left:0;" href="#commentList"
                                      data-toggle="tab">批示列表</a></li>
        </ul>
    </div>
    <div id="normal" class="normal" style="width: 100%;text-align: right">
        <c:if test="${pd.show==2 }"><!-- 员工日清 -->
        <a class="btn btn-mini btn-info" onclick="addDailyTask();" style="margin: 5px 2px 0 0;">添加日清</a>
        </c:if>
        <c:if test="${pd.show==3 }"><!-- 领导-日清看板 -->
        <a class="btn btn-mini btn-info" onclick="addComment();" style="margin: 5px 2px 0 0;  ">添加日清批示</a>
        </c:if>
        <c:if test="${pd.userRoleName=='PI' && pd.isOverDay}">
            <a class="btn btn-mini btn-info" onclick="addDailyTaskByPI();" style="margin: 5px 3px 0 0; float:right;">补录日清</a>
        </c:if>

    </div>
</div>

<div id="zhongxin" style="width:98%; margin: 30px auto; border: none" class="tab-content">
    <!-- 目标详情 -->
    <div class="tab-pane fade in active" id="detail">
        <table style="width: 100%;">
            <tr>
                <td style="text-align: center;"><label>年度目标：</label></td>
                <td style="text-align: left;">
                    <input type="text" readonly="readonly" value="${weekTask.TARGET_NAME }"
                           class="title" title="${weekTask.TARGET_NAME }"/></td>
            </tr>
            <tr>
                <td style="text-align: center;"><label>产品名称：</label></td>
                <td style="text-align: left;"><input type="text" readonly="readonly" value="${weekTask.PRODUCT_NAME }"
                                                     class="title" title="${weekTask.PRODUCT_NAME }"/></td>
            </tr>
            <tr>
                <td style="text-align: center;"><label>目标类型：</label></td>
                <td style="text-align: left;"><input type="text" readonly="readonly" value="${weekTask.typeName }"
                                                     class="title" title="${weekTask.typeName }"/></td>
            </tr>
            <tr>
                <td style="text-align: center;"><label>经营指标：</label></td>
                <td style="text-align: left;"><input type="text" readonly="readonly" value="${weekTask.INDEX_NAME }"
                                                     class="title" title="${weekTask.INDEX_NAME }"/></td>
            </tr>
            <tr>
                <td style="text-align: center;"><label>工作年度：</label></td>
                <td style="text-align: left;"><input type="text" readonly="readonly" value="${weekTask.YEAR }"/></td>
            </tr>

            <tr>
                <td style="text-align: center;"><label>月度：</label></td>
                <td style="text-align: left;"><input type="text" readonly="readonly" value="${weekTask.MONTH }"/></td>
            </tr>
            <tr>
                <td style="text-align: center;"><label>周次：</label></td>
                <td style="text-align: left;"><input type="text" readonly="readonly" value="${weekTask.WEEK }"/></td>
            </tr>
            <tr>
                <td style="text-align: center;"><label>开始时间：</label></td>
                <td style="text-align: left;"><input type="text" readonly="readonly"
                                                     value="${weekTask.WEEK_START_DATE }"/></td>
            </tr>
            <tr>
                <td style="text-align: center;"><label>结束时间：</label></td>
                <td style="text-align: left;"><input type="text" readonly="readonly"
                                                     value="${weekTask.WEEK_END_DATE }"/></td>
            </tr>
            <tr>
                <td style="text-align: center;"><label>周任务量：</label></td>
                <td style="text-align: left;"><input type="text" readonly="readonly"
                                                     value="${weekTask.WEEK_COUNT } ${weekTask.UNIT_NAME }"/></td>
            </tr>
            <tr>
                <td style="text-align: center;"><label>计划进度：</label></td>
                <td style="text-align: left;">
                    <div class="progress progress-info progress-striped opacity"
                         style="height: 30px; margin-bottom:0px; border: 1px solid #ccc;">
                        <div class="bar" style="width: ${weekTask.plan_percent }%; line-height: 30px;">
                            <span style="color:black">${weekTask.plan_percent }%</span>
                        </div>
                    </div>
                </td>
            </tr>

            <tr>
                <td style="text-align: center;"><label>实际进度：</label></td>
                <td style="text-align: left;">
                    <div class="progress"
                         style="height:30px; margin:0px; background-color: #dadada; border: 1px solid #ccc;">
                        <c:choose>
                        <c:when test="${weekTask.overWidth>0 }">
                        <div class="progress-bar success" role="progressbar" aria-valuenow="60" aria-valuemin="0"
                             aria-valuemax="100" style="width: 100%; line-height: 30px; text-align: center">
                            </c:when>
                            <c:otherwise>
                            <c:choose>
                            <c:when test="${weekTask.overProgress>=0 }">
                            <div class="progress-bar success" role="progressbar" aria-valuenow="60" aria-valuemin="0"
                                 aria-valuemax="100"
                                 style="width: ${weekTask.actual_percent }%; line-height: 30px; text-align: center">
                                </c:when>
                                <c:otherwise>
                                <div class="progress-bar warning" role="progressbar" aria-valuenow="60"
                                     aria-valuemin="0"
                                     aria-valuemax="100"
                                     style="width: ${weekTask.actual_percent }%; line-height: 30px; text-align: center">
                                    </c:otherwise>
                                    </c:choose>
                                    </c:otherwise>
                                    </c:choose>
                                    <span style="color: black">${weekTask.actual_percent }%</span>
                                </div>
                            </div>
                </td>
            </tr>
        </table>
    </div>
    <!-- 工作列表 -->
    <div class="tab-pane fade" id="taskList">
        <c:choose>
            <c:when test="${not empty emptaskList }">
                <c:forEach items="${emptaskList }" var="empTask" varStatus="vs">
                    <div class="keytask">
                        <table>
                            <tr>
                                <td style="width:80px">添加人:</td>
                                <td style="width:150px"><c:if
                                        test="${weekTask.EMP_NAME!=empTask.CREATE_USER }">PI补录-</c:if>
                                    ${empTask.CREATE_USER }</td>
                            </tr>
                            <tr>
                                <td>添加时间:</td>
                                <td><span>${empTask.CREATE_TIME }</span></td>
                            </tr>
                            <tr>
                                <td>当天完成:</td>
                                <td colspan="3"><span>${empTask.DAILY_COUNT }</span></td>
                            </tr>
                            <c:if test="${weekTask.TARGET_TYPE == 'XSH' }">
                                <tr>
                                    <td>客户名：</td>
                                    <td>${empTask.CUSTOM_NAME }</td>
                                </tr>
                                <tr>
                                    <td>产品：</td>
                                    <td>${weekTask.PRODUCT_NAME}</td>
                                </tr>
                                <tr>
                                    <td>销售量(吨)：</td>
                                    <td>${empTask.MONEY_COUNT}</td>
                                </tr>
                            </c:if>
                            <tr>
                                <td>差异分析:</td>
                                <td colspan="3"><span>${empTask.ANALYSIS }</span></td>
                            </tr>
                            <tr>
                                <td>关差措施:</td>
                                <td colspan="3"><span>${empTask.MEASURE }</span></td>
                            </tr>
                            <tr>
                                <td>当天进度:</td>
                                <td colspan="3"><span>${empTask.FINISH_PERCENT }%</span></td>
                            </tr>
                            <tr>
                                <td>进度滞后:</td>
                                <td colspan="3">
											<span>
												<c:if test="${empTask.ISDELAY==1 }">是</c:if>
												<c:if test="${empTask.ISDELAY==0 }">否</c:if>
											</span>
                                </td>
                            </tr>
                            <tr>
                                <td>审核人:</td>
                                <td colspan="3"><span>${empTask.UPDATE_USER_NAME }</span></td>
                            </tr>
                            <tr>
                                <td>状态:</td>
                                <td><span>${empTask.STATUS }</span></td>
                                <td colspan="2" style="text-align: right">
                                    <!-- 员工才可以删除 -->
                                    <c:if test="${pd.show==2 && empTask.STATUS=='草稿'}">
                                        <a style="cursor:pointer;" onclick="delTask(${empTask.ID})"
                                           title="删除" class='btn btn-mini btn-danger' data-rel="tooltip"
                                           data-placement="left">
                                            删除<i class="icon-trash"></i>
                                        </a>
                                    </c:if>
                                    <!-- 领导才可以审批 -->
                                    <c:if test="${pd.show==3 && empTask.STATUS=='草稿' }">
                                        <a style="cursor:pointer;"
                                           onclick="validate('${empTask.CREATE_TIME }', ${empTask.ID}, 1)"
                                           title="审核通过" class='btn btn-mini btn-success' data-rel="tooltip"
                                           data-placement="left">
                                            通过<i class="icon-check"></i>
                                        </a>
                                        <a style="cursor:pointer;"
                                           onclick="validate('${empTask.CREATE_TIME }', ${empTask.ID}, 0)"
                                           title="审核退回" class='btn btn-mini btn-danger' data-rel="tooltip"
                                           data-placement="left">
                                            退回<i class="icon-exclamation-sign"></i>
                                        </a>
                                    </c:if>
                                    <c:if test="${not empty empTask.FILENAME }">
                                        <a style="cursor:pointer;" onclick="loadFile('${empTask.FILENAME}')"
                                           title="查看附件" class='btn btn-mini btn-primary' data-rel="tooltip"
                                           data-placement="left">
                                            附件<i class="icon-eye-open"></i>
                                        </a>
                                    </c:if>
                                </td>
                            </tr>
                        </table>
                    </div>
                </c:forEach>
            </c:when>
            <c:otherwise>
                <span>没有数据</span>
            </c:otherwise>
        </c:choose>
    </div>
    <!-- 批示列表 -->
    <div class="tab-pane fade" id="commentList">
        <c:choose>
            <c:when test="${not empty commentList }">
                <c:forEach items="${commentList }" var="comment" varStatus="vs">
                    <div class="keytask">
                        <table>
                            <tr>
                                <td style="width:70px">添加时间:</td>
                                <td><span>${comment.CREATE_TIME }</span>
                                </td>
                            </tr>
                            <tr>
                                <td>批示内容:</td>
                                <td><span>${comment.COMMENT }</span>
                                </td>
                            </tr>
                            <tr>
                                <td>批示人:</td>
                                <td><span>${comment.CREATE_USER }</span>
                                </td>
                            </tr>
                        </table>
                    </div>
                </c:forEach>
            </c:when>
            <c:otherwise>
                <tr class="main_info">
                    <td colspan="100" class="center">没有相关数据</td>
                </tr>
            </c:otherwise>
        </c:choose>
    </div>
</div>

<div>
    <%@include file="../footer.jsp" %>
</div>

</body>
</html>