class GameStats
  constructor: () ->
    @responses = []

  addResponse: ({points, time}) =>
    @responses.push({points, time})

  getScore: () =>
    @responses.reduce (score, response) ->
      score + response.points
    , 0

  getAverageTime: () =>
    totalTime = @responses.reduce (_totalTime, response) ->
      _totalTime + response.time
    , 0
    return totalTime / @responses.length

  getPointBreakdown: () =>
    responsesByPoints = @responses.reduce (_responsesByPoints, {points}) ->
      _responsesByPoints[points] ?= 0
      _responsesByPoints[points]++
      return _responsesByPoints
    , {}

module.exports = GameStats
