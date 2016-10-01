# Web App Template

A simple web application template with CoffeeScript, SCSS, and Gulp.

This template includes Open Sans, an open-source sans-serif font.

## Usage

Dependencies are installed using npm and Bower. Install using:

```
npm install
bower install
```

Run `gulp build` to compile the various static files that comprise the application. The resulting `build/` directory will contain all files necessary for running the app.

Run `gulp watch` to continuously watch the source files and update the `build/` directory as necessary.

To run this as a stand-alone application, run the `server.coffee` script: this will start a server on `localhost:8081`. (Before you do this, you'll need to install the npm `devDependencies` using `npm install --production`.)

Usage:
```
coffee server.coffee
```

## Gulp

Gulp is a build tool used to transform the various source files into the files served by the web application. The various tasks are described below.

The `build` task (`gulp build`) does the following:

- Copies fonts from `bower_components/` to `build/`.
- Copies `index.html` from `src/` to `build/`.
- Compiles the various CoffeeScript files to a single JavaScript file (`build/static/index.js`), using Coffeeify.
- Compiles the various SCSS files into CSS files, and then combines them into a single file (`build/static/main.css`).
- Converts Angular template HTML files into an Angular module (a JavaScript file) so they can be included in `build/static/index.js`.

The `watch` task (`gulp watch`) invokes the `build` task when first invoked, and then runs any dependent task when one of the `src/` files changes.
