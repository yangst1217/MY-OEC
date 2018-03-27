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
    <!-- jsp文件头和头部 -->
    <link type="text/css" rel="StyleSheet" href="plugins/Bootstrap/css/bootstrap.min.css"/>
    <link type="text/css" rel="StyleSheet" href="plugins/Bootgrid/jquery.bootgrid.min.css"/>
    <link href="static/css/style.css" rel="stylesheet"/>
    <link rel="stylesheet" href="static/css/font-awesome.min.css"/>
    <link rel="stylesheet" href="static/css/bootgrid.change.css"/>
    <link rel="stylesheet" href="static/css/datepicker.css">

</head>
<body>
<div class="container-fluid" id="main-container">


    <div id="page-content" class="clearfix">

        <div class="row-fluid">

            <div class="row-fluid">

                <!-- 检索  -->
                <form action="positionLevel/list.do" method="post" name="Form" id="Form">
                    <div class="nav-search" id="nav-search" style="right:5px;margin-top: 20px;" class="form-search">
                        <div class="panel panel-default" style="float:left;position: absolute;z-index: 1000;">
                            <div>
                                <a class="btn btn-small btn-info" onclick="add();" style="margin-right:5px;float:left;">发起新流程</a>
                                <div id="change" style="margin-right:5px;float:left;">
                                    <a class="btn btn-small btn-info" onclick="changeSearch(1);" style="float:left;">关注人查询</a>
                                </div>
                                <a data-toggle="collapse" data-parent="#accordion"
                                   href="#collapseTwo" class="btn btn-small btn-primary"
                                   style="float:left;text-decoration:none;">
                                    高级搜索 </a>
                            </div>
                            <div id="collapseTwo" class="panel-collapse collapse"
                                 style="position:absolute;  top:32px; z-index:999">
                                <div class="panel-body">
                                    <table>
                                        <tr>
                                            <td><label>流程编号：</label></td>
                                            <td>
                                                <input autocomplete="off" type="text" id="FLOW_CODE" name="FLOW_CODE"
                                                       value="" placeholder="流程编号"
                                                       title="流程编号"/>
                                            </td>
                                            <td><label>流程名称：</label></td>
                                            <td>
                                                <input autocomplete="off" type="text" id="FLOW_NAME" name="FLOW_NAME"
                                                       value="" placeholder="流程名称"
                                                       title="流程名称"/>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td><label>发起人：</label></td>
                                            <td>
                                                <input autocomplete="off" type="text" id="NAME" name="NAME" value=""
                                                       placeholder="发起人"
                                                       title="发起人"/>
                                            </td>
                                            <td><label>发起时间：</label></td>
                                            <td>
                                                <input type="text" id="CREATE_TIME" name="CREATE_TIME"
                                                       style="background:#fff!important;"
                                                       class="date-picker" data-date-format="yyyy-mm-dd"
                                                       placeholder="请选择年月日！" readonly="readonly"/>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td><label>流程模板名称：</label></td>
                                            <td>
                                                <input autocomplete="off" type="text" id="FLOW_MODEL_NAME"
                                                       name="FLOW_MODEL_NAME" value="" placeholder="流程模板名称名称"
                                                       title="流程模板名称"/>
                                            </td>
                                        </tr>
                                    </table>
                                    <div
                                            style="margin-top:15px; margin-right:30px; text-align:right;">
                                        <a class="btn-style1" onclick="searchInfo();" data-toggle="collapse"
                                           data-parent="#accordion" href="#collapseTwo" style="cursor: pointer;">查询</a>
                                        <a class="btn-style2" onclick="resetting()" style="cursor: pointer;">重置</a>
                                        <a data-toggle="collapse" data-parent="#accordion" class="btn-style3"
                                           href="#collapseTwo">关闭</a>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    <!-- 检索  -->


                    <table id="flowWork_grid" class="table table-striped table-bordered table-hover">
                        <thead>
                        <tr>
                            <th data-column-id="FLOW_CODE" data-identifier="true" data-width="150px">流程编号</th>
                            <th data-column-id="FLOW_NAME" data-formatter="nameFormatter">流程名称</th>
                            <th data-column-id="MODEL_NAME">流程模板</th>
                            <th data-column-id="PARENT_NODE" data-visible="false">父流程节点</th>
                            <th data-column-id="NODE_NAME" data-visible="false">父流程节点名称</th>
                            <th data-column-id="NAME" data-width="80px">发起人</th>
                            <th data-column-id="CREATE_TIME" data-formatter="dateFormat" data-width="150px">发起时间</th>
                            <th data-column-id="REMARKS" data-width="150px">备注</th>
                            <!-- <th align="center" data-align="center" data-sortable="false" data-formatter="btns">操作</th> -->
                        </tr>
                        </thead>
                    </table>
                    <input type="hidden" id="searchId" value="2"/>
                </form>
            </div>


            <!-- PAGE CONTENT ENDS HERE -->
        </div><!--/row-->

    </div><!--/#page-content-->
</div><!--/.fluid-container#main-container-->

<!-- 引入 -->
<script type="text/javascript" src="plugins/JQuery/jquery.min.js"></script>
<script type="text/javascript" src="plugins/Bootstrap/js/bootstrap.min.js"></script>
<script src="static/js/ace-elements.min.js"></script>
<script src="static/js/ace.min.js"></script>
<script src="static/js/jquery-1.7.2.js"></script>
<script type="text/javascript" src="static/js/chosen.jquery.min.js"></script><!-- 下拉框 -->
<script type="text/javascript" src="static/js/bootstrap-datepicker.min.js"></script><!-- 日期框 -->
<script type="text/javascript" src="plugins/Bootgrid/jquery.bootgrid.min.js"></script>
<!-- 引入 -->

<script type="text/javascript">
    //日期框
    $(function () {
        if ("${success}" == "success") {
            top.Dialog.alert("保存成功！");
        }

        $('#CREATE_TIME').datepicker({
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

    $(function () {
        $("#flowWork_grid").bootgrid({
            ajax: true,
            url: "flowWork/flowWorkList.do",
            formatters: {
                dateFormat: function (column, row) {
                    var time = row.CREATE_TIME;

                    var format = function (time, format) {

                        var t = new Date(time);
                        var tf = function (i) {
                            return (i < 10 ? '0' : '') + i;
                        };
                        return format.replace(/yyyy|MM|dd|HH|mm|ss/g, function (a) {
                            switch (a) {
                                case 'yyyy':
                                    return tf(t.getFullYear());
                                    break;
                                case 'MM':
                                    return tf(t.getMonth() + 1);
                                    break;
                                case 'mm':
                                    return tf(t.getMinutes());
                                    break;
                                case 'dd':
                                    return tf(t.getDate());
                                    break;
                                case 'HH':
                                    return tf(t.getHours());
                                    break;
                                case 'ss':
                                    return tf(t.getSeconds());
                                    break;
                            }
                        });
                    };
                    return format(time, 'yyyy-MM-dd HH:mm:ss');

                },
                nameFormatter: function (column, row) {
                    return "<a href='javascript:void(0);' onclick='shwoFlowDetail(" + row.ID + ")' title='" + row.FLOW_NAME + "'>" + row.FLOW_NAME + "</a>";
                }
            }
        });

    });

    function shwoFlowDetail(id) {
        top.jzts();
        var diag = new top.Dialog();
        diag.Drag = true;
        diag.Title = "流程明细";
        diag.URL = '<%=basePath%>flowWork/showDetail.do?ID=' + id;
        diag.Width = 1000;
        diag.Height = 700;
        diag.show();
    }

    //检索
    function searchInfo() {
        var FLOW_CODE = $("#FLOW_CODE").val();
        var NAME = encodeURI($("#NAME").val());
        var FLOW_MODEL_NAME = encodeURI($("#FLOW_MODEL_NAME").val());
        var CREATE_TIME = $("#CREATE_TIME").val();
        var FLOW_NAME = encodeURI($("#FLOW_NAME").val());
        var flg = $("#searchId").val();

        $("#flowWork_grid").bootgrid("search",
            {
                "FLOW_CODE": FLOW_CODE,
                "NAME": NAME,
                "CREATE_TIME": CREATE_TIME,
                "FLOW_NAME": FLOW_NAME,
                "FLOW_MODEL_NAME": FLOW_MODEL_NAME,
                "flg": flg
            });
    }

    //切换
    function changeSearch(flg) {
        $("#flowWork_grid").bootgrid("search",
            {"flg": flg});
        if (flg == 1) {
            var button = '<a class="btn btn-small btn-info" onclick="changeSearch(2);" style="float:left;">创建人查询</a>'
            $("#searchId").val(flg);
        } else {
            var button = '<a class="btn btn-small btn-info" onclick="changeSearch(1);" style="float:left;">关注人查询</a>'
            $("#searchId").val(flg);
        }

        $("#change").html(button);
    }

    //新增
    function add() {
        window.location.href = "<%=basePath%>flowWork/toAdd.do";
    }


</script>

<script type="text/javascript">

    //重置
    function resetting() {
        $("#Form")[0].reset();
    }
</script>

<style type="text/css">
    li {
        list-style-type: none;
    }
</style>
<ul class="navigationTabs">
    <li><a></a></li>
    <li></li>
</ul>
</body>
</html>
