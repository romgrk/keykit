
_ = require 'underscore-plus'

KeyKit = require './keykit'

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

        kit = require './keykit'
        if @code?
            key = kit.findByCode(@code)
            @name = key.name
            if _.isArray key.char
                @char = key.char[0] if !@shift
                @char = key.char[1] if @shift
            else
                @char = key.char
        else if @name?
            @code = kit.findByName(@name).code
        else
            throw new Error "Keycode or name needed"


    toString: ->
        kit = require './keykit'

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
            s += @name.toLowerCase()

            return s

    vimEscaped: ->
        kit = require './keykit'

        kc = kit.keysByCode[@code]
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

            name = kit.vimCodeByKeyname[@name] || @name.toLowerCase()
            if name is 'LT' then name = '<LT>'
            s += name

            return "<#{s}>"
