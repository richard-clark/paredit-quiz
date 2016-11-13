hljs = require("highlight.js")
rq = require("../fluentDom")

replaceCursor = (element, cursorIndex, startIndex=0) ->
  index = startIndex

  if startIndex is 0 and element.childNodes.length is 0
    # Node is empty
    cursor = document.createElement("span")
    cursor.classList.add("code--cursor")
    element.appendChild(cursor)
    return

  for childNode in element.childNodes
    if childNode.nodeType is document.TEXT_NODE
      if index <= cursorIndex <= index + childNode.textContent.length
        originalContentLength = childNode.textContent.length

        pre = childNode.textContent.substr(0, cursorIndex - index)
        post = childNode.textContent.substr(cursorIndex - index, childNode.textContent.length)

        cursor = document.createElement("span")
        cursor.classList.add("code--cursor")
        element.insertBefore(cursor, childNode)

        element.insertBefore(document.createTextNode(pre), cursor)
        childNode.textContent = post

        index += originalContentLength
      else
        index += childNode.textContent.length

    else
      index = replaceCursor(childNode, cursorIndex, index)

  return index

code = (element, code) ->
  cursorIndex = code.indexOf("|")
  code = code.replace("|", "")

  element.clear().add("code")
    .addClass("code")
    .addClass("lisp")
    .text(code)
    .tapRaw (block) ->
      hljs.highlightBlock(block)
      replaceCursor(block, cursorIndex)

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
