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

    // === Highlight Mode Logic ===
    let highlightMode = false;
    const highlightBtn = document.getElementById("highlightModeBtn");
    const highlightMenu = document.getElementById("highlightMenu");

    highlightBtn.addEventListener("click", function() {
        highlightMode = !highlightMode;
        highlightBtn.classList.toggle("active", highlightMode);
        document.querySelectorAll('.passage-text').forEach(el => {
            if (highlightMode) {
                el.classList.add('highlight-mode');
            } else {
                el.classList.remove('highlight-mode');
            }
        });
        if (!highlightMode) {
            highlightMenu.style.display = "none";
        }
    });

    // Show highlight menu only in highlight mode and only for .passage-text

    document.addEventListener("mouseup", function (e) {
        if (!highlightMode) {
            highlightMenu.style.display = "none";
            return;
        }
        const selection = window.getSelection();
        const text = selection.toString().trim();
        if (text.length > 0) {
            // Only show if selection is inside .passage-text
            let node = selection.anchorNode;
            let passage = node ? (node.nodeType === 3 ? node.parentElement : node) : null;
            passage = passage ? passage.closest('.passage-text') : null;
            if (passage) {
                const range = selection.getRangeAt(0);
                const rect = range.getBoundingClientRect();
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

    highlightMenu.addEventListener("click", function() {
        const selection = window.getSelection();
        const text = selection.toString();
        if (text.length > 0) {
            let node = selection.anchorNode;
            let passage = node ? (node.nodeType === 3 ? node.parentElement : node) : null;
            passage = passage ? passage.closest('.passage-text') : null;
            if (passage) {
                // Replace selected text with highlighted span
                const range = selection.getRangeAt(0);
                const span = document.createElement('span');
                span.className = 'highlighted';
                span.textContent = text;
                range.deleteContents();
                range.insertNode(span);
            }
            window.getSelection().removeAllRanges();
            highlightMenu.style.display = "none";
        }
    });

    // === Unhighlight logic ===
    document.addEventListener('click', function(e) {
        if (e.target.classList.contains('highlighted')) {
            // Only allow unhighlight inside passage-text
            const passage = e.target.closest('.passage-text');
            if (passage) {
                const span = e.target;
                const text = document.createTextNode(span.textContent);
                span.parentNode.replaceChild(text, span);
            }
        }
    });


});
