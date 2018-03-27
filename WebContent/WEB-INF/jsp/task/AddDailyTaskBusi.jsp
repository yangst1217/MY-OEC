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

    <style>

        #zhongxin td {
            height: 40px;
        }

        #zhongxin td label {
            text-align: right;
            margin-right: 8px;
        }

        /*设置上传附件样式*/
        #file label {
            width: 330px;
            padding: 0 6px;
            height: 100px;
        }

        #file label span {
            text-align: left;
            margin-top: -10px;
        }

        input {
            width: 330px
        }

        /*设置自适应框样式*/
        .test_box {
            width: 330px;
            min-height: 22px;
            _height: 120px;
            padding: 4px 6px;
            outline: 0;
            border: 1px solid #d5d5d5;
            font-size: 12px;
            word-wrap: break-word;
            overflow-x: hidden;
            overflow-y: auto;
            _overflow-y: visible;
        }

        input {
            width: auto;
        }
    </style>

    <!-- 引入 -->
    <script type="text/javascript" src="static/js/jquery-1.7.2.js"></script>
    <script src="static/js/bootstrap.min.js"></script>
    <script src="static/js/ace-elements.min.js"></script>
    <script src="static/js/ace.min.js"></script>
    <script type="text/javascript" src="static/js/chosen.jquery.min.js"></script>

    <!--提示框-->
    <script type="text/javascript" src="static/js/jquery.tips.js"></script>

    <script type="text/javascript">
        $(function () {
            top.changeui();
            $("#id-input-file-1").ace_file_input({
                style: 'well',
                btn_choose: '选择',
                btn_change: '修改',
                no_icon: 'icon-cloud-upload',
                droppable: true,
                onchange: null,
                thumbnail: 'small',
                before_change: function (files, dropped) {

                    return true;
                }

            }).on('change', function () {

            });
        });

        //检查长度是否超出
        function checkVal(divId, inputId, length, setVal) {
            var val = $(divId).text();
            if (val.length > length) {
                $(divId).tips({
                    side: 3,
                    msg: '长度不能超过' + length + '，请重新填写!',
                    bg: '#AE81FF',
                    time: 1
                });
                $(divId).focus();
            } else if (setVal) {
                $(inputId).attr("value", val);
            }
            return val.length > length;
        }

        //保存
        function check() {
            //检查本次完成工作量
            var regNum = /^(-)?\d+(\.\d{1,4})?$/;
            var dailyCountMsg = "";
            if ($("#dailyCount").val() == "" || null == $("#dailyCount").val()) {
                dailyCountMsg = "不能为空";
            } else if (!regNum.test($("#dailyCount").val())) {
                dailyCountMsg = "只可填入数字，最多四位小数";
            }
            if (dailyCountMsg != "") {
                $("#dailyCount").tips({
                    side: 3,
                    msg: dailyCountMsg,
                    bg: '#AE81FF',
                    time: 2
                });
                $("#dailyCount").focus();
                return false;
            }
            //检查说明输入的字符是否过长
            if (checkVal('#divAnalysis', '#analysis', 255, true)) {
                return;
            }
            if (checkVal('#divMeasure', '#measure', 255, true)) {
                return;
            }
            //本次工作量小于计划量时，差异分析和关差措施不能为空
            if ($("#dailyCount").val() <${pd.taskCount}) {
                var analysisEmpty = $("#analysis").val() == "" || $("#analysis").val() == null;
                var measureEmpty = $("#measure").val() == "" || $("#measure").val() == null;
                if (analysisEmpty) {
                    $("#divAnalysis").tips({
                        side: 3,
                        msg: '本次工作量小于计划量,请填写差异分析',
                        bg: '#AE81FF',
                        time: 2
                    });
                    $("#divAnalysis").focus();
                    return false;
                } else if (measureEmpty) {
                    $("#divMeasure").tips({
                        side: 3,
                        msg: '本次工作量小于计划量,请填写关差措施',
                        bg: '#AE81FF',
                        time: 2
                    });
                    $("#divMeasure").focus();
                    return false;
                }
            }
            /*
            var file = $("#file").val();
            if(null == file || file == ''){
                $("#completeForm").attr('action', 'employeeDaylyTask/complete.do');
            }else{
                $("#completeForm").attr('enctype', 'multipart/form-data');
            }
            */
            $("#Form").submit();
            $("#zhongxin").hide();
        }

    </script>
</head>
<body>
<form action="<%=basePath%>empDailyTask/saveDailyEmpTask.do" name="Form" id="Form" method="post"
      enctype="multipart/form-data">
    <input type="hidden" id="taskCount" value="${pd.taskCount }"/>
    <input type="hidden" name="weekTaskId" value="${pd.weekTaskId }"/>
    <input type="hidden" name="endDate" value="${pd.endDate }"/>
    <div id="zhongxin" style="width:98%; margin:0 auto; ">
        <table style="margin: 10px auto; ">
            <tr>
                <td width="100px"><label>周任务量：</label></td>
                <td colspan="3"><input type="text" id="weekCount" name="weekCount" value="${pd.weekCount }"
                                       readonly="readonly" style="width: 330px;"/></td>
            </tr>
            <tr>
                <td><label><span style="color:red">*</span>本次完成：</label></td>
                <td colspan="3"><input type="text" name="dailyCount" id="dailyCount" style="width: 330px;"
                                       onchange="getCount()"/></td>
            </tr>
            <c:if test="${task.TARGET_TYPE == 'XSH' }">
                <tr>
                    <td><label>客户名：</label></td>
                    <td><input type="text" name="customName" id="customName" style="width: 150px;"/></td>
                    <td><label>产品：</label></td>
                    <td>
                        <input type="text" readonly="readonly" style="width: 120px;" value="${task.PRODUCT_NAME}"/>
                    </td>
                </tr>
                <tr>
                    <td><label>销售量(吨)：</label></td>
                    <td><input type="text" id="MONEY_COUNT" name="MONEY_COUNT" style="width: 150px;"
                               onchange="getCount()"/></td>
                    <td><label>单价：</label></td>
                    <td><input type="text" name="price" id="price" readonly="readonly" style="width: 120px;"/></td>
                </tr>
            </c:if>
            <tr>
                <td><label>差异分析：</label></td>
                <td colspan="3">
                    <input type="hidden" name="analysis" id="analysis" placeholder="这里输入差异分析"/>
                    <div id="divAnalysis" class="test_box" contenteditable="true"
                         onkeyup="checkVal('#divAnalysis', '#analysis', 255, false)"></div>
                </td>
            </tr>
            <tr>
                <td><label>关差措施：</label></td>
                <td colspan="3">
                    <input type="hidden" name="measure" id="measure" placeholder="这里输入关差措施"/>
                    <div id="divMeasure" class="test_box" contenteditable="true"
                         onkeyup="checkVal('#divMeasure', '#measure', 255, false)"></div>
                </td>
            </tr>
            <tr>
                <td><label>上传附件：</label></td>
                <td colspan="3" id="file"><input multiple type="file" id="id-input-file-1" name="file"/></td>
            </tr>
            <tr>
                <td colspan="4" style="text-align: center;">
                    <a class="btn btn-mini btn-primary" onclick="check();">保存</a>
                    <a class="btn btn-mini btn-danger" onclick="top.Dialog.close();">取消</a>
                </td>
            </tr>
        </table>
    </div>


</form>
<script type="text/javascript">
    function getCount() {
        var dailyCountVal = $("#dailyCount").val();
        var moneyCountVal = $("#MONEY_COUNT").val();
        if ((dailyCountVal / moneyCountVal) != "Infinity") {
            $("#price").val(dailyCountVal / moneyCountVal);
        }
    }
</script>
</body>
</html>