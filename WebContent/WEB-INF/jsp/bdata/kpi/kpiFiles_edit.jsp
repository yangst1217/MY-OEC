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
    <!-- ace styles -->
    <link rel="stylesheet" href="static/assets/css/ace.css" class="ace-main-stylesheet" id="main-ace-style"/>

    <link rel="stylesheet" href="static/assets/css/font-awesome.css"/>
    <script src="static/js/ajaxfileupload.js"></script>

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

        #zx td label {
            text-align: right;
            margin-right: 10px;
        }

        #zhongxin table input, textarea {
            width: 400px;
        }

        .ace-file-multiple {
            width: 420px;
        }
    </style>
    <script type="text/javascript">

    </script>
</head>
<body>
<fmt:requestEncoding value="UTF-8"/>
<form action="kpiFiles/${msg}.do" name="kpiFilesForm" id="kpiFilesForm" method="post">
    <input type="hidden" name="flag" id="flag" value="${msg}"/>
    <input type="hidden" name="ID" id="id" value="${pd.ID }"/>
    <input type="hidden" name="PARENT_ID" id="parent_id" value="${pd.PARENT_ID }"/>
    <input type="hidden" name="DOCUMENT" id="document"/>
    <input type="hidden" name="DOCUMENT_PATH" id="document_path"/>
    <input type="hidden" name="DOCUMENT_ID" id="DOCUMENT_ID" value="${pd.DOCUMENT_ID }"/>
    <c:if test="${msg == 'edit'}">
        <input type="hidden" name="KPI_CODE" id="kpi_code" value="${pd.KPI_CODE }"/>
    </c:if>
    <div id="zhongxin">
        <table style="margin: 0 auto; width: 98%; "><br>
            <tr>
                <td style="width:130px"><label><span style="color: red">*</span>KPI编码：</label></td>
                <td>
                    <c:if test="${msg == 'save'}">
                        <input type="text" name="KPI_CODE" id="kpi_code" value="${pd.KPI_CODE }"
                               maxlength="32" placeholder="请输入KPI编码"/>
                    </c:if>
                    <c:if test="${msg == 'edit'}">
                        <input type="text" value="${pd.KPI_CODE }" maxlength="32" readonly="readonly"/>
                    </c:if>
                </td>
                <td>
                </td>
            </tr>
            <tr>
                <td><label><span style="color: red">*</span>KPI名称：</label></td>
                <td>
                    <input type="text" name="KPI_NAME" id="kpi_name" value="${pd.KPI_NAME }"
                           maxlength="32"/>
                </td>
            </tr>
            <tr>
                <td><label><span style="color: red">*</span>KPI类型：</label></td>
                <td>
                    <input type="text" name="KPI_CATEGORY_NAME" id="kpi_category_name" value="${category.NAME}"
                           maxlength="32" readonly/>
                    <input type="hidden" name="KPI_CATEGORY_ID" id="kpi_category_id" value="${category.ID}"
                           maxlength="32"/>
                </td>
            </tr>
            <tr>
                <td><label>指标描述：</label></td>
                <td>
                    <input type="text" name="KPI_DESCRIPTION" id="kpi_description" value="${pd.KPI_DESCRIPTION}"
                           maxlength="32"/>
                </td>
            </tr>
            <tr>
                <td><label>KPI单位：</label></td>
                <td>
                    <input type="text" name="KPI_UNIT" id="kpi_unit" value="${pd.KPI_UNIT}"
                           maxlength="32"/>
                </td>
            </tr>
            <tr>
                <td><label>KPI计算逻辑：</label></td>
                <td>
                    <textarea type="text" name="KPI_SQL" id="kpi_sql"
                              style="height: 120px;width: 400px;">${pd.KPI_SQL }</textarea>
                </td>
            </tr>
            <tr>
                <td><label><span style="color: red">*</span>是否启用：</label></td>
                <td>
                    <input type="radio" name="ENABLED" value="1" style="width:18px"
                           <c:if test="${pd.ENABLED == 1}">checked="checked"</c:if>>是
                    <input type="radio" name="ENABLED" value="0" style="width:18px"
                           <c:if test="${pd.ENABLED == 0}">checked="checked"</c:if>>否
                </td>
            </tr>

            <%-- <tr>
                <td style="text-align: center;" colspan="2">
                    <input type="text" name="PARENT_ID" id="parent_id" value="${pd.PARENT_ID }"
                    maxlength="32" placeholder="这里输入上一级ID" title="上一级ID"/>
                </td>
            </tr> --%>

    </div>
    <!-- <div colspan="2" style="text-align: center;">
        <a class="btn btn-mini btn-primary" onclick="save();">保存</a>&nbsp;
        <a class="btn btn-mini btn-danger" onclick="top.Dialog.close();">取消</a>
    </div> -->

</form>

<tr id="zx">
    <td><label>指标文档上传：</label></td>
    <td><input multiple type="file" id="id-input-file-1" name="id-input-file-1"/></td>
</tr>
<tr>
    <td colspan="2" style="text-align: center;">
        <a class="btn btn-mini btn-primary" onclick="save();">保存</a>&nbsp;
        <a class="btn btn-mini btn-danger" onclick="top.Dialog.close();">取消</a>
    </td>
</tr>

</table>
</form>
<!-- 引入 -->
<script type="text/javascript">window.jQuery || document.write("<script src='static/js/jquery-1.9.1.min.js'>\x3C/script>");</script>
<script src="static/js/bootstrap.min.js"></script>
<script src="static/js/ace-elements.min.js"></script>
<script src="static/js/ace.min.js"></script>
<script type="text/javascript" src="static/js/chosen.jquery.min.js"></script><!-- 下拉框 -->

<script type="text/javascript">
    $(top.changeui());

    //保存
    function save() {
        /* if($("#parent_id").val() == ""){
            alert("请先在左侧树状菜单中点击选择您希望添加的位置！");
            top.Dialog.close();
            return false;
        } */
        var codeCheck = /\s/;
        var sql = $("#kpi_sql").val();
        if ($("#kpi_code").val() == "" || codeCheck.test($("#kpi_code").val())) {
            $("#kpi_code").tips({
                side: 3,
                msg: '请正确输入KPI编码',
                bg: '#AE81FF',
                time: 2
            });
            $("#kpi_code").focus();
            return false;
        }
        if ($("#kpi_name").val() == "") {
            $("#kpi_name").tips({
                side: 3,
                msg: '请输入KPI名称',
                bg: '#AE81FF',
                time: 2
            });
            $("#kpi_name").focus();
            return false;
        }
        if (typeof($("input:radio[name='ENABLED']:checked").val()) == "undefined") {
            alert("请选择是否启用！");
            return false;
        }

        if ((sql.indexOf("select") == 0 || sql.indexOf("SELECT") == 0 || sql.indexOf("Select") == 0 || sql == '') && sql.indexOf(";") < 0) {
            var url = "<%=basePath%>/kpiFiles/checkKpiFiles.do?kpiCode=" + $("#kpi_code").val() + "&msg=" + $("#flag").val() + "&id=" + $("#id").val();
            $.get(url, function (data) {
                if (data == "true") {
                    //var val = $("#kpi_category_id").find("option:selected").text();
                    //$("#kpi_category_name").val(val);


                    $.ajaxFileUpload({
                        url: '<%=basePath%>kpiFiles/Upload.do',
                        secureuri: false, //是否需要安全协议，一般设置为false
                        fileElementId: 'id-input-file-1', //文件上传域的ID
                        dataType: 'text',
                        type: 'POST',
                        success: function (data) {

                            //var obj = eval('(' + data + ')');

                            /* 							$.each(obj, function(i, item) {

                                                            //$("#groupsForSelect").append(option);
                                                        }); */

                            $("#document").val(data);
                            //alert($("#document").val());
                            //alert(data.msg);
                            $("#kpiFilesForm").submit();
                            $("#zhongxin").hide();
                        },
                        error: function (data, status, e)//服务器响应失败处理函数
                        {
                            alert(e);
                            top.Dialog.close();
                        }
                    });
                } else {
                    alert("该KPI编号已存在！");
                    top.Dialog.close();
                }
            }, "text");
        }
        else {
            alert("请输入正确语句，同时不要以分号结尾");
            return false;
        }
    }


    function addUpLoad() {
        $("#amount").val(parseInt($("#amount").val()) + 1);
        var html = "";
        html += "<tr>";
        html += "<td><input type='file' id='id-input-file-" + $("#amount").val() + "' name='id-input-file-" + $("#amount").val() + "' style='width: 200px'/></td>";
        //html+="<td><input type='file' id='id-input-file-1' name='id-input-file-1' style='width: 200px'/></td>";
        html += "</tr>";

        $("#upload").append(html);
        //$("input#id-input-file-1").ace_file_input({
        $("input#id-input-file-" + $("#amount").val() + "").ace_file_input({
            no_file: 'No File ...',
            btn_choose: '选择',
            btn_change: '修改',
            droppable: false,
            onchange: null,
            thumbnail: false //| true | large
            //whitelist:'gif|png|jpg|jpeg'
            //blacklist:'exe|php'
            //onchange:''
            //
        });
    }


    $(function () {
        //$("input#id-input-file-1").ace_file_input({
        //no_file:'No File ...',
        //btn_choose:'选择',
        //btn_change:'修改',
        //droppable:false,
        //onchange:null,
        //thumbnail:false //| true | large
        //whitelist:'gif|png|jpg|jpeg'
        //blacklist:'exe|php'
        //onchange:''
        //
        //});
        $("#id-input-file-1").ace_file_input({
            style: 'well',
            btn_choose: '选择',
            btn_change: '修改',
            no_icon: 'icon-cloud-upload',
            droppable: true,
            onchange: null,
            thumbnail: 'small',
            before_change: function (files, dropped) {
                /**
                 if(files instanceof Array || (!!window.FileList && files instanceof FileList)) {
						//check each file and see if it is valid, if not return false or make a new array, add the valid files to it and return the array
						//note: if files have not been dropped, this does not change the internal value of the file input element, as it is set by the browser, and further file uploading and handling should be done via ajax, etc, otherwise all selected files will be sent to server
						//example:
						var result = []
						for(var i = 0; i < files.length; i++) {
							var file = files[i];
							if((/^image\//i).test(file.type) && file.size < 102400)
								result.push(file);
						}
						return result;
					}
                 */
                return true;
            }
            /*,
            before_remove : function() {
                return true;
            }*/
        }).on('change', function () {
            //console.log($(this).data('ace_input_files'));
            //console.log($(this).data('ace_input_method'));
        });

    });
</script>

</body>
</html>