module.exports =
  categories: [
      name: "Basic Insertion Commands"
      commands: [
        "paredit-open-round"
        "paredit-close-round"
        "paredit-close-round-and-newline"
        "paredit-open-square"
        "paredit-close-square"
        "paredit-doublequote"
        "paredit-meta-doublequote"
        "paredit-backslash"
        "paredit-comment-dwim"
        "paredit-newline"
      ]
    ,
      name: "Deleting & Killing"
      commands: [
        "paredit-forward-delete"
        "paredit-backward-delete"
        "paredit-kill"
        "paredit-forward-kill-word"
        "paredit-backward-kill-word"
      ]
    ,
      name: "Movement & Navigation"
      commands: [
        "paredit-forward"
        "paredit-backward"
      ]
    ,
      name: "Depth-Changing Commands"
      commands: [
        "paredit-wrap-round"
        "paredit-splice-sexp"
        "paredit-splice-sexp-killing-backward"
        "paredit-splice-sexp-killing-forward"
        "paredit-raise-sexp"
      ]
    ,
      name: "Barfage & Slurpage"
      commands: [
        "paredit-forward-slurp-sexp"
        "paredit-forward-barf-sexp"
        "paredit-backward-slurp-sexp"
        "paredit-backward-barf-sexp"
      ]
    ,
      name: "Miscellaneous Commands"
      commands: [
        "paredit-split-sexp"
        "paredit-join-sexp"
      ]
  ]
  bindings:
    "paredit-open-round": ["("]
    "paredit-close-round": [")"]
    "paredit-close-round-and-newline": ["M-)"]
    "paredit-open-square": ["["]
    "paredit-close-square": ["]"]
    "paredit-doublequote": ["\""]
    "paredit-meta-doublequote": ["M-\""]
    "paredit-newline": ["C-j"]
    "paredit-forward-delete": ["C-d", "<delete>", "<deletechar>"]
    "paredit-backward-delete": ["DEL"] # note: backspace
    "paredit-kill": ["C-k"]
    "paredit-forward-kill-word": ["M-d"]
    "paredit-backward-kill-word": ["M-DEL"]
    "paredit-forward": ["C-M-f"]
    "paredit-backward": ["C-M-b"]
    "paredit-wrap-round": ["M-("]
    "paredit-splice-sexp": ["M-s"]
    "paredit-splice-sexp-killing-backward": ["M-<up>", "ESC <up>"]
    "paredit-splice-sexp-killing-forward": ["M-<down>", "ESC <down>"]
    "paredit-raise-sexp": ["M-r"]
    "paredit-forward-slurp-sexp": ["C-)", "C-<right>"]
    "paredit-forward-barf-sexp": ["C-}", "C-<left>"]
    "paredit-backward-slurp-sexp": ["C-(", "C-M-<left>", "ESC C-<left>"]
    "paredit-backward-barf-sexp": ["C-{", "C-M-<right>", "ESC C-<left>"]
    "paredit-split-sexp": ["M-S"]
    "paredit-join-sexp": ["M-J"]
  examples: [
      commands: [
        "paredit-open-round"
      ]
      from: "(a b |c d)"
      to: "(a b (|) c d)"
    ,
      commands: [
        "paredit-close-round"
      ]
      from: "(a b |c )"
      to: "(a b c)|"
    ,
      commands: [
        "paredit-close-round"
      ]
      from: "Hello,| world!"
      to: "Hello,)| world!"
    ,
      commands: [
        "paredit-close-round-and-newline"
      ]
      from: "(defun f (x|  ))"
      to: "(defun f (x)\n  |)"
    ,
      commands: [
        "paredit-close-round-and-newline"
      ]
      from: "; (Foo.|"
      to: "; (Foo.)|"
    ,
      commands: [
        "paredit-open-square"
      ]
      from: "(a b |c d)"
      to: "(a b [|] c d)"
    ,
      commands: [
        "paredit-open-square"
      ]
      from: "(foo \"bar |baz\" quux)"
      to: "(foo \"bar [|baz]\" quux)"
    ,
      commands: [
        "paredit-close-square"
      ]
      from: "(define-key keymap [frob|  ] 'frobnicate)"
      to: "(define-key keymap [frob]| 'frobnicate)"
    ,
      commands: [
        "paredit-close-square"
      ]
      from: "; [Bar.|"
      to: "; [Bar.]|"
    ,
      commands: [
        "paredit-doublequote"
      ]
      from: "(frob grovel |full lexical)"
      to: "(frob gravel \"|\" full lexical)"
    ,
      commands: [
        "paredit-doublequote"
      ]
      from: "(foo \"bar |baz\" quux)"
      to: "(foo \"bar \\\"|baz\" quux)"
    ,
      commands: [
        "paredit-meta-doublequote"
      ]
      from: "(foo \"bar |baz\" quux)"
      to: "(foo \"bar baz\"\n     |quux)"
    ,
      commands: [
        "paredit-meta-doublequote"
      ]
      from: "(foo | (bar #\\x \"baz \\\\ quux\") zot)"
      to: "(foo \"| (bar #\\x \"baz \\\\\\\\ quux\\\")\" zot)"
    ,
      commands: [
        "paredit-newline"
      ]
      from: "(let ((n frobbotz)) | (display (+ n 1)\n port))"
      to: "(let ((n frobbotz))\n  (display (+ n 1)\n           port))"
    ,
      commands: [
        "paredit-forward-delete"
      ]
      from: "(quu|x \"zot\")"
      to: "(quu| \"zot\")"
    ,
      commands: [
        "paredit-forward-delete"
      ]
      from: "(quux |\"zot\")"
      to: "(quux \"|zot\")"
    ,
      commands: [
        "paredit-forward-delete"
      ]
      from: "(quux \"|zot\")"
      to: "(quux \"|ot\")"
    ,
      commands: [
        "paredit-backward-delete"
        "paredit-forward-delete"
      ]
      from: "(foo (|) bar)"
      to: "(foo | bar)"
    ,
      commands: [
        "paredit-forward-delete"
      ]
      from: "|(foo bar)"
      to: "(|foo bar)"
    ,
      commands: [
        "paredit-backward-delete"
      ]
      from: "(\"zot\" q|uux)"
      to: "(\"zot\" |uux)"
    ,
      commands: [
        "paredit-backward-delete"
      ]
      from: "(\"zot\"| quux)"
      to: "(\"zot|\" quux)"
    ,
      commands: [
        "paredit-backward-delete"
      ]
      from: "(\"zot|\" quux)"
      to: "(\"zo|\" quux)"
    ,
      commands: [
        "paredit-backward-delete"
        "paredit-forward-delete"
      ]
      from: "(foo (|) bar)"
      to: "(foo | bar)"
    ,
      commands: [
        "paredit-backward-delete"
      ]
      from: "(foo bar)|"
      to: "(foo bar|)"
    ,
      commands: [
        "paredit-kill"
      ]
      from: "(foo bar)|    ; Useless comment!"
      to: "(foo bar)|"
    ,
      commands: [
        "paredit-kill"
      ]
      from: "(|foo bar)   ; Useless comment!"
      to: "(|)   ; Useless comment"
    ,
      commands: [
        "paredit-kill"
      ]
      from: "|(foo bar)   ; Useless line!"
      to: "|"
    ,
      commands: [
        "paredit-kill"
      ]
      from: "(foo \"|bar baz\"\n     quux)"
      to: "(foo \"|\"\n     quux)"
    ,
      commands: [
        "paredit-forward-kill-word"
      ]
      from: "|(foo bar)    ; baz"
      to: "(| bar)    ; baz"
    ,
      commands: [
        "paredit-forward-kill-word"
      ]
      from: "(| bar)   ; baz"
      to: "()    ; |"
    ,
      commands: [
        "paredit-forward-kill-word"
      ]
      from: ";;;| Frobnicate\n(defun frobnicate ...)"
      to: ";;;|\n(defun frobnicate ...)"
    ,
      commands: [
        "paredit-forward-kill-word"
      ]
      from: ";;;|\n(defun frobnicate ...)"
      to: ";;;\n(| frobnicate ...)"
    ,
      commands: [
        "paredit-backward-kill-word"
      ]
      from: "(foo bar)    ; baz\n(quux)|"
      to: "(foo bar)    ; baz\n(|)"
    ,
      commands: [
        "paredit-backward-kill-word"
      ]
      from: "(foo bar)    ; baz\n(|)"
      to: "(foo bar)    ; |\n()"
    ,
      commands: [
        "paredit-backward-kill-word"
      ]
      from: "(foo bar)    ; |\n()"
      to: "(foo |)    ;\n()"
    ,
      commands: [
        "paredit-backward-kill-word"
      ]
      from: "(foo |)    ;\n()"
      to: "(|)    ;\n()"
    ,
      commands: [
        "paredit-forward"
      ]
      from: "(foo |(bar baz) quux)"
      to: "(foo (bar baz)| quux)"
    ,
      commands: [
        "paredit-forward"
      ]
      from: "(foo (bar baz)|)"
      to: "(foo (bar baz))|"
    ,
      commands: [
        "paredit-backward"
      ]
      from: "(foo (bar baz)| quux)"
      to: "(foo |(bar baz) quux)"
    ,
      commands: [
        "paredit-backward"
      ]
      from: "(|(foo) bar)"
      to: "|((foo) bar)"
    ,
      commands: [
        "paredit-wrap-round"
      ]
      from: "(foo |bar baz)"
      to: "(foo (|bar) baz)"
    ,
      commands: [
        "paredit-splice-sexp"
      ]
      from: "(foo (bar| baz) quux)"
      to: "(foo bar| baz quux)"
    ,
      # Example for paredit-splice-sexp-killing-backward
      commands: [
        "paredit-raise-sexp"
        "paredit-splice-sexp-killing-backward"
      ]
      from: "(foo (let ((x 5)) |(sqrt n)) bar)"
      to: "(foo |(sqrt n) bar)"
    ,
      # Not from cheatsheet
      commands: [
        "paredit-splice-sexp-killing-backward"
      ]
      from: "(a (b c| d e) f)"
      to: "(a d e f)"
    ,
      commands: [
        "paredit-splice-sexp-killing-forward"
      ]
      from: "(a (b c| d e) f)"
      to: "(a b c| f)"
    ,
      # Example for paredit-raise-sexp
      commands: [
        "paredit-raise-sexp"
        "paredit-splice-sexp-killing-backward"
      ]
      from: "(dynamic-wind in (lambda () |body) out)"
      to: "(dynamic-wind in |body out)"
    ,
      commands: [
        "paredit-raise-sexp"
      ]
      from: "(dynamic-wind in |body out)"
      to: "|body"
    ,
      commands: [
        "paredit-forward-slurp-sexp"
      ]
      from: "(foo (bar |baz) quux zot)"
      to: "(foo (bar |baz quux) zot)"
    ,
      commands: [
        "paredit-forward-slurp-sexp"
      ]
      from: "(a b ((c| d)) e f)"
      to: "(a b ((c| d) e) f)"
    ,
      commands: [
        "paredit-forward-slurp-sexp"
      ]
      from: "(a b ((c| d) e) f)"
      to: "(a b ((c| d e)) f)"
    ,
      commands: [
        "paredit-forward-barf-sexp"
      ]
      from: "(foo (bar |baz quux) zot)"
      to: "(foo (bar |baz) quux zot)"
    ,
      commands: [
        "paredit-backward-slurp-sexp"
      ]
      from: "(foo bar (baz| quux) zot)"
      to: "(foo (bar baz| quux) zot)"
    ,
      commands: [
        "paredit-backward-slurp-sexp"
      ]
      from: "(a b ((c| d)) e f)"
      to: "(a (b (c| d)) e f)"
    ,
      commands: [
        "paredit-backward-barf-sexp"
      ]
      from: "(foo (bar baz| quux) zot)"
      to: "(foo bar (baz| quux) zot)"
    ,
      commands: [
        "paredit-split-sexp"
      ]
      from: "(hello| world)"
      to: "(hello) (world)"
    ,
      commands: [
        "paredit-split-sexp"
      ]
      from: "\"Hello, |world!\""
      to: "\"Hello, \" |\"world!\""
    ,
      commands: [
        "paredit-join-sexp"
      ]
      from: "(hello)| (world)"
      to: "(hello| world)"
    ,
      commands: [
        "paredit-join-sexp"
      ]
      from: "\"Hello, \"| \"world!\""
      to: "\"Hello, |world!\""
    ,
      commands: [
        "paredit-join-sexp"
      ]
      from: "hello-\n|  world"
      to: "hello-|world"
  ]
