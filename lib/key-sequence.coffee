
_ = require 'underscore-plus'

KeyKit = require './keykit'

module.exports =
class KeySequence
    
    keys:     null
    running:  null

    constructor: (sequence) ->
        @keys = KeyKit.getKeySequence sequence
        @running = false

    handler:  (event) =>
        if @running
            event.abortKeyBinding()
            return
        @running = true

        event.preventDefault()
        event.stopImmediatePropagation()

        _.each @keys, @trigger.bind(@)

        @running = false

    trigger: (key) ->
        downEvent = KeyKit.createKBEvent('keydown', key)
        canceled = !@dispatch downEvent

        if KeyKit.isPrintable key.code
            @dispatch KeyKit.createKBEvent('keypress', key)

        unless canceled
            if @dispatch KeyKit.createTextEvent(key)
                document.activeElement.getModel?().insertText key.char

        @dispatch KeyKit.createKBEvent('keyup', key)

    dispatch: (event) ->
        document.activeElement.dispatchEvent event
