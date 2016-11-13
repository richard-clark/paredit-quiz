AbstractModal = require("./AbstractModal")

class GameOverModal extends AbstractModal
  constructor: (observable) ->
    super("#end-of-game")
    observable.on ({type}) =>
      if type is "END_OF_GAME"
        @show()
      else
        @hide()

module.exports = GameOverModal
