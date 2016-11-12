module.exports = class Observable

  constructor: () ->
    items = []
    callbacks = []

    @emit = (item) ->
      for callback in callbacks
        callback(item)
      items.push(item)

    @off = (callback) ->
      subscribers = callbacks.filter (_callback) ->
        _callback isnt callback

    @on = (callback) ->
      @off(callback)
      callbacks.push(callback)
      for item in items
        callback(item)
