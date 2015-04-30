
# KeyKit = require './keykit'
# {Key, KeyCode, KeyStroke} = KeyKit
KeyStroke = require './key-stroke'

key = new KeyStroke {shift: true, code: 65, keyCode: 9, keycode: 13}
console.log key.vimEscaped()
