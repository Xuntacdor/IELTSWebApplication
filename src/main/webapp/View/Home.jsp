<%@ page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %> <!-- THÊM DÒNG NÀY -->
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8" />
        <meta name="viewport" content="width=device-width, initial-scale=1.0" />
        <title>Admin Dashboard</title>

        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/bootstrap.min.css" />
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/Home.css">
        <link href="https://fonts.googleapis.com/css2?family=ADLaM+Display&display=swap" rel="stylesheet" />
    </head>
    <body>
        <div class="container-fluid home_container">
            <div class="web_page row">
                <div class="col-md-3">
                    <div class="logo">
                        <img src="../Sources/HomeSource/cloud.png" alt="logo"/>
                        <p>IELTSPhobic</p>
                    </div>
                    <div>
                        <ul class="sidebar-menu">
                            <li class="menu-item">
                                <a href="overview.html">
                                    <img src="../Sources/HomeSource/overview.png" alt="Chart Icon">
                                    <span>Overview</span>
                                </a>
                            </li>
                            <li class="menu-item">
                                <a href="reading.html">
                                    <img src="../Sources/HomeSource/reading1.png" alt="Book Icon">
                                    <span>Reading</span>
                                </a>
                            </li>
                            <li class="menu-item">
                                <a href="listening.html">
                                    <img src="../Sources/HomeSource/headphone1.png" alt="Headphone Icon">
                                    <span>Listening</span>
                                </a>
                            </li>
                            <li class="menu-item">
                                <a href="reading-full.html">
                                    <img src="../Sources/HomeSource/reading2.png" alt="Open Book Icon">
                                    <span>Reading (Full Test)</span>
                                </a>
                            </li>
                            <li class="menu-item">
                                <a href="listening-full.html">
                                    <img src="../Sources/HomeSource/headphone2.png" alt="Headphone Icon">
                                    <span>Listening (Full Test)</span>
                                </a>
                            </li>

                            <c:if test="${sessionScope.role eq 'admin'}">
                                <li class="menu-item">
                                    <a href="./AddSources/admin.jsp">
                                        <span>➕ Add  Test</span>
                                    </a>
                                </li>

                            </c:if>

                            <li class="menu-item">
                                <a href="settings.html">
                                    <img src="../Sources/HomeSource/setting.png" alt="Gear Icon">
                                    <span>Settings</span>
                                </a>
                            </li>
                        </ul>

                        <div class="upgrade-btn-container">
                            <button class="btn-upgrade">Upgrade to Premium</button>
                        </div>
                    </div>
                </div>

                <div class="col-md-4">
                    <div>
                        <h2>Summary of your hard work</h2>
                    </div>
                    <div class="dedication_chart">
                        <h4>Your Dedication Chart</h4>
                    </div>
                    <div class="test_history">
                        <h4>Practice History</h4>
                    </div>
                </div>
                <div class="col-md-5"> Third part
                    <p>Role: ${sessionScope.role}</p>
                </div>
            </div>
        </div>
    </body>
</html>
