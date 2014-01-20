oembed = require 'oembed-auto'
Video  = require '../models/video'

exports.index = (req, res) ->
  videos = Video.find({}).sort('-date').exec (err, videos) ->
    throw(err) if err

    res.render 'index',
      videos: videos

exports.create = (req, res) ->
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
    , (err, video) ->
      throw(err) if err

      res.json video.toObject()
