rawQuestionData = require("./paredit")
QuestionDataSource = require("./QuestionDataSource")
Observable = require("./Observable")
CombineLatestObservable = require("./CombineLatestObservable")
keyEventToBinding = require("./keyEventToBinding")
renderers = require("./renderers")

options =
  attemptsPerQuestion: 2
  maxQuestionsPerCommand: 2
  maxQuestionCount: 40
  fixedOrder: false

documentReady = new Observable()
questionDataSource = new QuestionDataSource rawQuestionData,
  maxPerCommand: options.maxQuestionsPerCommand
  maxCount: options.maxQuestionCount
  fixedOrder: options.fixedOrder
questionObservable = new CombineLatestObservable([questionDataSource, documentReady])
keyPress = new Observable()
scoreObservable = new Observable()
timerObservable = new Observable()

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
scoreObservable.on (pointsToAdd) ->
  score += pointsToAdd
  renderers.score(score)
documentReady.on () ->
  scoreObservable.emit(0)
  timerObservable.emit(0)

timestamp = null
timestampInterval = null
startTimer = () ->
  pauseTimer()
  timestamp = new Date()
  timerObservable.emit(0)
  timestampInterval = window.setInterval () ->
    now = new Date()
    delta = now - timestamp
    timerObservable.emit(delta)
  , 1000
pauseTimer = () ->
  if timestampInterval?
    window.clearInterval(timestampInterval)
    timestampInterval = null
timerObservable.on (time) ->
  renderers.timer(time)

currentCommands = []
pointsForQuestion = 0
timestamp = null
questionDataSource.on ({item}) ->
  currentCommands = item.commands
  pointsForQuestion = options.attemptsPerQuestion
  startTimer()

SUCCESS_MESSAGES = [
  "Correct!"
  "Nice!"
  "Well Done!"
]

keyPress.on (command) ->
  if command in currentCommands
    # Success
    message = SUCCESS_MESSAGES[Math.floor(Math.random() * SUCCESS_MESSAGES.length)]
    renderers.message(message)
    scoreObservable.emit(pointsForQuestion)
    questionDataSource.next()
  else
    pointsForQuestion = Math.max(pointsForQuestion-1, 0)

    if pointsForQuestion > 0
      renderers.message("WRONG!")
    else
      pauseTimer()
      renderers.message()
      renderers.hintModalVisibility(true)
