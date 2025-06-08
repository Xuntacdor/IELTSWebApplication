const contextPath = window.contextPath; // lấy từ biến toàn cục đã khai báo trong JSP

const canvas = document.getElementById('fishCanvas');
const ctx = canvas.getContext('2d');

function resize() {
    canvas.width = canvas.clientWidth;
    canvas.height = canvas.clientHeight;
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

// Lớp cá
class Fish {
    constructor() {
        this.x = Math.random() * canvas.width;
        this.y = Math.random() * canvas.height;
        this.speed = 1 + Math.random() * 2;
        this.angle = Math.random() * 2 * Math.PI;
        this.size = 40 + Math.random() * 20;
        this.turnTimer = 0;

        // Chọn hình ảnh cá ngẫu nhiên
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

        // Va chạm cạnh canvas thì quay đầu
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
