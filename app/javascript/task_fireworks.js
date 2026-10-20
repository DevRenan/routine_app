function launchTaskFireworks() {
    if (typeof confetti !== "function") return;

    const duration = 1800;
    const animationEnd = Date.now() + duration;

    const defaults = {
        startVelocity: 35,
        spread: 360,
        ticks: 60,
        zIndex: 9999
    };

    function randomInRange(min, max) {
        return Math.random() * (max - min) + min;
    }

    const interval = setInterval(() => {
        const timeLeft = animationEnd - Date.now();

        if (timeLeft <= 0) {
            clearInterval(interval);
            return;
        }

        const particleCount = 45 * (timeLeft / duration);

        confetti({
            ...defaults,
            particleCount,
            origin: {
                x: randomInRange(0.1, 0.9),
                y: randomInRange(0.1, 0.5)
            }
        });
    }, 200);
}

document.addEventListener("turbo:load", () => {
    if (document.body.dataset.taskCompleted === "true") {
        launchTaskFireworks();
        delete document.body.dataset.taskCompleted;
    }
});