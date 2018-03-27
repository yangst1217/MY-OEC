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

        #zhongxin td {
            height: 60px;
        }

        #zhongxin td label {
            text-align: right;
            margin-right: 10px;
        }
    </style>
</head>
<body>
<form action="employee/${msg}.do" name="employeeForm" id="employeeForm" method="post">
    <div class="tabbable tabs-below">
        <ul class="nav nav-tabs" id="menuStatus">
            <li>
                <!-- <a data-toggle="tab"> </a> -->
                <img src="static/images/ui1.png" style="margin-top:-3px;">
                员工管理
            </li>

            <div class="nav-search" id="nav-search"
                 style="right:5px;" class="form-search">

                <div style="float:left;" class="panel panel-default">
                    <div>
                        <a class="btn btn-mini btn-primary" onclick="checkEmp();"
                           style="float:left;margin-right:5px;">保存</a>
                        <a class="btn btn-mini btn-danger" onclick="goBack();"
                           style="float:left;margin-right:5px;">关闭</a>
                    </div>
                </div>
            </div>
        </ul>
    </div>
    <div id="zhongxin">
        <input type="hidden" name="flag" id="flag" value="${msg }" title="修改页标志"/>
        <input type="hidden" name="editFlag" id="editFlag" value="${editFlag}" title="新增修改成功标志"/>
        <input type="hidden" name="ID" id="id" value="${emp.ID }" title="员工主键ID"/>
        <%-- <input type="hidden" name="EMP_DEPARTMENT_NAME" id="EMP_DEPARTMENT_NAME" value="${emp.EMP_DEPARTMENT_NAME }" title="员工部门名称" /> --%>
        <input type="hidden" name="kpiIdexStr" id="kpiIdexStr" value="" title="kpiIdex内容"/>

        <table style="margin-left: 50px;"><br>
            <tr>
                <td>
                    <label><font color="red">*</font>员工编号：</label>
                </td>
                <td>
                    <input type="text" name="EMP_CODE" id="emp_code"
                           value="${emp.EMP_CODE }" maxlength="32" placeholder="员工编号" title="员工编号"/>
                </td>
                <td style="padding-left: 30px;">
                    <label><font color="red">*</font>员工姓名：</label>
                </td>
                <td>
                    <input type="text" name="EMP_NAME" id="emp_name"
                           value="${emp.EMP_NAME }" maxlength="32" placeholder="姓名" title="姓名"/>
                </td>
                <td style="padding-left: 30px;">
                    <label><font color="red">*</font>员工性别：</label>
                </td>
                <td>
                    <input type="radio" name="EMP_GENDER" value="1"
                           <c:if test="${emp.EMP_GENDER == 1}">checked="checked"</c:if>>男
                    <input type="radio" name="EMP_GENDER" value="2"
                           <c:if test="${emp.EMP_GENDER == 2}">checked="checked"</c:if>>女
                </td>
            </tr>
            <tr>
                <td>
                    <label><font color="red">*</font>员工部门：</label>
                </td>
                <td>
                    <%-- <select id="EMP_DEPARTMENT_ID" name="EMP_DEPARTMENT_ID">
                        <option value="">请选择</option>
                        <!-- 员工部门循环 -->
                        <c:forEach items="${deptList }" var="deptList" varStatus="vs">
                            <option value="${deptList.ID}" <c:if test="${deptList.ID == emp.EMP_DEPARTMENT_ID}">selected</c:if> >
                                ${deptList.DEPT_NAME}
                            </option>
                        </c:forEach>
                    </select> --%>
                    <input type="text" id="EMP_DEPARTMENT_NAME" name="EMP_DEPARTMENT_NAME" autocomplete="off"
                           value="${emp.EMP_DEPARTMENT_NAME }" onclick="showDeptTree(this)" onkeydown="return false;"/>
                    <input type="hidden" id="EMP_DEPARTMENT_ID" name="EMP_DEPARTMENT_ID"
                           value="${emp.EMP_DEPARTMENT_ID }"/>
                    <div id="deptTreePanel" style="background-color:white;z-index: 1000;">
                        <ul id="deptTree" class="tree"></ul>
                    </div>
                </td>
                <td style="padding-left: 30px;">
                    <label><font color="red">*</font>员工岗位：</label>
                </td>
                <td>
                    <select id="EMP_GRADE_ID" name="EMP_GRADE_ID">
                        <option value=""></option>
                        <c:forEach items="${levelList }" var="level">
                            <option value="${level.ID }"
                                    <c:if test="${emp.EMP_GRADE_ID == level.ID}">selected</c:if> >
                                    ${level.GRADE_NAME }
                            </option>
                        </c:forEach>
                    </select>
                </td>
                <td style="padding-left: 30px;">
                    <label><font color="red">*</font>是否启用：</label>
                </td>
                <td>
                    <input type="radio" name="ENABLED" value="1"
                           <c:if test="${emp.ENABLED == 1}">checked="checked"</c:if>>是
                    <input type="radio" name="ENABLED" value="0"
                           <c:if test="${emp.ENABLED == 0}">checked="checked"</c:if>>否
                </td>
            </tr>
            <tr>
                <td>
                    <label>联系电话：</label>
                </td>
                <td>
                    <input type="text" name="EMP_PHONE" id="emp_phone"
                           value="${emp.EMP_PHONE }" maxlength="32" placeholder="联系电话" title="联系电话"/>
                </td>
                <td style="padding-left: 30px;">
                    <label>员工邮箱：</label>
                </td>
                <td>
                    <input type="text" name="EMP_EMAIL" id="emp_email"
                           value="${emp.EMP_EMAIL }" maxlength="32" placeholder="员工邮箱" title="员工邮箱"/>
                </td>
            </tr>
            <tr>
                <td style="padding-left: 30px;">
                    <label>员工职务：</label>
                </td>
                <td>
                    <select id="EMP_POSITION_CODE" name="EMP_POSITION_CODE">
                        <option value="0">请选择</option>
                        <!-- KPI模板循环 -->
                        <c:forEach items="${posList }" var="pos" varStatus="vs">
                            <option value="${pos.POSITION_CODE}"
                                    <c:if test="${pos.POSITION_CODE == emp.EMP_POSITION_CODE}">selected</c:if> >
                                    ${pos.POSITION_NAME}
                            </option>
                        </c:forEach>
                    </select>
                </td>
                <td style="padding-left: 30px;">
                    <label>备&nbsp;注：</label>
                </td>
                <td>
                    <input type="text" name="EMP_REMARK" id="EMP_REMARK emp_remark"
                           value="${emp.EMP_REMARK }" maxlength="32" placeholder="备注" title="备注"/>
                </td>
                <td style="display:none">
                    <select id="ATTACH_KPI_MODEL" name="ATTACH_KPI_MODEL" onchange="javascript:SelectModelChange();">
                        <option value="0">请选择</option>
                        <!-- KPI模板循环 -->
                        <c:forEach items="${kpiModelList }" var="kpiMode" varStatus="vs">
                            <option value="${kpiMode.ID}"
                                    <c:if test="${kpiMode.ID == emp.ATTACH_KPI_MODEL}">selected</c:if> >
                                    ${kpiMode.NAME}
                            </option>
                        </c:forEach>
                    </select>
                </td>
            </tr>
            <tr style="display:none">
                <td colspan="6">
                    <table id="kpiIndexTab" class="table table-striped table-bordered table-hover" data-min="11"
                           data-max="30" cellpadding="0" cellspacing="0" style="margin-top: 20px;">
                        <tr>
                            <td style="">KPI编号</td>
                            <td style="">KPI指标</td>
                            <td style="">类型</td>
                            <td style="">单位</td>
                            <td style="">1月</td>
                            <td style="">2月</td>
                            <td style="">3月</td>
                            <td style="">4月</td>
                            <td style="">5月</td>
                            <td style="">6月</td>
                            <td style="">7月</td>
                            <td style="">8月</td>
                            <td style="">9月</td>
                            <td style="">10月</td>
                            <td style="">11月</td>
                            <td style="">12月</td>
                            <td>分数(权重)</td>
                        </tr>
                        <tbody id="showDetail">

                        </tbody>
                    </table>
                </td>
            </tr>
        </table>
        <br>
        <!-- <div style="text-align: center;">
            <a class="btn btn-mini btn-primary" onclick="checkEmp();">保存</a>&nbsp;
            <a class="btn btn-mini btn-danger" onclick="goBack();">返回</a>
        </div> -->
    </div>

    <div id="zhongxin2" class="center" style="display:none"><br/><br/><br/><br/><img
            src="static/images/jiazai.gif"/><br/><h4 class="lighter block green"></h4></div>
</form>

<!-- 引入 -->
<script type="text/javascript">window.jQuery || document.write("<script src='static/js/jquery-1.9.1.min.js'>\x3C/script>");</script>
<script src="static/js/bootstrap.min.js"></script>
<script src="static/js/ace-elements.min.js"></script>
<script src="static/js/ace.min.js"></script>
<script type="text/javascript" src="static/js/chosen.jquery.min.js"></script><!-- 下拉框 -->
<script type="text/javascript" src="static/js/bootbox.min.js"></script><!-- 确认窗口 -->

<script type="text/javascript" src="plugins/zTree/jquery.ztree-2.6.min.js"></script>
<script type="text/javascript" src="static/deptTree/deptTree.js"></script>

<script type="text/javascript">
    //$(top.changeui());

    //部门选取控件
    $(function () {
        var setting = {
            checkable: false,
            checkType: {"Y": "", "N": ""},
            callback: {
                click: function () {
                    deptNodeClick();
                    getLevel();
                }
            }
        };

        $("#deptTree").deptTree(setting, ${deptTreeNodes}, 200, 218);
    });

    //关闭员工table页
    function goBack() {
        <%-- window.location.href = "<%=basePath%>employee/list.do"; --%>
        $(".tab_item2_selected", window.parent.document).siblings().find(".tab_close").trigger("click");
    }

    $(document).ready(function () {
        //KPI下拉框选取事件
        $("#ATTACH_KPI_MODEL").change(function () {
            var url = "<%=basePath%>/employee/modelDetail.do?ID=" + $("#ATTACH_KPI_MODEL").val();
            $.ajax({
                type: "POST",
                async: false,
                url: url,
                success: function (data) {     //回调函数，result，返回值
                    var obj = eval('(' + data + ')');
                    var shtml = "";
                    $.each(obj.list, function (i, list) {
                        shtml += '<tr><td>' + list.KPI_CODE + '</td>';
                        shtml += '<td>' + list.KPI_NAME + '</td>';
                        shtml += '<td>' + list.KPI_TYPE + '</td>';
                        shtml += '<td>' + list.KPI_UNIT + '</td>';
                        shtml += '<td><input type="text" id="JAN" style="width:35px;border:0;"></input></td>';
                        shtml += '<td><input type="text" id="FER" style="width:35px;border:0;"></input></td>';
                        shtml += '<td><input type="text" id="MAR" style="width:35px;border:0;"></input></td>';
                        shtml += '<td><input type="text" id="APR" style="width:35px;border:0;"></input></td>';
                        shtml += '<td><input type="text" id="MAY" style="width:35px;border:0;"></input></td>';
                        shtml += '<td><input type="text" id="JUN" style="width:35px;border:0;"></input></td>';
                        shtml += '<td><input type="text" id="JUL" style="width:35px;border:0;"></input></td>';
                        shtml += '<td><input type="text" id="AUG" style="width:35px;border:0;"></input></td>';
                        shtml += '<td><input type="text" id="SEP" style="width:35px;border:0;"></input></td>';
                        shtml += '<td><input type="text" id="OCT" style="width:35px;border:0;"></input></td>';
                        shtml += '<td><input type="text" id="NOV" style="width:35px;border:0;"></input></td>';
                        shtml += '<td><input type="text" id="DECE" style="width:35px;border:0;"></input></td>';
                        shtml += '<td><input type="text" id="SCORE" style="width:35px;border:0;"></input></td></tr>';
                    });
                    $("#showDetail").html(shtml);
                }
            });

        });

    });

    //员工部门下拉框选取事件
    <%-- $("#EMP_DEPARTMENT_NAME").click(function(){
        var url = "<%=basePath%>/employee/findDeptById.do?ID=" + $("#EMP_DEPARTMENT_ID").val();
        $.ajax({
            type: "POST",
            async:false,
            url: url,
            success:function (data){
                var deptName = data;
                $("#EMP_DEPARTMENT_NAME").val(deptName);
            }
        });
    });	 --%>
    //根据所选部门查询员工岗位级别
    function getLevel() {
        var url = "<%=basePath%>/employee/findLevelByDeptId.do?deptId=" + $("#EMP_DEPARTMENT_ID").val();
        $.ajax({
            type: "POST",
            async: false,
            url: url,
            success: function (data) {     //回调函数，result，返回值
                var obj = eval('(' + data + ')');
                var shtml = "<option value=''></option>";
                $.each(obj.list, function (i, list) {
                    shtml += '<option value=' + list.ID + '>' + list.GRADE_NAME + '</option>';
                });

                //alert(shtml);
                $("#EMP_GRADE_ID").html(shtml);
            }
        });
    }

    //员工岗位下拉框级联KPI模板事件
    $("#EMP_GRADE_ID").change(function () {
        var url = "<%=basePath%>/employee/findLevelKpi.do?kpiModelId=" + $("#EMP_GRADE_ID").val();
        $.ajax({
            type: "POST",
            async: false,
            url: url,
            success: function (data) {     //回调函数，result，返回值
                var kpiModelId = data;

                var url2 = "<%=basePath%>/employee/modelDetail.do?ID=" + kpiModelId;
                $.ajax({
                    type: "POST",
                    async: false,
                    url: url2,
                    success: function (data) {     //回调函数，result，返回值
                        var obj = eval('(' + data + ')');
                        var shtml = "";
                        $.each(obj.list, function (i, list) {
                            shtml += '<tr><td>' + list.KPI_CODE + '</td>';
                            shtml += '<td>' + list.KPI_NAME + '</td>';
                            shtml += '<td>' + list.KPI_TYPE + '</td>';
                            shtml += '<td>' + list.KPI_UNIT + '</td>';
                            shtml += '<td><input type="text" id="JAN" style="width:35px;border:0;"></input></td>';
                            shtml += '<td><input type="text" id="FER" style="width:35px;border:0;"></input></td>';
                            shtml += '<td><input type="text" id="MAR" style="width:35px;border:0;"></input></td>';
                            shtml += '<td><input type="text" id="APR" style="width:35px;border:0;"></input></td>';
                            shtml += '<td><input type="text" id="MAY" style="width:35px;border:0;"></input></td>';
                            shtml += '<td><input type="text" id="JUN" style="width:35px;border:0;"></input></td>';
                            shtml += '<td><input type="text" id="JUL" style="width:35px;border:0;"></input></td>';
                            shtml += '<td><input type="text" id="AUG" style="width:35px;border:0;"></input></td>';
                            shtml += '<td><input type="text" id="SEP" style="width:35px;border:0;"></input></td>';
                            shtml += '<td><input type="text" id="OCT" style="width:35px;border:0;"></input></td>';
                            shtml += '<td><input type="text" id="NOV" style="width:35px;border:0;"></input></td>';
                            shtml += '<td><input type="text" id="DECE" style="width:35px;border:0;"></input></td>';
                            shtml += '<td><input type="text" id="SCORE" style="width:35px;border:0;"></input></td></tr>';
                        });
                        $("#showDetail").html(shtml);
                    }
                });
            }
        });

    });

    //员工新增验证
    function checkEmp() {
        if ($("#emp_code").val() == "") {
            $("#emp_code").tips({
                side: 3,
                msg: '请输入员工编号',
                bg: '#AE81FF',
                time: 2
            });
            $("#emp_code").focus();
            return false;
        }
        var nameCheck = /^[a-zA-Z\u4e00-\u9fa5][a-zA-Z\u4e00-\u9fa5]*$/;
        if ($("#emp_name").val() == "" || !nameCheck.test($("#emp_name").val())) {
            $("#emp_name").tips({
                side: 3,
                msg: '请正确输入员工姓名',
                bg: '#AE81FF',
                time: 2
            });
            $("#emp_name").focus();
            return false;
        }
        if (typeof($("input:radio[name='EMP_GENDER']:checked").val()) == "undefined") {
            alert("请选择员工性别！");
            return false;
        }
        if ($("#EMP_DEPARTMENT_NAME").val() == "") {
            $("#EMP_DEPARTMENT_NAME").tips({
                side: 3,
                msg: '请选择员工部门',
                bg: '#AE81FF',
                time: 2
            });
            $("#EMP_DEPARTMENT_NAME").focus();
            return false;
        }
        if ($("#EMP_GRADE_ID").val() == "") {
            $("#EMP_GRADE_ID").tips({
                side: 3,
                msg: '请选择员工岗位',
                bg: '#AE81FF',
                time: 2
            });
            $("#EMP_GRADE_ID").focus();
            return false;
        }
        var phoneCheck = /^-?(?:\d+|\d{1,3}(?:,\d{3})+)(?:\.\d+)?$/;
        if ($("#emp_phone").val() != "") {
            if (!phoneCheck.test($("#emp_phone").val())) {
                $("#emp_phone").tips({
                    side: 3,
                    msg: '请正确输入电话',
                    bg: '#AE81FF',
                    time: 2
                });
                $("#emp_phone").focus();
                return false;
            }
        }
        var email = /^[a-z0-9]+([._\\-]*[a-z0-9])*@([a-z0-9]+[-a-z0-9]*[a-z0-9]+.){1,63}[a-z0-9]+$/;
        if ($("#emp_email").val() != "") {
            if (!email.test($("#emp_email").val())) {
                $("#emp_email").tips({
                    side: 3,
                    msg: '请正确输入员工邮箱',
                    bg: '#AE81FF',
                    time: 2
                });
                $("#emp_email").focus();
                return false;
            }
        }
        if (typeof($("input:radio[name='ENABLED']:checked").val()) == "undefined") {
            alert("请选择是否启用！");
            return false;
        }

        var url = "<%=basePath%>employee/checkEmployee.do?empCode=" + $('#emp_code').val() + "&msg=" + $("#flag").val() + "&id=" + $("#id").val();
        $.get(url, function (data) {
            if (data == "true") {
                save();
            } else {
                alert("该员工编号已存在！");
                $("#emp_code").focus();
                return;
            }
        }, "text");
    }

    //保存
    function save() {
        //清空原有隐藏input值
        $("#kpiIdexStr").val("");

        var kpiObj = "";
        var rows = document.getElementById("kpiIndexTab").rows.length;

        var checkNum = /^[-+]?[0-9]+([.]{1}[0-9]+){0,1}$/;

        //新增
        if ("save" == $("#flag").val()) {
            //下拉框已选取
            if (rows > 0) {
                //开始拼接json数组字符串
                kpiObj += "[";

                //table第一行为表头，从第二行开始获取每个td内容，无内容则赋空值
                for (var i = 1; i < rows; i++) {
                    var code = $("#kpiIndexTab tr:eq(" + i + ") td:eq(0)").text();
                    if (null == code || "" == code || "undefined" == typeof(code)) {
                        code = "''";
                    }

                    var jan = $("#kpiIndexTab tr:eq(" + i + ") td:eq(4)").find("input").val();
                    if (null == jan || "" == jan || "undefined" == typeof(jan)) {
                        jan = 0;
                    } else {
                        if (!checkNum.test(jan)) {
                            alert("1至12月数据仅能录入数字！");
                            return false;
                        }
                    }

                    var fer = $("#kpiIndexTab tr:eq(" + i + ") td:eq(5)").find("input").val();
                    if (null == fer || "" == fer || "undefined" == typeof(fer)) {
                        fer = 0;
                    } else {
                        if (!checkNum.test(fer)) {
                            alert("1至12月数据仅能录入数字！");
                            return false;
                        }
                    }

                    var mar = $("#kpiIndexTab tr:eq(" + i + ") td:eq(6)").find("input").val();
                    if (null == mar || "" == mar || "undefined" == typeof(mar)) {
                        mar = 0;
                    } else {
                        if (!checkNum.test(mar)) {
                            alert("1至12月数据仅能录入数字！");
                            return false;
                        }
                    }

                    var apr = $("#kpiIndexTab tr:eq(" + i + ") td:eq(7)").find("input").val();
                    if (null == apr || "" == apr || "undefined" == typeof(apr)) {
                        apr = 0;
                    } else {
                        if (!checkNum.test(apr)) {
                            alert("1至12月数据仅能录入数字！");
                            return false;
                        }
                    }

                    var may = $("#kpiIndexTab tr:eq(" + i + ") td:eq(8)").find("input").val();
                    if (null == may || "" == may || "undefined" == typeof(may)) {
                        may = 0;
                    } else {
                        if (!checkNum.test(may)) {
                            alert("1至12月数据仅能录入数字！");
                            return false;
                        }
                    }

                    var jun = $("#kpiIndexTab tr:eq(" + i + ") td:eq(9)").find("input").val();
                    if (null == jun || "" == jun || "undefined" == typeof(jun)) {
                        jun = 0;
                    } else {
                        if (!checkNum.test(jun)) {
                            alert("1至12月数据仅能录入数字！");
                            return false;
                        }
                    }

                    var jul = $("#kpiIndexTab tr:eq(" + i + ") td:eq(10)").find("input").val();
                    if (null == jul || "" == jul || "undefined" == typeof(jul)) {
                        jul = 0;
                    } else {
                        if (!checkNum.test(jul)) {
                            alert("1至12月数据仅能录入数字！");
                            return false;
                        }
                    }

                    var aug = $("#kpiIndexTab tr:eq(" + i + ") td:eq(11)").find("input").val();
                    if (null == aug || "" == aug || "undefined" == typeof(aug)) {
                        aug = 0;
                    } else {
                        if (!checkNum.test(aug)) {
                            alert("1至12月数据仅能录入数字！");
                            return false;
                        }
                    }

                    var sep = $("#kpiIndexTab tr:eq(" + i + ") td:eq(12)").find("input").val();
                    if (null == sep || "" == sep || "undefined" == typeof(sep)) {
                        sep = 0;
                    } else {
                        if (!checkNum.test(sep)) {
                            alert("1至12月数据仅能录入数字！");
                            return false;
                        }
                    }

                    var oct = $("#kpiIndexTab tr:eq(" + i + ") td:eq(13)").find("input").val();
                    if (null == oct || "" == oct || "undefined" == typeof(oct)) {
                        oct = 0;
                    } else {
                        if (!checkNum.test(oct)) {
                            alert("1至12月数据仅能录入数字！");
                            return false;
                        }
                    }

                    var nov = $("#kpiIndexTab tr:eq(" + i + ") td:eq(14)").find("input").val();
                    if (null == nov || "" == nov || "undefined" == typeof(nov)) {
                        nov = 0;
                    } else {
                        if (!checkNum.test(nov)) {
                            alert("1至12月数据仅能录入数字！");
                            return false;
                        }
                    }

                    var dece = $("#kpiIndexTab tr:eq(" + i + ") td:eq(15)").find("input").val();
                    if (null == dece || "" == dece || "undefined" == typeof(dece)) {
                        dece = 0;
                    } else {
                        if (!checkNum.test(dece)) {
                            alert("1至12月数据仅能录入数字！");
                            return false;
                        }
                    }

                    var score = $("#kpiIndexTab tr:eq(" + i + ") td:eq(16)").find("input").val();
                    if (null == score || "" == score || "undefined" == typeof(score)) {
                        score = 0;
                    } else {
                        if (!checkNum.test(score)) {
                            alert("分数(权重)请输入数字！");
                            return false;
                        }
                    }

                    kpiObj += "{KPI_CODE:'" + code + "'";
                    kpiObj += ",JAN:" + jan;
                    kpiObj += ",FER:" + fer;
                    kpiObj += ",MAR:" + mar;
                    kpiObj += ",APR:" + apr;
                    kpiObj += ",MAY:" + may;
                    kpiObj += ",JUN:" + jun;
                    kpiObj += ",JUL:" + jul;
                    kpiObj += ",AUG:" + aug;
                    kpiObj += ",SEP:" + sep;
                    kpiObj += ",OCT:" + oct;
                    kpiObj += ",NOV:" + nov;
                    kpiObj += ",DECE:" + dece;
                    kpiObj += ",SCORE:" + score + "}";
                    if (i != rows - 1) {
                        kpiObj += ",";
                    }
                }

                kpiObj += "]";
                $("#kpiIdexStr").val(kpiObj);
                //alert("kpiIdexStr:"+$("#kpiIdexStr").val());
            }
        }
        //修改
        if ("edit" == $("#flag").val()) {
            //开始拼接json数组字符串
            kpiObj += "[";

            //table第一行为表头，从第二行开始获取每个td内容，无内容则赋空值
            for (var i = 1; i < rows; i++) {
                var code = $("#kpiIndexTab tr:eq(" + i + ") td:eq(0)").text();
                if (null == code || "" == code || "undefined" == typeof(code)) {
                    code = "''";
                }

                var jan = $("#kpiIndexTab tr:eq(" + i + ") td:eq(4)").find("input").val();
                if (null == jan || "" == jan || "undefined" == typeof(jan)) {
                    jan = 0;
                } else {
                    if (!checkNum.test(jan)) {
                        alert("1至12月数据仅能录入数字！");
                        return false;
                    }
                }

                var fer = $("#kpiIndexTab tr:eq(" + i + ") td:eq(5)").find("input").val();
                if (null == fer || "" == fer || "undefined" == typeof(fer)) {
                    fer = 0;
                } else {
                    if (!checkNum.test(fer)) {
                        alert("1至12月数据仅能录入数字！");
                        return false;
                    }
                }

                var mar = $("#kpiIndexTab tr:eq(" + i + ") td:eq(6)").find("input").val();
                if (null == mar || "" == mar || "undefined" == typeof(mar)) {
                    mar = 0;
                } else {
                    if (!checkNum.test(mar)) {
                        alert("1至12月数据仅能录入数字！");
                        return false;
                    }
                }

                var apr = $("#kpiIndexTab tr:eq(" + i + ") td:eq(7)").find("input").val();
                if (null == apr || "" == apr || "undefined" == typeof(apr)) {
                    apr = 0;
                } else {
                    if (!checkNum.test(apr)) {
                        alert("1至12月数据仅能录入数字！");
                        return false;
                    }
                }

                var may = $("#kpiIndexTab tr:eq(" + i + ") td:eq(8)").find("input").val();
                if (null == may || "" == may || "undefined" == typeof(may)) {
                    may = 0;
                } else {
                    if (!checkNum.test(may)) {
                        alert("1至12月数据仅能录入数字！");
                        return false;
                    }
                }

                var jun = $("#kpiIndexTab tr:eq(" + i + ") td:eq(9)").find("input").val();
                if (null == jun || "" == jun || "undefined" == typeof(jun)) {
                    jun = 0;
                } else {
                    if (!checkNum.test(jun)) {
                        alert("1至12月数据仅能录入数字！");
                        return false;
                    }
                }

                var jul = $("#kpiIndexTab tr:eq(" + i + ") td:eq(10)").find("input").val();
                if (null == jul || "" == jul || "undefined" == typeof(jul)) {
                    jul = 0;
                } else {
                    if (!checkNum.test(jul)) {
                        alert("1至12月数据仅能录入数字！");
                        return false;
                    }
                }

                var aug = $("#kpiIndexTab tr:eq(" + i + ") td:eq(11)").find("input").val();
                if (null == aug || "" == aug || "undefined" == typeof(aug)) {
                    aug = 0;
                } else {
                    if (!checkNum.test(aug)) {
                        alert("1至12月数据仅能录入数字！");
                        return false;
                    }
                }

                var sep = $("#kpiIndexTab tr:eq(" + i + ") td:eq(12)").find("input").val();
                if (null == sep || "" == sep || "undefined" == typeof(sep)) {
                    sep = 0;
                } else {
                    if (!checkNum.test(sep)) {
                        alert("1至12月数据仅能录入数字！");
                        return false;
                    }
                }

                var oct = $("#kpiIndexTab tr:eq(" + i + ") td:eq(13)").find("input").val();
                if (null == oct || "" == oct || "undefined" == typeof(oct)) {
                    oct = 0;
                } else {
                    if (!checkNum.test(oct)) {
                        alert("1至12月数据仅能录入数字！");
                        return false;
                    }
                }

                var nov = $("#kpiIndexTab tr:eq(" + i + ") td:eq(14)").find("input").val();
                if (null == nov || "" == nov || "undefined" == typeof(nov)) {
                    nov = 0;
                } else {
                    if (!checkNum.test(nov)) {
                        alert("1至12月数据仅能录入数字！");
                        return false;
                    }
                }

                var dece = $("#kpiIndexTab tr:eq(" + i + ") td:eq(15)").find("input").val();
                if (null == dece || "" == dece || "undefined" == typeof(dece)) {
                    dece = 0;
                } else {
                    if (!checkNum.test(dece)) {
                        alert("1至12月数据仅能录入数字！");
                        return false;
                    }
                }

                var score = $("#kpiIndexTab tr:eq(" + i + ") td:eq(16) input:eq(0)").val();
                if (null == score || "" == score || "undefined" == typeof(score)) {
                    score = 0;
                } else {
                    if (!checkNum.test(score)) {
                        alert("分数(权重)请输入数字！");
                        return false;
                    }
                }

                var kpiIndexId = $("#kpiIndexTab tr:eq(" + i + ") td:eq(16) input:eq(1)").val();

                kpiObj += "{KPI_CODE:'" + code + "'";
                if (null != kpiIndexId && "" != kpiIndexId && "undefined" != typeof(kpiIndexId)) {
                    kpiObj += ",ID:" + kpiIndexId;
                }
                kpiObj += ",JAN:" + jan;
                kpiObj += ",FER:" + fer;
                kpiObj += ",MAR:" + mar;
                kpiObj += ",APR:" + apr;
                kpiObj += ",MAY:" + may;
                kpiObj += ",JUN:" + jun;
                kpiObj += ",JUL:" + jul;
                kpiObj += ",AUG:" + aug;
                kpiObj += ",SEP:" + sep;
                kpiObj += ",OCT:" + oct;
                kpiObj += ",NOV:" + nov;
                kpiObj += ",DECE:" + dece;
                kpiObj += ",SCORE:" + score + "}";
                if (i != rows - 1) {
                    kpiObj += ",";
                }
            }

            kpiObj += "]";
            $("#kpiIdexStr").val(kpiObj);
        }

        $("#employeeForm").submit();
    }

    //修改页kpiIndex列表加载
    window.onload = function () {
        if ($("#editFlag").val() == "saveSucc") {
            alert("新增成功！");
        }
        if ($("#editFlag").val() == "updateSucc") {
            alert("修改成功！");
        }

        if ("edit" == $("#flag").val()) {
            var url = "<%=basePath%>/kpiIndex/kpiDetail.do?empId=" + $("#id").val();
            $.ajax({
                type: "POST",
                async: false,
                url: url,
                success: function (data) {
                    var obj = eval('(' + data + ')');
                    var shtml = "";
                    $.each(obj.list, function (i, list) {
                        shtml += '<tr>';
                        shtml += '<td>' + list.KPI_CODE + '</td>';
                        shtml += '<td>' + list.KPI_NAME + '</td>';
                        shtml += '<td>' + list.KPI_TYPE + '</td>';
                        shtml += '<td>' + list.KPI_UNIT + '</td>';
                        shtml += '<td><input type="text" id="JAN" value=' + list.JAN + ' style="width:35px;border:0;"></input></td>';
                        shtml += '<td><input type="text" id="FER" value=' + list.FER + ' style="width:35px;border:0;"></input></td>';
                        shtml += '<td><input type="text" id="MAR" value=' + list.MAR + ' style="width:35px;border:0;"></input></td>';
                        shtml += '<td><input type="text" id="APR" value=' + list.APR + ' style="width:35px;border:0;"></input></td>';
                        shtml += '<td><input type="text" id="MAY" value=' + list.MAY + ' style="width:35px;border:0;"></input></td>';
                        shtml += '<td><input type="text" id="JUN" value=' + list.JUN + ' style="width:35px;border:0;"></input></td>';
                        shtml += '<td><input type="text" id="JUL" value=' + list.JUL + ' style="width:35px;border:0;"></input></td>';
                        shtml += '<td><input type="text" id="AUG" value=' + list.AUG + ' style="width:35px;border:0;"></input></td>';
                        shtml += '<td><input type="text" id="SEP" value=' + list.SEP + ' style="width:35px;border:0;"></input></td>';
                        shtml += '<td><input type="text" id="OCT" value=' + list.OCT + ' style="width:35px;border:0;"></input></td>';
                        shtml += '<td><input type="text" id="NOV" value=' + list.NOV + ' style="width:35px;border:0;"></input></td>';
                        shtml += '<td><input type="text" id="DECE" value=' + list.DECE + ' style="width:35px;border:0;"></input></td>';
                        shtml += '<td><input type="text" id="SCORE" value=' + list.SCORE + ' style="width:35px;border:0;"></input>';
                        shtml += '<input type="hidden" value=' + list.ID + '></input></td>';
                        shtml += '</tr>';
                    });

                    $("#showDetail").html(shtml);
                }
            });
        }
    };

    //KPI模板下拉事件
    function SelectModelChange() {
        var url = "<%=basePath%>/employee/modelDetail.do?ID=" + $("#ATTACH_KPI_MODEL").val();
        $.ajax({
            type: "POST",
            async: false,
            url: url,
            success: function (data) {     //回调函数，result，返回值
                var obj = eval('(' + data + ')');
                var shtml = "";
                $.each(obj.list, function (i, list) {
                    shtml += '<tr><td>' + list.KPI_CODE + '</td>';
                    shtml += '<td>' + list.KPI_NAME + '</td>';
                    shtml += '<td>' + list.KPI_TYPE + '</td>';
                    shtml += '<td>' + list.KPI_UNIT + '</td>';
                    shtml += '<td><input type="text" id="JAN" style="width:35px;border:0;"></input></td>';
                    shtml += '<td><input type="text" id="FER" style="width:35px;border:0;"></input></td>';
                    shtml += '<td><input type="text" id="MAR" style="width:35px;border:0;"></input></td>';
                    shtml += '<td><input type="text" id="APR" style="width:35px;border:0;"></input></td>';
                    shtml += '<td><input type="text" id="MAY" style="width:35px;border:0;"></input></td>';
                    shtml += '<td><input type="text" id="JUN" style="width:35px;border:0;"></input></td>';
                    shtml += '<td><input type="text" id="JUL" style="width:35px;border:0;"></input></td>';
                    shtml += '<td><input type="text" id="AUG" style="width:35px;border:0;"></input></td>';
                    shtml += '<td><input type="text" id="SEP" style="width:35px;border:0;"></input></td>';
                    shtml += '<td><input type="text" id="OCT" style="width:35px;border:0;"></input></td>';
                    shtml += '<td><input type="text" id="NOV" style="width:35px;border:0;"></input></td>';
                    shtml += '<td><input type="text" id="DECE" style="width:35px;border:0;"></input></td>';
                    shtml += '<td><input type="text" id="SCORE" style="width:35px;border:0;"></input></td></tr>';
                });
                $("#showDetail").html(shtml);
            }
        });
    }

</script>

</body>
</html>