document.addEventListener("DOMContentLoaded", () => {
    const buttons = document.querySelectorAll(".admin-btn");

    buttons.forEach(btn => {
        btn.addEventListener("click", (e) => {
            btn.classList.add("clicked");
            setTimeout(() => {
                btn.classList.remove("clicked");
            }, 300);
        });
    });
});
