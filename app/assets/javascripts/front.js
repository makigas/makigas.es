$(document).ready(function() {
  // When the navbar is toggled on mobile phone, turn on the background color.
  $('body.page-front .navbar-collapse').on('show.bs.collapse', function() {
    $('body').removeClass('navbar-transparent');
  });

  // When the navbar is removed from mobile phone, turn off background again.
  $('body.page-front .navbar-collapse').on('hidden.bs.collapse', function() {
    $('body').addClass('navbar-transparent');
  });

  // Instead of cold-jumping into the about, use an animation.
  $('#hero-scroller').click(function(e) {
    e.preventDefault();
    var target = $(this).attr('href');
    $('html, body').animate({ scrollTop: $(target).position().top }, 400);
  });
});