rq = require("../rQuery")

class Score
  constructor: (observable) ->
    observable.on (value) ->
      if value?
        text = "Score: #{Math.round(value*100)}%"
      else
        text = "Score: --"

      rq("#score").text(text)

padLeft = (str, length=2, padChar="0") ->
  [0...Math.max(length - "#{str}".length, 0)].map(->padChar).join("") + str

class Timer
  constructor: (observable) ->
    observable.on (time) ->
      totalSeconds = Math.round(time / 1000)
      seconds = totalSeconds % 60
      minutes = Math.floor(totalSeconds / 60)

      rq("#time").text("#{padLeft(minutes)}:#{padLeft(seconds)}")

class QuestionIndex
  constructor: (questionObservable) ->
    questionObservable.on ([{index, count}]) ->
      rq("#question-index").text("#{index+1} / #{count}")

module.exports = {
  QuestionIndex
  Score
  Timer
}
