<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
    String path = request.getContextPath();
    String basePath = request.getScheme() + "://"
            + request.getServerName() + ":" + request.getServerPort()
            + path + "/";
%>

<!DOCTYPE html>
<html lang="zh_CN">
<head>
    <meta charset="utf-8"/>
    <title></title>
    <meta name="keywords" content=""/>
    <meta name="description" content=""/>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>


    <link href="static/navigation/assets/css/style.css" rel="stylesheet"/>
    <link href="static/navigation/assets/css/bootstrap.min.css"
          rel="stylesheet"/>
    <link rel="stylesheet"
          href="static/navigation/assets/css/font-awesome.min.css"/>

    <!--[if IE 7]>
    <link rel="stylesheet" href="assets/css/font-awesome-ie7.min.css"/>
    <![endif]-->

    <!-- page specific plugin styles -->

    <!-- fonts -->


    <!-- ace styles -->

    <link rel="stylesheet" href="static/navigation/assets/css/ace.min.css"/>
    <link rel="stylesheet"
          href="static/navigation/assets/css/ace-rtl.min.css"/>
    <link rel="stylesheet"
          href="static/navigation/assets/css/ace-skins.min.css"/>

    <!--[if lte IE 8]>
    <link rel="stylesheet" href="assets/css/ace-ie.min.css"/>
    <![endif]-->

    <!-- inline styles related to this page -->

    <!-- ace settings handler -->

    <script src="static/navigation/assets/js/ace-extra.min.js"></script>
    <script src="static/navigation/assets/js/jquery-1.10.2.min.js"></script>
    <!-- HTML5 shim and Respond.js IE8 support of HTML5 elements and media queries -->

    <!--[if lt IE 9]>
    <script src="assets/js/html5shiv.js"></script>
    <script src="assets/js/respond.min.js"></script>
    <![endif]-->
    <style>
        body {
            background: none;
        }

        body:before {
            background: url(static/navigation/assets/images/hp_bg.png) 100% no-repeat;
        }

        td, th {
            font-size: 12px;
            color: #585858;
        }

        th {
            background: #f7f8fa;
        }

        .modal-backdrop {
            z-index: 99;
        }

        input[type=checkbox] {
            opacity: 1;
            position: inherit;
        }

        #myTab {
            margin-bottom: 0;
        }

        #myTab > ul > li {
            background: #98c0d9;
            margin: 0;
            border: 2px solid #98c0d9;
        }

        #myTab > li.active {
            border: 2px solid #448fb9;
        }

        #myTab > ul > li.active a {
            margin: 0;
            box-shadow: none !important;
            background: #448fb9;
        }

        #myTab > ul > li.active a:hover {
            background: #448fb9;
        }

        #myTab > ul > li a {
            color: #fff;
            padding: 12px 25px;
        }

        #myTab > ul > li a:hover {
            color: #fff;
            background: #98c0d9;
        }

        #myTab > ul > li > ul > li {
            color: #98c0d9;
            background: #fff;
        }

        #myTab > ul > li > ul > li a {
            color: #98c0d9;
            background: #fff;
        }

        .tabtitle {
            border: 1px solid #ddd;
            line-height: 40px;
            border-bottom: 0;
        }

        .tab-content {
            padding: 0;
            border: 0;
        }
    </style>
    <style>
        .socials {
            display: block;
            width: 32px;
            height: 32px;
            background: url(static/navigation/assets/images/socials/share.png) no-repeat;
            cursor: pointer;
            position: relative;
        }

        .nature {
            display: block;
            width: 120px;
            height: 120px;
            line-height: 120px;
            text-align: center;
            color: #fff;
            font-size: 15px;
            background: url(static/navigation/assets/images/nature/img1.png) no-repeat;
            cursor: pointer;
            position: relative;
        }

        .socials, .nature {
            margin-left: 50px;
            margin-top: 110px;
        }

        .socials {
            margin-bottom: 50px;
        }

        ul.reset,
        ul.reset li {
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
    </style>
    <style>
        .hp_left {
            width: 200px;
            float: left;
            margin: 30px 0 0 20px;
        }

        .byregion {
            margin-bottom: 20px;
        }

        .byregion ul {
            margin: 0;
        }

        .byregion li {
            float: left;
            list-style-type: none;
        }

        .byregion a {
            color: #1d1d1d;
            padding: 5px 10px;
        }

        .byregion a:hover {
            text-decoration: none;
        }

        .byfunction {
            margin-bottom: 20px;
        }

        .byfunction ul {
            margin: 0;
            position: relative;
        }

        .byfunction > ul > li {
            float: left;
            list-style-type: none;
            margin: 15px 0;
        }

        .byfunction > ul > li > ul > li {
            list-style-type: none;
        }

        .byfunction a {
            color: #1d1d1d;
            padding: 5px 10px;
        }

        .byfunction a:hover {
            text-decoration: none;
        }

        .byfunction a.active {
            background: #0574b7;
            color: #fff;
        }

        #function_list {
            display: none;
            position: absolute;
            left: 0;
            padding: 10px;
            width: 150px;
            border: 1px solid #ccc;
            background: #fff;
        }

        #function_list a {
            color: #616161;
        }

        .hp_right {
            margin-left: 220px;
        }
    </style>
    <link rel="stylesheet" href="static/navigation/css/MySocialShare.css"
          type="text/css"/>
</head>
<div class="page-content">
    <div class="row">
        <div class="col-xs-12" style="margin-left:-1px;">
            <div id="winimg" style="width:100%; overflow:hidden;">
                <img src="static/navigation/assets/images/indexbanner.jpg"
                     style="width:100%;">
            </div>
            <div class="hp_left">
                <div class="byregion">
                    <img src="static/navigation/assets/images/region.png"
                         onclick="queryItem('1')" style="cursor: pointer;"> <br/>
                    <br/>
                    <ul>

                        <c:choose>
                            <c:when test="${not empty districtList }">
                                <c:forEach items="${districtList }" var="item" varStatus="vs">
                                    <li><a href="javascript:"
                                           onclick="showDeptByDis('${item.BIANMA }')">${item.NAME }</a>
                                    </li>
                                    <li><span>|</span>
                                    </li>
                                </c:forEach>
                            </c:when>
                        </c:choose>
                    </ul>
                    <div id="cleaner"></div>
                </div>
                <div class="byfunction">
                    <img src="static/navigation/assets/images/function.png"
                         onclick="queryItem('2')" style="cursor: pointer;"> <br/>
                    <br/>
                    <ul>

                        <c:choose>
                            <c:when test="${not empty functionList }">
                                <c:forEach items="${functionList }" var="item" varStatus="vs">
                                    <c:if test="${vs.index == 0}">
                                        <li><a href="javascript:" onclick="showDeptByFun('${item.BIANMA }')"
                                               class="active">${item.NAME}</a>
                                            <ul id="function_list" style="display:block;">
                                                <c:choose>
                                                    <c:when test="${not empty allDeptList}">
                                                        <c:forEach items="${allDeptList }" var="dept">
                                                            <c:if test="${item.BIANMA == dept.FUNCTION }">
                                                                <li><a href="javascript:"
                                                                       onclick="openEmp('${dept.ID }')">${dept.DEPT_NAME }</a>
                                                                </li>
                                                            </c:if>
                                                        </c:forEach>
                                                    </c:when>
                                                </c:choose>
                                            </ul>
                                        </li>
                                        <li><span>|</span></li>
                                    </c:if>
                                    <c:if test="${vs.index != 0}">
                                        <li><a href="javascript:"
                                               onclick="showDeptByFun('${item.BIANMA }')">${item.NAME}</a>
                                            <ul id="function_list">
                                                <c:choose>
                                                    <c:when test="${not empty allDeptList}">
                                                        <c:forEach items="${allDeptList }" var="dept">
                                                            <c:if test="${item.BIANMA == dept.FUNCTION }">
                                                                <li><a href="javascript:"
                                                                       onclick="openEmp('${dept.ID }')">${dept.DEPT_NAME }</a>
                                                                </li>
                                                            </c:if>
                                                        </c:forEach>
                                                    </c:when>
                                                </c:choose>
                                            </ul>
                                        </li>
                                        <li><span>|</span></li>
                                    </c:if>
                                </c:forEach>
                            </c:when>
                        </c:choose>

                    </ul>
                    <div id="cleaner"></div>
                </div>
            </div>
            <div class="hp_right">
                <iframe name="showDataFrame" id="showDataFrame" frameborder="0"
                        src="showData.do?BM=null&&TYPE=2"
                        style="width: 100%;min-height: 400px;"></iframe>
            </div>
        </div>
        <!-- /.main-container-inner -->
    </div>
</div>
<!---/.page-content---->
<script type="text/javascript">
    var WinHeight = $(window.parent.document).height();//
    var imgHeight = $("#winimg").height();
    //alert(imgHeight);
    $("#showDataFrame").height(WinHeight - imgHeight - 45);
</script>
<script type="text/javascript">
    var html;
    var id;

    //点击按地域查看，按部门查看
    function queryItem(num) {
        $("#showDataFrame").attr("src", "showData.do?BM=null&&TYPE=" + num);
    }

    //按地域查看部门
    function showDeptByDis(BIANMA) {
        $("#showDataFrame").attr("src", "showData.do?BM=" + BIANMA + "&&TYPE=1");
    }

    //按职能查看部门
    function showDeptByFun(BIANMA) {
        $("#showDataFrame").attr("src", "showData.do?BM=" + BIANMA + "&&TYPE=2");
    }

    //打开员工页面
    function openEmp(deptId, deptName) {
        $("#showDataFrame").attr("src",
            "enterEmpData.do?deptId=" + deptId + "&&deptName=" + deptName);
    };
    $(".byfunction>ul>li>a").mouseover(function () {
        $(".byfunction>ul>li>a").removeClass("active");
        $(this).parent().siblings().find("#function_list").hide();
        $(this).toggleClass("active");
        $(this).siblings("#function_list").slideToggle();
    });
</script>
</body>
</html>
