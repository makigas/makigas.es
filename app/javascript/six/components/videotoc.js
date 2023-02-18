document.addEventListener("DOMContentLoaded", () => {
  [...document.querySelectorAll(".videotoc")].forEach((videotoc) => {
    const list = videotoc.querySelector(".videotoc__list");
    const current = videotoc.querySelector(".videotoc__entry--current");
    const firstRow = videotoc.querySelectorAll(".videotoc__entry")[0];

    // Make it compact so that it scrolls if needed.
    videotoc.classList.toggle("videotoc--compact");

    // Compute the Y position of the current row against the first row.
    // This will provide the Y value of the current row, but relative
    // to the beginning of the list.
    const currentRowOffset = current.offsetTop - firstRow.offsetTop;
    list.scrollTop = currentRowOffset - list.clientHeight / 2 + current.clientHeight / 2;
  });
});
