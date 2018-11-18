/**
 * This function gets the current accepted level by the user for computing
 * hashes on her browser. Possible return values are: 'granted' if the user
 * consents, 'rejected' if the user has rejected, 'unsupported' if the
 * browser won't be able to deal, 'undecided' if the user hasn't chosen yet.
 */
function getCryptoSupportStatus() {
    // Consent status is stored in the localStorage. Therefore, if the browser
    // does not support localStorage, there is nothing to do to store the
    // consent level, so we have to bail out.
    if (typeof(Storage) === 'undefined') {
        return 'unsupported';
    }

    // Return the consent level as given by the user.
    return window.localStorage.computeConsent || 'undecided';
}

/**
 * Sets in the local storage the consent level given by the user.
 * @param {boolean} status the agreement status given by the user.
 */
function setCryptoSupportStatus(status) {
    if (typeof(Storage) !== 'undefined') {
        window.localStorage.computeConsent = status ? 'granted' : 'rejected';
    }
}

export { getCryptoSupportStatus, setCryptoSupportStatus };