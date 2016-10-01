express = require("express")
proxy = require("express-http-proxy")
morgan = require("morgan")
path = require("path")
url = require("url")

startServer = () ->
  server = express()

  staticPath = path.join(__dirname, "build/static/")
  indexPath = path.join(__dirname, "build/index.html")

  # Logging
  server.use(morgan("combined"))

  # Serve index.html
  server.get /^\/app/, (request, response) ->
    response.sendFile(indexPath)

  # Serve static files
  server.use("/static", express.static(staticPath))

  # API passthrough
  server.use("/api", proxy("localhost:8080"))

  listener = server.listen 8081, () ->
    console.log("Listening on port: #{listener.address().port}")

startServer()
