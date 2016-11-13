AbstractModal = require("./AbstractModal")
rq = require("../fluentDom")

###
TODO:
- Rename modal to #wrong-answer instead of #hint (hint doens't make any sense).
###

class WrongAnswerModal extends AbstractModal
  constructor: (dataSource, questionObservable, gameLifecycleObservable) ->
    super("#hint")

    questionObservable.on ([{item}]) =>
      @hide()

      rq("#commands").clear().tap (commands) ->

        for command in item.commands
          category = dataSource.categoryForCommand[command]
          bindings = dataSource.bindingsForCommand[command]

          commands.add("div")
            .addClass("modal__section")
            .add("h2")
              .addClass("modal__subtitle")
              .text(command)
              .parent()
            .tap (element) ->
              for binding in bindings
                element.add("ul")
                  .addClass("bindings")
                  .tap (bindingElement) ->
                      keys = binding.split("-")
                      for key in keys
                        bindingElement.add("li")
                          .addClass("bindings__binding")
                          .text(key)

    gameLifecycleObservable.on (event) =>
      if event.type is "INCORRECT_RESPONSE" and event.pointsRemaining is 0
        @show()
      else
        @hide()

module.exports = WrongAnswerModal
