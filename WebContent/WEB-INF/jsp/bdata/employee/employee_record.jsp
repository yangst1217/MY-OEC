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
    <meta charset="utf-8"/>
    <title></title>
    <meta name="description" content="overview & stats"/>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <link href="static/css/style.css" rel="stylesheet"/>
    <link href="static/css/bootstrap.min.css" rel="stylesheet"/>
    <link href="static/css/bootstrap-responsive.min.css" rel="stylesheet"/>
    <link rel="stylesheet" href="static/css/font-awesome.min.css"/>
    <!-- 下拉框 -->
    <link rel="stylesheet" href="static/css/chosen.css"/>
    <link rel="stylesheet" href="static/css/ace.min.css"/>
    <link rel="stylesheet" href="static/css/ace-responsive.min.css"/>
    <link rel="stylesheet" href="static/css/ace-skins.min.css"/>
    <link type="text/css" rel="stylesheet" href="plugins/zTree/zTreeStyle.css"/>
    <script type="text/javascript" src="static/js/jquery-1.7.2.js"></script>
    <!--提示框-->
    <script type="text/javascript" src="static/js/jquery.tips.js"></script>

    <style type="text/css">
        input[type="checkbox"], input[type="radio"] {
            opacity: 1;
            position: static;
            /* height:25px; */
            margin-bottom: 8px;
        }

        .kpi-input {
            width: 40px;
            border: none;
            /* outline:none;
            outline:medium; */
        }

        #zhongxin select {
            margin: 5px 0;
        }
    </style>
</head>
<body>
<form action="employee/record.do" name="employeeForm" id="employeeForm" method="post">
    <input type="hidden" name="msg" id="msg" value="${msg}" title="修改页标志"/>
    <input type="hidden" name="flag" id="flag" value="${flag}" title="是否修改成功"/>
    <input type="hidden" name="editFlag" id="editFlag" value="${editFlag}" title="新增修改成功标志"/>
    <input type="hidden" name="EMP_ID" id="emp_id" value="${bdata.ID }" title="员工ID"/>
    <div class="tabbable tabs-below">
        <ul class="nav nav-tabs" id="menuStatus">
            <li>
                <!-- <a data-toggle="tab"> </a> -->
                <img src="static/images/ui1.png" style="margin-top:-3px;">
                员工档案
            </li>
            <div class="nav-search" id="nav-search"
                 style="right:5px;" class="form-search">

                <div style="float:left;" class="panel panel-default">
                    <div>
                        <a class="btn btn-mini btn-primary" onclick="save();"
                           style="float:left;margin-right:5px;">保存</a>
                        <a class="btn btn-mini btn-danger" onclick="goBack();"
                           style="float:left;margin-right:5px;">关闭</a>
                    </div>
                </div>
            </div>
        </ul>
    </div>
    <div id="zhongxin">


        <table style="margin-left: 50px;">
            <tr>
                <td style="padding-left: 30px;">
                    <label>员工姓名：</label>
                </td>
                <td>
                    <input type="text" name="NAME" id="name"
                           value="${bdata.EMP_NAME }" maxlength="32" placeholder="姓名" title="姓名" readonly/>
                </td>
                <td style="padding-left: 30px;">
                    <label>出生日期：</label>
                </td>
                <td>
                    <input type="text" id="birthday" name="BIRTHDAY" style="background:#fff!important;"
                           class="date-picker" data-date-format="yyyy-mm-dd" placeholder="请输入年月日！"
                           value="${emp.BIRTHDAY }" readonly="readonly"/>
                </td>
                <td style="padding-left: 30px;">
                    <label>员工性别：</label>
                </td>
                <td>
                    <c:if test="${bdata.EMP_GENDER == 1}"><input type="hidden" name="GENDER" value="1">男</c:if>
                    <c:if test="${bdata.EMP_GENDER == 2}"><input type="hidden" name="GENDER" value="2">女</c:if>
                </td>
            </tr>
            <tr>
                <td style="padding-left: 30px;">
                    <label>年&nbsp;龄：</label>
                </td>
                <td>
                    <input type="text" name="AGE" id="age"
                           value="${emp.AGE }" maxlength="32" placeholder="年龄" title="年龄"/>
                </td>
                <td style="padding-left: 30px;">
                    <label>籍&nbsp;贯：</label>
                </td>
                <td colspan="3" style="width:500px">
                    <input type="text" name="ADDRESS" id="address"
                           value="${emp.ADDRESS }" maxlength="100" placeholder="籍贯" title="籍贯" style="width:97.3%"/>
                </td>
            </tr>
            <tr>
                <td style="padding-left: 30px;">
                    <label>联系电话：</label>
                </td>
                <td>
                    <input type="text" name="PHONE" id="phone"
                           value="${bdata.EMP_PHONE }" maxlength="32" placeholder="联系电话" title="联系电话" readonly/>
                </td>
                <td style="padding-left: 30px;">
                    <label>员工邮箱：</label>
                </td>
                <td>
                    <input type="text" name="EMAIL" id="email"
                           value="${bdata.EMP_EMAIL }" maxlength="32" placeholder="员工邮箱" title="员工邮箱" readonly/>
                </td>
                <td style="padding-left: 30px;">
                    <label>专&nbsp;业：</label>
                </td>
                <td>
                    <input type="text" name="MAJOR" id="major"
                           value="${emp.MAJOR }" maxlength="32" placeholder="专业" title="专业"/>
                </td>
            </tr>
            <tr>
                <td style="padding-left: 30px;">
                    <label>毕业学校：</label>
                </td>
                <td>
                    <input type="text" name="SCHOOL" id="school"
                           value="${emp.SCHOOL }" maxlength="32" placeholder="毕业学校" title="毕业学校"/>
                </td>
                <td style="padding-left: 30px;">
                    <label>毕业时间：</label>
                </td>
                <td>
                    <input type="text" id="graduate_time" name="GRADUATE_TIME" style="background:#fff!important;"
                           class="date-picker" data-date-format="yyyy-mm-dd" placeholder="请输入年月日！"
                           value="${emp.GRADUATE_TIME }" readonly="readonly"/>
                </td>
                <td style="padding-left: 30px;">
                    <label>学&nbsp;位：</label>
                </td>
                <td>
                    <input type="text" name="DEGREE" id="degree"
                           value="${emp.DEGREE }" maxlength="32" placeholder="学位" title="学位"/>
                </td>
            </tr>
        </table>
        <hr style="height:1px;border:none;border-top:1px solid grey;margin: 6px 0;"/>
        <div class="row">
            <div class="span12">
                <div class="span6" style="text-align: left">
                    <h4>工作经历</h4>
                </div>
                <div class="span5" style="text-align: right">
                    <h4>
                        <a style="cursor:pointer;" title="添加工作经历" onclick="add()" class='btn btn-small btn-info'
                           data-rel="tooltip" data-placement="left">
                            <i class="icon-book"></i>
                        </a>
                        <a style="cursor:pointer;" title="删除工作经历" onclick="del()" class='btn btn-small btn-danger'
                           data-rel="tooltip" data-placement="left">
                            <i class="icon-trash"></i>
                        </a>
                    </h4>
                </div>
            </div>
            <div class="span12">
                <!--分解表格-->
                <table class="table table-striped table-bordered table-hover" id="dimtable">
                    <thead>
                    <th class="center">
                    </th>
                    <th class="center" style="width: 30px;">序号</th>
                    <th class="center" style="width: 70%">工作经历</th>
                    <th class="center" style="width: 20%">职位</th>
                    </thead>
                    <tbody>
                    <c:forEach items="${expList}" var="exp" varStatus="vs">
                        <tr>
                            <td>
                                <label>
                                    <span class='lbl'></span>
                                    <input type='checkbox' name='ids'/>
                                </label>
                                <input name='ID' type='hidden' value="${exp.ID}"/>
                            </td>
                            <td class='center' style="width: 30px;" name='vs_td'>${vs.index+1}</td>
                            <td style="width: 70%">
                                <input value='${exp.EXP}' name='EXP' style="width: 100%"/>
                            </td>
                            <td style="width: 20%">
                                <input value='${exp.POSITION}' name='POSITION' style="width: 100%"/>
                            </td>
                        </tr>
                    </c:forEach>
                    </tbody>
                </table>
                <!--分解表格-->
            </div>
        </div>
</form>

<!-- 引入 -->
<script type="text/javascript">window.jQuery || document.write("<script src='static/js/jquery-1.9.1.min.js'>\x3C/script>");</script>
<script src="static/js/bootstrap.min.js"></script>
<script src="static/js/ace-elements.min.js"></script>
<script src="static/js/ace.min.js"></script>
<script type="text/javascript" src="static/js/chosen.jquery.min.js"></script><!-- 下拉框 -->
<script type="text/javascript" src="static/js/bootbox.min.js"></script><!-- 确认窗口 -->
<script type="text/javascript" src="static/js/bootstrap-datepicker.min.js"></script><!-- 日期框 -->
<script type="text/javascript" src="plugins/zTree/jquery.ztree-2.6.min.js"></script>
<script type="text/javascript" src="static/deptTree/deptTree.js"></script>

<script type="text/javascript">
    $(document).ready(function () {
        if ($("#flag").val() == "success") {
            top.Dialog.alert("保存成功");
        }
        else if ($("#flag").val() == "false") {
            top.Dialog.alert("保存失败");
        }
    });
    //日期控件预加载
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

    //复选框预加载
    $('#explain_table th input:checkbox').on('click', function () {
        var that = this;
        $(this).closest('table').find('tr > td:first-child input:checkbox').not(':disabled')
            .each(function () {
                this.checked = that.checked;
                $(this).closest('tr').toggleClass('selected');
            });
    });


    //新增经历
    function add() {
        var ss = document.getElementsByName('ids').length + 1;
        var shtml = "<tr>";
        shtml += "<td><label><span class='lbl'></span><input type='checkbox' name='ids'/></label><input name='ID' type='hidden'/></td>";
        shtml += "<td class='center' style='width: 30px;' name='vs_td'>" + ss + "</td>";
        shtml += "<td style='width: 70%'><input value='' name='EXP' style='width: 100%'/></td>";
        shtml += "<td style='width: 20%'><input value='' name='POSITION' style='width: 100%'/></td>";
        shtml += "</tr>";
        $("#dimtable").append(shtml);
    }

    //删除经历
    function del() {
        var objList = document.getElementsByName('ids');
        var status = 'false';
        for (var i = 0; i < objList.length; i++) {
            if (objList[i].checked) {
                status = 'true';
            }
        }
        if (status == 'false') {
            top.Dialog.alert("您没有勾选任何内容，不能删除");
            $("#zcheckbox").tips({
                side: 3,
                msg: '点这里全选',
                bg: '#AE81FF',
                time: 8
            });
            return;
        } else {
            bootbox.confirm("确定要删除吗?", function (result) {
                if (result) {
                    var removeList = new Array();
                    for (var i = 0; i < objList.length; i++) {
                        if (objList[i].checked) {
                            removeList.push($(objList[i]).parents("tr"));
                        }
                    }
                    for (var i = 0; i < removeList.length; i++) {
                        removeList[i].remove();
                    }
                    $("#zcheckbox").attr("checked", false);
                    var vsList = document.getElementsByName("vs_td");
                    for (var i = 0; i < vsList.length; i++) {
                        $(vsList[i]).html(Number(i) + 1);
                    }
                    bootbox.hideAll();
                }
            })
        }
    }


    //保存
    function save() {
        //移除disable,后台方可取值
        $("#employeeForm :disabled").each(function () {
            $(this).attr("disabled", false);
        });
        var objList = document.getElementsByName('ids');
        var expList = document.getElementsByName('EXP');
        var positionList = document.getElementsByName('POSITION');
        if (objList.length == 0) {//只有一个form外隐藏的，未添加
            top.Dialog.alert("请至少添加一条工作经历！");
            return false;
        }
        for (var i = 0; i < expList.length; i++) {
            if (null == expList[i].value || "" == expList[i].value || 0 == Number(expList[i].value)) {
                $(expList[i]).tips({
                    side: 3,
                    msg: '请填写工作经历！',
                    bg: '#AE81FF',
                    time: 2
                });
                $(expList[i]).focus();
                return false;
            }
            ;
        }
        for (var i = 0; i < positionList.length; i++) {
            if (null == positionList[i].value || "" == positionList[i].value || 0 == Number(positionList[i].value)) {
                $(positionList[i]).tips({
                    side: 3,
                    msg: '请填写曾任岗位！',
                    bg: '#AE81FF',
                    time: 2
                });
                $(positionList[i]).focus();
                return false;
            }
            ;
        }

        $("#employeeForm").submit();
    }

    //关闭员工table页
    function goBack() {
        <%-- window.location.href = "<%=basePath%>employee/list.do"; --%>
        $(".tab_item2_selected", window.parent.document).siblings().find(".tab_close").trigger("click");
    }


</script>

</body>
</html>