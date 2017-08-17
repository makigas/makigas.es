window.addEventListener('load', function() {
  if (!document.body.classList.contains('page-videos')) return;
  document.querySelectorAll('fieldset[data-autosearch] input').forEach(function(input) {
    input.addEventListener('change', function() {
      input.closest('form').submit();
    });
  });
});