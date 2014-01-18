express = require 'express'
engines = require 'consolidate'
oembed  = require 'oembed-auto'

fs = require 'fs'

app = express()

app.engine 'eco', engines.eco

app.set 'view engine', 'eco'

app.use express.bodyParser()
app.use express.static(__dirname + '/public')

Video = require './models/video'

app.get '/', (req, res) ->
  videos = Video.find {}, (err, videos) ->
    res.render 'index',
      videos: videos

app.post '/', (req, res) ->
  url = req.body.url

  oembed url, (err, data) ->
    throw(err) if err

    Video.create
      type: data.type
      version: data.version
      title: data.title
      html: data.html
      height: data.height
      width: data.width
      thumbnail_url: data.thumbnail_url
      thumbnail_height: data.thumbnail_height
      thumbnail_width: data.thumbnail_width
      author_name: data.author_name
      author_url: data.author_url
      provider_name: data.provider_name
      provider_url: data.provider_url
    , (err) ->
      throw(err) if err
      res.redirect '/'

app.listen 3000
