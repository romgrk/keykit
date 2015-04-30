
_ = require 'underscore-plus'

KeyKit = require './keykit'
{Key, KeyCode} = require './key-code'

module.exports = class KeyStroke

    constructor: (options={}) ->
        @ctrl       = options.ctrl ? false
        @alt        = options.alt ? false
        @shift      = options.shift ? false
        @meta       = options.meta ? false

        @code       = options.code ? options.keyCode ? options.keycode ? null

        @name       = options.name ? null
        # @char       = options.char ? KeyKit.getChar @

        @identifier = options.identifier ? null

        @complete()

    complete: ->
        if @code?
            kc = KeyCode[@code]
            @name = kc.name
            if kc.shiftable
                @char = kc.char[@shift]
            else
                @char = kc.char
        @name ?= KeyKit.keynameByCode[@code]
        @char ?= KeyKit.getChar @

    toString: ->
        visible = not KeyCode.isNotVisible(@code)
        if KeyCode.isMod(@code)
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
            unless @char is '<' then @char else '<LT>'
        else
            s = ""
            s += (if @ctrl then "C-" else "")
            s += (if @alt then "A-" else "")
            s += (if @shift then "S-" else "")
            name = KeyKit.vimCodeByKeyname[@name] || @name.toLowerCase()
            if name is 'LT' then name = '<LT>'
            s += name

            return "<#{s}>"
