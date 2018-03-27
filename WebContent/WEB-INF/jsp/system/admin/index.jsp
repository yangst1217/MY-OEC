﻿<%@ page language="java" contentType="text/html; charset=UTF-8"
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
<html lang="en">
<head>
    <base href="<%=basePath%>">
    <!-- jsp文件头和头部 -->
    <%@ include file="top.jsp" %>
    <link rel="stylesheet" href="plugins/alertifyJS/alertify.core.css">
    <link rel="stylesheet" href="plugins/alertifyJS/alertify.default.css">
    <style type="text/css">
        .commitopacity {
            position: absolute;
            width: 100%;
            height: 100px;
            background: #7f7f7f;
            filter: alpha(opacity=50);
            -moz-opacity: 0.8;
            -khtml-opacity: 0.5;
            opacity: 0.5;
            top: 0px;
            z-index: 99999;
        }

        .dropdown-menu .badge-success {
            float: right
        }

        .alertify-log {
            background: #438eb9;
        }
    </style>

</head>
<body onload="startWebSocket()">

<!-- 页面顶部¨ -->
<%@ include file="head.jsp" %>

<div class="container-fluid" id="main-container">
    <a href="#" id="menu-toggler"><span></span></a>
    <!-- menu toggler -->

    <!-- 左侧菜单 -->
    <%@ include file="left.jsp" %>

    <div id="main-content" class="clearfix">

        <div id="jzts" style="display:none; width:100%; position:fixed; z-index:99999999;">
            <!-- <div class="commitopacity" id="bkbgjz"></div>
            <div style="padding-left: 70%;padding-top: 1px;">
                <div style="float: left;margin-top: 3px;"><img src="static/images/loadingi.gif" /> </div>
                <div style="margin-top: -5px;"><h4 class="lighter block red">&nbsp;加载中 ...</h4></div>
            </div> -->
        </div>

        <div>
            <iframe name="mainFrame" id="mainFrame" scrolling="no" frameborder="0" src="tab.do"
                    style="margin:0 auto;width:100%;height:100%;"></iframe>
        </div>

        <!-- 换肤 -->
        <%-- 	<div id="ace-settings-container">
                <div class="btn btn-app btn-mini btn-warning" id="ace-settings-btn">
                    <i class="icon-cog"></i>
                </div>
                <div id="ace-settings-box">
                    <div>
                        <div class="pull-left">
                            <select id="skin-colorpicker" class="hidden">
                                <option data-class="default" value="#438EB9"
                                    <c:if test="${user.SKIN =='default' }">selected</c:if>>#438EB9</option>
                                <option data-class="skin-1" value="#222A2D"
                                    <c:if test="${user.SKIN =='skin-1' }">selected</c:if>>#222A2D</option>
                                <option data-class="skin-2" value="#C6487E"
                                    <c:if test="${user.SKIN =='skin-2' }">selected</c:if>>#C6487E</option>
                                <option data-class="skin-3" value="#D0D0D0"
                                    <c:if test="${user.SKIN =='skin-3' }">selected</c:if>>#D0D0D0</option>
                            </select>
                        </div>
                        <span>&nbsp; 选择皮肤</span>
                    </div>
                    <div>
                        <label><input type='checkbox' name='menusf' id="menusf"
                            onclick="menusf();" /><span class="lbl" style="padding-top: 5px;">菜单缩放</span></label>
                    </div>
                </div>
            </div> --%>
        <!--/#ace-settings-container-->

    </div>
    <!-- #main-content -->
</div>
<!--/.fluid-container#main-container-->
<!-- basic scripts -->
<!-- 引入 -->
<script type="text/javascript">window.jQuery || document.write("<script src='static/js/jquery-1.9.1.min.js'>\x3C/script>");</script>
<script src="static/js/bootstrap.min.js"></script>
<script src="static/js/ace-elements.min.js"></script>
<script src="static/js/ace.min.js"></script>
<!-- 引入 -->

<script type="text/javascript" src="static/js/jquery.cookie.js"></script>
<script type="text/javascript" src="static/js/myjs/menusf.js"></script>
<script type="text/javascript" src="plugins/alertifyJS/alertify.min.js"></script>
<script type="text/javascript">
    $(function () {
        if (typeof ($.cookie('menusf')) == "undefined") {
            $("#menusf").attr("checked", true);
            $("#sidebar").attr("class", "");
        } else {
            $("#sidebar").attr("class", "menu-min");
        }
        //setInterval("loginTime()", 1000*60);
    });

    var ws = null;

    //开启WebSocket连接
    function startWebSocket() {
        //在自己电脑部署测试
        ws = new WebSocket("ws://localhost:8080/STL-OEC/task/msg");

        ws.onopen = function (evt) {
            //alert("opend");
        };

        ws.onmessage = function (evt) {
            var data = eval("(" + evt.data + ")");
            var content = "<span style='cursor: pointer;' onclick='siMenu(\"z" + data.MENU_ID + "\", \"lm" + data.PARENT_ID + "\",\"" + data.MENU_NAME + "\",\"" + data.MENU_URL + "\")'>" + data.taskMsg + "</span>";
            alertify.log(content, "", 0);
        };

        ws.onclose = function (evt) {
            //alert("关闭");
        }
    }

    function cmainFrame() {
        var hmain = document.getElementById("mainFrame");
        var bheight = document.documentElement.clientHeight;
        hmain.style.width = '100%';
        hmain.style.height = (bheight - 51) + 'px';
        //var bkbgjz = document.getElementById("bkbgjz");
        //bkbgjz .style.height = (bheight  - 41) + 'px';

    }

    cmainFrame();
    window.onresize = function () {
        cmainFrame();
    };
    jzts();
</script>
</body>
</html>
