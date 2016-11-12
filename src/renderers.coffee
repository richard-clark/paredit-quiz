
clearContents = (element) ->
  while element.firstChild?
    element.firstChild.remove()

code = (element, code) ->
  clearContents(element)

  chars = code.split("").reduce (prev, char) ->
    lastElement = prev[prev.length - 1]
    if lastElement?.match(/[A-Za-z]$/)? and char.match(/[A-Za-z]/)?
      prev.slice(0, prev.length - 1).concat([prev[prev.length - 1] + char])
    else
      prev.concat([char])
  , []

  for char in chars
    if char is "\n"
      element.appendChild(document.createElement("br"))
      continue

    codeElement = document.createElement("span")
    codeElement.classList.add("code")
    if char is "|"
      # cursor
      codeElement.classList.add("code--cursor")
    else if char.match(/[\(\)]/)?
      codeElement.classList.add("code--paren")
      codeElement.textContent = char
    else
      codeElement.textContent = char
    element.appendChild(codeElement)

question = (index, count, question) ->
  # name = document.querySelector("#name")
  # name.textContent = question.name

  questionNumberElement = document.querySelector("#question-number")
  questionNumberElement.textContent = "Question #{index+1} of #{count}"

  codeFromElement = document.querySelector("#code-from")
  code(codeFromElement, question.from)

  codeToElement = document.querySelector("#code-to")
  code(codeToElement, question.to)

hintModal = (question, dataSource) ->
  _element = document.querySelector("#hint")
  _commands = _element.querySelector("#commands")
  clearContents(_commands)

  for command in question.commands
    category = dataSource.categoryForCommand[command]
    bindings = dataSource.bindingsForCommand[command]
    _command = document.createElement("div")
    _command.classList.add("command")

    _name = document.createElement("h2")
    _name.classList.add("command__name")
    _name.textContent = command
    _command.appendChild(_name)

    _bindings = document.createElement("h3")
    _bindings.classList.add("command__bindings")
    _bindings.classList.add("bindings")
    for binding in bindings
      _binding = document.createElement("span")
      _binding.classList.add("bindings__binding")
      _binding.textContent = binding
      _bindings.append(binding)
    _command.appendChild(_bindings)

  _commands.appendChild(_command)
  _element.appendChild(_commands)

hintModalVisibility = (visible) ->
  element = document.querySelector("#hint")

  if visible
    element.classList.remove("modal--hidden")
  else
    element.classList.add("modal--hidden")


module.exports = {
  hintModal
  hintModalVisibility
  question
}
