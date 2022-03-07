// TODO: Finish the migration to makigas v6 so that I can stop using jQuery!
import jquery from 'jquery';
window.$ = jquery;
window.jQuery = jquery;

// using require seems to be the only way to import bootstrap without having
// jQuery fail. I need to migrate to makigas v6 to remove bootstrap 3 as soon
// as possible!!!
require('bootstrap/dist/js/bootstrap.min');

import 'cookieconsent';

import Rails from '@rails/ujs';
Rails.start()

import 'bootstrap/dist/css/bootstrap.min.css';
import 'cookieconsent/build/cookieconsent.min.css';

