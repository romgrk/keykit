// Generated by CoffeeScript 1.10.0
(function() {
  var KeyKit, KeyStroke, _,
    slice = [].slice;

  _ = require('underscore-plus');

  KeyStroke = require('./key-stroke');

  module.exports = KeyKit = {

    /*
    Data
     */
    keysByCode: require('./key-codes'),
    keysBySysname: require('./key-sysnames'),
    nonPrintableCodes: [16, 17, 18, 224, 225, 8, 27, 33, 34, 35, 36, 37, 39, 40, 45, 46, 112, 113, 114, 115, 116, 117, 118, 119, 120, 121, 122, 123, 124, 125, 126, 127, 128, 130, 131, 132, 133, 134, 135, 3, 6, 12, 19, 20, 22, 23, 24, 25, 28, 29, 30, 31, 41, 42, 43, 44, 95, 144, 145, 181, 182, 183, 246, 247, 248, 249, 250, 251, 253, 224, 225, 93, 38, 21, 129],
    nonPrintableNames: ["shift", "control", "alt", "meta", "altgr", "cmd", "backspace", "escape", "pageup", "pagedown", "end", "home", "left", "up", "right", "down", "insert", "delete", "f1", "f2", "f3", "f4", "f5", "f6", "f7", "f8", "f9", "f10", "f11", "f12", "f13", "f14", "f15", "f16", "f17", "f18", "f19", "f20", "f21", "f22", "f23", "f24"],
    shiftedToUnshifted: {
      "~": "`",
      "!": "1",
      "@": "2",
      "#": "3",
      "$": "4",
      "%": "5",
      "^": "6",
      "&": "7",
      "*": "8",
      "(": "9",
      ")": "0",
      "_": "-",
      "+": "=",
      "{": "[",
      "}": "]",
      ":": ";",
      "\"": "'",
      "|": "\\",
      "<": ",",
      ">": ".",
      "?": "/"
    },
    unshiftedToShifted: {
      '`': '~',
      '1': '!',
      '2': '@',
      '3': '#',
      '4': '$',
      '5': '%',
      '6': '^',
      '7': '&',
      '8': '*',
      '9': '(',
      '0': ')',
      '-': '_',
      '=': '+',
      '[': '{',
      ']': '}',
      ';': ':',
      '\'': '"',
      '\\': '|',
      ',': '<',
      '.': '>',
      '/': '?'
    },
    keycodeByName: {
      "backspace": 8,
      "tab": 9,
      "enter": 13,
      "return": 14,
      "shift": 16,
      "control": 17,
      "alt": 18,
      "escape": 27,
      "space": 32,
      "pageup": 33,
      "pagedown": 34,
      "end": 35,
      "home": 36,
      "left": 37,
      "up": 38,
      "right": 39,
      "down": 40,
      "insert": 45,
      "delete": 46,
      "0": 48,
      "1": 49,
      "2": 50,
      "3": 51,
      "4": 52,
      "5": 53,
      "6": 54,
      "7": 55,
      "8": 56,
      "9": 57,
      "A": 65,
      "B": 66,
      "C": 67,
      "D": 68,
      "E": 69,
      "F": 70,
      "G": 71,
      "H": 72,
      "I": 73,
      "J": 74,
      "K": 75,
      "L": 76,
      "M": 77,
      "N": 78,
      "O": 79,
      "P": 80,
      "Q": 81,
      "R": 82,
      "S": 83,
      "T": 84,
      "U": 85,
      "V": 86,
      "W": 87,
      "X": 88,
      "Y": 89,
      "Z": 90,
      "a": 65,
      "b": 66,
      "c": 67,
      "d": 68,
      "e": 69,
      "f": 70,
      "g": 71,
      "h": 72,
      "i": 73,
      "j": 74,
      "k": 75,
      "l": 76,
      "m": 77,
      "n": 78,
      "o": 79,
      "p": 80,
      "q": 81,
      "r": 82,
      "s": 83,
      "t": 84,
      "u": 85,
      "v": 86,
      "w": 87,
      "x": 88,
      "y": 89,
      "z": 90,
      "f1": 112,
      "f2": 113,
      "f3": 114,
      "f4": 115,
      "f5": 116,
      "f6": 117,
      "f7": 118,
      "f8": 119,
      "f9": 120,
      "f10": 121,
      "f11": 122,
      "f12": 123,
      "f13": 124,
      "f14": 125,
      "f15": 126,
      "f16": 127,
      "f17": 128,
      "f18": 129,
      "f19": 130,
      "f20": 131,
      "f21": 132,
      "f22": 133,
      "f23": 134,
      "f24": 135,
      ";": 186,
      "=": 187,
      ",": 188,
      "-": 189,
      ".": 190,
      "/": 191,
      "`": 192,
      "[": 219,
      "\\": 220,
      "]": 221,
      "'": 222,
      "meta": 224,
      "altgr": 225
    },
    keynameByCode: {
      16: "shift",
      17: "control",
      18: "alt",
      224: "meta",
      225: "altgr",
      8: "backspace",
      9: "tab",
      13: "enter",
      14: "return",
      27: "escape",
      32: "space",
      33: "pageup",
      34: "pagedown",
      35: "end",
      36: "home",
      37: "left",
      38: "up",
      39: "right",
      40: "down",
      45: "insert",
      46: "delete",
      224: "meta",
      225: "altgr",
      12: "clear",
      160: "^",
      161: "!",
      162: '"',
      163: '#',
      164: "$",
      165: "%",
      166: "&",
      167: "_",
      168: "(",
      169: ")",
      170: "*",
      171: "+",
      172: "|",
      173: "-",
      174: "{",
      175: "}",
      176: "~",
      58: ":",
      59: ";",
      60: "<",
      61: "=",
      62: ">",
      63: "?",
      64: "@",
      96: "NUMPAD0",
      97: "NUMPAD1",
      98: "NUMPAD2",
      99: "NUMPAD3",
      100: "NUMPAD4",
      101: "NUMPAD5",
      102: "NUMPAD6",
      103: "NUMPAD7",
      104: "NUMPAD8",
      105: "NUMPAD9",
      106: "*",
      107: "+",
      108: "SEPARATOR",
      109: "-",
      110: ".",
      111: "/",
      112: "f1",
      113: "f2",
      114: "f3",
      115: "f4",
      116: "f5",
      117: "f6",
      118: "f7",
      119: "f8",
      120: "f9",
      121: "f10",
      122: "f11",
      123: "f12",
      124: "f13",
      125: "f14",
      126: "f15",
      127: "f16",
      128: "f17",
      129: "f18",
      130: "f19",
      131: "f20",
      132: "f21",
      133: "f22",
      134: "f23",
      135: "f24",
      48: "0",
      49: "1",
      50: "2",
      51: "3",
      52: "4",
      53: "5",
      54: "6",
      55: "7",
      56: "8",
      57: "9",
      65: "A",
      66: "B",
      67: "C",
      68: "D",
      69: "E",
      70: "F",
      71: "G",
      72: "H",
      73: "I",
      74: "J",
      75: "K",
      76: "L",
      77: "M",
      78: "N",
      79: "O",
      80: "P",
      81: "Q",
      82: "R",
      83: "S",
      84: "T",
      85: "U",
      86: "V",
      87: "W",
      88: "X",
      89: "Y",
      90: "Z",
      186: ";",
      187: "=",
      188: ",",
      189: "-",
      190: ".",
      191: "/",
      192: "`",
      219: "[",
      220: "\\",
      221: "]",
      222: "'"
    },
    keycharByCode: {
      9: "\t",
      13: "\n",
      32: " ",
      48: "0",
      49: "1",
      50: "2",
      51: "3",
      52: "4",
      53: "5",
      54: "6",
      55: "7",
      56: "8",
      57: "9",
      65: "a",
      66: "b",
      67: "c",
      68: "d",
      69: "e",
      70: "f",
      71: "g",
      72: "h",
      73: "i",
      74: "j",
      75: "k",
      76: "l",
      77: "m",
      78: "n",
      79: "o",
      80: "p",
      81: "q",
      82: "r",
      83: "s",
      84: "t",
      85: "u",
      86: "v",
      87: "w",
      88: "x",
      89: "y",
      90: "z",
      186: ";",
      187: "=",
      188: ",",
      189: "-",
      190: ".",
      191: "/",
      192: "`",
      219: "[",
      220: "\\",
      221: "]",
      222: "'"
    },
    keynameByVimCode: {
      'BS': 'backspace',
      'TAB': 'tab',
      'CR': 'enter',
      'ESC': 'escape',
      'SPACE': 'space',
      'END': 'end',
      'HOME': 'home',
      'UP': 'up',
      'DOWN': 'down',
      'RIGHT': 'right',
      'LEFT': 'left',
      'DEL': 'delete',
      'BAR': '|',
      'LT': '<',
      '<LT>': '<',
      'F1': 'f1',
      'F2': 'f2',
      'F3': 'f3',
      'F4': 'f4',
      'F5': 'f5',
      'F6': 'f6',
      'F7': 'f7',
      'F8': 'f8',
      'F9': 'f9',
      'F10': 'f10',
      'F11': 'f11',
      'F12': 'f12',
      'F13': 'f13',
      'F14': 'f14',
      'F15': 'f15',
      'F16': 'f16',
      'F17': 'f17',
      'F18': 'f18',
      'F19': 'f19',
      'F20': 'f20',
      'F21': 'f21',
      'F22': 'f22',
      'F23': 'f23',
      'F24': 'f24',
      'CTRL': 'ctrl',
      'ALT': 'alt',
      'SHIFT': 'shift'
    },
    vimCodeByKeyname: {
      backspace: "BS",
      tab: "TAB",
      "return": "CR",
      enter: "CR",
      escape: "ESC",
      space: "SPACE",
      end: "END",
      home: "HOME",
      up: "UP",
      down: "DOWN",
      right: "RIGHT",
      left: "LEFT",
      "delete": "DEL",
      "|": "BAR",
      "<": "LT",
      f1: "F1",
      f2: "F2",
      f3: "F3",
      f4: "F4",
      f5: "F5",
      f6: "F6",
      f7: "F7",
      f8: "F8",
      f9: "F9",
      f10: "F10",
      f11: "F11",
      f12: "F12",
      f13: "F13",
      f14: "F14",
      f15: "F15",
      f16: "F16",
      f17: "F17",
      f18: "F18",
      f19: "F19",
      f20: "F20",
      f21: "F21",
      f22: "F22",
      f23: "F23",
      f24: "F24",
      ctrl: "CTRL",
      alt: "ALT",
      shift: "SHIFT",
      altgr: "ALTGR"
    },
    normalKeyStrokeRegex: /^(?:(?:(?:(?:ctrl|alt|shift|meta|cmd)-)*(.|enter|space|backspace|delete|tab|escape|pageup|pagedown|home|end|left|right|up|down|insert|f\d{1,2}))|(control|ctrl|alt|shift|meta|cmd))$/,
    vimEscapedRegex: /<((?:((?:[CSAM]-)+)?(BS|TAB|CR|ESC|SPACE|PAGEUP|PAGEDOWN|END|HOME|LEFT|UP|RIGHT|DOWN|DEL|BAR|F\d{1,2}|<LT>|.))|LT)>/i,
    vimSequenceRegex: /([^<]|<((?:((?:[CSAM]-)+)?(BS|TAB|CR|ESC|SPACE|PAGEUP|PAGEDOWN|END|HOME|LEFT|UP|RIGHT|DOWN|DEL|BAR|F\d{1,2}|<LT>|.))|LT)>)/gi,
    findByName: function(name) {
      var data, key, ref;
      if (this.keysBySysname[name] != null) {
        return this.keysBySysname[name];
      }
      ref = this.keysBySysname;
      for (key in ref) {
        data = ref[key];
        if (data.name === name.toLowerCase()) {
          return data;
        }
      }
      return null;
    },
    findByCode: function(code) {
      if (this.keysByCode[code] != null) {
        return this.keysByCode[code];
      }
      return null;
    },
    code: function(name) {
      return this.findByName(name).code;
    },
    name: function(code) {
      return this.findByCode(code).name;
    },
    key: function(key) {
      if (typeof key === 'string') {
        return this.findByName(key);
      } else {
        return this.findByCode(key);
      }
    },
    isModifier: function(arg) {
      var isMod;
      isMod = false;
      if (typeof arg === 'string') {
        isMod |= arg === 'ctrl' || arg === 'alt';
        isMod |= arg === 'shift' || arg === 'cmd' || arg === 'meta';
      } else {
        isMod = _.contains([16, 17, 18, 224], arg);
      }
      return isMod;
    },
    isMod: function(arg) {
      return this.isModifier(arg);
    },

    /*
    Section: char-helpers
     */
    isAlpha: function(c) {
      return /a-zA-Z/.test(c);
    },
    unshift: function(c) {
      if (this.isUpperCase(c)) {
        return c.toLowerCase();
      }
      if (this.isShifted(c)) {
        return this.shiftedToUnshifted[c];
      }
      return c;
    },
    shift: function(c) {
      if (this.isLowerCase(c)) {
        return c.toUpperCase();
      }
      if (!this.isShifted(c)) {
        return this.unshiftedToShifted[c];
      }
      return c;
    },
    unicode: function(c) {
      var code;
      code = c.toLowerCase().charCodeAt(0).toString(16);
      switch (code.length) {
        case 1:
          return "U+000" + code;
        case 2:
          return "U+00" + code;
        case 3:
          return "U+0" + code;
        case 4:
          return "U+" + code;
        default:
          console.warn("Unicode: ", code);
          return "U+" + code;
      }
    },
    isShifted: function(c) {
      if (this.shiftedToUnshifted[c] != null) {
        return true;
      }
      if (this.isUpperCase(c)) {
        return true;
      }
      return false;
    },
    isLowerCase: function(c) {
      return !/[^a-z]/.test(c);
    },
    isUpperCase: function(c) {
      return !/[^A-Z]/.test(c);
    },
    isChar: function(c) {
      return c.length === 1 && typeof c === 'string';
    },
    isPrintable: function(arg) {
      if (typeof arg === "string") {
        return !_.contains(this.nonPrintableNames, arg);
      } else {
        return !_.contains(this.nonPrintableCodes, arg);
      }
    },
    isVisible: function(c) {
      if (c == null) {
        return false;
      }
      return /[^\s]/.test(c);
    },

    /*
    Section: key parsing
     */
    isVimEscaped: function(k) {
      return this.vimEscapedRegex.test(k);
    },
    getVisibleRepresentation: function(c) {
      switch (c) {
        case '\n':
          return '\\n';
        case ' ':
          return '\\s';
        case '\t':
          return '\\t';
        default:
          return c;
      }
    },
    getNormalizedKey: function(key) {
      var normalizedKey;
      key = require('./key-stroke').parse(key);
      normalizedKey = "";
      if (key.ctrl) {
        normalizedKey += "ctrl-";
      }
      if (key.alt) {
        normalizedKey += "alt-";
      }
      if (this.isVisible(key.char)) {
        normalizedKey += key.char;
      } else {
        if (key.shift) {
          normalizedKey += "shift-";
        }
        normalizedKey += key.name;
      }
      return normalizedKey;
    },
    getNormalizedKeybinding: function(sequence) {
      var keys;
      keys = this.splitVimTokens(sequence);
      keys = _.map(keys, (function(_this) {
        return function(k) {
          return _this.getNormalizedKey(k);
        };
      })(this));
      return keys.join(" ");
    },
    splitVimTokens: function(sequence) {
      var matches;
      return matches = sequence.match(this.vimSequenceRegex);
    },

    /*
    Section: events/actions
     */
    createKBEvent: function(type, keysym, target, options) {
      var args, e, key;
      if (options == null) {
        options = {};
      }
      key = require('./key-stroke').parse(keysym);
      if (!((key != null) && key instanceof KeyStroke)) {
        throw new Error("`keysym` couldnt be resolved. (" + keysym + ")");
      }
      e = document.createEvent('KeyboardEvent');
      args = [true, true, null, key.identifier, 0, key.ctrl, key.alt, key.shift, key.meta];
      e.initKeyboardEvent.apply(e, [type].concat(slice.call(args)));
      e._keyIdentifier = key.identifier;
      e._keyCode = key.code;
      e._keyChar = key.char;
      e._name = key.name;
      if (type !== 'keypress') {
        Object.defineProperty(e, 'keyCode', {
          get: function() {
            return this._keyCode;
          }
        });
      } else {
        Object.defineProperty(e, 'keyCode', {
          get: function() {
            return this._keyChar.charCodeAt(0);
          }
        });
        Object.defineProperty(e, 'charCode', {
          get: function() {
            return this._keyChar.charCodeAt(0);
          }
        });
      }
      Object.defineProperty(e, 'which', {
        get: function() {
          return this._keyCode;
        }
      });
      Object.defineProperty(e, 'keyIdentifier', {
        get: function() {
          return this._keyIdentifier;
        }
      });
      Object.defineProperty(e, 'keykit', {
        get: function() {
          return true;
        }
      });
      e.target = target != null ? target : document.activeElement;
      return e;
    },
    createTextEvent: function(key) {
      var e;
      e = document.createEvent('TextEvent');
      e.initTextEvent('textInput', true, true, null, key.char);
      e._keyCode = key.code;
      Object.defineProperty(e, 'keyCode', {
        get: function() {
          return this._keyCode;
        }
      });
      Object.defineProperty(e, 'which', {
        get: function() {
          return this._keyCode;
        }
      });
      return e;
    },
    dispatch: function(event) {
      return document.activeElement.dispatchEvent(event);
    },
    executeSequence: function(sequence) {
      var i, k, len, ref, results;
      ref = this.splitVimTokens(sequence);
      results = [];
      for (i = 0, len = ref.length; i < len; i++) {
        k = ref[i];
        results.push(this.trigger(k));
      }
      return results;
    },
    executeKeys: function(keys) {
      var i, k, len, results;
      results = [];
      for (i = 0, len = keys.length; i < len; i++) {
        k = keys[i];
        results.push(this.trigger(k));
      }
      return results;
    },
    getKeystrokes: function(sequence) {
      var keys;
      keys = this.splitVimTokens(sequence);
      return _.map(keys, function(k) {
        return require('./key-stroke').parse(k);
      });
    }
  };

}).call(this);
