<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
    String path = request.getContextPath();
    String basePath = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort() + path + "/";
%>
<!DOCTYPE html>
<html lang="zh_CN">
<head>
    <base href="<%=basePath%>"/>
    <title>日清助手</title>
    <meta name="viewport"
          content="width=device-width,initial-scale=1.0, minimum-scale=1.0, maximum-scale=1.0, user-scalable=no,minimal-ui"/>
    <link href="static/css/bootstrap.min.css" rel="stylesheet"/>
    <link href="static/css/style.css" rel="stylesheet"/>
    <link rel="stylesheet" href="static/css/app-style.css"/>
    <link rel="stylesheet" href="static/css/font-awesome.min.css"/>
    <link rel="stylesheet" href="static/css/ace.min.css"/>
    <style>
        body {
            background: #f4f4f4;
        }

        .keytask table tr td {
            line-height: 1.3
        }

        .web_menu a {
            width: 49.5%;
        }

        .startBtn {
            height: 30px;
            width: 90px;
        }

        .workTimer {
            border: 1px solid #cecece;
            height: 120px;
            width: 100%;
            text-align: center;
            margin: 6px;
            table-layout: fixed;
        }

        .workTimer .workTitle {
            height: 100%;
            width: 49%;
            border-right: 1px solid #cecece;
            border-bottom: 1px solid #cecece;
            text-overflow: ellipsis;
            overflow: hidden;
            word-wrap: break-word;
        }

        .workTimer .timerDIV {
            height: 60px;
            width: 50%;
            line-height: 60px;
            border-bottom: 1px solid #cecece;
        }

        .workTimer .startDIV {
            width: 50%;
            float: left;
        }
    </style>
</head>
<body>
<form id="helperForm">
    <div class="web_menu">
        <a style="border-right: 1px solid #12e6d2" onclick="searchData('collection');"
           class="<c:if test="${type!='all'}">active</c:if>">常用日清助手</a>
        <a style="border-right: 1px solid #12e6d2" onclick="searchData('all');"
           class="<c:if test="${type=='all'}">active</c:if>">日清助手</a>
        <div style="clear: both;"></div>
    </div>
    <c:forEach items="${helpers}" var="duty">
        <table id="workTimer_${duty.ID}" class="workTimer">
            <tr>
                <td class="workTitle" title="${duty.detail }">
                        ${duty.detail }
                </td>
                <td class="timerDIV" id="timer_${duty.ID}">
                    00:00
                </td>
            </tr>
            <tr>
                <td colspan="2" style="padding: 6px 0;">
                    <div style="float:left;margin-left: 50px;">
                        <c:choose>
                            <c:when test="${type=='all'}">
                                <input type="button" class="btn" onclick="addCollection(${duty.ID})" value="添加收藏"/>
                            </c:when>
                            <c:otherwise>
                                <input type="button" class="btn	" onclick="removeCollection(${duty.ID})"
                                       value="移除收藏"/>
                            </c:otherwise>
                        </c:choose>
                    </div>
                    <div class="startDIV">
                        <input class="btn" id="startBtn_${duty.ID}" type="button" onclick="startWork('${duty.ID}')"
                               value="启动工作">
                        <input type="button" class="btn btn-primary" id="pauseBtn_${duty.ID}"
                               onclick="pauseWork('${duty.ID}')" style="display: none;" value="暂停">
                        <input type="button" class="btn btn-info" id="continueBtn_${duty.ID}"
                               onclick="continueWork('${duty.ID}')" style="display: none;" value="继续">
                        <input type="button" class="btn btn-danger" id="endBtn_${duty.ID}"
                               onclick="endWork('${duty.ID}')" style="display: none;" value="结束">
                        <input type="hidden" id="timeId_${duty.ID}">
                    </div>
                        <%-- <div class="startDIV">
                            <input class="btn" id="startBtn_${duty.ID}" type="button" onclick="startWork('${duty.ID}')" value="启动工作">
                            <input type="button" class="btn btn-danger" id="endBtn_${duty.ID}" onclick="endWork('${duty.ID}')" style="display: none;" value="结束工作">
                            <input type="hidden" id="timeId_${duty.ID}">
                        </div> --%>
                </td>
            </tr>
        </table>
    </c:forEach>
    <input type="hidden" id="type" name="type">
</form>
<div>
    <%@include file="../footer.jsp" %>
</div>
<!-- 引入 -->
<script type="text/javascript" src="plugins/JQuery/jquery-1.12.2.min.js"></script>
<script src="static/js/bootstrap.min.js"></script>
<script src="static/js/ace-elements.min.js"></script>
<script src="static/js/ace.min.js"></script>
<script type="text/javascript">
    function searchData(type) {
        $("#type").val(type);
        $("#helperForm").submit();
    }

    var timer;
    //秒
    var s = 0;
    //分
    var m = 0;

    $(function () {
        if ('${resultList}' == '') {
            return;
        }
        var resultList = eval('${resultList}');
        var pauseGroup = [];
        var doingGroup = [];
        for (var i = 0; i < resultList.length; i++) {
            var id = resultList[i].detail_id;
            var groups = resultList[i].groups;
            if (resultList[i].status == "doing") {
                $("#startBtn_" + id).hide();
                $("#pauseBtn_" + id).show();
                $("#continueBtn_" + id).hide();
                $("#endBtn_" + id).show();
                doingGroup.push(groups);
            } else if (resultList[i].status == "pause") {
                $("#startBtn_" + id).hide();
                $("#pauseBtn_" + id).hide();
                $("#continueBtn_" + id).show();
                $("#endBtn_" + id).show();
                pauseGroup.push(groups);
            }
        }

        for (var i = 0; i < pauseGroup.length; i++) {
            s = 0;
            var timeId;
            var detailId;
            for (var j = 0; j < resultList.length; j++) {
                if (resultList[j].groups == pauseGroup[i]) {
                    s += resultList[j].duration;
                    timeId = resultList[j].ID;
                    detailId = resultList[j].detail_id;
                }
            }

            m = parseInt(s / 60);
            s = s % 60;

            if (m < 10) {
                m = "0" + m;
            }

            if (s < 10) {
                s = "0" + s;
            }

            $('#timer_' + detailId).html(m + ":" + s);
            $("#timeId_" + detailId).val(timeId);
        }

        for (var i = 0; i < doingGroup.length; i++) {
            s = 0;
            var timeId;
            var detailId;

            for (var j = 0; j < resultList.length; j++) {
                if (resultList[j].groups == doingGroup[i]) {
                    s += resultList[j].duration;
                    timeId = resultList[j].ID;
                    detailId = resultList[j].detail_id;
                }
            }

            m = parseInt(s / 60);
            s = s % 60;

            if (m < 10 && m.length < 2) {
                m = "0" + m;
            }

            if (s < 10) {
                s = "0" + s;
            }

            timer = setInterval(function setTime() {
                if (++s < 10) {
                    s = "0" + s;
                } else if (s == 60) {
                    s = "00";
                    m++;
                }

                if (m < 10) {
                    $('#timer_' + detailId).html("0" + m + ":" + s);
                } else {
                    $('#timer_' + detailId).html(m + ":" + s);
                }
            }, 1000);
            $("#timeId_" + detailId).val(timeId);
        }
    });

    function startWork(id) {
        var endBtns = $(".startDIV .btn-danger");
        var pauseBtns = $(".startDIV .btn-primary");
        for (var i = 0; i < endBtns.length; i++) {
            if (endBtns[i].style.display != "none"
                && pauseBtns[i].style.display != "none") {
                top.Dialog.alert("请先结束或暂停现有任务");
                return false;
            }
        }

        //日常工作提交后，不能再启动日清助手
        if ('${isCommitDailyTask}' == 'true') {
            top.Dialog.alert("今天的日常工作已提交，不能继续操作！");
            return false;
        }

        $.post(
            "app_taskHelper/startDailyTask.do",
            {"detailid": id},
            function (data) {
                if (data.indexOf('<!DOCTYPE html>') > 0) {//验证是否请求正常
                    location.href = '<%=basePath%>app_login/login_index.do';
                    return;
                }
                if (data != "") {
                    var s = 0;
                    var m = 0;
                    $("#startBtn_" + id).hide();
                    $("#pauseBtn_" + id).show();
                    $("#endBtn_" + id).show();
                    $("#timeId_" + id).val(data);

                    timer = setInterval(function setTime() {
                        if (++s < 10) {
                            s = "0" + s;
                        } else if (s == 60) {
                            s = "00";
                            m++;
                        }

                        if (m < 10) {
                            $('#timer_' + id).html("0" + m + ":" + s);
                        } else {
                            $('#timer_' + id).html(m + ":" + s);
                        }
                    }, 1000);
                } else {
                    alert("任务启动失败");
                }
            }
        );
    }

    function endWork(id) {
        var time = $("#timeId_" + id).val();
        if (time != '') {
            $.post(
                "app_taskHelper/endDailyTask.do",
                {"timeId": time},
                function (data) {
                    if (data.indexOf('<!DOCTYPE html>') > 0) {//验证是否请求正常
                        location.href = '<%=basePath%>app_login/login_index.do';
                        return;
                    }
                    if (data != "") {
                        $("#endBtn_" + id).hide();
                        $("#pauseBtn_" + id).hide();
                        $("#continueBtn_" + id).hide();
                        $("#startBtn_" + id).show();
                        clearTimeout(timer);
                        $('#timer_' + id).html("00:00");
                        $("#timeId_" + id).val("");
                    } else {
                        alert("任务终止失败");
                    }
                }
            );
        }
    }

    function pauseWork(id) {
        $.post(
            "app_taskHelper/pauseDailyTask.do",
            {"timeId": $("#timeId_" + id).val()},
            function (data) {
                if (data.indexOf('<!DOCTYPE html>') > 0) {//验证是否请求正常
                    location.href = '<%=basePath%>app_login/login_index.do';
                    return;
                }
                if (data != "") {
                    $("#pauseBtn_" + id).hide();
                    $("#continueBtn_" + id).show();
                    clearTimeout(timer);
                } else {
                    top.Dialog.alert("任务暂停失败");
                }
            }
        );
    }

    function continueWork(id) {
        var endBtns = $(".startDIV .btn-danger");
        var pauseBtns = $(".startDIV .btn-primary");
        for (var i = 0; i < endBtns.length; i++) {
            if (endBtns[i].style.display != "none"
                && pauseBtns[i].style.display != "none") {
                top.Dialog.alert("请先结束或暂停现有任务");
                return false;
            }
        }

        $.post(
            "app_taskHelper/continueDailyTask.do",
            {"timeId": $("#timeId_" + id).val()},
            function (data) {
                if (data.indexOf('<!DOCTYPE html>') > 0) {//验证是否请求正常
                    location.href = '<%=basePath%>app_login/login_index.do';
                    return;
                }
                if (data != "") {
                    $("#pauseBtn_" + id).show();
                    $("#continueBtn_" + id).hide();
                    $("#timeId_" + id).val(data);

                    var timeStr = $('#timer_' + id).html();
                    s = timeStr.split(":")[1];
                    m = timeStr.split(":")[0];

                    timer = setInterval(function setTime() {
                        if (++s < 10) {
                            s = "0" + s;
                        } else if (s == 60) {
                            s = "00";
                            m++;
                        }

                        if (m < 10 && m.length < 2) {
                            $('#timer_' + id).html("0" + m + ":" + s);
                        } else {
                            $('#timer_' + id).html(m + ":" + s);
                        }
                    }, 1000);
                } else {
                    top.Dialog.alert("任务暂停失败");
                }
            }
        );
    }

    function addCollection(id) {
        $.post(
            "app_taskHelper/addCollection.do",
            {"id": id},
            function (data) {
                if (data.indexOf('<!DOCTYPE html>') > 0) {//验证是否请求正常
                    location.href = '<%=basePath%>app_login/login_index.do';
                    return;
                }
                if (data == 1) {//添加收藏成功
                    $("#workTimer_" + id).remove();
                } else {
                    alert("添加收藏失败");
                }
            }
        );
    }

    function removeCollection(id) {
        $.post(
            "app_taskHelper/removeCollection.do",
            {"id": id},
            function (data) {
                if (data.indexOf('<!DOCTYPE html>') > 0) {//验证是否请求正常
                    location.href = '<%=basePath%>app_login/login_index.do';
                    return;
                }
                if (data == 1) {//移除收藏成功
                    $("#workTimer_" + id).remove();
                } else {
                    alert("移除收藏失败");
                }
            }
        );
    }
</script>
</body>
</html>