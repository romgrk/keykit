// Generated by CoffeeScript 1.8.0
(function() {
  var Key, KeyCode, KeyKit, KeyStroke, _, _ref;

  _ = require('underscore-plus');

  KeyKit = require('./keykit');

  _ref = require('./keys'), Key = _ref.Key, KeyCode = _ref.KeyCode;

  module.exports = KeyStroke = (function() {
    function KeyStroke(options) {
      var kc, _ref1, _ref2, _ref3, _ref4, _ref5, _ref6, _ref7, _ref8, _ref9;
      if (options == null) {
        options = {};
      }
      this.ctrl = (_ref1 = options.ctrl) != null ? _ref1 : false;
      this.alt = (_ref2 = options.alt) != null ? _ref2 : false;
      this.shift = (_ref3 = options.shift) != null ? _ref3 : false;
      this.meta = (_ref4 = options.meta) != null ? _ref4 : false;
      this.name = (_ref5 = options.name) != null ? _ref5 : null;
      this.identifier = (_ref6 = options.identifier) != null ? _ref6 : null;
      this.code = (_ref7 = (_ref8 = (_ref9 = options.code) != null ? _ref9 : options.keyCode) != null ? _ref8 : options.keycode) != null ? _ref7 : null;
      if (this.code != null) {
        kc = KeyCode[this.code];
        this.name = kc.name;
        if (_.isArray(kc.char)) {
          if (!this.shift) {
            this.char = kc.char[0];
          }
          if (this.shift) {
            this.char = kc.char[1];
          }
        } else {
          this.char = kc.char;
        }
      } else if (this.name != null) {
        this.code = Key.code(this.name);
      }
    }

    KeyStroke.prototype.toString = function() {
      var s, visible;
      visible = KeyCode[this.code].visible;
      if (Key.isMod(this.code)) {
        return this.name;
      } else if (!(this.ctrl || this.alt) && visible) {
        return this.char;
      } else {
        s = "";
        s += (this.ctrl ? "ctrl-" : "");
        s += (this.alt ? "alt-" : "");
        s += (this.shift ? "shift-" : "");
        s += this.name.toLowerCase();
        return s;
      }
    };

    KeyStroke.prototype.vimEscaped = function() {
      var kc, name, s, visible;
      kc = KeyCode[this.code];
      visible = kc.visible;
      if (_.contains([16, 17, 18], this.code)) {
        return '';
      } else if (!(this.ctrl || this.alt) && visible) {
        if (typeof kc.char !== 'string') {
          if (this.char === '<') {
            return '<LT>';
          }
          if (!this.shift) {
            return kc.char[0];
          }
          if (this.shift) {
            return kc.char[1];
          }
        } else {
          return kc.char;
        }
      } else {
        s = "";
        s += (this.ctrl ? "C-" : "");
        s += (this.alt ? "A-" : "");
        s += (this.shift ? "S-" : "");
        name = KeyKit.vimCodeByKeyname[this.name] || this.name.toLowerCase();
        if (name === 'LT') {
          name = '<LT>';
        }
        s += name;
        return "<" + s + ">";
      }
    };

    return KeyStroke;

  })();

}).call(this);
