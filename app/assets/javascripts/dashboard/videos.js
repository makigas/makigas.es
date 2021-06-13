/*
 * On form submission, the sexagesimal components for the video
 * length should be extracted and the duration in seconds should be
 * calculated, as that is what has to be sent to the backend.
 */
var form = document.querySelector('body.page-videos form.simple_form');

if (form) {
  form.addEventListener('submit', function (e) {
    // Extract sexagesimal time values.
    var hh = form.querySelector('#duration_hours').value || 0;
    var mm = form.querySelector('#duration_minutes').value || 0;
    var ss = form.querySelector('#duration_seconds').value || 0;

    // Convert to seconds.
    var time = parseInt(hh) * 3600 + parseInt(mm) * 60 + parseInt(ss);
    form.querySelector('#video_duration').value = time;
  });
}

/*
 * Look for buttons that should trigger a return-to.
 */
var returns = [...document.querySelectorAll('button[data-submit-and-return-to], input[type=button][data-submit-and-return-to]')];
returns.forEach(function (button) {
  button.classList.remove('hidden');

  button.addEventListener('click', function (e) {
    var form = e.target.parentNode;
    while (form.nodeName != "FORM") {
      form = form.parentNode;
      if (form.nodeName == "BODY") {
        throw new Error("This button is not bound to a form");
      }
    }

    /* Add return_to hidden tag. */
    var hiddenTag = document.createElement("input");
    hiddenTag.type = "hidden";
    hiddenTag.name = "return_to";
    hiddenTag.value = button.getAttribute('data-submit-and-return-to');
    form.appendChild(hiddenTag);

    form.querySelector('[type=submit]').click();
  });
});
