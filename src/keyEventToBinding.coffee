###
Converts keyup and keydown events to Emacs-style command string.

TODO:
- figure out key for <deletechar>
- allow custom ctrl and meta keys
- support chords (sequences of keys)
###

module.exports = ({code, altKey, ctrlKey, shiftKey}) ->
  modifiers = ""
  if ctrlKey
    modifiers += "C-"
  if altKey
    modifiers += "M-"

  CHAR_FOR_KEY =
    Backspace: "DEL"
    BracketLeft: "["
    BracketRight: "]"
    Delete: "<delete>"
    Escape: "ESC"
    Quote: "'"

  SHIFT_MODIFIERS =
    "'": "\""
    "[": "{"
    "]": "}"
    "0": ")"
    "9": "("

  DIGIT_OR_KEY_MATCHER = /^(Digit|Key)(.)/
  ARROW_KEY_MATCHER = /^Arrow(.*)$/

  char = switch
    when CHAR_FOR_KEY[code]?
      CHAR_FOR_KEY[code]
    when code.match(DIGIT_OR_KEY_MATCHER)?
      code.match(DIGIT_OR_KEY_MATCHER)[2].toLowerCase()
    when code.match(ARROW_KEY_MATCHER)?
      "<" + code.match(ARROW_KEY_MATCHER)[1].toLowerCase() + ">"

  if char and shiftKey
    if SHIFT_MODIFIERS[char]?
      char = SHIFT_MODIFIERS[char]
    else
      char = char.toUpperCase()

  if char?
    return "#{modifiers}#{char}"
