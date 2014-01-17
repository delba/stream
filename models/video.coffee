mongoose = require 'mongoose'
mongoose.connect 'mongodb://localhost/viddit'

schema = new mongoose.Schema
  type: String
  version: String
  title: String
  html: String
  height: Number
  width: Number
  thumbnail_url: String
  thumbnail_height: Number
  thumbnail_width: Number
  author_name: String
  author_url: String
  provider_name: String
  provider_url: String

module.exports = mongoose.model('Video', schema)
