const toggleExpand = document.querySelectorAll("button.toggle-expand");
toggleExpand.forEach((button) => {
  button.addEventListener("click", () => {
    const row = button.closest("tr");
    row.classList.toggle("expanded");
  });
});
