<%--
  Created by IntelliJ IDEA.
  User: yangdw
  Date: 2016/7/1
  Time: 10:11
  To change this template use File | Settings | File Templates.
  2016-07-08 yangdw 修改展示方式，默认将所有详情全部展开
--%>
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
    <title>日清详情页面</title>
    <base href="<%=basePath%>">
    <!-- jsp文件头和头部 -->
    <%@ include file="../../system/admin/top.jsp" %>
    <link href="static/css/style.css" rel="stylesheet"/>
    <!-- 引入 -->
    <script type="text/javascript">window.jQuery || document.write("<script src='static/js/jquery-1.9.1.min.js'>\x3C/script>");</script>
    <script src="static/js/bootstrap.min.js"></script>
    <script src="static/js/ace-elements.min.js"></script>
    <script src="static/js/ace.min.js"></script>

    <script type="text/javascript" src="static/js/chosen.jquery.min.js"></script><!-- 下拉框 -->
    <script type="text/javascript" src="static/js/bootstrap-datepicker.min.js"></script><!-- 日期框 -->
    <script type="text/javascript" src="static/js/bootbox.min.js"></script><!-- 确认窗口 -->
    <script type="text/javascript" src="static/js/jquery.tips.js"></script><!--提示框-->
    <!-- 引入 -->

    <style>
        #detail_table thead th {
            text-align: center;
            vertical-align: middle;
        }

        #detail_table tbody tr td {
            text-align: center;
            vertical-align: middle;
        }
    </style>
</head>
<body>
<input type="hidden" name="flag" id="flag" value="${flag}" title="新增修改成功标志"/>
<div class="tabbable tabs-below">
    <ul class="nav nav-tabs" id="menuStatus">
        <li>
            <img src="static/images/ui1.png" style="margin-top:-3px;">
            日清详情
        </li>

        <div class="nav-search" id="nav-search" style="right:5px;" class="form-search">
            <div style="float:left;" class="panel panel-default">
                <div>
                    <a class="btn btn-mini btn-primary" onclick="save();"
                       style="float:left;margin-right:5px;">保存</a>
                    <a class="btn btn-mini btn-danger" onclick="goBack();"
                       style="float:left;margin-right:5px;">返回</a>
                </div>
            </div>
        </div>
    </ul>
</div>
<div id="zhongxin">
    <!-- 基础信息开始-->
    <table style="margin-left: 50px;" id="target_table"><br>
        <tr>
            <td>
                <label>姓名：</label>
            </td>
            <td>
                <input value="${baseDate.EMP_NAME}" type="text" readonly="readonly"/>
            </td>
            <td>
                <label>日期：</label>
            </td>
            <td>
                <input value="<fmt:formatDate value="${baseDate.DATE}" type="date"/>" type="text" readonly="readonly"/>
            </td>
        </tr>
        <tr>
            <td>
                <label>岗位：</label>
            </td>
            <td>
                <input value="${baseDate.GRADE_NAME}" type="text" readonly="readonly"/>
            </td>
            <td>
                <label>部门：</label>
            </td>
            <td>
                <input value="${baseDate.DEPT_NAME}" type="text" readonly="readonly"/>
            </td>
        </tr>
    </table>
    <!-- 基础信息结束-->

    <hr style="height:1px;border:none;border-top:1px solid grey;margin: 6px 0;"/>
    <div class="row">
        <div class="span12">
            <div class="span6" style="text-align: left">
                <h4>分解列表</h4>
            </div>
        </div>
        <form action="positionDailyTask/detailChange.do" name="Form" id="Form" method="post">
            <input type="hidden" value="${pd.from}" name="from"/>
            <input type="hidden" value="${PARENT_FRAME_ID}" name="PARENT_FRAME_ID" id="PARENT_FRAME_ID">
            <input type="hidden" value="${positionDailyTask.ID}" name="daily_task_id"/>
            <input value="<fmt:formatDate value="${baseDate.DATE}" type="date"/>" type="hidden" name="date"/>
            <div class="span12">
                <!--详情表格开始-->
                <table id="detail_table" class="table table-striped table-bordered table-hover"><br>
                    <thead>
                    <th>序号</th>
                    <th>岗位职责</th>
                    <th>工作明细选择</th>
                    <th>数量</th>
                    <th>单位</th>
                    <th>操作</th>
                    </thead>
                    <tbody>
                    <c:forEach items="${responseList}" var="response" varStatus="vs">
                        <tr>
                            <td class='center' style="width: 30px;" name='vs_td'>${vs.index+1}</td>
                            <td>${response.responsibility}</td>
                            <td>
                                <input type="hidden" name="detail_id" value="${response.ID}"/>
                                <input value="${response.detail}" type="text" readonly="readonly"/>
                            </td>
                            <td name="count_td">
                                <input
                                        <c:forEach items="${detailList}" var="detail" varStatus="vs">
                                            <c:if test="${detail.detail_id == response.ID}">value='${detail.count}'</c:if>
                                        </c:forEach>
                                        name='count'/>
                            </td>
                            <td>
                                    ${response.unit}
                            </td>
                            <td>
                                <a style="cursor:pointer;" title="维护时间" onclick="changeTime($(this))"
                                   class='btn btn-mini btn-warning' data-rel="tooltip" data-placement="left">
                                    <i class="icon-exchange"></i>
                                </a>
                            </td>
                            <input type="hidden" name="ID"
                                    <c:forEach items="${detailList}" var="detail" varStatus="vs">
                                        <c:if test="${detail.detail_id == response.ID}">value='${detail.ID}'</c:if>
                                    </c:forEach>
                            />
                            <input type="hidden" name="START_TIME_ARR"
                                    <c:forEach items="${detailList}" var="detail" varStatus="vs">
                                        <c:if test="${detail.detail_id == response.ID}">value='${detail.START_TIME_ARR}'</c:if>
                                    </c:forEach>
                            />
                            <input type="hidden" name="END_TIME_ARR"
                                    <c:forEach items="${detailList}" var="detail" varStatus="vs">
                                        <c:if test="${detail.detail_id == response.ID}">value='${detail.END_TIME_ARR}'</c:if>
                                    </c:forEach>
                            />
                        </tr>
                    </c:forEach>
                    </tbody>
                </table>
                <!--详情表格结束-->
            </div>
        </form>
    </div>
</div>
</body>

<!-- 按钮js -->
<script type="text/javascript">

    //维护时间
    function changeTime(obj) {
        var url = '<%=basePath%>/positionDailyTask/changeTime.do?Date=' + '<fmt:formatDate value="${baseDate.DATE}" type="date"/>';
        url += '&START_TIME_ARR=' + $(obj).parent().siblings("input[name='START_TIME_ARR']").val();
        url += '&END_TIME_ARR=' + $(obj).parent().siblings("input[name='END_TIME_ARR']").val();
        var diag = new top.Dialog();
        diag.Drag = true;
        diag.Title = "修改时间";
        diag.URL = url;
        diag.Width = 1050;
        diag.Height = 520;
        diag.ShowOkButton = true;
        diag.ShowCancelButton = false;
        diag.OKEvent = function () {
            $(obj).parent().siblings("input[name='START_TIME_ARR']").val(diag.innerFrame.contentWindow.document.getElementById('START_TIME_ARR').value);
            $(obj).parent().siblings("input[name='END_TIME_ARR']").val(diag.innerFrame.contentWindow.document.getElementById('END_TIME_ARR').value);
            alert("保存成功！");
            diag.close();
        };
        diag.show();
    }

    //返回
    function goBack() {
        if ('${pd.from}' == 'tasklist') {
            var param =
                "&deptCode=${pd.deptCode}&empCode=${pd.empCode}&productCode=${pd.productCode}&projectCode=${pd.projectCode}" +
                "&startDate=${pd.startDate}&endDate=${pd.endDate}&status=${pd.status}";

            window.location.href = "<%=basePath%>empDailyTask/listEmpWeekTask.do?${pd.page}" + param;
        } else {
            $("#" + $('#PARENT_FRAME_ID').val(), window.parent.document).trigger("click");
            $("#page_" + $('#PARENT_FRAME_ID').val(), window.parent.document).attr('src', $("#page_" + $('#PARENT_FRAME_ID').val(), window.parent.document).attr('src'));
            $("#positionDailyTaskDetail", window.parent.document).children().find(".tab_close").trigger("click");
        }
    }

    //保存
    function save() {
        var status = 'true';
        var objList = document.getElementsByName('ID');
        var startTimeList = document.getElementsByName('START_TIME_ARR');
        var endTimeList = document.getElementsByName('END_TIME_ARR');
        if (objList.length == 0) {
            alert("请至少添加一个分解！");
            return false;
        }
        $(startTimeList).each(function () {
            if ((null == $(this).val() || "" == $(this).val() || "0" == $(this).val()) &&
                (null != $(this).siblings("td[name='count_td']").find("input[name='count']") &&
                    "" != $(this).siblings("td[name='count_td']").find("input[name='count']").val() &&
                    "0" != $(this).siblings("td[name='count_td']").find("input[name='count']").val())) {
                $(this).parent().tips({
                    side: 3,
                    msg: '尚未添加时间段！',
                    bg: '#AE81FF',
                    time: 2
                });
                status = 'false';
            }
            ;
        });
        $(endTimeList).each(function () {
            if ((null == $(this).val() || "" == $(this).val() || "0" == $(this).val()) &&
                (null != $(this).siblings("td[name='count_td']").find("input[name='count']") &&
                    "" != $(this).siblings("td[name='count_td']").find("input[name='count']").val() &&
                    "0" != $(this).siblings("td[name='count_td']").find("input[name='count']").val())) {
                $(this).parent().tips({
                    side: 3,
                    msg: '尚未添加时间段！',
                    bg: '#AE81FF',
                    time: 2
                });
                status = 'false';
            }
            ;
        });
        if (status == 'true') {
            $("#Form").submit();
        }
    }
</script>
<!-- 按钮js -->

<!-- 预加载js -->
<script type="text/javascript">
    //是否保存成功
    window.onload = function () {
        if ($("#flag").val() == "success") {
            alert("保存成功！");
        } else if ($("#flag").val() == "false") {
            alert("保存失败！");
        }
    };

    //已有明细不可选
    $(function () {
        //默认数字是0
        $("input[name='count']").each(function () {
            if ('' == $(this).val()) {
                $(this).val("0");
            }
        })
    });

</script>
<!-- 预加载js -->
</html>
