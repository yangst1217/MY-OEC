<%@page import="java.util.Calendar" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
    String path = request.getContextPath();
    String basePath = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort() + path + "/";
%>
<!DOCTYPE html>
<html lang="zh_CN">
<head>
    <base href="<%=basePath%>">
    <meta charset="utf-8"/>
    <title></title>
    <meta name="description" content="overview & stats"/>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <link href="static/css/bootstrap.min.css" rel="stylesheet"/>
    <link href="static/css/bootstrap-responsive.min.css" rel="stylesheet"/>
    <link rel="stylesheet" href="static/css/font-awesome.min.css"/>
    <link rel="stylesheet" href="static/css/ace.min.css"/>
    <link rel="stylesheet" href="static/css/ace-responsive.min.css"/>
    <link rel="stylesheet" href="static/css/ace-skins.min.css"/>
    <link rel="stylesheet" href="plugins/zTeee3.5/zTreeStyle.css"/>
    <style type="text/css">
        .tab-content {
            overflow: visible;
        }

        .table {
            margin: 0;
        }

        .table tbody td {
            padding: 0;
            height: 32px;
        }

        .menuContent {
            border: 1px solid #cecece;
            background-color: white;
        }
    </style>
</head>
<body>
<form id="relateForm" action="cpEvent/relate.do">
    <div style="margin: 10px 0;">
        <input type="hidden" id="relateNodeIds" name="relateNodeIds" value="${event.RELATEEVENTS}">
        <input type="hidden" name="eventId" value="${event.ID}">
        <span>选择前置活动：</span>
        <input type="text" id="treeInput" style="width:300px" autocomplete="off" onclick="showMenu();">
        <!-- <input id="saveBtn" type="submit" class="btn btn-mini btn-primary" value="保存"> -->
        <input id="saveBtn" type="button" onclick="save()" class="btn btn-mini btn-primary" value="保存">
        <input id="cancelBtn" type="button" class="btn btn-mini btn-danger" onclick="javascript:history.go(-1)"
               value="取消">
    </div>
    <div id="menuContent" class="menuContent" style="width:300px;padding:0 6px;position: absolute;display: none;">
        <ul id="nodeTree" class="ztree" style="margin-top:0; width:300px;overflow: auto;max-height: 300px;"></ul>
        <div style="border-top: 1px solid #cecece;text-align: center;">
            <input type="button" class="btn btn-small btn-primary" id="confirmBtn" onclick="confirmCheck()" value="确认">
        </div>
    </div>
    <table class="table table-bordered">
        <thead>
        <tr>
            <td>前置活动</td>
            <td>开始日期</td>
            <td>结束日期</td>
            <td>备注</td>
        </tr>
        </thead>
        <tbody>
        <c:forEach items="${relates}" var="item">
            <tr>
                <td>${item.NAME}</td>
                <td>${item.START_DATE}</td>
                <td>${item.END_DATE}</td>
                <td>${item.DESCP}</td>
            </tr>
        </c:forEach>
        </tbody>
    </table>
</form>
<script type="text/javascript" src="plugins/JQuery/jquery-1.12.2.min.js"></script>
<script type="text/javascript" src="static/js/bootstrap.min.js"></script>
<script type="text/javascript" src="plugins/zTeee3.5/jquery.ztree.all.min.js"></script>
<script src="static/js/ace-elements.min.js"></script>
<script src="static/js/ace.min.js"></script>
<script type="text/javascript">
    var zTreeObj;
    var setting = {
        data: {
            simpleData: {
                enable: true,
                pIdKey: "parent",
            }
        },
        check: {
            enable: true
        }
    };


    $(function () {
        zTreeObj = $.fn.zTree.init($("#nodeTree"), setting, ${treeNodes});
    });

    function confirmCheck() {
        hideMenu();
        var checkedNodesId = new Array();
        var checkedNodes = zTreeObj.getCheckedNodes(true);
        var tbHtmlTxt = "";
        var inputTxt = "";
        $("tbody").empty();
        $.each(checkedNodes, function (i, n) {
            checkedNodesId.push(n.id.split("_")[1]);
            tbHtmlTxt += "<tr>" +
                "	<td>" + n.text + "</td>" +
                "	<td>" + n.start_time + "</td>" +
                "	<td>" + n.end_time + "</td>" +
                "	<td>" + n.DESCP + "</td>" +
                "</tr>";
            inputTxt += n.text + ",";
        });
        $("tbody").append(tbHtmlTxt);
        $("#treeInput").val(inputTxt.substr(0, inputTxt.length - 1));
        $("#relateNodeIds").val(checkedNodesId.toString());
    }

    function showMenu() {
        var cityObj = $("#treeInput");
        var cityOffset = $("#treeInput").offset();
        $("#menuContent").css({
            left: cityOffset.left + "px",
            top: cityOffset.top + cityObj.outerHeight() - 1 + "px"
        }).slideDown("fast");
        $("body").bind("mousedown", onBodyDown);
    }

    function hideMenu() {
        $("#menuContent").fadeOut("fast");
        $("body").unbind("mousedown", onBodyDown);
    }

    function onBodyDown(event) {
        if (!(event.target.id == "menuBtn" || event.target.id == "citySel" || event.target.id == "menuContent" || $(event.target).parents("#menuContent").length > 0)) {
            hideMenu();
        }
    }

    function save() {
        $("#relateForm").submit();
        collapseTreeNode();
    }
</script>
</body>
</html>