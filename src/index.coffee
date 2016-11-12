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

questionObservable.on ([{index, count, item}]) ->
  renderers.question(index, count, item)
  renderers.hintModalVisibility(false)
  renderers.hintModal(item, questionDataSource)

score = 0
currentCommands = []
pointsForQuestion = 0

gameLifecycle.on ({type}) ->
  if type is "NEW_GAME"
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
      endOfGameEvent =
        type: "END_OF_GAME"
        score: score
      gameLifecycle.emit(endOfGameEvent)
    else
      questionDataSource.next()
  else
    if pointsForQuestion > 0
      renderers.message("WRONG!")
    else
      timerObservable.pause()
      renderers.message()
      renderers.hintModalVisibility(true)

gameLifecycle.on (event) ->
  renderers.gameOverModal(event)

documentReady.on () ->
  gameLifecycle.emit({type: "NEW_GAME"})

userEvents.on (event) ->
  switch event
    when "new-game"
      gameLifecycle.emit({type: "NEW_GAME"})
