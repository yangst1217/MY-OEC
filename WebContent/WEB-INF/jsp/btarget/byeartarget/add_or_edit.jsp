<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%
    String path = request.getContextPath();
    String basePath = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort() + path + "/";
%>
<!DOCTYPE html>
<html>
<head>
    <title>新增年度经营目标</title>
    <base href="<%=basePath%>">
    <%@ include file="../../system/admin/top.jsp" %>
    <link href="static/css/style.css" rel="stylesheet"/>
    <link type="text/css" rel="stylesheet" href="plugins/zTree/zTreeStyle.css"/>

    <script type="text/javascript">window.jQuery || document.write("<script src='static/js/jquery-1.9.1.min.js'>\x3C/script>");</script>
    <script src="static/js/bootstrap.min.js"></script>
    <script src="static/js/ace-elements.min.js"></script>
    <script src="static/js/ace.min.js"></script>
    <link rel="stylesheet" href="static/css/chosen.css"/>
    <script type="text/javascript" src="static/js/chosen.jquery.min.js"></script><!-- 下拉框 -->
    <script type="text/javascript" src="static/js/bootstrap-datepicker.min.js"></script><!-- 日期框 -->
    <script type="text/javascript" src="static/js/bootbox.min.js"></script><!-- 确认窗口 -->
    <script type="text/javascript" src="static/js/jquery.tips.js"></script><!--提示框-->
    <script type="text/javascript" src="plugins/zTree/jquery.ztree-2.6.min.js"></script>
    <script type="text/javascript" src="static/deptTree/deptTree.js"></script>
    <style>
        #targetForm #zhongxin table tr label {
            margin-top: 7px;
        }

        #targetForm #zhongxin table tr input {
            margin-top: 7px;
        }

        #targetForm #zhongxin table tr select {
            margin-top: 7px;
        }

        #targetForm #zhongxin table tr textarea {
            margin-top: 7px;
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
<form action="byeartarget/${msg}.do" name="targetForm" id="targetForm" method="post">
    <input type="hidden" value="${target.STATUS}" id="STATUS" name="STATUS">
    <input type="hidden" value="${target.ID}" id="ID" name="ID">
    <input type="hidden" value="${target.CODE}" id="CODE" name="CODE">
    <input type="hidden" value="${target.CREATE_USER}" id="CREATE_USER" name="CREATE_USER">
    <input type="hidden" value="${target.CREATE_TIME}" id="CREATE_TIME" name="CREATE_TIME">
    <div id="zhongxin">
        <table style="margin: 0 auto">
            <tr>
                <td>
                    <label><span style="color: red; ">*</span>年度：</label>
                </td>
                <td>
                    <input value="${target.YEAR}" type="text" id="YEAR" name="YEAR" style="background:#fff!important;"
                           class="date-picker" data-date-format="yyyy" placeholder="请选择年度！" readonly="readonly"/>
                </td>
            </tr>
            <tr>
                <td>
                    <label><span style="color: red; ">*</span>目标：</label>
                </td>
                <td>
                    <textarea id="NAME" name="NAME" style="width:206px;">${target.NAME}</textarea>
                </td>
            </tr>
            <tr>
                <td>
                    <label><span style="color: red; ">*</span>完成期限：</label>
                </td>
                <td>
                    <input type="text" id="START_DATE" name="START_DATE" style="width:87px;background:#fff!important;"
                           value="${target.START_DATE}"
                           class="date-picker" data-date-format="yyyy-mm-dd" placeholder="请选择年月日！" readonly="readonly"/>
                    至
                    <input type="text" id="END_DATE" name="END_DATE" style="width:87px;background:#fff!important;"
                           value="${target.END_DATE}"
                           class="date-picker" data-date-format="yyyy-mm-dd" placeholder="请选择年月日！" readonly="readonly"/>
                </td>
            </tr>
            <tr>
                <td>
                    <label><span style="color: red; ">*</span>目标类型：</label>
                </td>
                <td>
                    <select id="TARGET_TYPE" name="TARGET_TYPE" onchange="typeChange()">
                        <c:forEach items="${productType}" var="type">
                            <option value="${type.BIANMA }"
                                    <c:if test="${target.TARGET_TYPE == type.BIANMA}">selected</c:if>>${type.NAME}</option>
                        </c:forEach>
                    </select>
                </td>
            </tr>
            <tr>
                <td>
                    <label><span style="color: red; ">*</span>承接部门：</label>
                </td>
                <td>
                    <input value="${target.DEPT_NAME}" type="text" id="dept_id" readonly="readonly"
                           style="background: #fff!important;" onclick="showDeptTree(this)"/>
                    <input type="hidden" id="DEPT_CODE" name="DEPT_CODE" value="${target.DEPT_CODE}">
                    <div id="deptTreePanel"
                         style="display:none; position:absolute; background-color:white;overflow-y:auto;overflow-x:auto;height: 200px;width: 218px;border: 1px solid #CCCCCC;z-index: 1000;">
                        <ul id="deptTree" class="tree" style="overflow: auto;padding: 0;margin: 0;"></ul>
                    </div>
                </td>
            </tr>
            <tr>
                <td>
                    <label><span style="color: red; ">*</span>承接责任人：</label>
                </td>
                <td>
                    <c:if test="${'add' == msg}">
                        <select id="EMP_CODE" name="EMP_CODE" disabled="disabled"></select>
                    </c:if>
                    <c:if test="${'edit' == msg}">
                        <select id="EMP_CODE" name="EMP_CODE">
                            <option value="">请选择</option>
                            <c:forEach items="${empList}" var="emp" varStatus="vs">
                                <option value="${emp.EMP_CODE}"
                                        <c:if test="${emp.EMP_CODE == target.EMP_CODE}">selected</c:if>>${emp.EMP_NAME}</option>
                            </c:forEach>
                        </select>
                    </c:if>
                </td>
            </tr>
            <tr>
                <td>
                    <label><span style="color: red; ">*</span>产品：</label>
                </td>
                <td>
                    <select multiple class="chzn-select" data-placeholder="点击选择产品，可多选" id="PRODUCT_CODE"
                            name="PRODUCT_CODE">
                        <option value=""></option>
                        <c:forEach items="${proList}" var="pro">
                            <option value="${pro.PRODUCT_CODE}"
                                    <c:forEach items="${projectSelected}" var="proSelected">
                                        <c:if test="${proSelected == pro.PRODUCT_CODE}">selected</c:if>
                                    </c:forEach>
                            >${pro.PRODUCT_NAME}</option>
                        </c:forEach>
                    </select>
                </td>
            </tr>
            <tr>
                <td>
                    <label><span style="color: red; ">*</span>经营指标：</label>
                </td>
                <td>
                    <select id="INDEX_CODE" name="INDEX_CODE">
                        <option value="">请选择</option>
                        <c:forEach items="${indexList}" var="index" varStatus="vs">
                            <option value="${index.INDEX_CODE}"
                                    <c:if test="${index.INDEX_CODE == target.INDEX_CODE}">selected</c:if>>${index.INDEX_NAME}</option>
                        </c:forEach>
                    </select>
                </td>
            </tr>
            <tr>
                <td>
                    <label><span style="color: red; ">*</span>目标数量/金额：</label>
                </td>
                <td>
                    <input onchange="checkNum($(this));"
                           value="${target.COUNT}" type="text" id="COUNT" name="COUNT"
                           placeholder="可带四位小数！"/>
                </td>
            </tr>
            <tr>
                <td>
                    <label><span style="color: red; ">*</span>单位：</label>
                </td>
                <td>
                    <select id="UNIT_CODE" name="UNIT_CODE">
                        <option value="">请选择</option>
                        <c:forEach items="${unitList}" var="unit" varStatus="vs">
                            <option value="${unit.UNIT_CODE}"
                                    <c:if test="${unit.UNIT_CODE == target.UNIT_CODE}">selected</c:if>>${unit.UNIT_NAME}</option>
                        </c:forEach>
                    </select>
                </td>
            </tr>
            <tr id="money_tr" <c:if test="${target.TARGET_TYPE != 'XSH'}">style="display:none;"</c:if>>
                <td>
                    <label>销售数量(吨)：</label>
                </td>
                <td>
                    <input type="text" id="MONEY_COUNT" name="MONEY_COUNT" style="width:206px;"
                           onchange="checkNum($(this));" value="${target.MONEY_COUNT}"/>
                </td>
            </tr>
            <tr>
                <td>
                    <label>完成标准：</label>
                </td>
                <td>
                    <textarea id="STANDARD" name="STANDARD" style="width:206px;">${target.STANDARD}</textarea>
                </td>
            </tr>
        </table>
    </div>
    <br/>
    <!--按钮组-->
    <div style="text-align: center;">
        <a class="btn btn-mini btn-primary" onclick="save();">保存</a>&nbsp;
        <a class="btn btn-mini btn-danger" onclick="top.Dialog.close();">取消</a>
    </div>
    <!--按钮组-->
</form>
<!-- 预加载js -->
<script type="text/javascript">
    //日期框
    $(function () {
        $(".chzn-select").chosen({
            no_results_text: "没有匹配结果",
            disable_search: false
        });

        $('#YEAR').datepicker({
            format: 'yyyy',
            changeMonth: true,
            changeYear: true,
            showButtonPanel: true,
            autoclose: true,
            minViewMode: 2,
            maxViewMode: 2,
            startViewMode: 0,
            onClose: function (dateText, inst) {
                var year = $("#span2 date-picker .ui-datepicker-year :selected").val();
                $(this).datepicker('setDate', new Date(year, 1, 1));
            }
        });
        $('#START_DATE').datepicker({
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
        $('#END_DATE').datepicker({
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

        var setting = {
            checkable: false,
            checkType: {"Y": "", "N": ""},
            callback: {
                beforeClick: function (treeId, treeNode) {
                    changeEmp(treeNode.DEPT_NAME, treeNode.DEPT_CODE, treeNode.DEPT_LEADER_ID, treeNode.ID);
                },
                click: function () {
                    hideDeptTree();
                }
            }
        }
        $("#deptTree").deptTree(setting, ${deptTreeNodes}, 200, 218);
    });

    //选择部门重填员工下拉框
    function changeEmp(dept_name, dept_code, dept_leader_id, dept_id) {
        $("#dept_id").val(dept_name);
        $("#DEPT_CODE").val(dept_code);
        $.ajax({
            type: "POST",
            url: '<%=basePath%>employee/findEmpByDept.do?timeStamp=' + new Date().getTime(),
            data: {deptId: dept_id},
            dataType: 'json',
            cache: false,
            success: function (data) {
                var empList = data.list;
                $('#EMP_CODE').attr("disabled", false);
                $("#EMP_CODE option").remove();
                if (empList.length != 0) {
                    var option = "<option value=''>请选择</option>";
                    for (var i = 0; i < empList.length; i++) {
                        option += "<option value='" + empList[i].EMP_CODE + "' ";
                        if (empList[i].ID == dept_leader_id) {
                            option += "selected";
                        }
                        option += ">" + empList[i].EMP_NAME + "</option>";
                    }
                } else {
                    var option = "<option value=''>无员工</option>";
                }
                $("#EMP_CODE").append(option);
            }
        })
    }

    //检验时间是否正确
    function checkDate() {
        if (null != $("#END_DATE").val() && '' != $("#END_DATE").val() && null != $("#START_DATE").val() && '' != $("#START_DATE").val()) {
            var END_DATE = new Date($("#END_DATE").val().replace(/-/ig, '/'));
            var START_DATE = new Date($("#START_DATE").val().replace(/-/ig, '/'));
            if (START_DATE > END_DATE) {
                $("#START_DATE").tips({
                    side: 3,
                    msg: '请确保开始时间早于结束时间！',
                    bg: '#AE81FF',
                    time: 2
                });
                $("#START_DATE").focus();
                $("#START_DATE").val("");
                $("#searchButton").attr("disabled", "disabled");
                return false;
            } else {
                $("#searchButton").attr("disabled", false);
            }
        }
    }

    //检验是否是数字
    function checkNum($obj) {
        if (!(/^(([1-9]\d*)|0)(\.\d{1,4})?$/).test($obj.val())) {
            $obj.tips({
                side: 3,
                msg: '只可填入数字，最多四位小数',
                bg: '#AE81FF',
                time: 2
            });
            $obj.focus();
            $obj.val("");
        }
    }

    //保存
    function save() {
        if (null == $("#YEAR").val() || "" == $("#YEAR").val()) {
            $("#YEAR").tips({
                side: 3,
                msg: '请选择年度！',
                bg: '#AE81FF',
                time: 2
            });
            $("#YEAR").focus();
            return false;
        }
        ;
        if (null == $("#START_DATE").val() || "" == $("#START_DATE").val()) {
            $("#START_DATE").tips({
                side: 3,
                msg: '请选择完成期限！',
                bg: '#AE81FF',
                time: 2
            });
            $("#START_DATE").focus();
            return false;
        }
        ;
        if (null == $("#END_DATE").val() || "" == $("#END_DATE").val()) {
            $("#END_DATE").tips({
                side: 3,
                msg: '请选择完成期限！',
                bg: '#AE81FF',
                time: 2
            });
            $("#END_DATE").focus();
            return false;
        }
        ;
        if (null == $("#NAME").val() || "" == $("#NAME").val()) {
            $("#NAME").tips({
                side: 3,
                msg: '请输入目标！',
                bg: '#AE81FF',
                time: 2
            });
            $("#NAME").focus();
            return false;
        }
        ;
        if (null == $("#DEPT_CODE").val() || "" == $("#DEPT_CODE").val()) {
            $("#DEPT_CODE").tips({
                side: 3,
                msg: '请设置组织部门！',
                bg: '#AE81FF',
                time: 2
            });
            $("#DEPT_CODE").focus();
            return false;
        }
        ;
        if (null == $("#EMP_CODE").val() || "" == $("#EMP_CODE").val()) {
            $("#EMP_CODE").tips({
                side: 3,
                msg: '请设置承接责任人！',
                bg: '#AE81FF',
                time: 2
            });
            $("#EMP_CODE").focus();
            return false;
        }
        ;
        if (null == $("#PRODUCT_CODE").val() || "" == $("#PRODUCT_CODE").val()) {
            $("#PRODUCT_CODE").tips({
                side: 3,
                msg: '请设置产品！',
                bg: '#AE81FF',
                time: 2
            });
            $("#PRODUCT_CODE").focus();
            return false;
        }
        ;
        if (null == $("#INDEX_CODE").val() || "" == $("#INDEX_CODE").val()) {
            $("#INDEX_CODE").tips({
                side: 3,
                msg: '请设置经营指标！',
                bg: '#AE81FF',
                time: 2
            });
            $("#INDEX_CODE").focus();
            return false;
        }
        ;
        if (null == $("#UNIT_CODE").val() || "" == $("#UNIT_CODE").val()) {
            $("#UNIT_CODE").tips({
                side: 3,
                msg: '请设置单位！',
                bg: '#AE81FF',
                time: 2
            });
            $("#UNIT_CODE").focus();
            return false;
        }
        ;
        var END_DATE = new Date($("#END_DATE").val().replace(/-/ig, '/'));
        var START_DATE = new Date($("#START_DATE").val().replace(/-/ig, '/'));
        if (START_DATE > END_DATE) {
            $("#START_DATE").tips({
                side: 3,
                msg: '请确保完成期限的开始时间不大于结束时间！',
                bg: '#AE81FF',
                time: 2
            });
            $("#START_DATE").focus();
            return false;
        }

        var cycleCheck = /^(([1-9]\d*)|0)(\.\d{1,4})?$/;
        if ($("#COUNT").val() == "" || !cycleCheck.test($("#COUNT").val())) {
            $("#COUNT").tips({
                side: 3,
                msg: '请正确填写目标数目',
                bg: '#AE81FF',
                time: 2
            });
            $("#COUNT").focus();
            return false;
        }
        if ($("#MONEY_COUNT").val() != "" && !cycleCheck.test($("#MONEY_COUNT").val())) {
            $("#MONEY_COUNT").tips({
                side: 3,
                msg: '请正确填写目标金额',
                bg: '#AE81FF',
                time: 2
            });
            $("#COUNT").focus();
            return false;
        }

        $("#targetForm").submit();
    };

    function typeChange() {
        var type = $("#TARGET_TYPE").val();
        if (type == 'XSH') {
            $("#money_tr").show();
        } else {
            $("#money_tr").hide();
        }

        $.ajax({
            url: "product/findByType.do",
            data: {"type": type},
            success: function (data) {
                $("#PRODUCT_CODE").chosen("destroy");
                $("#PRODUCT_CODE").empty();

                for (var i = 0; i < data.length; i++) {
                    $("#PRODUCT_CODE").append("<option value='" + data[i].PRODUCT_CODE + "'>" + data[i].PRODUCT_NAME + "</option>");
                }
                $("#PRODUCT_CODE").chosen({
                    no_results_text: "没有匹配结果",
                    disable_search: false
                });
            }
        });
    }
</script>
</body>
</html>
