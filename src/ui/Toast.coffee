rq = require("../fluentDom")

SUCCESS_MESSAGES = [
  "Correct!"
  "Nice!"
  "Well Done!"
]

class Toast
  constructor: (observable) ->
    observable.on (event) ->
      console.log("Toast")
      console.log(event)
      message = null
      if event.type is "CORRECT_RESPONSE" and event.points > 0
        message = SUCCESS_MESSAGES[Math.floor(Math.random() * SUCCESS_MESSAGES.length)]
      else if event.type is "INCORRECT_RESPONSE" and event.pointsRemaining > 0
        message = "Incorrect, try again."

      return unless message?

      rq("#message-container")
        .add("p")
          .addClass("message-container__message")
          .addClass("message-container__message--animated")
          .text(message)
          .tap (e) ->
            window.setTimeout () ->
              e.addClass("message-container__message--fade-out")
            , 500
            window.setTimeout () ->
              e.remove()
            , 1500

module.exports = Toast
