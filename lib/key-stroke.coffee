
_   = require 'underscore-plus'
kit = require './keykit'

module.exports = class KeyStroke

    ###
    Section: key parsing
    ###

    @parse: (keysym) ->
        kit ?= require './keykit'     # FIXME ... proper loading

        if keysym instanceof KeyStroke
            return keysym

        if kit.isChar keysym
            return @fromChar keysym

        if keysym.match kit.normalKeyStrokeRegex
            return @fromKeyStroke keysym

        if kit.isVimEscaped keysym
            return @fromVim keysym

        return null

    # Public: creates {KeyStroke} from a {string} `c`, where `c.length == 1`
    @fromChar: (c) ->
        kit = require './keykit'
        unless c?
            throw new Error 'No argument'
        unless typeof c is 'string'
            throw new Error('argument is not a string: ' + typeof c)
        unless c.length == 1
            throw new Error 'string exceeds 1 character'

        char = c
        shift = kit.isShifted(c)

        if kit.isAlpha(c)
            name = kit.shift(c)
        else if kit.isVisible(c)
            name = kit.unshift(c)
        else
            name = switch c
                when '\n' then 'enter'
                when '\t' then 'tab'
                when ' ' then 'space'

        code       = kit.keycodeByName[name]
        identifier = kit.unicode(c)

        return new KeyStroke {
            shift: shift, name: name, code:code,
            identifier: identifier, char: char }

    @fromVim: (keysym) ->
        kit = require './keykit'
        return @fromChar(keysym) if kit.isChar(keysym)

        unless kit.isVimEscaped(keysym)
            throw new Error "String doesn't represent a vim-notation. (#{keysym})"

        [mods, vimkey] = keysym.match(kit.vimEscapedRegex)[2..3]
        return null unless vimkey?

        ctrl  = /C-/i.test mods
        alt   = /A-/i.test mods
        shift = /S-/i.test mods
        meta  = /M-/i.test mods

        name = kit.keynameByVimCode[vimkey.toUpperCase()] || vimkey
        if kit.isShifted name
            name = kit.unshift(name)
            shift = true

        code = kit.keycodeByName[name]

        if kit.isChar name
            identifier = kit.unicode(name)
        else
            identifier = name
            char = switch name
                when "enter" then "\n"
                when "space" then " "
                when "tab" then "\t"
                else undefined

        new KeyStroke {
            ctrl: ctrl, alt:alt, shift:shift, meta: meta
            name: name, code: code, identifier: identifier
            , char: char ? null }

    @fromKeyStroke: (keystroke) ->
        kit = require './keykit'
        if keystroke.length == 1
            return @fromChar(keystroke)

        [match, key, mod] = keystroke.match kit.normalKeyStrokeRegex

        if mod?
            mod = 'meta' if mod is 'cmd'
            mod = 'control' if mod is 'ctrl'
            code = kit.key(mod).code
            switch mod
                when 'control'          then ctrl = true
                when 'alt'              then alt = true
                when 'shift'            then shift = true
                when 'meta'             then meta = true

            return new KeyStroke
                identifier: mod
                name:       mod
                ctrl:       ctrl ? false
                alt:        alt ? false
                shift:      shift ? false
                meta:       meta ? false
                code:       code
        else
            ctrl   = keystroke.match(/ctrl-/)?
            alt    = keystroke.match(/alt-/)?
            shift  = keystroke.match(/shift-/)?
            meta   = keystroke.match(/meta-/)? || keystroke.match(/cmd-/)?

            if key.length == 1
                name = kit.unshift(key)
            else
                name = key

            return new KeyStroke
                ctrl:  ctrl
                alt:   alt
                shift: shift
                meta:  meta
                name:  name

    @fromKBEvent: (event) ->
        kit or= require './keykit'
        if event.type == 'keydown' || event.type == 'keyup'
            return new KeyStroke
                code: event.keyCode   || event.which
                ctrl: event.ctrlKey   || false
                alt: event.altKey     || false
                shift: event.shiftKey || false
                meta: event.metaKey   || false
                name: kit.keynameByCode[event.keyCode || event.which]
                identifier: event.keyIdentifier || null
        if event.type == 'keypress'
            ks = @fromChar(String.fromCharCode(event.charCode))
            ks.ctrl = event.ctrlKey
            ks.alt = event.altKey
            ks.meta = event.metaKey
            return ks
        return null

    ###
    Section: instance
    ###

    constructor: (options={}) ->
        kit ?= require './keykit'

        @ctrl  = options.ctrl  ? false
        @alt   = options.alt   ? false
        @shift = options.shift ? false
        @meta  = options.meta  ? false
        @cmd   = options.cmd   ? false

        @name       = options.name ? null
        @char       = options.char ? null
        @identifier = options.identifier ? null

        @code       = options.code ? options.keyCode ? options.keycode ? null

        if @code?
            key = kit.findByCode(@code)
            @name = key.name
        else if @name?
            key = kit.findByName(@name)
            @code = key.code
        else
            throw new Error "Keycode or name needed"

        unless @char?
            if _.isArray key.char
                @char = key.char[0] if !@shift
                @char = key.char[1] if @shift
            else
                @char = key.char

    toString: ->
        visible = kit.keysByCode[@code].visible
        if kit.isModifier(@code)
            @name
        else if !(@ctrl || @alt) && visible
            @char
        else
            s = ""
            s += (if @ctrl then "ctrl-" else "")
            s += (if @alt then "alt-" else "")
            s += (if @shift then "shift-" else "")
            s += (if @meta then "meta-" else "")
            s += @name.toLowerCase()
            return s

    # Public: returns a vim-notation {String}
    vimEscaped: ->
        kc      = kit.keysByCode[@code]
        visible = kc.visible

        if kit.isModifier @code
            return ''

        if !(@ctrl || @alt) && visible
            if typeof kc.char isnt 'string'
                return '<LT>' if @char is '<'
                return kc.char[0] unless @shift
                return kc.char[1] if @shift
            else
                return kc.char
        else
            s = ""
            s += (if @ctrl then "C-" else "")
            s += (if @alt then "A-" else "")
            s += (if @shift then "S-" else "")
            s += (if @meta then "M-" else "")

            name = kit.vimCodeByKeyname[@name] || @name.toLowerCase()
            if name is 'LT' then name = '<LT>'
            s += name

            return "<#{s}>"
