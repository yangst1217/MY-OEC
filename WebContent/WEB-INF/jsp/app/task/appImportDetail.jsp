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
    <title>任务详情</title>
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

    <link rel="stylesheet" href="static/css/datepicker.css"/><!-- 日期框 -->
    <script type="text/javascript" src="static/js/jquery-1.7.2.js"></script>
    <script type="text/javascript" src="static/js/jquery.tips.js"></script>
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
    </style>

    <style type="text/css">
        * {
            margin: 0;
            padding: 0;
            list-style-type: none;
        }

        a, img {
            border: 0;
        }

        body {
            font: 12px/180% Arial, Helvetica, sans-serif;
        }

        /*quiz style*/
        .quiz {
            border: solid 1px #ccc;
            height: 270px;
            width: 772px;
        }

        .quiz h3 {
            font-size: 14px;
            line-height: 35px;
            height: 35px;
            border-bottom: solid 1px #e8e8e8;
            padding-left: 20px;
            background: #f8f8f8;
            color: #666;
            position: relative;
        }

        .quiz_content {
            padding-top: 10px;
            padding-left: 20px;
            position: relative;
            height: 205px;
        }

        .quiz_content .btm {
            border: none;
            width: 100px;
            height: 33px;
            background: url(static/images/btn.gif) no-repeat;
            margin: 10px 0 0 64px;
            display: inline;
            cursor: pointer;
        }

        .quiz_content li.full-comment {
            position: relative;
            z-index: 99;
            height: 41px;
        }

        .quiz_content li.cate_l {
            height: 24px;
            line-height: 24px;
            padding-bottom: 10px;
        }

        .quiz_content li.cate_l dl dt {
            float: left;
        }

        .quiz_content li.cate_l dl dd {
            float: left;
            padding-right: 15px;
        }

        .quiz_content li.cate_l dl dd label {
            cursor: pointer;
        }

        .quiz_content .l_text {
            height: 120px;
            position: relative;
            padding-left: 18px;
        }

        .quiz_content .l_text .m_flo {
            float: left;
            width: 47px;
        }

        .quiz_content .l_text .text {
            width: 634px;
            height: 109px;
            border: solid 1px #ccc;
        }

        .quiz_content .l_text .tr {
            position: absolute;
            bottom: -18px;
            right: 40px;
        }

        /*goods-comm-stars style*/
        .goods-comm {
            height: 41px;
            position: relative;
            z-index: 7;
        }

        .goods-comm-stars {
            line-height: 25px;
            padding-left: 12px;
            height: 41px;
            position: absolute;
            top: 0px;
            left: 0;
            width: 400px;
        }

        .goods-comm-stars .star_l {
            float: left;
            display: inline-block;
            margin-right: 5px;
            display: inline;
        }

        .goods-comm-stars .star_choose {
            float: left;
            display: inline-block;
        }

        /* rater star */
        .rater-star {
            position: relative;
            list-style: none;
            margin: 0;
            padding: 0;
            background-repeat: repeat-x;
            background-position: left top;
            float: left;
        }

        .rater-star-item, .rater-star-item-current, .rater-star-item-hover {
            position: absolute;
            top: 0;
            left: 0;
            background-repeat: repeat-x;
        }

        .rater-star-item {
            background-position: -100% -100%;
        }

        .rater-star-item-hover {
            background-position: 0 -48px;
            cursor: pointer;
        }

        .rater-star-item-current {
            background-position: 0 -48px;
            cursor: pointer;
        }

        /*.rater-star-item-current.rater-star-happy{background-position:0 -25px;}
        .rater-star-item-hover.rater-star-happy{background-position:0 -25px;}
        .rater-star-item-current.rater-star-full{background-position:0 -72px;}*/
        /* popinfo */
        .popinfo {
            display: none;
            position: absolute;
            top: 30px;
            background: url(images/comment/infobox-bg.gif) no-repeat;
            padding-top: 8px;
            width: 192px;
            margin-left: -14px;
        }

        .popinfo .info-box {
            border: 1px solid #f00;
            border-top: 0;
            padding: 0 5px;
            color: #F60;
            background: #FFF;
        }

        .popinfo .info-box div {
            color: #333;
        }

        .rater-click-tips {
            font: 12px/25px;
            color: #333;
            margin-left: 10px;
            background: url(images/comment/infobox-bg-l.gif) no-repeat 0 0;
            width: 125px;
            height: 34px;
            padding-left: 16px;
            overflow: hidden;
        }

        .rater-click-tips span {
            display: block;
            background: #FFF9DD url(images/comment/infobox-bg-l-r.gif) no-repeat 100% 0;
            height: 34px;
            line-height: 34px;
            padding-right: 5px;
        }

        .rater-star-item-tips {
            background: url(images/comment/star-tips.gif) no-repeat 0 0;
            height: 41px;
            overflow: hidden;
        }

        .cur.rater-star-item-tips {
            display: block;
        }

        .rater-star-result {
            color: #FF6600;
            font-weight: bold;
            padding-left: 10px;
            float: left;
        }
    </style>
    <!-- 引入 -->
    <script type="text/javascript">window.jQuery || document.write("<script src='static/js/jquery-1.9.1.min.js'>\x3C/script>");</script>
    <script src="static/js/bootstrap.min.js"></script>
    <script src="static/js/ace-elements.min.js"></script>
    <script src="static/js/ace.min.js"></script>
    <script type="text/javascript">
        // star choose
        jQuery.fn.rater = function (options) {
            var ss = $("#score").val();
            var isUsed = true;
            if ('${projectEvent.SCORE}' == null || '${projectEvent.SCORE}' == "" || '${projectEvent.SCORE}' == undefined) {
                isUsed = true;
            } else {
                isUsed = false;
            }
            // 默认参数
            var settings = {
                enabled: isUsed,
                url: '',
                method: 'post',
                step: 1,
                min: 1,
                max: 5,
                value: ss,
                after_click: null,
                before_ajax: null,
                after_ajax: null,
                title_format: null,
                info_format: null,
                image: 'static/images/stars.jpg',
                imageAll: 'WebRoot/static/images/stars-all.gif',
                defaultTips: false,
                clickTips: false,
                width: 24,
                height: 24
            };

            // 自定义参数
            if (options) {
                jQuery.extend(settings, options);
            }

            //外容器
            var container = jQuery(this);

            // 主容器
            var content = jQuery('<ul class="rater-star"></ul>');
            content.css('background-image', 'url(' + settings.image + ')');
            content.css('height', settings.height);
            content.css('width', (settings.width * settings.step) * (settings.max - settings.min + settings.step) / settings.step);
            // 当前选中的
            var item = jQuery('<li class="rater-star-item-current"></li>');
            item.css('background-image', 'url(' + settings.image + ')');
            item.css('height', settings.height);
            item.css('width', 0);
            item.css('z-index', settings.max / settings.step + 1);
            if (settings.value) {
                item.css('width', ((settings.value - settings.min) / settings.step + 1) * settings.step * settings.width);
            }
            ;
            content.append(item);


            // 星星
            for (var value = settings.min; value <= settings.max; value += settings.step) {
                item = jQuery('<li class="rater-star-item"><div class="popinfo"></div></li>');
                if (typeof settings.info_format == 'function') {
                    //item.attr('title' , settings.title_format(value));
                    item.find(".popinfo").html(settings.info_format(value));
                    item.find(".popinfo").css("left", (value - 1) * settings.width)
                }
                else {
                    item.attr('title', value);
                }
                item.css('height', settings.height);
                item.css('width', (value - settings.min + settings.step) * settings.width);
                item.css('z-index', (settings.max - value) / settings.step + 1);
                item.css('background-image', 'url(' + settings.image + ')');

                if (!settings.enabled) {	// 若是不能更改，则隐藏
                    item.hide();
                }

                content.append(item);
            }

            content.mouseover(function () {
                if (settings.enabled) {
                    jQuery(this).find('.rater-star-item-current').hide();
                }
            }).mouseout(function () {
                jQuery(this).find('.rater-star-item-current').show();
            })
            // 添加鼠标悬停/点击事件
            var shappyWidth = (settings.max - 2) * settings.width;
            var happyWidth = (settings.max - 1) * settings.width;
            var fullWidth = settings.max * settings.width;
            content.find('.rater-star-item').mouseover(function () {
                jQuery(this).prevAll('.rater-star-item-tips').hide();
                jQuery(this).attr('class', 'rater-star-item-hover');
                //jQuery(this).find(".popinfo").show();

                /*//当3分时用笑脸表示
                if(parseInt(jQuery(this).css("width"))==shappyWidth){
                    jQuery(this).addClass('rater-star-happy');
                }
                //当4分时用笑脸表示
                if(parseInt(jQuery(this).css("width"))==happyWidth){
                    jQuery(this).addClass('rater-star-happy');
                }
                //当5分时用笑脸表示
                if(parseInt(jQuery(this).css("width"))==fullWidth){
                    jQuery(this).removeClass('rater-star-item-hover');
                    jQuery(this).css('background-image' , 'url(' + settings.imageAll + ')');
                    jQuery(this).css({cursor:'pointer',position:'absolute',left:'0',top:'0'});
                }*/
            }).mouseout(function () {
                var outObj = jQuery(this);
                outObj.css('background-image', 'url(' + settings.image + ')');
                outObj.attr('class', 'rater-star-item');
                outObj.find(".popinfo").hide();
                //outObj.removeClass('rater-star-happy');
                jQuery(this).prevAll('.rater-star-item-tips').show();
                //var startTip=function () {
                //outObj.prevAll('.rater-star-item-tips').show();
                //};
                //startTip();
            }).click(function () {
                //jQuery(this).prevAll('.rater-star-item-tips').css('display','none');
                jQuery(this).parents(".rater-star").find(".rater-star-item-tips").remove();
                jQuery(this).parents(".goods-comm-stars").find(".rater-click-tips").remove();
                jQuery(this).prevAll('.rater-star-item-current').css('width', jQuery(this).width());
                if (parseInt(jQuery(this).prevAll('.rater-star-item-current').css("width")) == happyWidth || parseInt(jQuery(this).prevAll('.rater-star-item-current').css("width")) == shappyWidth) {
                    jQuery(this).prevAll('.rater-star-item-current').addClass('rater-star-happy');
                }
                else {
                    jQuery(this).prevAll('.rater-star-item-current').removeClass('rater-star-happy');
                }
                if (parseInt(jQuery(this).prevAll('.rater-star-item-current').css("width")) == fullWidth) {
                    jQuery(this).prevAll('.rater-star-item-current').addClass('rater-star-full');
                }
                else {
                    jQuery(this).prevAll('.rater-star-item-current').removeClass('rater-star-full');
                }
                var star_count = (settings.max - settings.min) + settings.step;
                var current_number = jQuery(this).prevAll('.rater-star-item').size() + 1;
                var current_value = settings.min + (current_number - 1) * settings.step;

                //显示当前分值
                if (typeof settings.title_format == 'function') {
                    jQuery(this).parents().nextAll('.rater-star-result').html(current_value + '分&nbsp;' + settings.title_format(current_value));
                }
                $("#score").val(current_value);
                //jQuery(this).parents().next('.rater-star-result').html(current_value);
                //jQuery(this).unbind('mouseout',startTip)
            })

            jQuery(this).html(content);

        }

        // 星星打分
        $(function () {
            var options = {
                max: 5,
                title_format: function (value) {
                    var title = '';
                    switch (value) {
                        case 1 :
                            title = '很不满意';
                            break;
                        case 2 :
                            title = '不满意';
                            break;
                        case 3 :
                            title = '一般';
                            break;
                        case 4 :
                            title = '满意';
                            break;
                        case 5 :
                            title = '非常满意';
                            break;
                        default :
                            title = value;
                            break;
                    }
                    return title;
                },
                info_format: function (value) {
                    var info = '';
                    switch (value) {
                        case 1 :
                            info = '<div class="info-box">1分&nbsp;很不满意<div>商品样式和质量都非常差，太令人失望了！</div></div>';
                            break;
                        case 2 :
                            info = '<div class="info-box">2分&nbsp;不满意<div>商品样式和质量不好，不能满足要求。</div></div>';
                            break;
                        case 3 :
                            info = '<div class="info-box">3分&nbsp;一般<div>商品样式和质量感觉一般。</div></div>';
                            break;
                        case 4 :
                            info = '<div class="info-box">4分&nbsp;满意<div>商品样式和质量都比较满意，符合我的期望。</div></div>';
                            break;
                        case 5 :
                            info = '<div class="info-box">5分&nbsp;非常满意<div>我很喜欢！商品样式和质量都很满意，太棒了！</div></div>';
                            break;
                        default :
                            info = value;
                            break;
                    }
                    return info;
                }
            }
            $('#rate-comm-1').rater(options);
        });

        //补录日清
        function addDailyTaskByPI() {
            if (${pd.overDays>3}) {
                alert("超过3天不能补录");
                return;
            }
            showTaskDialog('pi');
        }

        //员工日清
        function addDailyTask() {
            showTaskDialog('');
        }

        //添加日清
        function showTaskDialog(type) {
            //员工日清-超期不能填写
            if (type == '' && '${pd.isOverDay}' == 'true') {
                alert("已超过任务结束时间，不能填报日清");
                return;
            }
            //没有活动分解项，则不能进行日清
            var splitCount = "${projectEvent.SPLIT_COUNT}";
            if (splitCount == "0") {
                alert("重点协同活动没有未完成的分解项，不能添加日清");
                return;
            }
            //本次日清需要完成的进度
            var taskCount = "${projectEvent.taskCount}";
            //alert(taskCount);
            //活动结束时间，用于计算是否超期
            var endTime = "${projectEvent.END_DATE }";
            window.location.href = '<%=basePath%>app_task/toAddImportTask.do?&show=${pd.show}&showDept=${pd.showDept}&loadType=${pd.loadType}&startDate=${pd.startDate}&endDate=${pd.endDate}&projectCode=${pd.projectCode}&taskCount=' + taskCount
                + "&projectEventId=" + ${projectEvent.ID} +"&endTime=" + endTime;
        }

        //删除任务
        function delTask(id) {
            if (confirm("确定要删除?")) {
                var url = "<%=basePath%>app_task/deleteImportTask.do?id=" + id;
                $.get(url, function (data) {
                    if (data == "success") {
                        alert("删除成功！");
                        window.location.reload();
                    } else {
                        alert("删除失败！");
                    }
                }, "text");
            }
        }

        //日清任务-审核
        function validate(taskTime, id, isPass) {
            var cmd = "";
            if (isPass == 1) {
                cmd = "通过";
            } else {
                cmd = "退回";
            }
            if (confirm("确认" + cmd + "?")) {
                var url = "<%=basePath%>app_task/validateEventEmpTask.do?id=" + id + "&isPass=" + isPass;
                url += "&projectEventId=${projectEvent.ID}" + "&taskTime=" + taskTime +
                    "&startDate=${projectEvent.START_DATE }&endDate=${projectEvent.END_DATE }";
                $.get(url, function (data) {
                    if (data == "success") {
                        alert("审核成功！");
                        window.location.reload();
                    } else {
                        alert("审核失败！");
                    }
                }, "text");
            }
            ;
        }

        //添加日清批示
        function addComment() {
            window.location.href = '<%=basePath%>app_task/toAddImportComment.do?&show=${pd.show}&showDept=${pd.showDept}&loadType=${pd.loadType}&startDate=${pd.startDate}&endDate=${pd.endDate}&projectCode=${pd.projectCode}&deptCode=${pd.deptCode}&empCode=${pd.empCode}&projectEventId=${projectEvent.ID}';
        }

        //评价活动
        function assessEvent() {
            if ($("#score").val() == '') {
                alert("请评价活动!");
                return;
            }
            $.ajax({
                url: '<%=basePath%>app_task/assessEvent.do?id=${projectEvent.ID}&score=' + $("#score").val(),
                type: 'post',
                dataType: 'text',
                success: function (data) {
                    if ("success" == data) {
                        $("#assessBtn").hide();
                    } else {
                        top.Dialog.alert("评价活动失败，请联系管理员!");
                    }
                }
            });
        }

        //下载文件
        function loadFile(fileName) {
            var action = '<%=basePath%>app_task/checkFile.do';
            var time = new Date().getTime();
            $.ajax({
                type: "get",
                dataType: "text",
                data: {"fileName": fileName, "time": time},
                url: action,
                success: function (data) {
                    if (data == "") {
                        alert("文件不存在！");
                        return;
                    }
                    window.location.href = '<%=basePath%>app_task/loadFile.do?fileName=' + fileName + "&time=" + time;
                }
            });
        }
    </script>
</head>
<body>
<div class="web_title">
    <!-- 返回 -->
    <div class="back" style="top:5px">
        <c:choose>
        <c:when test="${empty pd.showDept }">
        <a href="<%=basePath %>app_task/listDesk.do?&show=${pd.show}&showDept=${pd.showDept}&loadType=${pd.loadType }&startDate=${pd.startDate }&endDate=${pd.endDate }&projectCode=${pd.projectCode }">
            </c:when>
            <c:otherwise>
            <a href="<%=basePath %>app_task/listBoard.do?show=${pd.show}&showDept=${pd.showDept}&loadType=${pd.loadType }&startDate=${pd.startDate }&endDate=${pd.endDate }&projectCode=${pd.projectCode }&deptCode=${pd.deptCode }&empCode=${pd.empCode }">
                </c:otherwise>
                </c:choose>

                <img src="static/app/images/left.png"/></a>
    </div>
    <!-- tab页 -->
    <div class="web_menu" style="width:90%; margin-left:20px;">
        <ul id="myTab" class="nav nav-tabs">
            <li class="active" style="width:30%;"><a style="width:100%; padding-right:0; padding-left:0;" href="#detail"
                                                     data-toggle="tab">目标详情</a></li>
            <li style="width:30%;"><a style="width:100%; padding-right:0; padding-left:0;" href="#taskList"
                                      data-toggle="tab">工作列表</a></li>
            <li style="width:30%;"><a style="width:100%; padding-right:0; padding-left:0;" href="#commentList"
                                      data-toggle="tab">批示列表</a></li>
        </ul>
    </div>
    <div id="normal" class="normal" style="width: 100%;text-align: right">
        <c:if test="${pd.show==2 }"><!-- 员工日清 -->
        <a class="btn btn-mini btn-info" onclick="addDailyTask();" style="margin: 5px 2px 0 0;">添加日清</a>
        </c:if>
        <c:if test="${pd.show==3 }"><!-- 领导-日清看板 -->
        <c:if test="${projectEvent.actual_percent==100.00 && empty projectEvent.SCORE}">
            <a id="assessBtn" onclick="assessEvent();" class="btn btn-mini btn-info"
               style="margin: 5px 2px 0 0;  ">评价活动</a>
        </c:if>
        <a class="btn btn-mini btn-info" onclick="addComment();" style="margin: 5px 2px 0 0;  ">添加日清批示</a>
        </c:if>
        <c:if test="${pd.userRoleName=='PI' && pd.isOverDay}">
            <a class="btn btn-mini btn-info" onclick="addDailyTaskByPI();" style="margin: 5px 3px 0 0; float:right;">补录日清</a>
        </c:if>

    </div>
</div>

<div id="zhongxin" style="width:98%; margin: 30px auto; border: none" class="tab-content">
    <!-- 重点协同详情 -->
    <div class="tab-pane fade in active" id="detail">
        <table style="width: 100%;margin-top: 20px;">
            <tr>
                <td style="text-align: center;"><label>项目名称：</label></td>
                <td style="text-align: left;">
                    <input type="text" readonly="readonly" value="${projectEvent.PROJECT_NAME }"
                           class="title" title="${projectEvent.PROJECT_NAME }"/></td>
            </tr>
            <tr>
                <td style="text-align: center;"><label>节点名称：</label></td>
                <td style="text-align: left;"><input type="text" readonly="readonly"
                                                     value="${projectEvent.NODE_TARGET }"
                                                     class="title" title="${projectEvent.NODE_TARGET }"/></td>
            </tr>
            <tr>
                <td style="text-align: center;"><label>权重：</label></td>
                <td style="text-align: left;"><input type="text" readonly="readonly" value="${projectEvent.WEIGHT }"
                                                     class="title" title="${projectEvent.WEIGHT }"/></td>
            </tr>
            <tr>
                <td style="text-align: center;"><label>活动名称：</label></td>
                <td style="text-align: left;"><input type="text" readonly="readonly"
                                                     value="${projectEvent.EVENT_NAME }"/></td>
            </tr>

            <tr>
                <td style="text-align: center;"><label>活动类型：</label></td>
                <td style="text-align: left;"><input type="text" readonly="readonly" value="${projectEvent.TYPE }"/>
                </td>
            </tr>
            <tr>
                <td style="text-align: center;"><label>活动成本：</label></td>
                <td style="text-align: left;"><input type="text" readonly="readonly" value="${projectEvent.COST }"/>
                </td>
            </tr>
            <tr>
                <td style="text-align: center;"><label>开始时间：</label></td>
                <td style="text-align: left;"><input type="text" readonly="readonly"
                                                     value="${projectEvent.START_DATE }"/></td>
            </tr>
            <tr>
                <td style="text-align: center;"><label>结束时间：</label></td>
                <td style="text-align: left;"><input type="text" readonly="readonly" value="${projectEvent.END_DATE }"/>
                </td>
            </tr>
            <tr>
                <td style="text-align: center;"><label>当前SPI：</label></td>
                <td style="text-align: left;"><input type="text" readonly="readonly" value="${projectEvent.spi }"/></td>
            </tr>
            <tr>
                <td style="text-align: center;"><label>预计完成时间：</label></td>
                <td style="text-align: left;"><input type="text" readonly="readonly"
                                                     value="${projectEvent.expect_date }"/></td>
            </tr>
            <tr>
                <td style="text-align: center;"><label>计划进度：</label></td>
                <td style="text-align: left;">
                    <div class="progress progress-info progress-striped opacity"
                         style="height: 30px; margin-bottom:0px; border: 1px solid #ccc;">
                        <div class="bar" style="width: ${projectEvent.plan_percent }%; line-height: 30px;">
                            <span style="color:black">${projectEvent.plan_percent }%</span>
                        </div>
                    </div>
                </td>
            </tr>

            <tr>
                <td style="text-align: center;"><label>实际进度：</label></td>
                <td style="text-align: left;">
                    <div class="progress"
                         style="height:30px; margin:0px; background-color: #dadada; border: 1px solid #ccc;">
                        <c:choose>
                            <c:when test="${projectEvent.overProgress>=0 }">
                                <div class="progress-bar success" role="progressbar" aria-valuenow="60"
                                     aria-valuemin="0"
                                     aria-valuemax="100"
                                     style="width: ${projectEvent.actual_percent }%; line-height: 30px; text-align: center"></div>
                            </c:when>
                            <c:otherwise>
                                <div class="progress-bar warning" role="progressbar" aria-valuenow="60"
                                     aria-valuemin="0"
                                     aria-valuemax="100"
                                     style="width: ${projectEvent.actual_percent }%; line-height: 30px; text-align: center"></div>
                            </c:otherwise>
                        </c:choose>
                        <span style="color: black">${projectEvent.actual_percent }%</span>
                    </div>
                </td>
            </tr>


            <c:if test="${projectEvent.actual_percent==100.00 && empty projectEvent.SCORE}">
                <tr>
                    <td style="text-align: center;"><label>评价得分：</label></td>
                    <td width="200px">
                        <span class="rater-star" id="rate-comm-1">${projectEvent.SCORE }</span>
                    </td>
                    <td>
                        <input type="hidden" name="score" id="score" value="${projectEvent.SCORE}" maxlength="32"
                               style="width:50px;" readonly>
                    </td>
                </tr>
            </c:if>
            <c:if test="${projectEvent.actual_percent==100.00 && not empty projectEvent.SCORE}">
                <tr>
                    <td style="text-align: center;"><label>评价得分：</label></td>
                    <td width="200px">
                        <span class="rater-star" id="rate-comm-1">${projectEvent.SCORE }</span>
                    </td>
                    <td><input type="hidden" name="score" id="score" value="${projectEvent.SCORE}" maxlength="32"
                               style="width:50px;" readonly></td>
                </tr>
            </c:if>
        </table>
    </div>
    <!-- 工作列表 -->
    <div class="tab-pane fade" id="taskList">
        <c:choose>
            <c:when test="${not empty emptaskList }">
                <c:forEach items="${emptaskList }" var="empTask" varStatus="vs">
                    <div class="keytask">
                        <table>
                            <tr>
                                <td style="width:60px">添加人:</td>
                                <td style="width:85px"><c:if
                                        test="${projectEvent.EMP_NAME!=empTask.CREATE_USER }">PI补录-</c:if>
                                    ${empTask.CREATE_USER }</td>
                                <td style="width:70px">,添加时间:</td>
                                <td><span>${empTask.CREATE_TIME }</span></td>
                            </tr>
                            <tr>
                                <td>完成活动:</td>
                                <td colspan="3"><span>${empTask.splitName}</span></td>
                            </tr>
                            <tr>
                                <td>当天完成:</td>
                                <td colspan="3"><span>${empTask.DAILY_COUNT }</span></td>
                            </tr>
                            <tr>
                                <td>差异分析:</td>
                                <td colspan="3"><span>${empTask.ANALYSIS }</span></td>
                            </tr>
                            <tr>
                                <td>关差措施:</td>
                                <td colspan="3"><span>${empTask.MEASURE }</span></td>
                            </tr>
                            <tr>
                                <td>当天进度:</td>
                                <td colspan="3"><span>${empTask.FINISH_PERCENT }%</span></td>
                            </tr>
                            <tr>
                                <td>进度滞后:</td>
                                <td colspan="3">
											<span>
												<c:if test="${empTask.ISDELAY==1 }">是</c:if>
												<c:if test="${empTask.ISDELAY==0 }">否</c:if>
											</span>
                                </td>
                            </tr>
                            <tr>
                                <td>审核人:</td>
                                <td colspan="3"><span>${empTask.UPDATE_USER_NAME }</span></td>
                            </tr>
                            <tr>
                                <td>状态:</td>
                                <td><span>${empTask.STATUS }</span></td>
                                <td colspan="2" style="text-align: right">
                                    <!-- 员工才可以删除 -->
                                    <c:if test="${pd.show==2 && empTask.STATUS=='草稿'}">
                                        <a style="cursor:pointer;" onclick="delTask(${empTask.ID})"
                                           title="删除" class='btn btn-mini btn-danger' data-rel="tooltip"
                                           data-placement="left">
                                            删除<i class="icon-trash"></i>
                                        </a>
                                    </c:if>
                                    <!-- 领导才可以审批 -->
                                    <c:if test="${pd.show==3 && empTask.STATUS=='草稿' }">
                                        <a style="cursor:pointer;"
                                           onclick="validate('${empTask.CREATE_TIME }', ${empTask.ID}, 1)"
                                           title="审核通过" class='btn btn-mini btn-success' data-rel="tooltip"
                                           data-placement="left">
                                            通过<i class="icon-check"></i>
                                        </a>
                                        <a style="cursor:pointer;"
                                           onclick="validate('${empTask.CREATE_TIME }', ${empTask.ID}, 0)"
                                           title="审核退回" class='btn btn-mini btn-danger' data-rel="tooltip"
                                           data-placement="left">
                                            退回<i class="icon-exclamation-sign"></i>
                                        </a>
                                    </c:if>
                                    <c:if test="${not empty empTask.FILENAME }">
                                        <a style="cursor:pointer;" onclick="loadFile('${empTask.FILENAME}')"
                                           title="查看附件" class='btn btn-mini btn-primary' data-rel="tooltip"
                                           data-placement="left">
                                            附件<i class="icon-eye-open"></i>
                                        </a>
                                    </c:if>
                                </td>
                            </tr>
                        </table>
                    </div>
                </c:forEach>
            </c:when>
            <c:otherwise>
                <span>没有数据</span>
            </c:otherwise>
        </c:choose>
    </div>
    <!-- 批示列表 -->
    <div class="tab-pane fade" id="commentList">
        <c:choose>
            <c:when test="${not empty commentList }">
                <c:forEach items="${commentList }" var="comment" varStatus="vs">
                    <div class="keytask">
                        <table>
                            <tr>
                                <td style="width:70px">添加时间:</td>
                                <td><span>${comment.CREATE_TIME }</span>
                                </td>
                            </tr>
                            <tr>
                                <td>批示内容:</td>
                                <td><span>${comment.COMMENT }</span>
                                </td>
                            </tr>
                            <tr>
                                <td>批示人:</td>
                                <td><span>${comment.CREATE_USER }</span>
                                </td>
                            </tr>
                        </table>
                    </div>
                </c:forEach>
            </c:when>
            <c:otherwise>
                <tr class="main_info">
                    <td colspan="100" class="center">没有相关数据</td>
                </tr>
            </c:otherwise>
        </c:choose>
    </div>
</div>

<div>
    <%@include file="../footer.jsp" %>
</div>

</body>
</html>