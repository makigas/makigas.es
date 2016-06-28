// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.

$(document).ready(function() {
  $('body.front .navbar-collapse').on('hidden.bs.collapse', function() {
    console.log('hola');
    $('body').addClass('sticky-navbar');
  });

  $('body.front .navbar-collapse').on('show.bs.collapse', function() {
    console.log('hola');
    $('body').removeClass('sticky-navbar');
  });
});

$(document).ready(function() {
  if (! $('body').hasClass('front')) return;

  var needsRestick = false;
  setInterval(function() {
    if (needsRestick) {
      var sticky = $('body').hasClass('sticky-navbar');
      var top = $(window).scrollTop();
      var required = $('.makigas-tron').height();

      if (sticky) {
        if (top >= required - 50) {
          $('body').removeClass('sticky-navbar');
          $('body').addClass('fixed-navbar');
        }
      } else {
        if (top < required - 50) {
          $('body').addClass('sticky-navbar');
          $('body').removeClass('fixed-navbar');
        }
      }
      needsRestick = false;
    }
  }, 60);
  
  $(document).scroll(function() {
    needsRestick = true;
  });
});