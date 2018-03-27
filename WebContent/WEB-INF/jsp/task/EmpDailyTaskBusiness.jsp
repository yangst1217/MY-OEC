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
    <style>
        .title {
            overflow: hidden;
            text-overflow: ellipsis;
            white-space: nowrap;
        }

        .taskDetail input {
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
    <script type="text/javascript">
        $(function () {
            var errorMsg = "${errorMsg}";
            if (errorMsg != "") {
                top.Dialog.alert(errorMsg);
            }
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
            //本次日清需要完成的量
            var taskCount = "${weekTask.taskCount}";
            //本周的工作量
            var weekCount = "${weekTask.WEEK_COUNT }";
            var endDate = "${weekTask.WEEK_END_DATE }";
            //alert(taskCount);
            var diag = new top.Dialog();
            diag.Drag = true;
            diag.Title = "新增日清";
            diag.URL = '<%=basePath%>empDailyTask/toAddDailyTask.do?taskCount=' + taskCount +
                "&weekCount=" + weekCount + "&weekTaskId=" + ${weekTask.ID} +"&endDate=" + endDate;
            // + "&product=" + ${weekTask.PRODUCT_NAME }
            diag.Width = 500;
            diag.Height = 450;
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
                var url = "<%=basePath%>empDailyTask/deleteDailyEmpTask.do?id=" + id;
                $.get(url, function (data) {
                    if (data == "success") {
                        top.Dialog.alert("删除成功！");
                        window.location.reload();
                        //window.location.href="<%=basePath%>empDailyTask/listBusinessEmpTask.do?weekEmpTaskId=${weekTask.ID}&show=${pd.show}";
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
                var url = "<%=basePath%>empDailyTask/validateDailyEmpTask.do?id=" + id + "&isPass=" + isPass;
                url += "&weekTaskId=${weekTask.ID}" + "&taskTime=" + taskTime +
                    "&startDate=${weekTask.WEEK_START_DATE }&endDate=${weekTask.WEEK_END_DATE }";
                $.get(url, function (data) {
                    if (data == "success") {
                        top.Dialog.alert("审核成功！");
                        window.location.reload();
                        //window.location.href="<%=basePath%>empDailyTask/listBusinessEmpTask.do?weekEmpTaskId=${weekTask.ID}&show=${pd.show}";
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
            diag.URL = "<%=basePath%>empDailyTask/toAddComment.do?weekTaskId=${weekTask.ID}";
            diag.Width = 350;
            diag.Height = 180;
            diag.CancelEvent = function () { //关闭事件
                setTimeout("self.location=self.location", 100);
                diag.close();
            };
            diag.show();
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
            if ("${pd.productName}" != "") {
                param += "&productName=${pd.productName}";
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
                                    <a onclick="backToList()" class="btn btn-small btn-danger"
                                       style="margin-right:5px;float:left;">返回</a>
                                    <c:if test="${pd.userRoleName=='PI' && pd.isOverDay}">
                                        <a class="btn btn-small btn-info" onclick="addDailyTaskByPI();"
                                           style="margin-right:5px;float:left;">补录日清</a>
                                    </c:if>
                                    <c:if test="${pd.show==2 }"><!-- 员工日清 -->
                                    <a class="btn btn-small btn-info" onclick="addDailyTask();"
                                       style="margin-right:5px;float:left;">添加日清</a>
                                    </c:if>
                                    <c:if test="${pd.show==3 }"><!-- 领导-日清看板 -->
                                    <a class="btn btn-small btn-info" onclick="addComment();"
                                       style="margin-right:5px;float:left;">添加日清批示</a>
                                    </c:if>
                                </div>
                            </div>
                        </div>
                    </ul>
                </div>

                <!-- 周工作目标开始 -->
                <div style="height: 20%; width:98%; margin: 20px auto">
                    <div class="controls-row" style="margin-top: 10px;position: relative">
                        <table class="taskDetail" style="table-layout:fixed">
                            <tr>
                                <td><label>年度目标：</label></td>
                                <td style="width: 18%"><input type="text" readonly="readonly"
                                                              value="${weekTask.TARGET_NAME }"
                                                              class="title" title="${weekTask.TARGET_NAME }"/></td>
                                <td><label>经营指标：</label></td>
                                <td style="width: 18%"><input type="text" readonly="readonly"
                                                              value="${weekTask.INDEX_NAME }"
                                                              class="title" title="${weekTask.INDEX_NAME }"/></td>
                                <td><label>工作年度：</label></td>
                                <td><input type="text" readonly="readonly" value="${weekTask.YEAR }"
                                           style="width:100%; padding:4px 0;"/></td>
                            </tr>
                            <tr>
                                <td><label>产品名称：</label></td>
                                <td><input type="text" readonly="readonly" value="${weekTask.PRODUCT_NAME }"
                                           class="title" title="${weekTask.PRODUCT_NAME }"/></td>
                                <td><label>月度：</label></td>
                                <td><input type="text" readonly="readonly" value="${weekTask.MONTH }"/></td>
                                <td><label>周次：</label></td>
                                <td><input type="text" readonly="readonly" value="${weekTask.WEEK }"
                                           style="width:100%; padding:4px 0;"/></td>
                            </tr>
                            <tr>
                                <td><label>开始时间：</label></td>
                                <td><input type="text" readonly="readonly" value="${weekTask.WEEK_START_DATE }"/></td>
                                <td><label>结束时间：</label></td>
                                <td><input type="text" readonly="readonly" value="${weekTask.WEEK_END_DATE }"/></td>
                                <td><label>计划进度：</label></td>
                                <!--
								<td><input type="text" readonly="readonly" value="${weekTask.plan_percent }%" width="100px"/></td>
								 -->
                                <td>
                                    <div class="progress progress-info progress-striped opacity"
                                         style="height: 30px; margin-bottom:0px; width:100%; border: 1px solid #ccc;">
                                        <div class="bar" style="width: ${weekTask.plan_percent }%; line-height: 30px;">
                                            <span style="color:black">${weekTask.plan_percent }%</span>
                                        </div>
                                    </div>
                                </td>
                            </tr>
                            <tr>
                                <td><label>周任务量：</label></td>
                                <td><input type="text" readonly="readonly" value="${weekTask.WEEK_COUNT }"/></td>
                                <td><label>单位：</label></td>
                                <td><input type="text" readonly="readonly" value="${weekTask.UNIT_NAME }"/></td>
                                <td><label>实际进度：</label></td>
                                <td>
                                    <div class="progress"
                                         style="height:30px; margin:0px; background-color: #dadada; border: 1px solid #ccc;">
                                        <c:choose>
                                        <c:when test="${weekTask.overWidth>0 }">
                                        <div class="progress-bar success" role="progressbar" aria-valuenow="60"
                                             aria-valuemin="0"
                                             aria-valuemax="100"
                                             style="width: 100%; line-height: 30px; text-align: center">
                                            </c:when>
                                            <c:otherwise>
                                            <c:choose>
                                            <c:when test="${weekTask.overProgress>=0 }">
                                            <div class="progress-bar success" role="progressbar" aria-valuenow="60"
                                                 aria-valuemin="0"
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
                </div>
                <!-- 周工作目标结束 -->

                <hr style="height: 1px;border:none;border-top: 1px solid grey;margin: 6px 0">

                <!-- 工作列表开始 -->
                <div style="height: 40%; width:98%; margin: 10px auto;">
                    <div class="span12" style="margin-left: 30px;">
                        <div class="span6" style="text-align: left">
                            <h4>工作列表</h4>
                        </div>
                    </div>
                    <table style="table-layout:fixed;" id="table_report"
                           class="table table-striped table-bordered table-hover">
                        <thead>
                        <tr>
                            <th width="40px">序号</th>
                            <th width="100px">添加时间</th>
                            <th width="100px">添加人</th>
                            <th width="100px">当天完成数量</th>
                            <c:if test="${weekTask.TARGET_TYPE == 'XSH' }">
                                <th width="100px">销售量(吨)</th>
                                <th width="100px">客户</th>
                            </c:if>
                            <th width="30%">差异分析</th>
                            <th width="30%">关差措施</th>
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
                                        <td><c:if test="${weekTask.EMP_NAME!=empTask.CREATE_USER }">PI补录-</c:if>
                                            ${empTask.CREATE_USER }</td>
                                        <td>${empTask.DAILY_COUNT }</td>
                                        <c:if test="${weekTask.TARGET_TYPE == 'XSH' }">
                                            <td>${empTask.MONEY_COUNT }</td>
                                            <td>${empTask.CUSTOM_NAME }</td>
                                        </c:if>
                                        <td class="title" title="${empTask.ANALYSIS }">${empTask.ANALYSIS }</td>
                                        <td class="title" title="${empTask.MEASURE }">${empTask.MEASURE }</td>
                                        <td>${empTask.FINISH_PERCENT }%</td>
                                        <td><c:if test="${empTask.ISDELAY==1 }">是</c:if>
                                            <c:if test="${empTask.ISDELAY==0 }">否</c:if>
                                        </td>
                                        <td>${empTask.UPDATE_USER_NAME }</td>
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
                                                <!--
                                                <a style="cursor:pointer;" href="<%=basePath%>empDailyTask/loadFile.do?fileName=${empTask.FILENAME}"
                                                title="查看附件" class='btn btn-mini btn-primary' data-rel="tooltip" data-placement="left">
                                                <i class="icon-eye-open"></i>
                                                </a>
                                                -->
                                                <a style="cursor:pointer;"
                                                   onclick="loadFile('${empTask.FILENAME_SERVER}')"
                                                   title="查看附件" class='btn btn-mini btn-primary' data-rel="tooltip"
                                                   data-placement="left">
                                                    <i class="icon-eye-open"></i>
                                                </a>
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
                <!-- 工作列表结束 -->

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