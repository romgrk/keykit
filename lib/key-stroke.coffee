
_ = require 'underscore-plus'

KeyKit         = require './keykit'
{Key, KeyCode} = require './key-code'

module.exports =
class KeyStroke

    constructor: (options={}) ->
        @ctrl       = options.ctrl ? false
        @alt        = options.alt ? false
        @shift      = options.shift ? false
        @meta       = options.meta ? false

        @name       = options.name ? null
        @identifier = options.identifier ? null

        @code       = options.code ? options.keyCode ? options.keycode ? null
        if @code?
            kc = KeyCode[@code]
            @name = kc.name
            if _.isArray kc.char
                @char = kc.char[0] if !@shift
                @char = kc.char[1] if @shift
            else
                @char = kc.char
        else if @name?
            @code = Key.code(@name)

        # @name ?= KeyKit.keynameByCode[@code]
        # @char       = options.char ? KeyKit.getChar @


    toString: ->
        visible = KeyCode[@code].visible
        if Key.isMod(@code)
            @name
        else if !(@ctrl || @alt) && visible
            @char
        else
            s = ""
            s += (if @ctrl then "ctrl-" else "")
            s += (if @alt then "alt-" else "")
            s += (if @shift then "shift-" else "")
            s += @name.toLowerCase()

            return s

    vimEscaped: ->
        kc = KeyCode[@code]
        visible = kc.visible
        if _.contains [16, 17, 18], @code
            return ''
        else if !(@ctrl || @alt) && visible
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
            name = KeyKit.vimCodeByKeyname[@name] || @name.toLowerCase()
            if name is 'LT' then name = '<LT>'
            s += name

            return "<#{s}>"
