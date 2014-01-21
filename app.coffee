express = require 'express'
engines = require 'consolidate'

fs = require 'fs'

app = express()

app.engine 'eco', engines.eco
app.set 'view engine', 'eco'
app.set 'port', process.env.PORT or 3000

app.use express.favicon()
app.use express.logger('dev')
app.use express.bodyParser()
app.use express.static(__dirname + '/public')

if 'development' is app.get('env')
  app.use express.errorHandler()

videos = require './controllers/videos'

app.get  '/',    videos.index
app.post '/',    videos.create
app.get  '/:id', videos.show

app.listen app.get('port'), ->
  console.log "Viddit listening on port #{app.get('port')}!"
