(function(global) {
  'use strict';
  var GOVUK = global.GOVUK || {};
  var $ = global.jQuery;

  GOVUK.autoSubmitForm = {
    attach: function () {
        var destinationLink = document.getElementById('saml-response-form');
        ga('govuk_shared.linker:decorate', destinationLink);
        $('form.js-auto-submit').submit();
    }
  };

  global.GOVUK = GOVUK;
})(window);
