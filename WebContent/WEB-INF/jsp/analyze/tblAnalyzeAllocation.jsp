<%@ page language="java" import="java.util.*" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
    String path = request.getContextPath();
    String basePath = request.getScheme() + "://"
            + request.getServerName() + ":" + request.getServerPort()
            + path + "/";
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <base href="<%=basePath%>">
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <link type="text/css" rel="StyleSheet"
          href="plugins/Bootstrap/css/bootstrap.min.css"/>
    <link type="text/css" rel="stylesheet"
          href="static/assets/css/font-awesome.min.css"/>
    <!-- 下拉框 -->
    <link rel="stylesheet" href="static/css/chosen.css"/>
    <link type="text/css" rel="stylesheet"
          href="static/assets/css/ace-rtl.min.css"/>
    <link type="text/css" rel="stylesheet"
          href="static/assets/css/ace-skins.min.css"/>
    <link type="text/css" rel="StyleSheet"
          href="plugins/Bootgrid/jquery.bootgrid.min.css"/>
    <link type="text/css" rel="stylesheet"
          href="static/css/font-awesome.min.css"/>
    <link type="text/css" rel="stylesheet"
          href="static/css/bootgrid.change.css"/>
    <link type="text/css" rel="StyleSheet" href="static/css/style.css"/>
    <script type="text/javascript" src="static/assets/js/ace-extra.min.js"></script>
    <script type="text/javascript" src="plugins/JQuery/jquery.min.js"></script>
    <script type="text/javascript"
            src="plugins/Bootstrap/js/bootstrap.min.js"></script>
    <script type="text/javascript"
            src="plugins/Bootgrid/jquery.bootgrid.min.js"></script>
    <script type="text/javascript" src="static/js/bootbox.min.js"></script>
    <script type="text/javascript" src="static/js/ace-elements.min.js"></script>
    <script type="text/javascript" src="static/js/chosen.jquery.min.js"></script>
    <!-- 下拉框 -->
    <script type="text/javascript"
            src="static/js/bootstrap-datepicker.min.js"></script>
    <!-- 日期框 -->
    <script type="text/javascript" src="static/js/bootbox.min.js"></script>
    <!-- 确认窗口 -->
    <script type="text/javascript" src="static/js/jquery.tips.js"></script>
    <!--提示框-->
    <script src="static/assets/js/typeahead-bs2.min.js"></script>
    <script src="static/assets/js/jquery-ui-1.10.3.custom.min.js"></script>
    <script src="static/assets/js/jquery.ui.touch-punch.min.js"></script>
    <script src="static/assets/js/jquery.slimscroll.min.js"></script>
    <script src="static/assets/js/jquery.easy-pie-chart.min.js"></script>
    <script src="static/assets/js/jquery.sparkline.min.js"></script>
    <script src="static/assets/js/flot/jquery.flot.min.js"></script>
    <script src="static/assets/js/flot/jquery.flot.pie.min.js"></script>
    <script src="static/assets/js/flot/jquery.flot.resize.min.js"></script>
    <script src="static/js/ace-elements.min.js"></script>
    <script src="static/js/ace.min.js"></script>
    <!-- 部门树 -->
    <link type="text/css" rel="stylesheet" href="plugins/zTree/zTreeStyle.css"/>
    <script type="text/javascript" src="plugins/zTree/jquery.ztree-2.6.min.js"></script>
    <script type="text/javascript" src="static/deptTree/deptTree.js"></script>

</head>

<body>
<div class="container-fluid" id="main-container">
    <div class="row">
        <div class="col-md-12">
            <div class="nav-search" id="nav-search"
                 style="right:5px;margin-top: 20px;" class="form-search">
                <div class="panel panel-default"
                     style="float:left;position: absolute;z-index: 1000;">
                    <div style="width: 100%;height: 20%;">
                        <table>
                            <tr>
                                <td>&nbsp;&nbsp; 部门：
                                    <input type="text" id="EMP_DEPARTMENT_NAME" name="EMP_DEPARTMENT_NAME"
                                           value="${initDeptName }" autocomplete="off"
                                           onclick="showDeptTree(this)" onkeydown="return false;"/>
                                    <input type="hidden" id="EMP_DEPARTMENT_ID" name="EMP_DEPARTMENT_ID"
                                           value="${initDeptId }"/>
                                    <div id="deptTreePanel" style="background-color:white;z-index: 1000;">
                                        <ul id="deptTree" class="tree"></ul>
                                    </div>
                                </td>
                                <td>&nbsp;&nbsp;员工: <select id="employee" style="width:170px;">
                                    <c:forEach items="${initEmpList}" var="emp">
                                        <option value="${emp.EMP_CODE}@${emp.EMP_NAME}@${emp.GRADE_CODE}"
                                                <c:if test="${emp.EMP_CODE == initEmpCode}">selected</c:if>>${emp.EMP_NAME}</option>
                                    </c:forEach>
                                </select>
                                </td>
                                <td>&nbsp;&nbsp;开始时间： <input class="date-picker"
                                                             id="startTime" name="startTime" type="text"
                                                             data-date-format="yyyy-mm-dd" style="width:170px;"
                                                             value="${initStartTime}"/></td>
                                <td>&nbsp;&nbsp;结束时间： <input class="date-picker"
                                                             id="endTime" name="endTime" type="text"
                                                             data-date-format="yyyy-mm-dd" style="width:170px;"
                                                             value="${initEndTime}"/>
                                </td>
                                <td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                                    <button type="button" class="btn btn-info btn-small"
                                            onClick="queryChart()">
                                        查询 <i class="icon-search icon-on-right bigger-110"></i>
                                    </button>
                                </td>

                            </tr>

                        </table>
                    </div>


                </div>
            </div>

            <div id="chart5" style="margin-top:150px;">
                <div id="piechart-placeholder" style="width:70%; height:350px;"></div>
            </div>
        </div>
    </div>
</div>
<script type="text/javascript">
    function searchEmp(deptId) {
        var url = "<%=basePath%>tblanalyze/queryDeptEmp.do?deptId=" + deptId;
        $
            .ajax({
                type: "POST",
                async: false,
                url: url,
                success: function (data) { //回调函数，result，返回值
                    var obj = eval('(' + data + ')');
                    var shtml = "<option value=''>请选择</option>";
                    $
                        .each(
                            obj.list,
                            function (i, list) {
                                shtml += '<option value=' + list.EMP_CODE + '@' + list.EMP_NAME + '@' + list.GRADE_CODE + '>'
                                    + list.EMP_NAME
                                    + '</option>';
                            });

                    $("#employee").html(shtml);
                }
            });
    }

    $(function () {

        var setting = {
            checkable: false,
            checkType: {"Y": "", "N": ""},
            callback: {
                click: function () {
                    deptNodeClick();
                    searchEmp($("#EMP_DEPARTMENT_ID").val());
                }
            }
        };

        $("#deptTree").deptTree(setting, ${deptTreeNodes}, 200, 218);
        //日期框
        $('.date-picker')
            .datepicker(
                {
                    format: 'yyyy-mm-dd',
                    changeMonth: true,
                    changeYear: true,
                    showButtonPanel: true,
                    autoclose: true,
                    minViewMode: 0,
                    maxViewMode: 2,
                    startViewMode: 0,
                    onClose: function (dateText, inst) {
                        var year = $(
                            "#span2 date-picker .ui-datepicker-year :selected")
                            .val();
                        $(this).datepicker('setDate',
                            new Date(year, 1, 1));
                    }
                });
        createTbl('${initEmpCode}', '${initEmpName}', '${initGradeCode}', '${initStartTime}', '${initEndTime}');

    });

    function drawPieChart(placeholder, data, position) {
        $.plot(placeholder, data, {
            series: {
                pie: {
                    show: true,
                    tilt: 1,
                    highlight: {
                        opacity: 0.9
                    },

                    stroke: {
                        color: '#fff',
                        width: 2
                    },
                    startAngle: 2,
                    offset: {
                        left: 10
                    }
                }
            },
            legend: {
                show: true,
                position: position || "ne",
                labelBoxBorderColor: null,
                margin: [-30, 30]
            }
            ,
            grid: {
                hoverable: true,
                clickable: true
            }
        });
    }

    //生成表格
    function queryChart() {
        var dept = $("#EMP_DEPARTMENT_NAME").val();
        if (dept == null || dept == '') {
            top.Dialog.alert("请选择部门!");
            return;
        }
        var employee = $("#employee").val();
        if (employee == null || employee == '') {
            top.Dialog.alert("请选择员工!");
            return;
        }
        var startTime = $("#startTime").val();
        if (startTime == null || startTime == '') {
            top.Dialog.alert("请选择开始时间!");
            return;
        }
        var endTime = $("#endTime").val();
        if (endTime == null || endTime == '') {
            top.Dialog.alert("请选择结束时间!");
            return;
        }
        if (startTime > endTime) {
            top.Dialog.alert("开始时间不能晚于结束时间!");
            return;
        }
        var empVal = $("#employee").val();
        var empCode = empVal.split("@")[0];
        var empName = empVal.split("@")[1];
        var GRADE_CODE = empVal.split("@")[2];
        var startTime = $("#startTime").val();
        var endTime = $("#endTime").val();
        createTbl(empCode, empName, GRADE_CODE, startTime, endTime);
    };

    function createTbl(empCode, empName, GRADE_CODE, startTime, endTime) {
        var url = "<%=basePath%>tblanalyze/queryAllocation.do?empCode=" + empCode + "&GRADE_CODE=" + GRADE_CODE + "&startTime=" + startTime + "&endTime=" + endTime;
        $.ajax({
            type: "POST",
            async: false,
            url: url,
            success: function (data) { //回调函数，result，返回值
                var obj = eval('(' + data + ')');
                if (obj.msg == null) {
                    top.Dialog.alert("没有数据!");
                    return;
                } else {
                    var placeholder = $('#piechart-placeholder');
                    var data = [];
                    $.each(obj.list, function (i, list) {
                        var col = "";
                        var res = i % 10;
                        if (res == 0) {
                            col = "#4f81bd";
                        }
                        if (res == 1) {
                            col = "#c0504d";
                        }
                        if (res == 2) {
                            col = "#9bbb59";
                        }
                        if (res == 3) {
                            col = "	#8064a2";
                        }
                        if (res == 4) {
                            col = "	#4bacc6";
                        }
                        if (res == 5) {
                            col = "	#f79646";
                        }
                        if (res == 6) {
                            col = "#5f7530";
                        }
                        if (res == 7) {
                            col = "#2c4d75";
                        }
                        if (res == 8) {
                            col = "#772c2a";
                        }
                        if (res == 9) {
                            col = "#b65708";
                        }
                        data.push({label: list.detail + list.use + "(小时)", data: list.duration, color: col});
                    });
                    drawPieChart(placeholder, data);
                    placeholder.data('chart', data);
                    placeholder.data('draw', drawPieChart);
                    var $tooltip = $("<div class='tooltip top in'><div class='tooltip-inner'></div></div>").hide().appendTo('body');
                    var previousPoint = null;
                    placeholder.on('plothover', function (event, pos, item) {
                        if (item) {
                            if (previousPoint != item.seriesIndex) {
                                previousPoint = item.seriesIndex;
                                var tip = item.series['label'];
                                $tooltip.show().children(0).text(tip);
                            }
                            $tooltip.css({top: pos.pageY + 10, left: pos.pageX + 10});
                        } else {
                            $tooltip.hide();
                            previousPoint = null;
                        }

                    });
                }
                ;

            }
        });
    }
</script>
</body>
</html>
