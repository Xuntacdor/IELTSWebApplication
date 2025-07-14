<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page import="model.User" %>
<%@ page import="model.CamPackage" %>
<%@ page import="java.util.List" %>
<%
    User user = (User) session.getAttribute("user");
    List<CamPackage> packages = (List<CamPackage>) request.getAttribute("packages");
%>
<!DOCTYPE html>
<html>
    <head>
        <title>Nạp CAM</title>
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/topup-cam.css">
        <link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap">
    </head>
    <body>

        <div class="cam-package-section">
            <h3>💰 Choose a CAM Package to Top Up</h3>
            <div class="package-list">
                <c:forEach var="pkg" items="${packages}">
                    <div class="package-card" onclick="selectPackage(${pkg.price}, '${pkg.camAmount}', ${pkg.bonus}, this, ${pkg.id})">
                        <div class="package-img">
                            <c:choose>
                                <c:when test="${pkg.camAmount <= 40000}">
                                    <img src="${pageContext.request.contextPath}/Sources/Payment/cam-coin-1.jpg" alt="CAM image">
                                </c:when>
                                <c:when test="${pkg.camAmount <= 100000}">
                                    <img src="${pageContext.request.contextPath}/Sources/Payment/cam-coin-100.jpg" alt="CAM image">
                                </c:when>
                                <c:when test="${pkg.camAmount <= 500000}">
                                    <img src="${pageContext.request.contextPath}/Sources/Payment/bag-cam-coin.jpg" alt="CAM image">
                                </c:when>
                                <c:otherwise>
                                    <img src="${pageContext.request.contextPath}/Sources/Payment/chest-cam-coin.jpg" alt="CAM image">
                                </c:otherwise>
                            </c:choose>
                            <c:if test="${pkg.bonus > 0}">
                                <div class="bonus-overlay">+ ${pkg.bonus} Bonus</div>
                            </c:if>
                        </div>
                        <div class="package-details">
                            <div class="package-text">
                                <div class="cam-amount">${pkg.camAmount} CAM Package</div>
                                <div class="price">${pkg.price} VND</div>
                            </div>
                            <button class="btn">+</button>
                        </div>
                    </div>
                </c:forEach>
            </div>
        </div>

        <div class="fuo-payment-container" id="paymentSection" style="display:none;">
            <div class="fuo-container">
                <div class="fuo-header">
                    <h1>💰 Top Up CAM</h1>
                    <p>Quick and secure CAM top-up via bank transfer or QR code</p>
                </div>

                <div class="fuo-payment-card">
                    <div class="fuo-card-grid">
                        <!-- ACCOUNT INFO -->
                        <div class="fuo-bank-info">
                            <h2 class="fuo-section-title">🔰 Account Information</h2>

                            <div class="fuo-info-item">
                                <div class="fuo-info-label">Account Holder</div>
                                <div class="fuo-info-value">NGUYEN NHAT QUANG</div>
                            </div>

                            <div class="fuo-info-item">
                                <div class="fuo-info-label">Account Number</div>
                                <div class="fuo-info-value">0200269329999</div>
                            </div>

                            <div class="fuo-info-item">
                                <div class="fuo-info-label">Bank</div>
                                <div class="fuo-info-value">MB BANK</div>
                            </div>

                            <div class="fuo-info-item">
                                <div class="fuo-info-label">Transfer Content</div>
                                <div class="fuo-info-value" id="transferContent">NAPCAM_<%= user.getUserId()%></div>
                            </div>

                            <div class="fuo-exchange-rate">
                                <div class="rate">1,000 CAM = 1,000 VND</div>
                                <div class="subtitle">Fixed exchange rate</div>
                            </div>

                            <div class="fuo-notice">
                                <h4>⚠ Note</h4>
                                <p>Transfer with the correct content for automatic CAM credit</p>
                                <p>Wait 1–2 minutes for the system to process</p>
                                <p>Contact support if you encounter any issues</p>
                            </div>

                            <div class="fuo-status-indicator">
                                <div class="fuo-pulse"></div> System is online
                            </div>
                        </div>

                        <!-- QR CODE -->
                        <div class="fuo-qr-section">
                            <h2 class="fuo-section-title">📱 Scan QR Code to Transfer</h2>
                            <p>Use your banking app to scan and transfer automatically</p>
                            <div class="fuo-qr-code">
                                <img id="qrImage" src="" alt="QR for transfer">
                                <form action="RequestTopUpServlet" method="post" class="text-center mt-3">
                                    <input type="hidden" name="amount" id="amountInput" value="0" />
                                    <button class="btn btn-success" type="submit">✅ I have transferred</button>
                                </form>
                            </div>

                            <div style="margin-top: 20px; background: rgba(255,255,255,0.1); padding: 15px; border-radius: 10px;">
                                <h4>📋 Quick Guide</h4>
                                <p>1. Open your banking app<br>2. Select "Scan QR"<br>3. Scan and confirm the transaction<br>4. Wait 1-2 minutes for CAM to be credited</p>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- SCRIPT -->
        <script>
            window.contextPath = '${pageContext.request.contextPath}';
            function selectPackage(amount, cam, bonus, el, packageId) {
                document.getElementById("paymentSection").style.display = "block";

                const userId = '<%= user.getUserId()%>';
                const content = "NAPCAM_" + userId + "_" + amount;
                document.getElementById("transferContent").textContent = content;
                document.getElementById("transferContent").onclick = () => navigator.clipboard.writeText(content).then(() => alert("Copied content: " + content));

                const qrImage = document.getElementById("qrImage");
                qrImage.src = `https://img.vietqr.io/image/mb-0200269329999-compact.png?amount=${amount}&addInfo=${content}&accountName=NGUYEN%20NHAT%20QUANG`;

                document.getElementById("amountInput").value = amount;
                
                // Add package ID to form for processing
                const packageIdInput = document.createElement('input');
                packageIdInput.type = 'hidden';
                packageIdInput.name = 'packageId';
                packageIdInput.value = packageId;
                document.querySelector('form').appendChild(packageIdInput);

                window.scrollTo({top: document.getElementById("paymentSection").offsetTop - 20, behavior: 'smooth'});

                document.querySelectorAll(".package-card").forEach(card => card.classList.remove("selected"));
                el.classList.add("selected");
            }
        </script>
        <script src="${pageContext.request.contextPath}/js/FishTank.js"></script>
        <canvas id="fishCanvas" style="position:fixed; left:0; top:0; width:100vw; height:100vh; z-index:-1;"></canvas>
    </body>
</html>
