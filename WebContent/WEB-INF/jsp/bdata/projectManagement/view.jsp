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
    <!-- jsp文件头和头部 -->
    <link type="text/css" rel="StyleSheet" href="plugins/Bootstrap/css/bootstrap.min.css"/>
    <link type="text/css" rel="StyleSheet" href="plugins/Bootgrid/jquery.bootgrid.min.css"/>
    <link href="static/css/style.css" rel="stylesheet"/>
    <link rel="stylesheet" href="static/css/font-awesome.min.css"/>
    <link rel="stylesheet" href="static/css/bootgrid.change.css"/>

    <style>
        #product {
            width: 950px;
            height: 100px;
            border: 1px solid #ccc;
            border-left: 0;
            border-right: 0;
        }

        #product div#content {
            position: relative;
            width: 850px;
            height: 100px;
            display: inline-block;
            overflow: hidden;
            float: left;
        }

        #product div#content_list {
            position: absolute;
            width: 4000px;
        }

        #product dl {
            width: 160px;
            height: 70px;
            float: left;
            margin: 13px 4px;
            padding: 2px 2px;
        }

        #product dl dt, dd {
            line-height: 70px;
            background: #4185d0;
        }

        #product dl dt, dd a {
            color: #fff;
        }

        #product dl dt, dd a:hover {
            color: #fff;
            text-decoration: none;
        }

        #product dl dt img {
            width: 160px;
            height: 120px;
            border: none;
        }

        #product dl dd {
            text-align: center;
        }

        #product span.prev {
            cursor: pointer;
            display: inline-block;
            width: 30px;
            height: 100px;
            margin-left: 10px;
            background: url(static/images/prev.png) no-repeat left center;
            float: left;
        }

        #product span.next {
            cursor: pointer;
            display: inline-block;
            width: 30px;
            height: 100px;
            margin-right: 10px;
            background: url(static/images/next.png) no-repeat left center;
            float: right;
        }

        .pay_title {
            font-size: 18px;
            border-left: 5px solid #005ba8;
            padding-left: 10px;
            margin: 15px 0;
        }

        /* .pay_option{ margin:50px 0;} */
        .pay_project {
            padding-top: 20px;
        }

        .pay_project_left {
            float: left;
            margin-right: 20px;
        }

        .pay_project_right {
            float: left;
        }

        .project_operator {
            float: left;
            margin-top: -3px;
            margin-left: 50px;
        }

        .project_info {
            width: 950px;
            height: 110px;
            margin-top: 5px;
            padding: 10px;
            border: 1px solid #ccc;
        }

        .radiusbtn {
            color: #fff;
            border-radius: 25px;
            padding: 5px 10px;
        }

        .radiusbtn:hover {
            color: #fff;
            text-decoration: none;
        }

        .radiusbtn:focus {
            color: #fff;
            text-decoration: none;
        }
    </style>

</head>
<body>

<!---右侧部门选择--->
<div id="main-content">
    <!---右侧表格显示--->
    <div class="main-content">
        <div class="breadcrumbs" id="breadcrumbs"
             style="font-size:18px;font-weight:bold;margin-left:30px;margin-top:10px;">
            薪资方案：查看
            <a class="btn btn-mini btn-danger" onclick="goBack();"
               style="margin-left:780px;margin-top:5px;">返回</a>
        </div>
        <div class="page-content">
            <div class="row">
                <div class="col-xs-12" style="margin-left:30px;">
                    <div class="pay_option">
                        <div class="pay_title">工资条目</div>
                        <div id="product">
                            <span class="prev"></span>
                            <div id="content">
                                <div id="content_list">

                                    <c:forEach items="${salaryList}" varStatus="vs" var="salary">
                                        <dl>
                                            <dd><a>${salary.NAME}</a></dd>
                                        </dl>
                                    </c:forEach>

                                </div>
                            </div>
                            <span class="next"></span>
                        </div>
                    </div>
                    <div id="cleaner"></div>
                    <div class="pay_project">
                        <div class="pay_title">方案配置</div>
                        <div class="pay_project_left">
                            <!-- <table id="sample-table-1" class="table table-striped table-bordered table-hover">
                            <thead>
                                <tr>
                                    <th>类别</th>
                                    <th>公式模板</th>
                                </tr>
                            </thead>
                            <tbody>
                                <tr>
                                    <td>方案1</td>
                                    <td>基本工资+岗位工资+绩效工资</td>
                                </tr>
                                <tr>
                                    <td>方案2</td>
                                    <td>基本工资+岗位工资+绩效工资</td>
                                </tr>
                                <tr>
                                    <td>方案3</td>
                                    <td>基本工资+岗位工资+绩效工资</td>
                                </tr>
                                <tr>
                                    <td>方案4</td>
                                    <td>基本工资+岗位工资+绩效工资</td>
                                </tr>
                            </tbody>
                            </table> -->
                        </div>
                        <div class="pay_project_right">
                            <div style="font-size:18px; float:left;">录入公式</div>
                            <div class="project_operator">
                                <c:forEach items="${operList}" varStatus="vs" var="oper">
                                    <c:if test="${oper.NAME == '+' }">
                                        <img src="static/images/operator_01.png" alt="${oper.NAME}">
                                    </c:if>
                                    <c:if test="${oper.NAME == '-' }">
                                        <img src="static/images/operator_02.png" alt="${oper.NAME}">
                                    </c:if>
                                    <c:if test="${oper.NAME == '*' }">
                                        <img src="static/images/operator_03.png" alt="${oper.NAME}">
                                    </c:if>
                                    <c:if test="${oper.NAME == '/' }">
                                        <img src="static/images/operator_04.png" alt="${oper.NAME}">
                                    </c:if>
                                    <c:if test="${oper.NAME == '(' }">
                                        <img src="static/images/operator_05.png" alt="${oper.NAME}">
                                    </c:if>
                                    <c:if test="${oper.NAME == ')' }">
                                        <img src="static/images/operator_06.png" alt="${oper.NAME}">
                                    </c:if>
                                </c:forEach>

                            </div>
                            <div style="float:right;">
                                <a href="javascript:" class="radiusbtn" style="background:#4185d0;"
                                   onClick="saveProject()">保存</a>
                                <a href="javascript:" class="radiusbtn" style="background:#4185d0;"
                                   onClick="reviseProject()">删除</a>
                                <a href="javascript:" class="radiusbtn" style="background:#4185d0;"
                                   onClick="deleteProject()">清空</a>
                            </div>
                            <div id="cleaner"></div>
                            <div class="project_info">
                                <span class="element">${pd.FORMULA}</span>
                            </div>
                            <div class="project_output" style="display:none;"></div>
                        </div>
                    </div>

                </div>
            </div>
        </div>
    </div>
</div>

<!-- 引入 -->
<script type="text/javascript" src="plugins/JQuery/jquery.min.js"></script>
<script type="text/javascript" src="plugins/Bootstrap/js/bootstrap.min.js"></script>
<script src="static/js/ace-elements.min.js"></script>
<script src="static/js/ace.min.js"></script>
<script src="static/js/jquery-1.7.2.js"></script>
<script type="text/javascript" src="static/js/chosen.jquery.min.js"></script><!-- 下拉框 -->
<script type="text/javascript" src="plugins/Bootgrid/jquery.bootgrid.min.js"></script>
<!-- 引入 -->

<script type="text/javascript">
    $(function () {
        var page = 1;
        var i = 5; //每版放4个图片
        //向后 按钮
        $("span.next").click(function () {    //绑定click事件
            var content = $("div#content");
            var content_list = $("div#content_list");
            var v_width = content.width() / i;
            var len = content.find("dl").length;
            var page_count = Math.ceil(len) - 4;   //只要不是整数，就往大的方向取最小的整数
            if (page_count <= 0) {
                page_count = 1;
            }
            if (!content_list.is(":animated")) {    //判断“内容展示区域”是否正在处于动画
                if (page == page_count) {  //已经到最后一个版面了,如果再向后，必须跳转到第一个版面。
                    //content_list.animate({ left : '0px'}, "slow"); //通过改变left值，跳转到第一个版面
                    //page = 1;
                } else {
                    content_list.animate({left: '-=' + v_width}, "slow");  //通过改变left值，达到每次换一个版面
                    page++;
                }
            }
        });
        //往前 按钮
        $("span.prev").click(function () {
            var content = $("div#content");
            var content_list = $("div#content_list");
            var v_width = content.width() / i;
            var len = content.find("dl").length;
            var page_count = Math.ceil(len / i);   //只要不是整数，就往大的方向取最小的整数
            if (!content_list.is(":animated")) {    //判断“内容展示区域”是否正在处于动画
                if (page == 1) {  //已经到第一个版面了,如果再向前，必须跳转到最后一个版面。
                    //content_list.animate({ left : '-='+v_width*(page_count-1) }, "slow");
                    //page = page_count;
                } else {
                    content_list.animate({left: '+=' + v_width}, "slow");
                    page--;
                }
            }
        });
    });

</script>

<script>
    <%-- $("#content_list dd").click(function(){
        var element	= $(this).text();
        //alert(element);
        $(".project_info").append('<span class="element">'+element+'</span>');
    });
    $(".project_operator img").click(function(){
        var operator	= $(this).attr("alt");
        //alert(operator);
        $(".project_info").append('<span class="element">'+operator+'</span>');
    });
    function saveProject(){
        $(".project_info span").each(function(){
            var info = $(this).text();
            $(".project_output").append(info+',');
        });

        if(confirm("保存当前方案?")){
            top.jzts();
            var info = $(".project_output").text();
            var url = "<%=basePath%>/projectManagement/add.do?addInfo="+encodeURIComponent(info);
            $.get(url,function(data){
                if(data=="success"){
                    window.location.href = "<%=basePath%>projectManagement/list.do";

                }else{
                    alert("方案保存失败！");
                }
            },"text");
        }

        //alert($(".project_output").text());
    }
    function reviseProject(){
        $(".project_info span:last").remove();
    }
    function deleteProject(){
        $(".project_info span").remove();
    } --%>
    //返回
    function goBack() {
        window.location.href = "<%=basePath%>projectManagement/list.do";
    }
</script>
<body style="overflow:-Scroll;overflow-y:hidden;overflow-x:hidden">
</body>
</html>
