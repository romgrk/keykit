
# KeyKit module

Some basic shit to handle KeyEvents, transform keyCodes into chars and stuff like that.
Mind the formulation. This is *not* intended for production use. It is based on
my keyboard, using US(en) and CA(fr) layouts. 
Although, it works great for testing and development.

It can:
 - parse a keystroke from text/kbEvent and return a model
 - retrieve keyCodes/names/properties
 - execute a sequence of keys

**Install :** ` npm install keykit `

## Usage
```coffeescript
{KeyKit, KeyStroke, KeySequence, KeyCode} = require 'keykit'
# KeyKit == KeyKit.Key == KeyKit.Kit

# General layout:
# - Key (or KeyKit):  General utilities; key data, kbEvent handling, ...
#                           .code(string) return key name
#                           .name(number) return key code
#                           .key(string || number) returns key data
# - KeyCode:          Object where indexes match keycodes (ex.: KeyCode[27] is Escape)
# - KeyStroke:        Keystroke model. Pretty straight-forward, see definition
#                     below. No cmd key handling, even if the field is present.
# - KeySequence:      Ok. This one is not my greatest work, but it is meant to
#                     represent a sequence of keystrokes in general. For
#                     example:
#                               ctrl-x, ctrl-v, h, e, l, l, o
#
#                     will be represented as an array of [KeyStrokes] under the
#                     'keys' property. 
#                     The interesting part is that it can execute the given
#                     sequence of keys, as if the user was typing it.

###
KeyKit/KeyCode: keycodes and names data
###

KeyKit.code('escape')
# <= 27

KeyKit.name(9)
# <= 'tab'

KeyKit.isMod(18)
# <= true

KeyKit.isMod('shift')
# <= true

KeyKit.key('SLASH') == KeyKit.key(191)
### <= {
    name: "/"
    code: 191
    printable: true
    visible: true
    char: [ "/", "?" ]
} however, != from ###
KeyKit.key '/'
### <= {
    name: "/"
    code: 111
    printable: true
    visible: true
    char: [ "/", "?" ]
} (Note the code. KEYPAD_SLASH != SLASH_QUESTION_KEY)
### 

KeyCode[57]
### <= {
    name: "9"
    sysname: "KEY_9"
    printable: true
    visible: true
    char: [ "9", "(" ]
} ###

###
KeyStroke model
###

# Parsing text representations of keystrokes:
# all of these (normally) return the same object
KeyStroke.fromKeyStroke('ctrl-alt-x')
KeyStroke.fromKBEvent(kbEvent)
KeyStroke.fromVim('<C-A-x>')
KeyStroke.fromVim('<C-M-x>')
# <= {KeyStroke}

class KeyStroke
    ctrl:  false || true
    alt:   false || true
    shift: false || true
    meta:  false || true
    cmd:   false || true

    name: 'space'                       # name, as usually returned by kbEvents
    char: ' '                           # char  OR  [unshiftedChar, shiftedChar]
    code: 20                            # kbEvent.keyCode
    identifier: 'U+0000' || 'space'     # if there is a key name, uses it.

# see also
# KeyStroke.fromChar(string)    where string.length == 1
# KeyStroke.parse(string)       which does magic and returns the appropriate
#                               model no matter the input format

###
KeySequence: 
 - constructor takes any KeyStroke.parse parsable string 
 - stores (and replays) a keystroke sequence
###

seq = KeySequence 'hello'
seq.execute()
# triggers 'h', 'e', 'l', 'l', 'o' on document.activeElement

seq = KeySequence 'ggVG<C-x>'
# ...

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

