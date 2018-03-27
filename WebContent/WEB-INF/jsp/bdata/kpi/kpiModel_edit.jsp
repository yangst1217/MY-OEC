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
    <link href="static/css/bootstrap.min.css" rel="stylesheet"/>
    <link href="static/css/bootstrap-responsive.min.css" rel="stylesheet"/>
    <link rel="stylesheet" href="static/css/font-awesome.min.css"/>
    <!-- 下拉框 -->
    <link rel="stylesheet" href="static/css/chosen.css"/>

    <link rel="stylesheet" href="static/css/ace.min.css"/>
    <link rel="stylesheet" href="static/css/ace-responsive.min.css"/>
    <link rel="stylesheet" href="static/css/ace-skins.min.css"/>

    <link rel="stylesheet" href="static/css/datepicker.css"/><!-- 日期框 -->
    <script type="text/javascript" src="static/js/jquery-1.7.2.js"></script>
    <script type="text/javascript" src="static/js/jquery.tips.js"></script>

    <script type="text/javascript">
        //保存
        function save() {
            var nameCheck = /\s/;
            if ($("#NAME").val() == "" || nameCheck.test($("#NAME").val())) {
                $("#NAME").tips({
                    side: 3,
                    msg: '请正确输入名称',
                    bg: '#AE81FF',
                    time: 2
                });
                $("#NAME").focus();
                return false;
            }
            if (typeof($("input:radio[name='ENABLE']:checked").val()) == "undefined") {
                alert("请选择是否启用！");
                return false;
            }
            $("#Form").submit();
            $("#zhongxin").hide();
            $("#zhongxin2").show();
        }
    </script>
    <style>
        input[type="checkbox"], input[type="radio"] {
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
<form action="kpiModel/${msg}.do" name="Form" id="Form" method="post">
    <input type="hidden" name="MODEL_ID" id="ID" value="${pd.ID}"/>
    <input type="hidden" id="txtGroupsSelect" name="txtGroupsSelect" value="${txtRoleSelect}"/>
    <div id="zhongxin">
        <br>
        <table style="width: 100%">
            <tr>
                <td style="text-align: center;">
                    KPI模板名称：
                    <input type="text" name="NAME" id="NAME" value="${pd.NAME}" placeholder="这里输入名称" title="名称"/>
                    启用:
                    <input type="radio" name="ENABLE" value="1" style="opacity: 1;position: relative;"
                           <c:if test="${pd.ENABLE == 1}">checked="checked"</c:if>/>是
                    <input type="radio" name="ENABLE" value="0" style="opacity: 1;position: relative;"
                           <c:if test="${pd.ENABLE == 0}">checked="checked"</c:if>/>否
                </td>
            </tr>


            <tr>
                <td style="text-align: center;">
                    <hr style="height:1px;border:none;border-top:1px solid grey;margin: 6px 0;"/>
                    <table style="width: 100%;" name="groups_tweenbox" id="groups_tweenbox" cellspacing="0"
                           cellpadding="0">
                        <tbody>
                        <tr>


                            <td colspan="3">
                                KPI类型:
                                <select name="kpi_type" id="kpi_type" data-placeholder="KPI类型" onchange="chooseType()">
                                    <option value="">全部</option>
                                    <c:forEach items="${kpiTypeList}" var="kpiType">
                                        <option value="${kpiType.ID}">${kpiType.NAME}</option>
                                    </c:forEach>
                                </select>
                            </td>
                        </tr>
                        <tr>
                            <td>可选KPI</td>
                            <td></td>
                            <td>已选KPI</td>
                        </tr>
                        <tr>
                            <td style="text-align: center;">
                                <select id="groupsForSelect" multiple="multiple" style="height: 150px; width: 150px">
                                    <c:forEach items="${kpiList}" var="key">
                                        <option value="${key.ID}">${key.KPI_NAME}</option>
                                    </c:forEach>
                                </select>
                            </td>
                            <td style="text-align: center;">
                                <div style="margin-left: 5px; margin-right: 5px">
                                    <button onclick="unselectedAll()" class="btn btn-primary"
                                            type="button" style="width: 50px;line-height:20px;" title="全取消">&lt;&lt;
                                    </button>
                                </div>
                                <div style="margin-left: 5px; margin-right: 5px; margin-top: 5px;">
                                    <button onclick="unselected()" class="btn btn-primary"
                                            type="button" style="width: 50px;line-height:20px;" title="选择">&lt;
                                    </button>
                                </div>
                                <div style="margin-left: 5px; margin-right: 5px; margin-top: 5px;">
                                    <button onclick="selected()" class="btn btn-primary"
                                            type="button" style="width: 50px;line-height:20px;" title="取消">&gt;
                                    </button>
                                </div>
                                <div style="margin-left: 5px; margin-right: 5px; margin-top: 5px">
                                    <button onclick="selectedAll()" class="btn btn-primary"
                                            type="button" style="width: 50px;line-height:20px;" title="全选">&gt;&gt;
                                    </button>
                                </div>
                            </td>
                            <td style="text-align: center;">
                                <select id="selectGroups" multiple="multiple" name="selectGroups"
                                        style="height: 150px; width: 150px">
                                    <c:forEach items="${subCodeList}" var="key">
                                        <option value="${key.ID}">${key.KPI_NAME}</option>
                                    </c:forEach>
                                </select>
                            </td>
                        </tr>
                        </tbody>
                    </table>
                </td>
            </tr>
            <tr>
                <td style="text-align: center;">
                    <br>
                    <a class="btn btn-mini btn-primary" onclick="save();">保存</a>
                    <a class="btn btn-mini btn-danger" onclick="top.Dialog.close();">取消</a>
                </td>
            </tr>
        </table>
    </div>

    <div id="zhongxin2" class="center" style="display:none"><br/><br/><br/><br/><br/><img
            src="static/images/jiazai.gif"/><br/><h4 class="lighter block green">提交中...</h4></div>

</form>

<!-- 引入 -->
<script type="text/javascript">window.jQuery || document.write("<script src='static/js/jquery-1.9.1.min.js'>\x3C/script>");</script>
<script src="static/js/bootstrap.min.js"></script>
<script src="static/js/ace-elements.min.js"></script>
<script src="static/js/ace.min.js"></script>
<script type="text/javascript" src="static/js/chosen.jquery.min.js"></script><!-- 下拉框 -->
<script type="text/javascript" src="static/js/bootstrap-datepicker.min.js"></script><!-- 日期框 -->
<script type="text/javascript">
    //$(top.changeui());
    $(function () {

        //单选框
        $(".chzn-select").chosen();
        $(".chzn-select-deselect").chosen({allow_single_deselect: true});

        //日期框
        $('.date-picker').datepicker();

    });

</script>
<script type="text/javascript">
    $(document).ready(function () {
        $("#groupsForSelect").dblclick(function () {
            selected();
        });
        $("#selectGroups").dblclick(function () {
            unselected();
        });
    });

    function selected() {
        var selOpt = $("#groupsForSelect option:selected");

        selOpt.remove();
        var selObj = $("#selectGroups");
        selObj.append(selOpt);

        var selOpt = $("#selectGroups")[0];
        ids = "";
        for (var i = 0; i < selOpt.length; i++) {
            ids += (selOpt[i].value + ",");
        }

        if (ids != "") {
            ids = ids.substring(0, ids.length - 1);
        }
        $('#txtGroupsSelect').val(ids);
        //alert($('#txtGroupsSelect').val());
    }

    function selectedAll() {
        var selOpt = $("#groupsForSelect option");

        selOpt.remove();
        var selObj = $("#selectGroups");
        selObj.append(selOpt);

        var selOpt = $("#selectGroups")[0];
        ids = "";
        for (var i = 0; i < selOpt.length; i++) {
            ids += (selOpt[i].value + ",");
        }

        if (ids != "") {
            ids = ids.substring(0, ids.length - 1);
        }
        $('#txtGroupsSelect').val(ids);
    }

    function unselected() {
        var selOpt = $("#selectGroups option:selected");
        selOpt.remove();
        var selObj = $("#groupsForSelect");
        selObj.append(selOpt);

        var selOpt = $("#selectGroups")[0];
        ids = "";
        for (var i = 0; i < selOpt.length; i++) {
            ids += (selOpt[i].value + ",");
        }

        if (ids != "") {
            ids = ids.substring(0, ids.length - 1);
        }
        $('#txtGroupsSelect').val(ids);
    }

    function unselectedAll() {
        var selOpt = $("#selectGroups option");
        selOpt.remove();
        var selObj = $("#groupsForSelect");
        selObj.append(selOpt);

        $('#txtGroupsSelect').val("blank");
    }

    function chooseType() {

        var KPI_ID = $("#kpi_type").val();
        var model_id = $("#ID").val();
        var task_type_name = $("#kpi_type").find("option:selected").text();
        var url = "<%=basePath%>/kpiModel/changeText.do?KPI_ID=" + KPI_ID + "&MODEL_ID=" + model_id;
        $.get(url, function (data) {
            var groupsForSelect = $("#groupsForSelect");
            groupsForSelect.empty();
            var obj = eval('(' + data + ')');

            $.each(obj.kpiList, function (i, item) {
                var option = $("<option>").text(item.KPI_NAME).val(item.ID);
                $("#groupsForSelect").append(option);
            });


        });
    }
</script>
</body>
</html>