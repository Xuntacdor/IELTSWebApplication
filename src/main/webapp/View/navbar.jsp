<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<style>
.user-dropdown {
    position: relative;
    display: inline-block;
    margin-left: 18px;
}
.user-dropdown-toggle {
    border: none;
    background: none;
    cursor: pointer;
    display: flex;
    align-items: center;
    padding: 0;
}
.user-avatar {
    width: 36px;
    height: 36px;
    border-radius: 50%;
    object-fit: cover;
    border: 2px solid #e4a4af;
    background: #fff;
}
.user-dropdown-menu {
    display: none;
    position: absolute;
    right: 0;
    top: 48px;
    min-width: 260px;
    background: #fff;
    border-radius: 16px;
    box-shadow: 0 8px 32px rgba(127,85,177,0.13);
    padding: 18px 0 10px 0;
    z-index: 1001;
    font-family: 'ADLaM Display', sans-serif;
}
.user-dropdown.open .user-dropdown-menu {
    display: block;
}
.user-dropdown-menu .user-info {
    text-align: center;
    margin-bottom: 10px;
}
.user-dropdown-menu .user-info .user-avatar {
    width: 54px;
    height: 54px;
    margin-bottom: 6px;
    border: 2px solid #9d80be;
}
.user-dropdown-menu .user-info .user-name {
    font-weight: bold;
    color: #7f55b1;
    font-size: 17px;
}
.user-dropdown-menu .user-info .user-email {
    color: #4b3b60;
    font-size: 13px;
    margin-bottom: 2px;
}
.user-dropdown-menu .dropdown-link {
    display: flex;
    align-items: center;
    padding: 8px 24px;
    color: #4b3b60;
    text-decoration: none;
    font-size: 15px;
    transition: background 0.18s;
    border: none;
    background: none;
    width: 100%;
    text-align: left;
    cursor: pointer;
}
.user-dropdown-menu .dropdown-link:hover {
    background: #fcecec;
    color: #7f55b1;
}
.user-dropdown-menu .dropdown-link .icon {
    margin-right: 10px;
    font-size: 18px;
}
.user-dropdown-menu .logout {
    color: #b71c1c;
    font-weight: 600;
    border-top: 1px solid #eee;
    margin-top: 8px;
    padding-top: 8px;
}
</style>
<script>
document.addEventListener('DOMContentLoaded', function() {
    var dropdown = document.querySelector('.user-dropdown');
    if (dropdown) {
        var toggle = dropdown.querySelector('.user-dropdown-toggle');
        toggle.addEventListener('click', function(e) {
            e.stopPropagation();
            dropdown.classList.toggle('open');
        });
        document.addEventListener('click', function() {
            dropdown.classList.remove('open');
        });
    }
});
</script>

<div class="col-md-3 sidebar-wrapper">
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
            <a href="">
                <span>Placement Test</span>
            </a>
        </li>
        <li class="menu-item">
            <a href="">
                <span>Study Plan Generator</span>
            </a>
        </li>
        <li class="menu-item"><a href="${pageContext.request.contextPath}/SettingsServlet">Settings</a></li>

        <c:if test="${sessionScope.role eq 'admin'}">
            <li class="menu-item">
                <a href="${pageContext.request.contextPath}/View/admin.jsp">
                    <img src="${pageContext.request.contextPath}/Sources/HomeSource/add.png" alt="">
                    <span>Add Test</span>
                </a>
            </li>
        </c:if>
            
    </ul>

    <div class="upgrade-btn-container">
        <button class="btn-upgrade" id="openUpgradeModal">Upgrade to Premium</button>
    </div>
</div>

<div style="float: right; margin-right: 32px;">
    <div class="user-dropdown">
        <button class="user-dropdown-toggle">
            <img class="user-avatar" src="${pageContext.request.contextPath}/Sources/LoginSources/user.png" alt="avatar" />
        </button>
        <div class="user-dropdown-menu">
            <div class="user-info">
                <img class="user-avatar" src="${pageContext.request.contextPath}/Sources/LoginSources/user.png" alt="avatar" />
                <div class="user-name">${sessionScope.user.fullName}</div>
                <div class="user-email">${sessionScope.user.email}</div>
            </div>
            <a class="dropdown-link" href="${pageContext.request.contextPath}/SettingsServlet"><span class="icon">👤</span> Hồ sơ của bạn</a>
            <a class="dropdown-link" href="#"><span class="icon">⏰</span> Lịch sử thanh toán</a>
            <a class="dropdown-link" href="#"><span class="icon">🥜</span> Lịch sử giao dịch CAM</a>
            <form action="${pageContext.request.contextPath}/LogoutServlet" method="post" style="margin:0;">
                <button type="submit" class="dropdown-link logout"><span class="icon">🚪</span> Đăng xuất</button>
            </form>
        </div>
    </div>
</div>


<div id="upgradeModal" class="modal-overlay">
    <div class="modal-content animated-modal">
        <h3>Choose Your Premium Plan</h3>
        <div class="plan-list">
            <c:forEach var="plan" items="${sessionScope.plans}">
                <div class="plan">
                    <h4>${plan.camCost} CAM</h4>
                    <p>
                        <c:choose>
                            <c:when test="${plan.durationInDays == 7}">1 Tuần</c:when>
                            <c:when test="${plan.durationInDays == 30}">1 Tháng</c:when>
                            <c:when test="${plan.durationInDays == 90}">3 Tháng</c:when>
                            <c:otherwise>${plan.durationInDays} ngày</c:otherwise>
                        </c:choose>
                    </p>
                    <form action="BuyPremiumServlet" method="post">
                        <input type="hidden" name="planId" value="${plan.id}" />
                        <button class="btn-pay" type="submit">Select Plan</button>
                    </form>
                </div>
            </c:forEach>
        </div>
        <button class="btn-close" type="button">Close</button>
    </div>
</div>

<script>
    const modal = document.getElementById("upgradeModal");
    const upgradeBtn = document.getElementById("openUpgradeModal");
    const closeBtn = document.querySelector(".btn-close");

    if (upgradeBtn && modal && closeBtn) {
        upgradeBtn.addEventListener("click", () => {
            modal.style.display = "block";
            setTimeout(() => {
                document.querySelector('.animated-modal').classList.add('show');
            }, 10);
        });

        closeBtn.addEventListener("click", () => {
            document.querySelector('.animated-modal').classList.remove('show');
            setTimeout(() => {
                modal.style.display = "none";
            }, 300);
        });

        window.addEventListener("click", function (event) {
            if (event.target === modal) {
                document.querySelector('.animated-modal').classList.remove('show');
                setTimeout(() => {
                    modal.style.display = "none";
                }, 300);
            }
        });
    }
</script>
