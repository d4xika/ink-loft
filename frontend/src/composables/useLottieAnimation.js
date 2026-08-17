import { nextTick, onBeforeUnmount, ref } from "vue";

let lottieLoader;

function loadLottie() {
  if (window.lottie) return Promise.resolve(window.lottie);
  if (lottieLoader) return lottieLoader;

  lottieLoader = new Promise((resolve, reject) => {
    const script = document.createElement("script");
    script.src =
      "https://cdnjs.cloudflare.com/ajax/libs/lottie-web/5.12.2/lottie.min.js";
    script.onload = () => resolve(window.lottie);
    script.onerror = reject;
    document.head.appendChild(script);
  });

  return lottieLoader;
}

export function useLottieAnimation() {
  const container = ref(null);
  const isPlaying = ref(false);
  let animation = null;

  function stop() {
    animation?.destroy();
    animation = null;
    isPlaying.value = false;
  }

  function play(path, options = {}) {
    isPlaying.value = true;

    nextTick(() => {
      loadLottie()
        .then((lottie) => {
          if (!container.value) {
            stop();
            return;
          }

          animation?.destroy();
          animation = lottie.loadAnimation({
            container: container.value,
            renderer: options.renderer || "canvas",
            loop: options.loop || false,
            autoplay: true,
            path,
          });
          animation.addEventListener("complete", stop);
        })
        .catch(stop);
    });
  }

  onBeforeUnmount(stop);

  return {
    container,
    isPlaying,
    play,
    stop,
  };
}
