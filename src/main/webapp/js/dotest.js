window.addEventListener("DOMContentLoaded", function () {
    const timeLimitElement = document.getElementById("timeLimit");
    if (!timeLimitElement) return;

    let totalSeconds = parseInt(timeLimitElement.value);

    function updateTimer() {
        const h = String(Math.floor(totalSeconds / 3600)).padStart(2, '0');
        const m = String(Math.floor((totalSeconds % 3600) / 60)).padStart(2, '0');
        const s = String(totalSeconds % 60).padStart(2, '0');
        const countdown = document.getElementById("countdown");
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

    window.confirmExit = function () {
        if (confirm("❌ Are you sure you want to exit the test? Your progress will be lost.")) {
            window.location.href = "View/Home.jsp";
        }
    };
});
