const copies = document.querySelectorAll(".copycomponent");

for (const copy of copies) {
  const button = copy.querySelector("button.copy");
  const node = copy.querySelector("span.inner");
  const copied = copy.querySelector("span.copied");

  if (button) {
    if (!navigator.clipboard) {
      button.setAttribute("disabled", "disabled");
      continue;
    }
    button.addEventListener("click", () => {
      let content = node.innerText.trim();
      navigator.clipboard.writeText(content);
      copied.removeAttribute("hidden");
    });
  }
}
