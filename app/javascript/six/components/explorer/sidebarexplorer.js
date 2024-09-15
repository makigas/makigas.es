const explorer = document.getElementById("sToggleExplorer");
if (explorer) {
  function toggleSidebar() {
    document.querySelector(".sidebarexplorer__sidebar").classList.toggle("sidebarexplorer__sidebar--toggle");
    document.querySelector(".sidebarexplorer__background").classList.toggle("sidebarexplorer__background--toggle");
  }
  explorer.addEventListener("click", () => toggleSidebar());

  const background = document.getElementById("sBackdropExplorer");
  if (background) {
    background.addEventListener("click", () => toggleSidebar());
  }
}
