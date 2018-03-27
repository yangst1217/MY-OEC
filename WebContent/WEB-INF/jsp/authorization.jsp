<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%
    String path = request.getContextPath();
    String basePath = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort() + path + "/";
%>
<!DOCTYPE html>
<html lang="en" style="height: 100%;">
<head>
    <base href="<%=basePath%>">
    <title></title>
    <meta charset="utf-8"/>
    <link href="static/css/bootstrap.min.css" rel="stylesheet"/>
    <link rel="stylesheet" href="static/css/font-awesome.min.css"/>

    <link type="text/css" rel="stylesheet" href="plugins/zTree/zTreeStyle.css"/>
    <link rel="stylesheet" href="static/css/ace.min.css"/>
    <link rel="stylesheet" href="static/css/ace-responsive.min.css"/>
    <link rel="stylesheet" href="static/css/ace-skins.min.css"/>
    <style type="text/css">
        footer {
            height: 50px;
            position: fixed;
            bottom: 0px;
            left: 0px;
            width: 100%;
            text-align: center;
        }
    </style>
</head>
<body style="height: 100%">
<input type="hidden" id="menuId" name="menuId">
<input type="hidden" id="menuCode" name="menuCode">
<div id="zhongxin" style="height: 85%;float: left;width: 50%;overflow: auto;">
    <ul id="tree" class="tree" style="overflow:auto;"></ul>
</div>
<div id="btnTreeDIV" style="height: 85%;float: left;width: 50%">
    <ul id="tree2" class="tree" style="overflow:auto;"></ul>
</div>
<div id="btnDIV" style="width: 100%;height: 10%;float: left;padding-top: 15px;" class="center">
    <a class="btn btn-mini btn-primary" onclick="save();">保存</a>
    <a class="btn btn-mini btn-danger" onclick="top.Dialog.close();">取消</a>
</div>
<div id="zhongxin2" class="center" style="display:none"><br/><br/><br/><br/>
    <img src="static/images/jiazai.gif"/><br/><h4 class="lighter block green"></h4>
</div>
<script type="text/javascript" src="static/js/jquery-1.5.1.min.js"></script>
<script type="text/javascript" src="plugins/zTree/jquery.ztree-2.6.min.js"></script>
<script type="text/javascript">
    $(top.changeui());
    var zTree;
    var btnTree;
    $(document).ready(function () {
        var setting = {
            showLine: true,
            checkable: true,
            callback: {
                click: zTreeOnClick,
                beforeClick: befortMenuClick
            }
        };
        var zn = '${zTreeNodes}';
        var zTreeNodes = eval(zn);
        zTree = $("#tree").zTree(setting, zTreeNodes);

        var setting2 = {
            showLine: true,
            checkable: true,
            showIcon: true,
            async: {
                enable: true,
                type: "post",
                contentType: "application/json",
                url: "selectChildMenu.action",
                autoParam: ["id"],
                dataType: "json"
            }
        };
        zTreeNodes2 = eval('${zBtnTreeNodes}');
        btnTree = $("#tree2").zTree(setting2, zTreeNodes2);
    });

    function befortMenuClick(event, treeId, treeNode) {
        var menuid = $("#menuId").val();
        var menucode = $("#menuCode").val();
        var menuNode = zTree.getSelectedNode();
        var btnChanged = btnTree.getChangeCheckedNodes();

        //当前菜单节点为勾选状态且按钮权限发生变化时保存按钮权限
        if (btnChanged.length > 0 && menuNode != null && menuNode.checked) {
            var nodes = btnTree.getCheckedNodes();
            var tmpNode;
            var ids = "";
            var events = "";
            for (var i = 0; i < nodes.length; i++) {
                tmpNode = nodes[i];
                if (i != nodes.length - 1) {
                    ids += tmpNode.id + ",";
                    events += tmpNode.BUTTONS_EVENT + ",";
                } else {
                    ids += tmpNode.id;
                    events += tmpNode.BUTTONS_EVENT;
                }
            }
            var roleId = "${roleId}";
            var url = "<%=basePath%>/role/roleButton/save.do";
            var postData;
            postData = {
                "ROLE_ID": roleId,
                "buttonIds": ids,
                "MENU_ID": menuid,
                "events": events,
                "MENU_CODE": menucode
            };

            $("#zhongxin").hide();
            $("#zhongxin2").show();
            $("#btnTreeDIV").hide();
            $("#btnDIV").hide();
            $.post(url, postData, function (data) {
                if (data != "success") {
                    alert("按钮权限保存失败！");
                } else {
                    $("#zhongxin").show();
                    $("#zhongxin2").hide();
                    $("#btnTreeDIV").show();
                    $("#btnDIV").show();
                }
            });
        }
    }

    function zTreeOnClick(event, treeId, treeNode) {
        var nodes = btnTree.getNodes();
        for (var i = nodes.length - 1; i >= 0; i--) {
            btnTree.removeNode(nodes[i]);
        }
        var menuid = treeNode.id;
        $("#menuId").val(menuid);
        var menucode = treeNode.MENU_CODE;
        $("#menuCode").val(menucode);

        var roleId = "${roleId}";
        var url = "<%=basePath%>/role/getBtnRole.do?ROLE_ID=" + roleId + "&MENU_ID=" + menuid;
        $.ajax({
            type: "POST",
            async: false,
            url: url,
            success: function (data) {     //回调函数，result，返回值
                zTreeNodes2 = eval('(' + data + ')');
                btnTree.addNodes(null, zTreeNodes2);
            }
        });
    }

    function save() {
        var nodes = zTree.getCheckedNodes();
        var tmpNode;
        var ids = "";
        for (var i = 0; i < nodes.length; i++) {
            tmpNode = nodes[i];
            if (i != nodes.length - 1) {
                ids += tmpNode.id + ",";
            } else {
                ids += tmpNode.id;
            }
        }

        var roleId = "${roleId}";
        var url = "role/auth/save.do";
        var postData = {"ROLE_ID": roleId, "menuIds": ids};

        befortMenuClick();

        $("#zhongxin").hide();
        $("#zhongxin2").show();
        $("#btnTreeDIV").hide();
        $("#btnDIV").hide();
        $.post(url, postData, function (data) {
            top.Dialog.close();
        });
    }
</script>
</body>
</html>