window.addEventListener('load', function() {
  if (!document.body.classList.contains('page-videos')) return;

  /* On form submission, update the video duration hidden field. */
  var form = document.querySelector('form.simple_form');
  form && form.addEventListener('submit', function() {
    // Extract sexagesimal time values.
    var hh = form.querySelector('#duration_hours').value || 0;
    var mm = form.querySelector('#duration_minutes').value || 0;
    var ss = form.querySelector('#duration_seconds').value || 0;

    // Convert to seconds.
    var time = parseInt(hh) * 3600 + parseInt(mm) * 60 + parseInt(ss);
    form.querySelector('#video_duration').value = time;
  });
});