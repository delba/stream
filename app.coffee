express = require 'express'
engines = require 'consolidate'

fs = require 'fs'

app = express()

app.engine 'eco', engines.eco
app.set 'view engine', 'eco'
app.use express.bodyParser()
app.use express.static(__dirname + '/public')

videos = require './controllers/videos'

app.get  '/', videos.index
app.post '/', videos.create

app.listen 3000
