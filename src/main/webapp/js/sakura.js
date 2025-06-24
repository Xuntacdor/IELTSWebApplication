function createSakura() {
    const sakura = document.createElement('div');
    sakura.classList.add('sakura');

    sakura.style.left = Math.random() * 100 + "vw";
    sakura.style.animationDuration = (Math.random() * 5 + 5) + "s";
    sakura.style.opacity = Math.random();
    sakura.style.transform = `rotate(${Math.random() * 360}deg)`;

    document.body.appendChild(sakura);

    setTimeout(() => {
        sakura.remove();
    }, 10000);
}

setInterval(createSakura, 1000);
