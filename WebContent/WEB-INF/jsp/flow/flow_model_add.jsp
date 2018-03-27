<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
    String path = request.getContextPath();
    String basePath = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort() + path + "/";
%>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <base href="<%=basePath%>">
    <title>新增流程模板</title>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link href="static/css/bootstrap.min.css" rel="stylesheet"/>
    <link href="static/css/bootstrap-responsive.min.css" rel="stylesheet"/>
    <link rel="stylesheet" href="static/css/font-awesome.min.css"/>
    <link rel="stylesheet" href="static/css/ace.min.css"/>
    <link rel="stylesheet" href="static/css/ace-rtl.min.css"/>
    <link rel="stylesheet" href="static/css/ace-responsive.min.css"/>
    <link rel="stylesheet" href="static/css/ace-skins.min.css"/>
    <link type="text/css" rel="stylesheet" href="plugins/zTree/zTreeStyle.css"/>
    <style type="text/css">
        #zhongxin td {
            height: 45px;
            text-align: right;
            margin-right: 10px;
        }

        input[type="text"] {
            height: 25px;
            width: 240px;
        }
    </style>
</head>
<body>
<form action="flowModel/save.do" name="editForm" id="editForm" method="post">
    <input type="hidden" name="ID" id="ID" value="${flowModel.ID }">
    <input type="hidden" name="PARENT_ID" value="${flowModel.PARENT_ID }">
    <div id="zhongxin" align="center" style="margin-top:20px;">
        <table>
            <tr>
                <td><span style="color: red;">*</span>模板编号：</td>
                <td><input type="text" name="MODEL_CODE" id="MODEL_CODE" value="${flowModel.MODEL_CODE }"></td>
            </tr>
            <tr>
                <td><span style="color: red;">*</span>模板名称：</td>
                <td><input type="text" name="MODEL_NAME" id="MODEL_NAME" value="${flowModel.MODEL_NAME }"></td>
            </tr>
            <tr>
                <td>所属部门：</td>
                <td>
                    <input autocomplete="off" data-placeholder="点击选择部门" id="dept_id" onclick="showDeptTree(this)"
                           type="text" value="${flowModel.DEPT_NAME }"/>
                    <input type="hidden" name="DEPT_ID" value="${flowModel.DEPT_ID}">
                    <div id="deptTreePanel" style="background-color:white;z-index: 1000;">
                        <ul id="deptTree" class="tree"></ul>
                    </div>
                </td>
            </tr>
            <tr>
                <td>备注：</td>
                <td>
                    <textarea name="REMARKS" style="width: 240px;height: 100px;">${flowModel.REMARKS }</textarea>
                </td>
            </tr>
            <tr>
            <tr>
                <td style="text-align: center;" colspan="2">
                    <a class="btn btn-mini btn-primary" onclick="save();">保存</a>
                    <a class="btn btn-mini btn-danger" onclick="Dialog.getInstance('0').close();">取消</a>
                </td>
            </tr>
        </table>
    </div>
    <div id="zhongxin2" class="center" style="display:none">
        <img src="static/images/jiazai.gif"/>
        <h4 class="lighter block green"></h4>
    </div>
</form>
<script type="text/javascript" src="plugins/JQuery/jquery.min.js"></script>
<script type="text/javascript" src="static/js/bootstrap.min.js"></script>
<script type="text/javascript" src="static/js/jquery.tips.js"></script>
<script type="text/javascript" src="plugins/zTree/jquery.ztree-2.6.min.js"></script>
<script type="text/javascript" src="static/deptTree/deptTree.js"></script>
<script type="text/javascript" src="plugins/attention/zDialog/zDrag.js"></script>
<script type="text/javascript" src="plugins/attention/zDialog/zDialog.js"></script>
<script type="text/javascript">
    //初始化树控件
    var setting = {
        checkable: true,
        checkType: {"Y": "s", "N": "s"},
        callback: {
            click: function () {
                var dept = deptTree.getSelectedNode();
                deptTreeInner.val(dept.DEPT_NAME);
                if (deptTreeInner.next()) {
                    deptTreeInner.next().val(dept.ID);
                }
                hideDeptTree();
            }
        }
    };
    $("#deptTree").deptTree(setting, ${deptTreeNodes}, 200, 253);

    //保存
    function save() {
        if (checkInput("MODEL_CODE", "请输入模板编号")
            && checkInput("MODEL_NAME", "请输入模板名称")) {
            $.ajax({
                url: "flowModel/checkCode.do",
                data: {"code": $("#MODEL_CODE").val(), "id": $("#ID").val()},
                dataType: "json",
                success: function (data) {
                    if (!data) {
                        $("#MODEL_CODE").tips({
                            side: 3,
                            msg: "该编码已存在，请重新输入",
                            bg: '#AE81FF',
                            time: 2
                        });
                        $("#MODEL_CODE").focus();
                    } else {
                        $("#editForm").submit();
                        $("#zhongxin").hide();
                        $("#zhongxin2").show();
                    }
                }
            });
        }
    }

    //检查输入
    function checkInput(id, msg) {
        var input = $("#" + id).val();
        if (input == null || $.trim(input) == "") {
            $("#" + id).tips({
                side: 3,
                msg: msg,
                bg: '#AE81FF',
                time: 2
            });
            $("#" + id).focus();
            return false;
        }
        return true;
    }
</script>
</body>
</html>