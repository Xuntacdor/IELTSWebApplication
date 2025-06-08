function togglePassword(fieldId, iconElement) {
    const input = document.getElementById(fieldId);
    const isHidden = input.type === "password";
    input.type = isHidden ? "text" : "password";
    iconElement.classList.toggle("fa-eye");
    iconElement.classList.toggle("fa-eye-slash");
}
