User = require '../models/user'

exports.new = (req, res) ->
  res.render 'users/new'

exports.create = (req, res) ->
  username = req.body.username
  password = req.body.password

  User.getByName username, (err, user) ->
    return next(err) if err

    if user.id
      res.render 'users/new',
        error: 'Username already taken'
    else
      user = new User
        name: username
        password: password
      user.save (err) ->
        return next(err) if err
        req.session.user_id = user.id
        res.redirect '/'
