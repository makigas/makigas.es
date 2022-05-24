/*
 * On form submission, the sexagesimal components for the video
 * length should be extracted and the duration in seconds should be
 * calculated, as that is what has to be sent to the backend.
 */
var form = document.querySelector("body.page-videos form.simple_form");

if (form) {
  form.addEventListener("submit", () => {
    // Extract sexagesimal time values.
    const hh = form.querySelector("#duration-hours").value || 0;
    const mm = form.querySelector("#duration-minutes").value || 0;
    const ss = form.querySelector("#duration-seconds").value || 0;

    // Convert to seconds.
    const time = parseInt(hh) * 3600 + parseInt(mm) * 60 + parseInt(ss);
    form.querySelector("#video_duration").value = time;
  });
}

/*
 * Look for buttons that should trigger a return-to.
 */
var returns = [
  ...document.querySelectorAll("button[data-submit-and-return-to], input[type=button][data-submit-and-return-to]"),
];
returns.forEach((button) => {
  button.classList.remove("hidden");
  button.removeAttribute("hidden");

  button.addEventListener("click", (e) => {
    let form = e.target.parentNode;
    while (form.nodeName != "FORM") {
      form = form.parentNode;
      if (form.nodeName == "BODY") {
        throw new Error("This button is not bound to a form");
      }
    }

    /* Add return_to hidden tag. */
    const hiddenTag = document.createElement("input");
    hiddenTag.type = "hidden";
    hiddenTag.name = "return_to";
    hiddenTag.value = button.getAttribute("data-submit-and-return-to");
    form.appendChild(hiddenTag);

    form.querySelector("[type=submit]").click();
  });
});
