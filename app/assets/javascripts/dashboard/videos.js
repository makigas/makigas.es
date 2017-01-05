// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.

$(document).ready(function() {
  var form = 'body.page-videos form.simple_form';

  var updateDuration = function() {
    hours = parseInt($(form).find('#duration_hours').val() || 0);
    minutes = parseInt($(form).find('#duration_minutes').val() || 0);
    seconds = parseInt($(form).find('#duration_seconds').val() || 0);
    $(form).find('#video_duration').val(hours * 3600 + minutes * 60 + seconds);
  };

  var formatComponent = function() {
    var value = parseInt($(this).val() || 0);
    if (value < 10) {
      $(this).val("0" + value);
    }
  }

  var timer = $(form).find('#duration_hours, #duration_minutes, #duration_seconds');
  timer.change(updateDuration);
  timer.keyup(updateDuration);
  timer.blur(formatComponent);
});