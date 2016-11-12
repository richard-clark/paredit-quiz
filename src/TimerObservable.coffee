Observable = require("./Observable")

module.exports = class TimerObervable extends Observable

  constructor: () ->
    super()
    timestampInterval = null
    timestamp = null
    emit = @emit
    @emit = null

    @value = () ->
      if timestamp?
        return new Date() - timestamp

    @pause = () ->
      if timestampInterval?
        window.clearInterval(timestampInterval)
        timestampInterval = null

    @start = (_timestamp) =>
      @pause()
      timestamp = _timestamp
      unless timestamp?
        timestamp = new Date()
      emitter = () =>
        emit(@value())
      timestampInterval = window.setInterval(emitter, 1000)
      emitter()

    emit(0)
