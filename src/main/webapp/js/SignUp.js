// SignUp.js - Modern, interactive enhancements for the SignUp page

document.addEventListener('DOMContentLoaded', function () {
    // 1. Smooth form fade-in
    const formContainer = document.querySelector('.form-bubble-container');
    if (formContainer) {
        formContainer.style.opacity = 0;
        formContainer.style.transform = 'translateY(40px)';
        setTimeout(() => {
            formContainer.style.transition = 'opacity 0.7s cubic-bezier(0.4,0,0.2,1), transform 0.7s cubic-bezier(0.4,0,0.2,1)';
            formContainer.style.opacity = 1;
            formContainer.style.transform = 'translateY(0)';
        }, 200);
    }

    // 2. Button ripple effect
    document.querySelectorAll('.signUp-btn').forEach(btn => {
        btn.addEventListener('click', function (e) {
            let ripple = document.createElement('span');
            ripple.className = 'ripple';
            ripple.style.left = (e.offsetX) + 'px';
            ripple.style.top = (e.offsetY) + 'px';
            this.appendChild(ripple);
            setTimeout(() => ripple.remove(), 600);
        });
    });

    // 3. Real-time input validation
    const emailInput = document.querySelector('input[name="email"]');
    const passwordInput = document.querySelector('input[name="password"]');
    const confirmPasswordInput = document.querySelector('input[name="confirmPassword"]');
    const nameInput = document.querySelector('input[name="name"]');

    const form = document.querySelector('.form-bubble');
    const signUpBtn = form.querySelector('.signUp-btn');

    const errorMsg = document.createElement('div');
    errorMsg.className = 'signup-error-message';
    form.insertBefore(errorMsg, signUpBtn); // ✅ Gắn lỗi vào đúng vị trí trong form

    function showError(msg) {
        errorMsg.textContent = msg;
        errorMsg.style.opacity = 1;
        errorMsg.style.transform = 'translateY(0)';
        setTimeout(() => {
            errorMsg.style.opacity = 0;
            errorMsg.style.transform = 'translateY(-10px)';
        }, 3500);
    }


    function validateEmail(email) {
        return /^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(email);
    }

    function validateForm() {
        const password = passwordInput.value;

        if (!nameInput.value.trim()) {
            showError('Please enter your full name.');
            return false;
        }

        if (!validateEmail(emailInput.value)) {
            showError('Please enter a valid email address.');
            return false;
        }

        if (!password) {
            showError('Please enter a password.');
            return false;
        }

        // ✅ Regex kiểm tra password mạnh
        const strongPasswordRegex = /^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[\W_]).{8,}$/;

        if (!strongPasswordRegex.test(password)) {
            showError('Password must be at least 8 characters, and include uppercase, lowercase, number, and special character.');
            return false;
        }

        if (password !== confirmPasswordInput.value) {
            showError('Passwords do not match.');
            return false;
        }

        return true;
    }



    // Real-time validation feedback
    [emailInput, passwordInput, confirmPasswordInput, nameInput].forEach(input => {
        if (input) {
            input.addEventListener('input', () => {
                errorMsg.textContent = '';
            });
        }
    });

    // 4. Password show/hide toggle
    document.querySelectorAll('.input-icon input[type="password"]').forEach(input => {
        const toggle = input.parentNode.querySelector('.toggle-password');
        if (toggle) {
            toggle.addEventListener('click', function () {
                const isPassword = input.type === 'password';
                input.type = isPassword ? 'text' : 'password';
                this.classList.toggle('fa-eye');
                this.classList.toggle('fa-eye-slash');
            });

        }
    });

    // 5. Subtle input focus/blur effects
    document.querySelectorAll('.input-icon input').forEach(input => {
        input.addEventListener('focus', function () {
            this.parentNode.style.boxShadow = '0 0 0 2px #5ee7df';
        });
        input.addEventListener('blur', function () {
            this.parentNode.style.boxShadow = '';
        });
    });

    // 6. Form submit handler
    if (form) {
        form.addEventListener('submit', function (e) {
            if (!validateForm()) {
                e.preventDefault();
            }
        });
    }
});

// Ripple effect CSS (inject if not present)
(function () {
    if (!document.getElementById('signup-ripple-style')) {
        const style = document.createElement('style');
        style.id = 'signup-ripple-style';
        style.textContent = `
        .ripple {
            position: absolute;
            border-radius: 50%;
            transform: scale(0);
            animation: ripple 0.6s linear;
            background-color: rgba(33,147,176,0.25);
            pointer-events: none;
            width: 80px;
            height: 80px;
            left: 50%;
            top: 50%;
            margin-left: -40px;
            margin-top: -40px;
            z-index: 2;
        }
        @keyframes ripple {
            to {
                transform: scale(2.5);
                opacity: 0;
            }
        }
        .signup-error-message {
            color: #d9534f;
            background: #fff3cd;
            border-radius: 8px;
            padding: 8px 16px;
            margin-bottom: 18px;
            font-weight: bold;
            font-size: 16px;
            box-shadow: 0 2px 8px rgba(249, 199, 79, 0.15);
            opacity: 0;
            transform: translateY(-10px);
            transition: opacity 0.4s, transform 0.4s;
            text-align: center;
        }
        .toggle-password {
            display: inline-block;
            vertical-align: middle;
        }
        `;
        document.head.appendChild(style);
    }
})(); 