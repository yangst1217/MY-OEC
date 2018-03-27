<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>
<%
    String path = request.getContextPath();
    String basePath = request.getScheme() + "://"
            + request.getServerName() + ":" + request.getServerPort()
            + path + "/";
%>

<!DOCTYPE html>
<html lang="zh_CN">
<head>
    <base href="<%=basePath%>">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta http-equiv="content-Type" content="text/html; charset=UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link type="text/css" rel="stylesheet"
          href="plugins/Bootstrap/css/bootstrap.min.css"/>
    <link type="text/css" rel="stylesheet" href="static/css/style.css"/>
    <link rel="stylesheet" href="static/css/font-awesome.min.css"/>
    <link rel="stylesheet" href="static/css/ace.min.css"/>
    <link rel="stylesheet" href="static/navigation/assets/css/style.css"/>
    <link rel="stylesheet"
          href="static/navigation/assets/css/ace-rtl.min.css"/>
    <link rel="stylesheet"
          href="static/navigation/assets/css/ace-skins.min.css"/>
    <link rel="stylesheet"
          href="static/navigation/assets/css/jquery-ui-1.10.2.custom.min.css"/>
    <link rel="stylesheet" href="static/navigation/css/MySocialShare.css"
          type="text/css"/>
    <script type="text/javascript" src="plugins/JQuery/jquery.min.js"></script>
    <script src="static/navigation/assets/js/ace-extra.min.js"></script>
    <script type="text/javascript">
        if ("ontouchend" in document) document.write("<script src='static/navigation/assets/js/jquery.mobile.custom.min.js'>" + "<" + "/script>");
    </script>
    <script src="static/navigation/assets/js/typeahead-bs2.min.js"></script>

    <!-- page specific plugin scripts -->

    <script src="static/navigation/assets/js/jquery.dataTables.min.js"></script>
    <script src="static/navigation/assets/js/jquery.dataTables.bootstrap.js"></script>

    <!-- ace scripts -->

    <script src="static/navigation/assets/js/jquery-ui-1.10.3.custom.min.js"></script>
    <script src="static/navigation/assets/js/jquery.ui.touch-punch.min.js"></script>
    <script src="static/navigation/assets/js/bootbox.min.js"></script>
    <script src="static/navigation/assets/js/jquery.easy-pie-chart.min.js"></script>
    <script src="static/navigation/assets/js/jquery.gritter.min.js"></script>
    <script src="static/navigation/assets/js/spin.min.js"></script>
    <script src="static/navigation/assets/js/fuelux/fuelux.wizard.min.js"></script>
    <script src="static/navigation/assets/js/jquery.validate.min.js"></script>
    <script src="static/navigation/assets/js/additional-methods.min.js"></script>
    <script src="static/navigation/assets/js/jquery.maskedinput.min.js"></script>
    <script src="static/navigation/assets/js/select2.min.js"></script>


    <script src="static/navigation/assets/js/ace-elements.min.js"></script>
    <script src="static/navigation/assets/js/ace.min.js"></script>
    <script src="static/navigation/assets/js/jquery-1.5.1.min.js"></script>


    <style>
        body {
            background: none;
        }

        body:before {
            background: none;
        }

        .nature {
            display: block;
            width: 120px;
            height: 120px;
            line-height: 120px;
            text-align: center;
            color: #fff;
            font-size: 15px;
            font-weight: bold;
            background: url(static/navigation/assets/images/nature/img1.png) no-repeat;
            cursor: pointer;
            position: relative;
        }

        .nature {
            margin: 50px;
            margin-top: 110px;
        }

        ul.reset, ul.reset li {
            display: block;
            list-style: none;
            padding: 0;
            margin: 0;
        }

        ul.reset li {
            position: absolute;
        }

        ul.reset li a {
            outline: none;
        }

        img {
            max-width: none;
        }

        .hp_title {
            color: #3f3f3f;
            font-size: 18px;
            font-weight: bold;
            margin-left: 15px;
            margin-top: 30px;
        }
    </style>
</head>

<body>
<div class="page-content">
    <div class="row" style="margin:0;">
        <div style="width: 90%;height: 100%;">
            <div class="hp_title" style="font-style:‘微软雅黑’">浙江司太立制药集团行政部组织架构图示</div>
            <div class="nature" id="nature">
                司太立制药
                <ul id="itemUl" class="reset">

                </ul>
            </div>
        </div>
        <!-- /.main-container-inner -->
    </div>
</div>
<!---/.page-content---->

<script type="text/javascript">
    $(function () {
        var url = window.location.href;
        var str = url.split("?")[1];
        var BM = str.split("&&")[0].split("=")[1];
        var TYPE = str.split("&&")[1].split("=")[1];
        var url = "<%=basePath%>findItem.do?TYPE=" + TYPE;
        $.ajax({
            type: "POST",
            async: false,
            url: url,
            success: function (data) {     //回调函数，result，返回值
                var obj = eval('(' + data + ')');
                $.each(obj.list, function (i, list) {
                    var str = '<li><div class="mysocialshare bubble"><a class="msb_main" id=' + list.BIANMA + '>' + list.NAME + '</a><div class="msb_network_holder">';
                    var secUrl = "";
                    if (TYPE == '1') {
                        //点击按地域查询
                        secUrl = "<%=basePath%>findDeptByDis.do?BIANMA=" + list.BIANMA;
                    } else {
                        //点击按职能查询
                        secUrl = "<%=basePath%>findDeptByFun.do?BIANMA=" + list.BIANMA;
                    }
                    $.ajax({
                        type: "POST",
                        async: false,
                        url: secUrl,
                        success: function (res) {
                            var resObj = eval('(' + res + ')');
                            $.each(resObj.funDeptList, function (j, resList) {
                                var deptName = resList.DEPT_NAME;
                                var deptId = resList.ID;
                                str += '<a class="msb_network_button" href="<%=basePath%>enterEmpData.do?deptId=' + deptId + '" title="' + deptName + '">' + deptName + '</a>';
                            });
                        }
                    });
                    str += '</div></div></li>';
                    $("#itemUl").append(str);

                });
            }
        });
        $("div.mysocialshare").find(".msb_main").click(function () {
            if ($(this).hasClass("disabled")) return;
            var n = this;
            var r = [];
            var u = 0;
            var a = 180;
            var f = 80;
            var l = 110;
            var e = 500;
            var t = 250;
            var z = $(n).next().find(".msb_network_button").length;
            var i = l;
            var s = e + (r - 1) * t;
            var o = 1;
            var a = $(this).outerWidth();
            var f = $(this).outerHeight();
            var c = $(n).next().find(".msb_network_button:eq(0)").outerWidth();
            var h = $(n).next().find(".msb_network_button:eq(0)").outerHeight();
            var p = (a - c) / 2;
            var d = (f - h) / 2;
            var v = u / 180 * Math.PI;
            var lileft = $(this).parents("li").position().left;
            var litop = $(this).parents("li").position().top;
            var k = 1;
            if (!$(this).hasClass("active")) {
                $(this).addClass("disabled").delay(s).queue(function (e) {
                    $(this).removeClass("disabled").addClass("active");
                    e()
                });
                $(n).next().find(".msb_network_button").each(function () {
                    var n = (i * k) + 150 - lileft;
                    var r = Math.floor((o - 1) / 5) * 50 - litop - 50//-aa;
                    $(this).css({display: "block", left: p + "px", top: d + "px"}).stop().animate({
                        left: n + "px",
                        top: r + "px",
                        opacity: "1"
                    }, e);
                    o++;
                    k++;
                    if ((k - 1) % 5 === 0) {
                        k = 1;
                    }
                })
            } else {
                o = r;
                $(this).addClass("disabled").delay(s).queue(function (e) {
                    $(this).removeClass("disabled").removeClass("active");
                    e()
                });
                $(n).next().find(".msb_network_button").each(function () {
                    $(this).stop().delay(t * o).animate({left: p, top: d, opacity: "0"}, e);
                    o--
                })
            }
        });

        $(".mysocialshare").click(function () {
            if ($(this).parents("li").siblings().find(".msb_main").hasClass("active")) {
                $(this).parents("li").siblings().find(".active").trigger("click");
            }
        });
        $(".byfunction>ul>li>a").click(function () {
            $(".byfunction>ul>li>a").removeClass("active");
            $(this).parent().siblings().find("#function_list").hide();
            $(this).toggleClass("active");
            $(this).siblings("#function_list").slideToggle();
        });

        if (BM != "null") {
            setTimeout(function () {

                $("#itemUl").stop(true, true);
                $("#itemUl li").stop(true, true);
                $("#" + BM).trigger("click");
                $(".msb_network_button").stop(true, true);
            }, 10);
        }

    });

    //按地域查询部门
    function findDeptByDis(BM) {
        var url = "<%=basePath%>findDeptByDis.do?BIANMA=" + BM;
        $.ajax({
            type: "POST",
            async: false,
            url: url,
            success: function (data) {     //回调函数，result，返回值
                $("#showDeptDiv").html("");
                $("#showDeptDiv").append("<span>按地点查看:<span>");
                var obj = eval('(' + data + ')');
                $.each(obj.funDeptList, function (i, list) {
                    $("#showDeptDiv").append("<a onclick='queryEmp(" + list.ID + ")'>" + list.DEPT_NAME + "<a><br>");
                });
            }
        });
    }

    //按职能查询部门
    function findDeptByFun(BM) {
        var url = "<%=basePath%>findDeptByFun.do?BIANMA=" + BM;
        $.ajax({
            type: "POST",
            async: false,
            url: url,
            success: function (data) {     //回调函数，result，返回值
                $("#showDeptDiv").html("");
                $("#showDeptDiv").append("<span>按职能查看:<span>");
                var obj = eval('(' + data + ')');
                $.each(obj.funDeptList, function (i, list) {
                    $("#showDeptDiv").append("<a onclick='queryEmp(" + list.ID + ")'>" + list.DEPT_NAME + "<a><br>");
                });
            }
        });
    }

    //查询部门
    function queryDept(BIANMA) {
        var url = "<%=basePath%>findDeptByFun.do?BIANMA=" + BIANMA;
        $.ajax({
            type: "POST",
            async: false,
            url: url,
            success: function (data) { //回调函数，result，返回值
                $("#showDeptDiv").html("");
                $("#showDeptDiv").append("<span>小球子页面:<span>");
                var obj = eval('(' + data + ')');
                $.each(obj.funDeptList, function (i, list) {
                    $("#showDeptDiv").append(
                        '<a onclick = queryEmp(\'' + list.ID + '\')>'
                        + list.DEPT_NAME + '<a><br>');
                });
            }
        });
    }

    //查询部门下人员
    function queryEmp(ID) {
        $('#showDataFrame', parent.document).attr("src", "enterEmpData.do?deptId=" + ID);
    }

</script>

<!-- inline scripts related to this page -->
<script src="static/navigation/assets/js/jquery-1.5.1.min.js"></script>
<script src="static/navigation/assets/js/init.js"
        type="text/javascript"></script>
<!-- <script src="static/navigation/assets/js/MySocialShare.js"
    type="text/javascript"></script> -->
<script src="static/navigation/assets/js/mobilyblocks.js"
        type="text/javascript"></script>


</body>
</html>
