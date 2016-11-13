rq = require("../fluentDom")

class AbstractModal
  constructor: (@selector) ->
    @modalTimeout = null

  cancelTimeout: () =>
    if @modalTimeout?
      window.clearTimeout(@modalTimeout)
      @modalTimeout = null

  visible: () =>
    rq(@selector).matches(".modal-container--visible")

  show: () =>
    return if @visible()
    @cancelTimeout()
    rq(@selector).removeClass("modal-container--animated")
      .addClass("modal-container--off-screen")
      .addClass("modal-container--visible")
      .tap (element) =>
        @modalTimeout = window.setInterval () ->
          element.addClass("modal-container--animated")
            .removeClass("modal-container--off-screen")
        , 100

  hide: () =>
    return if not @visible()
    @cancelTimeout()
    rq(@selector).removeClass("modal-container--visible")

module.exports = AbstractModal
