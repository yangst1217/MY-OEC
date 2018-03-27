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
    <%@ include file="../admin/top.jsp" %>
</head>
<body>

<div class="container-fluid" id="main-container">


    <div id="page-content">

        <div class="row-fluid">
            <div class="row-fluid">

                <form action="buttons/list.do" method="post" name="Form" id="Form">
                    <table>
                        <tr>
                            <td>
					<span class="input-icon">
						<input autocomplete="off" id="keyword" type="text" name="keyword" value="${pd.keyword}"
                               placeholder="这里输入关键词"/>
						<i id="nav-search-icon" class="icon-search"></i>
					</span>
                            </td>
                            <td style="vertical-align:top;">
                                <select id="ENABLED" name="enabled" data-placeholder="请选择状态"
                                        style="vertical-align:top;width: 79px;" class="form-field-select-2">
                                    <option value=""></option>
                                    <option value="1"
                                            <c:if test="${pd.ENABLED == '1' }">selected</c:if> >有效
                                    </option>
                                    <option value="0" <c:if test="${pd.ENABLED == '0' }">selected</c:if>>无效</option>
                                </select>
                            </td>
                            <c:if test="${QX.cha == 1 }">
                                <td style="vertical-align:top;">
                                    <button class="btn btn-mini btn-light" onclick="search();" title="检索"><i
                                            id="nav-search-icon" class="icon-search"></i></button>
                                </td>
                            </c:if>
                        </tr>
                    </table>

                    <table id="table_report" class="table table-striped table-bordered table-hover">
                        <thead>
                        <tr>
                            <th class="center">序号</th>
                            <th class="center">按钮名</th>
                            <th class="center">事件</th>
                            <th class="center">描述</th>
                            <th class="center">排序</th>
                            <th class="center">状态</th>
                            <th style="width:155px;" class="center">操作</th>
                        </tr>
                        </thead>
                        <c:choose>
                            <c:when test="${not empty varList}">
                                <c:forEach items="${varList}" var="var" varStatus="vs">
                                    <tr>
                                        <td class='center' style="width:30px;">${vs.index+1}</td>
                                        <td id="BUTTONS_NAMETd${var.BUTTONS_ID }">${var.BUTTONS_NAME }</td>
                                        <td>${var.BUTTONS_EVENT }</td>
                                        <td>${var.DESCRIPTION }</td>
                                        <td>${var.BUTTONS_ORDER }</td>
                                        <c:if test="${var.ENABLED ==1 }">
                                            <td class='hidden-480'><span class='label label-success'>有效</span></td>
                                        </c:if>
                                        <c:if test="${var.ENABLED ==0 }">
                                            <td class='hidden-480'><span
                                                    class='label label-inverse arrowed-in'>无效</span></td>
                                        </c:if>
                                        <td style="width:155px;">

                                            <c:if test="${QX.edit != 1 && QX.del != 1 }">
                                            <div style="width:100%;" class="center">
                                                <span class="label label-large label-grey arrowed-in-right arrowed-in"><i
                                                        class="icon-lock" title="无权限"></i></span>
                                            </div>
                                            </c:if>

                                            <c:if test="${QX.edit == 1 }">
                                            <a class='btn btn-mini btn-info' title="编辑"
                                               onclick="editButtons('${var.BUTTONS_ID }');"><i
                                                    class='icon-edit'></i></a>
                                            </c:if>

                                            <c:if test="${QX.del == 1 }">
                                            <a class='btn btn-mini btn-danger' title="删除"
                                               onclick="delButtons('${var.BUTTONS_ID }','${var.BUTTONS_NAME }');"><i
                                                    class='icon-trash'></i></a>
                                            </c:if>

                                    </tr>
                                </c:forEach>
                                <c:if test="${QX.cha == 0 }">
                                    <tr>
                                        <td colspan="100" class="center">您无权查看</td>
                                    </tr>
                                </c:if>
                            </c:when>
                            <c:otherwise>
                                <tr>
                                    <td colspan="100" class="center">没有相关数据</td>
                                </tr>
                            </c:otherwise>
                        </c:choose>
                    </table>

                    <div class="page-header position-relative">
                        <c:if test="${QX.add == 1 }">
                            <table style="width:100%;">
                                <tr>
                                    <td style="vertical-align:top;"><a class="btn btn-small btn-success"
                                                                       onclick="addButtons();">新增</a></td>
                                </tr>
                            </table>
                        </c:if>
                    </div>
                </form>
            </div>


            <!-- PAGE CONTENT ENDS HERE -->
        </div><!--/row-->

    </div><!--/#page-content-->
</div><!--/.fluid-container#main-container-->

<!-- 返回顶部  -->
<a href="#" id="btn-scroll-up" class="btn btn-small btn-inverse">
    <i class="icon-double-angle-up icon-only"></i>
</a>

<!-- 引入 -->
<script src="static/1.9.1/jquery.min.js"></script>
<script type="text/javascript">window.jQuery || document.write("<script src='static/js/jquery-1.9.1.min.js'>\x3C/script>");</script>
<script src="static/js/bootstrap.min.js"></script>
<script src="static/js/ace-elements.min.js"></script>
<script src="static/js/ace.min.js"></script>

<script type="text/javascript" src="static/js/bootbox.min.js"></script><!-- 确认窗口 -->
<!-- 引入 -->

<script type="text/javascript">

    top.changeui();

    //检索
    function search() {
        top.jzts();
        $("#Form").submit();
    }

    //新增角色
    function addButtons() {
        top.jzts();
        var diag = new top.Dialog();
        diag.Drag = true;
        diag.Title = "新增按钮";
        diag.URL = 'buttons/toAdd.do';
        diag.Width = 222;
        diag.Height = 230;
        diag.CancelEvent = function () { //关闭事件
            if (diag.innerFrame.contentWindow.document.getElementById('zhongxin').style.display == 'none') {
                top.jzts();
                setTimeout("self.location.reload()", 100);
            }
            diag.close();
        };
        diag.show();
    }

    //修改
    function editButtons(BUTTONS_ID) {
        top.jzts();
        var diag = new top.Dialog();
        diag.Drag = true;
        diag.Title = "编辑";
        diag.URL = 'buttons/toEdit.do?BUTTONS_ID=' + BUTTONS_ID;
        diag.Width = 222;
        diag.Height = 230;
        diag.CancelEvent = function () { //关闭事件
            if (diag.innerFrame.contentWindow.document.getElementById('zhongxin').style.display == 'none') {
                top.jzts();
                setTimeout("self.location.reload()", 100);
            }
            diag.close();
        };
        diag.show();
    }

    //删除
    function delButtons(BUTTONS_ID, BUTTONS_NAME) {
        bootbox.confirm("确定要删除[" + BUTTONS_NAME + "]吗?", function (result) {
            if (result) {
                var url = "<%=basePath%>/buttons/delete.do?BUTTONS_ID=" + BUTTONS_ID;
                $.get(url, function (data) {
                    if (data == "success") {
                        top.jzts();
                        document.location.reload();
                    }
                });
            }
        });
    }

</script>

</body>
</html>

