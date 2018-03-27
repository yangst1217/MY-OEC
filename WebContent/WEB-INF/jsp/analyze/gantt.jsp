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
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>项目甘特图</title>
    <link rel="stylesheet" href="plugins/DHtmlX_Gantt/dhtmlxgantt.css">
    <link rel="stylesheet" href="static/css/chosen.css"/>
    <style type="text/css">
        html, body {
            height: 100%;
            padding: 0px;
            margin: 0px;
            overflow: hidden;
        }

        .gantt_grid_head_cell {
            line-height: 115px;
        }

        .custon_select {
            position: absolute;
            width: 359px;
            height: 26px;
            z-index: 1000;
            border: 1px solid #cecece;
        }

        .select_panel {
            position: absolute;
            top: 29px;
            background-color: #FFF;
            z-index: 1000;
            border: 1px solid #C1C1C1;
            font-size: 12px;
            width: 359px;
            display: none;
            max-height: 250px;
            overflow: auto;
        }

        .select_option {
            line-height: 25px;
            height: 25px;
        }

        .select_confirm {
            height: 30px;
            width: 80px;
            background-color: #438EB9;
            border: 0;
            color: white;
            cursor: pointer;
        }

        .completed_task {
            border: 0;
            background-color: #78D378;
        }

        .completed_task .gantt_task_progress {
            background-color: #19B419;
        }
    </style>
</head>
<body>
<input type="text" class="custon_select" id="custon_select" placeholder="点击选择项目" onclick='showSelect()'>
<div id="select_panel" class="select_panel">
    <c:forEach items="${projects}" var="project">
        <div class="select_option">
            <input type="checkbox" id="checkbox_${project.CODE }">
            <span>${project.NAME }</span>
        </div>
    </c:forEach>
    <div style="border-top: 1px solid #CECECE;height: 30px;text-align:center;">
        <input class="select_confirm" type="button" value="确定" onclick="selectConfirm()">
        <input class="select_confirm" type="button" value="取消" onclick="cancel()">
    </div>
</div>
<div id="gantt_here" style='width:100%; height:100%;'></div>
<script type="text/javascript" src="plugins/JQuery/jquery-1.12.2.min.js"></script>
<script src="plugins/DHtmlX_Gantt/dhtmlxgantt.js" type="text/javascript"></script>
<script src="plugins/DHtmlX_Gantt/locale_cn.js" type="text/javascript"></script>
<script type="text/javascript" src="plugins/chosen/chosen.jquery.min.js"></script>
<script type="text/javascript">
    function showSelect() {
        $("#select_panel").show();
    }

    //配置甘特图表头日期格式
    gantt.config.scale_unit = "day";
    gantt.config.step = 1;
    gantt.config.date_scale = "%m/%d";

    //配置甘特图Grid列
    gantt.config.columns = [
        {
            name: "text",
            label: "名称",
            tree: true,
            width: '*'
        },
        {
            name: "DEPT_NAME",
            label: "负责部门",
            align: "center"
        },
        {
            name: "EMP_NAME",
            label: "负责人",
            align: "center",
            width: 50
        },
        {
            name: "progress",
            label: "进度(%)",
            align: "center",
            width: 50,
            template: function (obj) {
                return obj.progress * 100;
            }
        }
    ];

    //配置甘特图附加表头
    gantt.config.subscales = [
        {
            unit: "day",
            step: 1,
            date: "%D"
        },
        {
            unit: "week",
            step: 1,
            date: "%W周"
        }
    ];

    gantt.config.scale_height = 86;
    //设置不能通过拖拽调整日期
    gantt.config.drag_resize = false;
    //不能调整连接关系
    gantt.config.drag_links = false;
    //不能移动任务块
    gantt.config.drag_move = false;
    //不能调整进度条
    gantt.config.drag_progress = false;
    //双击不会出现弹出窗口
    gantt.config.details_on_dblclick = false;
    gantt.init("gantt_here");

    gantt.templates.task_class = function (start, end, task) {
        if (task.type == 'node')
            return "completed_task";
        return "";
    };

    function cancel() {
        $("#select_panel").hide();
    }

    function selectConfirm() {
        gantt.clearAll();
        $("#select_panel").hide();
        var checkedBoxs = $(".select_option :checked");
        var project_name = "";
        $.each(checkedBoxs, function (i, n) {
            project_name += "," + $(n).next().text();
            var project_id = n.id;
            gantt.load("cproject/findTreeByProjectId.do?code="
                + project_id.substr(9, project_id.length));
        });
        $("#custon_select").val(project_name.substr(1, project_name.length));
    }
</script>
</body>
</html>