console.debug = console.log

_ = require 'underscore-plus'

KeyStroke      = require './key-stroke'
KeyExecuter    = require './key-executer'
{Key, KeyCode} = require './key-code'

KeyKit =

    keynameByVimCode:
        'BS': 'backspace', 'TAB': 'tab', 'CR': 'enter', 'ESC': 'escape',
        'SPACE': 'space', 'END': 'end', 'HOME': 'home', 'UP': 'up',
        'DOWN': 'down', 'RIGHT': 'right', 'LEFT': 'left', 'DEL': 'delete',
        'BAR': '|', 'LT': '<', '<LT>': '<',
        'F1': 'f1',  'F2': 'f2',  'F3': 'f3',  'F4': 'f4',  'F5': 'f5',
        'F6': 'f6',  'F7': 'f7',  'F8': 'f8',  'F9': 'f9',  'F10': 'f10',
        'F11': 'f11',  'F12': 'f12',  'F13': 'f13',  'F14': 'f14',
        'F15': 'f15',  'F16': 'f16',  'F17': 'f17',  'F18': 'f18',
        'F19': 'f19',  'F20': 'f20',  'F21': 'f21',  'F22': 'f22',
        'F23': 'f23',  'F24': 'f24'
        # not official
        'CTRL': 'ctrl', 'ALT': 'alt', 'SHIFT': 'shift'

    vimCodeByKeyname:
        backspace: "BS", tab: "TAB", return: "CR", enter: "CR", escape: "ESC",
        space: "SPACE", end: "END", home: "HOME", up: "UP", down: "DOWN",
        right: "RIGHT", left: "LEFT", delete: "DEL", "|": "BAR", "<": "LT",
        f1: "F1", f2: "F2", f3: "F3", f4: "F4", f5: "F5", f6: "F6", f7: "F7",
        f8: "F8", f9: "F9", f10: "F10", f11: "F11", f12: "F12", f13: "F13",
        f14: "F14", f15: "F15", f16: "F16", f17: "F17", f18: "F18", f19: "F19",
        f20: "F20", f21: "F21", f22: "F22", f23: "F23", f24: "F24",
        ctrl: "CTRL", alt: "ALT", shift: "SHIFT", altgr: "ALTGR"

    normalKeyStrokeRegex: ///
        ^(
            control|alt|shift
        )|(?:
            (ctrl-)?
            (alt-)?
            (shift-)?
            (
                .| enter|space|backspace|delete|tab|escape
                |pageup|pagedown|home|end|left|right|up|down|f\d{1,2} )
        )
        $

        ///

    vimEscapedRegex: ///
        <(
        (?:
            (
                (?:[CSAM]-)+
            )?

            (BS|TAB|CR|ESC|SPACE|PAGEUP|
            PAGEDOWN|END|HOME|LEFT|UP|
            RIGHT|DOWN|DEL|BAR|F\d{1,2}|<LT>|.)
        )
        | LT
        )>
        ///i

    vimSequenceRegex: ///
        ([^<]|<(
        (?:
            ( (?:[CSAM]-)+ )?
            (BS|TAB|CR|ESC|SPACE|PAGEUP|
            PAGEDOWN|END|HOME|LEFT|UP|
            RIGHT|DOWN|DEL|BAR|F\d{1,2}|<LT>|.)
        )
        | LT )>)
        ///gi

    ###
    Section: helpers
    ###

    getChar: (key) ->
        return null unless @isPrintable key.code
        char = @keycharByCode[key.code]
        char = @shift char if key.shift
        return char

    isAlpha: (c) ->
        return /a-zA-Z/.test c

    unshift: (c) ->
        return c.toLowerCase() if @isUpperCase c
        return @shiftedToUnshifted[c] if @isShifted c
        return c

    shift: (c) ->
        return c.toUpperCase()  if @isLowerCase c
        return @unshiftedToShifted[c] unless @isShifted c
        return c

    unicode: (c) ->
        code = c.toLowerCase().charCodeAt(0).toString(16)
        return switch code.length
            when 1 then "U+000#{code}"
            when 2 then "U+00#{code}"
            when 3 then "U+0#{code}"
            when 4 then "U+#{code}"
            else
                console.warn "Unicode: ", code
                "U+#{code}"

    isShifted: (c) ->
        return true if @shiftedToUnshifted[c]?
        return true if @isUpperCase(c)
        return false

    isLowerCase: (c) ->
        not /[^a-z]/.test c

    isUpperCase: (c) ->
        not /[^A-Z]/.test c

    isChar: (c) ->
        c.length == 1

    isPrintable: (arg) ->
        if typeof arg == "string"
            return not _.contains @nonPrintableNames, arg
        else
            return not _.contains @nonPrintableCodes, arg

    isVisible: (c) ->
        return false unless c?
        /[^\s]/.test c

    ###
    Section: key parsing
    ###

    fromChar: (c) ->
        unless c?
            console.error new Error 'no argument'
        unless typeof c is 'string'
            console.error new Error('argument is not a string: ' + typeof c)

        return null if c.length != 1
        char = c

        shift = @isShifted(c)
        if @isAlpha(c)
            name = @shift(c)
        else if @isVisible(c)
            name = @unshift(c)
        else
            name = switch c
                when '\n' then 'enter'
                when '\t' then 'tab'
                when ' ' then 'space'
            return null unless name?
            char = c
        code       = @keycodeByName[name]
        identifier = @unicode(c)

        return new KeyStroke {
            shift: shift, name: name, code:code,
            identifier: identifier, char: char }

    fromVim: (keysym) ->
        return @fromChar(keysym) if @isChar(keysym)
        return null unless @isVimEscaped(keysym)

        [mods, vimkey] = keysym.match(@vimEscapedRegex)[2..3]
        return null unless vimkey?

        ctrl  = /C-/i.test mods
        alt   = /A-/i.test mods
        shift = /S-/i.test mods
        meta  = /M-/i.test mods

        name = @keynameByVimCode[vimkey.toUpperCase()] || vimkey
        if @isShifted name
            name = @unshift(name)
            shift = true

        code = @keycodeByName[name]

        if @isChar name
            identifier = @unicode(name)
            # char = @getChar name
        else
            identifier = name
            # char = switch name
            #     when "enter" then "\n"
            #     when "space" then " "
            #     when "tab" then "\t"
            #     else undefined

        new KeyStroke {
            ctrl: ctrl, alt:alt, shift:shift, meta: meta
            name: name, code: code, identifier: identifier }
            # , char: char }

    fromKeyStroke: (keystroke) ->
        console.debug keystroke
        console.debug keystroke.match @normalKeyStrokeRegex
        [match, mod, ctrl, alt, shift, key] = keystroke.match @normalKeyStrokeRegex
        if mod?
            console.debug mod
        else
            if key.length == 1
                name = KeyKit.unshift(key)
            else
                name = key
            console.debug name

        #
        # console.debug match
        # console.debug name
        # new KeyStroke {
        #     ctrl: ctrl
        #     alt: alt
        #     shift: shift
        #     name: name
        # }


    fromKBEvent: (event) ->
        new KeyStroke {
            code: event.keyCode || event.which
            ctrl: event.ctrlKey || false
            alt: event.altKey || false
            shift: event.shiftKey || false
            name: @keynameByCode[event.keyCode || event.which]
            identifier: event.keyIdentifier || null
        }

    isVimEscaped: (k) ->
        return @vimEscapedRegex.test k

    getVisibleRepresentation: (c) ->
        return switch c
            when '\n' then '\\n'
            when ' ' then '\\s'
            when '\t' then '\\t'
            else c

    getNormalizedKey: (key) ->
        unless key instanceof KeyStroke
            key = @resolveKey key

        normalizedKey = ""
        normalizedKey += "ctrl-" if key.ctrl
        normalizedKey += "alt-" if key.alt
        if @isVisible key.char
            normalizedKey += key.char
        else
            normalizedKey += "shift-" if key.shift
            normalizedKey += key.name

        return normalizedKey

    getNormalizedKeybinding: (sequence) ->
        keys = @splitVimTokens sequence
        keys = _.map keys, (k) => @getNormalizedKey k
        return keys.join " "

    splitVimTokens: (sequence) ->
        matches = sequence.match @vimSequenceRegex

    resolveKey: (keysym) ->
        if @isChar keysym
            return @fromChar keysym
        if @isVimEscaped keysym
            return @fromVim keysym
        console.error "KeyKit: couldn't resolve key (#{keysym})"
        return null

    trigger: (key) ->
        unless key instanceof KeyStroke
            key = @resolveKey(key)
        return unless key?

        downEvent = @createKBEvent('keydown', key)
        canceled = !@dispatch downEvent
        console.log 'down: ', !canceled
        console.log downEvent

        if @isPrintable key.code
            console.log 'press: ', @dispatch @createKBEvent('keypress', key)

        unless canceled
            if @dispatch @createTextEvent(key)
                console.log "textInput: #{key.char}"
                console.log document.activeElement.getModel?().insertText key.char

        console.log 'up: ', @dispatch @createKBEvent('keyup', key)

    createKBEvent: (type, key) ->
        e = document.createEvent('KeyboardEvent')
        args = [true, # bubbles
                true, # cancelable
                null, # view
                key.identifier,
                0,    # location
                key.ctrl, key.alt, key.shift, key.meta]

        e.initKeyboardEvent(type, args...)
        Object.defineProperty(e, 'keykit', get: -> true)

        unless type is 'keypress'
            Object.defineProperty(e, 'keyCode', get: -> @_keyCode)
        else
            Object.defineProperty(e, 'keyCode', get: -> @_keyChar.charCodeAt(0))
            Object.defineProperty(e, 'charCode', get: -> @_keyChar.charCodeAt(0))

        Object.defineProperty(e, 'which',           get: -> @_keyCode)
        Object.defineProperty(e, 'keyIdentifier',   get: -> @_keyIdentifier)

        e._keyIdentifier = key.identifier
        e._keyCode       = key.code
        e._keyChar       = key.char
        e._name          = key.name

        e.target = document.activeElement

        return e

    createTextEvent: (key) ->
        e = document.createEvent('TextEvent')
        e.initTextEvent(
            'textInput', true, true, # (name, bubbles, cancelable
            document.activeElement, key.char) # view, data)

        Object.defineProperty(e, 'keyCode', get: -> @_keyCode)
        Object.defineProperty(e, 'which', get: -> @_keyCode)

        e._keyCode = key.code

        return e

    dispatch: (event) ->
        document.activeElement.dispatchEvent event

    executeSequence: (sequence) ->
        @trigger k for k in @splitVimTokens sequence

    executeKeys: (keys) ->
        @trigger k for k in keys

    getKeyExec: (sequence) ->
        keyExecuter = new KeyExecuter sequence
        return keyExecuter.handler

    getKeySequence: (sequence) ->
        keys = @splitVimTokens sequence
        return  _.map keys, (k) => @resolveKey k

    createKeyExecuter: (sequence) ->
        keyExecuter = new KeyExecuter sequence
        return keyExecuter



# for k, v of KeyKit.keynameByVimCode
    # vimCodeByName[v] = k
# console.log KeyKit.vimCodeByKeyname

# obj = {true: 'a', false: 'b'}
# console.debug obj[true]

# for keycode, keyname of KeyKit.keynameByCode
    # console.debug keycode, ':', keyname

# keyCode
# idx:int           keycode
#   name:String
#   char:String     produced char, if applicable
#
# console.debug '#########'
# test(c) for c in 'aA1!,< '.split('')

module.exports = {KeyKit, KeyStroke, KeyExecuter, Key, KeyCode}
