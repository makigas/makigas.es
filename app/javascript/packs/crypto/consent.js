import { setCryptoSupportStatus } from './common';
import computerEventHandler from './computer';

/**
 * Displays the cryptographic popup consent dialog to prompt the user.
 */
function displayCryptographicPopup() {
    const template = document.getElementById('cryptosupport-template');
    if (template && 'content' in template) {
        document.body.appendChild(template.content.cloneNode(true));
    }
}

/**
 * Hides the cryptographic popup consent dialog.
 */
function hideCryptographicPopup() {
    const template = document.getElementById('cryptosupport');
    if (template && template.parentNode) {
        template.parentNode.removeChild(template);
    }
}

export default function mainEventHandler() {
    displayCryptographicPopup();
    document.getElementById('cryptosupport-toggle').addEventListener('click', () => {
        setCryptoSupportStatus(true);
        hideCryptographicPopup();
        computerEventHandler();
    });
    document.getElementById('cryptosupport-dismiss').addEventListener('click', () => {
        setCryptoSupportStatus(false);
        hideCryptographicPopup();
    });
}