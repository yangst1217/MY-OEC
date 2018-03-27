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

    <link type="text/css" rel="StyleSheet" href="plugins/Bootstrap/css/bootstrap.min.css"/>
    <link type="text/css" rel="StyleSheet" href="plugins/Bootgrid/jquery.bootgrid.min.css"/>
    <link type="text/css" rel="StyleSheet" href="static/css/style.css"/>
    <link rel="stylesheet" href="static/css/font-awesome.min.css"/>
    <link rel="stylesheet" href="static/css/datepicker.css"/>
    <link rel="stylesheet" href="static/css/bootgrid.change.css"/>
    <link rel="stylesheet" href="plugins/zTeee3.5/zTreeStyle.css">

    <style>
        html, body {
            height: 90%;
        }

        #zhongxin td {
            padding: 3px
        }

        #zhongxin td label {
            width: 80px;
            margin-right: 8px;
            padding-top: 5px
        }

        .test_box {
            width: 400px;
            min-height: 22px;
            _height: 120px;
            padding: 3px;
            outline: 0;
            border: 1px solid #d5d5d5;
            font-size: 12px;
            word-wrap: break-word;
            overflow-x: hidden;
            overflow-y: auto;
            _overflow-y: visible;
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
    </style>
    <!-- 引入 -->
    <script type="text/javascript" src="plugins/JQuery/jquery.min.js"></script>
    <script type="text/javascript" src="plugins/zTeee3.5/jquery.ztree.all.min.js"></script>
    <script type="text/javascript" src="plugins/Bootstrap/js/bootstrap.min.js"></script>
    <script type="text/javascript" src="plugins/Bootgrid/jquery.bootgrid.min.js"></script>

    <script src="static/js/ace-elements.min.js"></script>
    <script src="static/js/ace.min.js"></script>
    <script type="text/javascript" src="static/js/chosen.jquery.min.js"></script><!-- 下拉框 -->
    <script type="text/javascript" src="static/js/bootstrap-datepicker.min.js"></script>
    <script type="text/javascript" src="static/js/jquery.tips.js"></script>
    <script src="static/js/ajaxfileupload.js"></script>
    <!-- 引入 -->

    <script type="text/javascript">
        $(function () {
            top.changeui();
            $(".test_box").css('width', '370px');
            $("#file").css('border', "1px solid #ccc");
            $("#file").css('width', '370px');

            $("#dutyTable").bootgrid({
                selection: true,
                multiSelect: true,
                rowSelect: true,
                rowCount: 100,
                navigation: 0,
                formatters: {
                    detail: function (column, row) {
                        return '<span title="' + row.detail + '">' + row.detail + '</span>';
                    },
                    requirement: function (column, row) {
                        return '<span title="' + row.requirement + '">' + row.requirement + '</span>';
                    },
                    responsibility: function (column, row) {
                        return '<span title="' + row.responsibility + '">' + row.responsibility + '</span>';
                    }
                }
            });
            $("#flowWorkNodeGrid").bootgrid({
                ajax: true,
                url: "empDailyTask/findAllFlowWorkNode.do?flowId=${pd.flowId}&nodeId=${pd.nodeId}&handleType=${pd.handleType}",
                selection: true,
                multiSelect: true,
                rowSelect: true,
                navigation: 0,
                sorting: true,
                formatters: {
                    id: function (column, row) {
                        return row.ID;
                    },
                    nodeName: function (column, row) {
                        return '<span title="' + row.NODE_NAME + '">' + row.NODE_NAME + '</span>';
                    },
                    commandStr: function (column, row) {
                        if ('${pd.nodeId}' == row.ID || row.STATUS_NAME == '已完毕') {
                            return '';//'当前节点'//已完毕的节点;
                        } else {
                            return '<a style="cursor:pointer;" onclick="editRow(' + row.ID + ',this);" class="btn btn-mini btn-info">编辑</a>';
                        }
                    }
                }
            });
            /*
            $("#flowWorkNodeGrid").on("selected.rs.jquery.bootgrid", function(e, rows){
                var rowIds = [];
                for (var i = 0; i < rows.length; i++){
                    rowIds.push(rows[i].ID);
                }
                alert("Select: " + rowIds.join(","));
            }).on("deselected.rs.jquery.bootgrid", function(e, rows){
                var rowIds = [];
                for (var i = 0; i < rows.length; i++){
                    rowIds.push(rows[i].ID);
                }
                alert("Deselect: " + rowIds.join(","));
            });
            */
            $('#id-input-file-1').ace_file_input({
                no_file: '未选择文件 ...',
                btn_choose: '选择',
                btn_change: '更改',
                droppable: false,
                onchange: null,
                thumbnail: false,//| true | large
                //whitelist:'.xls',
                //allowExt:  ['xls'],
                //blacklist:'.xlsx|.png'
                //onchange:''
                //
            });
        })

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

        //列表行内树节点选择事件
        function nodeClick(event, treeId, treeNode) {
            $("#dept_id").val(treeNode.DEPT_NAME);
            $("#DEPT_ID").val(treeNode.ID);
            hideRowDeptTree();

            //根据部门添加岗位
            addPositionLevel(treeNode.ID);
            //根据部门获取员工
            getDeptEmp(treeNode.ID);
            //$("#EMP_CODE").empty();
        }

        //显示部门树
        function showRowDeptTree() {
            $("#deptTreePanel").slideDown("fast");
        };

        //隐藏部门树
        function hideRowDeptTree() {
            $("#deptTreePanel").fadeOut("fast");
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
            $positionId.append("<option >请选择...</option>");
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

        //根据部门获取员工
        function getDeptEmp(deptId) {
            $.ajax({
                url: "employee/findEmpByDept.do",
                type: "post",
                data: {"deptId": deptId},
                dataType: 'json',
                success: function (data) {
                    //返回部门的员工列表后，拼接在员工下面
                    var $empCode = $("#EMP_CODE");
                    $empCode.empty();
                    $empCode.append("<option >请选择...</option>");
                    var obj = eval(data);
                    for (var i = 0; i < obj.list.length; i++) {
                        $empCode.append("<option value='" + obj.list[i].EMP_CODE + "' empPositionId='" + obj.list[i].EMP_GRADE_ID + "' >" + obj.list[i].EMP_NAME + "</option>");
                    }
                    //选择员工后，把岗位选择上
                    $empCode.change(function (e) {
                        //根据员工选择岗位
                        var empPositionId = $("#EMP_CODE option:selected").attr("empPositionId");
                        if ($("#POSITION_ID").val() != empPositionId) {
                            $("#POSITION_ID").val(empPositionId);
                        }
                    });
                }
            });
        }

        //根据岗位获取员工
        function getEmp() {
            var positionId = $("#POSITION_ID").val();
            $.ajax({
                url: "employee/findEmpByPosition.do",
                type: "post",
                data: {"positionId": positionId},
                success: function (data) {
                    var $empCode = $("#EMP_CODE");
                    $empCode.unbind("change");//移除之前绑定的事件
                    $empCode.empty();
                    $empCode.append("<option >请选择...</option>");
                    for (var i = 0; i < data.length; i++) {
                        $empCode.append("<option value='" + data[i].EMP_CODE + "'>" + data[i].EMP_NAME + "</option>");
                    }
                }
            });
        }

        //取消行编辑
        function cancelEdit(obj) {
            /*
            var rows = $("#flowWorkNodeGrid").bootgrid("getCurrentRows");
            var r = rows[0];
            var rowId = $(obj).parent().parent().attr("data-row-id");
            $("#flowWorkNodeGrid").bootgrid("remove", [rowId]);
            $("#flowWorkNodeGrid").bootgrid("append", [r]);
            $("#flowWorkNodeGrid").bootgrid("deselect", [rowId]);
            */
            //取消选择的行
            if ($currentTr != null) {
                $(obj).parent().parent().after($currentTr);
            }
            $(obj).parent().parent().remove();
            tdInEdit = null;
            rowIndexInEdit = null;
        }

        //默认行，用于取消编辑时恢复
        var $currentTr = null;

        //处于编辑状态的
        var tdInEdit = null;
        var rowIndexInEdit = null;

        function setInfo() {
            //已经存在编辑框
            if (null != tdInEdit) {
                var deptStr = $("#dept_id").val();
                var posStr = $("#POSITION_ID option:selected").text();
                var empStr = $("#EMP_CODE  option:selected").text();
                //alert("deptStr=" + $("#DEPT_ID").val() + ", posStr=" + $("#POSITION_ID").val() + ", empStr=" + $("#EMP_CODE").val());
                if ("请选择..." == deptStr) {
                    $("#dept_id").tips({
                        side: 3,
                        msg: '请选择部门',
                        bg: '#AE81FF',
                        time: 1
                    });
                    $("#dept_id").focus();
                    return false;
                } else if ("请选择..." == posStr) {
                    $("#POSITION_ID").tips({
                        side: 3,
                        msg: '请选择岗位',
                        bg: '#AE81FF',
                        time: 1
                    });
                    $("#POSITION_ID").focus();
                    return false;
                } else if ("请选择..." == empStr) {
                    $("#EMP_CODE").tips({
                        side: 3,
                        msg: '请选择责任人',
                        bg: '#AE81FF',
                        time: 1
                    });
                    $("#EMP_CODE").focus();
                    return false;
                }
                //设置操作按钮
                var curRows = $("#flowWorkNodeGrid").bootgrid("getCurrentRows");
                var btnStr = '<input type="hidden" id="deptId" value="' + $("#DEPT_ID").val() + '" />' +
                    '<input type="hidden" id="positionId" value="' + $("#POSITION_ID").val() + '" />' +
                    '<input type="hidden" id="empCode" value="' + $("#EMP_CODE").val() + '" />' +
                    '<a style="cursor:pointer;" onclick="editRow(' + curRows[rowIndexInEdit].ID + ',this);" class="btn btn-mini btn-info">编辑</a>';
                //alert($(tdInEdit).html());
                //选中当前行
                $("#flowWorkNodeGrid").bootgrid("select", [curRows[rowIndexInEdit].ID]);
                //设置单元格内容
                $(tdInEdit).prev().prev().prev().html(deptStr);
                $(tdInEdit).prev().prev().html(posStr);
                $(tdInEdit).prev().html(empStr);
                $(tdInEdit).html(btnStr);
                tdInEdit = null;
                rowIndexInEdit = null;
            }
            return true;
        }

        //编辑节点列表
        function editRow(nodeId, obj) {
            //获取所有的行
            var rows = $("#flowWorkNodeGrid").bootgrid("getCurrentRows");

            //循环查找选择的行
            for (var i = 0; i < rows.length; i++) {
                if (nodeId == rows[i].ID) {
                    //不存在编辑框则赋值
                    if (!setInfo()) {
                        return;
                    } else if (null == tdInEdit) {
                        tdInEdit = $(obj).parent();
                        rowIndexInEdit = i;
                    }
                    //选中编辑的行
                    var rowId = rows[i].ID;
                    $("#flowWorkNodeGrid").bootgrid("select", [rowId]);
                    //复制当前编辑行
                    $currentTr = $(obj).parent().parent().clone();
                    //判断节点上是否已配置部门
                    var deptName = "请选择...";
                    var deptId = "";
                    if (null != rows[i].DEPT_ID) {
                        deptName = rows[i].DEPT_NAME;
                        deptId = rows[i].DEPT_ID;
                    }
                    //部门下拉框
                    var deptStr = '<input autocomplete="off" data-placeholder="点击选择部门" class="editGridRow" id="dept_id" onclick="showRowDeptTree()" ' +
                        ' type="text" value="' + deptName + '" />' +
                        '<input type="hidden" id="DEPT_ID" name="DEPT_ID" value="' + deptId + '" />' +
                        '<div id="deptTreePanel" class="treePanel">' +
                        '<ul id="deptTree" class="ztree" style="height: 85%;"></ul>' +
                        '</div>';
                    //添加岗位下拉框
                    var posStr = '<select style="width: 100%;height: 24px;" id="POSITION_ID" onchange="getEmp()" name="POSITION_ID"><option>请选择...</option>';
                    if (rows[i].DEPT_ID != null) {
                        $.ajax({
                            url: "positionLevel/findPositionByDeptId.do",
                            type: "post",
                            async: false,
                            data: {"deptId": rows[i].DEPT_ID},
                            success: function (data) {
                                for (var j = 0; j < data.length; j++) {
                                    if (rows[i].POSITION_ID == data[j].ID) {
                                        posStr += '<option value="' + data[j].ID + '" selected="selected">' + data[j].GRADE_NAME + '</option>';
                                    } else {
                                        posStr += '<option value="' + data[j].ID + '">' + data[j].GRADE_NAME + '</option>';
                                    }
                                }
                            }
                        });
                    }
                    posStr += '</select>';
                    //添加员工列表下拉框
                    var empStr = '<select style="width: 100%;height: 24px;" id="EMP_CODE" name="EMP_CODE"><option>请选择...</option>';
                    if (rows[i].POSITION_ID != null) {
                        $.ajax({
                            url: "employee/findEmpByPosition.do",
                            type: "post",
                            data: {"positionId": rows[i].POSITION_ID},
                            async: false,
                            success: function (data) {
                                for (var j = 0; j < data.length; j++) {
                                    if (rows[i].EMP_CODE == data[j].EMP_CODE) {
                                        empStr += '<option value="' + data[j].EMP_CODE + '" selected="selected">' + data[j].EMP_NAME + '</option>';
                                    } else {
                                        empStr += '<option value="' + data[j].EMP_CODE + '" >' + data[j].EMP_NAME + '</option>';
                                    }
                                }
                            }
                        });
                    }
                    empStr += '</select>';
                    //按钮
                    var btnStr = '<a style="cursor:pointer;margin-left: 3px" onclick="cancelEdit(this);" class="btn btn-mini btn-danger">取消</a>';
                    //重新设置单元格内容
                    //alert($(obj).parent().prev().prev().prev().html());
                    $(obj).parent().prev().prev().prev().html(deptStr);
                    $(obj).parent().prev().prev().html(posStr);
                    $(obj).parent().prev().html(empStr);
                    $(obj).parent().html(btnStr);
                    //初始化树并选中部门节点
                    rowDeptTree = $.fn.zTree.init($("#deptTree"), rowDeptTreeSetting, ${depts});
                    rowDeptTree.checkNode(rowDeptTree.getNodesByParam("ID", rows[i].DEPT_ID), true, true);
                    break;
                }
            }
        }

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
            if (!setInfo()) {
                return;
            }
            //退回和下一步
            if ('back' == '${pd.handleType}' || 'next' == '${pd.handleType}') {
                //获取所有的行
                var rows = $("#flowWorkNodeGrid").bootgrid("getCurrentRows");
                //获取选择的节点
                var selectRows = $("#flowWorkNodeGrid").bootgrid("getSelectedRows");
                if (selectRows.length == 0) {
                    $("#flowWorkNodeGrid").tips({
                        side: 3,
                        msg: '请选择节点！',
                        bg: '#AE81FF',
                        time: 1
                    });
                    return;
                } else if (selectRows.length > 1) {
                    $("#flowWorkNodeGrid").tips({
                        side: 3,
                        msg: '只能选择一个节点！',
                        bg: '#AE81FF',
                        time: 1
                    });
                    return;
                }
                //获取页面的所有数据行
                var trArr = $("#flowWorkNodeGrid tbody tr");
                var inputStr = "";//节点ID，部门ID，岗位ID，员工编号
                for (var i = 0; i < selectRows.length; i++) {
                    var rowID = selectRows[i];//获取选择的节点行ID
                    for (var j = 0; j < trArr.length; j++) {
                        if (rowID == $(trArr[j]).attr("data-row-id")) {
                            inputStr += rowID;//拼接选择的节点ID
                            var tdArr = $(trArr[j]).children();//获取选择的节点行包含的所有单元格
                            var selEmp = tdArr[tdArr.length - 2].innerHTML;//节点上的责任人
                            if (selEmp == '&nbsp;') {//节点上没有选择责任人
                                $("#flowWorkNodeGrid").tips({
                                    side: 3,
                                    msg: '请选择节点上的责任人！',
                                    bg: '#AE81FF',
                                    time: 1
                                });
                                return;
                            }
                            var btnTd = tdArr[tdArr.length - 1];//最后的按钮单元格
                            var inputArr = $(btnTd).children();//最后的单元格包含的子元素
                            if (inputArr.length > 1) {//编辑过的行最后的单元格会包含输入框，
                                inputStr += "," + $(inputArr[0]).val() + "," + $(inputArr[1]).val() + "," + $(inputArr[2]).val();
                            }
                            inputStr += ";";
                            break;
                        }
                    }
                }
                if ("" != inputStr) {
                    inputStr = inputStr.substr(0, inputStr.length - 1);
                }
                $("#inputStr").val(inputStr);
                //alert("inputStr=" + inputStr);
            }

            /*
            var file = $("#file").val();
            if(null == file || file == ''){
                $("#completeForm").attr('action', 'employeeDaylyTask/complete.do');
            }else{
                $("#completeForm").attr('enctype', 'multipart/form-data');
            }
            */
            //获取选择的岗位职责明细
            var selectedDuty = $("#dutyTable").bootgrid("getSelectedRows");
            $("#selectedDuty").val(selectedDuty);
            //退回和结束必须填写说明
            if ('back' == '${pd.handleType}' || 'end' == '${pd.handleType}') {
                if ($('#explain').text() == '') {
                    $('#explain').tips({
                        side: 3,
                        msg: '请填写说明！',
                        bg: '#AE81FF',
                        time: 1
                    });
                    return;
                }
            }
            //检查说明输入的字符是否过长
            if (checkVal('#explain', '#remarks', 500, true)) {
                return;
            }
            //提交表单
            top.Dialog.confirm("确定执行？", function () {
                $.ajaxFileUpload({
                    url: '<%=basePath%>empDailyTask/Upload.do',
                    secureuri: false, //是否需要安全协议，一般设置为false
                    fileElementId: 'file', //文件上传域的ID
                    dataType: 'text',
                    type: 'POST',
                    success: function (data) {
                        $("#document").val(data);
                        $("#Form").submit();
                        $("#zhongxin").hide();
                    },
                    error: function (data, status, e)//服务器响应失败处理函数
                    {
                        alert(e);
                        top.Dialog.close();
                    }
                });
            });

        }

    </script>
</head>
<body>
<form action="<%=basePath%>empDailyTask/handleFlowWork.do" name="Form" id="Form" method="post"
      enctype="multipart/form-data" style="width: 98%; margin: 0 auto;">
    <input type="hidden" name="nodeId" value="${pd.nodeId }"/>
    <input type="hidden" name="flowId" value="${pd.flowId }"/>
    <input type="hidden" name="handleType" value="${pd.handleType }"/>
    <input type="hidden" name="score" value="${score }"/>
    <input type="hidden" name="inputStr" value="" id="inputStr"/>
    <input type="hidden" name="selectedDuty" value="" id="selectedDuty"/>
    <input type="hidden" name="DOCUMENT" id="document"/>
    <div id="zhongxin">
        <table style="table-layout:fixed;margin: 0 auto">
            <!-- 接收节点 -->
            <c:if test="${ pd.handleType=='receive' && not empty flowModelList }">
                <tr>
                    <td><label>发起子流程：</label></td>
                    <td>
                        <select id="childFlowModel" name="childFlowModel"
                                style="width: 370px; height: 25px; border: 1px solid #ccc;">
                            <c:forEach items="${flowModelList }" var="childFlow">
                                <option value="">请选择</option>
                                <option value="${childFlow.ID }">${childFlow.MODEL_CODE } ${childFlow.MODEL_NAME }</option>
                            </c:forEach>
                        </select>
                    </td>
                </tr>
                <tr>
                    <td style="width:80px"><label>说明：</label></td>
                    <td style="width:100%">
                        <input type="hidden" name="remarks" id="remarks"/>
                        <div id="explain" class="test_box" contenteditable="true" style="width:870px"
                             onkeyup="checkVal('#explain', '#remarks', 500, false)"></div>
                    </td>
                </tr>
                <tr>
                    <td style="width:80px"><label>附件：</label></td>
                    <td><input multiple="multiple" type="file" name="file" id="file"/></td>
                </tr>
            </c:if>
            <!-- 结束流程 -->
            <c:if test="${pd.handleType=='end'}">
                <tr>
                    <td style="width:80px"><label><span style="color:red">*</span>说明：</label></td>
                    <td style="width:100%">
                        <input type="hidden" name="remarks" id="remarks"/>
                        <div id="explain" class="test_box" contenteditable="true" style="width:870px"
                             onkeyup="checkVal('#explain', '#remarks', 500, false)"></div>
                    </td>
                </tr>
                <tr>
                    <td style="width:80px"><label>附件：</label></td>
                    <td><input multiple="multiple" type="file" name="file" id="file"/></td>
                </tr>
            </c:if>
            <!-- 转交下一步时，显示岗位职责列表 -->
            <c:if test="${pd.handleType=='next' }">
                <c:if test="${not empty dutyList }">
                    <tr>
                        <td colspan="4"><label style="width:50%">选择工作明细：</label></td>
                    </tr>
                    <tr>
                        <td colspan="4">
                            <div style="max-height: 200px;overflow: auto;">
                                <table id="dutyTable" class="table table-striped table-bordered table-hover"
                                       style="margin-bottom:0px;">
                                    <thead>
                                    <tr>
                                        <th data-width="10%" data-column-id="ID" data-type="numeric"
                                            data-identifier="true" data-visible="false" data-formatter="id"
                                            data-css-class="aa" data-sortable="false">ID
                                        </th>
                                        <th data-width="35%" data-column-id="detail" data-formatter="detail">工作明细</th>
                                        <th data-width="35%" data-column-id="requirement" data-formatter="requirement">
                                            要求
                                        </th>
                                        <th data-width="20%" data-column-id="responsibility"
                                            data-formatter="responsibility">所属岗位职责
                                        </th>
                                    </tr>
                                    </thead>
                                    <tbody>
                                    <c:forEach items="${dutyList }" var="dutyDetail" varStatus="vs">
                                        <tr>
                                            <td>${dutyDetail.ID }</td>
                                            <td>${dutyDetail.detail }</td>
                                            <td>${dutyDetail.requirement }</td>
                                            <td>${dutyDetail.responsibility }</td>
                                        </tr>
                                    </c:forEach>
                                    </tbody>
                                </table>
                            </div>
                        </td>
                    </tr>
                </c:if>
            </c:if>
            <!-- 流程下的所有节点 -->
            <c:if test="${pd.handleType=='back' || pd.handleType=='next' }">
                <tr>
                    <td colspan="4"><label>选择节点：</label></td>
                </tr>
                <tr>
                    <td colspan="4">
                        <table id="flowWorkNodeGrid" class="table table-striped table-bordered table-hover"
                               style="margin-bottom:0px">
                            <thead>
                            <tr>
                                <th data-width="50px" data-column-id="ID" data-type="numeric" data-identifier="true"
                                    data-visible="false" data-formatter="id"
                                    data-css-class="aa" data-sortable="false">ID
                                </th>
                                <th data-width="25%" data-column-id="NODE_NAME" data-formatter="nodeName">节点名称</th>
                                <th data-width="80px" data-column-id="NODE_LEVEL">节点层级</th>
                                <th data-width="80px" data-column-id="STATUS_NAME">节点状态</th>
                                <th data-width="15%" data-column-id="DEPT_NAME">承接部门</th>
                                <th data-width="10%" data-column-id="GRADE_NAME">承接岗位</th>
                                <th data-width="80px" data-column-id="EMP_NAME">承接责任人</th>
                                <th data-width="50px" data-formatter="commandStr">操作</th>
                            </tr>
                            </thead>
                        </table>
                    </td>
                </tr>
                <tr>
                    <td style="width:80px"><label><c:if test="${pd.handleType=='back' }"><span
                            style="color:red">*</span></c:if>说明：</label></td>
                    <td style="width:100%">
                        <input type="hidden" name="remarks" id="remarks"/>
                        <div id="explain" class="test_box" contenteditable="true" style="width:870px"
                             onkeyup="checkVal('#explain', '#remarks', 500, false)"></div>
                    </td>
                    <td style="width:80px"><label>附件：</label></td>
                    <td><input multiple="multiple" type="file" name="file" id="file"/></td>
                </tr>
            </c:if>


            <!--
            <div style="height: 40px; padding:5px">
               <label style="font-size:14px;float:left;width:80px">上传文件:</label>
               <input type="file" name="file" id="id-input-file-1" />
           </div>
            -->

            <tr style="display:none">
                <c:if test="${pd.handleType=='receive' || pd.handleType=='end'}">
                <td colspan="2" style="text-align: center;">
                    </c:if>
                    <c:if test="${pd.handleType=='back' || pd.handleType=='next' }">
                <td colspan="4" style="text-align: center;">
                    </c:if>
                    <a id="handleBtn" class="btn btn-mini btn-primary" onclick="check();" style="margin-top: 20px;">
                        <c:if test="${pd.handleType=='receive' }">接收</c:if>
                        <c:if test="${pd.handleType=='back' }">退回</c:if>
                        <c:if test="${pd.handleType=='next' }">转交下一步</c:if>
                        <c:if test="${pd.handleType=='end' }">结束流程</c:if>
                    </a>
                    <a class="btn btn-mini btn-danger" onclick="top.Dialog.close();" style="margin-top: 20px;">取消</a>
                </td>
            </tr>
        </table>

    </div>
</form>

</body>
</html>