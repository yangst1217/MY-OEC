<%@ page language="java" contentType="text/html; charset=UTF-8"
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
<html lang="zh_CN">
<head>
    <base href="<%=basePath%>">
    <link type="text/css" rel="StyleSheet" href="plugins/Bootstrap/css/bootstrap.min.css"/>
    <link type="text/css" rel="StyleSheet" href="plugins/Bootgrid/jquery.bootgrid.min.css"/>
    <link type="text/css" rel="StyleSheet" href="static/css/dtree.css"/>
    <link type="text/css" rel="StyleSheet" href="static/css/style.css"/>
    <link rel="stylesheet" href="static/css/font-awesome.min.css"/>
    <link rel="stylesheet" href="static/css/bootgrid.change.css"/>
</head>

<body>
<div class="container-fluid" id="main-container">
    <div class="row">
        <div class="col-md-12">
            <div class="nav-search" id="nav-search"
                 style="right:5px;margin-top: 20px;" class="form-search">
                <div class="panel panel-default"
                     style="float:left;position: absolute;z-index: 1000;">
                    <div>
                        <a class="btn btn-small btn-info" onclick="upload();"
                           style="margin-right:5px;float:left;">新增</a> <a
                            data-toggle="collapse" data-parent="#accordion"
                            href="#collapseTwo" class="btn btn-small btn-primary"
                            style="float:left;text-decoration:none;">高级搜索 </a>
                    </div>
                    <div id="collapseTwo" class="panel-collapse collapse"
                         style="position:absolute; top:32px; z-index:999">
                        <div class="panel-body">
                            <table>

                                <tr>
                                    <td>部门:</td>
                                    <td><input name="DEPT_NAME" id="DEPT_NAME" type="text"></td>
                                    <td>上传时间:</td>
                                    <td><input type="text" id="UPLOADTIME" name="UPLOADTIME"
                                               style="width:160px;background:#fff!important;"
                                               class="date-picker" data-date-format="yyyy-mm-dd" placeholder="请输入年月日！"
                                               readonly="readonly"/></td>
                                </tr>

                            </table>
                            <div style="margin-right:30px;float: right;">
                                <a class="btn-style1" onclick="toSearch();"
                                   data-toggle="collapse" data-parent="#accordion"
                                   href="#collapseTwo" style="cursor: pointer;">查询</a> <a
                                    class="btn-style2" onclick="emptySearch()"
                                    style="cursor: pointer;">重置</a> <a data-toggle="collapse"
                                                                       data-parent="#accordion" class="btn-style3"
                                                                       href="#collapseTwo">关闭</a>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <table id="task_grid"
                   class="table table-striped table-bordered table-hover">
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
<script type="text/javascript" src="plugins/JQuery/jquery.min.js"></script>
<script type="text/javascript" src="plugins/Bootstrap/js/bootstrap.min.js"></script>
<script type="text/javascript" src="plugins/Bootgrid/jquery.bootgrid.min.js"></script>
<script type="text/javascript" src="static/js/bootbox.min.js"></script>
<script src="static/js/ace-elements.min.js"></script>
<script src="static/js/ace.min.js"></script>
<script type="text/javascript" src="static/js/chosen.jquery.min.js"></script><!-- 下拉框 -->
<script type="text/javascript" src="static/js/bootstrap-datepicker.min.js"></script><!-- 日期框 -->
<script type="text/javascript" src="static/js/bootbox.min.js"></script><!-- 确认窗口 -->
<script type="text/javascript" src="static/js/jquery.tips.js"></script><!--提示框-->
<script type="text/javascript">
    $(function () {

        //日期框
        $('.date-picker').datepicker({
            format: 'yyyy-mm-dd',
            changeMonth: true,
            changeYear: true,
            showButtonPanel: true,
            autoclose: true,
            minViewMode: 0,
            maxViewMode: 2,
            startViewMode: 0,
            onClose: function (dateText, inst) {
                var year = $("#span2 date-picker .ui-datepicker-year :selected").val();
                $(this).datepicker('setDate', new Date(year, 1, 1));
            }
        });

        //表格数据获取
        $("#task_grid").bootgrid({
            ajax: true,
            url: "repository/taskList.do",
            formatters: {
                links: function (column, row) {
                    var url = "<%=basePath%>/repository/downLoad.do?fileName=" + row.FILENAME_SERVER;
                    return '<a style="cursor:pointer;" onclick="window.location.href=\'' + url + '\'">' + row.FILENAME + '</a>';
                },
                btns: function (column, row) {
                    var uploadPerson = row.UPLOADPERSON;
                    var user = "${USER_NAME}";
                    if (user == uploadPerson) {
                        return '<a style="cursor:pointer;" title="删除" onclick="del(\'' + row.ID + '\');" class="btn btn-mini btn-danger" data-rel="tooltip" data-placement="left">' +
                            '<i class="icon-trash"></i></a>' +
                            '<a style="cursor:pointer;" title="查看意见" onclick="checkOpinion(\'' + row.ID + '\');" class="btn btn-mini btn-primary" data-rel="tooltip" data-placement="left">' +
                            '<i class="icon-eye-open"></i></a>';
                    }
                    else if (user != uploadPerson) {
                        return '<a style="cursor:pointer;" title="编辑意见" onclick="editOpinion(\'' + row.ID + '\');" class="btn btn-mini btn-info" data-rel="tooltip" data-placement="left">' +
                            '<i class="icon-book"></i></a>';
                    }
                },
                substr: function (column, row) {
                    if (row.REMARK.length > 10) {
                        return row.REMARK.substr(0, 10) + "…";
                    } else {
                        return row.REMARK;
                    }
                }
            },
            labels: {
                infos: "{{ctx.start}}至{{ctx.end}}条，共{{ctx.total}}条",
                refresh: "刷新",
                noResults: "未查询到数据",
                loading: "正在加载...",
                all: "全选"
            },
            rowCount: [10, 25, 50, 100]
        });

    });

    //打开上传excel页面
    function upload() {
        top.jzts();
        var diag = new top.Dialog();
        diag.Drag = true;
        diag.Title = "文件上传";
        diag.URL = 'repository/showUpload.do?DOC_TYPE=1';
        diag.Width = 500;
        diag.Height = 400;
        diag.CancelEvent = function () { //关闭事件
            if (diag.innerFrame.contentWindow.document.getElementById("daoru").value == '1') {
                top.jzts();
                setTimeout("self.location.reload()", 100);
            }
            diag.close();
        };
        diag.show();
    }


    //新增
    function add() {
        var diag = new top.Dialog();
        diag.Drag = true;
        diag.Title = '新增';
        diag.URL = '<%=basePath%>/repository/goAdd.do';
        diag.Width = 380;
        diag.Height = 200;
        diag.CancelEvent = function () {
            diag.close();
            location.replace('<%=basePath%>/repository/list.do');
        };
        diag.show();
    }

    //修改
    function edit(id) {
        top.jzts();
        var diag = new top.Dialog();
        diag.Drag = true;
        diag.Title = "编辑";
        diag.URL = '<%=basePath%>/repository/goEdit.do?ID=' + id;
        diag.Width = 380;
        diag.Height = 200;
        diag.CancelEvent = function () { //关闭事件
            location.replace('<%=basePath%>/repository/list.do');
            diag.close();
        };
        diag.show();
    }

    //检索
    function toSearch() {
        var DEPT_NAME = $("#DEPT_NAME").val();
        var UPLOADTIME = $("#UPLOADTIME").val();
        $("#task_grid").bootgrid("search",
            {"DEPT_NAME": DEPT_NAME, "UPLOADTIME": UPLOADTIME});
    }

    //重置
    function emptySearch() {
        $("#DEPT_NAME").val("");
        $("#UPLOADTIME").val("");
    }

    //删除
    function del(id) {
        top.Dialog.confirm("确定要删除?", function () {
            top.jzts();
            var url = "<%=basePath%>/repository/delete.do?ID=" + id;
            $.get(url, function (data) {
                if (data == "success") {
                    top.Dialog.alert("删除成功!");
                    location.replace('<%=basePath%>/repository/list.do');
                } else {
                    top.Dialog.alert("删除失败!");
                }
            });
        })
    }

    //查看意见
    function checkOpinion(id) {
        top.jzts();
        var diag = new top.Dialog();
        diag.Drag = true;
        diag.Title = "编辑";
        diag.URL = '<%=basePath%>/repository/toCheckOpinion.do?DOC_ID=' + id;
        diag.Width = 450;
        diag.Height = 300;
        diag.CancelEvent = function () { //关闭事件
            if (diag.innerFrame.contentWindow.document.getElementById('zhongxin').style.display == 'none') {
                top.jzts();
                setTimeout("self.location.reload()", 100);
            }
            diag.close();
        };
        diag.show();
    }

    //编辑意见
    function editOpinion(id) {
        top.jzts();
        var diag = new top.Dialog();
        diag.Drag = true;
        diag.Title = "编辑";
        diag.URL = '<%=basePath%>/repository/toEditOpinion.do?DOC_ID=' + id;
        diag.Width = 222;
        diag.Height = 90;
        diag.CancelEvent = function () { //关闭事件
            if (diag.innerFrame.contentWindow.document.getElementById('zhongxin').style.display == 'none') {
                top.jzts();
                setTimeout("self.location.reload()", 100);
            }
            diag.close();
        };
        diag.show();
    }

</script>
</body>
</html>
