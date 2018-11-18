import { getCryptoSupportStatus } from './common';
import consentEventHandler from './consent';
import computeEventHandler from './computer';

function mainEventHandler() {
    const status = getCryptoSupportStatus();
    if (status === 'undecided') {
        consentEventHandler();
    } else if (status == 'granted') {
        computeEventHandler();
    }
}

export default mainEventHandler;