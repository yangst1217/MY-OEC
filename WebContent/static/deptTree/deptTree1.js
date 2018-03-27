/**
 * 基于zTree v2.6进行封装
 * 使用前请确认页面引入jquery 1.4以上版本和zTree v2.6相关样式文件和脚本文件
 * 当前只适配下拉框内嵌树，仅支持简单JSON数据
 *
 * setting为zTree全局设置，具体配置请参考zTree v2.6 API文档
 * depts为需要转换为树形结构的JSON数据
 * height/width 树面板的高度/宽度
 * @author liweitao
 */
var deptTree;
var deptTreeInner;
//objId和treeId均为树元件ID，为兼容其他人用法，保留
var objId;
var treeId;

$.fn.deptTree = function (setting, depts, height, width) {
    height = height == null ? 500 : height;
    width = width == null ? 236 : width;
    treeId = setting.treeId ? setting.treeId : "deptTree";

    $("#" + treeId).parent().css({
        display: "none",
        position: "absolute",
        overflow: "auto",
        height: height,
        width: width,
        //border: "1px solid #CCCCCC"
    });

    $("#" + treeId).css({
        height: "100%",
        overflow: "auto",
        padding: 0,
        margin: 0
    });

    setting.isSimpleData = true;
    setting.treeNodeKey = "ID";
    setting.treeNodeParentKey = "PARENT_ID";
    setting.nameCol = "DEPT_NAME";


    deptTree = $("#" + treeId).zTree(setting, depts);
    return deptTree;
}


/**
 * 显示树形面板，根据触发控件位置确定面板位置
 * @param objId 点击时显示树形控件的元件ID
 */
function showDeptTree(obj) {
    objId = obj.id;
    deptTreeInner = $("#" + objId);
    var objOffset = deptTreeInner.offset();
    $("#" + treeId).parent().css({
        left: objOffset.left + "px",
        top: objOffset.top + 38 + "px"
    }).slideDown("fast");
};

function hideDeptTree() {
    $("#" + treeId).parent().fadeOut("fast");
};


/**
 * 显示树形面板，根据触发控件位置确定面板位置
 * @param objId 点击时显示树形控件的元件ID
 * 同一页面多个地方需要显示树的时候，需增加treeIdNew确定显示哪个树
 */

/*function showDeptTreeMulti(obj,treeIdNew) {
	treeId = treeIdNew;
	objId = obj.id;
	deptTreeInner = $("#" + objId);
	var objOffset = deptTreeInner.offset();
	$("#"+treeId).parent().css({
		left : objOffset.left + "px", 
		top : objOffset.top + deptTreeInner.outerHeight() + "px"
	}).slideDown("fast");
};*/

/**
 * 树节点多选时确认方法
 */
function deptTreeSelectEnd() {
    var nodes = deptTree.getCheckedNodes();
    var values = "";
    var texts = "";
    for (var i = 0; i < nodes.length; i++) {
        values += nodes[i].ID + ",";
        texts += nodes[i].DEPT_NAME + ",";
    }
    values = values.substring(0, values.length - 1);
    texts = texts.substring(0, texts.length - 1);

    deptTreeInner.val(texts);
    if (deptTreeInner.next()) {
        deptTreeInner.next().val(values);
    }
    hideDeptTree();
}

/**
 * 树节点单选时点击方法
 */
function deptNodeClick() {
    var dept = deptTree.getSelectedNode();
    deptTreeInner.val(dept.DEPT_NAME);
    if (deptTreeInner.next()) {
        deptTreeInner.next().val(dept.ID);
    }
    hideDeptTree();
}

/**
 * 重置树节点状态，全部设置为未选择
 */
function resetDeptTree() {
    deptTree.checkAllNodes(false);
}