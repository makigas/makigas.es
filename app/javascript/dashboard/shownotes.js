const iframe = document.getElementById("dashboard-video-player");
if (iframe) {
  let player;

  window.onYouTubeIframeAPIReady = function () {
    player = new YT.Player("dashboard-video-player");
  };

  const tag = document.createElement("script");
  tag.src = "https://www.youtube.com/player_api";
  document.head.appendChild(tag);

  function onPlayPause() {
    if (player.getPlayerState() == 1) {
      player.pauseVideo();
    } else {
      player.playVideo();
    }
  }

  function onRewind() {
    const current = player.getCurrentTime();
    const next = current >= 15 ? current - 15 : 0;
    player.seekTo(next);
  }

  function onChangeSpeed(amount) {
    const current = player.getPlaybackRate();
    next = current + amount;
    player.setPlaybackRate(next);
  }

  document.addEventListener("keydown", (e) => {
    if (e.shiftKey) {
      switch (e.code) {
        case "Space":
          onPlayPause();
          e.preventDefault();
          return;
        case "ArrowLeft":
          onRewind();
          e.preventDefault();
          return;
        case "ArrowUp":
          onChangeSpeed(0.25);
          e.preventDefault();
          return;
        case "ArrowDown":
          onChangeSpeed(-0.25);
          e.preventDefault();
          return;
      }
    }
  });
}
