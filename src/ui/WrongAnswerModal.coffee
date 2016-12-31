AbstractModal = require("./AbstractModal")
rq = require("../fluentDom")

class WrongAnswerModal extends AbstractModal
  constructor: (dataSource, questionObservable, gameLifecycleObservable) ->
    super("#wrong-answer")

    questionObservable.on ([{item}]) =>
      @hide()

      if item.commands.length > 1
        message = "You can accomplish this task with one of the following
          commands. Try one now."
      else
        message = "You can accomplish this task with the following command. Try
          it now."

      rq("#wrong-answer .modal__copy").text(message)

      rq("#commands").clear().tap (commands) ->

        for command in item.commands
          category = dataSource.categoryForCommand[command]
          bindings = dataSource.bindingsForCommand[command]

          commands.add()
            .addClass("modal__section")
            .add("h2")
              .addClass("modal__subtitle")
              .text(command)
              .parent()
            .tap (element) ->
              for binding in bindings
                element.add()
                  .addClass("bindings")
                  .tap (bindingElement) ->
                      keys = binding.split("-")
                      for key in keys
                        bindingElement.add("kbd")
                          .addClass("bindings__binding")
                          .text(key)

    gameLifecycleObservable.on (event) =>
      if event.type is "INCORRECT_RESPONSE" and event.pointsRemaining is 0
        @show()
      else
        @hide()

module.exports = WrongAnswerModal
