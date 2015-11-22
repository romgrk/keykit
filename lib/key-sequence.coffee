
_ = require 'underscore-plus'

KeyKit = require './keykit'

module.exports =
class KeySequence

    callbackReference: null

    keys:     null
    running:  null

    constructor: (sequence) ->
        @keys = KeyKit.getKeystrokes sequence
        @running = false

    execute: (event) =>
        if @running
            return
        @running = true

        if event?
            event.originalEvent.preventDefault()
            event.originalEvent.stopImmediatePropagation()

        _.each @keys, @trigger.bind(@)

        @running = false

    trigger: (key) ->
        downEvent = KeyKit.createKBEvent('keydown', key)
        canceled = !@dispatch downEvent

        unless canceled
            if @dispatch(textEvent = KeyKit.createTextEvent(key))
                document.activeElement.getModel?().insertText key.char
            # if KeyKit.isPrintable key.code
                # @dispatch KeyKit.createKBEvent('keypress', key)

        @dispatch KeyKit.createKBEvent('keyup', key)

    getCallback: ->
        unless @callbackReference?
            @callbackReference = @execute.bind(@)
        return @callbackReference

    dispatch: (event) ->
        document.activeElement.dispatchEvent event
