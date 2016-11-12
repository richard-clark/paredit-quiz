rq = require("./rQuery")

code = (element, code) ->
  chars = code.split("").reduce (prev, char) ->
    lastElement = prev[prev.length - 1]
    if lastElement?.match(/[A-Za-z]$/)? and char.match(/[A-Za-z]/)?
      prev.slice(0, prev.length - 1).concat([prev[prev.length - 1] + char])
    else
      prev.concat([char])
  , []

  element.clear().tap (_element) ->
    for char in chars
      isCursor = char is "|"
      isParen = char.match(/[\(\)]/)?
      isNewline = char is "\n"

      _element
        .add("span")
          .addClass("code")
          .toggleClass("code--cursor", isCursor)
          .toggleClass("code--paren", isParen)
          .tap (e) ->
            if isNewline
              e.add("br")
            else if not isCursor
              e.text(char)

###
I find myself sometimes trying to use a command to get from the `from` state to
the `to` state. The delay in showing the `to` state is hopefully to eliminate
this.

# TODO: add options for toggling whether the delay is enabled, and adjusting
# the delay duration.
###
showToTimeout = null
question = (index, count, question) ->
  if showToTimeout?
    window.clearTimeout(showToTimeout)

  rq("#previous-question").remove()

  rq("#question")
    .addClass("main__question--completed")
    .setId("previous-question")

  rq("#main")
    .add()
      .setId("question")
      .addClass("main__question")
      .addClass("main__question--future")
      .tap (element) ->
        window.setTimeout () ->
          element.removeClass("main__question--future")
        , 100
      .addClass("question")
      .add()
        .addClass("prompt")
        .add("span")
          .addClass("prompt__description")
          .text("transform this")
          .parent()
        .add("pre")
          .addClass("prompt__code")
          .tap (element) ->
            code(element, question.from)
          .parent()
        .parent()
      .add()
        .addClass("prompt")
        .add("span")
          .addClass("prompt__description")
          .text("to this")
          .parent()
        .add("pre")
          .addClass("prompt__code")
          .tap (element) ->
            code(element, question.to)
            element.addClass("code-block--hidden")
            showToTimeout = window.setTimeout () ->
              element.addClass("code-block--animated")
                .removeClass("code-block--hidden")
            , 0.2*1000
          .parent()
        .parent()

hintModal = (question, dataSource) ->
  commands = rq("#commands").clear()

  for command in question.commands
    category = dataSource.categoryForCommand[command]
    bindings = dataSource.bindingsForCommand[command]

    commands.add("div")
      .addClass("command")
      .add("h2")
        .addClass("command__name")
        .text(command)
        .parent()
      .add("command__bindings")
        .addClass("bindings")
        .tap (bindingElement) ->
          for binding in bindings
            bindingElement.add("span")
              .addClass("bindings__binding")
              .text(binding)

hintModalVisibility = (visible) ->
  rq("#hint")
    .toggleClass("modal--hidden", not visible)

message = (text) ->
  rq("#message-container").clear()

  if text?
    rq("#message-container")
      .add("p")
        .addClass("message-container__message")
        .addClass("message-container__message--animated")
        .text(text)
        .tap (e) ->
          window.setTimeout () ->
            e.addClass("message-container__message--fade-out")
          , 500

score = (value) ->
  rq("#score").text("Score: #{value}")

padLeft = (str, length=2, padChar="0") ->
  [0...Math.max(length - "#{str}".length, 0)].map(->padChar).join("") + str

timer = (time) ->
  totalSeconds = Math.round(time / 1000)
  seconds = totalSeconds % 60
  minutes = Math.floor(totalSeconds / 60)

  rq("#time").text("#{padLeft(minutes)}:#{padLeft(seconds)}")

module.exports = {
  hintModal
  hintModalVisibility
  message
  question
  score
  timer
}