<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<div class="web_footer">
    <c:choose>
        <c:when test="${fn:length(appmenuList)>5 }">
            <table>
                <tr>
                    <c:forEach items="${appmenuList}" var="item" varStatus="vs">
                        <c:choose>
                            <c:when test="${vs.index<4 }">
                                <td style="width:20%; border-right:1px dashed gray">
                                    <a href="${item.MENU_URL }" style="line-height: 1; ">
                                        <img src="static/img/${item.MENU_CODE }.png"
                                             width="25px"/><br/>${item.MENU_NAME }
                                    </a>
                                </td>
                            </c:when>
                        </c:choose>
                    </c:forEach>
                    <td style="width:20%;">
                        <a onclick="showMenu();" style="line-height: 1; ">
                            <img src="static/img/app_list.png" width="25px"/><br/>更多操作
                        </a>
                    </td>
                </tr>
            </table>
            <div id="menuDiv" class="hide"
                 style="width:18%; text-align:center; position: absolute; bottom:50px; right:0; background: #fff;">
                <c:forEach items="${appmenuList}" var="item" varStatus="vs">
                    <c:if test="${vs.index>=4}">
                        <div style="padding-top:5px; padding-bottom:5px; <c:if
                                test='${vs.index< fn:length(appmenuList)-1 }'>border-bottom:1px dashed gray;</c:if>">
                            <a href="${item.MENU_URL }">
                                <img src="static/img/${item.MENU_CODE }.png" width="25px"/><br/>${item.MENU_NAME }
                            </a>
                        </div>
                    </c:if>
                </c:forEach>
            </div>
        </c:when>
        <c:otherwise>
            <table>
                <tr>
                    <c:forEach items="${appmenuList}" var="item" varStatus="vs">
                        <td style="width:20%; border-right:1px dashed gray">
                            <a href="${item.MENU_URL }" style="line-height: 1; ">
                                <img src="static/img/${item.MENU_CODE }.png" width="25px"/><br/>${item.MENU_NAME }
                            </a>
                        </td>
                    </c:forEach>
                </tr>
            </table>
        </c:otherwise>
    </c:choose>
</div>
<script>
    function showMenu() {
        if ($("#menuDiv").hasClass("hide")) {
            $("#menuDiv").removeClass("hide");
        } else {
            $("#menuDiv").addClass("hide");
        }
    }
</script>