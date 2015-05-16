
# KeyKit module

Some basic shit to handle KeyEvent, transform KeyCodes into chars and stuff like that.

**Install :** ` npm install keykit `

## Usage
```coffeescript
{KeyKit, KeyStroke, KeyExecuter, Key, KeyCode} = require 'keykit'


###
Key/KeyCode
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
