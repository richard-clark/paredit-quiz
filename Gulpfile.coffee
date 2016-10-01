coffeeify = require("gulp-coffeeify")
gulp = require("gulp")
scss = require("gulp-sass")

# If these start with `./`, `gulp.watch` doesn't recognize new files.
SRC =
  FONTS: "bower_components/open-sans-fontface/fonts/**/*.{eot,svg,ttf,woff,woff2}"
  HTML_MAIN: "src/*.html"
  JS: "src/**/*.coffee"
  JS_MAIN: "src/index.coffee"
  SCSS: "src/**/*.scss"
  SCSS_MAIN: "src/main.scss"

gulp.task "build", [
  "fonts"
  "html"
  "js"
  "scss"
]

gulp.task "fonts", () ->
  gulp.src(SRC.FONTS)
    .pipe(gulp.dest("./build/static/fonts"))

gulp.task "html", () ->
  gulp.src(SRC.HTML_MAIN)
    .pipe(gulp.dest("./build"))

gulp.task "js", () ->
  gulp.src(SRC.JS_MAIN)
    .pipe coffeeify
      options: {}
    .pipe(gulp.dest("./build/static"))

gulp.task "scss", () ->
  gulp.src(SRC.SCSS_MAIN)
    .pipe(scss().on("error", scss.logError))
    .pipe(gulp.dest("./build/static"))

gulp.task "watch", ["build"], () ->
  gulp.watch(SRC.HTML_MAIN, ["html"])
  gulp.watch(SRC.JS, ["js"])
  gulp.watch(SRC.SCSS, ["scss"])
