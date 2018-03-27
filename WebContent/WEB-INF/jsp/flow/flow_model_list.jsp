<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
    String path = request.getContextPath();
    String basePath = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort() + path + "/";
%>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <base href="<%=basePath%>">
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta http-equiv="content-Type" content="text/html; charset=UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>流程模板管理</title>
    <link type="text/css" rel="StyleSheet" href="plugins/Bootstrap/css/bootstrap.min.css"/>
    <link type="text/css" rel="StyleSheet" href="plugins/Bootgrid/jquery.bootgrid.min.css"/>
    <link type="text/css" rel="StyleSheet" href="static/css/style.css"/>
    <link rel="stylesheet" href="static/css/font-awesome.min.css"/>
    <link rel="stylesheet" href="static/css/bootgrid.change.css"/>
    <link rel="stylesheet" href="plugins/zTeee3.5/zTreeStyle.css">
    <style type="text/css">
        .col-md-3, .col-md-9 {
            padding: 0
        }

        .col-md-3 {
            border-right: 1px solid #CCCCCC;
            border-bottom: 1px solid #CCCCCC;
        }

        .col-md-9 {
            border-bottom: 1px solid #CCCCCC;
        }

        .editGridRow {
            height: 100%;
            width: 100%;
        }

        .treePanel {
            display: none;
            position: absolute;
            overflow: auto;
            height: 200px;
            width: 200px;
            border: 1px solid #CCCCCC;
            background-color: white;
            z-index: 100000;
        }

        .bootgrid-table th > .column-header-anchor > .text {
            margin: 0;
        }
    </style>
</head>
<body>
<div class="container-fluid" id="main-container">
    <div class="row">
        <div class="col-md-3" style="overflow: auto;">
            <div class="m-c-l-top">
                <img src="static/images/ui1.png" style="margin-top:-5px;">流程管理
                <a class="btn btn-mini btn-danger" onclick="delModel();" style="float:right;margin: 6px">刪除</a>
                <a class="btn btn-mini btn-primary" onclick="editModel();" style="float:right;margin: 6px">编辑</a>
                <a class="btn btn-mini btn-primary" onclick="addModel();" style="float:right;margin: 6px">新增</a>
            </div>
            <ul id="tree" class="ztree" style="overflow:auto;"></ul>
        </div>
        <div class="col-md-9">
            <div class="m-c-l-top">
                <img style="margin-top: -5px;" src="static/images/ui1.png">流程模板详情
                <a class="btn btn-mini btn-primary" onclick="showFLowImage();" style="float:right;margin: 6px">流程图</a>
                <a class="btn btn-mini btn-primary" onclick="importExcel();" style="float:right;margin: 6px">导入</a>
                <a class="btn btn-mini btn-primary" onclick="addNode();" style="float:right;margin: 6px">新增</a>
            </div>
            <form id="flowModel_form">
                <table id="flowModel_grid" class="table table-striped table-bordered table-hover">
                    <thead>
                    <tr>
                        <th data-column-id="ID" data-visible="false"></th>
                        <th data-column-id="NODE_CODE" data-width="60px">节点编号</th>
                        <th data-column-id="NODE_NAME" data-formatter="nodeName">节点名称</th>
                        <th data-column-id="TIME_INTERVAL" data-width="60px">时间间隔</th>
                        <th data-column-id="COST_TIME" data-width="60px">节点耗时</th>
                        <th data-column-id="DEPT_NAME" data-formatter="deptName" data-width="90px">责任部门</th>
                        <th data-column-id="GRADE_NAME" data-formatter="gradeName" data-width="90px">责任岗位</th>
                        <th data-column-id="EMP_NAME" data-formatter="empName" data-width="80px">责任人</th>
                        <th data-column-id="NODE_LEVEL" data-width="60px">节点层级</th>
                        <th data-column-id="PARENT_CODE" data-formatter="parentCode" data-width="80px">上一节点</th>
                        <th data-column-id="MODEL_NAME" data-formatter="subflow" data-width="80px">子流程</th>
                        <th data-column-id="REMARKS" data-formatter="remarks" data-width="80px">备注</th>
                        <th data-formatter="oper" data-width="90px" data-width="80px">操作</th>
                    </tr>
                    </thead>
                </table>
            </form>
        </div>
    </div>
</div>
<script type="text/javascript" src="plugins/JQuery/jquery.min.js"></script>
<script type="text/javascript" src="plugins/zTeee3.5/jquery.ztree.all.min.js"></script>
<script type="text/javascript" src="plugins/Bootstrap/js/bootstrap.min.js"></script>
<script type="text/javascript" src="plugins/Bootgrid/jquery.bootgrid.min.js"></script>
<script type="text/javascript" src="static/js/bootbox.min.js"></script>
<script type="text/javascript" src="static/js/jquery.tips.js"></script>
<script type="text/javascript">
    //标识gird的编辑状态
    var editing = false;
    //默认行，用于取消编辑时恢复
    var $defaultTr;
    var $currentTr = null;

    var depts = ${depts};
    var rowDeptTree;
    var rowFlowTree;
    var regNum = /^\d{1,}$/

    //左侧流程树配置
    var setting = {
        async: {
            enable: true,
            url: "flowModel/getFlowModelTreeNode.do",
            autoParam: ["ID"]
        },
        data: {
            key: {
                name: "MODEL_NAME"
            },
            simpleData: {
                enable: true,
                idKey: "ID",
                pIdKey: "PARENT_ID",
                rootPId: 0
            }
        },
        callback: {
            onClick: zTreeOnClick
        }
    };

    //行内组织机构树配置
    var rowDeptTreeSetting = {
        data: {
            key: {
                name: "DEPT_NAME"
            },
            simpleData: {
                enable: true,
                idKey: "ID",
                pIdKey: "PARENT_ID",
                rootPId: 0
            }
        },
        callback: {
            onClick: nodeClick
        }
    }

    var rowFlowTreeSetting = {
        async: {
            enable: true,
            url: "flowModel/getFlowModelTreeNode.do",
            autoParam: ["ID"]
        },
        data: {
            key: {
                name: "MODEL_NAME"
            },
            simpleData: {
                enable: true,
                idKey: "ID",
                pIdKey: "PARENT_ID",
                rootPId: 0
            }
        },
        callback: {
            onClick: rowFlowTreeClick
        }
    };

    //初始化流程模板树
    var zTreeObj = $.fn.zTree.init($("#tree"), setting, null);

    //行内流程树节点点击事件
    function rowFlowTreeClick(event, treeId, treeNode) {
        if (treeNode.isParent) {
            rowFlowTree.expandNode(treeNode, true, false, true);
        } else {
            $("#subFlow_id").val(treeNode.MODEL_NAME);
            $("#SUBFLOW_ID").val(treeNode.ID);
            hideRowFlowTree();
        }
    }

    //列表行内树节点选择事件
    function nodeClick(event, treeId, treeNode) {
        $("#dept_id").val(treeNode.DEPT_NAME);
        $("#DEPT_ID").val(treeNode.ID);
        hideRowDeptTree();

        //根据部门添加岗位
        addPositionLevel(treeNode.ID);
        $("#EMP_CODE").empty();
    }

    //流程模板树节点单击事件
    function zTreeOnClick(event, treeId, treeNode) {
        $("#flowModel_grid").bootgrid("destroy");
        if (treeNode.isParent) {
            zTreeObj.expandNode(treeNode, true, false, true);
        } else {
            $("#flowModel_grid").bootgrid({
                ajax: true,
                navigation: 0,
                sorting: false,
                url: "flowModelNode/findNodesByModel.do?id=" + treeNode.ID,
                formatters: {
                    oper: function (column, row) {
                        return '<a style="cursor:pointer;" onclick="editRow(' + row.ID + ',this);" class="btn btn-mini btn-info">编辑</a>' +
                            '<a style="cursor:pointer;margin-left: 3px" onclick="delNode(' + row.ID + ');" class="btn btn-mini btn-danger">删除</a>';
                    },
                    nodeName: function (column, row) {
                        return '<span title="' + row.NODE_NAME + '">' + row.NODE_NAME + '</span>';
                    },
                    remarks: function (column, row) {
                        return '<span title="' + row.REMARKS + '">' + row.REMARKS + '</span>';
                    },
                    subflow: function (column, row) {
                        if (row.MODEL_NAME != null) {
                            return '<span title="' + row.MODEL_NAME + '">' + row.MODEL_NAME + '</span>';
                        }
                    },
                    parentCode: function (column, row) {
                        return '<span title="' + row.PARENT_CODE + '">' + row.PARENT_CODE + '</span>';
                    },
                    empName: function (column, row) {
                        if (row.EMP_NAME != null) {
                            return '<span title="' + row.EMP_NAME + '">' + row.EMP_NAME + '</span>';
                        }
                    },
                    gradeName: function (column, row) {
                        if (row.GRADE_NAME != null) {
                            return '<span title="' + row.GRADE_NAME + '">' + row.GRADE_NAME + '</span>';
                        }
                    },
                    deptName: function (column, row) {
                        if (row.DEPT_NAME != null) {
                            return '<span title="' + row.DEPT_NAME + '">' + row.DEPT_NAME + '</span>';
                        }
                    },
                }
            });
            editing = false;
        }
    }

    //切换编辑列
    function editRow(id, obj) {
        //检查当前是否存在未保存的列
        var selectNode = zTreeObj.getSelectedNodes()[0];
        if (!checkAddNode(selectNode)) {
            return false;
        }
        editing = true;

        //修改当前列为编辑状态
        var rows = $("#flowModel_grid").bootgrid("getCurrentRows");
        for (var i = 0; i < rows.length; i++) {
            if (id == rows[i].ID) {
                $currentTr = $(obj).parent().parent().clone();

                var content = "<td><input class='editGridRow' id='NODE_CODE' name='NODE_CODE' value='" + rows[i].NODE_CODE + "'/></td>" +
                    "<td><input class='editGridRow' id='NODE_NAME' name='NODE_NAME' value='" + rows[i].NODE_NAME + "'/></td>" +
                    "<td><input class='editGridRow' id='TIME_INTERVAL' name='TIME_INTERVAL' value='" + rows[i].TIME_INTERVAL + "'/></td>" +
                    "<td><input class='editGridRow' id='COST_TIME' name='COST_TIME' value='" + rows[i].COST_TIME + "'/></td>";

                //添加责任部门
                if (rows[i].DEPT_NAME == null) {
                    content += "<td><input autocomplete='off' data-placeholder='点击选择部门' class='editGridRow' id='dept_id' onclick='showRowDeptTree()' type='text'/>" +
                        "<input type='hidden' id='DEPT_ID' name='DEPT_ID'>" +
                        "<div id='deptTreePanel' class='treePanel'>" +
                        "<ul id='deptTree' class='ztree' style='height: 85%;'></ul>" +
                        "</div></td>";
                } else {
                    content += "<td><input autocomplete='off' data-placeholder='点击选择部门' class='editGridRow' id='dept_id' onclick='showRowDeptTree()' type='text' value='" + rows[i].DEPT_NAME + "'/>" +
                        "<input type='hidden' id='DEPT_ID' name='DEPT_ID' value='" + rows[i].DEPT_ID + "'>" +
                        "<div id='deptTreePanel' class='treePanel'>" +
                        "<ul id='deptTree' class='ztree' style='height: 85%;'></ul>" +
                        "</div></td>";
                }


                //添加岗位下拉框
                content += "<td><select style='width: 100%;height: 24px;' id='POSITION_ID' onchange='getEmp()' name='POSITION_ID'><option value=''>请选择...</option>";
                if (rows[i].DEPT_ID != null) {
                    $.ajax({
                        url: "positionLevel/findPositionByDeptId.do",
                        type: "post",
                        async: false,
                        data: {"deptId": rows[i].DEPT_ID},
                        success: function (data) {
                            for (var j = 0; j < data.length; j++) {
                                if (rows[i].POSITION_ID == data[j].ID) {
                                    content += "<option value='" + data[j].ID + "' selected='selected'>" + data[j].GRADE_NAME + "</option>";
                                } else {
                                    content += "<option value='" + data[j].ID + "'>" + data[j].GRADE_NAME + "</option>"
                                }
                            }
                        }
                    });
                }
                content += "</select></td>";

                //添加员工列表下拉框
                content += "<td><select style='width: 100%;height: 24px;' id='EMP_CODE' name='EMP_CODE'><option value=''>请选择...</option>";
                if (rows[i].POSITION_ID != null) {
                    $.ajax({
                        url: "employee/findEmpByPosition.do",
                        type: "post",
                        data: {"positionId": rows[i].POSITION_ID},
                        async: false,
                        success: function (data) {
                            for (var j = 0; j < data.length; j++) {
                                if (rows[i].EMP_CODE == data[j].EMP_CODE) {
                                    content += "<option value='" + data[j].EMP_CODE + "' selected='selected'>" + data[j].EMP_NAME + "</option>";
                                } else {
                                    content += "<option value='" + data[j].EMP_CODE + "'>" + data[j].EMP_NAME + "</option>"
                                }
                            }
                        }
                    });
                }
                content += "</select></td>";

                content += "<td><input class='editGridRow' id='NODE_LEVEL' name='NODE_LEVEL' value='" + rows[i].NODE_LEVEL + "'/></td>" +
                    "<td><input class='editGridRow' id='PARENT_CODE' name='PARENT_CODE' value='" + rows[i].PARENT_CODE + "'/></td>";

                //添加子流程
                if (rows[i].MODEL_NAME == null) {
                    content += "<td><input autocomplete='off' data-placeholder='点击选择子流程' class='editGridRow' id='subFlow_id' onclick='showRowFlowTree()' type='text'/>" +
                        "<input type='hidden' id='SUBFLOW_ID' name='SUBFLOW_ID'>" +
                        "<div id='flowTreePanel' class='treePanel'>" +
                        "<ul id='flowTree' class='ztree' style='height: 85%;'></ul>" +
                        "</div></td>";
                } else {
                    content += "<td><input autocomplete='off' data-placeholder='点击选择子流程' class='editGridRow' id='subFlow_id' onclick='showRowFlowTree()' type='text' value='" + rows[i].MODEL_NAME + "'/>" +
                        "<input type='hidden' id='SUBFLOW_ID' name='SUBFLOW_ID' value='" + rows[i].SUBFLOW_ID + "'>" +
                        "<div id='flowTreePanel' class='treePanel'>" +
                        "<ul id='flowTree' class='ztree' style='height: 85%;'></ul>" +
                        "</div></td>";
                }

                content += "<td><input class='editGridRow' id='REMARKS' name='REMARKS' value='" + rows[i].REMARKS + "'/></td>" +
                    "<td><input type='hidden' name='ID' value='" + rows[i].ID + "'/><a style='cursor:pointer;' onclick='saveNode();' class='btn btn-mini btn-info'>保存</a>" +
                    "<a style='cursor:pointer;margin-left: 3px' onclick='cancelEdit(this);' class='btn btn-mini btn-danger'>取消</a></td>"

                $(obj).parent().parent().empty().append(content);

                //初始化树并选中部门节点
                rowDeptTree = $.fn.zTree.init($("#deptTree"), rowDeptTreeSetting, depts);
                rowFlowTree = $.fn.zTree.init($("#flowTree"), rowFlowTreeSetting, null);
                break;
            }
        }
    }

    //添加节点
    function addNode() {
        var selectNode = zTreeObj.getSelectedNodes()[0];

        if (!checkAddNode(selectNode)) {
            return false;
        }

        var $tbody = $("#flowModel_grid tbody");
        var $tr = $("#flowModel_grid tbody tr").last();
        if ($tr.find("td").html() == "未查询到数据") {
            $defaultTr = $tr.clone();
            $tbody.empty();
        }

        editing = true;
        $tbody.append(
            "<tr>" +
            "<td><input class='editGridRow' id='NODE_CODE' name='NODE_CODE'/></td>" +
            "<td><input class='editGridRow' id='NODE_NAME' name='NODE_NAME'/></td>" +
            "<td><input class='editGridRow' id='TIME_INTERVAL' name='TIME_INTERVAL'/></td>" +
            "<td><input class='editGridRow' id='COST_TIME' name='COST_TIME'/></td>" +
            "<td><input autocomplete='off' data-placeholder='点击选择部门' class='editGridRow' id='dept_id' onclick='showRowDeptTree()' type='text'/>" +
            "<input type='hidden' id='DEPT_ID' name='DEPT_ID'>" +
            "<div id='deptTreePanel' class='treePanel'>" +
            "<ul id='deptTree' class='ztree' style='height: 85%;'></ul>" +
            "</div></td>" +
            "<td><select style='width: 100%;height: 24px;' id='POSITION_ID' onclick='checkDept()' onchange='getEmp()' name='POSITION_ID'></select></td>" +
            "<td><select style='width: 100%;height: 24px;' id='EMP_CODE' onclick='checkPosition()' name='EMP_CODE'></select></td>" +
            "<td><input class='editGridRow' id='NODE_LEVEL' name='NODE_LEVEL'/></td>" +
            "<td><input class='editGridRow' id='PARENT_CODE' name='PARENT_CODE'/></td>" +

            //添加流程模板下拉树
            "<td><input autocomplete='off' data-placeholder='点击选择子流程' class='editGridRow' id='subFlow_id' onclick='showRowFlowTree()' type='text'/>" +
            "<input type='hidden' id='SUBFLOW_ID' name='SUBFLOW_ID'>" +
            "<div id='flowTreePanel' class='treePanel'>" +
            "<ul id='flowTree' class='ztree' style='height: 85%;'></ul>" +
            "</div></td>" +

            "<td><input class='editGridRow' name='REMARKS'/></td>" +
            "<td><input type='hidden' name='MODEL_ID' value='" + selectNode.ID + "'/><a style='cursor:pointer;' onclick='saveNode();' class='btn btn-mini btn-info'>保存</a>" +
            "<a style='cursor:pointer;margin-left: 3px' onclick='cancelEdit(this);' class='btn btn-mini btn-danger'>取消</a></td>" +
            "</tr>"
        );

        rowDeptTree = $.fn.zTree.init($("#deptTree"), rowDeptTreeSetting, depts);
        rowFlowTree = $.fn.zTree.init($("#flowTree"), rowFlowTreeSetting, null);
    }

    //部门为空时提示
    function checkDept() {
        if ($("#DEPT_ID").val() == null || $("#DEPT_ID").val() == "") {
            top.Dialog.alert("选择岗位前请先选择责任部门");
        }
    }

    function checkPosition() {
        if ($("#POSITION_ID").val() == null || $("#POSITION_ID").val() == "") {
            top.Dialog.alert("选择人员前请先选择岗位");
        }
    }

    function getEmp() {
        var positionId = $("#POSITION_ID").val();
        $.ajax({
            url: "employee/findEmpByPosition.do",
            type: "post",
            data: {"positionId": positionId},
            success: function (data) {
                var $empCode = $("#EMP_CODE");
                $empCode.empty();
                $empCode.append("<option value=''>请选择...</option>");
                for (var i = 0; i < data.length; i++) {
                    $empCode.append("<option value='" + data[i].EMP_CODE + "'>" + data[i].EMP_NAME + "</option>");
                }
            }
        });
    }

    //检查是否可以新增节点
    function checkAddNode(selectNode) {
        if (editing) {
            top.Dialog.alert("请先保存当前编辑的数据");
            return false;
        } else if (selectNode == null) {
            top.Dialog.alert("请选择需要操作的流程模板");
            return false;
        } else if (selectNode.isParent) {
            top.Dialog.alert("流程模板分类下不能新增流程节点");
            return false;
        } else {
            return true;
        }
    }

    function showRowDeptTree() {
        $("#deptTreePanel").slideDown("fast");
    };

    function hideRowDeptTree() {
        $("#deptTreePanel").fadeOut("fast");
    };

    function showRowFlowTree() {
        $("#flowTreePanel").slideDown("fast");
    }

    function hideRowFlowTree() {
        $("#flowTreePanel").fadeOut("fast");
    };

    //组织机构树多选下拉选项
    function deptTreeSelectEnd() {
        var nodes = rowDeptTree.getCheckedNodes(true);
        var values = "";
        var texts = "";
        for (var i = 0; i < nodes.length; i++) {
            values += nodes[i].ID + ",";
            texts += nodes[i].DEPT_NAME + ",";
        }
        values = values.substring(0, values.length - 1);
        texts = texts.substring(0, texts.length - 1);

        $("#dept_id").val(texts);
        $("#DEPT_ID").val(values);
        hideRowDeptTree();

        //根据部门添加岗位
        addPositionLevel(values);
    }

    //添加岗位列表
    function addPositionLevel(deptId) {
        var $positionId = $("#POSITION_ID");
        $positionId.empty();
        $positionId.append("<option value=''>请选择...</option>");
        $.ajax({
            url: "positionLevel/findPositionByDeptId.do",
            type: "post",
            data: {"deptId": deptId},
            success: function (data) {
                for (var i = 0; i < data.length; i++) {
                    $positionId.append("<option value='" + data[i].ID + "'>" + data[i].GRADE_NAME + "</option>");
                }
            }
        });
    }

    /**
     * 重置树节点状态，全部设置为未选择
     */
    /* function resetDeptTree(){
        rowDeptTree.checkAllNodes(false);
    } */

    //绑定页面鼠标点击事件
    $(document).bind("mousedown", function (event) {
        if (!(event.target.id == "dept_id"
                || event.target.id.indexOf("deptTreePanel") >= 0
                || $(event.target).parents("#deptTreePanel").length > 0)) {
            hideRowDeptTree();
        }

        if (!(event.target.id == "subFlow_id"
                || event.target.id.indexOf("flowTreePanel") >= 0
                || $(event.target).parents("#flowTreePanel").length > 0)) {
            hideRowFlowTree();
        }
    });

    //删除节点
    function delNode(id) {
        top.Dialog.confirm("确定要删除此节点吗？", function () {
            $.ajax({
                url: "flowModelNode/delNode.do",
                type: "post",
                data: {'id': id},
                success: function (data) {
                    if (data == "success") {
                        $("#flowModel_grid").bootgrid("reload");
                    } else {
                        top.Dialog.alert("删除失败，请联系系统管理员");
                    }
                }
            });
        });
    }

    //取消行编辑
    function cancelEdit(obj) {
        if ($("#flowModel_grid tbody").children().length == 0) {
            $("#flowModel_grid tbody").append($defaultTr);
        } else if ($currentTr != null) {
            $(obj).parent().parent().after($currentTr);
        }
        $(obj).parent().parent().remove();
        editing = false;
    }

    //保存节点信息
    function saveNode() {

        if (!checkNode()) {
            return false;
        }

        var formData = $("#flowModel_form").serializeArray();
        editing = false;
        $.ajax({
            url: "flowModelNode/saveNode.do",
            type: "post",
            data: {'nodes': formData},
            success: function (data) {
                if (data == "success") {
                    $("#flowModel_grid").bootgrid("reload");
                } else {
                    top.Dialog.alert("保存失败，请联系系统管理员");
                }
            }
        });
    }

    //检查当前记录是否可保存
    function checkNode() {
        return checkInputText('NODE_CODE', "节点编号不能为空")
            && checkInputText('NODE_NAME', "节点名称不能为空")
            && checkInputNum("TIME_INTERVAL", "时间间隔不能为空，且只能为正整数")
            && checkInputNum("COST_TIME", "节点耗时不能为空，且只能为正整数")
            && checkInputNum("NODE_LEVEL", "节点层级不能为空，且只能为正整数")
            && checkParentNode();
    }

    //检查上级节点是否为空
    function checkParentNode() {
        var parentCode = $("#PARENT_CODE").val();
        var nodeLevel = $("#NODE_LEVEL").val();
        if (parentCode == null || parentCode.trim() == "") {
            if (nodeLevel != 1 && (parentCode == null || $.trim(parentCode) == "")) {
                $("#PARENT_CODE").tips({
                    side: 3,
                    msg: "仅层级为1的节点上级节点可以为空",
                    bg: '#AE81FF',
                    time: 2
                });

                $("#PARENT_CODE").focus();
                return false;
            }
        }
        return true;
    }

    //检查输入是否为空
    function checkInputText(id, msg) {
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

    function checkInputNum(id, msg) {
        var input = $("#" + id).val();
        if (!regNum.test(input)) {
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

    //excel导入
    function importExcel() {
        var selectNode = zTreeObj.getSelectedNodes()[0];

        if (selectNode == null) {
            top.Dialog.alert("请选择需要操作的流程模板");
            return false;
        } else if (selectNode.isParent) {
            top.Dialog.alert("流程模板分类下不能导入流程节点");
            return false;
        }

        top.jzts();
        var diag = new top.Dialog();
        diag.Drag = true;
        diag.Title = "导入Excel数据";
        diag.URL = 'flowModelNode/toUpload.do?modelId=' + selectNode.ID;
        diag.Width = 400;
        diag.Height = 150;
        diag.CancelEvent = function () { //关闭事件
            $("#flowModel_grid").bootgrid("reload");
            diag.close();
        };
        diag.show();
    }

    //新增流程模板
    function addModel() {
        var selectNode = zTreeObj.getSelectedNodes()[0];
        var pid = 0;
        if (selectNode != null) {
            pid = selectNode.ID;
        }

        $.ajax({
            url: "flowModel/countNode.do",
            type: "post",
            data: {"pid": pid},
            success: function (data) {
                if (data > 0) {
                    top.Dialog.alert("此节点下已有流程节点，不能增加下级节点");
                } else {
                    top.jzts();
                    var diag = new top.Dialog();
                    diag.Drag = true;
                    diag.Title = "新增流程模板";
                    diag.URL = '<%=basePath%>flowModel/goAdd.do?pid=' + pid;
                    diag.Width = 450;
                    diag.Height = 360;
                    diag.CancelEvent = function () {
                        //如果当前选中接点为父节点，则刷新当前节点，如果不是则刷新当前节点的父节点
                        if (selectNode != null && selectNode.PARENT_ID != 0) {
                            zTreeObj.reAsyncChildNodes(selectNode, "refresh");
                        } else if (selectNode == null || selectNode.PARENT_ID == 0) {
                            zTreeObj.reAsyncChildNodes(null, "refresh");
                        }
                        diag.close();
                    };
                    diag.show();
                }
            }
        });
    }

    //删除模板
    function delModel() {
        var selectNode = zTreeObj.getSelectedNodes()[0];
        if (selectNode == null) {
            top.Dialog.alert("请选择需要编辑的节点");
        } else {
            top.Dialog.confirm("刪除当前节点将会删除所有子节点，确认删除吗？", function () {
                $.ajax({
                    url: "flowModel/removeModel.do",
                    type: "post",
                    data: {"id": selectNode.ID},
                    success: function (data) {
                        if (data == "success") {
                            zTreeObj.removeNode(selectNode);
                        } else {
                            top.Dialog.alert("操作失败，请稍后重试或联系系统管理员");
                        }
                    }
                });
            });
        }
    }

    //编辑节点信息
    function editModel() {
        var selectNode = zTreeObj.getSelectedNodes()[0];

        if (selectNode == null) {
            top.Dialog.alert("请选择需要编辑的节点");
            return false;
        }

        top.jzts();
        var diag = new top.Dialog();
        diag.Drag = true;
        diag.Title = "编辑流程模板";
        diag.URL = '<%=basePath%>flowModel/goEdit.do?id=' + selectNode.ID;
        diag.Width = 450;
        diag.Height = 360;
        diag.CancelEvent = function () {
            //如果当前选中接点是第一级节点则刷新整个树；如果不是第一级节点，则刷新当前节点的父节点
            if (selectNode.PARENT_ID != 0) {
                zTreeObj.reAsyncChildNodes(selectNode.getParentNode(), "refresh");
            } else {
                zTreeObj.reAsyncChildNodes(null, "refresh");
            }
            diag.close();
        };
        diag.show();
    }

    function showFLowImage() {
        var selectNode = zTreeObj.getSelectedNodes()[0];

        if (selectNode == null) {
            top.Dialog.alert("请选择需要显示的节点");
            return false;
        }

        top.jzts();
        var diag = new top.Dialog();
        diag.Drag = true;
        diag.Title = "流程图";
        diag.URL = '<%=basePath%>flowModel/showImage.do?id=' + selectNode.ID;
        diag.Width = 800;
        diag.Height = 700;
        diag.show();
    }
</script>
</body>
</html>