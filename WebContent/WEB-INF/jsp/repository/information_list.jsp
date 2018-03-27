<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
    String path = request.getContextPath();
    String basePath = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort() + path + "/";
%>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <base href="<%=basePath%>">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta http-equiv="content-Type" content="text/html; charset=UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>资料库管理</title>
    <link type="text/css" rel="StyleSheet" href="static/css/ace.min.css"/>
    <link type="text/css" rel="stylesheet" href="plugins/Bootstrap/css/bootstrap.min.css"/>
    <link type="text/css" rel="stylesheet" href="plugins/Bootgrid/jquery.bootgrid.min.css"/>
    <link type="text/css" rel="stylesheet" href="static/css/style.css"/>
    <link rel="stylesheet" href="static/css/font-awesome.min.css"/>
    <link rel="stylesheet" href="plugins/bootstrap-datetimepicker/bootstrap-datetimepicker.min.css"/>
    <link rel="stylesheet" href="static/css/bootgrid.change.css"/>
    <link type="text/css" rel="StyleSheet" href="static/css/dtree.css"/>
    <script type="text/javascript" src="static/js/dtree.js"></script>
    <style>
        #zhongxin input[type="checkbox"], input[type="radio"] {
            opacity: 1;
            position: static;
            height: 25px;
            margin-bottom: 10px;
        }

        #zhongxin td {
            height: 40px;
        }

        #zhongxin td label {
            text-align: right;
            margin-right: 10px;
        }

        .container-fluid:before .row:before {
            display: inline;
        }
    </style>
</head>
<body>
<div class="container-fluid" id="main-container">
    <input type="hidden" id="DOC_TYPE" name="DOC_TYPE" value="0"/>
    <input type="hidden" id="DEPT_CLASSIFY" name="DEPT_CLASSIFY" value="${pd.DEPT_CLASSIFY}"/>
    <div id="page-content">
        <div class="row-fluid">
            <div class="main-container-left">
                <div class="m-c-l-top">
                    <img src="static/images/ui1.png" style="margin-top:-5px;">类别
                </div>
                <script type="text/javascript">
                    varList = new dTree('varList', 'static/img', 'treeForm');
                    varList.config.useIcons = true;
                    varList.add(0, -1, '类别', '');
                    <c:forEach items="${varList}" var="dept" varStatus="vs">
                    varList.add('${dept.ID}', '${dept.PARENT_ID}', '[${dept.DEPT_CODE}]${dept.DEPT_NAME}', 'javascript:searchByTree();', '', '', '', '', '', true);
                    </c:forEach>
                    document.write(varList);
                    varList.openAll();
                </script>
            </div>
            <div class="main-content" style="margin-left:220px">
                <div class="breadcrumbs" id="breadcrumbs">
                    <div class="m-c-l_show"></div>
                    资源文件详情
                    <div style="position:absolute; top:5px; right:25px;">
                        <div>
                            <a class="btn btn-small btn-info" onclick="upload();" style="margin-right:5px;float:left;">上传</a>
                        </div>
                    </div>
                </div>

                <table id="task_grid" class="table table-striped table-bordered table-hover">
                    <thead>
                    <tr>
                        <th data-column-id="FILENAME" data-formatter="links">文件名称</th>
                        <th data-column-id="NAME">上传人</th>
                        <th data-column-id="UPLOADTIME" data-order="desc">上传时间</th>
                        <th data-column-id="REMARK" data-formatter="substr">说明</th>
                        <th align="center" data-align="center" data-sortable="false"
                            data-formatter="btns">操作
                        </th>
                    </tr>
                    </thead>
                </table>
            </div>
        </div>
    </div>
</div>
<script type="text/javascript" src="plugins/JQuery/jquery.min.js"></script>
<script type="text/javascript" src="plugins/Bootstrap/js/bootstrap.min.js"></script>
<script type="text/javascript" src="plugins/Bootgrid/jquery.bootgrid.min.js"></script>
<script type="text/javascript" src="static/js/bootbox.min.js"></script>
<script type="text/javascript">
    $(function () {
        var browser_height = $(document).height();
        $("div.main-container-left").css("min-height", browser_height);
        $(window).resize(function () {
            var browser_height = $(window).height();
            $("div.main-container-left").css("min-height", browser_height);
        });

        $(".m-c-l_show").click(function () {
            $(".main-container-left").toggle();
            $(".main-container-left").toggleClass("m-c-l_width");
            $(".m-c-l_show").toggleClass("m-c-l_hide");

            var div_width = $(".main-container-left").width();
            $("div.main-content").css("margin-left", div_width + 2);
        });

        $("#task_grid").bootgrid({
            ajax: true,
            url: "repository/taskListByDeptId.do?DEPT_CLASSIFY=" + $("#DEPT_CLASSIFY").val(),
            navigation: 2,
            formatters: {
                links: function (column, row) {
                    var url = "<%=basePath%>/repository/downLoad.do?fileName=" + row.FILENAME_SERVER;
                    return '<a style="cursor:pointer;" onclick="window.location.href=\'' + url + '\'">' + row.FILENAME + '</a>';
                },
                btns: function (column, row) {
                    var uploadPerson = row.UPLOADPERSON;
                    var user = "${USER_NAME}";
                    if (user == uploadPerson && row.upload == 'noissued')
                        return '<a style="cursor:pointer;" title="删除" onclick="del(\'' + row.ID + '\');" class="btn btn-mini btn-danger" data-rel="tooltip" data-placement="left">' +
                            '<i class="icon-trash"></i></a>';
                },
                substr: function (column, row) {
                    if (row.REMARK.length > 10) {
                        return row.REMARK.substr(0, 10) + "…";
                    } else {
                        return row.REMARK;
                    }
                }
            }
        });
    });

    function searchByTree() {
        var deptId = varList.getSelected();
        $("#DEPT_CLASSIFY").val(deptId);
        $("#task_grid").bootgrid("search", {"DEPT_CLASSIFY": deptId});
    }

    //打开上传excel页面
    function upload() {
        top.jzts();
        var deptId = varList.getSelected();
        if (deptId == null) {
            top.Dialog.alert("请先选择资源类别再上传资源。");
            return false;
        }
        var diag = new top.Dialog();
        diag.Drag = true;
        diag.Title = "文件上传";
        diag.URL = 'repository/showUpload.do?DOC_TYPE=0&DEPT_CLASSIFY=' + deptId;
        diag.Width = 500;
        diag.Height = 400;
        diag.CancelEvent = function () { //关闭事件
            if (diag.innerFrame.contentWindow.document.getElementById("daoru").value == '1') {
                top.jzts();
                $("#task_grid").bootgrid("reload");
            }
            diag.close();
        };
        diag.show();
    }

    //删除
    function del(id) {
        top.Dialog.confirm("确定要删除?", function () {
            top.jzts();
            var url = "<%=basePath%>/repository/delete.do?ID=" + id;
            $.get(url, function (data) {
                if (data == "success") {
                    top.Dialog.alert("删除成功!");
                    $("#task_grid").bootgrid("reload");
                } else {
                    top.Dialog.alert("删除失败!");
                }
            });
        })
    }
</script>
</body>
</html>