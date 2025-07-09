document.addEventListener("DOMContentLoaded", function () {
    const buttons = document.querySelectorAll(".section-btn");
    const sections = document.querySelectorAll(".section-content");

    buttons.forEach(btn => {
        btn.addEventListener("click", function () {
            const index = this.getAttribute("data-index");
            sections.forEach(sec => sec.style.display = "none");
            document.getElementById("section-" + index).style.display = "flex";

            buttons.forEach(b => b.classList.remove("active"));
            this.classList.add("active");
        });
    });

    if (buttons.length > 0)
        buttons[0].classList.add("active");
});
