import moment from 'moment';

// Set the class name to js for custom CSS code that depends on the JS status.
window.addEventListener('load', () => {
  document.body.classList.remove('no-js');
  document.body.classList.add('js');
});

document.addEventListener('DOMContentLoaded', () => {
  // Video search page controls update the search query when updated.
  document.querySelectorAll('body.page-videos fieldset[data-autosearch] input').forEach(input => {
    input.addEventListener('change', () => input.closest('form').submit());
  });

  // When DNT is acknowledged, a cookie is created to not display the banner.
  document.getElementById('ack_dnt').addEventListener('click', () => {
    let oneYearFromNow = moment().add('1', 'y').toString();
    document.cookie = `dnt_ack=ack; expires=${oneYearFromNow}; path=/`;
  });
});
