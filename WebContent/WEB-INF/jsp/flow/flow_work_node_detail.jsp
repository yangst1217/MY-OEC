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
    <title></title>
    <meta name="description" content="overview & stats"/>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>

    <link type="text/css" rel="StyleSheet" href="plugins/Bootstrap/css/bootstrap.min.css"/>
    <link type="text/css" rel="StyleSheet" href="plugins/Bootgrid/jquery.bootgrid.min.css"/>
    <link type="text/css" rel="StyleSheet" href="static/css/style.css"/>
    <link rel="stylesheet" href="static/css/font-awesome.min.css"/>
    <link rel="stylesheet" href="static/css/datepicker.css"/>
    <link rel="stylesheet" href="static/css/bootgrid.change.css"/>
    <link rel="stylesheet" href="plugins/zTeee3.5/zTreeStyle.css">

    <style>
        html, body {
            height: 90%;
        }

        #zhongxin td {
            padding: 3px
        }

        #zhongxin td label {
            width: 80px;
            margin-right: 8px;
            padding-top: 5px
        }

    </style>
    <!-- 引入 -->
    <script type="text/javascript" src="plugins/JQuery/jquery.min.js"></script>
    <script type="text/javascript" src="plugins/zTeee3.5/jquery.ztree.all.min.js"></script>
    <script type="text/javascript" src="plugins/Bootstrap/js/bootstrap.min.js"></script>
    <script type="text/javascript" src="plugins/Bootgrid/jquery.bootgrid.min.js"></script>

    <script src="static/js/ace-elements.min.js"></script>
    <script src="static/js/ace.min.js"></script>
    <script type="text/javascript" src="static/js/chosen.jquery.min.js"></script><!-- 下拉框 -->
    <script type="text/javascript" src="static/js/bootstrap-datepicker.min.js"></script>
    <script type="text/javascript" src="static/js/jquery.tips.js"></script>
    <!-- 引入 -->

    <script type="text/javascript">
        $(function () {
            top.changeui();
            $("#dutyTable").bootgrid({
                navigation: 0,
                formatters: {
                    detail: function (column, row) {
                        return '<span title="' + row.detail + '">' + row.detail + '</span>';
                    },
                    requirement: function (column, row) {
                        return '<span title="' + row.requirement + '">' + row.requirement + '</span>';
                    },
                    responsibility: function (column, row) {
                        return '<span title="' + row.responsibility + '">' + row.responsibility + '</span>';
                    }
                }
            });

        })

        //下载文件
        function loadFile(fileName) {
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
</head>
<body>
<div id="zhongxin" style="margin:10px;">
    <table id="dutyTable" class="table table-striped table-bordered table-hover" style="margin-bottom:0px">
        <thead>
        <tr>
            <th data-width="10%" data-column-id="ID" data-type="numeric" data-identifier="true" data-visible="false"
                data-formatter="id"
                data-css-class="aa" data-sortable="false">ID
            </th>
            <th data-width="35%" data-column-id="detail" data-formatter="detail">工作明细</th>
            <th data-width="35%" data-column-id="requirement" data-formatter="requirement">要求</th>
            <th data-width="20%" data-column-id="responsibility" data-formatter="responsibility">所属岗位职责</th>
        </tr>
        </thead>
        <tbody>
        <c:forEach items="${dutyList }" var="dutyDetail" varStatus="vs">
            <tr>
                <td>${dutyDetail.ID }</td>
                <td>${dutyDetail.detail }</td>
                <td>${dutyDetail.requirement }</td>
                <td>${dutyDetail.responsibility }</td>
            </tr>
        </c:forEach>
        </tbody>
    </table>

</div>
<div style="text-align:center">
    <c:if test="${fileNameStr !='' }">
        <a style="cursor:pointer;" onclick="loadFile('${fileNameStr}')"
           title="查看附件" class='btn btn-mini btn-primary' data-rel="tooltip" data-placement="left">
            查看附件<i class="icon-eye-open"></i>
        </a>
    </c:if>
</div>
</body>
</html>