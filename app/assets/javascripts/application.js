//= require_self
//= require_directory .

window.addEventListener('load', function(e) {
  document.body.classList.remove('no-js');
  document.body.classList.add('js');
});

document.getElementById('ack_dnt').addEventListener('click', () => {
  const getExpirationDate = () => {
    let date = new Date();
    date.setFullYear(date.getFullYear() + 1);
    return date;
  }
  let oneYearFromNow = getExpirationDate().toUTCString();
  document.cookie = `dnt_ack=ack; expires=${oneYearFromNow}; path=/`;
});
