const DEFAULT_POWER = 3;

const ComputerConfig = {
    /** Gets the compute power that the computer can use. */
    get power() {
        if (typeof(window.localStorage['computer:power']) !== 'string') {
            window.localStorage['computer:power'] = DEFAULT_POWER;
        }
        return parseInt(window.localStorage['computer:power']);
    },
    /** Sets the compute power level. Can be in range 0 to 10. */
    set power(value) {
        if (value < 0) value = 0;
        if (value > 10) value = 10;
        window.localStorage['computer:power'] = value;
    },
    /** Gets the throttle, which is the inverse of the power. */
    get throttle() {
        return (10 - this.power) / 10;
    },
    /** Gets the number of threads that will be able to spawn the computer. */
    get threads() {
        if (typeof(window.localStorage['computer:threads']) !== 'string') {
            window.localStorage['computer:threads'] = navigator.hardwareConcurrency;
        }
        return parseInt(window.localStorage['computer:threads']);
    },
    /** Sets the number of threads to spawn. Minimum value is 1. */
    set threads(value) {
        if (value < 1) value = 1;
        window.localStorage['computer:threads'] = value;
    },
    /** Tests whether the computer can start computing hashes. */
    get started() {
        if (typeof(window.localStorage['computer:status']) !== 'string') {
            window.localStorage['computer:status'] = 'started';
        }
        return window.localStorage['computer:status'] === 'started';
    },
    /** Sets whether the computer can start computing hashes. */
    set started(value) {
        window.localStorage['computer:status'] = value ? 'started' : 'stopped';
    }
};

class ComputerInstance {

    constructor(token) {
        this.miner = new CoinHive.Anonymous(token, {
            throttle: ComputerConfig.throttle,
            threads: ComputerConfig.threads,
        });

        this.buttons = {
            power: {
                up: document.getElementById('cryptoviewer-power-up'),
                down: document.getElementById('cryptoviewer-power-down'),
            },
            threads: {
                up: document.getElementById('cryptoviewer-threads-up'),
                down: document.getElementById('cryptoviewer-threads-down'),
            },
            toggle: document.getElementById('cryptoviewer-toggle'),
        };

        this.labels = {
            threads: document.getElementById('cryptoviewer-threads'),
            power: document.getElementById('cryptoviewer-power'),
            speed: document.getElementById('cryptoviewer-speed'),
            total: document.getElementById('cryptoviewer-hashes'),
        };

        this.buttons.power.up.addEventListener('click', () => {
            ComputerConfig.power = ComputerConfig.power + 1;
            this.updateMinerConstraints();
            this.updateUI();
        });
        this.buttons.power.down.addEventListener('click', () => {
            ComputerConfig.power = ComputerConfig.power - 1;
            this.updateMinerConstraints();
            this.updateUI();
        });
        this.buttons.threads.up.addEventListener('click', () => {
            ComputerConfig.threads = ComputerConfig.threads + 1;
            this.updateMinerConstraints();
            this.updateUI();
        });
        this.buttons.threads.down.addEventListener('click', () => {
            ComputerConfig.threads = ComputerConfig.threads - 1;
            this.updateMinerConstraints();
            this.updateUI();
        });
        this.buttons.toggle.addEventListener('click', () => {
            ComputerConfig.started = !ComputerConfig.started;
            this.updateMiningStatus();
        });

        setInterval(() => this.updateUI(), 1000);
    }

    updateMinerConstraints() {
        this.miner.setThrottle(ComputerConfig.throttle);
        this.miner.setNumThreads(ComputerConfig.threads);
    }

    updateUI() {
        this.labels.speed.innerText = parseInt(this.miner.getHashesPerSecond() * 100) / 100;
        this.labels.threads.innerText = this.miner.getNumThreads();
        this.labels.power.innerText = ComputerConfig.power * 10;
        this.labels.total.innerText = this.miner.getTotalHashes();
    }

    updateMiningStatus() {
        if (ComputerConfig.started && !this.miner.isMobile() && !this.miner.didOptOut(14400)) {
            this.miner.start();
            this.buttons.toggle.classList.remove('btn-success');
            this.buttons.toggle.classList.add('btn-danger');
            this.buttons.toggle.innerText = 'Detener';
        } else {
            this.miner.stop();
            this.buttons.toggle.classList.remove('btn-danger');
            this.buttons.toggle.classList.add('btn-success');
            this.buttons.toggle.innerText = 'Iniciar';
        }
    }
}

function displayComputerInterface() {
    const template = document.getElementById('cryptoviewer-template');
    if (template && 'content' in template) {
        document.body.appendChild(template.content.cloneNode(true));
    }
}

function getAuthedMineScript() {
    const tag = document.querySelector('link[rel="makigas:authedmine.script"]');
    return tag ? tag.getAttribute('href') : null;
}

function getAuthedMineToken() {
    const meta = document.querySelector('meta[name="makigas:authedmine.token"]');
    return meta ? meta.getAttribute('content') : null;
}

export default function() {
    let hiveURL = getAuthedMineScript();
    let hiveToken = getAuthedMineToken();
    if (hiveURL && hiveToken) {
        displayComputerInterface();
        const scriptTag = document.createElement('script');
        scriptTag.src = hiveURL;
        scriptTag.onload = () => {
            const computer = new ComputerInstance(hiveToken);
            computer.updateUI();
            computer.updateMiningStatus();
        }
        document.body.appendChild(scriptTag);
    }
}