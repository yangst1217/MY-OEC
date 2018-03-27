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
    <title>日清页面</title>
    <base href="<%=basePath%>">
    <!-- jsp文件头和头部 -->
    <%@ include file="../system/admin/top.jsp" %>
    <link href="static/css/bootstrap.min.css" rel="stylesheet"/>
    <link href="static/css/style.css" rel="stylesheet"/>
    <link rel="stylesheet" href="static/css/font-awesome.min.css"/>
    <link rel="stylesheet" href="static/css/ace.min.css"/>
    <link rel="stylesheet" href="static/css/ace-rtl.min.css"/>
    <link rel="stylesheet" href="static/css/ace-skins.min.css"/>
    <link rel="stylesheet" href="static/css/star-rating.css"/>
    <style>

        .title {
            overflow: hidden;
            text-overflow: ellipsis;
            white-space: nowrap;
        }

        input {
            width: 95%;
        }

        .taskDetail td label {
            width: 100px;
            text-align: right;
        }

        .taskDetail td {
            width: 10%;
        }

        .success {
            background-color: #55b83b
        }

        .warning {
            background-color: #d20b44
        }
    </style>

    <script type="text/javascript" src="plugins/JQuery/jquery.min.js"></script>
    <script type="text/javascript" src="plugins/Bootstrap/js/bootstrap.min.js"></script>
    <script type="text/javascript" src="static/js/star-rating.js"></script>
    <script type="text/javascript">
        $(function () {
            var errorMsg = "${errorMsg}";
            if (errorMsg != "") {
                top.Dialog.alert(errorMsg);
            }
            // 星星打分
            $('.rater-star').rater();
        });

        //补录日清
        function addDailyTaskByPI() {
            if (${pd.overDays>3}) {
                top.Dialog.alert("超过3天不能补录");
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
                top.Dialog.alert("已超过任务结束时间，不能填报日清");
                return;
            }
            //没有活动分解项，则不能进行日清
            var splitCount = "${projectEvent.SPLIT_COUNT}";
            if (splitCount == "0") {
                top.Dialog.alert("创新活动没有未完成的分解项，不能添加日清");
                return;
            }
            var diag = new top.Dialog();
            diag.Drag = true;
            diag.Title = "新增日清";
            //本次日清需要完成的进度
            var taskCount = "${projectEvent.taskCount}";
            //alert(taskCount);
            //活动结束时间，用于计算是否超期
            var endDate = "${projectEvent.END_DATE }";
            diag.URL = '<%=basePath%>empDailyTask/toAddDailyTaskCreative.do?taskCount=' + taskCount
                + "&projectEventId=" + ${projectEvent.ID} +"&projectNodeId=" + ${projectEvent.C_PROJECT_NODE_ID}
                +"&endDate=" + endDate;
            diag.Width = 600;
            diag.Height = 500;
            diag.CancelEvent = function () { //关闭事件
                //window.location.reload();
                setTimeout("self.location=self.location", 100);
                diag.close();
            };
            diag.show();
        }

        //删除任务
        function delTask(id) {
            top.Dialog.confirm("确定要删除?", function () {
                var url = "<%=basePath%>empDailyTask/deleteEventEmpTask.do?id=" + id;
                $.get(url, function (data) {
                    if (data == "success") {
                        top.Dialog.alert("删除成功！");
                        window.location.reload();
                    } else {
                        top.Dialog.alert("删除失败！");
                    }
                }, "text");
            });
        }

        //日清任务-审核
        function validate(taskTime, id, isPass) {
            var cmd = "";
            if (isPass == 1) {
                cmd = "通过";
            } else {
                cmd = "退回";
            }
            top.Dialog.confirm("确认" + cmd + "?", function () {
                var url = "<%=basePath%>empDailyTask/validateEventEmpTask.do?id=" + id + "&isPass=" + isPass;
                url += "&projectEventId=${projectEvent.ID}" + "&taskTime=" + taskTime +
                    "&startDate=${projectEvent.START_DATE }&endDate=${projectEvent.END_DATE }";
                $.get(url, function (data) {
                    if (data == "success") {
                        top.Dialog.alert("审核成功！");
                        window.location.reload();
                    } else {
                        top.Dialog.alert("审核失败！");
                    }
                }, "text");
            });
        }

        //添加日清批示
        function addComment() {
            var diag = new top.Dialog();
            diag.Drag = true;
            diag.Title = "添加日清批示";
            diag.URL = "<%=basePath%>empDailyTask/toAddEventComment.do?eventId=${projectEvent.ID}";
            diag.Width = 350;
            diag.Height = 180;
            diag.CancelEvent = function () { //关闭事件
                setTimeout("self.location=self.location", 100);
                diag.close();
            };
            diag.show();
        }

        //评价活动
        function assessEvent() {
            if ($("#score").val() == '') {
                top.Dialog.alert("请评价活动!");
                return;
            }
            $.ajax({
                url: '<%=basePath%>empDailyTask/assessEvent.do?id=${projectEvent.ID}&score=' + $("#score").val(),
                type: 'post',
                dataType: 'text',
                success: function (data) {
                    if ("success" == data) {
                        $("#projectEventScore").val($("#score").val());
                        $("#scoreTr").removeClass("hide");
                        $("#assessBtn").hide();
                    } else {
                        top.Dialog.alert("评价活动失败，请联系管理员!");
                    }
                }
            });
        }

        //返回路径
        function backToList() {
            var actionPath = "listTask.do";
            var param = "?${pd.page}&status=${pd.status}&loadType=${pd.loadType}&back=1";
            if ("${pd.startDate}" != "") {
                param += "&startDate=${pd.startDate}";
            }
            if ("${pd.endDate}" != "") {
                param += "&endDate=${pd.endDate}";
            }
            if ("${pd.projectName}" != "") {
                param += "&projectName=${pd.projectName}";
            }
            //看板
            if ('${pd.showDept}' != '') {
                actionPath = "listTaskForDept.do";
                param += "&showDept=${pd.showDept}";
                if ("${pd.deptCode}" != "") {
                    param += "&deptCode=${pd.deptCode}";
                }
                if ("${pd.empCode}" != "") {
                    param += "&empCode=${pd.empCode}";
                }
            }
            //返回
            window.location.href = "<%=basePath%>empDailyTask/" + actionPath + param;
        }

        //下载文件
        function loadFile(fileName) {
            var action = '<%=basePath%>empDailyTask/checkFile.do';
            var time = new Date().getTime();
            $.ajax({
                type: "get",
                dataType: "text",
                data: {"fileName": fileName, "time": time},
                url: action,
                success: function (data) {
                    if (data == "") {
                        top.Dialog.alert("文件不存在！");
                        return;
                    }
                    window.location.href = '<%=basePath%>empDailyTask/loadFile.do?fileName=' + fileName + "&time=" + time;
                }
            });
        }
    </script>
</head>
<body>
<div class="container-fluid" id="main-container">

    <div id="page-content" class="clearfix">

        <div class="row-fluid">

            <div class="row-fluid">

                <!-- 检索  -->

                <div class="tabbable tabs-below">

                    <ul class="nav nav-tabs" id="menuStatus">
                        <li>
                            <!-- <a data-toggle="tab"> </a> -->
                            <img src="static/images/ui1.png" style="margin-top:-3px;">
                            员工-日清列表
                        </li>
                        <div class="nav-search" id="nav-search"
                             style="right:5px;" class="form-search">

                            <div style="float:left;" class="panel panel-default">
                                <div>
                                    <!--
									<c:choose>
										<c:when test="${not empty pd.showDept}">
											<a class="btn btn-small btn-danger" style="margin-right:5px;float:left;"
												href="<%=basePath%>empDailyTask/listDeptEmpTask.do?${pd.page}">返回</a>
										</c:when>
										<c:otherwise>
											<a class="btn btn-small btn-danger" style="margin-right:5px;float:left;"
												href="<%=basePath%>empDailyTask/listEmpWeekTask.do?${pd.page}">返回</a>
										</c:otherwise>
									</c:choose>
									 -->
                                    <a onclick="backToList();" class="btn btn-small btn-danger"
                                       style="margin-right:5px;float:left;">返回</a>
                                    <c:if test="${pd.userRoleName=='PI' && pd.isOverDay}">
                                        <a class="btn btn-small btn-info" onclick="addDailyTaskByPI();"
                                           style="margin-right:5px;float:left;">补录日清</a>
                                    </c:if>
                                    <c:if test="${pd.show==2 }">
                                        <a class="btn btn-small btn-info" onclick="addDailyTask();"
                                           style="margin-right:5px;float:left;">添加日清</a>
                                    </c:if>
                                    <c:if test="${pd.show==3 }">
                                        <c:if test="${projectEvent.actual_percent==100.00 && empty projectEvent.SCORE}">
                                            <a id="assessBtn" class="btn btn-small btn-info" data-toggle="modal"
                                               data-target="#assessModal"
                                               style="margin-right:5px;float:left;">评价活动</a>
                                        </c:if>
                                        <a class="btn btn-small btn-info" onclick="addComment();"
                                           style="margin-right:5px;float:left;">添加日清批示</a>
                                    </c:if>
                                </div>
                            </div>
                        </div>
                    </ul>
                </div>

                <!-- 评价模态框（Modal） -->
                <div class="modal fade" id="assessModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel"
                     aria-hidden="true">
                    <div class="modal-dialog">
                        <div class="modal-content">
                            <div class="modal-header">
                                <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;
                                </button>
                                <h4 class="modal-title" id="myModalLabel">评价活动</h4>
                            </div>
                            <div class="modal-body">
                                <span class="rater-star"></span>
                                <input class="rater-star-socre" type="hidden" id="score" name="score"/>
                            </div>
                            <div class="modal-footer">
                                <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
                                <button type="button" class="btn btn-primary" data-dismiss="modal"
                                        onclick="assessEvent()">提交
                                </button>
                            </div>
                        </div><!-- /.modal-content -->
                    </div><!-- /.modal -->
                </div>

                <!-- 项目节点活动信息开始 -->
                <div style="height: 20%; margin: 20px auto">
                    <div class="controls-row" style="margin-top: 10px;position: relative">
                        <table class="taskDetail" style="table-layout:fixed">
                            <tr>
                                <td><label>项目名称：</label></td>
                                <td style="width: 18%"><input type="text" readonly="readonly"
                                                              value="${projectEvent.PROJECT_NAME }"
                                                              class="title" title="${projectEvent.PROJECT_NAME }"/></td>
                                <td><label>节点名称：</label></td>
                                <td style="width: 18%"><input type="text" readonly="readonly"
                                                              value="${projectEvent.NODE_TARGET }"
                                                              class="title" title="${projectEvent.NODE_TARGET }"/></td>
                                <td><label>权重：</label></td>
                                <td><input type="text" readonly="readonly" value="${projectEvent.WEIGHT }"
                                           style="width:100%; padding:4px 0;"/></td>
                            </tr>
                            <tr>
                                <td><label>活动名称：</label></td>
                                <td><input type="text" readonly="readonly" value="${projectEvent.EVENT_NAME }"
                                           class="title" title="${projectEvent.EVENT_NAME }"/></td>
                                <td><label>活动类型：</label></td>
                                <td><input type="text" readonly="readonly" value="${projectEvent.TYPE }"/></td>
                                <%-- <td><label>活动成本：</label></td>
                                <td><input type="text" readonly="readonly" value="${projectEvent.COST }" style="width:100%; padding:4px 0;"/></td> --%>
                                <td><label>计划进度：</label></td>
                                <!-- 
                                <td><input type="text" readonly="readonly" value="${projectEvent.plan_percent }%" width="150px"/></td>
                                 -->
                                <td>
                                    <div class="progress progress-info progress-striped opacity"
                                         style="height: 30px; margin-bottom:0px; width:100%; border: 1px solid #ccc;">
                                        <div class="bar"
                                             style="width: ${projectEvent.plan_percent }%; line-height: 30px;">
                                            <span style="color:black">${projectEvent.plan_percent }%</span>
                                        </div>
                                    </div>
                                </td>
                            </tr>
                            <tr>
                                <td><label>开始时间：</label></td>
                                <td><input type="text" readonly="readonly" value="${projectEvent.START_DATE }"/></td>
                                <td><label>结束时间：</label></td>
                                <td><input type="text" readonly="readonly" value="${projectEvent.END_DATE }"/></td>
                                <td><label>实际进度：</label></td>
                                <td>
                                    <div class="progress"
                                         style="height:30px; margin:0px; background-color: #dadada; border: 1px solid #ccc;">
                                        <c:choose>
                                        <c:when test="${projectEvent.overProgress>=0 }">
                                        <div class="progress-bar success" role="progressbar" aria-valuenow="60"
                                             aria-valuemin="0"
                                             aria-valuemax="100"
                                             style="width: ${projectEvent.actual_percent }%; line-height: 30px; text-align: center">
                                            </c:when>
                                            <c:otherwise>
                                            <div class="progress-bar warning" role="progressbar" aria-valuenow="60"
                                                 aria-valuemin="0"
                                                 aria-valuemax="100"
                                                 style="width: ${projectEvent.actual_percent }%; line-height: 30px; text-align: center">
                                                </c:otherwise>
                                                </c:choose>
                                                <span style="color: black">${projectEvent.actual_percent }%</span>
                                            </div>
                                        </div>
                                </td>
                            </tr>
                            <%-- <tr>
                                <td><label title="当SPI>1时，表示进度提前，即实际进度比计划进度快；当SPI<1时，表示进度延误，即实际进度比计划进度慢">进度绩效指数SPI：</label></td>
                                <td><input type="text" readonly="readonly" value="${projectEvent.spi }"/></td>
                                <td><label>预计完成时间：</label></td>
                                <td><input type="text" readonly="readonly" value="${projectEvent.expect_date }"/></td>

                            </tr> --%>
                            <tr id="scoreTr" <c:if test="${empty projectEvent.SCORE }">class="hide"</c:if>>
                                <td><label>得分：</label></td>
                                <td><input id="projectEventScore" type="text" readonly="readonly"
                                           value="${projectEvent.SCORE }"/></td>
                                <td><label>评价人：</label></td>
                                <td><input id="checkEmpName" type="text" readonly="readonly"
                                           value="${projectEvent.CHECK_EMP_NAME }"/></td>
                            </tr>
                        </table>
                    </div>
                </div>
                <!-- 项目节点活动信息结束 -->

                <hr style="height: 1px;border:none;border-top: 1px solid grey;margin: 6px 0">

                <!-- 活动日清列表开始 -->
                <div style="height: 40%; width:98%; margin: 10px auto;">
                    <div class="span12" style="margin-left: 30px;">
                        <div class="span6" style="text-align: left">
                            <h4>日清列表</h4>
                        </div>
                    </div>
                    <table style="table-layout:fixed;" id="table_report"
                           class="table table-striped table-bordered table-hover">
                        <thead>
                        <tr>
                            <th width="40px">序号</th>
                            <th width="100px">添加时间</th>
                            <th width="100px">添加人</th>
                            <th width="20%">完成活动</th>
                            <th width="20%">差异分析</th>
                            <th width="20%">关差措施</th>
                            <th width="100px">当天完成进度</th>
                            <th width="80px">进度是否滞后</th>
                            <th width="80px">审核人</th>
                            <th width="80px">状态</th>
                            <th width="140px" class="center">操作</th>
                        </tr>
                        </thead>
                        <tbody>
                        <c:choose>
                            <c:when test="${not empty emptaskList}">
                                <c:forEach items="${emptaskList }" var="empTask" varStatus="vs">
                                    <tr>
                                        <td>${vs.index+1 }</td>
                                        <td>${empTask.CREATE_TIME }</td>
                                        <td><c:if test="${projectEvent.EMP_NAME!=empTask.CREATE_USER }">PI补录-</c:if>
                                            ${empTask.CREATE_USER }</td>
                                        <td class="title" title="${empTask.splitName }">${empTask.splitName }</td>
                                        <td class="title" title="${empTask.ANALYSIS }">${empTask.ANALYSIS }</td>
                                        <td class="title" title="${empTask.MEASURE }">${empTask.MEASURE }</td>
                                        <td>${empTask.FINISH_PERCENT }%</td>
                                        <td><c:if test="${empTask.ISDELAY==1 }">是</c:if>
                                            <c:if test="${empTask.ISDELAY==0 }">否</c:if>
                                        </td>
                                        <td>${empTask.CHECK_EMP_NAME }</td>
                                        <td>${empTask.STATUS }</td>
                                        <td>
                                            <!-- 员工才可以删除 -->
                                            <c:if test="${pd.show==2 && empTask.STATUS=='草稿'}">
                                                <a style="cursor:pointer;" onclick="delTask(${empTask.ID})"
                                                   title="删除" class='btn btn-mini btn-danger' data-rel="tooltip"
                                                   data-placement="left">
                                                    <i class="icon-trash"></i>
                                                </a>
                                            </c:if>
                                            <!-- 领导才可以审批 -->
                                            <c:if test="${pd.show==3 && empTask.STATUS=='草稿' }">
                                                <a style="cursor:pointer;"
                                                   onclick="validate('${empTask.CREATE_TIME }', ${empTask.ID}, 1)"
                                                   title="审核通过" class='btn btn-mini btn-success' data-rel="tooltip"
                                                   data-placement="left">
                                                    <i class="icon-check"></i>
                                                </a>
                                                <a style="cursor:pointer;"
                                                   onclick="validate('${empTask.CREATE_TIME }', ${empTask.ID}, 0)"
                                                   title="审核退回" class='btn btn-mini btn-danger' data-rel="tooltip"
                                                   data-placement="left">
                                                    <i class="icon-exclamation-sign"></i>
                                                </a>
                                            </c:if>
                                            <c:if test="${not empty empTask.FILENAME }">
                                                <a style="cursor:pointer;"
                                                   onclick="loadFile('${empTask.FILENAME_SERVER}')"
                                                   title="查看附件" class='btn btn-mini btn-primary' data-rel="tooltip"
                                                   data-placement="left">
                                                    <i class="icon-eye-open"></i>
                                                </a>
                                                <!--
                                                <a style="cursor:pointer;" href="<%=basePath%>empDailyTask/loadFile.do?fileName=${empTask.FILENAME}"
                                                title="查看附件" class='btn btn-mini btn-primary' data-rel="tooltip" data-placement="left">
                                                <i class="icon-eye-open"></i>
                                                </a>
                                                -->
                                            </c:if>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </c:when>
                            <c:otherwise>
                                <tr class="main_info">
                                    <td colspan="100" class="center">没有相关数据</td>
                                </tr>
                            </c:otherwise>
                        </c:choose>
                        </tbody>
                    </table>
                </div>
                <!-- 活动日清列表结束 -->

                <!-- 批示列表开始 -->
                <div style="height:40%; width:98%; margin: 10px auto; ">
                    <div class="span12" style="margin-left: 30px;">
                        <div class="span6" style="text-align: left">
                            <h4>批示列表</h4>
                        </div>
                    </div>
                    <table style="table-layout:fixed;" id="table_report"
                           class="table table-striped table-bordered table-hover">
                        <thead>
                        <tr>
                            <th width="10%">序号</th>
                            <th width="20%">添加时间</th>
                            <th width="50%">批示内容</th>
                            <th width="21%">批示人</th>
                        </tr>
                        </thead>
                        <tbody>
                        <c:choose>
                            <c:when test="${not empty commentList}">
                                <c:forEach items="${commentList }" var="comment" varStatus="vs">
                                    <tr>
                                        <td>${vs.index+1 }</td>
                                        <td>${comment.CREATE_TIME }</td>
                                        <td class="title" title="${comment.COMMENT }">${comment.COMMENT }</td>
                                        <td>${comment.CREATE_USER }</td>
                                    </tr>
                                </c:forEach>
                            </c:when>
                            <c:otherwise>
                                <tr class="main_info">
                                    <td colspan="100" class="center">没有相关数据</td>
                                </tr>
                            </c:otherwise>
                        </c:choose>
                        </tbody>
                    </table>
                </div>
                <!-- 批示列表结束 -->

            </div>
            <!-- PAGE CONTENT ENDS HERE -->
        </div><!--/row-->
    </div><!--/#page-content-->
</div><!--/.fluid-container#main-container-->


</body>
</html>