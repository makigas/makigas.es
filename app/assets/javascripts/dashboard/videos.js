window.addEventListener('load', function() {
  if (!document.body.classList.contains('page-videos')) return;

  var form = document.querySelector('form.simple_form');

  // Check that there is actually a form in this page.
  if (form == null) return;

  /**
   * Updates the hidden duration field using the sexagesimal values.
   * Because setting the duration using seconds would be hard when the
   * video lasts more than 60 seconds, the duration is set using hours,
   * minutes and seconds by the user. This function will update the
   * hidden duration value which is the value actually sent to the
   * server.
   */
  var updateDuration = function() {
    // Get the current sexagesimal time.
    var hours = parseInt(form.querySelector('#duration_hours').value) || 0;
    var minutes = parseInt(form.querySelector("#duration_minutes").value) || 0;
    var seconds = parseInt(form.querySelector("#duration_seconds")) || 0;

    // Update the hidden actual seconds value.
    var duration = hours * 3600 + minutes * 60 + seconds;
    form.querySelector('#video_duration').value = duration;
  };

  [
    form.querySelector("#duration_hours"),
    form.querySelector("#duration_minutes"),
    form.querySelector("#duration_seconds")
  ].forEach(function(item) {
    item.addEventListener('change', updateDuration);
    item.addEventListener('keyup', updateDuration);
    item.addEventListener('blur', function(e) {
      if (e.target.value == "") {
        e.target.value = 0;
      } else {
        var realValue = parseInt(e.target.value);
        if (realValue < 0) {
          e.target.value = 0;
        }
      }
    });
  });
});