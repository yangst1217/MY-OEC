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

    <title>临时任务下达</title>
    <meta name="description" content="overview & stats"/>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <link href="static/css/bootstrap.min.css" rel="stylesheet"/>
    <link href="static/css/bootstrap-responsive.min.css" rel="stylesheet"/>
    <link rel="stylesheet" href="static/css/font-awesome.min.css"/>

    <link rel="stylesheet" href="static/css/ace.min.css"/>
    <link rel="stylesheet" href="static/css/ace-responsive.min.css"/>
    <link rel="stylesheet" href="static/css/ace-skins.min.css"/>


    <link rel="stylesheet" href="static/css/app-style.css"/>

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

        .keytask {
            width: 98%;
            padding: 0;
            margin: 0 auto;
        }

        .keytask table {
            width: 96%;
            margin: 0 auto;
        }

        .keytask table tr td {
            line-height: 1.3;
            word-break: break-word;
            overflow: visible;
            white-space: normal;
        }

        .keytask {
            width: 98%;
            padding: 0;
            margin: 0 auto;
        }

        .keytask table {
            width: 96%;
            margin: 0 auto;
        }

        .keytask table tr td {
            line-height: 1.3;
            word-break: break-word;
            overflow: visible;
            white-space: normal;
        }
    </style>

    <!-- 引入 -->
    <script type="text/javascript" src="static/js/jquery-1.7.2.js"></script>
    <script src="static/js/bootstrap.min.js"></script>
    <script src="static/js/ace-elements.min.js"></script>
    <script src="static/js/ace.min.js"></script>
    <script type="text/javascript" src="static/js/jquery-form.js"></script>
    <!--提示框-->
    <script type="text/javascript" src="static/js/jquery.tips.js"></script>
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

        if ("ontouchend" in document) document.write("<script src='static/js/jquery.mobile.custom.min.js'>" + "<" + "/script>");
    </script>

</head>
<body>
<div id="normal" class="normal" style="width: 98%;text-align: right;padding: 5px;">
    <a class="btn btn-small btn-info" onclick="add();" style="margin-right:5px;">新增</a>
    <a class="btn btn-small btn-primary" onclick="batchIssued();" style="margin-right:5px;">批量下发</a>
    <a class='btn btn-small btn-primary' data-toggle="collapse" href="#searchTab" style="margin-right: 5px;">高级搜索</a>
</div>
<div style="width: 98%;text-align: right;padding: 5px;">
    <input id="searchField" type="hidden" value="YW_CG"/><!-- 默认加载查询的值 -->
    <input type="hidden" id="currentPage" value="0"/>
    <input type="hidden" id="totalPage" value="0"/>
    <c:if test="${count==0 }">
        <button class="btn btn-small btn-info active" onclick="clickSearch('YW_CG', this);">待提交</button>
        <button class="btn btn-small btn-info " onclick="clickSearch('YW_YTH', this);">已退回</button>
        <button class="btn btn-small btn-info" onclick="clickSearch('YW_DSX', this);">审核中</button>
    </c:if>
    <c:if test="${count==1 }">
        <button class="btn btn-small btn-info active" onclick="clickSearch('YW_CG', this);">待下达</button>
    </c:if>
    <button class="btn btn-small btn-info" onclick="clickSearch('YW_YSX', this);">已下达</button>
    <button class="btn btn-small btn-info" style="margin-right: 5px;" onclick="clickSearch('', this);">全部</button>
</div>
<!-- 查询面板 -->
<div id="searchTab" class="panel-collapse collapse">
    <table style="width: 98%; margin: 5px auto;">
        <tr>
            <td style="text-align: center;"><label>完成期限:</label></td>
            <td><input type="text" name="year" id="year" class="date-picker" data-date-format="yyyy-mm-dd"
                       placeholder="请输入时间" readonly="readonly">
        </tr>
        <tr>
            <td><label>任务编号/名称:</label></td>
            <td><input id="KEYW" name="KEYW" style="width: 216px;"/></td>
        </tr>

        <tr>
            <td colspan="2">
                <a class='btn btn-mini btn-primary' style="margin-top: 10px;margin-bottom:10px;margin-left: 220px;"
                   onclick="searching();"
                   data-toggle="collapse" href="#searchTab">查询</a>
                <a class='btn btn-mini btn-primary' style="cursor: pointer;" onclick="resetting();">重置</a>
            </td>
        </tr>
    </table>
</div>
<!-- 任务列表 -->
<div id="showTask">
    <input type="hidden" name="count" id="COUNT" value="${count}"/>
</div>
<div id="zhongxin2" class="center" style="display:none"><br/><br/><br/><br/><br/><img
        src="static/images/jiazai.gif"/><br/><h4 class="lighter block green">提交中...</h4></div>
<!-- 引入菜单页 -->
<div>
    <%@include file="../footer.jsp" %>
</div>
<script type="text/javascript">
    $(function () {
        // 初始化日期框插件内容
        $('#year').mobiscroll().datetime({
            theme: 'android',
            mode: 'scroller',
            display: 'modal',
            lang: 'zh',
            dateFormat: 'yyyy-mm-dd',
            timeFormat: 'HH:ii:ss',
            timeWheels: 'hhiiss',
            buttons: ['set', 'cancel', 'clear']
        });
        loadData(0);
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
                loadData(currentPage);
            }
            ;
        }
        ;
    });

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

    //加载数据
    function loadData(currentPage) {
        var year = $("#year").val();
        var keyword = $("#KEYW").val();
        var status = $("#searchField").val();
        //初始化任务
        var loadDataUrl = "app_temp/loadData.do?currentPage=" + currentPage + "&status=" + status + "&year=" + year + "&keyword=" + keyword;
        $.ajax({
            type: "POST",
            url: loadDataUrl,
            success: function (data) {
                var obj = eval('(' + data + ')');
                if (currentPage == 0) {
                    $("#showTask").empty();
                    if (obj.taskList.length == 0) {
                        $("#showTask").append('<span>没有数据</span>');
                    }
                }
                $.each(obj.taskList, function (i, task) {
                    apendElement(task);
                });
                $("#zhongxin2").hide();
                $('#currentPage').val(obj.page.currentPage);
                $('#totalPage').val(obj.page.totalPage);
            }
        });
    }

    //生成任务列表数据
    function apendElement(task) {
        var appendStr = '<div class="keytask">' +
            '<div><table>' +
            '<tr><td style="width:70px">任务编号:</td><td colspan="2"><span>' + task.TASK_CODE + '</span></td><td style="text-align: right; width:30px; "><input style="width:20px" name="finishBox" type="checkbox" value=' + task.TASK_CODE + ' /><span class="lbl"></span></td></tr>' +
            '<tr><td>任务名称:</td><td colspan="3"><span>' + task.TASK_NAME + '</span></td></tr>' +
            '<tr><td>开始时间:</td><td colspan="3"><span>' + task.START_TIME + '</span></td></tr>' +
            '<tr><td>结束时间:</td><td colspan="3"><span>' + task.END_TIME + '</span></td></tr>' +
            '<tr><td>责任人:</td><td colspan="3"><span>' + task.MAIN_EMP_NAME + '</span></td></tr>' +
            '<tr><td>创建人:</td><td colspan="3"><span>' + task.CREATE_NAME + '</span></td></tr>' +
            '<tr><td>创建时间:</td><td colspan="3"><span>' + task.CREATE_TIME + '</span></td></tr>' +
            '<tr><td>状态:</td><td><span>' + change(task.STATUS) + '</span></td><td colspan="2" style="text-align:right">' + getCommand(task) + '</td></tr>' +
            '</table></div>' +
            '</div>';
        $("#showTask").append(appendStr);
    }

    //状态
    function change(status) {
        if (status == 'YW_CG') {
            return '草稿';
        } else if (status == 'YW_YSX') {
            return '已生效';
        } else if (status == 'YW_DSX') {
            return '待生效';
        } else if (status == 'YW_YTH') {
            return '已退回';
        }
    }


    function getCommand(row) {
        var res = row.STATUS;
        var str = '';
        var count = row.COUNT;
        if (res == 'YW_YSX' || res == 'YW_DSX') {
            str += '<a style="cursor:pointer;" title="查看" onclick="view(\'' + row.ID + '\',\'' + row.TASK_CODE + '\');" class="btn btn-mini btn-warning" data-rel="tooltip" data-placement="left">' +
                '<i class="icon-eye-open"></i></a>';
        } else {
            str += '<a style="cursor:pointer;" title="编辑" onclick="edit(\'' + row.ID + '\',\'' + row.TASK_CODE + '\');" class="btn btn-mini btn-info" data-rel="tooltip" data-placement="left">' +
                '<i class="icon-edit"></i></a>' +
                '<a style="cursor:pointer;" title="附件上传" onclick="uploadFile(\'' + row.ID + '\');" class="btn btn-mini btn-info" data-rel="tooltip" data-placement="left">' +
                '<i class="icon-cloud-upload"></i></a>';
            if (res == 'YW_YTH' || (res == 'YW_CG' && (count == 0 || count == '0'))) {
                str += '<a style="cursor:pointer;" title="提交审核" onclick="save(\'' + row.ID + '\',\'YW_DSX\',\'' + row.TASK_CODE + '\',\'' + row.MAIN_EMP_ID + '\',\'' + row.MAIN_EMP_NAME + '\');" class="btn btn-mini btn-primary" data-rel="tooltip" data-placement="left">' +
                    '<i class="icon-envelope"></i></a>';
            } else if (res == 'YW_CG' && (count == 1 || count == '1')) {
                str += '<a style="cursor:pointer;" title="下达" onclick="save(\'' + row.ID + '\',\'YW_YSX\',\'' + row.TASK_CODE + '\',\'' + row.MAIN_EMP_ID + '\',\'' + row.MAIN_EMP_NAME + '\');" class="btn btn-mini btn-primary" data-rel="tooltip" data-placement="left">' +
                    '<i class="icon-envelope"></i></a>';
            }
            str += '<a style="cursor:pointer;" title="删除" onclick="del(\'' + row.ID + '\');" class="btn btn-mini btn-danger" data-rel="tooltip" data-placement="left">' +
                '<i class="icon-trash"></i></a>';
        }
        return str;
    }

    // 编辑页面
    function edit(id, taskTypeId) {
        //保存搜索的参数
        var param = "";
        if ($("#year").val() != '') {
            param += "&year=" + $("#year").val();
        }
        if ($("#KEYW").val() != '') {
            param += "&KEYW=" + $("#KEYW").val();
        }
        //保存页数
        param += "&currentPage=" + $("#currentPage").val();
        window.location.href = '<%=basePath%>/app_temp/goEdit.do?id=' + id + '&taskTypeId=' + taskTypeId + param;
    }

    // 详情页面
    function view(id, taskTypeId) {
        //保存搜索的参数
        var param = "";
        if ($("#year").val() != '') {
            param += "&year=" + $("#year").val();
        }
        if ($("#KEYW").val() != '') {
            param += "&KEYW=" + $("#KEYW").val();
        }

        //保存页数
        param += "&currentPage=" + $("#currentPage").val();
        window.location.href = '<%=basePath%>/app_temp/goView.do?id=' + id + '&taskTypeId=' + taskTypeId + param;
    }

    // 新增页面
    function add() {
        //保存搜索的参数
        var param = "currentPage=" + $("#currentPage").val();
        //保存页数
        if ($("#year").val() != '') {
            param += "&year=" + $("#year").val();
        }
        if ($("#KEYW").val() != '') {
            param += "&KEYW=" + $("#KEYW").val();
        }

        window.location.href = '<%=basePath%>/app_temp/goAdd.do?' + param;
    }

    //提交任务
    function save(id, status, TASK_CODE, MAIN_EMP_ID, MAIN_EMP_NAME) {
        if (confirm("确定要提交任务?")) {
            var url = "<%=basePath%>/app_temp/update.do?id=" + id + "&status=" + status + "&TASK_CODE=" + id + "&MAIN_EMP_ID=" + MAIN_EMP_ID + "&MAIN_EMP_NAME=" + MAIN_EMP_NAME;
            $.ajax({
                type: "POST",
                url: url,
                success: function (data) {
                    if (data == 'success') {
                        location.replace('<%=basePath%>/app_temp/goTemp.do');
                    } else {
                        alert("提交失败！");
                    }
                }
            });
        }
    }

    //点击进行查询
    function clickSearch(value, ele) {
        $("#btnDiv button").removeClass("active");
        $(ele).addClass("active");
        $("#searchField").val(value);
        searching();
    }

    //检索
    function searching() {
        loadData(0);
    }

    //上传附件
    function uploadFile(id) {
        location.href = '<%=basePath%>app_temp/goAttchmentsUpload.do?id=' + id;
    }

    //删除
    function del(id) {
        if (confirm("确定要删除?")) {
            var url = "<%=basePath%>/app_temp/delete.do?id=" + id;
            $.get(url, function (data) {
                if (data == "success") {
                    location.replace('<%=basePath%>/app_temp/goTemp.do');
                }
            });
        }
    }

    //批量下发临时任务
    function batchIssued() {

        if ($("#COUNT").val() == 0 || $("#COUNT").val() == '0') {
            alert("不是领导角色，不能下发");
            return;
        }
        var objList = document.getElementsByName("finishBox");
        var num = 0;
        for (var i = 0; i < objList.length; i++) {
            if (objList[i].checked) {
                num += 1;
            }
        }
        if (num == 0) {
            alert("您没有勾选任何内容，不能下发");
            return;
        } else {
            if (confirm("确定要批量下发吗？")) {
                var inputStr = '';
                for (var i = 0; i < objList.length; i++) {
                    if (objList[i].checked) {
                        inputStr += objList[i].value + ",";//拼接选择的节点ID
                    }
                }
                if ("" != inputStr) {
                    inputStr = inputStr.substr(0, inputStr.length - 1);
                }
                var url = '<%=basePath%>/app_temp/batchIssued.do?status=YW_YSX&taskCodes=' + inputStr;
                $.get(
                    url,
                    function (data) {
                        if (data == "success") {
                            alert("下发成功！");
                        } else if (data == "false") {
                            alert("下发失败！");
                        }
                        location.reload();
                    },
                    "text"
                );
            }

        }

    }

    function resetting() {
        $("#year").val("");
        $("#KEYW").val("");
    }
</script>
</body>
</html>