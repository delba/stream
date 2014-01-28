Video = require '../models/video'

exports.index = (req, res) ->
  videos = Video.all (err, videos) ->
    throw err if err

    res.render 'videos/index', { videos }

exports.new = (req, res) ->
  if req.current_user
    res.render 'videos/new'
  else
    res.redirect 'login'

exports.create = (req, res) ->
  url = req.body.url

  video = new Video(url: url)

  video.save (err, data) ->
    throw err if err

    res.redirect "/#{data.id}"

exports.show = (req, res) ->
  id = req.params.id

  Video.get id, (err, video) ->
    throw err if err
    res.render 'videos/show', { video }
