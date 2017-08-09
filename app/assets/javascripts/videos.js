$(document).ready(function() {
  $('#toggle-description').click(function() {
    $description = $('.video-description');
    
    $('.video-player').toggleClass('col-md-8').toggleClass('col-md-12');
    $('.video-description').toggleClass('hidden-md').toggleClass('hidden-lg');
  });

  $('body.page-videos form#videos_filter fieldset[data-autosearch] input').on('change', function(e) {
    $(this).closest('form').submit();
  });
})