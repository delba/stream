Video = require '../models/video'

exports.index = (req, res) ->
  videos = Video.all (err, videos) ->
    throw err if err

    res.render 'videos/index', { videos }

exports.create = (req, res) ->
  url = req.body.url

  Video.find_or_create_by_url url, (err, data) ->
    throw err if err

    res.redirect "/#{data.id}"

exports.show = (req, res) ->
  id = req.params.id

  Video.find req.params.id, (err, video) ->
    throw err if err

    res.render 'videos/show', { video }
