rawQuestionData = require("./paredit")
QuestionDataSource = require("./QuestionDataSource")
Observable = require("./Observable")
CombineLatestObservable = require("./CombineLatestObservable")
keyEventToBinding = require("./keyEventToBinding")
TimerObservable = require("./TimerObservable")
GameStats = require("./GameStats")

###
TODO:
- Keys that don't map to commands that are successfully consumed (e.g. `C-r`)
  should be treated as incorrect input instead of ignored.
- Add support for restarting the current game.
- Restore display of question number
- Display number of questions in game over modal?
###

navUi = require("./ui/nav")
QuestionUi = require("./ui/Question")
GameOverModalUi = require("./ui/GameOverModal")
ToastUi = require("./ui/Toast")
WrongAnswerModalUi = require("./ui/WrongAnswerModal")

options =
  attemptsPerQuestion: 2
  maxQuestionsPerCommand: 2
  maxQuestionCount: 10 # 40
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
  binding = keyEventToBinding(event)
  command = getCommandForBinding(binding)
  if command?
    keyPress.emit(command)
    event.preventDefault()
    event.stopPropagation()
    return false

currentCommands = []
pointsForQuestion = 0
lastQuestion = false
responses = new GameStats()

gameLifecycle.on ({type}) ->
  if type is "NEW_GAME"
    responses = new GameStats()
    scoreObservable.emit(responses.getScore())
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
keyPress.on (command) ->
  if command in currentCommands
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
    scoreObservable.emit(responses.getScore())

# Clear timer on incorrect response
gameLifecycle.on (event) ->
  if event.type is "INCORRECT_RESPONSE"
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

# Start a new game when the document is loaded
documentReady.on () ->
  gameLifecycle.emit({type: "NEW_GAME"})
