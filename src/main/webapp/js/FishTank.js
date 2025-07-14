document.addEventListener('DOMContentLoaded', function() {
const contextPath = window.contextPath; 

const canvas = document.getElementById('fishCanvas');
const ctx = canvas.getContext('2d');

function resize() {
    canvas.width = canvas.clientWidth;
    canvas.height = canvas.clientHeight;
    // Vẽ lại san hô khi resize
    drawCorals();
}
window.addEventListener('resize', resize);
resize();

// Danh sách đường dẫn hình ảnh cá, dùng contextPath đúng
const fishImagesSrc = [
    contextPath + '/Sources/LoginSources/coloredfish.png',
    contextPath + '/Sources/LoginSources/clown-fish.png'
];

// Tải tất cả ảnh cá
const fishImages = [];
for (const src of fishImagesSrc) {
    const img = new Image();
    img.src = src;
    fishImages.push(img);
}

// Bong bóng nước
class Bubble {
    constructor() {
        this.radius = 5 + Math.random() * 10;
        this.x = Math.random() * canvas.width;
        this.y = canvas.height + this.radius + Math.random() * 50;
        this.speed = 1 + Math.random() * 2;
        this.alpha = 0.3 + Math.random() * 0.5;
        this.drift = (Math.random() - 0.5) * 0.5;
    }
    update() {
        this.y -= this.speed;
        this.x += this.drift;
        this.alpha -= 0.0008 * this.speed;
        if (this.y < -this.radius || this.alpha <= 0) {
            // Reset lại bong bóng
            this.radius = 5 + Math.random() * 10;
            this.x = Math.random() * canvas.width;
            this.y = canvas.height + this.radius + Math.random() * 50;
            this.speed = 1 + Math.random() * 2;
            this.alpha = 0.3 + Math.random() * 0.5;
            this.drift = (Math.random() - 0.5) * 0.5;
        }
    }
    draw() {
        ctx.save();
        ctx.globalAlpha = this.alpha;
        ctx.beginPath();
        ctx.arc(this.x, this.y, this.radius, 0, 2 * Math.PI);
        ctx.fillStyle = 'rgba(180,220,255,0.7)';
        ctx.fill();
        ctx.strokeStyle = 'rgba(255,255,255,0.5)';
        ctx.stroke();
        ctx.globalAlpha = 1;
        ctx.restore();
    }
}
const bubbles = [];
for (let i = 0; i < 30; i++) {
    bubbles.push(new Bubble());
}

// Sóng nước
function drawWaves() {
    ctx.save();
    ctx.globalAlpha = 0.18;
    ctx.beginPath();
    let waveHeight = 18;
    let waveLength = 120;
    let yOffset = 18;
    ctx.moveTo(0, yOffset);
    for (let x = 0; x <= canvas.width; x += 2) {
        ctx.lineTo(x, yOffset + Math.sin((x + Date.now() / 600) / waveLength) * waveHeight);
    }
    ctx.lineTo(canvas.width, 0);
    ctx.lineTo(0, 0);
    ctx.closePath();
    ctx.fillStyle = '#b3e0ff';
    ctx.fill();
    ctx.globalAlpha = 1;
    ctx.restore();
}

function drawCorals() {
    ctx.save();
    let baseY = canvas.height - 10;
    for (let i = 0; i < canvas.width; i += 60) {
        let coralHeight = 30 + Math.random() * 30;
        ctx.beginPath();
        ctx.moveTo(i, baseY);
        ctx.bezierCurveTo(i + 10, baseY - coralHeight / 2, i + 20, baseY - coralHeight, i + 30, baseY);
        ctx.strokeStyle = i % 120 === 0 ? '#ffb347' : '#ff69b4';
        ctx.lineWidth = 6;
        ctx.stroke();
    }
    ctx.restore();
}

class Fish {
    constructor() {
        this.x = Math.random() * canvas.width;
        this.y = Math.random() * canvas.height;
        this.speed = 1 + Math.random() * 2;
        this.angle = Math.random() * 2 * Math.PI;
        this.size = 40 + Math.random() * 20;
        this.turnTimer = 0;
        this.image = fishImages[Math.floor(Math.random() * fishImages.length)];
    }
    update() {
        this.turnTimer--;
        if (this.turnTimer <= 0) {
            this.angle += (Math.random() - 0.5) * 1;
            this.turnTimer = 30 + Math.random() * 60;
        }
        this.x += Math.cos(this.angle) * this.speed;
        this.y += Math.sin(this.angle) * this.speed;
        if (this.x < 0 || this.x > canvas.width) {
            this.angle = Math.PI - this.angle;
        }
        if (this.y < 0 || this.y > canvas.height) {
            this.angle = -this.angle;
        }
    }
    draw() {
        ctx.save();
        ctx.translate(this.x, this.y);
        ctx.rotate(this.angle);
        ctx.scale(this.speed > 0 ? 1 : -1, 1);
        ctx.drawImage(this.image, -this.size / 2, -this.size / 2, this.size, this.size);
        ctx.restore();
    }
}

// Mảng cá (sẽ khởi tạo sau khi ảnh tải xong)
const fishes = [];

// Vòng lặp hoạt họa
function animate() {
    ctx.clearRect(0, 0, canvas.width, canvas.height);
    drawWaves();
    drawCorals();
    for (const bubble of bubbles) {
        bubble.update();
        bubble.draw();
    }
    for (const fish of fishes) {
        fish.update();
        fish.draw();
    }
    requestAnimationFrame(animate);
}

// Chờ ảnh tải xong rồi mới khởi tạo cá và chạy animate
let loadedImages = 0;
fishImages.forEach(img => {
    img.onload = () => {
        loadedImages++;
        if (loadedImages === fishImages.length) {
            // Tạo cá sau khi tất cả ảnh đã tải
            for (let i = 0; i < 15; i++) {
                fishes.push(new Fish());
            }
            animate();
        }
    };
});
});
