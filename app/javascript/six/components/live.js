document.addEventListener("DOMContentLoaded", () => {
  function doNotRemind() {
    return document.cookie.split(";").some((item) => item.trim().startsWith("nolive="));
  }

  const notToday = document.getElementById("live-not-today");
  const liveBlock = document.querySelector("body > .live");
  if (liveBlock) {
    if (doNotRemind()) {
      liveBlock.remove();
    }
    notToday.addEventListener("click", () => {
      const expiration = Date.now() + 86400 * 1000 * 0.5;
      const date = new Date(expiration);
      document.cookie = "nolive=nolive; expires=" + date.toUTCString() + "; path=/";
      liveBlock.remove();
    });
  }
});
