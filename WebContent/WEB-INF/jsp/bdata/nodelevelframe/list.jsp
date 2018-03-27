<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
    String path = request.getContextPath();
    String basePath = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort() + path + "/";
%>
<!DOCTYPE html>
<html lang="zh_CN">
<head>
    <base href="<%=basePath%>">
    <!-- jsp文件头和头部 -->
    <link type="text/css" rel="StyleSheet" href="plugins/Bootstrap/css/bootstrap.min.css"/>
    <link href="static/css/style.css" rel="stylesheet"/>
    <link type="text/css" rel="StyleSheet" href="plugins/Bootgrid/jquery.bootgrid.min.css"/>
    <link rel="stylesheet" href="static/css/bootgrid.change.css"/>
    <link rel="stylesheet" href="static/css/font-awesome.min.css"/>
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
    </style>

</head>
<body>
<div class="container-fluid" id="main-container">
    <div id="page-content" class="clearfix">
        <div class="breadcrumbs" id="breadcrumbs">
            &nbsp; &nbsp; 节点层级结构
            <div style="position:absolute; top:5px; right:25px;">
                <div>
                    <a class="btn btn-small btn-info" onclick="add();" style="margin-right:5px;float:left;">新增</a>
                    <a data-toggle="collapse" data-parent="#accordion"
                       href="#collapseTwo" class="btn btn-small btn-primary"
                       style="float:left;text-decoration:none;">
                        高级搜索 </a>
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
                                <td><label>关键字：</label></td>
                                <td>
                                    <input autocomplete="off" type="text" name="keyword" id="keyword"
                                           value="${pd.keyword}" placeholder="节点层级结构、描述"
                                           title="可用于查询  节点层级结构、描述"/>
                                </td>
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
        <div class="row-fluid">
            <div class="row-fluid">
                <form action="nodeLevelFrame/list.do" method="post" name="Form" id="Form">
                    <%-- <div class="nav-search" id="nav-search" style="right:5px;margin-top: 20px;" class="form-search">
                        <div class="panel panel-default" style="float:left;position: absolute;z-index: 1000;">
                            <div>
                                <a class="btn btn-small btn-info" onclick="add();" style="margin-right:5px;float:left;">新增</a>

                                <a data-toggle="collapse" data-parent="#accordion"
                                    href="#collapseTwo" class="btn btn-small btn-primary"
                                    style="float:left;text-decoration:none;">
                                    高级搜索 </a>
                            </div>
                            <div id="collapseTwo" class="panel-collapse collapse"
                                style="position:absolute; top:32px; z-index:999">
                                <div class="panel-body">
                                    <table>
                                        <tr>
                                            <td><label>关键字：</label></td>
                                            <td>
                                            <input autocomplete="off" type="text" name="keyword" id="keyword" value="${pd.keyword}" placeholder="节点层级结构、描述"
                                                title="可用于查询  节点层级结构、描述"	/>
                                            </td>
                                        </tr>
                                    </table>
                                    <div style="margin-top:15px; margin-right:30px; text-align:right;">
                                        <a class="btn-style1" onclick="search2();" data-toggle="collapse" data-parent="#accordion" href="#collapseTwo"
                                            style="cursor: pointer;">查询</a> <a class="btn-style2"
                                            onclick="resetting()" style="cursor: pointer;">重置</a>
                                        <a data-toggle="collapse" data-parent="#accordion"
                                            class="btn-style3" href="#collapseTwo">关闭</a>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div> --%>
                </form>

                <table id="employee_grid" class="table table-striped table-bordered table-hover">
                    <thead>
                    <tr>
                        <th data-column-id="LEVEL_FRAME" data-order="asc">节点层级结构</th>
                        <th data-column-id="DESCP">描述</th>
                        <th align="center" data-align="center" data-sortable="false" data-formatter="btns">操作</th>
                    </tr>
                    </thead>
                </table>

            </div>
        </div>
    </div>
</div>
<style type="text/css">
    li {
        list-style-type: none;
    }
</style>
<ul class="navigationTabs">
    <li><a></a></li>
    <li></li>
</ul>
<script type="text/javascript" src="plugins/JQuery/jquery.min.js"></script>
<script type="text/javascript" src="plugins/Bootstrap/js/bootstrap.min.js"></script>
<script src="static/js/ace-elements.min.js"></script>
<script src="static/js/ace.min.js"></script>
<script type="text/javascript" src="plugins/Bootgrid/jquery.bootgrid.min.js"></script>
<script type="text/javascript">
    $(function () {
        $("#employee_grid").bootgrid({
            ajax: true,
            url: "nodeLevelFrame/empList.do",
            navigation: 2,
            formatters: {
                /* gender: function(column, row){
                    var value = row.EMP_GENDER;
                    if(value== "1"){
                        return "男";
                    }else if(value == "2"){
                        return "女";
                    }else{
                        return "";
                    }
                }, */
                btns: function (column, row) {
                    return '<a style="cursor:pointer;margin:1px;" title="编辑" onclick="edit(' + row.ID + ');" class="btn btn-mini btn-purple" data-rel="tooltip" data-placement="left">' +
                        '<i class="icon-edit"></i></a>' +
                        '<a style="cursor:pointer;margin:1px;" title="删除" onclick="del(' + row.ID + ');" class="btn btn-mini btn-purple" data-rel="tooltip"  data-placement="left">' +
                        '<i class="icon-trash"></i></a>' +
                        '<a style="cursor:pointer;margin:1px;" title="配置层级" onclick="editLevels(' + row.ID + ');" class="btn btn-mini btn-purple" data-rel="tooltip"  data-placement="left">' +
                        '<i class="icon-pencil"></i></a>';
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

    $(top.changeui());

    function resetting() {
        $("#keyword").val("");
    }

    //检索
    function search2() {
        var keyword = $("#keyword").val();

        $("#employee_grid").bootgrid("search",
            {"KEYW": keyword});
    }

    //新增
    function add() {
        top.jzts();
        var diag = new top.Dialog();
        diag.Drag = true;
        diag.Title = "新增";
        diag.URL = '<%=basePath%>/nodeLevelFrame/toAdd.do';
        diag.Width = 400;
        diag.Height = 150;
        diag.CancelEvent = function () { //关闭事件
            if ('${page.currentPage}' == '0') {
                top.jzts();
                setTimeout("self.location=self.location", 100);
            } else {
                $("#employee_grid").bootgrid("reload");
            }
            diag.close();
        };
        diag.show();
    }

    //删除
    function del(id) {

        if (confirm("确定要删除?")) {
            top.jzts();
            var url = "<%=basePath%>/nodeLevelFrame/delete.do?id=" + id;
            $.get(url, function (data) {
                if (data == "success") {
                    $("#employee_grid").bootgrid("reload");
                } else if (data == "fail") {
                    alert("岗位已分配到员工，不可删除");
                } else if (data == "error") {
                    alert("删除出错");
                }
            }, "text");
        }
    }

    //修改
    function edit(id) {
        top.jzts();
        var diag = new top.Dialog();
        diag.Drag = true;
        diag.Title = "编辑";
        diag.URL = '<%=basePath%>/nodeLevelFrame/goEdit.do?id=' + id;
        diag.Width = 400;
        diag.Height = 150;
        diag.CancelEvent = function () { //关闭事件
            if (diag.innerFrame.contentWindow.document.getElementById('zhongxin').style.display == 'none') {
                $("#employee_grid").bootgrid("reload");
            }
            diag.close();
        };
        diag.show();
    }

    //修改
    function editLevels(id) {
        top.jzts();
        var diag = new top.Dialog();
        diag.Drag = true;
        diag.Title = "编辑";
        diag.URL = '<%=basePath%>/nodeLevelFrame/goEditLevels.do?id=' + id;
        diag.Width = 400;
        diag.Height = 350;
        diag.CancelEvent = function () { //关闭事件
            if (diag.innerFrame.contentWindow.document.getElementById('zhongxin').style.display == 'none') {
                $("#employee_grid").bootgrid("reload");
            }
            diag.close();
        };
        diag.show();
    }
</script>
</body>
</html>
