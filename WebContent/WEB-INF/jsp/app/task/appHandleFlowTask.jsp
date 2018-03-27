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
    <title>处理流程工作</title>
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

    <link rel="stylesheet" href="static/css/app-style.css"/>

    <style type="text/css">
        #zhognxin td {
            height: 35px;
        }

        #zhognxin td label {
            text-align: left;
            margin-right: 10px;
        }

        #zhongxin td input {
            width: 90%;
            padding: 4px 0;
        }

        .progress {
            width: 90%;
        }

        .success {
            background-color: #55b83b
        }

        .warning {
            background-color: #d20b44
        }

        .tab-content {
            padding: 0;
        }

        .nav-tabs > li > a {
            color: white;
        }

        .keytask {
            width: 100%;
            padding: 0;
        }

        .keytask table {
            width: 98%;
            margin: 0 auto;
        }

        .keytask table tr td {
            line-height: 1.3;
            word-break: break-word;
            overflow: visible;
            white-space: normal;
        }

        .btn-mini {
            padding: 0 2px;
        }

        .web_footer {
            z-index: 11;
        }

        /*设置自适应框样式*/
        .test_box {
            width: 220px;
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
    <!-- 引入 -->
    <script type="text/javascript" src="static/js/jquery-1.7.2.js"></script>
    <script src="static/js/bootstrap.min.js"></script>
    <script src="static/js/ace-elements.min.js"></script>
    <script src="static/js/ace.min.js"></script>
    <script type="text/javascript" src="static/js/jquery-form.js"></script>
    <script type="text/javascript" src="static/js/jquery.tips.js"></script>
    <script src="static/js/ajaxfileupload.js"></script>
    <script type="text/javascript">
        jQuery(function ($) {
            $('#file').ace_file_input({
                no_file: '未选择文件 ...',
                btn_choose: '选择',
                btn_change: '更改',
                droppable: false,
                onchange: null,
                thumbnail: false,//| true | large
            });
            //初始化岗位和员工
            var deptlist = document.getElementsByName("dept");
            var gradelist = document.getElementsByName("grade");
            var boxlist = document.getElementsByName("finishBox");
            if (null != deptlist && deptlist.length > 0) {
                for (var i = 0; i < deptlist.length; i++) {
                    if (deptlist[i].value != '') {
                        findPos(deptlist[i].value, boxlist[i].value, gradelist[i].value);
                    }
                }
            }
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

        //根据部门查询岗位
        function findPos(deptId, nodeId, posId) {
            $('#grade' + nodeId).empty();
            $('#grade' + nodeId).append('<option value="" >请选择</option>');
            if (deptId != '' && deptId != null) {
                $.ajax({
                    url: "app_task/findPositionByDeptId.do",
                    type: "post",
                    async: false,
                    data: {"deptId": deptId},
                    success: function (data) {
                        for (var j = 0; j < data.length; j++) {
                            var gradeStr = '<option value="' + data[j].ID + '" ';
                            //节点上存在岗位信息则默认选择
                            if (data[j].ID == $('#grade' + nodeId).attr('positionId')) {
                                gradeStr += 'selected ';
                                //默认员工信息
                                findEmp(data[j].ID, nodeId);
                            }
                            gradeStr += '>' + data[j].GRADE_NAME + '</option>';
                            $('#grade' + nodeId).append(gradeStr);
                        }
                        //节点上没有岗位信息则加载部门下所有员工
                        if ('' == $('#grade' + nodeId).attr('positionId')) {
                            getDeptEmp(deptId, nodeId);
                        }

                    }
                });
            }

        }

        //根据部门获取员工
        function getDeptEmp(deptId, nodeId) {
            $.ajax({
                url: "app_task/findEmpByDept.do",
                type: "post",
                data: {"deptId": deptId},
                dataType: 'json',
                success: function (data) {
                    //返回部门的员工列表后，拼接在员工下面
                    var $empCode = $('#emp' + nodeId);
                    $empCode.empty();
                    $empCode.append('<option value="" >请选择</option>');
                    var obj = eval(data);
                    for (var i = 0; i < obj.list.length; i++) {
                        $empCode.append("<option value='" + obj.list[i].EMP_CODE + "' empPositionId='" + obj.list[i].EMP_GRADE_ID + "' >" + obj.list[i].EMP_NAME + "</option>");
                    }
                    //选择员工后，把岗位选择上
                    $empCode.change(function (e) {
                        //根据员工选择岗位
                        var empPositionId = $("#emp" + nodeId + " option:selected").attr("empPositionId");
                        if ($('#grade' + nodeId).val() != empPositionId) {
                            $('#grade' + nodeId).val(empPositionId);
                        }
                    });
                }
            });
        }

        //根据岗位查询人员
        function findEmp(posId, nodeId) {
            $('#emp' + nodeId).empty();
            $('#emp' + nodeId).append('<option value="" >请选择</option>');
            $.ajax({
                url: "app_task/findEmpByPosition.do",
                type: "post",
                data: {"positionId": posId},
                success: function (data) {
                    $('#emp' + nodeId).unbind("change");//移除之前绑定的事件
                    for (var i = 0; i < data.length; i++) {
                        var empStr = '<option value="' + data[i].EMP_CODE + '"';
                        //节点上存在员工信息则默认选择
                        if (data[i].EMP_CODE == $('#emp' + nodeId).attr('empCode')) {
                            empStr += 'selected ';
                        }
                        empStr += ' >' + data[i].EMP_NAME + '</option>';
                        $('#emp' + nodeId).append(empStr);
                    }
                }
            });
        }

        function setInfo() {
            var checklist = document.getElementsByName("finishBox");
            var empList = document.getElementsByName("emp");
            for (var i = 0; i < checklist.length; i++) {
                if (checklist[i].checked) {
                    var emp = empList[i].value;
                    if (emp == '' || emp == '请选择') {
                        return false;
                    }
                }
            }
            return true;
        }

        //保存
        function check() {
            if ('back' != '${pd.handleType}' && !setInfo()) {
                alert('存在未选择到责任人的节点，请重新编辑!');
                return;
            } else {
                //退回和下一步
                if ('back' == '${pd.handleType}' || 'next' == '${pd.handleType}') {
                    var checklist = document.getElementsByName("finishBox");
                    var num = 0;
                    for (var i = 0; i < checklist.length; i++) {
                        if (checklist[i].checked) {
                            num += 1;
                        }
                    }
                    if (num == 0) {
                        alert('请选择节点!');
                        return;
                    }
                    var deptlist = document.getElementsByName("dept");
                    var gradelist = document.getElementsByName("grade");
                    var emplist = document.getElementsByName("emp");
                    var inputStr = "";//节点ID，部门ID，岗位ID，员工编号
                    for (var i = 0; i < checklist.length; i++) {
                        if (checklist[i].checked) {
                            inputStr += checklist[i].value;//拼接选择的节点ID
                            if (null != deptlist && deptlist.length > 0) {//有选择下拉框才拼接
                                inputStr += "," + deptlist[i].value + "," + gradelist[i].value + "," + emplist[i].value;
                            }
                            inputStr += ";"
                            break;
                        }
                    }
                    if ("" != inputStr) {
                        inputStr = inputStr.substr(0, inputStr.length - 1);
                    }
                    $("#inputStr").val(inputStr);
                }
                var checkList2 = document.getElementsByName("finishBox2");
                var selectedDuty = "";
                for (var j = 0; j < checkList2.length; j++) {
                    if (checkList2[j].checked) {
                        selectedDuty += checkList2[j].value + ",";
                    }
                }
                if ("" != selectedDuty) {
                    selectedDuty = selectedDuty.substr(0, selectedDuty.length - 1);
                }
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
                if (confirm("确定执行?")) {
                    $.ajaxFileUpload({
                        url: '<%=basePath%>app_task/Upload.do',
                        secureuri: false, //是否需要安全协议，一般设置为false
                        fileElementId: 'file', //文件上传域的ID
                        dataType: 'text',
                        type: 'POST',
                        success: function (data) {
                            $("#document").val(data);
                            var options = {
                                success: function (data) {
                                    if (data == "success") {
                                        alert("保存成功");
                                        $("#zhongxin").hide();
                                        var url = '<%=basePath %>app_task/listDesk.do?&startDate=${pd.startDate }&endDate=${pd.endDate }&flowName=${pd.flowName}&loadType=F';
                                        window.location.href = url;
                                    } else {
                                        alert("保存失败");
                                    }

                                }

                            };
                            $("#Form").ajaxSubmit(options);

                        },
                        error: function (data, status, e)//服务器响应失败处理函数
                        {
                            alert(e);
                        }
                    });

                }

            }

        }
    </script>
</head>

<body>
<div class="web_title">
    <!-- 返回 -->
    <div class="back" style="top:5px">
        <a href="<%=basePath %>app_task/listDesk.do?&loadType=F&startDate=${pd.startDate }&endDate=${pd.endDate }&flowName=${pd.flowName }&currentPage=${pd.currentPage}">
            <img src="static/app/images/left.png"/></a>
    </div>
    <!-- tab页 -->
    <div class="web_menu" style="width:90%; margin-left:20px;">
        <ul id="myTab" class="nav nav-tabs">
            <li class="active" style="width:30%;"><a style="width:100%; padding-right:0; padding-left:0;"
                                                     href="#nodeList" data-toggle="tab">节点列表</a></li>
            <c:if test="${pd.handleType=='next' }">
                <li style="width:30%;"><a style="width:100%; padding-right:0; padding-left:0;" href="#dutyList"
                                          data-toggle="tab">工作明细</a></li>
            </c:if>
        </ul>
    </div>
</div>
<form action="<%=basePath%>app_task/handleFlowWork.do" name="Form" id="Form" method="post"
      enctype="multipart/form-data" style="width: 98%; margin: 0 auto;">

    <input type="hidden" name="nodeId" value="${pd.nodeId }"/>
    <input type="hidden" name="flowId" value="${pd.flowId }"/>
    <input type="hidden" name="handleType" value="${pd.handleType }"/>
    <input type="hidden" name="inputStr" value="" id="inputStr"/>
    <input type="hidden" name="selectedDuty" value="" id="selectedDuty"/>
    <input type="hidden" name="score" value="${score }"/>
    <input type="hidden" name="DOCUMENT" id="document"/>
    <div id="zhongxin" style="width:98%; margin: 10px auto; border: none" class="tab-content">
        <!-- 节点列表 -->
        <div class="tab-pane fade in active" id="nodeList">
            <!-- 结束流程 -->
            <c:if test="${pd.handleType=='end'}">
                <table>
                    <tr>
                        <td style="width:70px"><label><span style="color:red">*</span>说明:</label></td>
                        <td>
                            <input type="hidden" name="remarks" id="remarks"/>
                            <div id="explain" class="test_box" contenteditable="true"
                                 onkeyup="checkVal('#explain', '#remarks', 500, false)"></div>
                        </td>
                    </tr>
                    <tr>
                        <td><label>附件:</label></td>
                        <td><input multiple="multiple" type="file" name="file" id="file"/></td>
                    </tr>
                </table>
            </c:if>

            <c:if test="${pd.handleType=='back' || pd.handleType=='next' }">
                <span>选择节点:</span><br>
                <c:choose>
                    <c:when test="${not empty flowNodeList }">
                        <c:forEach items="${flowNodeList }" var="node" varStatus="vs">
                            <div class="keytask">
                                <table>
                                    <tr>
                                        <td style="width:70px">节点名称:</td>
                                        <td name="NODE_NAME"><span>${node.NODE_NAME }</span>
                                        </td>
                                        <td style="text-align: right; width:30px; "><input style="width:20px"
                                                                                           name="finishBox"
                                                                                           type="checkbox"
                                                                                           value="${node.ID }"/>
                                            <span class="lbl"></span>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td style="width:70px">节点层级:</td>
                                        <td name="NODE_LEVEL"><span>${node.NODE_LEVEL }</span>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td style="width:70px">节点状态:</td>
                                        <td name="STATUS_NAME"><span>${node.STATUS_NAME }</span>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td style="width:70px">承接部门:</td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${pd.handleType=='back' }">
                                                    ${node.DEPT_NAME }
                                                </c:when>
                                                <c:otherwise>
                                                    <select id="dept${node.ID }" name="dept"
                                                            onchange="findPos(this.options[this.options.selectedIndex].value,'${node.ID }','${node.POSITION_ID }')"
                                                            style="vertical-align: top;">
                                                        <option value="">请选择</option>
                                                        <c:forEach items="${deptList }" var="dept">
                                                            <option value="${dept.ID }"
                                                                    <c:if test="${node.DEPT_ID==dept.ID }">selected</c:if> >${dept.DEPT_NAME }</option>
                                                        </c:forEach>
                                                    </select>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td style="width:70px">承接岗位:</td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${pd.handleType=='back' }">
                                                    ${node.GRADE_NAME }
                                                </c:when>
                                                <c:otherwise>
                                                    <select id="grade${node.ID }" name="grade"
                                                            positionId="${node.POSITION_ID }"
                                                            value="${node.POSITION_ID }"
                                                            onchange="findEmp(this.options[this.options.selectedIndex].value,'${node.ID }')"
                                                            style="vertical-align: top;">
                                                    </select>
                                                </c:otherwise>
                                            </c:choose>

                                        </td>
                                    </tr>
                                    <tr>
                                        <td style="width:70px">承接责任人:</td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${pd.handleType=='back' }">
                                                    ${node.EMP_NAME }
                                                </c:when>
                                                <c:otherwise>
                                                    <select id="emp${node.ID }" name="emp" empCode="${node.EMP_CODE }"
                                                            value="${node.EMP_CODE }"
                                                            style="vertical-align: top;">
                                                    </select>
                                                </c:otherwise>
                                            </c:choose>

                                        </td>
                                    </tr>
                                </table>
                            </div>
                        </c:forEach>
                    </c:when>
                    <c:otherwise>
                        <span>没有节点列表数据</span>
                    </c:otherwise>
                </c:choose>
                <table id="dataTable" style="width: 100%;">
                    <tr>
                        <td style="width: 70px;"><label><c:if test="${pd.handleType=='back' }"><span
                                style="color:red">*</span></c:if>说明:</label></td>
                        <td>
                            <input type="hidden" name="remarks" id="remarks"/>
                            <div id="explain" class="test_box" contenteditable="true"
                                 onkeyup="checkVal('#explain', '#remarks', 500, false)"></div>
                        </td>
                    </tr>
                    <tr>
                        <td><label>附件:</label></td>
                        <td><input multiple="multiple" type="file" name="file" id="file"/></td>
                    </tr>


                </table>
            </c:if>
            <div style="text-align: right;">
                <a id="handleBtn" class="btn btn-mini btn-primary" onclick="check();" style="margin-top: 20px;">
                    <c:if test="${pd.handleType=='receive' }">接收</c:if>
                    <c:if test="${pd.handleType=='back' }">退回</c:if>
                    <c:if test="${pd.handleType=='next' }">转交下一步</c:if>
                    <c:if test="${pd.handleType=='end' }">结束流程</c:if>
                </a>
            </div>
        </div>
        <!-- 工作列表 -->
        <div class="tab-pane fade" id="dutyList">
            <span>选择工作明细：</span><br>
            <c:choose>
                <c:when test="${not empty dutyList }">
                    <c:forEach items="${dutyList }" var="duty" varStatus="vs">
                        <div class="keytask">
                            <table>
                                <tr>
                                    <td style="width:70px">工作明细:</td>
                                    <td name=detail><span>${duty.detail }</span>
                                    </td>
                                    <td style="text-align: right; width:30px;"><input style="width:20px"
                                                                                      name="finishBox2" type="checkbox"
                                                                                      value="${duty.ID }"/>
                                        <span class="lbl"></span>
                                    </td>
                                </tr>
                                <tr>
                                    <td style="width:70px">工作要求:</td>
                                    <td name="requirement"><span>${duty.requirement }</span>
                                    </td>
                                </tr>
                                <tr>
                                    <td style="width:70px">岗位职责:</td>
                                    <td name="responsibility"><span>${duty.responsibility }</span>
                                    </td>
                                </tr>
                            </table>
                        </div>
                    </c:forEach>
                </c:when>
                <c:otherwise>
                    <span>没有工作明细列表数据</span>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
</form>
<div>
    <%@include file="../footer.jsp" %>
</div>
</body>
</html>
