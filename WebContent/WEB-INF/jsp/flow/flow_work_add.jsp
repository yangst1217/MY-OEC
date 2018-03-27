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
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta http-equiv="content-Type" content="text/html; charset=UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>流程工作管理</title>
    <link type="text/css" rel="StyleSheet" href="plugins/Bootstrap/css/bootstrap.min.css"/>
    <link type="text/css" rel="StyleSheet" href="plugins/Bootgrid/jquery.bootgrid.min.css"/>
    <link type="text/css" rel="StyleSheet" href="static/css/style.css"/>
    <link rel="stylesheet" href="static/css/font-awesome.min.css"/>
    <link rel="stylesheet" href="static/css/bootgrid.change.css"/>
    <link rel="stylesheet" href="plugins/zTeee3.5/zTreeStyle.css">
    <!-- 下拉框 -->
    <link rel="stylesheet" href="static/css/chosen.css"/>

    <script type="text/javascript" src="static/js/dtree.js"></script>
    <style type="text/css">
        .pay_title {
            font-size: 18px;
            border-left: 5px solid #005ba8;
            padding-left: 10px;
            margin: 15px 0;
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

        /*设置自适应框样式*/
        .test_box {
            width: 176px;
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
    </style>

</head>
<body>
<div class="container-fluid" id="main-container">
    <div class="row">

        <form action="flowWork/save.do" name="Form" id="Form" method="post">
            <input type="hidden" name="fromPage" value="${pd.fromPage }"/>
            <div class="col-md-3">
                <table style="border-collapse:separate; border-spacing:0px 10px;">
                    <tr>
                        <td colspan="3">
                            <div class="pay_title">选择流程模板：</div>
                        </td>
                    </tr>
                    <tr>
                        <td colspan="3">
                            <select id="ID" name="ID" style="width:162px;height:26px"
                                    onchange="getInfo(this.options[this.options.selectedIndex].value)"
                                    <c:if test="${'flowTask' == pd.fromPage}">disabled='disabled'</c:if> >
                                <option value="">请选择...</option>
                                <c:forEach items="${temList }" var="tem" varStatus="vs">
                                    <option value="${tem.ID }"
                                            <c:if test="${pd.flowModelId == tem.ID}">selected</c:if>>${tem.MODEL_NAME}</option>
                                </c:forEach>
                            </select>
                            <a class="btn btn-small btn-success" onclick="save()">发起流程</a>
                        </td>
                    </tr>
                    <tr>
                        <td colspan="3">
                            <div class="pay_title">流程信息：</div>
                        </td>
                    </tr>
                    <tr>
                        <td><label>流程名称：</label></td>
                        <td colspan="2">
                            <input type="hidden" id="MODEL_NAME" name="MODEL_NAME" value="" placeholder="流程名称"
                                   title="流程名称"/>
                            <div>
                                <div id="divModelName" class="test_box" contenteditable="false"
                                     style="border-bottom:none"></div>
                                <div id="divActualModelName" class="test_box" contenteditable="true"
                                     style="border-top:none" placeholder="流程名称"></div>
                            </div>
                            <!--
                            <input autocomplete="off" type="text" id="MODEL_NAME" name="MODEL_NAME" value="" placeholder="流程名称"
                                title="流程名称"	/>
                             -->
                        </td>
                    </tr>
                    <!--
                    <tr>
                        <td><label>任务提醒：</label></td>
                        <td  colspan="2">
                            <select id="" name="" style="width:172px;height:26px">
                                <option value="">请选择...</option>

                            </select>
                        </td>
                    </tr>
                    <tr>
                        <td><label>任务报警：</label></td>
                        <td  colspan="2">
                            <select id="" name="" style="width:172px;height:26px">
                                <option value="">请选择...</option>

                            </select>
                        </td>
                    </tr>
                     -->
                    <tr>
                        <td><label>流程备注：</label></td>
                        <td colspan="2">
                            <input autocomplete="off" type="text" id="REMARKS" name="REMARKS" value=""
                                   placeholder="流程备注"
                                   title="流程备注"/>
                        </td>
                    </tr>
                    <tr>
                        <td><label>发起节点：</label></td>
                        <td colspan="2">
                            <select id="START_ID" name="START_ID" style="width:172px;height:26px"
                                    onchange="setIndex(this.options.selectedIndex)">

                            </select>
                        </td>
                    </tr>
                    <tr>
                        <td><label>父流程：</label></td>
                        <td colspan="2">
                            <select id="PARENT_NODE" name="PARENT_NODE" style="width:172px;height:26px"
                                    <c:if test="${'flowTask' == pd.fromPage}">disabled='disabled'</c:if>>
                                <option value="">请选择...</option>
                                <c:forEach items="${parentList }" var="par" varStatus="vs">
                                    <option value="${par.ID }" <c:if test="${pd.nodeId==par.ID }">selected</c:if>>
                                        [${par.FLOW_NAME}]${par.NODE_NAME}</option>
                                </c:forEach>
                            </select>
                        </td>
                    </tr>
                    <tr>
                        <td><label>关注人：</label></td>
                        <td colspan="2">
                            <select class="chzn-select" id="FOCUS_EMP" name="FOCUS_EMP[]"
                                    style="width:172px;height:100px" multiple data-placeholder="点击选择关注人">
                                <!-- <option value="">请选择...</option> -->
                                <c:forEach items="${empList }" var="emp" varStatus="vs">
                                    <option value="${emp.EMP_CODE }">${emp.EMP_NAME}</option>
                                </c:forEach>
                            </select>
                        </td>
                    </tr>
                </table>
                <input type="hidden" name="INDEX" id="INDEX" value="0"/>
            </div>


            <div class="col-md-9">
                <table id="flow_grid" class="table table-striped table-bordered table-hover">
                    <colgroup>
                        <col style="width: 28%">
                        <col style="width: 10%">
                        <col style="width: 16%">
                        <col style="width: 14%">
                        <col style="width: 12%">
                        <col style="width: 20%">
                    </colgroup>
                    <thead>
                    <tr>
                        <th data-column-id="NODE_NAME" data-sortable="false" data-formatter="NODE_NAME">节点名称</th>
                        <th data-column-id="NODE_LEVEL" data-sortable="false">节点层级</th>
                        <th data-column-id="DEPT_NAME" data-sortable="false" data-formatter="DEPT_NAME">责任部门</th>
                        <th data-column-id="GRADE_NAME" data-sortable="false" data-formatter="GRADE_NAME">责任岗位</th>
                        <th data-column-id="EMP_NAME" data-sortable="false" data-formatter="EMP_NAME">责任人</th>
                        <th data-column-id="REMARKS" data-sortable="false" data-formatter="REMARKS">备注</th>
                    </tr>
                    </thead>
                </table>
            </div>
        </form>
    </div>
</div>
<script type="text/javascript" src="plugins/JQuery/jquery.min.js"></script>
<script type="text/javascript" src="plugins/Bootstrap/js/bootstrap.min.js"></script>
<script type="text/javascript" src="plugins/Bootgrid/jquery.bootgrid.min.js"></script>
<script type="text/javascript" src="static/js/bootbox.min.js"></script>
<script type="text/javascript" src="plugins/zTeee3.5/jquery.ztree.all.min.js"></script>
<script type="text/javascript" src="static/js/chosen.jquery.min.js"></script>
<script type="text/javascript">
    $(function () {
        $(".chzn-select").chosen();
        $("#flow_grid").bootgrid({
            ajax: true,
            url: "flowWork/flowList.do",
            navigation: 0,
            formatters: {
                DEPT_NAME: function (column, row) {
                    if (row.DEPT_NAME == null) {
                        return '<input autocomplete="off" data-placeholder="点击选择部门" class="editGridRow" id="dept_id_' + row.ID + '" onclick="showRowDeptTree(' + row.ID + ')" ' +
                            ' type="text" style="width:100%" value="" />' +
                            '<input type="hidden" id="DEPT_ID_' + row.ID + '" name="DEPT_ID" value="' + row.DEPT_ID + '" />' +
                            '<div id="deptTreePanel_' + row.ID + '" class="treePanel">' +
                            '<ul id="deptTree_' + row.ID + '" class="ztree" style="height: 85%;"></ul>' +
                            '</div>';
                    } else {
                        return '<input autocomplete="off" data-placeholder="点击选择部门" class="editGridRow" id="dept_id_' + row.ID + '" onclick="showRowDeptTree(' + row.ID + ')" ' +
                            ' type="text" style="width:100%" value="' + row.DEPT_NAME + '" />' +
                            '<input type="hidden" id="DEPT_ID_' + row.ID + '" name="DEPT_ID" value="' + row.DEPT_ID + '" />' +
                            '<div id="deptTreePanel_' + row.ID + '" class="treePanel">' +
                            '<ul id="deptTree_' + row.ID + '" class="ztree" style="height: 85%;"></ul>' +
                            '</div>';
                    }

                },

                GRADE_NAME: function (column, row) {
                    var posStr = '<select style="width: 100%;height: 24px;" id="POSITION_ID_' + row.ID + '" onchange="getEmp(' + row.ID + ')" name="POSITION_ID"><option>请选择...</option>';
                    if (row.DEPT_ID != null) {
                        $.ajax({
                            url: "positionLevel/findPositionByDeptId.do",
                            type: "post",
                            async: false,
                            data: {"deptId": row.DEPT_ID},
                            success: function (data) {
                                for (var j = 0; j < data.length; j++) {
                                    if (row.POSITION_ID == data[j].ID) {
                                        posStr += '<option value="' + data[j].ID + '" selected="selected">' + data[j].GRADE_NAME + '</option>';
                                    } else {
                                        posStr += '<option value="' + data[j].ID + '">' + data[j].GRADE_NAME + '</option>';
                                    }
                                }
                            }
                        });
                    }
                    posStr += '</select>';
                    return posStr;
                },

                EMP_NAME: function (column, row) {
                    var empStr = '<select style="width: 100%;height: 24px;" id="EMP_CODE_' + row.ID + '" name="EMP_CODE"><option>请选择...</option>';
                    if (row.POSITION_ID != null) {
                        $.ajax({
                            url: "employee/findEmpByPosition.do",
                            type: "post",
                            data: {"positionId": row.POSITION_ID},
                            async: false,
                            success: function (data) {
                                for (var j = 0; j < data.length; j++) {
                                    if (row.EMP_CODE == data[j].EMP_CODE) {
                                        empStr += '<option value="' + data[j].EMP_CODE + '" selected="selected">' + data[j].EMP_NAME + '</option>';
                                    } else {
                                        empStr += '<option value="' + data[j].EMP_CODE + '" >' + data[j].EMP_NAME + '</option>';
                                    }
                                }
                            }
                        });
                    }
                    empStr += '</select>';
                    return empStr;
                },
                REMARKS: function (column, row) {
                    return '<span title="' + row.REMARKS + '">' + row.REMARKS + '</span>';
                },
                NODE_NAME: function (column, row) {
                    return '<span title="' + row.NODE_NAME + '">' + row.NODE_NAME + '</span>';
                }


            }
        });
        //从工作台添加的任务，自动加载信息
        if ('flowTask' == '${pd.fromPage}') {
            getInfo('${pd.flowModelId}');
        }
    });

    function searchById(id) {
        $("#flow_grid").bootgrid("search", {"ID": id});

    }

    var nodeList = null;

    //获取流程模板信息
    function getInfo(id) {
        var url = "<%=basePath%>flowWork/getInfo.do?ID=" + id;
        $.ajax({
            type: "POST",
            async: false,
            url: url,
            success: function (data) {
                var obj = eval('(' + data + ')');
                //$("#MODEL_NAME").val(obj.pd.MODEL_NAME);
                //设置流程实例名称
                $("#divModelName").text(obj.pd.MODEL_NAME + "-");
                $("#REMARKS").val(obj.pd.REMARKS);
                nodeList = obj.nodeList;
                var optionstring = "";
                for (var i = 0; i < obj.nodeList.length; i++) {
                    optionstring += "<option value='" + obj.nodeList[i].ID + "'>" + obj.nodeList[i].NODE_NAME + "</option>";
                }
                $("#START_ID").html("<option value=''>请选择...</option>" + optionstring);

                searchById(id);
            }
        });
    };

    function setIndex(index) {
        if (index >= 1) {
            index = index - 1;
        }
        $("#INDEX").val(index);
    };

    //检查长度是否超出
    function checkVal(setVal) {
        var length = 100;
        var val = $("#divModelName").text();
        if ($("#divActualModelName").text().length > 0) {
            val += $("#divActualModelName").text();
        } else {
            val = val.substr(0, val.length - 1);
        }
        if (val.length > length) {
            top.Dialog.alert('长度不能超过' + length + '，请重新填写!');
            $("#divActualModelName").focus();
        } else if (setVal) {
            $("#MODEL_NAME").attr("value", val);
        }
        return val.length > length;
    }

    //保存
    function save() {
        if ($("#ID").val() == "") {
            top.Dialog.alert("请选择流程模板！");
            return;
        }
        //设置流程名称
        if (checkVal(true)) {
            return;
        }
        //检查输入项
        var index = $("#INDEX").val();
        var nodeID = nodeList[index].ID;
        if ($("#DEPT_ID_" + nodeID).val() == "undefined" || $("#POSITION_ID_" + nodeID).find("option:selected").val() == "请选择..." || $("#EMP_CODE_" + nodeID).find("option:selected").val() == "请选择...") {
            top.Dialog.alert("请输入发起节点的模板数据！");
        } else {
            if ('${pd.fromPage}' == 'flowTask') {
                $DisSelects = $("select[disabled='disabled']");//获取所有被禁用的select
                $DisSelects.attr("disabled", false); //处理之前, 全部打开
            }
            $("#Form").submit();
            /*
            if('
            ${ pd.from}'=='flowTask'){
	        			$DisSelects.attr("disabled", true);  //处理完成, 全部禁用
	        		}
	        		*/
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

    //列表行内树节点选择事件
    function nodeClick(event, treeId, treeNode) {
        $("#dept_id_" + cdeptid).val(treeNode.DEPT_NAME);
        $("#DEPT_ID_" + cdeptid).val(treeNode.ID);
        hideRowDeptTree();

        //根据部门添加岗位
        addPositionLevel(treeNode.ID);
        $("#EMP_CODE").empty();
    }

    var cdeptid = null;

    //显示部门树
    function showRowDeptTree(deptid) {
        cdeptid = deptid;
        //初始化树并选中部门节点
        rowDeptTree = $.fn.zTree.init($("#deptTree_" + deptid), rowDeptTreeSetting, ${depts});
        rowDeptTree.checkNode(rowDeptTree.getNodesByParam("ID", deptid), true, true);
        $("#deptTreePanel_" + deptid).slideDown("fast");

    };

    //隐藏部门树
    function hideRowDeptTree() {
        $("#deptTreePanel_" + cdeptid).fadeOut("fast");
    };

    //绑定页面鼠标点击事件
    $(document).bind("mousedown", function (event) {
            if (!(event.target.id == cdeptid
                    || event.target.id.indexOf("deptTreePanel") >= 0
                    || $(event.target).parents(".treePanel").length > 0)) {
                hideRowDeptTree();
            }
        }
    );

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
        var $positionId = $("#POSITION_ID_" + cdeptid);
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

    //根据岗位获取员工
    function getEmp(id) {
        var positionId = $("#POSITION_ID_" + id).val();
        $.ajax({
            url: "employee/findEmpByPosition.do",
            type: "post",
            data: {"positionId": positionId},
            success: function (data) {
                var $empCode = $("#EMP_CODE_" + id);
                $empCode.empty();
                $empCode.append("<option >请选择...</option>");
                for (var i = 0; i < data.length; i++) {
                    $empCode.append("<option value='" + data[i].EMP_CODE + "'>" + data[i].EMP_NAME + "</option>");
                }
            }
        });
    }

</script>
</body>
</html>