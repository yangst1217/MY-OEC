<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="shiro" uri="http://shiro.apache.org/tags" %>
<%
    String path = request.getContextPath();
    String basePath = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort() + path + "/";
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <base href="<%=basePath%>">
    <%@ include file="../../system/admin/top.jsp" %>
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
    <script type="text/javascript" src="static/js/jquery-1.7.2.js"></script>
    <!--提示框-->
    <script type="text/javascript" src="static/js/jquery.tips.js"></script>

    <!-- 部门树 -->
    <link type="text/css" rel="stylesheet" href="plugins/zTree/zTreeStyle.css"/>
    <script type="text/javascript" src="plugins/zTree/jquery.ztree-2.6.min.js"></script>
    <script type="text/javascript" src="static/deptTree/deptTree.js"></script>

    <script type="text/javascript">
        top.changeui();

        //保存
        function save() {
            $("#form1").submit();
            $("#zhongxin").hide();
            $("#zhongxin2").show();
        }

        function checkCode() {
            if ($("#gradeCode").val() == "" || trimStr($("#gradeCode").val()) == "") {
                $("#gradeCode").tips({
                    side: 3,
                    msg: '请输入',
                    bg: '#AE81FF',
                    time: 2
                });
                $("#gradeCode").focus();
                return false;
            }
            if ($("#gradeName").val() == "") {
                $("#gradeName").tips({
                    side: 3,
                    msg: '请输入',
                    bg: '#AE81FF',
                    time: 2
                });
                $("#gradeName").focus();
                return false;
            }
            if ($("#jobRank").val() == "") {
                $("#jobRank").tips({
                    side: 3,
                    msg: '请输入',
                    bg: '#AE81FF',
                    time: 2
                });
                $("#jobRank").focus();
                return false;
            }
            if ($("#jobRank").val() < 1) {
                $("#jobRank").tips({
                    side: 3,
                    msg: '请输入大于0的数字',
                    bg: '#AE81FF',
                    time: 2
                });
                $("#jobRank").focus();
                return false;
            }
            if ($("#laborCost").val() == "") {
                $("#laborCost").tips({
                    side: 3,
                    msg: '请输入',
                    bg: '#AE81FF',
                    time: 2
                });
                $("#laborCost").focus();
                return false;
            }

            //var val =  $("#attachDeptId").find("option:selected").text();
            var val = $("#attachDeptId").val();
            if (val == "") {
                $("#attachDeptId").tips({
                    side: 3,
                    msg: '请选择',
                    bg: '#AE81FF',
                    time: 2
                });
                $("#attachDeptId").focus();
                $("#deptip").attr("hidden", false);
                return false;
            } else {
                $("#deptip").attr("hidden", true);
            }
            $("#attachDeptName").val(val);
            //关联KPI模板赋值
            var selKPI = $("#attachKpiModelList").find("option:selected").val();
            if (selKPI != "") {
                $("#attachKpiModel").val(selKPI);
            }


            var gradeCode = document.getElementById("gradeCode").value;
            var gradeName = document.getElementById("gradeName").value;
            //alert(icnum);
            top.jzts();
            var url = "<%=basePath%>/positionLevel/checkCode.do?gradeCode=" + gradeCode;
            $.get(url, function (data) {
                if (data) {
                    $("#codetip").attr("hidden", true);
                    save();
                } else {
                    $("#codetip").attr("hidden", false);
                    //$("#gradeCode").focus();
                    //$("#gradeName").focus();
                    $("#gradeCode").tips({
                        side: 3,
                        msg: '级别编码已存在',
                        bg: '#AE81FF',
                        time: 2
                    });
                    $("#gradeCode").focus();
                    return false;
                }
            }, "text");
        }

        function trimStr(str) {
            return str.replace(/(^\s*)|(\s*$)/g, "");
        }

    </script>

    <script>

        $(function () {
            $("#deptTree").deptTree(setting, ${deptTreeNodes}, 200, 220);
        });

        var setting = {
            checkable: false,
            checkType: {"Y": "", "N": ""}
        };

        /* mootools ftw! */
        /*
        $(function(){

          //判断浏览器是否支持placeholder属性
          supportPlaceholder='placeholder'in document.createElement('input'),

          placeholder=function(input){

            var text = input.attr('placeholder'),
            defaultValue = input.defaultValue;

            if(!defaultValue){

              input.val(text).addClass("phcolor");
            }

            input.focus(function(){

              if(input.val() == text){

                $(this).val("");
              }
            });


            input.blur(function(){

              if(input.val() == ""){

                $(this).val(text).addClass("phcolor");
              }
            });

            //输入的字符不为灰色
            input.keydown(function(){

              $(this).removeClass("phcolor");
            });
          };

          //当浏览器不支持placeholder属性时，调用placeholder函数
          if(!supportPlaceholder){

            $('input').each(function(){

              text = $(this).attr("placeholder");

              if($(this).attr("type") == "text"){

                placeholder($(this));
              }
            });
          }

          $("#deptTree").deptTree(setting, ${deptTreeNodes},200, 220);
	}); */
    </script>
    <style>
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
<form action="positionLevel/add.do" name="form1" id="form1" method="post">
    <input type="hidden" name="attachDeptName" id="attachDeptName"/>
    <input type="hidden" name="attachKpiModel" id="attachKpiModel"/>
    <div id="zhongxin" align="center" style="margin-top:20px;">
        <table>
            <tr>
                <td><label><span style="color: red">*</span>级别编码：</label></td>
                <td><input type="text" name="gradeCode" id="gradeCode" title="级别编码"/></td>
            </tr>
            <tr>
                <td><label><span style="color: red">*</span>级别名称：</label></td>
                <td><input type="text" name="gradeName" id="gradeName" title="级别名称"/></td>
            </tr>
            <tr>
                <td><label><span style="color: red">*</span>岗位等级：</label></td>
                <td><input type="text" name="jobRank" id="jobRank" placeholder="输入岗位等级" title="岗位等级"
                           style="ime-mode:disabled"
                           onkeydown="if(event.keyCode==13)event.keyCode=9"
                           onkeypress="if ((event.keyCode<48 || event.keyCode>57)) event.returnValue=false"/></td>
            </tr>

            <tr>
                <td><label><span style="color: red">*</span>所属部门：</label></td>
                <td>
                    <input onkeydown="return false;" autocomplete="off" id="attachDeptId" name="attachDeptId"
                           onclick="showDeptTree(this)"
                           type="text" placeholder="点击选择所属部门"/>
                    <input type="hidden" name="DEPT_ID" value="${pd.deptIds}">

                    <div id="deptTreePanel" style="background-color:white;z-index: 1000;">
                        <ul id="deptTree" class="tree"></ul>
                    </div>
                    <!-- <select class="chzn-select" name="attachDeptId" id="attachDeptId" data-placeholder="请选择所属部门"
                    style="vertical-align:top;" > -->
                    <!--
						<select class="chzn-select"  name="attachDeptId" id="attachDeptId" data-placeholder="请选择所属部门" 
						style="vertical-align:top;" >
						<option value=""></option>
						<c:forEach items="${deptList}" var="dept">
							<option value="${dept.ID}">${dept.DEPT_NAME }</option>
						</c:forEach>
						</select>
						-->

                    <!-- <p id="deptip" class="tip" hidden="true"><span>提示：请选择所属部门</span></p>
                    <p id="codetip" class="tip" hidden="true"><span>提示：编码或名称重复,请重新输入</span></p> -->
                </td>
            </tr>

            <tr style="display:none">
                <td><label><span style="color: red">*</span>员工成本：</label></td>
                <td><input type="hidden" name="laborCost" id="laborCost" title="员工成本" value="1"
                           onkeyup="changeNumber(this)" onafterpaste="this.value=this.value.replace(/\D/g,'')"></td>
            </tr>

            <tr>
                <td><label>关联KPI模板：</label></td>
                <td>
                    <select class="chzn-select" name="attachKpiModelList" id="attachKpiModelList"
                            data-placeholder="请选择KPI" style="vertical-align:top;">
                        <option value=""></option>
                        <c:forEach items="${kpiList}" var="kpi">
                            <option value="${kpi.ID}">${kpi.NAME }</option>
                        </c:forEach>
                    </select>
                </td>
            </tr>

            <tr>
                <td><label>级别描述：</label></td>
                <td><input type="text" name="gradeDesc" id="gradeDesc" placeholder="这里输入级别描述" title="描述"/></td>
            </tr>

            <tr>
                <td colspan="2" style="text-align: center;">
                    <a class="btn btn-mini btn-primary" onclick="checkCode();">保存</a>
                    <a class="btn btn-mini btn-danger" onclick="top.Dialog.close();">取消</a>
                </td>
            </tr>
        </table>
    </div>
</form>

<div id="zhongxin2" class="center" style="display:none"><img src="static/images/jzx.gif" style="width: 50px;"/><br/><h4
        class="lighter block green"></h4></div>

<script type="text/javascript" src="static/js/chosen.jquery.min.js"></script><!-- 下拉框 -->
<script type="text/javascript">
    $(function () {
        //单选框
        $(".chzn-select").chosen();
        $(".chzn-select").next().find(".chosen-results").css("height", "75px");
        $(".chzn-select-deselect").chosen({allow_single_deselect: true});
    });

    function changeNumber(objTxt) {
        objTxt.value = objTxt.value.replace(/\D/g, '');
    }
</script>
</body>

</html>
