User = require '../models/user'

exports.new = (req, res) ->
  res.render 'users/new'

exports.create = (req, res) ->
  username = req.body.username
  password = req.body.password

  console.log username, password

  res.redirect '/'
