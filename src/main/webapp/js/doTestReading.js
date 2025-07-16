// doTestReading.js

function showSection(index) {
    const sections = document.querySelectorAll('.section-content');
    sections.forEach(div => div.style.display = 'none');
    document.getElementById('section-' + index).style.display = 'flex';

    const buttons = document.querySelectorAll('.section-btn');
    buttons.forEach(btn => btn.classList.remove('active'));
    document.querySelector(`.section-btn[data-index="${index}"]`).classList.add('active');
}

document.addEventListener("DOMContentLoaded", function () {
    // Section buttons
    const buttons = document.querySelectorAll(".section-btn");
    if (buttons.length > 0) {
        buttons[0].classList.add("active");
        showSection(buttons[0].getAttribute("data-index"));
    }

    buttons.forEach(btn => {
        btn.addEventListener("click", function () {
            const index = this.getAttribute("data-index");
            showSection(index);
        });
    });

    // Timer logic
    let elapsedTime = 0;
    const timerElement = document.getElementById("timer");

    function updateTimer() {
        const minutes = Math.floor(elapsedTime / 60);
        const seconds = elapsedTime % 60;
        timerElement.textContent = `⏱ ${String(minutes).padStart(2, '0')}:${String(seconds).padStart(2, '0')}`;
        elapsedTime++;
    }

    setInterval(updateTimer, 1000);



    // Settings toggle
    document.getElementById("settingsBtn").addEventListener("click", () => {
        const menu = document.getElementById("settingsMenu");
        menu.style.display = (menu.style.display === "block") ? "none" : "block";
    });

    // Eye protection mode
    document.getElementById("eyeProtection").addEventListener("change", function () {
        document.body.style.backgroundColor = this.checked ? "#fcefcf" : "";
    });

    // Font size selector
    document.getElementById("fontSizeSelector").addEventListener("change", function () {
        document.body.style.fontSize = this.value + "px";
    });

    // Exit button
    document.getElementById("exitBtn").addEventListener("click", () => {
        if (confirm("Are you sure you want to exit the test? Your progress will be lost.")) {
            window.location.href = appContext + "/View/Home.jsp";
        }
    });

    // Handle text selection highlight popup
    document.addEventListener("mouseup", function (e) {
    const selection = window.getSelection();
    const text = selection.toString().trim();
    const highlightMenu = document.getElementById("highlightMenu");

    if (text.length > 0) {
        const range = selection.getRangeAt(0);
        const rect = range.getBoundingClientRect();

        if (e.target.closest(".passage-text")) {
            highlightMenu.style.display = "block";
            highlightMenu.style.left = `${rect.left + window.scrollX}px`;
            highlightMenu.style.top = `${rect.top + window.scrollY - 40}px`;
        } else {
            highlightMenu.style.display = "none";
        }
    } else {
        highlightMenu.style.display = "none";
    }
});

document.getElementById("highlightMenu").addEventListener("click", () => {
    const selection = window.getSelection();
    const text = selection.toString();
    if (text.length > 0) {
        const range = selection.getRangeAt(0);
        const span = document.createElement("span");
        span.className = "highlighted";
        span.textContent = text;
        range.deleteContents();
        range.insertNode(span);
        window.getSelection().removeAllRanges();
        document.getElementById("highlightMenu").style.display = "none";
    }
});


});
