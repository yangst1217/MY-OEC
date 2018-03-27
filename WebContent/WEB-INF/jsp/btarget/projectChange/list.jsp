<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%
    String path = request.getContextPath();
    String basePath = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort() + path + "/";
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <base href="<%=basePath%>">
    <!-- jsp文件头和头部 -->
    <link type="text/css" rel="StyleSheet" href="plugins/Bootstrap/css/bootstrap.min.css"/>
    <link type="text/css" rel="StyleSheet" href="plugins/Bootgrid/jquery.bootgrid.min.css"/>
    <link type="text/css" rel="StyleSheet" href="static/css/dtree.css"/>
    <link type="text/css" rel="StyleSheet" href="static/css/style.css"/>
    <link rel="stylesheet" href="static/css/font-awesome.min.css"/>
    <link rel="stylesheet" href="static/css/bootgrid.change.css"/>
</head>

<body>
<fmt:requestEncoding value="UTF-8"/>

<div class="container-fluid" id="main-container">
    <div class="row">
        <div class="col-md-12">
            <div class="nav-search" id="nav-search" style="right:5px;margin-top: 20px;" class="form-search">
                <div class="panel panel-default" style="float:left;position: absolute;z-index: 1000;">
                    <div>
                        <a class="btn btn-small btn-info" onclick="add();" style="margin-right:5px;float:left;">新增</a>
                        <a data-toggle="collapse" data-parent="#accordion" href="#collapseTwo"
                           class="btn btn-small btn-primary" style="float:left;text-decoration:none;">高级搜索 </a>
                    </div>
                    <div id="collapseTwo" class="panel-collapse collapse"
                         style="position:absolute; top:32px; z-index:999">
                        <div class="panel-body">
                            <form id="searchForm">
                                <table>

                                    <tr>
                                        <td>项目名称:</td>
                                        <td><input name="NAME" id="NAME" type="text"></td>
                                        <td>状态:</td>
                                        <td>
                                            <select name="STATUS" id="STATUS">
                                                <option value="">全部</option>
                                                <option value="YW_CG">草稿</option>
                                                <option value="YW_YSX">已生效</option>
                                                <option value="YW_DSX">待生效</option>
                                                <option value="YW_YTH">已退回</option>
                                            </select>
                                        </td>

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
                <thead>
                <tr>
                    <th data-column-id="NAME">项目名称</th>
                    <th data-column-id="UPDATE_TIME">变更时间</th>
                    <th data-column-id="CREATE_USER">变更人</th>
                    <th data-column-id="STATUS" data-formatter="change">当前状态</th>
                    <th align="center" data-align="center" data-sortable="false" data-formatter="btns">操作</th>
                </tr>
                </thead>
            </table>
        </div>
    </div>


</div><!--/.fluid-container#main-container-->

<!-- 返回顶部  -->
<a href="#" id="btn-scroll-up" class="btn btn-small btn-inverse">
    <i class="icon-double-angle-up icon-only"></i>
</a>

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

    $(top.changeui());

    //检索
    function search2() {
        var name = $("#NAME").val();
        var status = $("#STATUS").val();
        $("#task_grid").bootgrid("search",
            {"NAME": name, "STATUS": status});
    }

    //修改
    function edit(Id) {
        var diag = new top.Dialog();
        diag.Drag = true;
        diag.Title = "修改";
        diag.URL = "<%=basePath%>/projectChange/goEdit.do?ID=" + Id;
        diag.Width = 850;
        diag.Height = 800;
        diag.CancelEvent = function () { //关闭事件

            diag.close();
            location.replace('<%=basePath%>/projectChange/list.do');
        };
        diag.show();
    }


    //提交
    function goSubmit(id, status) {

        top.Dialog.confirm("确定要提交?", function () {
            //top.jzts();
            var url = "<%=basePath%>/projectChange/changeStatus.do?ID=" + id + "&STATUS=" + status;
            $.get(url, function (data) {
                if (data == "success") {
                    top.Dialog.alert("提交成功！");
                    //nextPage(${page.currentPage});
                    location.replace("<%=basePath%>/projectChange/list.do");
                }
                else {
                    top.Dialog.alert("提交失败！");
                    //nextPage(${page.currentPage});
                    location.replace("<%=basePath%>/projectChange/list.do");
                }
            }, "text");

        })

    }

    //查看
    function view(Id) {
        top.jzts();
        var diag = new top.Dialog();
        diag.Drag = true;
        diag.Title = "查看";
        diag.URL = "<%=basePath%>/projectChange/goView.do?ID=" + Id;
        diag.Width = 850;
        diag.Height = 800;
        diag.CancelEvent = function () { //关闭事件
            diag.close();
            location.replace('<%=basePath%>/projectChange/list.do');
        };
        diag.show();
    }

    //新增
    function add() {
        top.jzts();
        var diag = new top.Dialog();
        diag.Drag = true;
        diag.Title = "新增";
        diag.URL = '<%=basePath%>/projectChange/goAdd.do';
        diag.Width = 850;
        diag.Height = 800;
        diag.CancelEvent = function () { //关闭事件
            diag.close();
            location.replace('<%=basePath%>/projectChange/list.do');
        };
        diag.show();
    }

    //删除
    function del(id) {

        top.Dialog.confirm("确定要删除?", function () {
            //top.jzts();
            var url = "<%=basePath%>/projectChange/delete.do?ID=" + id;
            $.get(url, function (data) {
                if (data == "success") {
                    top.Dialog.alert("删除成功！");
                    //nextPage(${page.currentPage});
                    location.replace("<%=basePath%>/projectChange/list.do");
                }
                else {
                    top.Dialog.alert("删除失败！");
                    //nextPage(${page.currentPage});
                    location.replace("<%=basePath%>/projectChange/list.do");
                }
            }, "text");

        })

    }


    //清空
    function emptySearch() {
        $("#NAME").val("");
        $("#STATUS").val("");
    }


</script>

<script type="text/javascript">

    $(function () {
        //表格数据获取
        $("#task_grid").bootgrid({
            ajax: true,
            url: "projectChange/taskList.do?state=0",
            formatters: {
                btns: function (column, row) {
                    var res = row.STATUS;
                    var str = '<a style="cursor:pointer;" title="查看" onclick="view(\'' + row.ID + '\');" class="btn btn-mini btn-primary" data-rel="tooltip" data-placement="left">' +
                        '<i class="icon-eye-open"></i></a>';
                    if (res == 'YW_YTH') {
                        str += '<a style="cursor:pointer;" title="编辑" onclick="edit(\'' + row.ID + '\');" class="btn btn-mini btn-info" data-rel="tooltip" data-placement="left">' +
                            '<i class="icon-edit"></i></a>' +
                            '<a style="cursor:pointer;" title="删除" onclick="del(\'' + row.ID + '\');" class="btn btn-mini btn-danger" data-rel="tooltip" data-placement="left">' +
                            '<i class="icon-trash"></i></a>' +
                            '<a style="cursor:pointer;" title="提交" onclick="goSubmit(\'' + row.ID + '\',\'YW_DSX\');" class="btn btn-mini btn-primary" data-rel="tooltip" data-placement="left">' +
                            '<i class="icon-envelope"></i></a>';
                    }
                    if (res == 'YW_CG') {
                        str += '<a style="cursor:pointer;" title="编辑" onclick="edit(\'' + row.ID + '\');" class="btn btn-mini btn-info" data-rel="tooltip" data-placement="left">' +
                            '<i class="icon-edit"></i></a>' +
                            '<a style="cursor:pointer;" title="删除" onclick="del(\'' + row.ID + '\');" class="btn btn-mini btn-danger" data-rel="tooltip" data-placement="left">' +
                            '<i class="icon-trash"></i></a>' +
                            '<a style="cursor:pointer;" title="提交" onclick="goSubmit(\'' + row.ID + '\',\'YW_DSX\');" class="btn btn-mini btn-primary" data-rel="tooltip" data-placement="left">' +
                            '<i class="icon-envelope"></i></a>';
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
        //下拉框
        $(".chzn-select").chosen();
        $(".chzn-select-deselect").chosen({allow_single_deselect: true});

        //日期框
        $('.date-picker').datepicker({
            format: 'yyyy',
            changeMonth: true,
            changeYear: true,
            showButtonPanel: true,
            autoclose: true,
            minViewMode: 2,
            onClose: function (dateText, inst) {
                var year = $("#span2 date-picker .ui-datepicker-year :selected").val();
                $(this).datepicker('setDate', new Date(year, 1, 1));
            }
        });

        //复选框
        $('table th input:checkbox').on('click', function () {
            var that = this;
            $(this).closest('table').find('tr > td:first-child input:checkbox')
                .each(function () {
                    this.checked = that.checked;
                    $(this).closest('tr').toggleClass('selected');
                });

        });

    });

    function nextPage(page) {
        top.jzts();
        if (true && document.forms[0]) {
            var url = document.forms[0].getAttribute("action");
            if (url.indexOf('?') > -1) {
                url += "&currentPage=";
            }
            else {
                url += "?currentPage=";
            }
            url = url + page + "&showCount=10";
            document.forms[0].action = url;
            document.forms[0].submit();
        } else {
            var url = document.location + '';
            if (url.indexOf('?') > -1) {
                if (url.indexOf('currentPage') > -1) {
                    var reg = /currentPage=\d*/g;
                    url = url.replace(reg, 'currentPage=');
                } else {
                    url += "&currentPage=";
                }
            } else {
                url += "?currentPage=";
            }
            url = url + page + "&showCount=10";
            document.location = url;
        }
    }


</script>

</body>
</html>

