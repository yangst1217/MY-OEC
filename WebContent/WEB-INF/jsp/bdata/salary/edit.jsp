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
<html lang="en">
<head>
    <base href="<%=basePath%>">
    <title>编辑</title>
    <%@ include file="../../system/admin/top.jsp" %>

    <script type="text/javascript" src="plugins/JQuery/jquery.min.js"></script>


    <style>
        #editAll table tr {
            height: 40px;
        }
    </style>
</head>

<body>
<div style="margin-left: 10px;">
    <form action="salary/edit.do" id="targetForm" name="targetForm"
          accept-charset="UTF-8">
        <input type="hidden" id="ID" name="ID" value="${pd.ID }"> <input
            type="hidden" id="sum" name="sum"> <input type="hidden"
                                                      id="info" name="info">
        <div id="editAll">
            <h5 style="font-style: italic;font-weight: bold;">基本信息</h5>
            <hr>
            <table>
                <tr>
                    <td>员工编号:</td>
                    <td><input style="border-style: none;width: 150px;"
                               readonly="readonly" type="text" value="${pd.EMP_CODE}"/></td>
                    <td>员工姓名:</td>
                    <td><input style="border-style: none;width: 150px;"
                               readonly="readonly" type="text" value="${pd.EMP_NAME}"/></td>
                    <td>性别:</td>
                    <td><input style="border-style: none;width: 150px;"
                               readonly="readonly" type="text" value="${pd.EMP_GENDER}"/></td>
                </tr>
                <tr>
                    <td>所属部门:</td>
                    <td><input style="border-style: none;width: 150px;"
                               readonly="readonly" type="text" value="${pd.DEPT_NAME}"/></td>
                    <td>岗位类别:</td>
                    <td><input style="border-style: none;width: 150px;"
                               readonly="readonly" type="text" value="${pd.POS_NAME}"/></td>
                    <td>年月:</td>
                    <td><input style="border-style: none;width: 150px;"
                               readonly="readonly" type="text" value="${pd.YM}"/></td>
                </tr>
                <tr>
                    <td>&nbsp;&nbsp;备注:</td>
                    <td colspan="5"><textarea style="width: 98%;" id="remarks"
                                              name="remarks">${pd.REMARKS}</textarea></td>
                </tr>
            </table>
        </div>
        <div id="eidtInfo">
            <h5 style="font-style: italic;font-weight: bold;">工资明细</h5>
            <hr>
            <table id="infoTb">
                <tr>
                    <c:forEach items="${itemList }" var="item">
                        <c:if test="${item.BS_TYPE !='2' }">
                            <td><input type="text" readonly="readonly"
                                       value="${item.BS_NAME }"></td>
                        </c:if>
                        <c:if test="${item.BS_TYPE =='2' }">
                            <td><input type="hidden" value="${item.BS_NAME }">
                            </td>
                        </c:if>
                    </c:forEach>
                </tr>
                <tr>
                    <c:forEach items="${itemList }" var="item">
                    <c:if test="${item.BS_TYPE !='2' && item.BS_NAME != '考核系数' }">
                        <td><input type="text" id="${item.BS_ID }"
                                   name="${item.BS_NAME }" value="${item.BS_AMOUNT }"
                                   class="${item.BS_TYPE }"
                                   maxlength="9"
                                   onkeyup="this.value=(this.value.match(/\d+(\.\d{0,2})?/)||[''])[0]"
                        ></td>
                    </c:if>
                    <c:if test="${item.BS_TYPE !='2' && item.BS_NAME == '考核系数' }">
                        <td><input id="${item.BS_ID }" name="${item.BS_NAME }" value="${item.BS_AMOUNT }"
                                   class="${item.BS_TYPE }" readonly="readonly"></td>
                    </c:if>
                    <c:if test="${item.BS_TYPE =='2' }">
                    <td><input type="hidden" id="${item.BS_ID }"
                               class="${item.BS_TYPE }" name="${item.BS_NAME }"
                               value="${item.BS_AMOUNT }">
                        </c:if>
                        </c:forEach>
                </tr>
            </table>
        </div>
        <br> <br>
        <div style="text-align: center;">
            <a class="btn btn-mini btn-primary" onclick="save();">保存</a>&nbsp; <a
                class="btn btn-mini btn-danger" onclick="top.Dialog.close();">取消</a>
        </div>
    </form>
</div>
<script type="text/javascript" src="static/js/jquery.tips.js"></script>
<!--提示框-->
<script type="text/javascript">
    //保存修改方法
    function save() {
        var str = "";
        var info = "";
        var rows = $("#infoTb").find("tr");
        var tdArr = rows.eq(1).find("td");
        for (var i = 0; i < tdArr.length; i++) {
            var data = tdArr.eq(i).find("input").val();
            var name = tdArr.eq(i).find("input").attr("name");
            var id = tdArr.eq(i).find("input").attr("id");
            var type = tdArr.eq(i).find("input").attr("class");
            if (type == '1') {
                if (data == null || data == '') {

                    $("#" + id).tips({
                        side: 3,
                        msg: "请填写" + name + "!",
                        bg: "#AE81FF",
                        time: 2
                    });
                    $("#" + id).focus();
                    return false;
                }
                ;
                if (data > 99999.99) {
                    $("#" + id).tips({
                        side: 3,
                        msg: "金额不能大于99999.99!",
                        bg: "#AE81FF",
                        time: 2
                    });
                    $("#" + id).focus();
                    return false;
                }
                ;

            }

            if (type == '1') {
                str += data;
                info += id + "@" + data + ",";
            } else {
                str += rows.eq(0).find("td").eq(i).find("input").val();
            }

        }
        var sum = eval(str);
        var remarks = $("#remarks").val();
        info = info.substring(0, info.length - 1);
        $("#sum").val(sum);
        $("#info").val(info);
        $("#targetForm").submit();
    }
</script>
</body>
</html>

