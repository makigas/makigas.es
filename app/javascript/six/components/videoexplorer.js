const explorer = document.getElementById("sToggleExplorer");
if (explorer) {
  explorer.addEventListener("click", () => {
    document.querySelector(".videoexplorer__sidebar").classList.toggle("videoexplorer__sidebar--toggle");
  });
}
