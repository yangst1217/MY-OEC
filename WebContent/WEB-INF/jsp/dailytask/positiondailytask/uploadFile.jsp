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
    <link href="static/css/bootstrap.min.css" rel="stylesheet"/>
    <link href="static/css/bootstrap-responsive.min.css" rel="stylesheet"/>
    <link rel="stylesheet" href="static/css/font-awesome.min.css"/>
    <!-- 下拉框 -->
    <link rel="stylesheet" href="static/css/chosen.css"/>
    <link rel="stylesheet" href="static/css/ace.min.css"/>
    <link rel="stylesheet" href="static/css/ace-responsive.min.css"/>
    <link rel="stylesheet" href="static/css/ace-skins.min.css"/>
    <script type="text/javascript" src="static/js/jquery-1.7.2.js"></script>
    <!--提示框-->
    <script type="text/javascript" src="static/js/jquery.tips.js"></script>
    <!-- ace styles -->
    <link rel="stylesheet" href="static/assets/css/ace.css" class="ace-main-stylesheet" id="main-ace-style"/>

    <link rel="stylesheet" href="static/assets/css/font-awesome.css"/>
    <script src="static/js/ajaxfileupload.js"></script>
    <style type="text/css">
        #uploadF label {
            padding: 0 6px;
            height: 110px;
        }
    </style>
</head>
<body>
<fmt:requestEncoding value="UTF-8"/>
<form action="positionDailyTask/saveFile.do" name="positionDailyForm" id="positionDailyForm" method="post"
      enctype="multipart/form-data">
    <input type="hidden" name="daily_task_id" id="daily_task_id" value="${daily_task_id}"/>

    <div id="zhongxin">
        <table style="margin: 0 auto; width: 450px;"><br>

            <tr id="zx">
                <td style="width:100px;"><label style="text-align:left">文档上传：</label></td>
                <td id="uploadF"><input type="file" name="file" id="file"/></td>
            </tr>
            <tr>
                <td colspan="2" style="text-align: center;">
                    <a class="btn btn-mini btn-primary" onclick="save();">保存</a>&nbsp;
                    <a class="btn btn-mini btn-danger" onclick="top.Dialog.close();">取消</a>
                </td>
            </tr>

        </table>
    </div>
</form>
<!-- 引入 -->
<script type="text/javascript">window.jQuery || document.write("<script src='static/js/jquery-1.9.1.min.js'>\x3C/script>");</script>
<script src="static/js/bootstrap.min.js"></script>
<script src="static/js/ace-elements.min.js"></script>
<script src="static/js/ace.min.js"></script>

<script type="text/javascript">
    $(top.changeui());
    $(function () {

        $("#file").ace_file_input({
            style: 'well',
            btn_choose: '选择',
            btn_change: '修改',
            no_icon: 'icon-cloud-upload',
            droppable: true,
            onchange: null,
            thumbnail: 'small',
            before_change: function (files, dropped) {

                return true;
            }

        }).on('change', function () {

        });

    });

    function save() {
        $("#positionDailyForm").submit();
    }
</script>

</body>
</html>