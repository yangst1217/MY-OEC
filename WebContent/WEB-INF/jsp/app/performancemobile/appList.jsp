<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%
    String path = request.getContextPath();
    String basePath = request.getScheme() + "://"
            + request.getServerName() + ":" + request.getServerPort()
            + path + "/";
%>

<!DOCTYPE html>
<html lang="zh_CN">
<head>
    <base href="<%=basePath%>">
    <meta name="viewport"
          content="width=device-width,initial-scale=1.0, minimum-scale=1.0, maximum-scale=1.0, user-scalable=no,minimal-ui"/>

    <link href="static/css/bootstrap-responsive.min.css" rel="stylesheet"/>
    <link rel="stylesheet" href="static/css/font-awesome.min.css"/>
    <link rel="stylesheet" href="static/css/app-style.css"/>
    <!-- 下拉框 -->
    <link rel="stylesheet" href="static/css/chosen.css"/>

    <link rel="stylesheet" href="static/css/ace.min.css"/>
    <link rel="stylesheet" href="static/css/ace-responsive.min.css"/>
    <link rel="stylesheet" href="static/css/ace-skins.min.css"/>

    <style>
        body {
            background: #f4f4f4;
        }

        .more {
            z-index: 999;
            width: 100%;
            display: none;
        }

        .more table tr td {
            padding-top: 5px;
            padding-bottom: 5px;
        }

        .tasklist table tr td {
            line-height: 1.3;
        }

        .keytask table tr td label {
            font-size: 14px;
        }

        .keytask table tr td span {
            font-size: 14px;
        }

        .keytask {
            padding: 0px;
            width: 100%;
        }

        td.wordlimit {
            padding-left: 0px;
            padding-right: 0px;
        }
    </style>
</head>

<body>
<div>
    <input type="hidden" id="currentPage" value="${page.currentPage}"/>
    <input type="hidden" id="totalPage" value="${page.totalPage}"/>
    <div id="normal" class="normal" style="width: 100%;text-align: right">
        <a class='btn btn-mini btn-primary'
           style="margin-top: 10px;margin-bottom:10px;margin-right: 10px;"
           onclick="showMore();">高级搜索</a>
    </div>


    <div id="more" class="more">
        <form id="searchForm" action="app_performance/list.do?currentPage=1" method="post">
            <table style="width: 100%;margin-top: 5px;">
                <tr>
                    <td>姓名:</td>
                    <td><input name="EMP_NAME" id="EMP_NAME" type="text"></td>
                </tr>
                <tr>
                    <td>工号:</td>
                    <td><input name="EMP_CODE" id="EMP_CODE" type="text"></td>
                </tr>

                <tr>
                    <td>部门:</td>
                    <td><input name="DEPT_NAME" id="DEPT_NAME" type="text"></td>
                </tr>
                <tr>
                    <td>年月:</td>
                    <td><input type="text" id="MONTH" name="MONTH"
                               placeholder="请输入年月"/></td>
                </tr>
                <tr>
                    <td colspan="2">
                        <a class='btn btn-mini btn-primary'
                           style="margin-top: 10px;margin-bottom:10px;margin-left: 220px;" onclick="toSearch();">查询</a>
                        <a class='btn btn-mini btn-primary' style="cursor: pointer;margin-left: 10px;"
                           onclick="emptySearch();">重置</a>
                    </td>
                </tr>
            </table>
        </form>
    </div>


    <div class="tasklist" id="tasklist">
        <c:choose>
            <c:when test="${not empty perList}">
                <c:forEach items="${perList }" var="per" varStatus="vs">
                    <c:choose>
                        <c:when test="${isLeader =='1'}">
                            <div class="keytask">
                                <a class="task_list"
                                   href="<%=basePath%>/app_performance/listTask.do?empCode=${per.EMP_CODE }&MONTH=${per.MONTH }&PERF_ID=${per.PERF_ID }&SCORE=${per.SCORE }">
                                    <table style="width:100%;">
                                        <tr>
                                            <td class="wordlimit">
                                                <label>员工号：</label><span>${per.EMP_CODE }</span>
                                            </td>
                                            <td class="wordlimit">
                                                <label>员工姓名：</label><span>${per.EMP_NAME }</span>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td class="wordlimit">
                                                <label>岗位：</label><span>${per.EMP_GRADE_NAME }</span>
                                            </td>
                                            <td class="wordlimit">
                                                <label>部门：</label><span>${per.EMP_DEPARTMENT_NAME }</span>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td class="wordlimit">
                                                <label>年月：</label><span>${per.MONTH }</span>
                                            </td>
                                            <td class="wordlimit">
                                                <label>上月得分：</label><span>${per.LASTMONTH_SCORE }</span>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td class="wordlimit">
                                                <label>平均得分：</label><span>${per.AVERAGE_SCORE }</span>
                                            </td>
                                            <td class="wordlimit">
                                                <label>当月得分：</label><span>${per.SCORE }</span>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td class="wordlimit">
                                                <label>当月排名：</label><span>${per.RANKING }</span>
                                            </td>
                                        </tr>
                                    </table>
                                </a>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <c:choose>
                                <c:when test="${EMP_CODE == per.EMP_CODE}">
                                    <div class="keytask">
                                        <a class="task_list"
                                           href="<%=basePath%>/app_performance/listTask.do?empCode=${per.EMP_CODE }&MONTH=${per.MONTH }&PERF_ID=${per.PERF_ID }&SCORE=${per.SCORE }&SELF=1">
                                            <table style="width:100%;">
                                                <tr>
                                                    <td class="wordlimit">
                                                        <label>员工号：</label><span>${per.EMP_CODE }</span>
                                                    </td>
                                                    <td class="wordlimit">
                                                        <label>员工姓名：</label><span
                                                            style="color:blue">${per.EMP_NAME }</span>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td class="wordlimit">
                                                        <label>岗位：</label><span>${per.EMP_GRADE_NAME }</span>
                                                    </td>
                                                    <td class="wordlimit">
                                                        <label>部门：</label><span>${per.EMP_DEPARTMENT_NAME }</span>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td class="wordlimit">
                                                        <label>年月：</label><span>${per.MONTH }</span>
                                                    </td>
                                                    <td class="wordlimit">
                                                        <label>上月得分：</label><span>${per.LASTMONTH_SCORE }</span>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td class="wordlimit">
                                                        <label>平均得分：</label><span>${per.AVERAGE_SCORE }</span>
                                                    </td>
                                                    <td class="wordlimit">
                                                        <label>当月得分：</label><span>${per.SCORE }</span>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td class="wordlimit">
                                                        <label>当月排名：</label><span>${per.RANKING }</span>
                                                    </td>
                                                </tr>
                                            </table>
                                        </a>
                                    </div>
                                </c:when>
                                <c:otherwise>
                                    <div class="keytask">
                                        <table style="width:100%;">
                                            <tr>
                                                <td class="wordlimit">
                                                    <label>员工号：</label><span>${per.EMP_CODE }</span>
                                                </td>
                                                <td class="wordlimit">
                                                    <label>员工姓名：</label><span>${per.EMP_NAME }</span>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="wordlimit">
                                                    <label>岗位：</label><span>${per.EMP_GRADE_NAME }</span>
                                                </td>
                                                <td class="wordlimit">
                                                    <label>部门：</label><span>${per.EMP_DEPARTMENT_NAME }</span>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="wordlimit">
                                                    <label>年月：</label><span>${per.MONTH }</span>
                                                </td>
                                                <td class="wordlimit">
                                                    <label>上月得分：</label><span>${per.LASTMONTH_SCORE }</span>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="wordlimit">
                                                    <label>平均得分：</label><span>${per.AVERAGE_SCORE }</span>
                                                </td>
                                                <td class="wordlimit">
                                                    <label>当月得分：</label><span>${per.SCORE }</span>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="wordlimit">
                                                    <label>当月排名：</label><span>${per.RANKING }</span>
                                                </td>
                                            </tr>
                                        </table>
                                    </div>
                                </c:otherwise>
                            </c:choose>
                        </c:otherwise>
                    </c:choose>

                </c:forEach>
            </c:when>
            <c:otherwise>
                <table>
                    <tr class="main_info">
                        <td class="center">没有相关数据</td>
                    </tr>
                </table>
            </c:otherwise>
        </c:choose>
    </div>

    <div>
        <%@include file="../footer.jsp" %>
    </div>
</div>


<script type="text/javascript" src="plugins/JQuery/jquery.min.js"></script>
<script type="text/javascript" src="plugins/Bootstrap/js/bootstrap.min.js"></script>
<script type="text/javascript" src="plugins/Bootgrid/jquery.bootgrid.min.js"></script>
<script type="text/javascript" src="static/js/bootbox.min.js"></script>
<script src="static/js/ace-elements.min.js"></script>
<script src="static/js/ace.min.js"></script>
<script type="text/javascript" src="static/js/chosen.jquery.min.js"></script><!-- 下拉框 -->
<script type="text/javascript" src="static/js/bootbox.min.js"></script><!-- 确认窗口 -->
<script type="text/javascript" src="static/js/jquery.tips.js"></script><!--提示框-->
<!-- 加载Mobile文件 -->
<script src="plugins/appDate/js/jquery-1.11.1.min.js"></script>
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
    $(function () {

        //日期框
        $('#MONTH').mobiscroll().date({
            theme: 'android',
            mode: 'scroller',
            display: 'modal',
            lang: 'zh',
            dateFormat: 'yyyy-mm',
            buttons: ['set', 'cancel', 'clear']
        });

    });

    //页面下滑
    $(document).scroll(function () {
        var scrollTop = 0;
        var scrollBottom = 0;
        var dch = getClientHeight();
        scrollTop = getScrollTop();
        scrollBottom = document.body.scrollHeight - scrollTop;
        if (scrollBottom >= dch && scrollBottom <= (dch + 10)) {
            if ($('#totalPage').val() < ($('#currentPage').val() * 1 + 1)) {
                return;
            }
            ;
            if (true && document.forms[0]) {
                $("#zhongxin2").show();
                var currentPage = $('#currentPage').val() * 1 + 1;
                loadInfo(currentPage);
            }
            ;
        }
        ;
    });

    //加载任务列表
    function loadInfo(currentPage) {
        //初始化任务
        var loadInfoUrl = "app_performance/loadInfo.do?currentPage=" + currentPage;
        $.ajax({
            type: "POST",
            url: loadInfoUrl,
            success: function (data) {
                var obj = eval('(' + data + ')');
                $.each(obj.perList, function (i, per) {
                    apendElement(per, obj);
                });
                $("#zhongxin2").hide();
                $('#currentPage').val(obj.page.currentPage);
                $('#totalPage').val(obj.page.totalPage);
            }
        });
    }

    //生成任务列表数据
    function apendElement(per, obj) {
        if (null == per.LASTMONTH_SCORE) {
            per.LASTMONTH_SCORE = '';
        }
        if (null == per.AVERAGE_SCORE) {
            per.AVERAGE_SCORE = '';
        }
        if (null == per.SCORE) {
            per.SCORE = '';
        }
        if (obj.isLeader == '1') {//领导
            var appendStr = '<div class="keytask">' +
                '<a class="task_list" href="<%=basePath%>/app_performance/listTask.do?empCode=' + per.EMP_CODE + '&MONTH=' + per.MONTH + '&PERF_ID=' + per.PERF_ID + '&SCORE=' + per.SCORE + '">' +
                '<table style="width:100%;"><tr><td class="wordlimit"><label>员工号：</label><span>' + per.EMP_CODE + '</span></td>' +
                '<td class="wordlimit"><label>员工姓名：</label><span>' + per.EMP_NAME + '</span></td></tr>' +
                '<tr><td class="wordlimit"><label>岗位：</label><span>' + per.EMP_GRADE_NAME + '</span></td>' +
                '<td class="wordlimit"><label>部门：</label><span>' + per.EMP_DEPARTMENT_NAME + '</span></td></tr>' +
                '<tr><td class="wordlimit"><label>年月：</label><span>' + per.MONTH + '</span></td>' +
                '<td class="wordlimit"><label>上月得分：</label><span>' + per.LASTMONTH_SCORE + '</span></td></tr>' +
                '<tr><td class="wordlimit"><label>平均得分：</label><span>' + per.AVERAGE_SCORE + '</span></td>' +
                '<td class="wordlimit"><label>当月得分：</label><span>' + per.SCORE + '</span></td></tr>' +
                '<tr><td class="wordlimit"><label>当月排名：</label><span>' + per.RANKING + '</span></td></tr>' +
                '</table></a></div>';

            $("#tasklist").append(appendStr);
        } else if (obj.EMP_CODE == per.EMP_CODE) {
            var appendStr = '<div class="keytask">' +
                '<a class="task_list" href="<%=basePath%>/app_performance/listTask.do?empCode=' + per.EMP_CODE + '&MONTH=' + per.MONTH + '&PERF_ID=' + per.PERF_ID + '&SCORE=' + per.SCORE + '&SELF=1">' +
                '<table style="width:100%;"><tr><td class="wordlimit"><label>员工号：</label><span>' + per.EMP_CODE + '</span></td>' +
                '<td class="wordlimit"><label>员工姓名：</label><span style="color:blue">' + per.EMP_NAME + '</span></td></tr>' +
                '<tr><td class="wordlimit"><label>岗位：</label><span>' + per.EMP_GRADE_NAME + '</span></td>' +
                '<td class="wordlimit"><label>部门：</label><span>' + per.EMP_DEPARTMENT_NAME + '</span></td></tr>' +
                '<tr><td class="wordlimit"><label>年月：</label><span>' + per.MONTH + '</span></td>' +
                '<td class="wordlimit"><label>上月得分：</label><span>' + per.LASTMONTH_SCORE + '</span></td></tr>' +
                '<tr><td class="wordlimit"><label>平均得分：</label><span>' + per.AVERAGE_SCORE + '</span></td>' +
                '<td class="wordlimit"><label>当月得分：</label><span>' + per.SCORE + '</span></td></tr>' +
                '<tr><td class="wordlimit"><label>当月排名：</label><span>' + per.RANKING + '</span></td></tr>' +
                '</table></a></div>';

            $("#tasklist").append(appendStr);
        } else {
            var appendStr = '<div class="keytask">' +
                '<table style="width:100%;"><tr><td class="wordlimit"><label>员工号：</label><span>' + per.EMP_CODE + '</span></td>' +
                '<td class="wordlimit"><label>员工姓名：</label><span>' + per.EMP_NAME + '</span></td></tr>' +
                '<tr><td class="wordlimit"><label>岗位：</label><span>' + per.EMP_GRADE_NAME + '</span></td>' +
                '<td class="wordlimit"><label>部门：</label><span>' + per.EMP_DEPARTMENT_NAME + '</span></td></tr>' +
                '<tr><td class="wordlimit"><label>年月：</label><span>' + per.MONTH + '</span></td>' +
                '<td class="wordlimit"><label>上月得分：</label><span>' + per.LASTMONTH_SCORE + '</span></td></tr>' +
                '<tr><td class="wordlimit"><label>平均得分：</label><span>' + per.AVERAGE_SCORE + '</span></td>' +
                '<td class="wordlimit"><label>当月得分：</label><span>' + per.SCORE + '</span></td></tr>' +
                '<tr><td class="wordlimit"><label>当月排名：</label><span>' + per.RANKING + '</span></td></tr>' +
                '</table></div>';

            $("#tasklist").append(appendStr);
        }
    }

    //获取窗口可视范围的高度
    function getClientHeight() {
        var clientHeight = 0;
        if (document.body.clientHeight && document.documentElement.clientHeight) {
            clientHeight = (document.body.clientHeight < document.documentElement.clientHeight) ? document.body.clientHeight : document.documentElement.clientHeight;
        } else {
            clientHeight = (document.body.clientHeight > document.documentElement.clientHeight) ? document.body.clientHeight : document.documentElement.clientHeight;
        }
        return clientHeight;
    }

    function getScrollTop() {
        var scrollTop = 0;
        scrollTop = (document.body.scrollTop > document.documentElement.scrollTop) ? document.body.scrollTop : document.documentElement.scrollTop;
        return scrollTop;
    }


    //检索
    function toSearch() {
        $("#searchForm").submit();
    }

    function showMore() {
        $("#more").toggle();

    }

    //导出excel
    function toExcel() {
        window.location.href = '<%=basePath%>/performance/excel.do';
    }

    //重置
    function emptySearch() {
        $("#searchForm")[0].reset();
    }

</script>


</body>
</html>
