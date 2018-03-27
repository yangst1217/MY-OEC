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
    <base href="<%=basePath%>"><!-- jsp文件头和头部 -->
    <%@ include file="../../system/admin/top.jsp" %>

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


        //删除明细
        function delDetail(ID) {
            alert(1);

        }
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
    <style type="text/css">
        .f_deta {
            width: 180px;
            float: left;
        }

        .table td {
            vertical-align: middle;
        }
    </style>
</head>
<body>
<fmt:requestEncoding value="UTF-8"/>
<form action="positionDuty/list.do" method="post" name="userForm" id="userForm">
    <input type="hidden" name="GRADE_CODE" id="GRADE_CODE" value="${pd.GRADE_CODE}"/>
    <input type="hidden" name="id" id="id" value="${pd.id}"/>
    <input type="hidden" name="ID" id="ID" value="${pd.ID}"/>
    <!-- <div style="margin-top: 20px;">
        <a class="btn btn-small btn-success" onclick="add();">新增</a>&nbsp;&nbsp;&nbsp;
        <a class="btn btn-small btn-info" onclick="edit();">修改</a>&nbsp;&nbsp;&nbsp;
        <a class="btn btn-small btn-danger" onclick="del();">删除</a>
    </div>
    <hr style="height:1px;border:none;border-top:1px solid grey;margin: 6px 0;" /> -->


    <div class="main-container-left">
        <div class="m-c-l-top">
            <img src="static/images/ui1.png" style="margin-top:-5px;">岗位职责
            <th><a class="btn btn-mini btn-success" onclick="add();">新增</a></th>
            <th><a class="btn btn-mini btn-info" onclick="edit();">修改</a></th>
            <th><a class="btn btn-mini btn-danger" onclick="del();">删除</a>
                <!-- <a class="btn btn-mini btn-primary" onclick="fromExcel();" title="从EXCEL导入" style="margin-left:90px;">导入</a> -->
        </div>

        <table class="table table-striped table-bordered table-hover" data-min="11" data-max="30" cellpadding="0"
               cellspacing="0">
            <thead>

            <tr>

                <th class="center" style="width: 20%">
                </th>

                <th>岗位职责</th>
            </tr>
            </thead>
            <tbody>
            <!-- 开始循环 -->
            <c:choose>
                <c:when test="${not empty varList}">
                    <c:forEach items="${varList}" var="position" varStatus="vs">
                        <tr onclick="showDetail('${position.ID}',$(this));" style="cursor:pointer">
                            <td class='center' style="width: 30px;">
                                <label>
                                    <input type='checkbox' name='ids' kpiid="${position.ID}" value="${position.ID}"
                                           <c:if test="${pd.ID == position.ID}">checked="checked"</c:if>/><span
                                        class="lbl"></span>
                                </label>
                            </td>

                            <td>${position.responsibility}</td>
                        </tr>
                    </c:forEach>
                </c:when>
                <c:otherwise>
                    <tr class="main_info">
                        <td colspan="100" class="center">没有相关数据</td>
                    </tr>
                </c:otherwise>
            </c:choose>
            </tbody>
        </table>
    </div>

    <div class="main-content" style="margin-left:222px">
        <div class="breadcrumbs" id="breadcrumbs">
            <div class="m-c-l_show"></div>
            <div id="subjectName"></div>
            <div style="position:absolute; top:0px; right:25px;">
                <%-- <a class="btn btn-mini btn-success" onclick="save();">保存</a>
                <a class="btn btn-mini btn-danger" onclick="del('${pd.ID}');">删除</a>
                <c:if test="${pd.ID != null }">
                <a class="btn btn-mini btn-primary" onclick="add('${pd.ID}');">新增下级部门</a>
                </c:if> --%>
                <a class="btn btn-small btn-danger" onclick="goBack();">关闭</a>
                <a class="btn btn-small btn-success" onclick="addDetail();">添加明细</a>
                <!-- <a class="btn btn-mini btn-primary" onclick="fromExcel();" title="从EXCEL导入" style="margin-left:90px;">导入</a> -->
            </div>
        </div>

        <!-- <div id="subjectName" style="/*padding: 10px;*/height:20px;text-align: center;font-size: 17px;
            font-weight: bold;"></div>
        <div style="padding: 10px;">

        </div> -->
        <!-- <div style="float:right;padding: 10px; margin-top: -40px">
            目标值
        </div> -->
        <table id="editTable" class="table table-striped table-bordered table-hover" data-min="11" data-max="30"
               cellpadding="0" cellspacing="0">
            <thead>
            <tr>
                <th style="min-width:30px">序号</th>
                <th style="">工作明细</th>
                <th style="min-width:80px">要求</th>
                <th style="min-width:60px">标准时间</th>
                <th style="min-width:30px">单位</th>
                <th style="min-width:60px">实施频率</th>
                <th style="min-width:60px">工作指南</th>
                <th style="min-width:30px">对象</th>
                <th style="min-width:60px">需要审批</th>
                <th style="">操作</th>
            </tr>
            </thead>
            <tbody id="showDetail">

            </tbody>
        </table>
        <!-- <div style="margin-top:60px;text-align:center;">
            <input type="button" class="btn btn-small btn-primary" value="保存" onclick="saveScore();"/>
        </div> -->
    </div>

</form>

<!-- 返回顶部  -->
<a href="#" id="btn-scroll-up" class="btn btn-small btn-inverse">
    <i class="icon-double-angle-up icon-only"></i>
</a>

<!-- 引入 -->
<script type="text/javascript">window.jQuery || document.write("<script src='static/js/jquery-1.9.1.min.js'>\x3C/script>");</script>
<script src="static/js/bootstrap.min.js"></script>
<script src="static/js/ace-elements.min.js"></script>
<script src="static/js/ace.min.js"></script>

<script type="text/javascript" src="static/js/chosen.jquery.min.js"></script><!-- 下拉框 -->
<script type="text/javascript" src="static/js/bootstrap-datepicker.min.js"></script><!-- 日期框 -->
<script type="text/javascript" src="static/js/bootbox.min.js"></script><!-- 确认窗口 -->
<!-- 引入 -->
<script type="text/javascript" src="static/js/jquery.tips.js"></script><!--提示框-->
<script type="text/javascript">


    $(document).ready(
        function () {
            var id = $("#ID").val();
            $(":checkbox[name='ids']:checked").parent().parent().parent().click();
        }
    );

    //检索
    function search() {
        //top.jzts();
        $("#Form").submit();
    }

    //新增
    function add() {
        //top.jzts();
        var id = $("#id").val();
        var diag = new top.Dialog();
        diag.Drag = true;
        diag.Title = "新增";
        diag.URL = '<%=basePath%>/positionDuty/goAdd.do?id=' + id;
        diag.Width = 500;
        diag.Height = 200;
        diag.CancelEvent = function () { //关闭事件
            diag.close();
            location.replace("<%=basePath%>/positionDuty/list.do?id=" + id);
        };
        diag.show();
    }

    //删除
    function del() {
        var id = $("#id").val();
        var count = $(":checkbox[name='ids']:checked").size();
        if (count != 1) {
            top.Dialog.alert("请选择且仅可选择一条数据！");
            return false;
        }
        bootbox.confirm("确定要删除吗?", function (result) {
            if (result) {
                //top.jzts();
                var url = "<%=basePath%>/positionDuty/delete.do?DUTY_ID=" + $(":checkbox[name='ids']:checked").val();
                $.get(url, function (data) {
                    if (data == "success") {
                        top.Dialog.alert("删除成功！");
                        //top.jzts();
                        location.replace("<%=basePath%>/positionDuty/list.do?id=" + id);
                    } else {
                        top.Dialog.alert("删除失败！");
                        //top.jzts();
                        location.replace("<%=basePath%>/positionDuty/list.do?id=" + id);
                    }
                }, "text");
            }
        });
    }

    function del1(ID) {
        var id = $("#id").val();
        var mid = $(":checkbox[name='ids']:checked").val();
        bootbox.confirm("确定要删除吗?", function (result) {
            if (result) {
                //top.jzts();
                var url = "<%=basePath%>/positionDuty/delDetail.do?ID=" + ID;
                $.get(url, function (data) {
                    if (data == "success") {
                        top.Dialog.alert("删除成功！");
                        //top.jzts();
                        location.replace("<%=basePath%>/positionDuty/list.do?id=" + id + "&ID=" + mid);
                    } else {
                        top.Dialog.alert("删除失败！");
                        //top.jzts();
                        location.replace("<%=basePath%>/positionDuty/list.do?id=" + id + "&ID=" + mid);
                    }
                }, "text");
            }
        });
    }


    //修改
    function edit() {
        var id = $("#id").val();
        var count = $(":checkbox[name='ids']:checked").size();
        var ID = $(":checkbox[name='ids']:checked").val();

        if (count != 1) {
            alert("请选择且仅可选择一条数据！");
            return false;
        }
        //top.jzts();
        var diag = new top.Dialog();
        diag.Drag = true;
        diag.Title = "编辑";
        diag.URL = '<%=basePath%>/positionDuty/goEdit.do?ID=' + ID;
        diag.Width = 500;
        diag.Height = 200;
        diag.CancelEvent = function () { //关闭事件
            diag.close();
            location.replace("<%=basePath%>/positionDuty/list.do?id=" + id + "&ID=" + ID);
        };
        diag.show();
    }


    //新增明细
    function addDetail() {
        var id = $("#id").val();
        var count = $(":checkbox[name='ids']:checked").size();
        var ID = $(":checkbox[name='ids']:checked").val();
        if (count != 1) {
            alert("请选择一条岗位职责！");
            return false;
        }
        //top.jzts();
        var diag = new top.Dialog();
        diag.Drag = true;
        diag.Title = "编辑";
        diag.URL = '<%=basePath%>/positionDuty/goAddDetail.do?responsibility_id=' + $(":checkbox[name='ids']:checked").val();
        diag.Width = 400;
        diag.Height = 300;
        diag.CancelEvent = function () { //关闭事件
            diag.close();
            location.replace("<%=basePath%>/positionDuty/list.do?id=" + id + "&ID=" + ID);
        };
        diag.show();
    }


    //修改明细
    function editDetail(ID) {
        var id = $("#id").val();
        var mid = $(":checkbox[name='ids']:checked").val();
        var count = $(":checkbox[name='ids']:checked").size();
        if (count != 1) {
            alert("请选择且仅可选择一条数据！");
            return false;
        }
        //top.jzts();
        var diag = new top.Dialog();
        diag.Drag = true;
        diag.Title = "编辑";
        diag.URL = '<%=basePath%>/positionDuty/goEditDetail.do?ID=' + ID;
        diag.Width = 500;
        diag.Height = 400;
        diag.CancelEvent = function () { //关闭事件
            diag.close();
            location.replace("<%=basePath%>/positionDuty/list.do?id=" + id + "&ID=" + mid);
        };
        diag.show();
    }


    //明细列表
    function showDetail(id, $obj) {
        $("[kpiid]").prop('checked', false);
        var url = "<%=basePath%>/positionDuty/showDetail.do?ID=" + id;
        $.ajax({
            type: "POST",
            async: false,
            url: url,
            success: function (data) {     //回调函数，result，返回值
                var obj = eval('(' + data + ')');

                var shtml = "";
                $("#subjectName").html(obj.pd.NAME);
                $.each(obj.list, function (i, list) {
                    if (list.needApprove == 0) {
                        shtml += '<tr class="record"><td class="center">' + Number(i + 1) + '</td><td> ' + list.detail + '</td><td>' + list.requirement + '</td><td>' + list.standard_time + '</td><td>' + list.unit + '</td><td>' + list.frequency + '</td><td>' + list.guide + '</td><td>' + list.target + '</td><td>' + "否" + '</td><td style="display:none"><input type="text" name = "kID" id = "kID" style = "width:1px" value=' + list.ID + '></td>';
                    }
                    else {
                        shtml += '<tr class="record"><td class="center">' + Number(i + 1) + '</td><td> ' + list.detail + '</td><td>' + list.requirement + '</td><td>' + list.standard_time + '</td><td>' + list.unit + '</td><td>' + list.frequency + '</td><td>' + list.guide + '</td><td>' + list.target + '</td><td>' + "是" + '</td><td style="display:none"><input type="text" name = "kID" id = "kID" style = "width:1px" value=' + list.ID + '></td>';
                    }
                    //shtml += '<tr class="record"><td class="center">'+ Number(i+1) +'</td><td> '+list.detail+'</td><td>'+list.requirement+'</td><td>'+list.unit+'</td><td>'+list.standard_time+'</td><td>'+list.frequency+'</td><td>'+list.guide+'</td><td>'+list.target+'</td><td>'+list.needApprove+'</td><td style="display:none"><input type="text" name = "kID" id = "kID" style = "width:1px" value='+list.ID+'></td>';
                    shtml += "<td style='width: 70px'>"
                    shtml += "<a style='cursor:pointer' title='编辑' onclick='editDetail(" + list.ID + ")' class='btn btn-mini btn-info' data-rel='tooltip' data-placement='left'>" + "<i class='icon-edit'></i></a>" + " ";
                    shtml += "<a style='cursor:pointer' title='删除' onclick='del1(" + list.ID + ")' class='btn btn-mini btn-danger' data-rel='tooltip' data-placement='left'>" + "<i class='icon-trash'></i></a>" + " ";
                    shtml += "</td></tr>"
                });
                $("#showDetail").html(shtml);
                $obj.parent().find("tr").each(function () {
                    $(this).css("background-color", "white");
                });
                $obj.css("background-color", "#f1f1f1");
                $("[kpiid= '" + id + "']").prop('checked', true);

                /*                     document.getElementById('70').click();
                 */
            }
        }, "text");

    }

    //关闭tab页
    function goBack() {
        $("#" + $('#PARENT_FRAME_ID').val(), window.parent.document).trigger("click");
        $("#page_" + $('#PARENT_FRAME_ID').val(), window.parent.document).attr('src', $("#page_" + $('#PARENT_FRAME_ID').val(), window.parent.document).attr('src'));
        $("#explain1", window.parent.document).children().find(".tab_close").trigger("click");
    }


</script>

<script type="text/javascript">


</script>
<script type="text/javascript">
    //为表格绑定处理方法.
    //document.getElementById("editTable").ondblclick=editCell;
    //dom创建文本框
    var input = document.createElement("input");
    input.type = "text";
    input.style.width = "60px";
    /* input.style.height="15px";  */
    input.style.padding = "0px";
    //得到当前的单元格
    var currentCell;
    var cHtml = "";

    function editCell(event) {
        if (event == null) {
            currentCell = window.event.srcElement;
        }
        else {
            currentCell = event.target;
        }
        //根据Dimmacro 的建议修定下面的bug 非常感谢
        if (currentCell.tagName == "TD") {
            //用单元格的值来填充文本框的值
            input.value = currentCell.innerHTML;
            cHtml = currentCell.innerHTML;
            //当文本框丢失焦点时调用last
            input.onblur = last;
            input.ondblclick = last;
            currentCell.innerHTML = "";
            //把文本框加到当前单元格上.
            currentCell.appendChild(input);
            input.focus();
        }
    }

    function last() {
        //判断当前输入框中的值是不是数字
        var inputValue = input.value.replace(/\s+/g, "");
        var re = /^([1-9]\d{0,11}|0)(\.\d{1,2})?$/;
        if (1) {
            //充文本框的值给当前单元格
            currentCell.innerHTML = input.value;
        } else {
            alert("数据格式错误，小数点后最多两位!");
            currentCell.innerHTML = cHtml;
            return;
        }


    }


</script>

</body>
</html>

