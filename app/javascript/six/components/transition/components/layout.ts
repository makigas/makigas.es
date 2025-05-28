export function initLayoutComponent() {
  document.querySelectorAll(".Layout").forEach((layout) => {
    const button = layout.querySelector<HTMLButtonElement>(".Layout__button");
    button?.addEventListener("click", () => {
      layout.classList.add("Layout--open");
    });

    const backdrop = layout.querySelector<HTMLDivElement>(".Layout__backdrop");
    backdrop?.addEventListener("click", () => {
      layout.classList.remove("Layout--open");
    });
  });
}
