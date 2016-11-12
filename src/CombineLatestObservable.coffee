Observable = require("./Observable")

module.exports = class CombineLatestObservable extends Observable

  constructor: (observables) ->
    super()
    latest = observables.map () ->
      undefined

    emit = @emit
    @emit = null
    emitWhenPresent = () =>
      return unless latest.every (result) ->
        result?
      emit(latest)

    for observable, index in observables
      do (observable, index) ->
        observable.on (result) ->
          latest[index] = result
          emitWhenPresent()
