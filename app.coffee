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
app.use express.cookieParser()
app.use express.session(secret: 'secretpassword123')

if 'development' is app.get('env')
  app.use express.errorHandler()

videos = require './controllers/videos'
users  = require './controllers/users'

app.get  '/',         videos.index
app.post '/',         videos.create
app.get  '/register', users.new
app.post '/register', users.create
app.get  '/:id',      videos.show

app.listen app.get('port'), ->
  console.log "Viddit listening on port #{app.get('port')}!"
