<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
    String path = request.getContextPath();
    String basePath = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort() + path + "/";
%>
<!DOCTYPE html>
<html>
<head>
    <base href="<%=basePath%>">
    <meta charset="UTF-8">
    <title>流程图</title>
    <link type="text/css" rel="StyleSheet" href="plugins/Bootstrap/css/bootstrap.min.css"/>
    <style type="text/css">
        .containerDIV {
            text-align: center;
            width: 100%;
        }

        .flowNode {
            height: 50px;
            text-align: center;
            margin: 3px;
            display: inline-block;
            padding: 0 6px;;
            line-height: 50px;
            border-radius: 10px;
            border: 1px solid #ADADAD;
        }
    </style>
</head>
<body>
<script type="text/javascript" src="plugins/JQuery/jquery.min.js"></script>
<script type="text/javascript">
    var nodes = ${nodes};
    $(function () {
        var maxLevel = nodes[nodes.length - 1].NODE_LEVEL;
        var startLevel = nodes[0].NODE_LEVEL;

        for (var i = 0; i <= maxLevel - startLevel; i++) {
            $("body").append("<div id='containerDIV_" + (startLevel + i) + "' class='containerDIV'></div>");
            if (i != maxLevel - startLevel) {
                $("body").append("<div style='text-align:center;margin-top: 3px;'><img src='static/img/down.png'></div>");
            }
        }

        for (var i = 0; i < nodes.length; i++) {
            $("#containerDIV_" + nodes[i].NODE_LEVEL).append("<div class='flowNode'>" + nodes[i].NODE_NAME + "</div>");
        }
    });
</script>
</body>
</html>
