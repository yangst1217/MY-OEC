<%
    String pathl = request.getContextPath();
    String basePathl = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort() + pathl + "/";
%>
<style>
    .nav-list > li.active .submenu {
        display: block
    }

    .nav-list > li .submenu {
        display: none;
        list-style: none;
        margin: 0;
        padding: 0;
        position: relative;
        background-color: #fff;
        border-top: 1px solid #e5e5e5
    }

    .nav-list > li .submenu > li {
        margin-left: 0;
        position: relative
    }

    .nav-list > li .submenu > li > a {
        display: block;
        position: relative;
        color: #616161;
        padding: 7px 0 9px 37px;
        margin: 0;
        border-top: 1px dotted #e4e4e4
    }

    .nav-list > li .submenu > li > a:focus {
        text-decoration: none
    }

    .nav-list > li .submenu > li > a:hover {
        text-decoration: none;
        color: #4b88b7
    }

    .nav-list > li .submenu > li.active > a {
        color: #2b7dbc
    }

    .nav-list > li .submenu > li a > [class*="icon-"]:first-child {
        display: none;
        font-size: 12px;
        font-weight: normal;
        width: 18px;
        height: auto;
        line-height: 12px;
        text-align: center;
        position: absolute;
        left: 10px;
        top: 11px;
        z-index: 1;
        background-color: #FFF
    }

    .nav-list > li .submenu > li.active > a > [class*="icon-"]:first-child, .nav-list > li .submenu > li:hover > a > [class*="icon-"]:first-child {
        display: inline-block
    }

    .nav-list > li .submenu > li.active > a > [class*="icon-"]:first-child {
        color: #c86139
    }

    .nav-list > li > .submenu > li:before {
        content: "";
        display: inline-block;
        position: absolute;
        width: 7px;
        left: 20px;
        top: 17px;
        border-top: 1px dotted #9dbdd6
    }

    .nav-list > li > .submenu > li:first-child > a {
        border-top: 1px solid #fafafa
    }

    .nav-list > li > .submenu:before {
        content: "";
        display: block;
        position: absolute;
        z-index: 1;
        left: 18px;
        top: 0;
        bottom: 0;
        border: 1px dotted #9dbdd6;
        border-width: 0 0 0 1px
    }

    .nav-list > li.active > .submenu > li:before {
        border-top-color: #8eb3d0
    }

    .nav-list > li.active > .submenu:before {
        border-left-color: #8eb3d0
    }

    .nav-list li .submenu {
        overflow: hidden
    }

    .nav-list li.active > a:after {
        display: block;
        content: "";
        position: absolute !important;
        right: 0;
        top: 4px;
        border: 8px solid transparent;
        border-width: 14px 10px;
        border-right-color: #2b7dbc
    }

    .nav-list li.open > a:after {
        display: none
    }

    .nav-list li.active.open > .submenu > li.active.open > a.dropdown-toggle:after {
        display: none
    }

    .nav-list li.active > .submenu > li.active > a:after {
        display: none
    }

    .nav-list li.active.open > .submenu > li.active > a:after {
        display: block
    }

    .select2-container .select2-choice .select2-arrow b {
        background: 0
    }

    .select2-container .select2-choice .select2-arrow b:before {
        font-family: FontAwesome;
        font-size: 12px;
        display: inline;
        content: "\f0d7";
        color: #888;
        position: relative;
        left: 5px
    }

    .select2-dropdown-open .select2-choice .select2-arrow b:before {
        content: "\f0d8"
    }

    .nav-list > li a > .arrow {
        display: inline-block;
        width: 14px !important;
        height: 14px;
        line-height: 14px;
        text-shadow: none;
        font-size: 18px;
        position: absolute;
        right: 11px;
        top: 11px;
        padding: 0;
        color: #666
    }

    .nav-list > li a:hover > .arrow, .nav-list > li.active > a > .arrow, .nav-list > li.open > a > .arrow {
        color: #1963aa
    }

    .nav-list > li > .submenu a > .arrow {
        right: 11px;
        top: 10px;
        font-size: 16px;
        color: #6b828e
    }

    .nav-list > li > .submenu .open > a, .nav-list > li > .submenu .open > a:hover, .nav-list > li > .submenu .open > a:focus {
        background-color: transparent;
        border-color: #e4e4e4
    }

    .nav-list > li > .submenu li > .submenu > li > a > .arrow {
        right: 12px;
        top: 9px
    }

    .nav-list > li > .submenu li.open > a .arrow {
        color: #25639e
    }

    .nav-list > li > .submenu li > .submenu li.open > a {
        color: #25639e
    }

    .nav-list > li > .submenu li > .submenu li.open > a > [class*="icon-"]:first-child {
        display: inline-block;
        color: #1963aa
    }

    .nav-list > li > .submenu li > .submenu li.open > a .arrow {
        color: #25639e
    }

    .menu-min .nav-list > li > a .arrow {
        display: none
    }

    .nav-list > li > .submenu li > .submenu > li > a {
        margin-left: 20px;
        padding-left: 30px
    }

    #sidebar {
        /* position:fixed; */
        top: 0;
        left: 0;
        height: 100%;
        overflow: hidden;
        outline: none;
        background: #f2f2f2;
    }

</style>

<!-- 本页面涉及的js函数，都在head.jsp页面中 -->
<div id="sidebar" class="">

    <div id="sidebar-shortcuts">

        <%-- <div id="sidebar-shortcuts-large">

            <button class="btn btn-small btn-success" onclick="changeMenu();" title="切换菜单" ><i class="icon-pencil"></i></button><!-- style="padding:0 15px;"-->

             <button class="btn btn-small btn-info" title="" onclick="window.open('<%=basePathl%>static/UI_new');"><i class="icon-eye-open"></i></button>

            <button class="btn btn-small btn-warning" title="数据字典" id="adminzidian" onclick="zidian();" ><i class="icon-book"></i></button>

            <button class="btn btn-small btn-danger" title="菜单管理" id="adminmenu" onclick="menu();" ><i class="icon-folder-open"></i></button>

        </div> --%>

        <!-- <div id="sidebar-shortcuts-mini">
            <span class="btn btn-success"></span>

            <span class="btn btn-info"></span>

            <span class="btn btn-warning"></span>

            <span class="btn btn-danger"></span>
        </div> -->

    </div><!-- #sidebar-shortcuts -->


    <ul class="nav nav-list">

        <li class="active" id="mfwindex">
            <a href="login_index.do"><i class="icon-dashboard"></i><span>主页</span></a>
        </li>


        <c:forEach items="${menuList}" var="menu">
            <c:if test="${menu.hasMenu}">
                <li id="lm${menu.MENU_ID }">
                    <c:choose>
                        <c:when test="${menu.MENU_URL=='#'}">
                            <a href="#" class="dropdown-toggle">
                                <i class="${menu.MENU_ICON == null ? 'icon-desktop' : menu.MENU_ICON}"></i>
                                <span>${menu.MENU_NAME }</span>

                                <b class="arrow icon-angle-down"></b>
                            </a>
                            <ul class="submenu">
                                <c:forEach items="${menu.subMenu}" var="sub">
                                    <c:if test="${sub.hasMenu}">
                                        <c:choose>
                                            <c:when test="${not empty sub.subMenu}">
                                                <li>
                                                    <a href="#" class="dropdown-toggle">
                                                        <i class="icon-double-angle-right"></i>
                                                            ${sub.MENU_NAME }
                                                        <b class="arrow icon-angle-down"></b>
                                                    </a>
                                                    <ul class="submenu">
                                                        <c:forEach items="${sub.subMenu}" var="newSub">
                                                            <c:if test="${newSub.hasMenu}">
                                                                <c:choose>
                                                                    <c:when test="${not empty newSub.MENU_URL}">
                                                                        <li id="z${newSub.MENU_ID}">
                                                                            <a style="cursor:pointer;"
                                                                               target="mainFrame"
                                                                               onclick="siMenu('z${newSub.MENU_ID }','lm${sub.MENU_ID }','${newSub.MENU_NAME }','${newSub.MENU_URL }')">
                                                                                <i class="icon-double-angle-right"></i>${newSub.MENU_NAME }
                                                                            </a>
                                                                        </li>
                                                                    </c:when>
                                                                    <c:otherwise>
                                                                        <li><a href="javascript:void(0);"><i
                                                                                class="icon-double-angle-right"></i>${newSub.MENU_NAME }
                                                                        </a></li>
                                                                    </c:otherwise>
                                                                </c:choose>
                                                            </c:if>
                                                        </c:forEach>
                                                    </ul>
                                                </li>
                                            </c:when>
                                            <c:otherwise>
                                                <c:choose>
                                                    <c:when test="${not empty sub.MENU_URL}">
                                                        <li id="z${sub.MENU_ID }">
                                                            <a style="cursor:pointer;" target="mainFrame"
                                                               onclick="siMenu('z${sub.MENU_ID }','lm${menu.MENU_ID }','${sub.MENU_NAME }','${sub.MENU_URL }')">
                                                                <i class="icon-double-angle-right"></i>${sub.MENU_NAME }
                                                            </a>
                                                        </li>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <li><a href="javascript:void(0);"><i
                                                                class="icon-double-angle-right"></i>${sub.MENU_NAME }
                                                        </a></li>
                                                    </c:otherwise>
                                                </c:choose>
                                            </c:otherwise>
                                        </c:choose>
                                    </c:if>
                                </c:forEach>
                            </ul>
                        </c:when>
                        <c:otherwise>
                            <a style="cursor:pointer;" target="mainFrame"
                               onclick="siMenu('lm${menu.MENU_ID }','lm${menu.MENU_ID }','${menu.MENU_NAME }','${menu.MENU_URL }')">
                                <i class="${menu.MENU_ICON == null ? 'icon-desktop' : menu.MENU_ICON}"></i>${menu.MENU_NAME }
                            </a>
                        </c:otherwise>
                    </c:choose>
                </li>
            </c:if>
        </c:forEach>

    </ul><!--/.nav-list-->

    <div id="sidebar-collapse"><i class="icon-double-angle-left"></i></div>

</div>
<!--/#sidebar-->

