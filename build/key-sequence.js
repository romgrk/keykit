// Generated by CoffeeScript 1.8.0
(function() {
  var KeyKit, KeySequence, _,
    __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

  _ = require('underscore-plus');

  KeyKit = require('./keykit');

  module.exports = KeySequence = (function() {
    KeySequence.prototype.keys = null;

    KeySequence.prototype.running = null;

    function KeySequence(sequence) {
      this.handler = __bind(this.handler, this);
      this.keys = KeyKit.getKeySequence(sequence);
      this.running = false;
    }

    KeySequence.prototype.handler = function(event) {
      if (this.running) {
        event.abortKeyBinding();
        return;
      }
      this.running = true;
      event.preventDefault();
      event.stopImmediatePropagation();
      _.each(this.keys, this.trigger.bind(this));
      return this.running = false;
    };

    KeySequence.prototype.trigger = function(key) {
      var canceled, downEvent, _base;
      downEvent = KeyKit.createKBEvent('keydown', key);
      canceled = !this.dispatch(downEvent);
      if (KeyKit.isPrintable(key.code)) {
        this.dispatch(KeyKit.createKBEvent('keypress', key));
      }
      if (!canceled) {
        if (this.dispatch(KeyKit.createTextEvent(key))) {
          if (typeof (_base = document.activeElement).getModel === "function") {
            _base.getModel().insertText(key.char);
          }
        }
      }
      return this.dispatch(KeyKit.createKBEvent('keyup', key));
    };

    KeySequence.prototype.dispatch = function(event) {
      return document.activeElement.dispatchEvent(event);
    };

    return KeySequence;

  })();

}).call(this);