AbstractModal = require("./AbstractModal")
rq = require("../rQuery")

renderPointBreakdown = (element, responses) ->
  SERIES_MODIFIERS =
    2: "success"
    1: "warning"
    0: "error"

  pointBreakdown = responses.getPointBreakdown()

  element.find(".pie-chart__data").clear()
    .tap (dataElement) ->
      for value in [2..0]
        count = pointBreakdown[value]
        width = "#{count / responses.responses.length * 100}%"
        # 2 -> 1, 1 -> 2, 0 -> 3
        dataElement.add("div")
          .addClass("data__slice")
          .addClass("data__slice--#{SERIES_MODIFIERS[value]}")
          .style("minWidth", width)
          .style("maxWidth", width)

  element.find(".pie-chart__legend").clear()
    .tap (legendElement) ->
      for value in [2..0]
        count = pointBreakdown[value] ? 0
        legendElement.add("li")
          .addClass("legend__item")
          .add("span")
            .addClass("legend__item__key")
            .addClass("legend__item__key--#{SERIES_MODIFIERS[value]}")
            .parent()
          .add("span")
            .addClass("legend__item__value")
            .text("#{value} (#{count})")

class GameOverModal extends AbstractModal
  constructor: (observable) ->
    super("#end-of-game")
    observable.on ({type, responses}) =>
      if type is "END_OF_GAME"
        score = responses.getScore()
        rating = score / (responses.responses.length * 2)
        averageTime = Math.round(responses.getAverageTime() / 10) / 100

        element = rq("#end-of-game")

        if rating is 1
          message = "Perfect!"
        else if rating >= 0.8
          message = "Excellent job."
        else if rating >= 0.6
          message = "Good effort."
        else
          message = "Try again. Practice makes perfect."

        element.find(".modal__copy").text(message)

        scalars = [
            title: "Score"
            value: "#{Math.round(rating * 100)}%"
          ,
            title: "Points"
            value: score
          ,
            title: "Average Time"
            value:  "#{averageTime}s"
        ]
        element.find(".scalar-group").clear()
          .tap (scalarGroupElement) ->
            for scalar in scalars
              scalarGroupElement.add("li")
                .addClass("scalar-group__scalar")
                .addClass("scalar")
                .add("h4")
                  .addClass("scalar__title")
                  .text(scalar.title)
                  .parent()
                .add("p")
                  .addClass("scalar__value")
                  .text(scalar.value)
                  .parent()

        renderPointBreakdown(element, responses)

        @show()
      else
        @hide()

module.exports = GameOverModal
