/*
 * On form submission, the sexagesimal components for the video
 * length should be extracted and the duration in seconds should be
 * calculated, as that is what has to be sent to the backend.
 */
var form = document.querySelector('body.page-videos form.simple_form');

if (form) {
  form.addEventListener('submit', function(e) {
    // Extract sexagesimal time values.
    var hh = form.querySelector('#duration_hours').value || 0;
    var mm = form.querySelector('#duration_minutes').value || 0;
    var ss = form.querySelector('#duration_seconds').value || 0;

    // Convert to seconds.
    var time = parseInt(hh) * 3600 + parseInt(mm) * 60 + parseInt(ss);
    form.querySelector('#video_duration').value = time;
  });
}