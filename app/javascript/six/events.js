/* Track events. */
import YouTubePlayer from "youtube-player";

/* Build a YouTube player. Keep the player variable to use later. */
function startYouTubePlayer() {
  const youtubePlayer = document.getElementById("ytplayer");
  if (youtubePlayer) {
    const player = YouTubePlayer(youtubePlayer, {
      videoId: youtubePlayer.getAttribute("data-id"),
    });

    /* Goal: play video */
    let alreadySent = false;
    player.on("stateChange", (e) => {
      if (!alreadySent && e.data === 1) {
        if (window.plausible) {
          window.plausible("Play");
        } else {
          console.log("Play");
        }
        alreadySent = true;
        player.off("stateChange");
      }
    });

    return player;
  }
  return null;
}

window.startYouTubePlayer = function () {
  const player = startYouTubePlayer();
  if (player) {
    window.__player = player;
  } else {
    window.__player = "Unloaded";
  }
};

// const player = startYouTubePlayer();

/* For debug purpose, let's expose it in the global variable. */
// window.__player = player || "Unloaded";

/* Event: submit the form is a custom event. */
const frontform = document.querySelector("form.searchbar");
if (frontform) {
  frontform.addEventListener("submit", () => {
    if (window.plausible) {
      window.plausible("Search");
    } else {
      console.log("Search");
    }
  });
}
