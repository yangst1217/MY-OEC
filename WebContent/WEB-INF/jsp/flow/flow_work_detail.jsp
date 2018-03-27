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
    <meta charset="UTF-8">
    <title>流程明细</title>
    <link type="text/css" rel="StyleSheet" href="plugins/Bootstrap/css/bootstrap.min.css"/>
    <link type="text/css" rel="StyleSheet" href="plugins/Bootgrid/jquery.bootgrid.min.css"/>
    <style type="text/css">
        #myTab {
            margin-bottom: 0;
        }

        #myTab li {
            background: #98c0d9;
            margin: 0;
            border: 2px solid #98c0d9;
        }

        #myTab > li.active {
            border: 2px solid #448fb9;
        }

        #myTab li.active a {
            margin: 0;
            box-shadow: none !important;
            background: #448fb9;
            border: 0
        }

        #myTab li.active a:hover {
            background: #448fb9;
        }

        #myTab li a {
            color: #fff;
            padding: 12px 25px;
            line-height: 16px;
        }

        #myTab li a:hover {
            color: #fff;
            background: #98c0d9;
        }

        .tab-content {
            padding: 0;
            border: 0;
        }

        .wrapSpan {
            overflow: hidden;
            text-overflow: ellipsis;
            white-space: nowrap;
            width: 150px;
        }

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
        }

        .gbcolor_YW_DSX {
            border: 1px solid #ADADAD;
        }

        .gbcolor_YW_YSX {
            background-color: #FFB752;
            color: white;
        }

        .gbcolor_YW_YJS {
            background-color: #5BC0DE;
            color: white;
        }

        .gbcolor_YW_YTH {
            background-color: #D15B47;
            color: white;
        }

        .gbcolor_YW_YWB {
            background-color: #438EB9;
            color: white;
        }

        .flow_tag {
            height: 20px;
            width: 30px;
            border-radius: 5px;
            display: inline-block;
            vertical-align: middle;
        }
    </style>
</head>
<body>
<!-- tab页 -->
<ul id="myTab" class="nav nav-tabs">
    <li class="active">
        <a id="tab_history" href="#history" data-toggle="tab">流程历史</a>
    </li>
    <li>
        <a id="tab_image" href="#image" data-toggle="tab">流程图</a>
    </li>
    <li>
        <a id="tab_detail" href="#detail" data-toggle="tab">流程详情</a>
    </li>
</ul>
<div id="myTabContent" class="tab-content" style="overflow:inherit">
    <div id="history" class="tab-pane fade in active">
        <!--
                <div style="padding: 5px;width: 100%;word-wrap:break-word;">备注：${flowWork.REMARKS}</div>
                 -->
        <table class="table table-striped table-bordered table-hover">
            <tr>
                <th>操作人</th>
                <th>操作时间</th>
                <th>操作节点</th>
                <th>操作类型</th>
                <th>目标节点</th>
                <th>目标责任人</th>
                <th>逾期扣分</th>
                <th>附件</th>
                <th>备注</th>
            </tr>
            <c:forEach items="${flowHistory}" var="history">
                <tr>
                    <td>
                            ${history.OPERATOR}
                    </td>
                    <td>${history.operTime}</td>
                    <td>
                        <div class="wrapSpan" title="${history.CURRENT_NODE_NAME }">
                                ${history.CURRENT_NODE_NAME }
                        </div>
                    </td>
                    <td>${history.OPERA_TYPE }</td>
                    <td>
                        <div class="wrapSpan" title="${history.NEXT_NODE_NAME }">
                                ${history.NEXT_NODE_NAME }
                        </div>
                    </td>
                    <td>${history.EMP_NAME }</td>
                    <td>${history.SCORE }</td>
                    <td>
                        <c:choose>
                            <c:when test="${not empty history.fileList }">
                                <c:forEach items="${history.fileList }" var="file" varStatus="vs">
                                    <a style="cursor:pointer;"
                                       onclick="loadFile('${file.FILENAME_SERVER }')">${file.FILENAME }
                                    </a><br>
                                </c:forEach>
                                <c:if test="${history.fileNameStr!='' }">
                                    <br><a style="cursor:pointer;" onclick="loadAllFile('${history.fileNameStr }')"
                                           class="btn btn-mini btn-info" data-rel="tooltip"
                                           data-placement="left">全部下载</a>
                                </c:if>

                            </c:when>

                        </c:choose>

                    </td>
                    <td>
                        <div class="wrapSpan" title="${history.REMARKS }">
                                ${history.REMARKS }
                        </div>
                    </td>
                </tr>
            </c:forEach>
        </table>
    </div>
    <div id="image" class="tab-pane fade">
        <div style="position: absolute;">
            <div style="position: fixed;top: 50px;left: 6px;border: 1px solid #ADADAD;padding: 6px;">
                <div style="margin-bottom: 6px;">
                    <div class="gbcolor_YW_DSX flow_tag"></div>
                    <span class="tag_title">待生效</span>
                </div>
                <div style="margin-bottom: 6px;">
                    <div class="gbcolor_YW_YSX flow_tag"></div>
                    <span class="tag_title">已生效</span>
                </div>
                <div style="margin-bottom: 6px;">
                    <div class="gbcolor_YW_YJS flow_tag"></div>
                    <span class="tag_title">已接收</span>
                </div>
                <div style="margin-bottom: 6px;">
                    <div class="gbcolor_YW_YTH flow_tag"></div>
                    <span class="tag_title">已退回</span>
                </div>
                <div style="margin-bottom: 6px;">
                    <div class="gbcolor_YW_YWB flow_tag"></div>
                    <span class="tag_title">已完毕</span>
                </div>
            </div>
        </div>
    </div>
    <div id="detail" class="tab-pane fade">
        <table class="table table-striped table-bordered table-hover">
            <tr>
                <th>节点名称</th>
                <th>节点层级</th>
                <th>责任部门</th>
                <th>责任岗位</th>
                <th>责任人</th>
                <!-- <th>备注</th> -->
            </tr>
            <c:forEach items="${flowNodes}" var="node">
                <tr>
                    <td>
                        <div class="wrapSpan" title="${node.NODE_NAME }">
                                ${node.NODE_NAME }
                        </div>
                    </td>
                    <td>${node.NODE_LEVEL }</td>
                    <td>
                        <div class="wrapSpan" title="${node.DEPT_NAME }">
                                ${node.DEPT_NAME }
                        </div>
                    </td>
                    <td>${node.GRADE_NAME }</td>
                    <td>${node.EMP_NAME }</td>
                    <!--
                            <td>
                                <div class="wrapSpan" title="${node.REMARKS }">
                                    ${node.REMARKS }
                                </div>
                            </td>
                             -->
                </tr>
            </c:forEach>
        </table>
    </div>
</div>
<script type="text/javascript" src="plugins/JQuery/jquery.min.js"></script>
<script type="text/javascript" src="plugins/Bootstrap/js/bootstrap.min.js"></script>
<script type="text/javascript" src="plugins/Bootgrid/jquery.bootgrid.min.js"></script>
<script type="text/javascript">
    var nodes = ${nodesGson};
    $(function () {
        var maxLevel = nodes[nodes.length - 1].NODE_LEVEL;
        var startLevel = nodes[0].NODE_LEVEL;

        for (var i = 0; i <= maxLevel - startLevel; i++) {
            $("#image").append("<div id='containerDIV_" + (startLevel + i) + "' class='containerDIV'></div>");
            if (i != maxLevel - startLevel) {
                $("#image").append("<div style='text-align:center;margin-top: 3px;'><img src='static/img/down.png'></div>");
            }
        }

        for (var i = 0; i < nodes.length; i++) {
            var nodestr = "<div class='gbcolor_" + nodes[i].STATUS + " flowNode'>" + nodes[i].NODE_NAME + "</div>";
            $("#containerDIV_" + nodes[i].NODE_LEVEL).append(nodestr);
        }

    });

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

    //打包下载文件
    function loadAllFile(fileName) {
        if (fileName != '') {
            var arr = fileName.split(",");
            var action = '<%=basePath%>empDailyTask/checkFile.do';
            var flag = true;
            for (var i = 0; i < arr.length; i++) {
                var name = arr[i];
                $.ajax({
                    async: false,
                    type: "get",
                    dataType: "text",
                    data: {"fileName": name, "time": time},
                    url: action,
                    success: function (data) {
                        if (data == "") {
                            top.Dialog.alert("文件" + name + "不存在！");
                            flag = false;
                        }

                    }
                });
                if (flag == false) {
                    return;
                }
            }
            var time = new Date().getTime();
            window.location.href = '<%=basePath%>empDailyTask/loadAllFile.do?fileName=' + fileName + "&time=" + time;

        }


    }
</script>
</body>
</html>