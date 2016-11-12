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
domActions = new Observable()
questionDataSource = new QuestionDataSource rawQuestionData,
  maxPerCommand: maxQuestionsPerCommand
  maxCount: maxQuestionsPerCommand
  fixedOrder: fixedOrder
questionObservable = new CombineLatestObservable([questionDataSource, documentReady])
keyPress = new Observable()
scoreObservable = new Observable()
toastObservable = new Observable()

kebabToCamelCase = (name) ->
  name.replace /([^\-])\-([^\-])/g, (_, first, second) ->
    first + second.toUpperCase()

getEventAttributes = (event) ->
  element = event.target
  attributes = {}
  while element?
    for {name, value} in element.attributes
      if name.match(/^eq-/)
        camelCaseName = kebabToCamelCase(name)
        attributes[camelCaseName] = value
    element = element.parent
  return attributes

document.addEventListener "DOMContentLoaded", () ->
  documentReady.emit(true)

document.addEventListener "click", (event) ->
  attr = getEventAttributes(event)
  domActions.emit({attr, event})

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
  document.querySelector("#score").textContent = "Score: #{score}"
documentReady.on () ->
  scoreObservable.emit(0)

currentCommands = []
pointsForQuestion = 0
questionDataSource.on ({item}) ->
  currentCommands = item.commands
  pointsForQuestion = options.attemptsPerQuestion

keyPress.on (command) ->
  console.log(currentCommands, command)
  if command in currentCommands
    # Success
    toastObservable.emit
      message: "Success!"
      timestamp: new Date()
    scoreObservable.emit(pointsForQuestion)
    questionDataSource.next()
  else
    pointsForQuestion = Math.max(pointsForQuestion-1, 0)

    if pointsForQuestion > 0
      toastObservable.emit
        message: "WRONG!"
        timestamp: new Date()
    else
      toastObservable.emit
        message: "Too many incorrect attempts"
        timestamp: new Date()
      renderers.hintModalVisibility(true)

showMessage = (message) ->
  document.querySelector("#message").textContent = message

clearMessage = () ->
  document.querySelector("#message").textContent = ""

toastTimeout = null
toastObservable.on ({message, timestamp}) ->
  if toastTimeout?
    window.clearTimeout(toastTimeout)

  now = new Date()
  deltaDate = now - timestamp
  clearAfter = 3*1000 - deltaDate

  if clearAfter > 0
    toastTimeout = window.setTimeout () ->
      clearMessage()
    , clearAfter
    showMessage(message)
