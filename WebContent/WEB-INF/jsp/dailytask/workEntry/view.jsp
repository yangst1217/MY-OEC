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

    <style>
        input[type="checkbox"], input[type="radio"] {
            opacity: 1;
            position: static;
            height: 25px;
            margin-bottom: 10px;
        }

        #zhongxin td {
            height: 40px;
        }

        #zhongxin td label {
            text-align: right;
            margin-right: 10px;
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
    <script type="text/javascript">
        // star choose
        jQuery.fn.rater = function (options) {
            var ss = $("#SCORE").val();
            // 默认参数
            var settings = {
                enabled: true,
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
                $("#SCORE").val(current_value);
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
    </script>
</head>
<body>
<form action="workEntry/${msg}.do" name="completeForm" id="completeForm" method="post">
    <input type="hidden" name="ID" value="${pd.ID }"></input>
    <input type="hidden" name="NEED_CHECK" value="${pd.NEED_CHECK }"></input>
    <div id="zhongxin">
        <table style="margin:20px auto;">
            <tr>
                <td><label>实际完成：</label></td>
                <td><input type="text" name="REAL_COMPLETION" id="REAL_COMPLETION" value="${pd.REAL_COMPLETION }"
                           maxlength="32" readonly/></td>
            </tr>
            <tr>
                <td><label>任务完成说明：</label></td>
                <td><textarea name="DESCRIPTION" id="DESCRIPTION" readonly>${pd.DESCRIPTION }</textarea></td>
            </tr>
            <tr>
                <td>
                    <label>工作完成度：</label>
                </td>
                <td id="eq" width="70px">
                <span class="ui-slider-red">
                    <c:if test="${null != pd.FINISH_PERCENT}">${pd.FINISH_PERCENT}</c:if>
                    <c:if test="${null == pd.FINISH_PERCENT}">0</c:if>
                </span>
                    <input value="<c:if test="${null != pd.FINISH_PERCENT}">${pd.FINISH_PERCENT}</c:if><c:if test="${null == pd.FINISH_PERCENT}">0</c:if>"
                           type="text" id="FINISH_PERCENT" name="FINISH_PERCENT" style="width:22px;"
                           readonly="readonly"/>
                </td>
            </tr>
            <tr>
                <td><label>质量评价：</label></td>
                <td><input type="text" name="QA" id="QA" value="${pd.QA }" maxlength="32" readonly/></td>
            </tr>
            <tr>
                <td><label>评价得分：</label></td>
                <td width="200px">
				<span class="rater-star" id="rate-comm-1">
					 <c:if test="${null != pd.SCORE}">${pd.SCORE}</c:if>
					 <c:if test="${null == pd.SCORE}">0</c:if>
				</span>
                </td>
                <td><input type="hidden" name="SCORE" id="SCORE" value="${pd.SCORE }" maxlength="32" style="width:50px;"
                           readonly></td>
            </tr>

            <tr>
                <td colspan="2" style="text-align: center;">
                    <a class="btn btn-mini btn-primary" onclick="save();">更新完成度</a>
                    <a class="btn btn-mini btn-danger" onclick="top.Dialog.close();">关闭</a>
                </td>
            </tr>
        </table>
    </div>

    <div id="zhongxin2" class="center" style="display:none"><br/><br/><br/><br/><img
            src="static/images/jiazai.gif"/><br/><h4 class="lighter block green"></h4></div>

</form>

<!-- 引入 -->
<link rel="stylesheet" href="static/css/jquery-ui-1.10.2.custom.min.css"/>
<script type="text/javascript" src="static/js/jquery-ui-1.10.2.custom.min.js"></script>
<script type="text/javascript">window.jQuery || document.write("<script src='static/js/jquery-1.9.1.min.js'>\x3C/script>");</script>
<script src="static/js/bootstrap.min.js"></script>
<script src="static/js/ace-elements.min.js"></script>
<script src="static/js/ace.min.js"></script>
<script type="text/javascript" src="static/js/bootstrap-datepicker.min.js"></script><!-- 日期框 -->
<script type="text/javascript" src="static/js/chosen.jquery.min.js"></script><!-- 下拉框 -->
<script type="text/javascript" src="static/js/bootbox.min.js"></script><!-- 确认窗口 -->
<!-- 引入 -->
<script type="text/javascript" src="static/js/jquery.tips.js"></script><!--提示框-->
<script type="text/javascript">
    $(top.changeui());
    $(document).ready(function () {
        if ($("#user_id").val() != "") {
            $("#loginname").attr("readonly", "readonly");
            $("#loginname").css("color", "gray");
        }
    });

    //保存
    function save() {
        $("#completeForm").submit();
        $("#zhongxin").hide();
    }

    $(document).ready(function () {
        $("#eq > span").css({width: '70%', float: 'left', margin: '15px'}).each(function () {
            // read initial values from markup and remove that
            var value = parseInt($(this).text(), 10);
            $(this).empty().slider({
                value: value,
                range: "min",
                step: 5,
                min: 0,
                max: 100,
                animate: true,
                slide: function (event, ui) {
                    $("#FINISH_PERCENT").val(ui.value);
                }
            });
        });
    })
    $(function () {

        //单选框
        $(".chzn-select").chosen();
        $(".chzn-select-deselect").chosen({allow_single_deselect: true});

        //日期框
        $('.date-picker').datepicker();

    });

</script>

</body>
</html>