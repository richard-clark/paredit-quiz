rawQuestionData = require("./paredit")
QuestionDataSource = require("./QuestionDataSource")
Observable = require("./Observable")
CombineLatestObservable = require("./CombineLatestObservable")
keyEventToBinding = require("./keyEventToBinding")
renderers = require("./renderers")
TimerObservable = require("./TimerObservable")

options =
  attemptsPerQuestion: 2
  maxQuestionsPerCommand: 2
  maxQuestionCount: 5 # 40
  fixedOrder: false

documentReady = new Observable()
questionDataSource = new QuestionDataSource rawQuestionData,
  maxPerCommand: options.maxQuestionsPerCommand
  maxCount: options.maxQuestionCount
  fixedOrder: options.fixedOrder
questionObservable = new CombineLatestObservable([questionDataSource, documentReady])
keyPress = new Observable()
scoreObservable = new Observable()
timerObservable = new TimerObservable()

document.addEventListener "DOMContentLoaded", () ->
  documentReady.emit(true)

getCommandForBinding = (binding) ->
  if binding? and rawQuestionData?
    for command, commandBindings of questionDataSource.bindingsForCommand
      if binding in commandBindings
        return command

window.addEventListener "keydown", (event) ->
  binding = keyEventToBinding(event)
  command = getCommandForBinding(binding)
  if command?
    keyPress.emit(command)
    event.preventDefault()
    event.stopPropagation()
    return false

questionObservable.on ([{index, count, item}]) ->
  renderers.question(index, count, item)
  renderers.hintModalVisibility(false)
  renderers.hintModal(item, questionDataSource)

score = 0
currentCommands = []
pointsForQuestion = 0

newGame = () ->
  score = 0
  scoreObservable.emit(0)
  questionDataSource.shuffle()

scoreObservable.on (value) ->
  renderers.score(value)

timerObservable.on (time) ->
  renderers.timer(time)

lastQuestion = false
questionDataSource.on ({item, index, count}) ->
  currentCommands = item.commands
  pointsForQuestion = options.attemptsPerQuestion
  lastQuestion = index is count - 1
  timerObservable.start()

SUCCESS_MESSAGES = [
  "Correct!"
  "Nice!"
  "Well Done!"
]

keyPress.on (command) ->
  pointsForQuestion = Math.max(pointsForQuestion-1, 0)

  if command in currentCommands
    timerObservable.pause()

    if pointsForQuestion > 0
      # Success
      message = SUCCESS_MESSAGES[Math.floor(Math.random() * SUCCESS_MESSAGES.length)]
      renderers.message(message)
      score += pointsForQuestion
      scoreObservable.emit(score)

    if lastQuestion
      console.log("End of game!")
    else
      questionDataSource.next()
  else
    if pointsForQuestion > 0
      renderers.message("WRONG!")
    else
      timerObservable.pause()
      renderers.message()
      renderers.hintModalVisibility(true)

documentReady.on () ->
  newGame()
