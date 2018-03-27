<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
    String path = request.getContextPath();
    String basePath = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort() + path + "/";
%>
<!DOCTYPE html>
<html lang="zh_CN">
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
    <link rel="stylesheet" href="static/css/ace.min.css"/>
    <link rel="stylesheet" href="static/css/ace-responsive.min.css"/>
    <link rel="stylesheet" href="static/css/ace-skins.min.css"/>
    <link rel="stylesheet" href="static/css/chosen.css"/>
    <link rel="stylesheet" href="static/css/datepicker.css"/>
    <link type="text/css" rel="stylesheet" href="plugins/zTree/zTreeStyle.css"/>
</head>
<body>
<form action="cpNode/saveNode.do" name="nodeForm" id="nodeForm" method="post">
    <input type="hidden" name="ID" id="ID" value="${node.ID }"/>
    <input type="hidden" name="STATUS" id="STATUS" value="${node.STATUS }"/>
    <div id="zhongxin">
        <table style="margin: 0 auto">
            <tr>
                <td><span style="color: red;">*</span>节点名称：</td>
                <td colspan="3">
                    <input type="text" name="NODE_TARGET" id="nodeTarget" value="${node.NODE_TARGET}"
                           style="width:512px"/>
                </td>
                <!--
						<td><span style="color: red;">*</span>节点层级：</td>
						<td>
							<select class="chzn-select" data-placeholder="请选择节点层级" name="PROJECT_NODE_LEVEL_ID" id="nodeLevel" >
						  		<c:forEach items="${nodelLevels}" var="item">
						  			<option value="${item.ID }" <c:if test="${item.ID == node.PROJECT_NODE_LEVEL_ID}">selected</c:if> >${item.NODE_LEVEL }</option>
						  		</c:forEach>
						  	</select>
						</td>
						 -->
            </tr>
            <tr>
                <td><span style="color: red;">*</span>重点协同项目：</td>
                <td>
                    <input type="text" disabled="disabled" value="${node.PROJECT_NAME}">
                    <input type="hidden" name="C_PROJECT_CODE" value="${node.C_PROJECT_CODE}">
                </td>
                <td>上级节点：</td>
                <td>
                    <input type="text" disabled="disabled" value="${node.PARENT_NAME}">
                    <input type="hidden" name="PARENT_ID" value="${node.PARENT_ID}">
                </td>
            </tr>
            <tr>
                <td><span style="color: red;">*</span>承接部门：</td>
                <td>
                    <input autocomplete="off" data-placeholder="点击选择承接部门" id="dept_id" onclick="showDeptTree(this)"
                           type="text" value="${node.DEPT_NAME }"/>
                    <input type="hidden"/>
                    <input type="hidden" name="DEPT_CODE" id="deptCode" value="${node.DEPT_CODE}">
                    <div id="deptTreePanel" style="background-color:white;z-index: 1000;">
                        <ul id="deptTree" class="tree"></ul>
                    </div>
                </td>
                <td><span style="color: red;">*</span>承接责任人：</td>
                <td>
                    <select class="chzn-select" data-placeholder="请先选择承接责任人" name="EMP_CODE" id="empCode">
                        <c:forEach items="${emps}" var="emp">
                            <option value="${emp.EMP_CODE }"
                                    <c:if test="${node.EMP_CODE == emp.EMP_CODE}">selected</c:if> >${emp.EMP_NAME }</option>
                        </c:forEach>
                    </select>
                </td>
            </tr>
            <tr>
                <td><span style="color: red;">*</span>达成时间：</td>
                <td><input type="text" name="PLAN_DATE" id="endpicker" value="${node.PLAN_DATE}"/></td>
                <td>权重(%)：</td>
                <td>
                    <input type="number" min="1" max="100" name="WEIGHT" id="weight" value="${node.WEIGHT}">
                </td>
            </tr>
            <tr>
                <td>备注：</td>
                <td colspan="3">
                    <textarea name="DESCP" id="desc" style="width:512px;">${node.DESCP}</textarea>
                </td>
            </tr>
            <tr>
                <td style="text-align: center;" colspan="4">
                    <a class="btn btn-mini btn-primary" onclick="save();">保存</a>
                    <c:if test="${node.STATUS != 'YW_YSX'}">
                        <a class="btn btn-mini btn-info" onclick="refer();">生效</a>
                    </c:if>
                    <a class="btn btn-mini btn-danger" onclick="javascript:history.go(-1)">取消</a>
                </td>
            </tr>
        </table>
    </div>
    <div id="zhongxin2" class="center" style="display:none"><br/><br/><br/><br/><img
            src="static/images/jiazai.gif"/><br/><h4 class="lighter block green"></h4></div>
</form>
<!-- 引入 -->
<script type="text/javascript" src="plugins/JQuery/jquery-1.12.2.min.js"></script>
<script type="text/javascript" src="static/js/bootstrap.min.js"></script>
<script src="static/js/ace-elements.min.js"></script>
<script src="static/js/ace.min.js"></script>
<script type="text/javascript" src="plugins/chosen/chosen.jquery.min.js"></script><!-- 下拉框 -->
<script type="text/javascript" src="static/js/jquery.tips.js"></script>
<script type="text/javascript" src="static/js/bootstrap-datepicker.min.js"></script>
<script type="text/javascript" src="plugins/zTree/jquery.ztree-2.6.min.js"></script>
<script type="text/javascript" src="static/deptTree/deptTree.js"></script>
<script type="text/javascript">
    //初始化日期控件
    $('#endpicker').datepicker({
        minView: 2,
        format: 'yyyy-mm-dd',
        autoclose: true,
        startDate: '${node.startDate}',
        endDate: '${node.endDate}'
    });

    //初始化树控件
    var setting = {
        checkable: false,
        checkType: {"Y": "", "N": ""},
        callback: {
            click: function () {
                var dept = deptTree.getSelectedNode();
                deptTreeInner.val(dept.DEPT_NAME);
                $("#deptCode").val(dept.DEPT_CODE);
                if (deptTreeInner.next()) {
                    deptTreeInner.next().val(dept.ID);
                }
                addEmp(dept.ID);
                hideDeptTree();
            }
        }
    };
    $("#deptTree").deptTree(setting, ${deptTreeNodes}, 200, 218);

    //初始化下拉框控件
    $(".chzn-select").chosen({disable_search_threshold: 1000});

    //根据选择的部门ID获取员工列表
    function addEmp(deptId) {
        $.ajax({
            url: "employee/findEmpByDept.do?deptId=" + deptId,
            type: "get",
            success: function (data) {
                var emps = eval('(' + data + ')').list;
                var appendStr = "";
                for (var i = 0; i < emps.length; i++) {
                    appendStr += "<option value=" + emps[i].EMP_CODE;
                    if (emps[i].leader) {
                        appendStr += " selected "
                    }
                    appendStr += ">" + emps[i].EMP_NAME + "</option>";
                }
                $("#empCode").empty();
                $("#empCode").append(appendStr);
                $("#empCode").trigger("chosen:updated");
            }
        });
    }

    //保存创新项目信息
    function save() {
        if (checkInput("nodeTarget", "请输入节点名称")
            && checkInput("dept_id", "请选择责任部门")
            && checkInput("empCode", "请选择负责人")
            && checkInput("endpicker", "请选择达成时间")) {

            var input = $("#weight").val();
            var flag = true;
            if (input != null && input != "") {
                flag = checkWeight(input);
            }
            if (flag) {
                $("#nodeForm").submit();
                $("#zhongxin").hide();
                $("#zhongxin2").show();
            }
        }
    }

    function checkWeight(input) {
        if (!(input > 0 && input <= 100)) {
            $("#weight").tips({
                side: 3,
                msg: "权重只能为1-100的正整数",
                bg: '#AE81FF',
                time: 2
            });
            $("#weight").focus();
            return false;
        }
        return true;
    }

    function checkInput(id, msg) {
        var input = $("#" + id).val();
        if (input == null || $.trim(input) == "") {
            $("#" + id).tips({
                side: 3,
                msg: msg,
                bg: '#AE81FF',
                time: 2
            });

            if (id == "deptCode") {
                $("#dept_id").focus();
            } else {
                $("#" + id).focus();
            }
            return false;
        }
        return true;
    }

    function refer() {
        $("#STATUS").val("YW_YSX");
        save();
    }
</script>
</body>
</html>