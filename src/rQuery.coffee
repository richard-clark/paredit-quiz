factory = (elements) ->
  fn = {}

  add = (tagName) ->
    childElements = elements.map (element) ->
      childElement = document.createElement(tagName)
      element.appendChild(childElement)
      return childElement
    return factory(childElements)
  fn.add = add

  addClass = (cls) ->
    for element in elements
      element.classList.add(cls)
    return fn
  fn.addClass = addClass

  clear = () ->
    for element in elements
      while element.firstChild?
        element.firstChild.remove()
    return fn
  fn.clear = clear

  find = (selector) ->
    allMatches = []
    for element in elements
      matches = element.querySelectorAll(selector)
      for match in matches
        allMatches.push(match)
    return factory(allMatches)
  fn.find = find

  removeClass = (cls) ->
    for element in elements
      element.classList.remove(cls)
    return fn
  fn.removeClass = removeClass

  parent = () ->
    if elements.length > 0 and elements[0].parentElement?
      factory([elements[0].parentElement])
    else
      factory([])
  fn.parent = parent

  tap = (invokee) ->
    for element in elements
      invokee(factory([element]))
    return fn
  fn.tap = tap

  text = (text) ->
    for element in elements
      element.textContent = text
    return fn
  fn.text = text

  toggleClass = (cls, show) ->
    if show
      addClass(cls)
    else
      removeClass(cls)
  fn.toggleClass = toggleClass

  return fn

module.exports = (selector) ->
  elements = [document]
  if selector?
    elements = Array.from(document.querySelectorAll(selector))
  factory(elements)
