hljs = require("highlight.js")
rq = require("../rQuery")

###
TODO:
- Pass in streams and let logic in this file decide what to do instead of
  invoking the logic in this file from elsewhere.
- Fix instances where highlighting is incorrect due to cursor. (See #1 below.)

Issue #1:

Given `(qux|x)` as input, when rendered, `qux` is treated as a function, and `x`
as a name. `x` should also be treated as a function. (Possible solution: figure
out cursor index, remove it from code string, highlight code, then add a cursor
element based on index.)

###

replaceCursor = (element) ->
  for childNode in element.childNodes
    if childNode.nodeType is document.TEXT_NODE
      match = childNode.textContent.match(/^([^\|]*)\|([^\|]*)$/)
      if match?
        cursor = document.createElement("span")
        cursor.classList.add("code--cursor")
        element.insertBefore(cursor, childNode)

        element.insertBefore(document.createTextNode(match[1]), cursor)

        childNode.textContent = match[2]

        return true

    else
      if replaceCursor(childNode)
        return true

code = (element, code) ->
  element.clear().add("code")
    .addClass("code")
    .addClass("lisp")
    .text(code)
    .tapRaw (block) ->
      hljs.highlightBlock(block)
      replaceCursor(block)

###
I find myself sometimes trying to use a command to get from the `from` state to
the `to` state. The delay in showing the `to` state is hopefully to eliminate
this.

# TODO: add options for toggling whether the delay is enabled, and adjusting
# the delay duration.
###
class Question
  constructor: (questionObservable) ->
    showToTimeout = null
    questionObservable.on ([{index, count, item}]) ->
      question = item

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

module.exports = Question
