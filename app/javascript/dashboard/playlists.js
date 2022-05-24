if (document.body.classList.contains("page-playlists")) {
  /**
   * Swaps the numbers displayed in row1 and row2. This function is
   * highly dependent on the table structure. It only works on the
   * videos table because it expects each row to have the first
   * column being the position number.
   *
   * @param {HTMLTableRowElement} row1
   * @param {HTMLTableRowElement} row2
   */
  const swapNumbers = (row1, row2) => {
    const column1 = row1.querySelector("td:first-child");
    const column2 = row2.querySelector("td:first-child");

    // Your classic swap algorithm.
    const tmp = column1.innerText;
    column1.innerText = column2.innerText;
    column2.innerText = tmp;
  };

  // When the move up button is pressed and the request is success,
  // perform the animation where this item and the above up have
  // their position changed.
  document.querySelectorAll(".video-move-up").forEach(function (btn) {
    btn.closest("form").addEventListener("ajax:success", () => {
      const row = btn.closest("tr");
      const previous = row.previousElementSibling;
      const tbody = btn.closest("tbody");

      // Make sure this is not the first position.
      if (previous == null) {
        return;
      }

      // Swap the video positions.
      swapNumbers(row, previous);

      // Start animating.
      row.classList.add("moving-up");
      previous.classList.add("moving-down");

      // Once the animation is finished, do the actual row swap.
      row.addEventListener("animationend", () => {
        row.classList.remove("moving-up");
        previous.classList.remove("moving-down");
        tbody.insertBefore(row, previous);
      });
    });
  });

  document.querySelectorAll(".video-move-down").forEach(function (btn) {
    btn.closest("form").addEventListener("ajax:success", () => {
      const row = btn.closest("tr");
      const next = row.nextElementSibling;
      const tbody = btn.closest("tbody");

      // Make sure this is not the last position.
      if (next == null) {
        return;
      }

      // Swap the video positions.
      swapNumbers(row, next);

      // Start animating.
      row.classList.add("moving-down");
      next.classList.add("moving-up");

      // Once the animation is finished, do the actual row swap.
      row.addEventListener("animationend", () => {
        row.classList.remove("moving-down");
        next.classList.remove("moving-up");
        tbody.insertBefore(next, row);
      });
    });
  });
}
