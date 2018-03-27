<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
    String path = request.getContextPath();
    String basePath = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort() + path + "/";
%>
<!DOCTYPE html>
<html>
<head>
    <base href="<%=basePath%>">
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <title>临时任务附件上传</title>
    <link href="static/css/bootstrap.min.css" rel="stylesheet"/>
    <link href="static/css/bootstrap-responsive.min.css" rel="stylesheet"/>
    <link rel="stylesheet" href="static/css/ace.min.css"/>
    <link rel="stylesheet" href="static/css/ace-responsive.min.css"/>
    <link rel="stylesheet" href="static/css/ace-skins.min.css"/>
    <link rel="stylesheet" href="static/css/font-awesome.min.css"/>
    <link rel="stylesheet" href="static/assets/css/ace.css" class="ace-main-stylesheet" id="main-ace-style"/>
</head>
<body>
<form action="workOrder/saveFile.do" name="uploadForm" id="uploadForm" method="post">
    <input type="hidden" name="taskid" value="${taskid}">
    <input type="hidden" id="ids" name="ids">
    <input type="hidden" name="DOCUMENT" id="document" value="${pd.document}"/>
    <div id="zhongxin" align="center" style="padding: 5px;height: 100%;">
        <table class="table table-striped table-bordered table-hover" style="height: 100%;">
            <tr>
                <th>附件名称</th>
                <th style="text-align: center;">操作</th>
            </tr>
            <c:choose>
                <c:when test="${not empty fileList}">
                    <c:forEach items="${fileList}" var="file">
                        <tr>
                            <td><a style="cursor:pointer;"
                                   onclick="loadFile('${file.SERVER_FILENAME }')">${file.FILENAME }
                            </a></td>
                            <td style="text-align: center;"><a style="cursor:pointer;"
                                                               onclick="markFile(this,'${file.ID }')"
                                                               class="btn btn-mini btn-info" data-rel="tooltip"
                                                               data-placement="left">删除</a></td>
                        </tr>
                    </c:forEach>
                </c:when>
                <c:otherwise>
                    <tr>
                        <td colspan="2" style="text-align: center;"><span>没有附件</span></td>
                    </tr>
                </c:otherwise>
            </c:choose>

        </table>
        <div style="width: 100%;text-align: left;">
            <label>文档上传：</label>
            <input multiple type="file" id="id-input-file-1" name="id-input-file-1"/>
        </div>
        <div style="float: left;text-align: center;width: 100%;">
            <a class="btn btn-mini btn-primary" onclick="save();">确定</a>
            <a class="btn btn-mini btn-danger" onclick="top.Dialog.close();">取消</a>
        </div>

    </div>
    <div id="zhongxin2" class="center" style="display:none"><img src="static/images/jzx.gif" style="width: 50px;"/><br/>
        <h4 class="lighter block green"></h4></div>
</form>
<script type="text/javascript" src="static/js/jquery-1.7.2.js"></script>
<script src="static/js/bootstrap.min.js"></script>
<script src="static/js/ace-elements.min.js"></script>
<script src="static/js/ace.min.js"></script>
<script src="static/js/ajaxfileupload.js"></script>
<script type="text/javascript">
    $(function () {
        $("#id-input-file-1").ace_file_input({
            style: 'well',
            btn_choose: '选择',
            btn_change: '修改',
            no_icon: 'icon-cloud-upload',
            droppable: true,
            onchange: null,
            thumbnail: 'small',
            before_change: function (files, dropped) {
                return true;
            }
        })
    });

    //下载文件
    function loadFile(fileName) {
        var action = '<%=basePath%>empDailyTask/checkFile.do';
        var time = new Date().getTime();
        $.ajax({
            type: "get",
            dataType: "text",
            data: {"fileName": fileName, "time": time},
            url: action,
            success: function (data) {
                if (data == "") {
                    top.Dialog.alert("文件不存在！");
                    return;
                }
                window.location.href = '<%=basePath%>empDailyTask/loadFile.do?fileName=' + fileName + "&time=" + time;
            }
        });
    }

    //删除数据
    function markFile(obj, fileId) {
        top.Dialog.confirm("确定删除附件？", function () {
            var tr = obj.parentNode.parentNode;
            var tbody = tr.parentNode;
            tbody.removeChild(tr);
            var ids = $("#ids").val();
            if (ids == null || ids == '') {
                ids = fileId;
            } else {
                ids += "," + fileId;
            }
            $("#ids").val(ids);
        });
    }

    //提交
    function save() {
        $.ajaxFileUpload({
            url: '<%=basePath%>workOrder/Upload.do',
            secureuri: false, //是否需要安全协议，一般设置为false
            fileElementId: 'id-input-file-1', //文件上传域的ID
            dataType: 'text',
            type: 'POST',
            success: function (data) {
                $("#document").val(data);
                $("#uploadForm").submit();
                $("#zhongxin").hide();
                $("#zhongxin2").show();
            },
            error: function (data, status, e)//服务器响应失败处理函数
            {
                alert(e);
                top.Dialog.close();
            }
        });

    }
</script>
</body>
</html>