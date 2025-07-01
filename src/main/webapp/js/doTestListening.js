document.addEventListener("DOMContentLoaded", function () {
    const audio = document.getElementById("audioReal");
    if (!audio) return;

    const playPauseBtn = document.getElementById("playPauseBtn");
    const volumeSlider = document.getElementById("volumeSlider");
    const rewindBtn = document.getElementById("rewindBtn");
    const forwardBtn = document.getElementById("forwardBtn");
    const speedBtn = document.getElementById("speedBtn");
    const muteBtn = document.getElementById("muteBtn");
    const progressBar = document.querySelector(".progress-bar .progress");
    const trackTimeEl = document.getElementById("trackTime");

    let speeds = [1, 1.25, 1.5, 0.75];
    let speedIndex = 0;

    function formatTime(time) {
        if (!isFinite(time) || isNaN(time)) return "00:00";
        const m = Math.floor(time / 60).toString().padStart(2, "0");
        const s = Math.floor(time % 60).toString().padStart(2, "0");
        return `${m}:${s}`;
    }

    function updateTrackTime() {
        if (!trackTimeEl || !audio) return;
        const current = formatTime(audio.currentTime);
        const duration = isFinite(audio.duration) ? formatTime(audio.duration) : "00:00";
        trackTimeEl.textContent = `${current} / ${duration}`;
    }

    audio.addEventListener("loadedmetadata", updateTrackTime);
    audio.addEventListener("timeupdate", () => {
        if (isFinite(audio.duration)) {
            const percent = (audio.currentTime / audio.duration) * 100;
            progressBar.style.width = percent + "%";
        }
        updateTrackTime();
    });

    playPauseBtn.onclick = () => {
        if (audio.paused) {
            audio.play();
            playPauseBtn.textContent = "⏸️";
        } else {
            audio.pause();
            playPauseBtn.textContent = "▶️";
        }
    };

    volumeSlider.oninput = () => audio.volume = volumeSlider.value;
    rewindBtn.onclick = () => audio.currentTime = Math.max(0, audio.currentTime - 5);
    forwardBtn.onclick = () => audio.currentTime = Math.min(audio.duration, audio.currentTime + 5);

    speedBtn.onclick = () => {
        speedIndex = (speedIndex + 1) % speeds.length;
        audio.playbackRate = speeds[speedIndex];
        speedBtn.textContent = `⏱ Tốc độ: ${speeds[speedIndex]}x`;
    };

    muteBtn.onclick = () => {
        audio.muted = !audio.muted;
        muteBtn.textContent = audio.muted ? "🔇" : "🔊";
    };

    updateTrackTime();
});
