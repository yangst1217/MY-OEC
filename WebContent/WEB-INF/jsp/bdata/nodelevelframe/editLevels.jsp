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
    <link href="static/css/style.css" rel="stylesheet"/>
    <link href="static/css/bootstrap.min.css" rel="stylesheet"/>
    <link href="static/css/bootstrap-responsive.min.css" rel="stylesheet"/>
    <link rel="stylesheet" href="static/css/font-awesome.min.css"/>
    <!-- 下拉框 -->
    <link rel="stylesheet" href="static/css/chosen.css"/>

    <link rel="stylesheet" href="static/css/ace-responsive.min.css"/>
    <link rel="stylesheet" href="static/css/ace-skins.min.css"/>

    <link rel="stylesheet" href="static/css/datepicker.css"/><!-- 日期框 -->
    <script type="text/javascript" src="static/js/jquery-1.7.2.js"></script>
    <script type="text/javascript" src="static/js/jquery.tips.js"></script>

    <script type="text/javascript">


        //保存
        function save() {
            var e = document.getElementsByName("level").length;
            for (var i = 0; i < e - 1; i++) {
                var level = document.getElementsByName("level")[i].value;
                if (level.replace(/(^\s*)|(\s*$)/g, '') == "") {
                    $("input[name='level']:eq(" + i + ")").tips({
                        side: 3,
                        msg: '请输入层级',
                        bg: '#AE81FF',
                        time: 2
                    });
                    document.getElementsByName("level")[i].focus();
                    return false;
                }
            }

            $("#Form").submit();
            $("#zhongxin").hide();
            $("#zhongxin2").show();
        }

        //添加维度tr
        function addDim() {
            var shtml = document.getElementById("dimString").innerHTML;
            $("#dimtable").append(shtml);

        }

        //删除维度tr
        function delDim() {
            var checkboxs = jQuery("input[name='lids']:checked");
            if (checkboxs.length > 0) {
                if (confirm("确认删除此记录？")) {
                    checkboxs.each(function () {
                        if ($(this).val() != 0) {
                            $("#delIds").val($("#delIds").val() + $(this).val() + ",");
                        }
                        $(this).parents("tr:first").remove();
                    });
                }
                ;
            } else {
                alert("请至少选择一条记录");
            }
        }


    </script>
</head>
<body>
<form action="nodeLevelFrame/editLevels.do" name="Form" id="Form" method="post">
    <input id="delIds" type="hidden" value="" name="delIds"/>
    <input id="projectNodeLevelFrameId" type="hidden" value="${pd.ID }" name="projectNodeLevelFrameId"/>
    <div id="zhongxin">
        <br>

        <table class="table table-striped table-bordered table-hover" style=";width:100%;">
            <tbody>

            <tr>
                <td colspan="2">
                    <table class="LayoutTable" style="width:100%;">
                        <tbody>
                        <tr class="groupHeadHide">
                            <td class="interval">
                                <span><img src="static/images/ui1.png"> </span>
                                <span class="e8_grouptitle">层级配置</span>


                                <span class="toolbar">
										<input type="button" class="addbtn" onclick="addDim()" title="添加">
							    		<input type="button" class="delbtn" onclick="delDim()" title="删除">
									</span>
                            </td>
                        </tr>
                        </tbody>
                    </table>
                </td>
            </tr>
            <tr style="display:">
                <td colspan="2">
                    <table width="100%" style="margin:3px 0 5px 0" id="dimtable">
                        <tr>
                            <th width="30px"></th>
                            <th width="100px">所在层级</th>
                            <th>层级节点</th>

                        </tr>
                        <c:forEach items="${varList}" var="key">
                            <tr style="background-color: rgb(248,248,248);">
                                <td><input type="checkbox" name="lids" value="${key.ID}"/></td>
                                <td>
                                    <input type="hidden" name="dids" value="${key.ID}"/>
                                    <input type="text" name="level" id="level" value="${key.LEVEL}"
                                           onkeyup="changeNum(this)"
                                           onafterpaste="this.value=this.value.replace(/\D/g,'')"/>
                                </td>
                                <td>
                                    <select name="projectNodeLevel" style="width: 100%;">
                                        <c:forEach items="${nodeList}" var="var" varStatus="vs">
                                            <option value="${var.ID}"
                                                    <c:if test="${var.ID == key.PROJECT_NODE_LEVEL_ID}">selected="selected"</c:if>>${var.NODE_LEVEL}</option>
                                        </c:forEach>
                                    </select>
                                </td>

                            </tr>
                        </c:forEach>
                    </table>
                </td>
            </tr>


            </tbody>
        </table>
        <div style="text-align: center;">
            <a class="btn btn-mini btn-primary" onclick="save();">保存</a>
            <a class="btn btn-mini btn-danger" onclick="top.Dialog.close();">取消</a>
        </div>


    </div>

    <div id="zhongxin2" class="center" style="display:none"><br/><br/><br/><br/><br/><img
            src="static/images/jiazai.gif"/><br/><h4 class="lighter block green">提交中...</h4></div>

</form>

<table id="dimString" style="display: none;">
    <tr style="background-color: rgb(248,248,248);">
        <td><input type="checkbox" name="lids" value="0"/></td>
        <td>
            <input type="hidden" name="dids" value="0"/>
            <input type="text" name="level" id="level" onkeyup="changeNum(this)"
                   onafterpaste="this.value=this.value.replace(/\D/g,'')"/>
        </td>
        <td>
            <select name="projectNodeLevel" style="width: 100%;">
                <c:forEach items="${nodeList}" var="var" varStatus="vs">
                    <option value="${var.ID}">${var.NODE_LEVEL}</option>
                </c:forEach>
            </select>
        </td>
    </tr>
</table>

<!-- 引入 -->
<script type="text/javascript">window.jQuery || document.write("<script src='static/js/jquery-1.9.1.min.js'>\x3C/script>");</script>
<script src="static/js/bootstrap.min.js"></script>
<script src="static/js/ace-elements.min.js"></script>
<script src="static/js/ace.min.js"></script>
<script type="text/javascript" src="static/js/chosen.jquery.min.js"></script><!-- 下拉框 -->
<script type="text/javascript" src="static/js/bootstrap-datepicker.min.js"></script><!-- 日期框 -->
<script type="text/javascript">
    $(top.changeui());
    $(function () {

        //单选框
        $(".chzn-select").chosen();
        $(".chzn-select-deselect").chosen({allow_single_deselect: true});

        //日期框
        $('.date-picker').datepicker();

    });

    function changeNum(objTxt) {
        objTxt.value = objTxt.value.replace(/\D/g, '');
    }

</script>
<script type="text/javascript">

    function checkName(obj) {//姓名是否包含特殊符号
        var value = $(obj).val();
        var p = new Array("﹉", " ", "＃", "＠", "＆", "＊", "※", "§", "〃", "№", "〓", "○",
            "●", "△", "▲", "◎", "☆", "★", "◇", "◆", "■", "□", "▼", "▽",
            "㊣", "℅", "ˉ", "￣", "＿", "﹍", "﹊", "﹎", "﹋", "﹌", "﹟", "﹠",
            "﹡", "♀", "♂", "?", "⊙", "↑", "↓", "←", "→", "↖", "↗", "↙",
            "↘", "┄", "—", "︴", "﹏", "（", "）", "︵", "︶", "｛", "｝", "︷",
            "︸", "〔", "〕", "︹", "︺", "【", "】", "︻", "︼", "《", "》", "︽",
            "︾", "〈", "〉", "︿", "﹀", "「", "」", "﹁", "﹂", "『", "』", "﹃",
            "﹄", "﹙", "﹚", "﹛", "﹜", "﹝", "﹞", "\"", "〝", "〞", "ˋ",
            "ˊ", "≈", "≡", "≠", "＝", "≤", "≥", "＜", "＞", "≮", "≯", "∷",
            "±", "＋", "－", "×", "÷", "／", "∫", "∮", "∝", "∧", "∨", "∞",
            "∑", "∏", "∪", "∩", "∈", "∵", "∴", "⊥", "∥", "∠", "⌒", "⊙",
            "≌", "∽", "√", "≦", "≧", "≒", "≡", "﹢", "﹣", "﹤", "﹥", "﹦",
            "～", "∟", "⊿", "∥", "㏒", "㏑", "∣", "｜", "︱", "︳", "|", "／",
            "＼", "∕", "﹨", "¥", "€", "￥", "£", "®", "™", "©", "，", "、",
            "。", "．", "；", "？", "！", "︰", "…", "‥", "′", "‵", "々",
            "～", "‖", "ˇ", "ˉ", "﹐", "﹑", "﹒", "﹔", "：", "﹖", "﹗",
            "&", "*", "#", "`", "~", "+", "=", "(", ")", "^", "%",
            "$", "@", ";", ",", "'", "\\", "/", ">", "<",
            "?", "!", "[", "]", "{", "}", "“", "”", "\"");
        for (var j = 0; j < p.length; j++) {
            if (value.indexOf(p[j]) != -1) {
                alert("模板名称中包含非法字符！");
                obj.focus();
                return false;
            }
        }
        return true;
    }

</script>
</body>
</html>