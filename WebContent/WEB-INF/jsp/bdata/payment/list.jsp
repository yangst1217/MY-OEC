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
    <link type="text/css" rel="StyleSheet" href="static/css/ace.min.css"/>
    <link type="text/css" rel="StyleSheet" href="plugins/Bootstrap/css/bootstrap.min.css"/>
    <link type="text/css" rel="StyleSheet" href="plugins/Bootgrid/jquery.bootgrid.min.css"/>
    <link type="text/css" rel="StyleSheet" href="static/css/dtree.css"/>
    <link type="text/css" rel="StyleSheet" href="static/css/style.css"/>
    <link rel="stylesheet" href="static/css/font-awesome.min.css"/>
    <link rel="stylesheet" href="static/css/bootgrid.change.css"/>
</head>

<body>
<div class="container-fluid" id="main-container">
    <div id="page-content" class="clearfix">
        <div class="breadcrumbs" id="breadcrumbs">
            &nbsp; &nbsp; 薪酬基础数据
            <div style="position:absolute; top:5px; right:25px;">
                <div>
                    <a class="btn btn-small btn-info" onclick="add();" style="margin-right:5px;float:left;">新增</a>
                    <a data-toggle="collapse" data-parent="#accordion" href="#collapseTwo"
                       class="btn btn-small btn-primary" style="float:left;text-decoration:none;">高级搜索 </a>
                </div>
                <div id="collapseTwo" class="panel-collapse collapse"
                     style="position:absolute;  top:32px;right:0; z-index:999">
                    <div class="panel-body">
                        <%-- <span class="input-icon">
                            关键字：<input autocomplete="off" id="nav-search-input" type="text" name="keyword" value="${pd.keyword}" placeholder="这里输入关键词" />
                            <i id="nav-search-icon" class="icon-search"></i>
                        </span> --%>
                        <table>
                            <tr>
                                <td>任务编号/任务名称:</td>
                                <td><input name="keyword" id="keyword" type="text"></td>

                            </tr>
                        </table>
                        <div
                                style="margin-top:15px; margin-right:30px; text-align:right;">
                            <a class="btn-style1" onclick="search2();" data-toggle="collapse" data-parent="#accordion"
                               href="#collapseTwo" style="cursor: pointer;">查询</a>
                            <a class="btn-style2" onclick="resetting()" style="cursor: pointer;">重置</a>
                            <a data-toggle="collapse" data-parent="#accordion" class="btn-style3"
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
                <th data-column-id="CODE" data-order="asc">编号</th>
                <th data-column-id="NAME">名称</th>
                <th data-column-id="TYPE" data-formatter="type">类型</th>
                <th data-column-id="CREATE_USER">创建人</th>
                <th data-column-id="CREATE_TIME">创建时间</th>
                <th align="center" data-align="center" data-sortable="false"
                    data-formatter="btns">操作
                </th>
            </tr>
            </thead>
        </table>
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
        //表格数据获取
        $("#task_grid").bootgrid({
            ajax: true,
            url: "payment/taskList.do",
            navigation: 2,
            formatters: {
                btns: function (column, row) {
                    return '<a style="cursor:pointer;margin-left: 2px;" title="修改" onclick="edit(\'' + row.ID + '\');" class="btn btn-mini btn-primary" data-rel="tooltip" data-placement="left">' +
                        '修改</a>' +
                        '<a style="cursor:pointer;margin-left: 2px;" title="删除" onclick="del(\'' + row.ID + '\');" class="btn btn-mini btn-danger" data-rel="tooltip" data-placement="left">' +
                        '删除</a>';
                },
                type: function (column, row) {
                    var type = row.TYPE;
                    if (type == '1') {
                        return '基础项';
                    } else if (type == '2') {
                        return '运算符';
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

    //新增
    function add() {
        var diag = new top.Dialog();
        diag.Drag = true;
        diag.Title = '新增';
        diag.URL = '<%=basePath%>/payment/goAdd.do';
        diag.Width = 380;
        diag.Height = 200;
        diag.CancelEvent = function () {
            diag.close();
            location.replace('<%=basePath%>/payment/list.do');
        };
        diag.show();
    }

    //修改
    function edit(id) {
        top.jzts();
        var diag = new top.Dialog();
        diag.Drag = true;
        diag.Title = "编辑";
        diag.URL = '<%=basePath%>/payment/goEdit.do?ID=' + id;
        diag.Width = 380;
        diag.Height = 200;
        diag.CancelEvent = function () { //关闭事件
            location.replace('<%=basePath%>/payment/list.do');
            diag.close();
        };
        diag.show();
    }

    //检索
    function toSearch() {
        var keyWord = $("#keyword").val();
        $("#task_grid").bootgrid("search",
            {"keyword": keyWord});
    }

    //重置
    function emptySearch() {
        $("#keyword").val("");
    }

    //删除
    function del(id) {
        if (confirm("确定要删除?")) {
            top.jzts();
            var url = "<%=basePath%>/payment/delete.do?ID=" + id;
            $.get(url, function (data) {
                if (data == "success") {
                    alert("删除成功!");
                    location.replace('<%=basePath%>/payment/list.do');
                } else {
                    alert("删除失败!");
                }
            });
        }
    }
</script>
</body>
</html>
