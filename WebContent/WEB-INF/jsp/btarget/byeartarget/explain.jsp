<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%
    String path = request.getContextPath();
    String basePath = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort() + path + "/";
%>
<!DOCTYPE html>
<html>
<head>
    <title>公司年度经营目标分解</title>
    <base href="<%=basePath%>">
    <!-- jsp文件头和头部 -->
    <%@ include file="../../system/admin/top.jsp" %>
    <link href="static/css/style.css" rel="stylesheet"/>
    <link type="text/css" rel="stylesheet" href="plugins/zTree/zTreeStyle.css"/>

    <!-- 引入 -->
    <script type="text/javascript">window.jQuery || document.write("<script src='static/js/jquery-1.9.1.min.js'>\x3C/script>");</script>
    <script src="static/js/bootstrap.min.js"></script>
    <script src="static/js/ace-elements.min.js"></script>
    <script src="static/js/ace.min.js"></script>

    <script type="text/javascript" src="static/js/chosen.jquery.min.js"></script><!-- 下拉框 -->
    <script type="text/javascript" src="static/js/bootstrap-datepicker.min.js"></script><!-- 日期框 -->
    <script type="text/javascript" src="static/js/bootbox.min.js"></script><!-- 确认窗口 -->
    <script type="text/javascript" src="static/js/jquery.tips.js"></script><!--提示框-->
    <script type="text/javascript" src="plugins/zTree/jquery.ztree-2.6.min.js"></script>
    <script type="text/javascript" src="static/deptTree/deptTree.js"></script>
    <!-- 引入 -->

    <style>
        #target_table textarea {
            margin-top: 7px;
        }

        #target_table input {
            margin-top: 7px;
        }

        #zhongxin table tbody td {
            text-align: center;
            vertical-align: middle;
        }

        .label_left {
            width: 200px;
            text-align: left;
        }

        .label_right {
            width: 180px;
            text-align: right;
        }
    </style>
</head>
<body>
<input type="hidden" name="flag" id="flag" value="${flag}" title="新增修改成功标志"/>
<div id="deptTreePanel"
     style="display:none; position:absolute; background-color:white;overflow-y:auto;overflow-x:auto;height: 200px;width: 218px;border: 1px solid #CCCCCC;z-index: 1000;">
    <ul id="deptTree" class="tree" style="overflow: auto;padding: 0;margin: 0;"></ul>
</div>
<div class="tabbable tabs-below">
    <ul class="nav nav-tabs" id="menuStatus">
        <li>
            <img src="static/images/ui1.png" style="margin-top:-3px;">
            目标分解
        </li>
    </ul>
    <div class="nav-search" id="nav-search" style="right:5px;" class="form-search">
        <div style="float:left;" class="panel panel-default">
            <div>
                <a class="btn btn-mini btn-primary" onclick="saveAndArrange();"
                   style="float:left;margin-right:5px;">保存并生效</a>
                <c:if test="${target.ISEXPLAIN != '已分解（已生效）'}">
                    <a class="btn btn-mini btn-primary" onclick="save();"
                       style="float:left;margin-right:5px;">仅保存为草稿</a>
                </c:if>
                <a class="btn btn-mini btn-danger" onclick="goBack();"
                   style="float:left;margin-right:5px;">关闭</a>
            </div>
        </div>
    </div>
</div>
<div id="zhongxin">
    <!-- 基础信息开始-->
    <table style="margin-left: 50px;" id="target_table">
        <tr>
            <td>
                <label class="label_right">目标：</label>
            </td>
            <td colspan="3">
                <label class="label_left">${target.NAME}</label>
            </td>
        </tr>
        <tr>
            <td>
                <label class="label_right">年度：</label>
            </td>
            <td>
                <label class="label_left">${target.YEAR}</label>
            </td>
            <td>
                <label class="label_right">开始时间：</label>
            </td>
            <td>
                <label class="label_left">${target.START_DATE}</label>
            </td>
            <td>
                <label class="label_right">结束时间：</label>
            </td>
            <td>
                <label class="label_left">${target.END_DATE}</label>
            </td>
        </tr>
        <tr>
            <td>
                <label class="label_right">承接部门：</label>
            </td>
            <td>
                <label class="label_left">${target.DEPT_NAME}</label>
            </td>
            <td>
                <label class="label_right">承接责任人：</label>
            </td>
            <td>
                <label class="label_left">${target.EMP_NAME}</label>
            </td>
            <td>
                <label class="label_right">产品：</label>
            </td>
            <td>
                <label class="label_left">${target.PRODUCT_NAME}</label>
            </td>
        </tr>
        <tr>
            <td>
                <label class="label_right">经营指标：</label>
            </td>
            <td>
                <label class="label_left">${target.INDEX_NAME}</label>
            </td>
            <td>
                <label class="label_right">

                    目标数量/金额：</label>
            </td>
            <td>
                <label class="label_left">${target.COUNT} ${target.UNIT_NAME}</label>
            </td>
        </tr>
        <tr>
            <td>
                <label class="label_right">完成标准：</label>
            </td>
            <td colspan="3">
                <label class="label_left">${target.STANDARD}</label>
            </td>
        </tr>
    </table>
    <!-- 基础信息结束-->
    <hr style="height:1px;border:none;border-top:1px solid grey;margin: 6px 0;"/>
    <div class="row">
        <div class="span12">
            <div class="span6" style="text-align: left">
                <h4>分解列表</h4>
            </div>
            <div class="span5" style="text-align: right">
                <h4>
                    <a style="cursor:pointer;" title="添加分解" onclick="add()" class='btn btn-small btn-info'
                       data-rel="tooltip" data-placement="left">
                        <i class="icon-edit"></i>
                    </a>
                    <a style="cursor:pointer;" title="删除分解" onclick="del()" class='btn btn-small btn-danger'
                       data-rel="tooltip" data-placement="left">
                        <i class="icon-trash"></i>
                    </a>
                </h4>
            </div>
        </div>
        <form action="byeardepttask/add.do" name="Form" id="Form" method="post">
            <input type="hidden" value="${target.CODE}" name="B_YEAR_TARGET_CODE"/>
            <input type="hidden" value="${target.CODE}" name="CODE"/>
            <input type="hidden" value="${target.STATUS}" name="STATUS" id="STATUS"/>
            <input type="hidden" value="${PARENT_FRAME_ID}" name="PARENT_FRAME_ID" id="PARENT_FRAME_ID">
            <input name='isChanged' type='hidden' id='isChanged' value="0"/>
            <div class="span12">
                <!--分解表格-->
                <table id="explain_table" class="table table-striped table-bordered table-hover">
                    <thead>
                    <th class="center">
                        <label>
                            <input type="checkbox" id="zcheckbox"/>
                            <span class="lbl"></span>
                        </label>
                    </th>
                    <th>序号</th>
                    <th>承接部门</th>
                    <th>负责人</th>
                    <th>承接内容</th>
                    </thead>
                    <tbody>
                    <c:forEach items="${supTaskList}" var="task" varStatus="vs">
                        <tr>
                            <td>
                                <label>
                                    <input type='checkbox' name='ids' <c:if
                                            test="${task.STATUS == 'YW_YSX'}"> disabled </c:if>/>
                                    <span class='lbl'></span>
                                </label>
                                <input name='ID' type='hidden' value="${task.ID}"/>
                                <input name='STATUSES' type='hidden' value="${task.STATUS}"/>
                            </td>
                            <td class='center' style="width: 30px;" name='vs_td'>${vs.index+1}</td>
                            <td>
                                <input vs='${vs.index+1}' value='${task.DEPT_NAME}' type='text'
                                       id='dept_id${vs.index+1}' readonly='readonly' style='background: #fff!important;'
                                       onclick='showDept(this)' <c:if
                                        test="${task.STATUS == 'YW_YSX'}"> disabled</c:if>/>
                                <input name='DEPT_CODE' type='hidden' vs='${vs.index+1}' id='DEPT_CODE${vs.index+1}'
                                       value="${task.DEPT_CODE}"/>
                            </td>
                            <td>
                                <select id='EMP_CODE${vs.index+1}' name='EMP_CODE' <c:if
                                        test="${task.STATUS == 'YW_YSX'}"> disabled </c:if>>
                                    <option value="">请选择</option>
                                    <c:forEach items="${task.empList}" var="emp" varStatus="us">
                                        <option value="${emp.EMP_CODE}"
                                                <c:if test="${emp.EMP_CODE == task.EMP_CODE}">selected</c:if>>${emp.EMP_NAME}</option>
                                    </c:forEach>
                                </select>
                            </td>
                            <td>
                                <table>
                                    <tr>
                                        <td>产品</td>
                                        <td>数量/金额</td>
                                        <c:if test="${target.TARGET_TYPE == 'XSH'}">
                                            <td>销售量（吨）</td>
                                        </c:if>
                                        <td>操作</td>
                                    </tr>
                                    <c:forEach items="${task.explain}" var="explainItem">
                                        <tr>
                                            <td>
                                                <select name="product_${vs.index+1}">
                                                    <c:forEach items="${productList}" var="productItem">
                                                        <option value='${productItem.PRODUCT_CODE}'
                                                                <c:if test="${productItem.PRODUCT_CODE == explainItem.PRODUCT_CODE}">selected</c:if> >${productItem.PRODUCT_NAME}</option>
                                                    </c:forEach>
                                                </select>
                                            </td>
                                            <td><input name="count_${vs.index+1}" test='count'
                                                       onchange='checkNum($(this));getSum()' type='text'
                                                       value="${explainItem.COUNT }"/></td>
                                            <c:if test="${target.TARGET_TYPE == 'XSH'}">
                                                <td><input name="money_${vs.index+1}"
                                                           onchange="checkNum($(this));changeValue()" type='text'
                                                           value="${explainItem.MONEY_COUNT }"/></td>
                                            </c:if>
                                            <td>
                                                <a style='cursor:pointer;' title='删除分解' onclick='delExplain(this)'
                                                   class='btn btn-small btn-danger' data-rel='tooltip'
                                                   data-placement='left'>
                                                    <i class='icon-trash'></i>
                                                </a>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                    <tr>
                                        <c:choose>
                                        <c:when test="${target.TARGET_TYPE == 'XSH'}">
                                        <td colspan='4' style='text-align:center'>
                                            </c:when>
                                            <c:otherwise>
                                        <td colspan='3' style='text-align:center'>
                                            </c:otherwise>
                                            </c:choose>
                                            <input class='btn btn-small btn-info' onclick='addsplit(this,${vs.index+1})'
                                                   type='button' value='添加分解项'/>
                                        </td>
                                    </tr>
                                </table>
                            </td>
                        </tr>
                    </c:forEach>
                    <tr id="sum_tr">
                        <td colspan="4">
                            合计
                        </td>
                        <td id="sum_td">
                            ${target.COUNT_SUM}
                        </td>
                    </tr>
                    <tr>
                        <td colspan="4">
                            年度目标
                        </td>
                        <td id="count_td">
                            ${target.COUNT}
                        </td>
                    </tr>
                    </tbody>
                </table>
                <!--分解表格-->
            </div>
        </form>
    </div>
</div>
</body>
<!-- 按钮js -->
<script type="text/javascript">
    var targetType = '${target.TARGET_TYPE}';

    //添加分解
    function add() {
        var vs = document.getElementsByName('ids').length + 1;
        var ss = document.getElementsByName('ids').length + 1;
        for (var i = vs; 1 == $("#dept_id" + i).length; i++) {
            vs = i + 1;
        }

        var shtml = "<tr>";
        shtml += "<td><label><input type='checkbox' name='ids'/><span class='lbl'></span></label><input name='ID' type='hidden'/><input name='STATUSES' type='hidden'/></td>";
        shtml += "<td class='center' style='width: 30px;' name='vs_td'>" + ss + "</td>"
        shtml += "<td><input vs = '" + vs + "' value='' type='text' id='dept_id" + vs + "' readonly='readonly' style='background: #fff!important;' onclick='showDept(this)'/>"
        shtml += "<input name='DEPT_CODE' type='hidden' vs = '" + vs + "' id='DEPT_CODE" + vs + "'/></td>"
        shtml += "<td><select disabled='disabled' id='EMP_CODE" + vs + "' name='EMP_CODE'></select></td>"
        //shtml += "<td><input value='' onchange='checkNum($(this));getSum();' name='COUNT'/></td>"
        shtml += "<td>" +
            "   <table>" +
            "       <tr>" +
            "           <td>产品</td>" +
            "           <td>数量/金额</td>";
        if (targetType == 'XSH') {
            shtml += "<td>销售量（吨）</td>";
        }

        shtml += "           <td>操作</td>" +
            "       </tr>" +
            "       <tr>" +
            "           <td>" +
            "               <select name='product_" + ss + "'>";

        var products = ${products};

        for (var i = 0; i < products.length; i++) {
            shtml += "<option value='" + products[i].PRODUCT_CODE + "'>" + products[i].PRODUCT_NAME + "</option>";
        }

        shtml += "               </select>" +
            "           </td>" +
            "           <td><input name='count_" + ss + "' test='count' onchange='checkNum($(this));getSum()' type='text' value='0.00' /></td>";
        if (targetType == 'XSH') {
            shtml += "<td><input name='money_" + ss + "' onchange='checkNum($(this));changeValue()' type='text' value='0.00' /></td>";
        }

        shtml += "           <td>" +
            "<a style='cursor:pointer;' title='删除分解' onclick='delExplain(this)' class='btn btn-small btn-danger' data-rel='tooltip' data-placement='left'>" +
            "    <i class='icon-trash'></i>" +
            "</a>" +
            "</td>" +
            "       </tr>" +
            "       <tr>";
        if (targetType == 'XSH') {
            shtml += "<td colspan='4' style='text-align:center'>";
        } else {
            shtml += "<td colspan='3' style='text-align:center'>";
        }
        shtml += "               <input class='btn btn-small btn-info' onclick='addsplit(this," + ss + ")' type='button' value='添加分解项'/>" +
            "           </td>" +
            "       </tr>" +
            "   </table>" +
            "</td>";
        shtml += "</tr>"
        $("#sum_tr").before(shtml);
    }

    //删除分解
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
            bootbox.confirm("确定要批量删除吗?", function (result) {
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
                    printDeptTree();
                    var vsList = document.getElementsByName("vs_td");
                    for (var i = 0; i < vsList.length; i++) {
                        $(vsList[i]).html(Number(i) + 1);
                    }
                    getSum();
                    bootbox.hideAll()
                }
            })
        }
    }

    //关闭tab页
    function goBack() {
        $("#" + $('#PARENT_FRAME_ID').val(), window.parent.document).trigger("click");
        $("#page_" + $('#PARENT_FRAME_ID').val(), window.parent.document).attr('src', $("#page_" + $('#PARENT_FRAME_ID').val(), window.parent.document).attr('src'));
        $("#explain1", window.parent.document).children().find(".tab_close").trigger("click");
    }

    //保存并生效
    function saveAndArrange() {
        $("input[name='STATUSES']").each(function () {
            $(this).val("YW_YSX");
        });
        $("#STATUS").val("YW_YSX");
        save();
    }

    //仅保存为草稿
    function save() {
        //移除disable,后台方可取值
        $("#Form :disabled").each(function () {
            $(this).attr("disabled", false);
        });
        var objList = document.getElementsByName('ids');
        ;
        var deptList = document.getElementsByName('DEPT_CODE');
        var empList = document.getElementsByName('EMP_CODE');
        var countList = document.getElementsByName('COUNT');
        if (objList.length == 0) {//只有一个form外隐藏的，未添加
            top.Dialog.alert("请至少添加一个分解！");
            return false;
        }
        if (Number($("#sum_td").html()) < Number($("#count_td").html())) {
            top.Dialog.alert("您的拆分合计小于总目标！");
            return false;
        }
        for (var i = 0; i < deptList.length; i++) {
            if (null == deptList[i].value || "" == deptList[i].value) {
                $("#dept_id" + (Number(i) + 1).toString()).tips({
                    side: 3,
                    msg: '请选择组织部门！',
                    bg: '#AE81FF',
                    time: 2
                });
                $("#dept_id" + (Number(i) + 1).toString()).focus();
                return false;
            }
            ;
        }
        for (var i = 0; i < empList.length; i++) {
            if (null == empList[i].value || "" == empList[i].value) {
                $(empList[i]).tips({
                    side: 3,
                    msg: '请选择负责人！',
                    bg: '#AE81FF',
                    time: 2
                });
                $(empList[i]).focus();
                return false;
            }
            ;
        }
        for (var i = 0; i < countList.length; i++) {
            if (null == countList[i].value || "" == countList[i].value || 0 == Number(countList[i].value)) {
                $(countList[i]).tips({
                    side: 3,
                    msg: '请填写数字！',
                    bg: '#AE81FF',
                    time: 2
                });
                $(countList[i]).focus();
                return false;
            }
            ;
        }

        $("#Form").submit();
    }

    //复选框
    $('#explain_table th input:checkbox').on('click', function () {
        var that = this;
        $(this).closest('table').find('tr > td:first-child input:checkbox').not(':disabled')
            .each(function () {
                this.checked = that.checked;
                $(this).closest('tr').toggleClass('selected');
            });
    });

    //打印部门树
    $(function () {
        printDeptTree();
    });

    //是否保存成功
    window.onload = function () {
        if ($("#flag").val() == "success") {
            top.Dialog.alert("保存成功！");
        } else if ($("#flag").val() == "false") {
            top.Dialog.alert("保存失败！");
        }
    };


    //行序号
    var vs = '';

    //展开部门树
    function showDept($obj) {
        vs = $($obj).attr("vs");
        showDeptTree($obj);
    }

    //打印部门树
    function printDeptTree() {
        var deptList = document.getElementsByName('DEPT_CODE');
        var setting = {
            checkable: false,
            checkType: {"Y": "", "N": ""},
            fontCss: function (treeId, treeNode) {
                var color = {};
                for (var i = 0; i < deptList.length; i++) {
                    if (deptList[i].value == treeNode.DEPT_CODE) {
                        color = {color: "red"};
                    }
                }
                return color;
            },
            callback: {
                beforeClick: function (treeId, treeNode) {
                    for (var i = 0; i < deptList.length; i++) {
                        if (deptList[i].value == treeNode.DEPT_CODE) {
                            return false;
                        }
                    }
                    changeEmp(treeNode.DEPT_NAME, treeNode.DEPT_CODE, treeNode.DEPT_LEADER_ID, treeNode.ID);
                    return true;
                },
                click: function () {
                    hideDeptTree();
                    $("#deptTree").deptTree(setting, ${deptTreeNodes}, 200, 218);
                }
            }
        }
        $("#deptTree").deptTree(setting, ${deptTreeNodes}, 200, 218);
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
            $obj.val("0.00");
        }
    }

    //求和
    function getSum() {
        changeValue();
        var tdList = $("input[test='count']");
        var sum = Number(0);
        for (var i = 0; i < tdList.length; i++) {
            sum += Number(tdList[i].value);
        }
        $("#sum_td").html(sum);
    }

    //选择部门重填员工下拉框
    function changeEmp(dept_name, dept_code, dept_leader_id, dept_id) {
        $("#dept_id" + vs).val(dept_name);
        $("#DEPT_CODE" + vs).val(dept_code);
        $.ajax({
            type: "POST",
            url: '<%=basePath%>employee/findEmpByDept.do?timeStamp=' + new Date().getTime(),
            data: {deptId: dept_id},
            dataType: 'json',
            cache: false,
            success: function (data) {
                var empList = data.list;
                $('#EMP_CODE' + vs).attr("disabled", false);
                $("#EMP_CODE" + vs + " option").remove();
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
                $('#EMP_CODE' + vs).append(option);
            }
        });
    }

    //添加分解项
    function addsplit(obj, rowNum) {
        var products = ${products};
        var $tr = $(obj).parent().parent();
        var $tbody = $(obj).parent().parent().parent();

        if ($tbody.children().length >= products.length + 2) {
            top.Dialog.alert("分解项不能多于产品数");
            return false;
        }

        var htmlstr = "<tr><td><select name='product_" + rowNum + "'>";
        for (var i = 0; i < products.length; i++) {
            htmlstr += "<option value='" + products[i].PRODUCT_CODE + "'>" + products[i].PRODUCT_NAME + "</option>";
        }
        htmlstr += "</select></td>" +
            "           <td><input name='count_" + rowNum + "' test='count' onchange='checkNum($(this));getSum()' type='text' value='0.00'/></td>";
        if (targetType == 'XSH') {
            htmlstr += "<td><input name='money_" + rowNum + "' onchange='checkNum($(this));changeValue()' type='text' value='0.00'/></td>";
        }

        htmlstr += "           <td>" +
            "<a style='cursor:pointer;' title='删除分解' onclick='delExplain(this)' class='btn btn-small btn-danger' data-rel='tooltip' data-placement='left'>" +
            "    <i class='icon-trash'></i>" +
            "</a>" +
            "</td>" +
            "       </tr>";
        $tr.before(htmlstr);
    }

    //删除分解项
    function delExplain(obj) {
        $(obj).parent().parent().remove();
        changeValue();
    }

    function changeValue() {
        $("#isChanged").val("1");
    }
</script>
<!-- 行为js -->

</html>
