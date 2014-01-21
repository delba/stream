oembed = require 'oembed-auto'

Video = require '../models/video'

exports.index = (req, res) ->
  videos = Video.all (err, videos) ->
    throw err if err

    res.render 'index',
      videos: videos

exports.create = (req, res) ->
  url = req.body.url

  oembed url, (err, data) ->
    throw(err) if err

    data._url = url

    Video.create data, (err, data) ->
      res.json data
