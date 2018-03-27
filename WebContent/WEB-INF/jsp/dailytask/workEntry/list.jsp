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
    <base href="<%=basePath%>"><!-- jsp文件头和头部 -->
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
                                        <td>任务名称:</td>
                                        <td><input name="taskN" id="taskN" type="text"></td>

                                        <td>年度:</td>
                                        <td><input type="text" id="END_TIME" name="END_TIME"
                                                   style="width:160px;background:#fff!important;"
                                                   class="date-picker" data-date-format="yyyy-mm-dd"
                                                   placeholder="请输入年月日！" readonly="readonly"/></td>
                                    </tr>
                                    <tr>
                                        <td>状态:</td>
                                        <td>
                                            <select name="STATUS" id="STATUS">
                                                <option value="">全部</option>
                                                <option value="1">进行中</option>
                                                <option value="2">已完成</option>
                                                <option value="5">已评价</option>
                                            </select>
                                        </td>
                                        <td>是否超时:</td>
                                        <td>
                                            <select name="STATUS" id="STATUS">
                                                <option value="">全部</option>
                                                <option value="1">未超时</option>
                                                <option value="-1">已超时</option>
                                            </select>
                                        </td>

                                    </tr>

                                </table>
                                <div style="margin-right:30px;float: right;">
                                    <a class="btn-style1" onclick="searchE();" data-toggle="collapse"
                                       data-parent="#accordion" href="#collapseTwo" style="cursor: pointer;">查询</a>
                                    <a class="btn-style2" onclick="resetting()" style="cursor: pointer;">重置</a>
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
                    <th data-column-id="TASK_CODE" data-order="asc">任务编号</th>
                    <th data-column-id="TASK_TYPE" data-formatter="type">任务类型</th>
                    <th data-column-id="TASK_NAME">任务名称</th>
                    <th data-column-id="END_TIME">完成期限</th>
                    <th data-column-id="NEED_CHECK" data-formatter="check">是否评价</th>
                    <th data-column-id="COMPLETION">完成标准</th>
                    <th data-column-id="EMP_NAME">责任人</th>
                    <th data-column-id="CREATE_USER">创建人</th>
                    <th data-column-id="CREATE_TIME" data-formatter="time">创建时间</th>
                    <th data-column-id="REMAIN_DAY">剩余天数</th>
                    <th data-column-id="STATUS" data-formatter="change">状态</th>
                    <th align="center" data-align="center" data-sortable="false" data-formatter="btns">操作</th>
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

    $(top.changeui());

    //检索
    function searchE() {
        var taskN = $("#taskN").val();
        var STATUS = $("#STATUS").val();
        var END_TIME = $("#END_TIME").val();
        var remainDay = $("#REMAIN_DAY").val();
        $("#task_grid").bootgrid("search",
            {"taskN": taskN, "STATUS": STATUS, "END_TIME": END_TIME, "REMAIN_DAY": remainDay});
    }

    //确认完成
    function complete(Id, Nc) {
        top.jzts();
        var diag = new top.Dialog();
        diag.Drag = true;
        diag.Title = "确认完成";
        diag.URL = '<%=basePath%>/workEntry/goComplete.do?ID=' + Id + '&NEED_CHECK=' + Nc;
        diag.Width = 400;
        diag.Height = 300;
        diag.CancelEvent = function () { //关闭事件
            if (diag.innerFrame.contentWindow.document.getElementById('zhongxin').style.display == 'none') {
                location.replace('<%=basePath%>/workEntry/list.do');
            }
            diag.close();
        };
        diag.show();
    }

    //查看
    function view(Id) {
        top.jzts();
        var diag = new top.Dialog();
        diag.Drag = true;
        diag.Title = "查看";
        diag.URL = '<%=basePath%>/workEntry/goView.do?ID=' + Id;
        diag.Width = 400;
        diag.Height = 300;
        diag.CancelEvent = function () { //关闭事件
            if (diag.innerFrame.contentWindow.document.getElementById('zhongxin').style.display == 'none') {
                location.replace('<%=basePath%>/workEntry/list.do');
            }
            diag.close();
        };
        diag.show();
    }

    //未完成
    function unfinish(Id) {
        if (confirm("确定未完成?")) {
            top.jzts();
            var url = "<%=basePath%>/workEntry/unfinish.do?ID=" + Id;
            $.get(url, function (data) {
                if (data == "success") {
                    location.replace('<%=basePath%>/workEntry/list.do');
                }
            }, "text");
        }
    }

    //忽略
    function ignore(Id) {

        if (confirm("确定忽略任务?")) {
            top.jzts();
            var url = "<%=basePath%>/workEntry/ignore.do?ID=" + Id;
            $.get(url, function (data) {
                if (data == "success") {
                    location.replace('<%=basePath%>/workEntry/list.do');
                }
            }, "text");
        }
    }

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

<script type="text/javascript">

    $(function () {
        //表格数据获取
        $("#task_grid").bootgrid({
            ajax: true,
            url: "workEntry/taskList.do",
            formatters: {
                btns: function (column, row) {
                    var status = row.STATUS;
                    if (status == 'YW_YSX') {
                        return '<a style="cursor:pointer;" title="确认完成" onclick="complete(\'' + row.ID + '\',\'' + row.NEED_CHECK + '\');" class="btn btn-mini btn-success" data-rel="tooltip" data-placement="left">' +
                            '<i class="icon-check"></i></a>' +
                            '<a style="cursor:pointer;" title="未完成" onclick="unfinish(\'' + row.ID + '\');" class="btn btn-mini btn-danger" data-rel="tooltip" data-placement="left">' +
                            '<i class="icon-check-empty"></i></a>';
                    } else {
                        return '<a style="cursor:pointer;" title="查看" onclick="view(\'' + row.ID + '\');" class="btn btn-mini btn-warning" data-rel="tooltip" data-placement="left">' +
                            '<i class="icon-envelope"></i></a>';
                    }
                }, check: function (columen, row) {
                    var check = row.NEED_CHECK;
                    if (check == '1') {
                        return '是';
                    } else if (check == '0') {
                        return '否';
                    }
                }, change: function (column, row) {
                    var status = row.STATUS;
                    if (status == 'YW_YSX') {
                        return '进行中';
                    } else if (status == 'YW_YWB') {
                        return '已完成';
                    } else if (status == 'YW_WWC') {
                        return '未完成';
                    } else if (status == 'YW_YPJ') {
                        return '已评价';
                    }
                },
                type: function (column, row) {
                    var type = row.TASK_TYPE;
                    if (type == 'f7c906a338d04529b9459d6af491ebd9') {
                        return "经营任务";
                    }
                    if (type == '2ea5e72ac27440879ad4946db5880443') {
                        return "创新任务";
                    }
                    if (type == '64a4c11151644d8896ebae3579b6784c') {
                        return "临时任务";
                    }
                }, time: function (column, row) {
                    var status = row.STATUS;
                    var remain_day = row.REMAIN_DAY;
                    if (status == 'YW_YSX' && remain_day >= 0) {
                        return remain_day;
                    } else if (status == 'YW_YSX' && remain_day < 0) {
                        return row.OVER_DAY;
                    } else if (status != 'YW_YSX' && status == '') {
                        return '';
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
        //日期框
        $('.date-picker').datepicker();

        //下拉框
        $(".chzn-select").chosen();
        $(".chzn-select-deselect").chosen({allow_single_deselect: true});

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

    //导出excel
    function toExcel() {
        var USERNAME = $("#nav-search-input").val();
        var lastLoginStart = $("#lastLoginStart").val();
        var lastLoginEnd = $("#lastLoginEnd").val();
        var ROLE_ID = $("#role_id").val();
        window.location.href = '<%=basePath%>/user/excel.do?USERNAME=' + USERNAME + '&lastLoginStart=' + lastLoginStart + '&lastLoginEnd=' + lastLoginEnd + '&ROLE_ID=' + ROLE_ID;
    }

    //清空
    function resetting() {
        $("#taskN").val("");
        $("#status").val("");
        $("#year").val("");
        $("#REMAIN_DAY").val("");
    }

    //打开上传excel页面
    function fromExcel() {
        top.jzts();
        var diag = new top.Dialog();
        diag.Drag = true;
        diag.Title = "EXCEL 导入到数据库";
        diag.URL = 'user/goUploadExcel.do';
        diag.Width = 300;
        diag.Height = 150;
        diag.CancelEvent = function () { //关闭事件
            diag.close();
        };
        diag.show();
    }

</script>

</body>
</html>

