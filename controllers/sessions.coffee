User = require '../models/user'

exports.new = (req, res) ->
  res.render 'sessions/new'

exports.create = (req, res) ->
  username = req.body.username
  password = req.body.password

  User.authenticate username, password, (err, user) ->
    return next(err) if err
    if user
      req.session.user_id = user.id
      res.redirect '/'
    else
      res.render 'sessions/new',
        error: 'Sorry! Invalid credentials.'

exports.destroy = (req, res) ->
  req.session.destroy (err) ->
    throw(err) if err
    res.redirect '/'
