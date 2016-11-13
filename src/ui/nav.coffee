rq = require("../rQuery")

class Score
  constructor: (observable) ->
    observable.on (value) ->
      rq("#score").text("Score: #{value}")

padLeft = (str, length=2, padChar="0") ->
  [0...Math.max(length - "#{str}".length, 0)].map(->padChar).join("") + str

class Timer
  constructor: (observable) ->
    observable.on (time) ->
      totalSeconds = Math.round(time / 1000)
      seconds = totalSeconds % 60
      minutes = Math.floor(totalSeconds / 60)

      rq("#time").text("#{padLeft(minutes)}:#{padLeft(seconds)}")

module.exports = {
  Score
  Timer
}
