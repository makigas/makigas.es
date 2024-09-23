import { Modal } from "bootstrap";
const slugModal = document.querySelector("#slugModal");

if (slugModal) {
  const titlePlaceholder = slugModal.querySelector("[data-target-title]");
  const idPlaceholder = slugModal.querySelector("[data-target-id]");
  const slugPlaceholder = slugModal.querySelector("[data-target-slug]");
  const resetCheckbox = slugModal.querySelector("#modal_slug_reset");

  resetCheckbox.addEventListener("change", () => {
    if (resetCheckbox.checked) {
      slugPlaceholder.setAttribute("disabled", "disabled");
    } else {
      slugPlaceholder.removeAttribute("disabled");
    }
  });

  slugModal.addEventListener("shown.bs.modal", () => {
    slugPlaceholder.select();
  });

  function installSlugModalOpen(node) {
    node.addEventListener("click", () => {
      const id = node.getAttribute("data-id");
      const title = node.getAttribute("data-title");
      const slug = node.getAttribute("data-slug");
      console.log(`Opening modal for ${id} x ${slug}`);

      titlePlaceholder.innerText = title;
      idPlaceholder.value = id;
      slugPlaceholder.value = slug;

      const modal = new Modal(slugModal);
      modal.show();
    });
  }

  const slugModalOpen = document.querySelector("#slugModalOpen");

  if (slugModalOpen) {
    installSlugModalOpen(slugModalOpen);
  }
}
