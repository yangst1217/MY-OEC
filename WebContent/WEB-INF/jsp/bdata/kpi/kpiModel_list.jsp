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
    </style>
</head>
<body>
<fmt:requestEncoding value="UTF-8"/>
<form action="kpiModel/list.do" method="post" name="userForm" id="userForm">
    <!-- <div style="margin-top: 20px;">
        <a class="btn btn-small btn-success" onclick="add();">新增</a>&nbsp;&nbsp;&nbsp;
        <a class="btn btn-small btn-info" onclick="edit();">修改</a>&nbsp;&nbsp;&nbsp;
        <a class="btn btn-small btn-danger" onclick="del();">删除</a>
    </div>
    <hr style="height:1px;border:none;border-top:1px solid grey;margin: 6px 0;" /> -->


    <div class="main-container-left">
        <div class="m-c-l-top">
            <img src="static/images/ui1.png" style="margin-top:-5px;">KPI模板
            <th><a class="btn btn-mini btn-info" onclick="add();">新增</a></th>
            <th><a class="btn btn-mini btn-primary" onclick="edit();">修改</a></th>
            <th><a class="btn btn-mini btn-danger" onclick="del();">删除</a>
                <!-- <a class="btn btn-mini btn-primary" onclick="fromExcel();" title="从EXCEL导入" style="margin-left:90px;">导入</a> -->
        </div>

        <table class="table table-striped table-bordered table-hover" data-min="11" data-max="30" cellpadding="0"
               cellspacing="0">
            <thead>

            <tr>

                <th class="center" style="width: 20%">
                </th>
                <th style="width: 20%">模板编号</th>
                <th>模板名称</th>
            </tr>
            </thead>
            <tbody>
            <!-- 开始循环 -->
            <c:choose>
                <c:when test="${not empty varList}">
                    <c:forEach items="${varList}" var="kpiModel" varStatus="vs">
                        <tr onclick="showDetail('${kpiModel.ID}',$(this));" style="cursor:pointer">
                            <td class='center' style="width: 30px;">
                                <label>
                                    <input type='checkbox' name='ids' kpiid="${kpiModel.ID}"
                                           value="${kpiModel.ID}"/><span class="lbl"></span>
                                </label>
                            </td>
                            <td>${kpiModel.CODE}</td>
                            <td>${kpiModel.NAME}</td>
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
                <a class="btn btn-mini btn-primary" onclick="saveScore();">保存</a>
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
                <th style="">KPI编号</th>
                <th style="">KPI指标</th>
                <th style="">类型</th>
                <th style="">单位</th>
                <th style="">考核周期</th>
                <th style="">考核标准</th>
                <th style="">分数</th>
                <th style="">考核目的</th>
                <!-- <th style="width: 6%;">1月</th>
                <th style="width: 6%;">2月</th>
                <th style="width: 6%;">3月</th>
                <th style="width: 6%;">4月</th>
                <th style="width: 6%;">5月</th>
                <th style="width: 6%;">6月</th>
                <th style="width: 6%;">7月</th>
                <th style="width: 6%;">8月</th>
                <th style="width: 6%;">9月</th>
                <th style="width: 6%;">10月</th>
                <th style="width: 6%;">11月</th>
                <th style="width: 6%;">12月</th>
                <th>分数(权重)</th> -->
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

    /* 			function saveScore(){
                    var scores=$(".record");

                    if(scores==null || scores=='undefined' || scores.length==0){
                        return;
                    }
                    for(var i=0;i<scores.length;i++){
                        score=$(scores[i]).children();
                         var PREPARATION1=$($(score)[4]).html();
                        var PREPARATION2=$($(score)[5]).html();
                        var PREPARATION3=$($(score)[6]).html();
                        var PREPARATION4=$($(score)[7]).html();
                        var ID=$($(score)[8]).html();
                        $.ajax({
                            type:"post",
                            data:{
                                "PREPARATION1":PREPARATION1,
                                "PREPARATION2":PREPARATION2,
                                "PREPARATION3":PREPARATION3,
                                "PREPARATION4":PREPARATION4,
                                "ID":ID},
                             url:"kpiModel/saveScore.do",
                             async: false,
                             success : function(msg){
                                 if(msg!=null&&msg!=""){

                                 }
                             }
                        });
                    }
                    alert("保存成功");
                } */


    function saveScore() {
        $("#userForm").submit();
    }

    //检索
    function search() {
        //top.jzts();
        $("#Form").submit();
    }

    //新增
    function add() {
        //top.jzts();
        var diag = new top.Dialog();
        diag.Drag = true;
        diag.Title = "新增";
        diag.URL = '<%=basePath%>/kpiModel/goAdd.do';
        diag.Width = 550;
        diag.Height = 400;
        diag.CancelEvent = function () { //关闭事件
            diag.close();
            location.replace("<%=basePath%>/kpiModel/list.do");
        };
        diag.show();
    }

    //删除
    function del() {
        var count = $(":checkbox[name='ids']:checked").size();
        if (count != 1) {
            alert("请选择且仅可选择一条数据！");
            return false;
        }
        bootbox.confirm("确定要删除吗?", function (result) {
            if (result) {
                //top.jzts();
                var url = "<%=basePath%>/kpiModel/delete.do?MODEL_ID=" + $(":checkbox[name='ids']:checked").val();
                $.get(url, function (data) {
                    if (data == "success") {
                        alert("删除成功！");
                        //top.jzts();
                        setTimeout("self.location.reload()", 100);
                    } else {
                        alert("该模板已分配，无法删除！");
                        //top.jzts();
                        setTimeout("self.location.reload()", 100);
                    }
                }, "text");
            }
        });
    }

    //修改
    function edit() {
        var count = $(":checkbox[name='ids']:checked").size();
        if (count != 1) {
            alert("请选择且仅可选择一条数据！");
            return false;
        }
        //top.jzts();
        var diag = new top.Dialog();
        diag.Drag = true;
        diag.Title = "编辑";
        diag.URL = '<%=basePath%>/kpiModel/goEdit.do?MODEL_ID=' + $(":checkbox[name='ids']:checked").val();
        diag.Width = 550;
        diag.Height = 400;
        diag.CancelEvent = function () { //关闭事件
            diag.close();
            location.replace("<%=basePath%>/kpiModel/list.do");
        };
        diag.show();
    }

    function showDetail(id, $obj) {
        $("[kpiid]").prop("checked", false);
        //$("[kpiid]").attr('checked',false);
        var url = "<%=basePath%>/kpiModel/modelDetail.do?ID=" + id;
        $.ajax({
            type: "POST",
            async: false,
            url: url,
            success: function (data) {     //回调函数，result，返回值
                var obj = eval('(' + data + ')');
                var shtml = "";
                $("#subjectName").html(obj.pd.NAME);
                $.each(obj.list, function (i, list) {
                    shtml += '<tr class="record"><td> ' + list.KPI_CODE + '</td><td>' + list.KPI_NAME + '</td><td>' + list.KPI_TYPE + '</td><td>' + list.KPI_UNIT + '</td><td style="text-align: center;"><input type="text" name = "PREPARATION1" id = "PREPARATION1" style = "width:60px;color:black" value=' + list.PREPARATION1 + '></td><td style="text-align: center;"><input type="text" name = "PREPARATION2" id = "PREPARATION2" style = "width:100px;color:black" value=' + list.PREPARATION2 + '></td><td style="text-align: center;"><input type="text" name = "PREPARATION3" id = "PREPARATION3" class="score" style = "width:40px;color:black"  onkeyup="control(event,this)" onblur = "getdate();" value=' + list.PREPARATION3 + '></td><td style="text-align: center;"><input type="text" name = "PREPARATION4" id = "PREPARATION4" style = "width:150px;color:black" value=' + list.PREPARATION4 + '></td><td style="display:none"><input type="text" name = "kID" id = "kID" style = "width:1px" value=' + list.ID + '></td></tr>';
                    //shtml += '<tr class="record"><th> '+list.KPI_CODE+'</th><th>'+list.KPI_NAME+'</th><th>'+list.KPI_TYPE+'</th><th>'+list.KPI_UNIT+'</th><td>'+list.PREPARATION1+'</td><td>'+list.PREPARATION2+'</td><td>'+list.PREPARATION3+'</td><td>'+list.PREPARATION4+'</td><th style="display:none">'+list.ID+'</th></tr>';
                    //shtml += '<td></td><td></td><td></td><td></td><td></td><td></td><td></td><td></td><td></td><td></td><td></td><td></td><td></td></tr>';
                });
                shtml += '<tr><th>合计</th><th></th><th></th><th></th><th></th><th></th><td style="text-align: center;"><input readonly type="text" id="count" style = "width:40px"/></td><th></th></tr>';
                $("#showDetail").html(shtml);
                $obj.parent().find("tr").each(function () {
                    $(this).css("background-color", "white");
                });
                $obj.css("background-color", "#f1f1f1");
                $("[kpiid= '" + id + "']").prop('checked', true);
                getdate();
                /*                     document.getElementById('70').click();
                 */
            }
        }, "text");

    }

    $("#PREPARATION3").keyup(function () {
        var c = $(this);
        if (/[^\d]/.test(c.val())) {//替换非数字字符
            var temp_amount = c.val().replace(/[^\d]/g, '');
            $(this).val(temp_amount);
        }
    })

    function control(e, o) {

        var v = o.value | 0;

        if (v <= 0) {

            o.value = '';

            o.focus();

        }

    };

    function getdate() {

        var list = $(document).find("[name = 'PREPARATION3']");
        var count = 0;
        $(document).find("[name = 'PREPARATION3']").each(function () {
            if ($(this).val() == null || $(this).val() == "") {
                $(this).val(0);
            }
            count = parseInt(count) + parseInt($(this).val());
        });
        $("#count").val(count);
    }
</script>

<script type="text/javascript">

    //导出excel
    function toExcel() {
        window.location.href = '<%=basePath%>/bdbudgetmodel/excel.do';
    }

    //打开上传excel页面
    function fromExcel() {
        top.jzts();
        var diag = new top.Dialog();
        diag.Drag = true;
        diag.Title = "EXCEL 导入到数据库";
        diag.URL = '<%=basePath%>kpiModel/goUploadExcel.do?MODEL_ID=' + $(":checkbox[name='ids']:checked").val();
        diag.Width = 400;
        diag.Height = 150;
        diag.CancelEvent = function () { //关闭事件
            diag.close();
        };
        diag.show();
    }

    $(".score").


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

