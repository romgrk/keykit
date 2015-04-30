
# KeyKit = require './keykit'
# {Key, KeyCode, KeyStroke} = KeyKit
KeyStroke = require './key-stroke'

key = new KeyStroke {keyCode: 13}
console.log key.vimEscaped()
