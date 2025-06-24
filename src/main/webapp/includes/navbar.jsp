<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<div class="col-md-3">
    <div class="logo">
        <img src="${pageContext.request.contextPath}/Sources/HomeSource/cloud.png" alt="logo"/>
        <p>IELTSPhobic</p>
    </div>
    <ul class="sidebar-menu">
        <li class="menu-item">
            <a href="${pageContext.request.contextPath}/HomeServlet">
                <img src="${pageContext.request.contextPath}/Sources/HomeSource/overview.png" alt="">
                <span>Overview</span>
            </a>
        </li>
        <li class="menu-item">
            <a href="${pageContext.request.contextPath}/exam-list?category=READING_SINGLE">
                <img src="${pageContext.request.contextPath}/Sources/HomeSource/reading1.png" alt="">
                <span>Reading</span>
            </a>
        </li>
        <li class="menu-item">
            <a href="${pageContext.request.contextPath}/exam-list?category=LISTENING_SINGLE">
                <img src="${pageContext.request.contextPath}/Sources/HomeSource/headphone1.png" alt="">
                <span>Listening</span>
            </a>
        </li>
        <li class="menu-item">
            <a href="${pageContext.request.contextPath}/exam-list?category=READING_FULL">
                <img src="${pageContext.request.contextPath}/Sources/HomeSource/reading2.png" alt="">
                <span>Reading (Full Test)</span>
            </a>
        </li>
        <li class="menu-item">
            <a href="${pageContext.request.contextPath}/exam-list?category=LISTENING_FULL">
                <img src="${pageContext.request.contextPath}/Sources/HomeSource/headphone2.png" alt="">
                <span>Listening (Full Test)</span>
            </a>
        </li>
        <li class="menu-item">
            <a href="${pageContext.request.contextPath}/settings.jsp">
                <img src="${pageContext.request.contextPath}/Sources/HomeSource/setting.png" alt="">
                <span>Settings</span>
            </a>
        </li>
    </ul>

    <div class="upgrade-btn-container">
        <button class="btn-upgrade">Upgrade to Premium</button>
    </div>
</div>
