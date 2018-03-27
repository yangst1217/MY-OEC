<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="shiro" uri="http://shiro.apache.org/tags" %>
<%
    String path = request.getContextPath();
    String basePath = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort() + path + "/";
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <base href="<%=basePath%>">
    <!-- jsp文件头和头部 -->
    <%@ include file="../../system/admin/top.jsp" %>

    <!--树状图插件 -->
    <link rel="StyleSheet" href="static/css/dtree.css" type="text/css"/>
    <script type="text/javascript" src="static/js/dtree.js"></script>
    <!--树状图插件 -->
    <link rel="StyleSheet" href="static/css/style.css" type="text/css"/>
    <script>
        $(function () {
            var browser_height = $(document).height();
            $("div.main-container-left").css("min-height", browser_height);
            $(window).resize(function () {
                var browser_height = $(window).height();
                $("div.main-container-left").css("min-height", browser_height);
            });
        });
    </script>

    <script>
        $(function () {
            $(".m-c-l_show").click(function () {
                $(".main-container-left").toggle();
                $(".main-container-left").toggleClass("m-c-l_width");
                $(".m-c-l_show").toggleClass("m-c-l_hide");
            });
        });
    </script>
    <script>
        $(function () {

            $(".m-c-l_show").click(function () {
                var div_width = $(".main-container-left").width();
                $("div.main-content").css("margin-left", div_width + 2);
            });
        });
    </script>
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
    </style>
</head>
<body>
<div class="container-fluid" id="main-container">
    <div id="page-content" class="clearfix">
        <div class="row-fluid">

            <div class="main-container-left">
                <div class="m-c-l-top">
                    <img src="static/images/ui1.png" style="margin-top:-5px;">KPI指标分类
                    <!-- <a class="btn btn-mini btn-primary" onclick="fromExcel();" title="从EXCEL导入" style="margin-left:90px;">导入</a> -->
                </div>
                <form action="kpiCategoryFiles/list.do" method="post" name="Form" id="Form">
                    <div class="left">
                        <script type="text/javascript">
                            varList = new dTree('varList', 'static/img', 'treeForm');
                            varList.config.useIcons = true;
                            varList.add(0, -1, 'KPI类别维护', 'kpiCategoryFiles/list.do');
                            <c:forEach items="${varList}" var="var" varStatus="vs">
                            varList.add(${var.ID}, ${var.PARENT_ID}, '[${var.CODE}]${var.NAME}', 'kpiCategoryFiles/list.do?ID=${var.ID}');
                            </c:forEach>
                            document.write(varList);
                        </script>
                    </div>
                </form>
            </div>
            <div class="main-content" style="margin-left:222px">
                <div class="breadcrumbs" id="breadcrumbs">
                    <div class="m-c-l_show"></div>
                    <div style="position:absolute; top:0px; right:25px;">
                        <c:if test="${pd.ID!=null }">
                            <a class="btn btn-mini btn-primary" onclick="save();">保存</a>
                            <a class="btn btn-mini btn-danger" onclick="del('${pd.ID}');">删除</a>
                        </c:if>
                        <a class="btn btn-mini btn-primary" onclick="add();">新增KPI类别</a>
                    </div>
                </div>
                <form action="kpiCategoryFiles/edit.do" method="post" name="Form" id="editForm">
                    <input type="hidden" name="ID" id="id" value="${pd.ID }"/>
                    <div id="zhongxin" style="margin:20px; margin-left:100px;">
                        <table>
                            <tr>
                                <td><label>KPI类别编码：</label></td>
                                <td><input type="text" name="CODE" id="code"
                                           value="${pd.CODE }" placeholder="KPI类别编码" maxlength="32" title="部门编码"/></td>
                            </tr>
                            <tr>
                                <td><label>KPI类别名称：</label></td>
                                <td><input type="text" name="NAME" id="name"
                                           value="${pd.NAME }" placeholder="KPI类别名称" maxlength="32" title="部门名称"/></td>
                            </tr>
                            <tr>
                                <td><label>KPI类别描述：</label></td>
                                <td><input type="text" name="REMARKS" id="remarks"
                                           value="${pd.REMARKS }" placeholder="KPI类别描述" maxlength="32" title="部门标识"/>
                                </td>
                            </tr>
                        </table>
                        <br>
                        <%-- <table>
                            <tr>
                                <td style="text-align: right;">
                                    <a class="btn btn-mini btn-primary" onclick="save();">保存</a>
                                    <a class="btn btn-mini btn-danger" onclick="del('${pd.ID}');">删除</a>
                                    <a class="btn btn-mini btn-primary" onclick="add();">新增KPI类别</a>
                                    <c:if test="${pd.ID!=null }">
                                    <a class="btn btn-mini btn-primary" onclick="addSec('${pd.ID}');">新增下级科目</a>
                                    </c:if>
                                </td>
                            </tr>
                        </table> --%>
                    </div>
                </form>
            </div>
        </div>
    </div>
</div>
<!-- 引入 -->
<script type="text/javascript">window.jQuery || document.write("<script src='static/js/jquery-1.9.1.min.js'>\x3C/script>");</script>
<script src="static/js/bootstrap.min.js"></script>
<script src="static/js/ace-elements.min.js"></script>
<script src="static/js/ace.min.js"></script>
<!-- 引入 -->

<script type="text/javascript">
    $(top.changeui());

    //保存
    function save() {
        if ($("#id").val() == "") {
            alert("请先点击选择要修改的KPI类别！");
        } else {
            $("#editForm").submit();
        }
    }

    //新增主目录
    function add() {
        //top.jzts();
        var diag = new top.Dialog();
        diag.Drag = true;
        diag.Title = "新增KPI类别";
        diag.URL = '<%=basePath%>/kpiCategoryFiles/goAdd.do';
        diag.Width = 400;
        diag.Height = 250;
        diag.CancelEvent = function () { //关闭事件
            if ('${page.currentPage}' == '0') {
                //top.jzts();
                setTimeout("self.location=self.location", 100);
            } else {
                nextPage(${page.currentPage});
            }
            diag.close();
        };
        diag.show();
    }

    //新增次级目录
    function addSec(Id) {
        top.jzts();
        var diag = new top.Dialog();
        diag.Drag = true;
        diag.Title = "新增下级目录";
        diag.URL = '<%=basePath%>/kpiCategoryFiles/goAddSec.do?ID=' + Id;
        diag.Width = 400;
        diag.Height = 300;
        diag.CancelEvent = function () { //关闭事件
            if ('${page.currentPage}' == '0') {
                top.jzts();
                setTimeout("self.location=self.location", 100);
            } else {
                nextPage(${page.currentPage});
            }
            diag.close();
        };
        diag.show();
    }

    //删除
    function del(Id) {
        if (confirm("确定要删除?")) {
            //top.jzts();
            var url = "<%=basePath%>/kpiCategoryFiles/delete.do?ID=" + Id + "&tm=" + new Date().getTime();
            $.get(url, function (data) {
                if (data == "success") {
                    alert("KPI类别删除成功！");
                    location.replace("<%=basePath%>/kpiCategoryFiles/list.do");
                    //nextPage(${page.currentPage});
                }
            }, "text");
        }
    }

    //修改
    function edit(Id) {
        //top.jzts();
        var diag = new top.Dialog();
        diag.Drag = true;
        diag.Title = "编辑";
        diag.URL = '<%=basePath%>/kpiCategoryFiles/goEdit.do?ID=' + Id;
        diag.Width = 600;
        diag.Height = 465;
        diag.CancelEvent = function () { //关闭事件
            //diag.close();
            //location.replace("<%=basePath%>/kpiCategoryFiles/list.do");
        };
        diag.show();
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

