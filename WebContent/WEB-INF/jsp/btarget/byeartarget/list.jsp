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
<html lang="zh-CN">
<head>
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta http-equiv="content-Type" content="text/html; charset=UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>年度经营目标列表</title>
    <base href="<%=basePath%>">
    <!-- jsp文件头和头部 -->
    <link type="text/css" rel="StyleSheet" href="plugins/Bootstrap/css/bootstrap.min.css"/>
    <link type="text/css" rel="StyleSheet" href="plugins/Bootgrid/jquery.bootgrid.min.css"/>
    <link type="text/css" rel="StyleSheet" href="static/css/dtree.css"/>
    <link type="text/css" rel="StyleSheet" href="static/css/style.css"/>
    <link rel="stylesheet" href="static/css/font-awesome.min.css"/>
    <link rel="stylesheet" href="static/css/bootgrid.change.css"/>
    <!-- 引入 -->
    <style type="text/css">
        #main-container {
            padding: 0;
            position: relative
        }

        #breadcrumbs {
            position: relative;
            z-index: 13;
            border-bottom: 1px solid #e5e5e5;
            background-color: #f5f5f5;
            height: 37px;
            line-height: 37px;
            padding: 0 12px 0 0;
            display: block
        }

        .bootgrid-table th > .column-header-anchor > .text {
            margin: 0px 13px 0px 0px
        }
    </style>
</head>
<body>
<div class="container-fluid" id="main-container">
    <div id="page-content" class="clearfix">
        <div class="breadcrumbs" id="breadcrumbs" style="">
            &nbsp; &nbsp; <span style="margin-left:20px; float:left; font-size:15px">公司年度经营目标</span>
            <div id="btnDiv" style="float:left; margin-left:150px;">
                <input id="searchField" type="hidden" value="0"/>
                <button class="btn btn-small btn-danger" onclick="clickSearch(0, this);">待分解</button>
                <button class="btn btn-small btn-warning" onclick="clickSearch(1, this);">待下发</button>
                <button class="btn btn-small btn-success" onclick="clickSearch(2, this);">已下发</button>
                <button class="btn btn-small btn-info active" onclick="clickSearch(-1, this);">全部</button>
            </div>
            <div style="position:absolute; top:5px; right:25px;">
                <div>
                    <a class="btn btn-small btn-info" onclick="add();" style="margin-right:5px;float:left;">新增</a>
                    <a class="btn btn-small btn-danger" onclick="del();" style="margin-right:5px;float:left;">删除</a>
                    <a data-toggle="collapse" data-parent="#accordion" href="#collapseTwo"
                       class="btn btn-small btn-primary"
                       style="float:left;text-decoration:none;">高级搜索 </a>
                </div>
                <div id="collapseTwo" class="panel-collapse collapse"
                     style="position:absolute;  top:32px;right:0; z-index:999">
                    <div class="panel-body">
                        <%-- <span class="input-icon">
                            关键字：<input autocomplete="off" id="nav-search-input" type="text" name="keyword" value="${pd.keyword}" placeholder="这里输入关键词" />
                            <i id="nav-search-icon" class="icon-search"></i>
                        </span> --%>
                        <form id="searchForm">
                            <table>
                                <tr>
                                    <td><label>开始时间：</label></td>
                                    <td><input type="text" id="START_DATE" name="START_DATE"
                                               style="width:160px;background:#fff!important;" onchange="checkDate()"
                                               class="date-picker" data-date-format="yyyy-mm-dd" placeholder="请输入年月日！"
                                               readonly="readonly"/></td>
                                    <td><label>结束时间：</label></td>
                                    <td><input type="text" id="END_DATE" name="END_DATE"
                                               style="width:160px;background:#fff!important;" onchange="checkDate()"
                                               class="date-picker" data-date-format="yyyy-mm-dd" placeholder="请输入年月日！"
                                               readonly="readonly"/></td>
                                </tr>
                                <tr>
                                    <!--
                                    <td>是否分解:</td>
                                    <td>
                                        <select name="ISEXPLAIN" id="ISEXPLAIN">
                                            <option value="2">已分解（已生效）</option>
                                            <option value="1">已分解（未生效）</option>
                                            <option value="0">未分解</option>
                                        </select>
                                    </td>
                                     -->
                                    <td><label>关键字:</label></td>
                                    <td><input name="KEY_WORD" id="KEY_WORD" type="text" placeholder="请输入项目编码或名称"></td>
                                </tr>

                            </table>
                            <div style="margin-right:30px;float: right;">
                                <a class="btn-style1" onclick="toSearch();" data-toggle="collapse"
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
        <div class="row-fluid ">
            <table id="target_grid" class="table table-striped table-bordered table-hover">
                <thead>
                <tr>
                    <th data-column-id="CODE" data-identifier="true" data-width="85px"
                        data-header-Css-Class="noLeftBorder"
                        data-css-Class="noLeftBorder" data-visible="false">编号
                    </th>
                    <th data-column-id="START_DATE">开始时间</th>
                    <th data-column-id="END_DATE">结束时间</th>
                    <th data-column-id="NAME" data-formatter="nameTitle">目标</th>
                    <th data-column-id="PRODUCT_NAME" data-formatter="productTitle">产品</th>
                    <th data-column-id="INDEX_NAME" data-formatter="indexTitle" data-width="80px">经营指标</th>
                    <th data-column-id="COUNT" data-width="105px" data-formatter="count">目标数量/金额</th>
                    <th data-column-id="DEPT_NAME" data-width="90px" data-formatter="deptTitle">承接部门</th>
                    <th data-column-id="EMP_NAME" data-width="65px">承接人</th>
                    <th data-column-id="STATUS_NAME" data-width="55px" data-formatter="statusName">状态</th>
                    <th data-column-id="ISEXPLAIN" data-width="115px" data-visible="false">是否分解</th>
                    <th align="center" data-align="center" data-width="110px" data-sortable="false"
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
<!-- 预加载js -->
<script type="text/javascript">
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
    $(function () {
        $("#target_grid").bootgrid({
            ajax: true,
            url: "byeartarget/targetList.do",
            navigation: 2,
            selection: true,
            multiSelect: true,
            formatters: {
                nameTitle: function (column, row) {
                    return '<span style="cursor:pointer;" title="' + row.NAME + '">' + row.NAME + '</span>';
                },
                count: function (column, row) {
                    return row.COUNT + ' ' + row.UNIT_NAME;
                },
                productTitle: function (column, row) {
                    if (row.PRODUCT_NAME == null) {
                        row.PRODUCT_NAME = '';
                    }
                    return '<span style="cursor:pointer;" title="' + row.PRODUCT_NAME + '">' + row.PRODUCT_NAME + '</span>';
                },
                indexTitle: function (column, row) {
                    if (row.INDEX_NAME == null) {
                        row.INDEX_NAME = '';
                    }
                    return '<span style="cursor:pointer;" title="' + row.INDEX_NAME + '">' + row.INDEX_NAME + '</span>';
                },
                deptTitle: function (column, row) {
                    return '<span style="cursor:pointer;" title="' + row.DEPT_NAME + '">' + row.DEPT_NAME + '</span>';
                },
                statusName: function (column, row) {
                    if (row.STATUS_NAME == '草稿') {
                        return '<span class="bg-danger">' + row.STATUS_NAME + '</span>';
                    } else if (row.STATUS_NAME == '已生效') {
                        return '<span class="bg-success">' + row.STATUS_NAME + '</span>';
                    }
                },
                btns: function (column, row) {
                    var value = row.STATUS;
                    var res = row.IS_YOURS;
                    var btnStr = '';
                    if (value == "YW_CG") {
                        if (res == "YOURS") {
                            btnStr += '<button title="编辑" onclick="edit(\'' + row.CODE + '\');" class="btn btn-mini btn-primary" >' +
                                '<i class="icon-edit"></i></button>' +
                                '<button style="margin-left:1px;" title="分解" onclick="explain(\'' + row.CODE + '\');" class="btn btn-mini btn-warning" >' +
                                '<i class="icon-exchange"></i></button>' +
                                '<button style="margin-left:1px;" title="下发" onclick="arrange(\'' + row.CODE + '\',\'' + row.COUNT + '\',\'' + row.COUNT_SUM + '\');" class="btn btn-mini btn-success" >' +
                                '<i class="icon-envelope"></i></button>';
                        }
                    } else if (value == "YW_YSX") {
                        if ("${fuzong}" == 1) {
                            btnStr += '<button title="修改目标数量" onclick="editCount(\'' + row.ID + '\',\'' + row.COUNT + '\');" class="btn btn-mini btn-danger" >' +
                                '<i class="icon-edit"></i></button>';
                        }
                        if (res == "YOURS") {
                            btnStr += '<button style="margin-left:1px;" title="分解" onclick="explain(\'' + row.CODE + '\');" class="btn btn-mini btn-warning" >' +
                                '<i class="icon-exchange"></i></button>' +
                                '<button style="margin-left:1px;" title="分解记录" onclick="history(\'' + row.ID + '\',\'' + row.CODE + '\');" class="btn btn-mini btn-info" >' +
                                '<i class="icon-book"></i></button>' +
                                '<button style="margin-left:1px;" title="撤回" onclick="withdraw(\'' + row.CODE + '\');" class="btn btn-mini btn-danger" >' +
                                '<i class="glyphicon glyphicon-step-backward"></i></button>';
                        } else {
                            btnStr += '<button style="margin-left:1px;" title="分解记录" onclick="history(\'' + row.ID + '\',\'' + row.CODE + '\');" class="btn btn-mini btn-info" >' +
                                '<i class="icon-book"></i></button>';

                        }
                    }
                    return btnStr;
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
        });//.bootgrid("search", {"ISEXPLAIN": $("#searchField").val()});//默认加载未分解目标
    });

    //分解目标
    function explain(CODE) {
        var PARENT_FRAME_ID = $(".tab_item2_selected", window.parent.document).parents('table').attr('id');
        top.mainFrame.tabAddHandler("explain1", "分解目标", "<%=basePath%>/byeartarget/goExplain.do?CODE=" + CODE + "&PARENT_FRAME_ID=" + PARENT_FRAME_ID);
    }

    //复选框
    $('table th input:checkbox').on('click', function () {
        var that = this;
        $(this).closest('table').find('tr > td:first-child input:checkbox')
            .each(function () {
                this.checked = that.checked;
                $(this).closest('tr').toggleClass('selected');
            });
    });
</script>

<script type="text/javascript">

    //检验时间是否正确
    function checkDate() {
        if (null != $("#END_DATE").val() && '' != $("#END_DATE").val() && null != $("#START_DATE").val() && '' != $("#START_DATE").val()) {
            var END_DATE = new Date($("#END_DATE").val().replace(/-/ig, '/'));
            var START_DATE = new Date($("#START_DATE").val().replace(/-/ig, '/'));
            if (START_DATE > END_DATE) {
                $("#START_DATE").tips({
                    side: 3,
                    msg: '请确保开始时间早于结束时间！',
                    bg: '#AE81FF',
                    time: 2
                });
                $("#START_DATE").focus();
                $("#START_DATE").val("");
                $("#searchButton").attr("disabled", "disabled");
                return false;
            } else {
                $("#searchButton").attr("disabled", false);
            }
        }
    }

</script>
<script type="text/javascript">

    //检索
    function toSearch() {
        var startDate = $("#START_DATE").val();
        var endDate = $("#END_DATE").val();
        var isExplain = $("#searchField").val();
        var keyWord = $("#KEY_WORD").val();
        $("#target_grid").bootgrid("search",
            {"START_DATE": startDate, "END_DATE": endDate, "ISEXPLAIN": isExplain, "KEY_WORD": keyWord});
    }

    //点击进行查询
    function clickSearch(value, ele) {
        $("#btnDiv button").removeClass("active");
        $(ele).addClass("active");
        $("#searchField").val(value);
        toSearch();
    }

    //清空查询条件
    function emptySearch() {
        $("#START_DATE").val("");
        $("#END_DATE").val("");
        //$("#ISEXPLAIN").val("");
        $("#KEY_WORD").val("");
    }

    //新增目标
    function add() {
        var diag = new top.Dialog();
        diag.Drag = true;
        diag.Title = "新增";
        diag.URL = '<%=basePath%>/byeartarget/goAdd.do';
        diag.Width = 550;
        diag.Height = 650;
        diag.CancelEvent = function () {
            //关闭事件
            diag.close();
            location.replace('<%=basePath%>/byeartarget/list.do');
        };
        diag.show();
    }

    //修改目标数量
    function editCount(ID, COUNT) {
        var diag = new top.Dialog();
        diag.Drag = true;
        diag.Title = "修改目标数量";
        diag.URL = '<%=basePath%>/byeartarget/goEditCount.do?ID=' + ID + '&COUNT=' + COUNT;
        diag.Width = 450;
        diag.Height = 180;
        diag.CancelEvent = function () {
            //关闭事件
            diag.close();
            location.replace('<%=basePath%>/byeartarget/list.do');
        };
        diag.show();
    }

    //修改目标
    function edit(CODE) {
        var diag = new top.Dialog();
        diag.Drag = true;
        diag.Title = "修改";
        diag.URL = '<%=basePath%>/byeartarget/goEdit.do?CODE=' + CODE;
        diag.Width = 550;
        diag.Height = 650;
        diag.CancelEvent = function () {
            //关闭事件
            diag.close();
            location.replace('<%=basePath%>/byeartarget/list.do');
        };
        diag.show();
    }


    //分解历史
    function history(ID, CODE) {
        var PARENT_FRAME_ID = $(".tab_item2_selected", window.parent.document).parents('table').attr('id');
        top.mainFrame.tabAddHandler("history1", "分解历史", "<%=basePath%>/byeartarget/goHistory.do?CODE=" + CODE + "&PARENT_FRAME_ID=" + PARENT_FRAME_ID + "&TARGET_ID=" + ID);
    }

    //下发
    function arrange(CODE, COUNT, MONTH_COUNT_SUM) {
        if (Number(MONTH_COUNT_SUM) < Number(COUNT)) {
            top.Dialog.alert('您现有的拆分不能满足目标，请重新确认！');
            return false;
        } else {
            bootbox.confirm("下发后将不能修改，仍要这么做吗?", function (result) {
                if (result) {
                    var url = "byeartarget/arrange.do?timeStamp=" + new Date().getTime();
                    $.get(
                        url,
                        {CODE: CODE},
                        function (data) {
                            if (data == "success") {
                                top.Dialog.alert("启用成功！");
                                location.replace('<%=basePath%>/byeartarget/list.do');
                            }
                        },
                        "text"
                    );
                }
            });
        }
    }

    //批量删除目标
    function del() {
        var objList = $("#target_grid").bootgrid("getSelectedRows");
        for (var i = 0; i < objList.length; i++) {
            var obj = objList[i];
            if ($(obj).attr("status") == 'YW_YSX') {
                top.Dialog.alert("所勾选的项中有已生效的目标，不能删除");
                return;
            }
        }
        if (objList == null || objList.length == 0) {
            top.Dialog.alert("您没有勾选任何内容，不能删除");
            $("#zcheckbox").tips({
                side: 3,
                msg: '点这里全选',
                bg: '#AE81FF',
                time: 8
            });

            return;
        } else {
            bootbox.confirm("确定要批量删除吗?", function (result) {
                if (result) {
                    var url = "byeartarget/del.do?timeStamp=" + new Date().getTime();
                    $.get(
                        url,
                        {ids: objList},
                        function (data) {
                            if (data == "success") {
                                top.Dialog.alert("删除成功！");
                                $("#target_grid").bootgrid("reload");
                            } else if (data == "false") {
                                top.Dialog.alert("删除失败！");
                                $("#target_grid").bootgrid("reload");
                            }
                        },
                        "text"
                    );
                }
            });
        }
    }

    //撤回
    function withdraw(code) {
        top.Dialog.confirm("撤回后将删除其分解条目，确定要撤回吗？", function () {
            $.ajax({
                url: "byeartarget/withdraw.do",
                type: "post",
                data: {"code": code},
                success: function (data) {
                    if (data = "success") {
                        top.Dialog.alert("撤回成功！");
                        $("#target_grid").bootgrid("reload");
                    } else {
                        top.Dialog.alert("撤回失败！");
                    }
                }
            });
        });
    }
</script>
<!-- 按钮功能 -->

</body>
</html>
