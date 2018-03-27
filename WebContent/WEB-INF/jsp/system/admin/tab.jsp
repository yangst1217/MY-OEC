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

    <script type="text/javascript" src="static/js/jquery-1.7.2.js"></script>
    <script type="text/javascript" src="plugins/tab/js/framework.js"></script>
    <link href="plugins/tab/css/import_basic.css" rel="stylesheet" type="text/css"/>
    <link rel="stylesheet" type="text/css" id="skin" prePath="plugins/tab/"/>
    <!--默认相对于根目录路径为../，可添加prePath属性自定义相对路径，如prePath="<%=request.getContextPath()%>"-->
    <script type="text/javascript" charset="utf-8" src="plugins/tab/js/tab.js"></script>
</head>


<body>
<div id="tab_menu"></div><!-- style="height:30px;" -->
<div style="width:100%;">
    <div id="page" style="width:100%;height:100%;"></div>
</div>
</body>

<script type="text/javascript">

    function tabAddHandler(mid, mtitle, murl) {
        tab.add({
            id: mid,
            title: mtitle,
            url: murl,
            isClosed: true
        });
        tab.update({
            id: mid,
            title: mtitle,
            url: murl,
            isClosed: true
        });
        tab.activate(mid);

        var framewidth = $(document).width();
        var tabwidth = 0;
        var num = 1;
        //alert(framewidth);
        $(".tab_item").each(function () {
            tabwidth = tabwidth + $(this).width() + 4;
            num++;
            //alert(tabwidth);
            //alert(num);
            if (tabwidth > framewidth) {
                $(".tab_item:eq(2)").find(".tab_close").click();
                tabwidth = tabwidth - $(".tab_item:eq(1)").width() - 4;
            }
        });
        if (tabwidth > framewidth) {
            $(".tab_item:eq(2)").find(".tab_close").click();
        }
    }

    var tab;
    $(function () {
        tab = new TabView({
            containerId: 'tab_menu',
            pageid: 'page',
            cid: 'tab1',
            position: "top"
        });
        tab.add({
            id: 'close_all',
            title: "关闭所有",
            isClosed: false
        });
        tab.add({
            id: 'tab1_index1',
            title: "主页",
            url: "<%=basePath%>goNavigation.do",
            isClosed: false
        });
        /**tab.add( {
		id :'tab1_index1',
		title :"主页",
		url :"/per/undoTask!gettwo",
		isClosed :false
	});
         **/
    });

    function cmainFrameT() {
        var hmainT = document.getElementById("page");
        var bheightT = document.documentElement.clientHeight;
        hmainT.style.width = '100%';
        hmainT.style.height = (bheightT - 32) + 'px';
    }

    cmainFrameT();
    window.onresize = function () {
        cmainFrameT();
    }

    $(function () {
        $("#close_all").click(function () {
            $(this).next().nextAll("table").each(function () {
                $(this).find(".tab_close").each(function () {
                    $(this).trigger("click");
                })
            })
            $("#tab1_index1").trigger("click");
        })
    })
</script>
</html>

