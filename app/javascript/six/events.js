/* Track events. */
import YouTubePlayer from "youtube-player";

/* Build a YouTube player. Keep the player variable to use later. */
let player = null;
const youtubePlayer = document.getElementById("ytplayer");
if (youtubePlayer) {
  player = YouTubePlayer(youtubePlayer, {
    videoId: youtubePlayer.getAttribute("data-id"),
  });
}

/* For debug purpose, let's expose it in the global variable. */
window.__player = player || "Unloaded";

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

/* Goal: play the video. */
if (player != null) {
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
}
