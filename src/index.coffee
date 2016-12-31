rawQuestionData = require("./paredit")
QuestionDataSource = require("./QuestionDataSource")
Observable = require("./Observable")
CombineLatestObservable = require("./CombineLatestObservable")
keyEventToBinding = require("./keyEventToBinding")
TimerObservable = require("./TimerObservable")
GameStats = require("./GameStats")

###
TODO:
- Store scores with local storage; display past scores.
- Allow options to be change dynamically. (e.g. maxQuestionCount).
###

navUi = require("./ui/nav")
QuestionUi = require("./ui/Question")
GameOverModalUi = require("./ui/GameOverModal")
ToastUi = require("./ui/Toast")
WrongAnswerModalUi = require("./ui/WrongAnswerModal")

options =
  attemptsPerQuestion: 2
  maxQuestionsPerCommand: 2
  maxQuestionCount: 25
  fixedOrder: false # useful for debugging--don't randomize the order of the questions.
  keyBindings:
    # Swap these properties as necessary--this configuration works for macOS.
    command: "metaKey"
    ctrl: "ctrlKey"
    meta: "altKey"

documentReady = new Observable()
questionDataSource = new QuestionDataSource rawQuestionData,
  maxPerCommand: options.maxQuestionsPerCommand
  maxCount: options.maxQuestionCount
  fixedOrder: options.fixedOrder
questionObservable = new CombineLatestObservable([questionDataSource, documentReady])
keyPress = new Observable()
scoreObservable = new Observable()
timerObservable = new TimerObservable()
gameLifecycle = new Observable()
userEvents = new Observable()

document.addEventListener "DOMContentLoaded", () ->
  documentReady.emit(true)

document.addEventListener "click", (event) ->
  element = event.target
  while element?
    if element.hasAttribute("event-on-click")
      userEvents.emit(element.getAttribute('event-on-click'))
      return
    element = element.parentElement

getCommandForBinding = (binding) ->
  if binding? and rawQuestionData?
    for command, commandBindings of questionDataSource.bindingsForCommand
      if binding in commandBindings
        return command

window.addEventListener "keydown", (event) ->
  binding = keyEventToBinding(options, event)
  if binding?
    keyPress.emit(binding)
    event.preventDefault()
    event.stopPropagation()
    return false

currentCommands = []
pointsForQuestion = 0
lastQuestion = false
responses = new GameStats()

gameLifecycle.on ({type, restart}) ->
  if type is "NEW_GAME"
    responses = new GameStats()
    scoreObservable.emit(responses.getGrade())
    if restart
      questionDataSource.restart()
    else
      questionDataSource.shuffle()

new navUi.Score(scoreObservable)
new navUi.Timer(timerObservable)
new navUi.QuestionIndex(questionObservable)
new QuestionUi(questionObservable)
new GameOverModalUi(gameLifecycle)
new ToastUi(gameLifecycle)
new WrongAnswerModalUi(questionDataSource, questionObservable, gameLifecycle)

questionDataSource.on ({item, index, count}) ->
  currentCommands = item.commands
  pointsForQuestion = options.attemptsPerQuestion
  lastQuestion = index is count - 1
  timerObservable.start()

# Dispatch a response event when a command is entered
keyPress.on (binding) ->
  command = getCommandForBinding(binding)
  if command? and command in currentCommands
    # Valid response
    gameLifecycle.emit
      type: "CORRECT_RESPONSE"
      points: pointsForQuestion
      lastQuestion: lastQuestion
      time: timerObservable.value()

  else
    # Invalid response
    pointsForQuestion = Math.max(pointsForQuestion-1, 0)
    gameLifecycle.emit
      type: "INCORRECT_RESPONSE"
      pointsRemaining: pointsForQuestion

# Update score
gameLifecycle.on (event) ->
  if event.type is "CORRECT_RESPONSE"
    responses.addResponse(event)
    scoreObservable.emit(responses.getGrade())

# Clear timer on incorrect response
gameLifecycle.on (event) ->
  if event.type is "INCORRECT_RESPONSE" and pointsForQuestion is 0
    timerObservable.pause()

# End game if this is the last question
gameLifecycle.on (event) ->
  if event.type is "CORRECT_RESPONSE" and event.lastQuestion
    timerObservable.pause()
    gameLifecycle.emit
      type: "END_OF_GAME"
      responses: responses

# Show next question if this is not the last question
gameLifecycle.on (event) ->
  if event.type is "CORRECT_RESPONSE" and not event.lastQuestion
    questionDataSource.next()

# Star a new game when the user requests it
userEvents.on (event) ->
  switch event
    when "new-game"
      gameLifecycle.emit({type: "NEW_GAME"})
    when "restart"
      gameLifecycle.emit({type: "NEW_GAME", restart: true})

# Start a new game when the document is loaded
documentReady.on () ->
  gameLifecycle.emit({type: "NEW_GAME"})
