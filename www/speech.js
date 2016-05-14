var exec = require('cordova/exec');

var speech = function () {

  this.events = {};
};

speech.prototype = {

  play   : function (message) {
    var self = this;
    var cb = function (info) {
      if (self.events.hasOwnProperty(info.event)) {
        self.events[info.event]();
      }
    };
    exec(cb, cb, "Speech", "play", [message]);
  },
  cancel : function () {
    exec(null, null, "Speech", "cancel", []);
  },
  onStart: function (fn) {
    if (typeof fn === 'function') {
      this.events.onStart = fn;
    }
  },
  onStop : function (fn) {
    if (typeof fn === 'function') {
      this.events.onStop = fn;
    }
  }
};

module.exports = new speech();
