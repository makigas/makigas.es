// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.

$(document).ready(function() {
  $('#toggle-description').click(function() {
    $description = $('.video-description');
    
    $('.video-player').toggleClass('col-md-8').toggleClass('col-md-12');
    $('.video-description').toggleClass('hidden-md').toggleClass('hidden-lg');
  });
})