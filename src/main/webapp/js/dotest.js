function showSection(index) {
    document.querySelectorAll(".section-content").forEach(section => {
        section.style.display = "none";
    });

    const target = document.getElementById("section-" + index);
    if (target) {
        target.style.display = "flex";
    }
}

function confirmExit() {
    if (confirm("❌ Are you sure you want to exit the test? Your progress will be lost.")) {
        window.location.href = "View/Home.jsp";
    }
}

window.addEventListener("DOMContentLoaded", function () {
    // Gán sự kiện chuyển section bằng event delegation để luôn hoạt động
    document.addEventListener("click", function(e) {
        if (e.target.classList.contains("section-btn")) {
            const index = e.target.getAttribute("data-index");
            showSection(index);
        }
    });

    // Gán nút thoát nếu có
    const exitBtn = document.getElementById("exitBtn");
    if (exitBtn) {
        exitBtn.addEventListener("click", confirmExit);
    }

    // Timer
    const timeLimitElement = document.getElementById("timeLimit");
    if (timeLimitElement) {
        let totalSeconds = parseInt(timeLimitElement.value);
        const countdown = document.getElementById("countdown");

        function updateTimer() {
            const h = String(Math.floor(totalSeconds / 3600)).padStart(2, '0');
            const m = String(Math.floor((totalSeconds % 3600) / 60)).padStart(2, '0');
            const s = String(totalSeconds % 60).padStart(2, '0');
            if (countdown) countdown.textContent = `${h}:${m}:${s}`;

            if (totalSeconds > 0) {
                totalSeconds--;
            } else {
                clearInterval(timerInterval);
                alert("⏰ Time's up! The test will now be submitted.");
                document.querySelector("form").submit();
            }
        }

        const timerInterval = setInterval(updateTimer, 1000);
        updateTimer();
    }
});
