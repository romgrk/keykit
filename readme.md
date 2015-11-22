
# KeyKit module

Some basic shit to handle KeyEvents, transform keyCodes into chars and stuff like that.
Mind the formulation. This is *not* intended for production use. It is based on
my keyboard, using US(en) and CA(fr) layouts. 
Although, it works great for testing and development.

**Install :** ` npm install keykit `

## Usage
```coffeescript
{KeyKit, KeyStroke, KeyExecuter, KeyCode} = require 'keykit'
# General layout:
# - Key
# - KeyCode: object where indexes matches keycodes (ex.: KeyCode[27] is Esc)
#

###
Key/KeyCode: keycodes and names data
###

Key.code('escape')
# <= 27

Key.name(9)
# <= 'tab'

Key.isMod(18)
# <= true

Key.isMod('shift')
# <= true

Key.SLASH
### <= {
    name: "/"
    code: 191
    printable: true
    visible: true
    char: [ "/", "?" ]
} ###


KeyCode[57]
### <= {
    name: "9"
    sysname: "KEY_9"
    printable: true
    visible: true
    char: [ "9", "(" ]
} ###

###
KeyKit
###

KeyKit.fromKeyStroke('ctrl-alt-x')
KeyKit.fromKBEvent(kbEvent)
KeyKit.fromVim('<C-Esc>')
# <= {KeyStroke}

class KeyStroke
    ctrl:  false || true
    alt:   false || true
    shift: false || true
    meta:  false || true

    name: 'key name'
    char: 'keystroke char if applicable'
    code: 0 # keyCode
    identifier: 'U+0000' || 'name'

```

## Note that you should read before using this anywhere

This is published because I needed a library to test key events across
multiple platforms, quickly; finding no available ressource, I had to write
this. If it can spare you some time, go ahead, use it.
However: 
 - it is not meant for efficiency 
 - no doc
 - not tested on macs
 - don't expect it to be accurate on anything else than US(en) layout keyboard

