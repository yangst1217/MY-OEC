<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%
    String path = request.getContextPath();
    String basePath = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort() + path + "/";
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
    <style type="text/css">
        li {
            list-style-type: none;
        }
    </style>
</head>
<body>
<div class="container-fluid" id="main-container">
    <div class="row">
        <div class="col-md-12">
            <div class="nav-search" id="nav-search" style="right:5px;margin-top: 20px;" class="form-search">
                <div class="panel panel-default" style="float:left;position: absolute;z-index: 1000;">
                    <div style="float:left">
                        <a data-toggle="collapse" data-parent="#accordion" href="#collapseTwo"
                           class="btn btn-small btn-primary" style="float:left;text-decoration:none;">高级搜索 </a>
                    </div>
                    <div id="btnDiv" style="float:left; margin-left:196px;"><!-- 页面点击查询 -开始 -->
                        <input id="searchField" type="hidden" value="YW_DSX"/><!-- 默认加载查询的值 -->
                        <button class="btn btn-small btn-info active" onclick="clickSearch('YW_DSX', this);">待审核
                        </button>
                        <button class="btn btn-small btn-info" onclick="clickSearch('YW_YSX', this);">已审核</button>
                        <button class="btn btn-small btn-info" onclick="clickSearch('', this);">全部</button>
                    </div><!-- 页面点击查询 -结束 -->
                    <div id="collapseTwo" class="panel-collapse collapse"
                         style="position:absolute; top:32px; z-index:999">
                        <div class="panel-body">
                            <form id="searchForm">
                                <table>

                                    <tr>
                                        <td>完成期限:</td>
                                        <td><input type="text" id="year" name="year"
                                                   style="width:160px;background:#fff!important;"
                                                   class="date-picker" data-date-format="yyyy-mm-dd"
                                                   placeholder="请输入年月日！" readonly="readonly"/></td>
                                        <td>任务编号/任务名称:</td>
                                        <td><input name="keyword" id="keyword" type="text"></td>

                                    </tr>

                                </table>
                                <div style="margin-right:30px;float: right;">
                                    <a class="btn-style1" onclick="search2();" data-toggle="collapse"
                                       data-parent="#accordion" href="#collapseTwo" style="cursor: pointer;">查询</a>
                                    <a class="btn-style2" onclick="emptySearch()" style="cursor: pointer;">重置</a>
                                    <a data-toggle="collapse" data-parent="#accordion" class="btn-style3"
                                       href="#collapseTwo">关闭</a>
                                </div>
                            </form>
                        </div>
                    </div>
                </div>
            </div>
            <table id="task_grid" class="table table-striped table-bordered table-hover">
                <input type="hidden" name="count" id="COUNT" value="${count}"/>
                <thead>
                <tr>
                    <th data-column-id="TASK_CODE" data-width="90px">任务编号</th>
                    <th data-formatter="type" data-visible="false" data-width="80px">任务类型</th>
                    <th data-column-id="TASK_NAME" data-formatter="taskName">任务名称</th>
                    <th data-column-id="START_TIME" data-width="140px">开始时间</th>
                    <th data-column-id="END_TIME" data-width="140px">结束时间</th>
                    <th data-column-id="MAIN_EMP_NAME" data-width="61px">责任人</th>
                    <th data-column-id="CREATE_NAME" data-width="61px">创建人</th>
                    <th data-column-id="CREATE_TIME" data-width="140px">创建时间</th>
                    <th data-column-id="STATUS" data-formatter="change" data-width="50px">状态</th>
                    <th align="center" data-align="center" data-sortable="false" data-width="90px"
                        data-formatter="btns">操作
                    </th>
                </tr>
                </thead>
            </table>
        </div>
    </div>
</div><!--/.fluid-container#main-container-->
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
            url: "workOrder/checkList.do",
            formatters: {
                taskName: function (column, row) {
                    return '<span style="cursor:pointer;" title="' + row.TASK_NAME + '">' + row.TASK_NAME + '</span>';
                },
                btns: function (column, row) {
                    var res = row.STATUS;
                    var str = '';
                    var count = row.COUNT;
                    if (res == 'YW_YSX') {
                        str += '<a style="cursor:pointer;" title="查看" onclick="view(\'' + row.ID + '\',\'' + row.TASK_CODE + '\');" class="btn btn-mini btn-info" data-rel="tooltip" data-placement="left">' +
                            '<i class="icon-eye-open"></i></a>';
                    }
                    if (res == 'YW_DSX') {
                        str += '<a style="cursor:pointer;" title="查看" onclick="view(\'' + row.ID + '\',\'' + row.TASK_CODE + '\');" class="btn btn-mini btn-info" data-rel="tooltip" data-placement="left">' +
                            '<i class="icon-eye-open"></i></a>' +
                            '<a style="cursor:pointer;" title="审核通过" onclick="save(\'' + row.ID + '\',\'YW_YSX\',\'' + row.TASK_CODE + '\',\'' + row.MAIN_EMP_ID + '\',\'' + row.MAIN_EMP_NAME + '\');" class="btn btn-mini btn-primary" data-rel="tooltip" data-placement="left">' +
                            '<i class="icon-check"></i></a>' +
                            '<a style="cursor:pointer;" title="审核退回" onclick="save(\'' + row.ID + '\',\'YW_YTH\',\'' + row.TASK_CODE + '\',\'' + row.MAIN_EMP_ID + '\',\'' + row.MAIN_EMP_NAME + '\');" class="btn btn-mini btn-danger" data-rel="tooltip" data-placement="left">' +
                            '<i class="icon-check-empty"></i></a>';
                    }

                    return str;
                },
                change: function (column, row) {
                    var status = row.STATUS;
                    if (status == 'YW_CG') {
                        return '草稿';
                    } else if (status == 'YW_YSX') {
                        return '已生效';
                    } else if (status == 'YW_DSX') {
                        return '待生效';
                    } else if (status == 'YW_YTH') {
                        return '已退回';
                    }
                },
                type: function (column, row) {
                    return "临时任务";
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
        }).bootgrid("search", {"status": $("#searchField").val()});
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
    });

    $(top.changeui());

    //重置
    function resetting() {
        $("#year").val("");
        $("#keyword").val("");
    }

    //检索
    function search2() {
        var year = $("#year").val();
        var keyword = $("#keyword").val();
        var searchField = $("#searchField").val();
        $("#task_grid").bootgrid("search",
            {"year": year, "keyword": keyword, "status": searchField});
    }

    //点击进行查询
    function clickSearch(value, ele) {
        $("#btnDiv button").removeClass("active");
        $(ele).addClass("active");
        $("#searchField").val(value);
        search2();
    }

    function save(id, status, TASK_CODE, MAIN_EMP_ID, MAIN_EMP_NAME) {
        if (status == "YW_YSX") {
            top.Dialog.confirm("是否确认通过?", function () {
                top.jzts();
                var url = "<%=basePath%>/workOrder/update.do?id=" + id + "&status=" + status + "&TASK_CODE=" + id + "&MAIN_EMP_ID=" + MAIN_EMP_ID + "&MAIN_EMP_NAME=" + MAIN_EMP_NAME;
                $.get(url, function (data) {
                    if (data == "success") {
                        location.replace('<%=basePath%>/workOrder/listCheck.do');
                    }
                });
            });
        }
        if (status == "YW_YTH") {
            top.Dialog.confirm("是否确认驳回?", function () {
                top.jzts();
                var url = "<%=basePath%>/workOrder/update.do?id=" + id + "&status=" + status + "&TASK_CODE=" + id + "&MAIN_EMP_ID=" + MAIN_EMP_ID + "&MAIN_EMP_NAME=" + MAIN_EMP_NAME;
                $.get(url, function (data) {
                    if (data == "success") {
                        location.replace('<%=basePath%>/workOrder/listCheck.do');
                    }
                });
            });
        }
    }

    // view(
    function view(id, taskTypeId) {
        top.jzts();
        var diag = new top.Dialog();
        diag.Drag = true;
        diag.Title = "查看";
        diag.URL = '<%=basePath%>/workOrder/goView.do?id=' + id + '&taskTypeId=' + taskTypeId;
        diag.Width = 400;
        diag.Height = 480;
        diag.CancelEvent = function () { //关闭事件
            location.replace('<%=basePath%>/workOrder/listCheck.do');
            diag.close();
        };
        diag.show();
    }

    //清空
    function emptySearch() {
        $("#year").val("");
        $("#keyword").val("");
    }

</script>
</body>
</html>
