import cryptoSupport from './crypto';
import './crypto/crypto.css';

document.addEventListener('DOMContentLoaded', () => cryptoSupport());

// Set the class name to js for custom CSS code that depends on the JS status.
window.addEventListener('load', () => {
  document.body.classList.remove('no-js');
  document.body.classList.add('js');
});

function enableMathPuzzles() {
  if (window.localStorage === undefined) {
    return; /* No support for local storage. Bail. */
  }

  if (!document.querySelector('meta[name="makigas:authedmine"]')) {
    return; /* No API key for AuthedMine has been set. */
  }

  var authedMineApiKey = document.querySelector('meta[name="makigas:authedmine"]').getAttribute('content');

  /* This function should only be executed if consent has been granted. */
  function addMathPuzzles() {
    /* Test that we will be able to put a stop button. */
    var authmToggle = document.getElementById('authm_toggle');
    if (!authmToggle) {
      return;
    }

    /* Add the script tag. */
    var scriptTag = document.createElement('script');
    scriptTag.setAttribute('src', ['https://authedmine.com', 'lib', 'authedmine.min.js'].join('/'));
    scriptTag.onload = function() {
      document.body.classList.add('with-authm');

      /* Connect the process. Yes, it will ask for permission again. */
      let miner = new CoinHive.Anonymous(authedMineApiKey, {throttle: 0.75});
      miner.on('close', () => document.body.classList.remove('with-authm-active'));
      miner.on('open', () => document.body.classList.add('with-authm-active'));
      if (!miner.isMobile() && !miner.didOptOut(14400)) {
        miner.start();
      }

      /* Set up stop button. */
      authmToggle.addEventListener('click', () => {
        miner.stop();
        window.localStorage.removeItem('puzzles:consent');
      });
    };
    document.body.appendChild(scriptTag);
  }

  if (window.localStorage.getItem('puzzles:consent')) {
    /* User has given us consent to download the miner. */
    addMathPuzzles();
  } else {
    /* Request permission to display the miner. */
    let puzzleConsent = document.getElementById('puzzle_consent');
    if (puzzleConsent && 'content' in document.createElement('template')) {
      let puzzleConsentTemplate = document.getElementById('puzzle_consent_template');
      puzzleConsent.appendChild(puzzleConsentTemplate.content.cloneNode(true));

      var buttons = puzzleConsent.querySelectorAll('button[data-id]');
      for (var i = 0; i < buttons.length; i++) {
        buttons[i].setAttribute('id', buttons[i].getAttribute('data-id'));
      }

      document.getElementById('puzzle_consent_trigger_yes').addEventListener('click', () => {
        window.localStorage.setItem('puzzles:consent', 'accept');
        while (puzzleConsent.firstChild) {
          puzzleConsent.removeChild(puzzleConsent.firstChild);
        }
        addMathPuzzles();
      });

      document.getElementById('puzzle_consent_trigger_no').addEventListener('click', () => {
        window.localStorage.setItem('puzzles:consent', 'reject');
        while (puzzleConsent.firstChild) {
          puzzleConsent.removeChild(puzzleConsent.firstChild);
        }
      });
    }
  }
}

document.addEventListener('DOMContentLoaded', () => {
  // Video search page controls update the search query when updated.
  document.querySelectorAll('body.page-videos fieldset[data-autosearch] input').forEach(input => {
    input.addEventListener('change', () => input.closest('form').submit());
  });

  enableMathPuzzles();
});
