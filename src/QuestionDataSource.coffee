Observable = require("./Observable")

flatten = (collection) ->
  collection.reduce (rest, item) ->
    if item instanceof Array
      return rest.concat(item)
    else
      return rest.concat([item])
  , []

# Fisher Yates shuffle
shuffle = (items) ->
  for i in [(items.length-1)...0]
    j = Math.floor(Math.random() * i)
    temp = items[i]
    items[i] = items[j]
    items[j] = temp
  return items

###
Options:
- max length (maximum number of questions)
- max per command (maximum number of examples per command)

###
module.exports = class QuestionDataSource extends Observable
  constructor: (rawQuestionData, @options={}) ->
    super()
    @categoryForCommand = rawQuestionData.categories.reduce (parentObj, category) ->
      category.commands.reduce (obj, command) ->
        obj[command] = category.name
      , parentObj
    , {}
    @bindingsForCommand = rawQuestionData.bindings
    @allItems = rawQuestionData.examples

    emit = @emit
    @emit = () =>
      event =
        index: @index
        count: @collection.length
        item: @collection[@index]
      emit(event)

  shuffle: () =>
    @collection = @allItems.map (item) ->
      item

    unless @options.fixedOrder
      @collection = shuffle(@collection)

    if @options.maxPerCommand?
      countPerCommand = {}
      collection = []
      for item in @collection
        continue unless item.commands.every (command) =>
          not countPerCommand[command]? or
          countPerCommand[command] < @options.maxPerCommand
        collection.push(item)
        for command in item.commands
          countPerCommand[command] ?= 0
          countPerCommand[command]++
      @collection = collection

    if @options.maxCount? and @options.maxCount < @collection.length
      @collection = @collection.slice(0, @options.maxCount)

    @index = 0
    @emit()

  next: () =>
    if @index < @collection.length - 1
      @index++
      @emit()

  previous: () =>
    if @index > 0
      @index--
      @emit()

  restart: () =>
    return unless @index > 0
    @index = 0
    @emit()
