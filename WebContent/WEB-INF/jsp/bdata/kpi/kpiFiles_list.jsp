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
    <script src="static/js/bootstrap-datepicker.min.js" type="text/javascript"></script><!-- 日期框 -->
    <script type="text/javascript" src="static/js/bootbox.min.js"></script><!-- 确认窗口 -->
    <script src="static/js/bootstrap.min.js"></script>
    <script type="text/javascript" src="static/js/jquery.tips.js"></script><!--提示框-->

    <!-- ace scripts -->
    <script src="static/assets/js/ace/elements.fileinput.js"></script>
    <script src="static/assets/js/ace/ace.js"></script>

    <!-- ace styles -->
    <!--  <link rel="stylesheet" href="static/assets/css/ace.css" class="ace-main-stylesheet" id="main-ace-style" /> -->


    <link rel="stylesheet" href="static/assets/css/font-awesome.css"/>
    <script src="static/js/ajaxfileupload.js"></script>
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
<fmt:requestEncoding value="UTF-8"/>
<div class="container-fluid" id="main-container">
    <div id="page-content" class="clearfix">
        <div class="row-fluid">

            <form action="kpiFiles/list.do" method="post" name="kpiFilesForm" id="kpiFilesForm">
                <div class="main-container-left">
                    <div class="m-c-l-top">
                        <img src="static/images/ui1.png" style="margin-top:-5px;">KPI指标库
                        <a class="btn btn-mini btn-primary" onclick="fromExcel();" title="从EXCEL导入"
                           style="margin-left:90px;">导入</a>
                    </div>

                    <input type="hidden" name="editFlag" id="editFlag" value="${editFlag }" title="新增修改成功标志"/>
                    <%-- <table style="width:100%;">
                        <tr>
                            <td style="vertical-align:top;">
                                <a class="btn btn-small btn-success" onclick="add()">新增</a>
                                <a class="btn btn-small btn-success" onclick="edit('${pd.ID}');">修改</a>
                                <a class="btn btn-small btn-danger" onclick="del('${pd.ID}','${pd.KPI_CODE}');" title="删除">
                                    <i class='icon-trash'></i>
                                </a>
                            </td>
                        </tr>
                    </table><br> --%>
                    <div class="left">
                        <script type="text/javascript">
                            varList = new dTree('varList', 'static/img', 'treeForm');
                            varList.config.useIcons = true;
                            varList.add(0, -1, 'KPI维护', 'kpiFiles/list.do');
                            <c:forEach items="${dtreeList}" var="var" varStatus="vs">
                            varList.add(${var.ID}, ${var.PARENT_ID}, '[${var.CODE}]${var.NAME}', 'kpiFiles/list.do?ID=${var.ID}', '', '', '', '', true);
                            </c:forEach>
                            document.write(varList);
                        </script>
                    </div>
                </div>
                <div class="main-content" style="margin-left:222px">
                    <div class="breadcrumbs" id="breadcrumbs">
                        <div class="m-c-l_show"></div>
                        <div style="position:absolute; top:0px; right:25px;">
                            <c:if test="${pd.ID != null && pd.KPI_NAME != null}">
                                <a class="btn btn-mini btn-primary" onclick="add();">新增</a>
                                <a class="btn btn-mini btn-primary" onclick="edit('${pd.ID}');">修改</a>
                            </c:if>
                            <c:if test="${pd.KPI_NAME != null}">
                                <a class="btn btn-mini btn-danger" onclick="del('${pd.ID}','${pd.KPI_CODE}');">删除</a>
                            </c:if>
                            <c:if test="${pd.ID != NULL && pd.KPI_NAME == null}">
                                <a class="btn btn-mini btn-primary" onclick="add();">新增下级KPI</a>
                                <a class="btn btn-mini btn-primary" onclick="edittop('${pd.ID}');">修改</a>
                                <a class="btn btn-mini btn-danger" onclick="checkEmp('${pd.ID}');">删除</a>
                            </c:if>
                            <a class="btn btn-mini btn-primary" onclick="addr();">新增根级KPI</a>
                        </div>
                    </div>


                    <table id="table_report" class="table table-striped table-bordered table-hover">
                        <thead>
                        <tr>
                            <th style="width:100px">KPI编码</th>
                            <th style="width:150px">KPI名称</th>
                            <th style="width:100px">KPI类型名称</th>
                            <th style="width:150px">指标描述</th>
                            <th style="width:100px">KPI单位</th>
                            <th>KPI计算逻辑</th>
                            <th style="width:70px">是否有效</th>
                            <th style="width:100px">指标文档</th>
                        </tr>
                        </thead>
                        <tbody>
                        <tr>
                            <td>${pd.KPI_CODE}</td>
                            <td>${pd.KPI_NAME}</td>
                            <td>${pd.KPI_CATEGORY_NAME}</td>
                            <td>${pd.KPI_DESCRIPTION}</td>
                            <td>${pd.KPI_UNIT}</td>
                            <td>${pd.KPI_SQL}</td>
                            <input type="hidden" id="PARENT_ID" name="PARENT_ID" value="${pd.treeID}"/>
                            <td>
                                <c:if test="${pd.ENABLED == 1}">是</c:if>
                                <c:if test="${pd.ENABLED == 0}">否</c:if>
                            </td>
                            <td>
                                <c:choose>
                                    <c:when test="${not empty fileList}">
                                        <c:forEach items="${fileList}" var="file" varStatus="vs">
                                            <div>
                                                <a href="<%=basePath%>/uploadFiles/file/${file.FILENAME}">${file.FILENAME}</a>
                                            </div>
                                        </c:forEach>
                                    </c:when>
                                </c:choose>
                            </td>
                            <%-- <td>${file.FILENAME}</td>
                            <input type="hidden" id="PATH" name="PATH" value="${file.PATH}" /> --%>
                        </tr>
                        </tbody>
                    </table>
                </div>
            </form>
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

    //检索
    function search() {
        //top.jzts();
        $("#Form").submit();
    }

    //新增根级kpi
    function addr() {
        //top.jzts();
        var diag = new top.Dialog();
        diag.Drag = true;
        diag.Title = "新增根级KPI类别";
        diag.URL = '<%=basePath%>/kpiFiles/goAddr.do';
        diag.Width = 400;
        diag.Height = 250;
        diag.CancelEvent = function () { //关闭事件
            if ('${page.currentPage}' == '0') {
                //top.jzts();
                nextPage(${page.currentPage});
            } else {
                nextPage(${page.currentPage});
            }
            diag.close();
        };
        diag.show();
    }

    //新增
    function add() {
        top.jzts();
        var diag = new top.Dialog();
        diag.Drag = true;
        diag.Title = "新增KPI";
        diag.URL = "<%=basePath%>/kpiFiles/goAdd.do?PARENT_ID=" + $('#PARENT_ID').val();
        diag.Width = 600;
        diag.Height = 600;
        diag.CancelEvent = function () { //关闭事件
            if ('${page.currentPage}' == '0') {
                top.jzts();
                nextPage(${page.currentPage});
            } else {
                nextPage(${page.currentPage});
            }
            diag.close();
        };
        diag.show();
    }

    //查找次级
    function checkEmp(Id) {
        var urle = "<%=basePath%>/kpiFiles/checkEmp.do?ID=" + Id;
        $.get(urle, function (data) {
            if (data == "0") {
                deltop(Id);
            } else {
                top.Dialog.alert("本KPI类型下还有KPI，不可删除！");
                return false;
            }
        });
    }

    //删除根级
    function deltop(Id) {
        if (confirm("确定要删除?")) {
            //top.jzts();
            var url = "<%=basePath%>/kpiCategoryFiles/delete.do?ID=" + Id + "&tm=" + new Date().getTime();
            $.get(url, function (data) {
                if (data == "success") {
                    top.Dialog.alert("KPI根类别删除成功！");
                    location.replace("<%=basePath%>/kpiFiles/list.do");
                    //nextPage(${page.currentPage});
                }
            }, "text");
        }
    }

    //删除
    function del(id, kpiCode) {

        if (confirm("确定要删除?")) {
            //top.jzts();
            var url = "<%=basePath%>/kpiFiles/delete.do?ID=" + id + "&KPI_CODE=" + kpiCode;
            $.get(url, function (data) {
                if (data == "success") {
                    top.Dialog.alert("删除KPI成功！");
                    //nextPage(${page.currentPage});
                    location.replace("<%=basePath%>/kpiFiles/list.do");
                }
            }, "text");

        }

    }

    //修改根部
    function edittop(Id) {
        //top.jzts();
        var diag = new top.Dialog();
        diag.Drag = true;
        diag.Title = "编辑";
        diag.URL = '<%=basePath%>/kpiFiles/goEditTop.do?ID=' + Id;
        diag.Width = 400;
        diag.Height = 250;
        diag.CancelEvent = function () { //关闭事件
            diag.close();
            nextPage(${page.currentPage});
        };
        diag.show();
    }

    //修改
    function edit(Id) {
        //top.jzts();
        var diag = new top.Dialog();
        diag.Drag = true;
        diag.Title = "编辑";
        diag.URL = '<%=basePath%>/kpiFiles/goEdit.do?ID=' + Id;
        diag.Width = 600;
        diag.Height = 600;
        diag.CancelEvent = function () { //关闭事件
            diag.close();
            nextPage(${page.currentPage});
        };
        diag.show();
    }

    window.onload = function () {
        if ($("#editFlag").val() == "saveSucc") {
            top.Dialog.alert("新增成功！");
        }
        if ($("#editFlag").val() == "updateSucc") {
            top.Dialog.alert("修改成功！");
        }
    }

    //打开上传excel页面
    function fromExcel() {
        top.jzts();
        var diag = new top.Dialog();
        diag.Drag = true;
        diag.Title = "EXCEL 导入到数据库";
        diag.URL = 'kpiFiles/goUploadExcel.do';
        diag.Width = 400;
        diag.Height = 150;
        diag.CancelEvent = function () { //关闭事件
            diag.close();
            location.replace("<%=basePath%>/kpiFiles/list.do");
        };
        diag.show();
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
