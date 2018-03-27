<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="shiro" uri="http://shiro.apache.org/tags" %>
<%
    String path = request.getContextPath();
    String basePath = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort() + path + "/";
%>
<!DOCTYPE html>
<html>
<head>
    <title>部门年度经营目标列表</title>
    <base href="<%=basePath%>">
    <!-- jsp文件头和头部 -->
    <link type="text/css" rel="StyleSheet" href="plugins/Bootstrap/css/bootstrap.min.css"/>
    <link type="text/css" rel="StyleSheet" href="plugins/Bootgrid/jquery.bootgrid.min.css"/>
    <link type="text/css" rel="StyleSheet" href="static/css/dtree.css"/>
    <link type="text/css" rel="StyleSheet" href="static/css/style.css"/>
    <link rel="stylesheet" href="static/css/font-awesome.min.css"/>
    <link rel="stylesheet" href="static/css/bootgrid.change.css"/>
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

        .modal {
            width: 600px;
            height: 100%;
            background: none;
        }

        .checkbox-inline + .checkbox-inline, .radio-inline + .radio-inline {
            margin-left: 0px;
        }
    </style>
</head>
<body>
<div class="container-fluid" id="main-container">
    <div id="page-content" class="clearfix">
        <div class="breadcrumbs" id="breadcrumbs">
            &nbsp; &nbsp; <span style="margin-left:20px; float:left; font-size:15px">部门年度经营目标</span>
            <div id="btnDiv" style="float:left; margin-left:150px;">
                <input id="searchField" type="hidden" value="0"/>
                <button class="btn btn-small btn-danger" onclick="clickSearch(0, this);">待分解</button>
                <button class="btn btn-small btn-warning " onclick="clickSearch(1, this);">待下发</button>
                <button class="btn btn-small btn-success" onclick="clickSearch(2, this);">已下发</button>
                <button class="btn btn-small btn-info active" onclick="clickSearch(-1, this);">全部</button>
            </div>
            <div style="position:absolute; top:5px; right:25px;">
                <div>
                    <shiro:hasPermission name="ndjyrw(bm):loadOtherDeptTarget()">
                        <a id="showDeptTask" class="btn btn-small btn-info"
                           style="margin-right:5px; float:left; text-decoration:none;"
                           onclick="loadOtherDeptTarget()">管理其它部门年度目标</a>
                    </shiro:hasPermission>
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
                                    <td>关键字:</td>
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
        <!-- <div class="nav-search" id="nav-search" style="right:5px;margin-top: 20px;" class="form-search">
            <div class="panel panel-default" style="float:left;position: absolute;z-index: 1000;">
                <div>
                    <a data-toggle="collapse" data-parent="#accordion" href="#collapseTwo" class="btn btn-small btn-primary" style="float:left;text-decoration:none;">高级搜索 </a>
                </div>
                <div id="collapseTwo" class="panel-collapse collapse" style="position:absolute; top:32px; z-index:999">
                    <div class="panel-body">
                        <form id="searchForm">
                            <table>
                            <tr>
                                    <td><label>开始时间：</label></td>
                                    <td><input type="text" id="START_DATE" name="START_DATE" style="width:160px;background:#fff!important;" onchange="checkDate()"
                                                                class="date-picker" data-date-format="yyyy-mm-dd" placeholder="请输入年月日！" readonly="readonly"/></td>
                                    <td><label>结束时间：</label></td>
                                    <td><input type="text" id="END_DATE" name="END_DATE" style="width:160px;background:#fff!important;" onchange="checkDate()"
                                                                class="date-picker" data-date-format="yyyy-mm-dd" placeholder="请输入年月日！" readonly="readonly"/></td>
                            </tr>
                            <tr>
                                    <td>是否分解:</td>
                                    <td>
                                        <select name="ISEXPLAIN" id="ISEXPLAIN">
                                            <option value="2">已分解（已生效）</option>
                                            <option value="1">已分解（未生效）</option>
                                            <option value="0">未分解</option>
                                        </select>
                                    </td>
                                    <td>关键字:</td>
                                    <td><input name="KEY_WORD" id="KEY_WORD" type="text" placeholder="请输入项目编码或名称"></td>
                            </tr>

                            </table>
                            <div style="margin-right:30px;float: right;">
                                <a class="btn-style1" onclick="toSearch();" data-toggle="collapse" data-parent="#accordion" href="#collapseTwo" style="cursor: pointer;">查询</a>
                                <a class="btn-style2" onclick="emptySearch()" style="cursor: pointer;">重置</a>
                                <a data-toggle="collapse" data-parent="#accordion" class="btn-style3" href="#collapseTwo">关闭</a>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        </div> -->
        <div class="row-fluid">
            <!-- 模态框（Modal） -->
            <div class="modal" id="myModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel"
                 aria-hidden="true">
                <div class="modal-dialog">
                    <div class="modal-content">
                        <div class="modal-header">
                            <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                            <h4 class="modal-title" id="myModalLabel">指定负责人</h4>
                        </div>
                        <div class="modal-body">
                        </div>
                        <input id="explainTaskId" type="hidden" value=""/>
                        <div class="modal-footer">
                            <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
                            <button type="button" class="btn btn-primary" data-dismiss="modal" onclick="submitModal()">
                                提交
                            </button>
                        </div>
                    </div><!-- /.modal-content -->
                </div><!-- /.modal-dialog -->
            </div><!-- modal -->

            <table id="dept_grid" class="table table-striped table-bordered table-hover">
                <thead>
                <tr>
                    <th data-column-id="B_YEAR_TARGET_CODE" data-width="90px" data-visible="false">编号</th>
                    <th data-column-id="START_DATE">开始时间</th>
                    <th data-column-id="END_DATE">结束时间</th>
                    <th data-column-id="NAME" data-formatter="nameTitle">目标</th>
                    <th data-column-id="PRODUCT_NAME" data-formatter="productTitle">产品</th>
                    <th data-column-id="INDEX_NAME" data-width="80px" data-formatter="indexTitle">经营指标</th>
                    <th data-column-id="COUNT" data-width="105px" data-formatter="count">目标数量/金额</th>
                    <!--
                    <th data-column-id="UNIT_NAME" data-width="55px" data-visible="false">单位</th>
                     -->
                    <th data-column-id="DEPT_NAME" data-width="90px" data-formatter="deptTitle">承接部门</th>
                    <th data-column-id="EMP_NAME" data-width="65px">承接人</th>
                    <th data-column-id="ISEXPLAIN" data-width="60px" data-formatter="statusName">状态</th>
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
<!-- 行为js -->
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
<!-- 行为js -->

<!-- 按钮功能 -->
<script type="text/javascript">

    //检索
    function toSearch() {
        var startDate = $("#START_DATE").val();
        var endDate = $("#END_DATE").val();
        var isExplain = $("#searchField").val();
        var keyWord = $("#KEY_WORD").val();
        $("#dept_grid").bootgrid("search",
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

    //分解目标
    function explain(ID) {
        var PARENT_FRAME_ID = $(".tab_item2_selected", window.parent.document).parents('table').attr('id');
        top.mainFrame.tabAddHandler("explain2", "分解目标", "<%=basePath%>/byeardepttask/goExplain.do?ID=" + ID + "&PARENT_FRAME_ID=" + PARENT_FRAME_ID);
    }

    //分解历史
    function history(ID) {
        var PARENT_FRAME_ID = $(".tab_item2_selected", window.parent.document).parents('table').attr('id');
        top.mainFrame.tabAddHandler("history2", "分解历史", "<%=basePath%>/byeardepttask/goHistory.do?ID=" + ID + "&PARENT_FRAME_ID=" + PARENT_FRAME_ID);
    }

    //下发
    function arrange(ID, COUNT, COUNT_SUM) {
        if (Number(COUNT_SUM) < Number(COUNT)) {
            top.Dialog.alert('您现有的拆分不能满足目标，请重新确认！');
            return false;
        } else {
            top.Dialog.confirm("确认要下发吗？", function () {
                var url = "byeardepttask/arrange.do?timeStamp=" + new Date().getTime();
                $.get(
                    url,
                    {ID: ID},
                    function (data) {
                        if (data == "success") {
                            top.Dialog.alert("启用成功！");
                            location.replace('<%=basePath%>/byeardepttask/list.do');
                        }
                    },
                    "text"
                );
            });
        }
    }
</script>

<!-- 预加载js -->
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
        loadOtherDeptTarget();
    });

    //撤回
    function withdraw(id) {
        top.Dialog.confirm("撤回后将删除其分解条目，确定要撤回吗？", function () {
            $.ajax({
                url: "byeardepttask/withdraw.do",
                type: "post",
                data: {"id": id},
                success: function (data) {
                    if (data = "success") {
                        top.Dialog.alert("撤回成功！");
                        $("#dept_grid").bootgrid("reload");
                    } else {
                        top.Dialog.alert("撤回失败！");
                    }
                }
            });
        });
    }

    //显示模态框
    function showModal(deptId, explainEmpCode, taskId) {
        $.ajax({
            url: '<%=basePath%>employee/findEmpByDept.do?deptId=' + deptId,
            type: 'post',
            success: function (data) {
                var empList = eval('(' + data + ')');
                var empStr = '';
                $.each(empList.list, function (i, emp) {
                    empStr += '<label class="checkbox-inline"><input type="radio" name="empRadio" value="' + emp.EMP_CODE + '"';
                    if (explainEmpCode == emp.EMP_CODE) {
                        empStr += ' checked="checked" '
                    }
                    empStr += ' >' + emp.EMP_NAME + '</label>';
                });
                $("#explainTaskId").val(taskId);
                $(".modal-body").empty();
                $(".modal-body").append(empStr);
            }
        });
        $("#myModal").modal();
    }

    //提交模态框
    function submitModal() {
        var explainEmpCode = $('.modal-body input[name="empRadio"]:checked').val();
        var explainTaskId = $("#explainTaskId").val();
        top.Dialog.confirm("确定提交？", function () {
            $.ajax({
                url: '<%=basePath%>byeardepttask/updateExplainEmp.do',
                data: {explainEmpCode: explainEmpCode, id: explainTaskId},
                type: 'post',
                success: function (data) {
                    if (data == 'success') {
                        top.Dialog.alert("提交成功！");
                        $("#dept_grid").bootgrid("reload");
                    } else {
                        top.Dialog.alert("提交出错！");
                    }
                }
            });
        });
    }

    var showOtherDept = 1;

    //加载部门的年度目标
    function loadOtherDeptTarget() {
        var loadUrl = "";
        if (showOtherDept == 0) {//加载其它部门目标
            loadUrl = "byeardepttask/taskList.do?showOtherDept=1"
            $("#showDeptTask").text('管理本部门年度目标');
            showOtherDept = 1;
        } else {//加载本部门目标
            loadUrl = "byeardepttask/taskList.do?showOtherDept=0";
            $("#showDeptTask").text('管理其它部门年度目标');
            showOtherDept = 0;
        }
        $("#dept_grid").bootgrid("destroy");
        $("#dept_grid").bootgrid({
            ajax: true,
            url: loadUrl,
            navigation: 2,
            formatters: {
                nameTitle: function (column, row) {
                    return '<span style="cursor:pointer;" title="' + row.NAME + '">' + row.NAME + '</span>';
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
                count: function (column, row) {
                    return row.COUNT + ' ' + row.UNIT_NAME;
                },
                statusName: function (column, row) {
                    if (row.ISEXPLAIN == "已分解（未生效）") {
                        return '<span class="bg-warning">待下发</span>';
                    } else if (row.ISEXPLAIN == "已分解（已生效）") {
                        return '<span class="bg-success">已下发</span>';
                    } else {
                        return '<span class="bg-danger">待分解</span>';
                    }
                },
                btns: function (column, row) {
                    var res = row.IS_YOURS;
                    var str = "";
                    if (res == "YOURS" || showOtherDept == 1) {//自己的目标或者显示了自己创建的其它部门的目标
                        str += '<button title="指定负责人" onclick="showModal(' + row.DEPT_ID + ', \'' + row.EXPLAIN_EMP_CODE + '\', ' + row.ID + ');"' +
                            ' class="btn btn-mini btn-primary"><i class="icon-edit"></i></button>' +
                            '<button style="margin-left:1px;" title="分解" onclick="explain(\'' + row.ID + '\');" class="btn btn-mini btn-warning">' +
                            '<i class="icon-exchange"></i></button>';
                        if (row.ISEXPLAIN == "已分解（未生效）") {
                            str += '<button style="margin-left:1px;" title="下发" onclick="arrange(\'' + row.ID + '\',\'' + row.COUNT + '\',\'' + row.MONTH_COUNT_SUM + '\');" class="btn btn-mini btn-success" >' +
                                '<i class="icon-envelope"></i></button>';
                        } else if (row.ISEXPLAIN == "已分解（已生效）") {
                            str += '<button style="margin-left:1px;" title="分解记录" onclick="history(\'' + row.ID + '\');" class="btn btn-mini btn-info" >' +
                                '<i class="icon-book"></i></button>';
                            str += '<button style="margin-left:1px;" title="撤回" onclick="withdraw(\'' + row.ID + '\');" class="btn btn-mini btn-danger" >' +
                                '<i class="glyphicon glyphicon-step-backward"></i></button>';
                        }
                    } else if (row.EXPLAIN_EMP_CODE == '${currentEmpCode}') {//指定负责人的目标
                        str += '<button style="margin-left:1px;" title="分解" onclick="explain(\'' + row.ID + '\');" class="btn btn-mini btn-warning">' +
                            '<i class="icon-exchange"></i></button>';
                        if (row.ISEXPLAIN == "已分解（未生效）") {
                            str += '<button style="margin-left:1px;" title="下发" onclick="arrange(\'' + row.ID + '\',\'' + row.COUNT + '\',\'' + row.MONTH_COUNT_SUM + '\');" class="btn btn-mini btn-success" >' +
                                '<i class="icon-envelope"></i></button>';
                        } else if (row.ISEXPLAIN == "已分解（已生效）") {
                            str += '<button style="margin-left:1px;" title="分解记录" onclick="history(\'' + row.ID + '\');" class="btn btn-mini btn-info" >' +
                                '<i class="icon-book"></i></button>';
                        }
                    } else {//其他人只能查看
                        str += '<button style="margin-left:1px;" title="分解记录" onclick="history(\'' + row.ID + '\');" class="btn btn-mini btn-info" >' +
                            '<i class="icon-book"></i></button>';
                    }

                    return str;
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
        });//.bootgrid("search", {"ISEXPLAIN": $("#searchField").val()});//默认加载未分解目标;
    }
</script>
<!-- 预加载js -->
</body>


</html>
