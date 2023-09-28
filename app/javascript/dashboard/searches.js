import { Tooltip } from "bootstrap";

if (document.body.classList.contains("page-searches")) {
  const tooltipTriggerList = document.querySelectorAll('[data-bs-toggle="tooltip"]');
  [...tooltipTriggerList].map((tooltipTriggerEl) => new Tooltip(tooltipTriggerEl));
}
