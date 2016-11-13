# Paredit Quiz

(Better name to be determined.)

This is a simple web application for building proficiency with [Paredit](https://www.emacswiki.org/emacs/ParEdit) (for Lisp, with default Emacs keyboard shortcuts) in a quiz format.

The app will present you with a series of questions (in random order). A question has two snippets of Lisp code, with the current cursor position indicated. The goal is to get from the first code snippet (`transform this`) to the second (`to this`) using a single Paredit.

By default, the Meta key (`M-`) corresponds to whatever key sets the [`altKey`](https://developer.mozilla.org/en-US/docs/Web/API/KeyboardEvent/altKey) property for a keyboard event in your browser. The Ctrl key (`C-`) is triggered by the [`ctrlKey`](https://developer.mozilla.org/en-US/docs/Web/API/KeyboardEvent/ctrlKey) property. (You can change this behavior by updating `options.keyBindings` in `index.coffee`.)

The majority of these examples come from the [Paredit Reference Card (pdf)](http://pub.gajendra.net/src/paredit-refcard.pdf), with a couple of additions. Some questions have multiple possible solutions. In this case, any solution is valid.

For a given example, this app checks to see if you've used the command that corresponds to the example in the Reference Card. It does not actually emulate Emacs or Paredit—if a command is listed on the cheatsheet, and it's applicable to an example, it should work; other Paredit commands, or other Emacs commands will not work.

If you find an example that has a keyboard shortcut that doesn't work, please file an issue. (Or, if you have any further examples.)

## Running Locally

Install dependencies:

```
npm install --production
bower install
```

Compile CoffeeScript to JavaScript, SCSS to CSS, and move everything into the build directory:

```
gulp build
```

(If you're actively working on the application, run `gulp watch` to rebuild whenever a source file changes.)

Run using the provided `server.coffee` script, which starts a server and serves the app at `localhost:8081`:

```
# If CoffeeScript is installed globally:
coffee server.coffee

# If CoffeeScript is not installed globally, uncomment and run:
# ./node_modules/coffee-script/bin/coffee server.coffee
```

The app can then be accessed at `http://localhost:8081/app`.
