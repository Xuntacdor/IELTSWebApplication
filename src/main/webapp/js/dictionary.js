function createSakura() {
    const sakura = document.createElement('div');
    sakura.classList.add('sakura');

    sakura.style.left = Math.random() * window.innerWidth + "px";
    sakura.style.top = "-40px";
    sakura.style.width = sakura.style.height = (Math.random() * 15 + 10) + "px";
    sakura.style.animationDuration = (Math.random() * 5 + 5) + "s";
    sakura.style.opacity = Math.random().toFixed(2); 

    document.body.appendChild(sakura);

    setTimeout(() => {
        sakura.remove();
    }, 10000);
}

setInterval(createSakura, 400); 