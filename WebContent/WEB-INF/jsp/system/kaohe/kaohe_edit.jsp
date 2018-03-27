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
    <script type="text/javascript" src="static/js/jquery-1.7.2.js"></script>
    <!--提示框-->
    <script type="text/javascript" src="static/js/jquery.tips.js"></script>

    <!-- 引入 -->
    <script type="text/javascript">window.jQuery || document.write("<script src='static/js/jquery-1.9.1.min.js'>\x3C/script>");</script>
    <script src="static/js/bootstrap.min.js"></script>
    <script src="static/js/ace-elements.min.js"></script>
    <script src="static/js/ace.min.js"></script>

    <script type="text/javascript" src="static/js/chosen.jquery.min.js"></script><!-- 下拉框 -->
    <script type="text/javascript" src="static/js/bootstrap-datepicker.min.js"></script><!-- 日期框 -->
    <script type="text/javascript" src="static/js/bootbox.min.js"></script><!-- 确认窗口 -->
    <!-- 引入 -->

    <!--引入弹窗组件start-->
    <script type="text/javascript" src="static/js/attention/zDialog/zDrag.js"></script>
    <script type="text/javascript" src="static/js/attention/zDialog/zDialog.js"></script>
    <!--引入弹窗组件end-->

    <script type="text/javascript" src="static/js/jquery.tips.js"></script><!--提示框-->


    <script type="text/javascript">
        $(top.changeui());


        //保存
        function save() {

            /* 	if($("#loginname").val()=="" || $("#loginname").val()=="此用户名已存在!"){

                    $("#loginname").tips({
                        side:3,
                        msg:'输入用户名',
                        bg:'#AE81FF',
                        time:2
                    });

                    $("#loginname").focus();
                    $("#loginname").val('');
                    $("#loginname").css("background-color","white");
                    return false;
                }else{
                    $("#loginname").val(jQuery.trim($('#loginname').val()));
                } */

            if ($("#course_name").val() == "") {

                $("#course_name").tips({
                    side: 3,
                    msg: '输入培训名称',
                    bg: '#AE81FF',
                    time: 3
                });
                $("#course_name").focus();
                return false;
            }

            if ($("#course_teacher").val() == "") {

                $("#course_teacher").tips({
                    side: 3,
                    msg: '输入培训人',
                    bg: '#AE81FF',
                    time: 2
                });

                $("#course_teacher").focus();
                return false;
            }

            if ($("#course_hour").val() == "") {

                $("#course_hour").tips({
                    side: 3,
                    msg: '输入课时',
                    bg: '#AE81FF',
                    time: 3
                });

                $("#course_hour").focus();
                return false;
            }
            if ($("#course_date").val() == "") {

                $("#course_date").tips({
                    side: 3,
                    msg: '输入培训日期',
                    bg: '#AE81FF',
                    time: 3
                });
                $("#course_date").focus();
                return false;
            }

            /* var myreg = /^(((13[0-9]{1})|159)+\d{8})$/; */
            if ($("#course_comment").val() == "") {

                $("#course_comment").tips({
                    side: 3,
                    msg: '输入内容',
                    bg: '#AE81FF',
                    time: 3
                });
                $("#course_comment").focus();
                return false;
            }

            if ($("#course_standard").val() == "") {

                $("#course_standard").tips({
                    side: 3,
                    msg: '输入标准',
                    bg: '#AE81FF',
                    time: 3
                });
                $("#course_standard").focus();
                return false;
            }

            $("#kaoheForm").submit();

            <%-- var url = "kaohe/del.do?ID="+id+"&tm="+new Date().getTime();
            $.get(url,function(data){
                window.location.href='<%=basePath%>kaohe/mlist.do';
            }); --%>

            <%-- 	/////////window.location.href='<%=basePath%>kaohe/mlist.do'; --%>
            // $("#zhongxin").hide();
            // $("#zhongxin2").show();
        }

        /* 	function ismail(mail){
                return(new RegExp(/^(?:[a-zA-Z0-9]+[_\-\+\.]?)*[a-zA-Z0-9]+@(?:([a-zA-Z0-9]+[_\-]?)*[a-zA-Z0-9]+\.)+([a-zA-Z]{2,})+$/).test(mail));
                } */

        //判断用户名是否存在
        function hasU() {
            var USERNAME = $("#loginname").val();
            var url = "user/hasU.do?USERNAME=" + USERNAME + "&tm=" + new Date().getTime();
            $.get(url, function (data) {
                if (data == "error") {
                    $("#loginname").css("background-color", "#D16E6C");

                    setTimeout("$('#loginname').val('此用户名已存在!')", 500);

                } else {
                    $("#userForm").submit();
                    $("#zhongxin").hide();
                    $("#zhongxin2").show();
                }
            });
        }

        //判断邮箱是否存在
        function hasE(USERNAME) {
            var EMAIL = $("#EMAIL").val();
            var url = "user/hasE.do?EMAIL=" + EMAIL + "&USERNAME=" + USERNAME + "&tm=" + new Date().getTime();
            $.get(url, function (data) {
                if (data == "error") {

                    $("#EMAIL").tips({
                        side: 3,
                        msg: '邮箱已存在',
                        bg: '#AE81FF',
                        time: 3
                    });

                    setTimeout("$('#EMAIL').val('')", 2000);

                }
            });
        }

        //判断编码是否存在
        function hasN(USERNAME) {
            var NUMBER = $("#NUMBER").val();
            var url = "user/hasN.do?NUMBER=" + NUMBER + "&USERNAME=" + USERNAME + "&tm=" + new Date().getTime();
            $.get(url, function (data) {
                if (data == "error") {

                    $("#NUMBER").tips({
                        side: 3,
                        msg: '编号已存在',
                        bg: '#AE81FF',
                        time: 3
                    });

                    setTimeout("$('#NUMBER').val('')", 2000);

                }
            });
        }

    </script>
</head>
<body>
<form action="kaohe/save.do" name="kaoheForm" id="kaoheForm" method="post">
    <input type="hidden" name="ID" id="ID" value="${pd.id}"/>
    <input type="hidden" name="DEPT_NAME" id="dept_name"/>
    <div id="zhongxin">
        <table>

            <%--<tr>
                <td>
                    <select class="chzn-select" name="DEPT_ID" id="dept_id" data-placeholder="请选择部门" style="vertical-align:top;">
                    <option value=""></option>
                    <c:forEach items="${deptList}" var="dept">
                        <option value="${dept.ID}" <c:if test="${dept.ID == pd.DEPT_ID }">selected</c:if>>${dept.DEPT_NAME }</option>
                    </c:forEach>
                    </select>
                </td>
            </tr> --%>

            <tr>
                <td><input type="text" name="course_name" id="course_name" placeholder="请输入培训名称"
                           value="${pd.course_name }" maxlength="32" title="培训名称"/></td>
            </tr>

            <tr>
                <select class="chzn-select" name="course_type_id" id="course_type_id" data-placeholder="请输入培训类型"
                        style="vertical-align:top;">
                    <option value="1">延展</option>
                    <option value="2">流程</option>
                </select>
            </tr>
            <tr>
                <td><input type="text" name="course_teacher" id="course_teacher" placeholder="请输入培训人"
                           value="${pd.course_teacher }" maxlength="32" title="培训人"/></td>
            </tr>
            <tr>
                <td><input type="text" name="course_hour" id="course_hour" placeholder="请输入课时"
                           value="${pd.course_hour }" maxlength="32" title="课时"/></td>
            </tr>
            <tr>
                <td>
                    <%-- <input type="text" name="course_date" id="course_date"  value="${pd.course_date }" placeholder="请输入培训日期" maxlength="32"  title="培训日期" /> --%>
                    <input class="span10 date-picker" name="course_date" id="course_date" value="${pd.course_date}"
                           type="text" data-date-format="yyyy-mm-dd" readonly="readonly" style="width:88px;"
                           placeholder="请输入培训日期" title="培训日期"/>
                </td>
            </tr>
            <tr>
                <td><input type="text" name="course_comment" id="course_comment" placeholder="请输入内容"
                           value="${pd.course_comment}" maxlength="32" title="培训内容"/></td>
            </tr>
            <tr>
                <td><input type="text" name="course_standard" id="course_standard" placeholder="请输入标准"
                           value="${pd.course_standard }" maxlength="32" title="标准"/></td>
            </tr>
            <tr>
                <td><input type="text" name="course_score" id="course_score" placeholder="请输入分值"
                           value="${pd.course_score}" maxlength="32" title="分值"/></td>
            </tr>
            <tr>
                <td><input type="text" name="check_person" id="check_person" placeholder="请输入核人"
                           value="${pd.check_person}" maxlength="64" title="考核人"/></td>
            </tr>
            <tr>
                <td style="text-align: center;">
                    <a class="btn btn-mini btn-primary" onclick="save();">保存</a>
                    <a class="btn btn-mini btn-danger" onclick="top.Dialog.close();">取消</a>
                </td>
            </tr>
        </table>
    </div>

    <div id="zhongxin2" class="center" style="display:none"><br/><br/><br/><br/><img
            src="static/images/jiazai.gif"/><br/><h4 class="lighter block green"></h4></div>

</form>

<!-- 引入 -->
<script type="text/javascript">window.jQuery || document.write("<script src='static/js/jquery-1.9.1.min.js'>\x3C/script>");</script>
<script src="static/js/bootstrap.min.js"></script>
<script src="static/js/ace-elements.min.js"></script>
<script src="static/js/ace.min.js"></script>
<script type="text/javascript" src="static/js/chosen.jquery.min.js"></script><!-- 下拉框 -->

<script type="text/javascript">

    $(function () {

        //日期框
        $('.date-picker').datepicker();

        //下拉框
        $(".chzn-select").chosen();
        $(".chzn-select-deselect").chosen({allow_single_deselect: true});

        //复选框
        $('table th input:checkbox').on('click', function () {
            var that = this;
            $(this).closest('table').find('tr > td:first-child input:checkbox')
                .each(function () {
                    this.checked = that.checked;
                    $(this).closest('tr').toggleClass('selected');
                });

        });

    });

</script>

</body>
</html>