$(document).ready(function () {
    /*首页底部banner转换*/
    $('#moudleRemove').mouseenter(function () {
        $('#moudleRemove').hide();
        $('#moudleRemove1').show();
    });
    $('#moudleRemove1').mouseleave(function () {
        $('#moudleRemove').show();
        $('#moudleRemove1').hide();
    });
    $('#moudleRemove2').mouseenter(function () {
        $('#moudleRemove2').hide();
        $('#moudleRemove22').show();
    });
    $('#moudleRemove22').mouseleave(function () {
        $('#moudleRemove2').show();
        $('#moudleRemove22').hide();
    });
    $('#moudleRemove3').mouseenter(function () {
        $('#moudleRemove3').hide();
        $('#moudleRemove33').show();
    });
    $('#moudleRemove33').mouseleave(function () {
        $('#moudleRemove3').show();
        $('#moudleRemove33').hide();
    });
    /*首页底部banner转换*/
    /*首页input框样式*/
    if (typeof navigator !== 'undefined' && (/MSIE/.test(navigator.userAgent) || /Trident\//.test(navigator.appVersion))) {
        $(".loginUsername input").focus(
            function () {
                $(".loginUsername input")
                    .css({"background-color": "#ffffff"});
            });
        $(".loginUsername input").blur(function () {
            $(".loginUsername input").css({"background-color": "transparent"});
        });
        $(".loginPassword input").focus(
            function () {
                $(".loginPassword input")
                    .css({"background-color": "#ffffff"});
            });
        $(".loginPassword input").blur(function () {
            $(".loginPassword input").css({"background-color": "transparent"});
        });
    }
    ;
    /*首页input框样式*/
    /*右侧悬浮框关闭*/
    $(".pop-compare-top-close").click(function () {
        $('#pop-compare').hide();
    })

    /*导航下拉菜单样式js开始*/

    /*项目下拉菜单*/
    $(".navmenu").mouseover(function () {
        $(this).children("ul").show();
    })
    $(".navmenu").mouseout(function () {
        $(this).children("ul").hide();
    })
    /*tab具体内容页面切换*/
    $('.tag .jump').click(function () {
        $(".tag li.onactive").removeClass("onactive");
        $(this).addClass("onactive");
        $(".select").removeClass("select");
        $(".tag-div-tag1").hide().eq($(this).index()).show();
    })
    /*tab具体内容页面切换结束*/


    if (Object.hasOwnProperty.call(window, "ActiveXObject") && !window.ActiveXObject) {
        $(".windowCheckbox .text_checkbox").css("width", "261px")
    }

    /*导航菜单切换样式js*/
    $('.indexNav_a').on('click', function () {
        $(".indexNav_a").removeClass('onactive');
        $(this).addClass('onactive')
    })
    /*导航菜单切换样式js*/


    /*详情页加入收藏按钮*/
    $('#comp_899322').click(function () {
        if ($("#comp_899322").html() == '<span class="color1">收藏产品</span>') {
            $(this).addClass('btn-inverse');
            $("#comp_899322").html('<img src="images/collecttick.png"><span class="color2">已收藏</span>');
        } else {
            $("#comp_899322").removeClass('btn-inverse');
            $(this).html('<span class="color1">收藏产品</span>');
        }
    })
    $('#comp_899323').click(function () {
        if ($("#comp_899323").html() == '<span class="color1">收藏产品</span>') {
            $(this).addClass('btn-inverse');
            $("#comp_899323").html('<img src="images/collecttick.png"><span class="color2">已收藏</span>');
        } else {
            $("#comp_899323").removeClass('btn-inverse');
            $(this).html('<span class="color1">收藏产品</span>');
        }
    })
    /*详情页加入收藏按钮结束*/
    /*报价单详情页单选按钮*/
    $('.modulebox.moduleboxmid ul li a').click(function () {
        var thisToggle = $(this).is('.diqu') ? $(this) : $(this).prev();
        var checkBox = thisToggle.prev();
        checkBox.trigger('click');
        $('.diqu').removeClass('current');
        thisToggle.addClass('current');
        return false;
    });
    /*报价单详情单按钮结束*/
    /*产品库li标签浮动开始*/
    $(".gl-item").hover(function () {
            $(this).find(".p-copy").removeClass("hide");
            $(this).find(".p-review").removeClass("hide");
        },
        function () {
            $(this).find(".p-copy").addClass("hide");
            $(this).find(".p-review").addClass("hide");
        })
    /*产品库li标签浮动结束*/

    /*左侧菜单浮动开始*/
    $('.sideDel').mouseover(function () {
        $("#J_CategoryNavItem").addClass('category-list-slide');
        $(".side").removeClass('nobg');
    });
    $(".sideDel").mouseout(function () {
        $("#J_CategoryNavItem").removeClass('category-list-slide');
        $(".side").addClass('nobg');
    })
    /*左侧菜单浮动结束*/
    /*销售页面tr跳转开始*/
    $("#saleToquotation").click(function () {
        window.location.href = 'quotation.html';
    })
    /*销售页面tr跳转结束*/
    /*市场需求页面弹窗2检测IE*/
    var funPlaceholder = function (element) {
        var placeholder = '';
        if (element && !("placeholder" in document.createElement("input")) && (placeholder = element.getAttribute("placeholder"))) {
            element.onfocus = function () {
                if (this.value === placeholder) {
                    this.value = "";
                }
                this.style.color = '';
            };
            element.onblur = function () {
                if (this.value === "") {
                    this.value = placeholder;
                    this.style.color = 'graytext';
                }
            };

            //样式初始化
            if (element.value === "") {
                element.value = placeholder;
                element.style.color = 'graytext';
            }
        }
    };

    funPlaceholder(document.getElementById("refuseinfo"));


    /*市场需求列表跳转 */
    /*市场需求跳转到详情页 */
    $(".marketjumpno").click(function () {
        window.location.href = 'marketDetial.html';
    })

    $('#showpop').click(function () {
        $('.showscheme1').toggle();
        $('.showscheme').hide();
    })
    $('#marketshow').click(function () {
        $('.showscheme').toggle();
        if ($('.showscheme').css("display") == "none") {
            $("#marketshow").parent().children().css("border-bottom", "1px solid #fff");

        }
        else {
            $("#marketshow").parent().children().css("border-bottom", "0");
        }
    })

    $(".marketpop").click(function () {
        $("#marketpop-style").show();
    })
    $(".detialfont").click(function () {
        $("#marketpop-style").show();
    })
    $(".detialnoaccepct").click(function () {
        $("#marketnoaccept").show();
    })

    $(".pop-top-colse").click(function () {
        $("#marketpop-style").hide();
    })
    $(".wrapStyle").click(function () {
        $("#marketnoaccept").hide();
    })
    $(".marketdetial-tab .markettag1").click(function () {
        $("#markettagcss1").show();
        $("#markettagcss2").hide();
        $(".markettag1").css("color", "#FFFFFF");
        $(".markettag2").css("color", "#AED1ED");
        $(".triangle1").show();
        $(".triangle2").hide();
        $(".editlike").show();

    })
    $(".marketdetial-tab .markettag2").click(function () {
        $("#markettagcss2").show();
        $("#markettagcss1").hide();
        $(".markettag2").css("color", "#FFFFFF");
        $(".markettag1").css("color", "#AED1ED");
        $(".triangle2").show();
        $(".triangle1").hide();
        $(".editlike").hide();
    })
    /*$('#comp_899323').click(function(){
      if($("#comp_899323").html()=="<span>收藏产品</span>"){
        $(this).addClass('btn-inverse');
        $("#comp_899323 span").html('<img src="images/collecttick.png"><span>已收藏</span>');
      }else{
        $("#comp_899323").removeClass('btn-inverse');
        $(this).html("<span>收藏产品</span>");
      }
    })*/
    $("#marketsubmit").click(function () {
        $("#detial-weypopstyle").show();
    });

    $(".pop-top-colse").click(function () {
        $("#detial-weypopstyle").hide();

    });
    $(".market-login").click(function () {
        $(".pop1").hide();
        $(".pop2").show();
        $("#detial-weypopstyle").hide();
    });
    $(".market-login2").click(function () {
        if ($('.triangle1').css("display") == "block") {
            $("#markettagcss1 .pop1").hide();
            $("#markettagcss1 .pop2").show();
            $("#detial-weypopstyle").hide();

        } else {
            $("#markettagcss2 .pop1").hide();
            $("#markettagcss2 .pop2").show();
            $("#detial-weypopstyle").hide();
        }

    });
    /*判断火狐修改弹窗位置*/
    if (isFirefox = navigator.userAgent.indexOf("Firefox") > 0) {
        console.log("Firefox");
        $(".marketinfopop").css({"position": "relative", "bottom": "-200px"});
        $(".marketinfopop1").css({"position": "relative", "bottom": "0"});
    }
//市场需求列表跳转
    /*账户管理中的添加账号js样式*/
    $("#addProjectstyle").click(
        function () {
            $('#addinputBox').show();
        }
    )
    /*账户管理中的添加账号中确认按钮*/
    $("#accountbtn").click(
        function () {
            $('#addinputBox').hide();
            $('#accountAdd').show();
        }
    )
    /*账户管理页面中编辑按钮js样式*/
    $("#accountEdit").click(function () {
        $('#accountEditdefault').hide();
        $('#accountEditentry').show();
        $('#accountEdit').hide();
        $('#accountCheck').show();
    })
    /*账户管理页面中的编辑后的对号执行的操作*/
    $("#checkRight").click(
        function () {
            $('#accountEditdefault').show();
            $('#accountEditentry').hide();
            $('#accountEdit').show();
            $('#accountCheck').hide();
        })
    /*账户管理页面中的编辑后的x号执行的操作*/
    $("#checkError").click(
        function () {
            $("#accountEditentry :input").val("");
        }
    )
    /*账户管理页面中删除按钮js样式*/
    $("#accountDelete").click(function () {
        $('#accountAdd').hide();
    })
    /*首页中对该任务立项js*/
    $('#goodslist_table').on('mouseover', '.approval-pencil', function () {
        $(this).prepend('<div class="indexlx"><span class="indexlxText">对该任务立项</span><span class="indexliImg"></span></div>');
    }).on('mouseout', '.approval-pencil', function () {
        $(this).find('.indexlx').remove();
    });
    /*首页附件弹出框js*/
    $('#fjhover1').on('mouseover', '.indexfjpop', function () {
        $(this).prepend('<div class="fjWindow" id="fjWindow1"> <span class="fjWindowStyle">输出名称:ACF数据</span> <span class="fjWindowTriangle"></span> </div>');
    }).on('mouseout', '.indexfjpop', function () {
        $(this).find('.fjWindow').remove();
    });
    $('#fjhover1').on('mouseover', '.indexfjpop1', function () {
        $(this).prepend('<div class="fjWindow" id="fjWindow1"> <span class="fjWindowStyle">公开权限:对公司公开</span><span class="fjWindowTriangle"></span> </div>');
    }).on('mouseout', '.indexfjpop1', function () {
        $(this).find('.fjWindow').remove();
    });
    /*首页附件弹出框js*/
    /*WBS模板管理中对该任务立项js*/
    /*wbs模板分享复制删除按钮js*/
    $('#goodslist_table').on('mouseover', '.approval-fx', function () {
        $(this).prepend(' <div class="indexlxwbs"><span class="indexlxText">分享</span><span class="indexliImg"></span></div>');
    }).on('mouseout', '.approval-fx', function () {
        $(this).find('.indexlxwbs').remove();
    });
    $('#goodslist_table').on('mouseover', '.approval-copy', function () {
        $(this).prepend(' <div class="indexlxwbs"><span class="indexlxText">复制</span><span class="indexliImg"></span></div>');
    }).on('mouseout', '.approval-copy', function () {
        $(this).find('.indexlxwbs').remove();
    });
    $('#goodslist_table').on('mouseover', '.approval-delete', function () {
        $(this).prepend(' <div class="indexlxwbs"><span class="indexlxText">删除</span><span class="indexliImg"></span></div>');
    }).on('mouseout', '.approval-delete', function () {
        $(this).find('.indexlxwbs').remove();
    });

    /*上传附件弹出页面*/
    $('#uploadAttachments').click(function () {
        $('#shade1').show();
        $('#window1').show();
    });
    $('.indexeditStyle').click(function () {
        $('#shade1').show();
        $('#window1').show();
    });
    /*上传附件后弹窗关闭*/
    $("#pop-top-colse").click(function () {
        $('#shade1').hide();
        $('#window1').hide();
    });
    /*点击删除*/
    $(".indexpopdelete").click(function () {
        $('.indexpoptr').hide();
    });
    /*项目执行页面串联----------------------------------------------*/
    /*项目执行页面中的项目基本信息，点击编辑按钮后出现出现输入框*/
    $("#projecteditBtn").click(function () {
        $('#noeditor').hide();
        $('#editor').show();
        $('#projectBtn').show();

    });
    /*项目成员信息中的变更项目经理按钮*/
    $("#informationBtn1").click(function () {
        $('#cardstylebg').hide();
        $('#informationBtn1').hide();
        $('#cardstyleconfirm').show();
        $('#informationBtn2').show();
    });
    /*项目成员信息中的确认变更后项目经理下拉*/
    $("#drop-downedit").hover(
        function () {
            $('#drop-downedittext').show();
        }, function () {
            $('#drop-downedittext').hide();
        });
    /*项目成员信息中点击编辑按钮样式*/
    $("#editprojectBtn").click(
        function () {
            $('#informationStyle').hide();
            $('#edit-style').show();
            $('#editconfirmBtn').show();
        });
    /*项目成员信息中添加项目人*/
    $("#editaddProject").click(function () {
        $('#editaddProjectstyle').show();
    });
    /*项目成员添加项目人可删除数据*/
    $("#editconfirmBtn").click(function () {
        $('#edit-style').hide();
        $('#informationStyle').show();
        $('#editconfirmBtn').hide();
    });
    /*项目执行页面串联*/
    $("#projecttr1").click(function () {
        window.location.href = "projectWBSresolve.html";
    });
    $("#projecttr2").click(function () {
        window.location.href = "projectWBSresolve1.html";
    });
    $("#projecttr3").click(function () {
        window.location.href = "projectWBSdisplaySwitchedit1.html";
    });
    /*项目执行页面串联----------------------------------------------*/
    /*左侧菜单中立项添加页面*/
    $("#toolimg-lilx").click(function () {
        window.location.href = "projectImplement.html";
    });
    $("#toolimg-lizy").click(function () {
        window.location.href = "marketDemand.html";
    });
    /*wbs里面弹出评论页面*/
    $("#iconpl").click(function () {
        $("#wbsshade").show();
        $("#historyrecord").show();
    });
    $("#commentDelete").click(function () {
        $("#wbsshade").hide();
        //location.reload();
    });
    $("#commentDelete1").click(function () {
        $("#historyrecord").hide();
        $("#mutualrecond").css({
            "position": "absolute", "margin-left": "-300px", "width": "608px"

        });
    });
    /***************折叠面板****************/


    /*编辑文本信息*/
    /*function edit(){
        $(".messionSup .listStyle .editBtn").unbind('click').bind('click',function(){
            $(".messionSup .rowStyle").not($(this).parent().parent().next()).slideUp("slow");
            $(".messionSup .listStyle").not($(this).parent().parent().next()).find(".progress_operation").css('display','none');
            $(".messionSup .listStyle").not($(this).parent().parent().next()).find(".editStyle").css('display','block');

            $(this).parent().parent().next().slideToggle(500);
            $(this).parent().parent().find(".progress_operation").css('display','block');
            $(this).parent().parent().find(".editStyle").replaceWith('<div class="editStyle"><a class="dropup dropdown"></a></div>');
            $(this).parent().parent().next().find(".blackStyle")
            .replaceWith(
            '<div class="rowStyle" style="display:none;">'+
                '<div class="blackStyle">'+
                  '<div class="wrapStyle">'+
                    '<div class="wrapContentleft">'+'供应商编号:'+'</div>'+
                   ' <div class="wrapContentright">'+
                      '<input type="text" placeholder="" class="w180" value="">'+
                    '</div>'+
                  '</div>'+
               ' </div>'+
                '<div class="blackStyle">'+
                  '<div class="wrapStyle">'+
                    '<div class="wrapContentleft">'+'供应商名称：'+'</div>'+
                    '<div class="wrapContentright">'+
                      '<input type="text" placeholder="" class="w180" value="">'+
                    '</div>'+
                  '</div>'+
                '</div>'+
                '<div class="blackStyle">'+
                  '<div class="wrapStyle">'+
                    '<div class="wrapContentleft">'+'供应商简称：'+'</div>'+
                    '<div class="wrapContentright">'+
                      '<input type="text" placeholder="" class="w180" value="">'+
                    '</div>'+
                  '</div>'+
                '</div>'+
               '<div class="rowStyle fright" >'+
                 '<div class="blackStyle">'+
                    '<div class="wrapStyle"> <a href="#" class="btnstyle blueBtn blueBtn1"> <span class="color1">'+'暂存'+'</span> </a> </div>'+
                  '</div>'+
                  '<div class="blackStyle">'+
                    '<div class="wrapStyle"><a href="#" class="btnstyle orangeBtn"><img src="images/btnimg1.png"><span class="color1">'+'确认'+'</span></a></div>'+
                 '</div>'+
                '</div>'+
              '</div>');

            close();
        });
    }*/

    /*查看文本信息---加号*/
    function open() {
        $(".dropup").unbind("click").bind('click', function () {
            $(this).parent().parent().next().find(".fright").hide();
            $(this).parent().parent().next().find(".blackStyle").replaceWith('<div class="blackStyle"><div class="wrapStyle"><div class="wrapContent"><span class="contentText w297">' + '项目编号：XM201400882' + '</span></div></div></div>');
            $(this).parent().parent().next().slideToggle(500);
            $(this).parent().parent().find(".progress_operation").css('display', 'block');
            $(this).parent().parent().find(".editStyle").replaceWith('<div class="editStyle"><a  class="dropup dropdown"></a></div>');

            close();
        });

    }

    function close() {
        /*折叠文本内容*/
        $(".dropdown").unbind('click').bind('click', function () {

            $(this).parent().parent().next().hide();
            $(this).parent().parent().find(".progress_operation").css('display', 'none');
            $(this).parent().replaceWith('<div class="editStyle">' + '<a  class="editBtn"></a>' + '<a  class="dropup"></a>' + '</div>');
            //edit();
            open();
        });

    }

    open();
//edit();
    close();
    var value;//左侧节点id的数值
    var text2;//右侧折叠面板的id值

    function openleft(text2) {
        text2.find(".rowStyle").slideDown(500);
        text2.find(".rowStyle .fright").hide();
        text2.find(".progress_operation").css('display', 'block');
        text2.find(".editStyle").replaceWith('<div class="editStyle"><a href="#" class="dropup dropdown"></a></div>');
        text2.find(".blackStyle").replaceWith('<span class="messionwz1"><span class="text1">' + '项目编号' + '：</span><span class="text1">'
            + 'XM201400882' + '</span></span>');
        closeleft();

    };

    function closeleft() {
        $(".dropdown").bind('click', function () {

            $(this).parent().parent().next().hide();
            $(this).parent().parent().find(".progress_operation").css('display', 'none');
            $(this).parent().replaceWith('<div class="editStyle">' + '<a href="#" class="editBtn"></a>' + '<a href="#" class="dropup"></a>' + '</div>');

            open();
        });
    };
    /*节点跳转并展开文本内容*/
    $('.text1').bind('click', function () {
        var me = this;
        $('.text1').not($(this)).removeClass("curnode");
        $(this).addClass("curnode");
        var text1 = $(this).attr('id');
        value = parseInt(text1.replace(/[^0-9]/ig, ""));//获取id值
        text2 = $('#subnode' + value);
        openleft(text2);

    });
    /*节点树关于我的弹窗*/
    /*$('#resolvewindow1').on('mouseover','.approval-fx',function(){
      $(this).prepend('  <div class="fjWindow resolve1Window"> <span class="fjWindowStyle"> <span class="text4">承担者：hszdvb</span> <span class="text4">计划开始时间：2015-06-10</span> <span class="text4">计划截止时间：2015-10-10</span> <span class="fjWindowTriangle lxWindowTriangle"></span> </span></div></div>');
    }).on('mouseout', '.approval-fx',function(){
      $(this).find('.indexlxwbs').remove();
    });	*/
    $('#resolvewindow1').hover(function () {
        $("#resolvewindowstyle").show();
    }, function () {
        $("#resolvewindowstyle").hide();

    });

});

