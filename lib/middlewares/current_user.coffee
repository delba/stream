User = require '../../models/user'

module.exports = (req, res, next) ->
  user_id = req.session.user_id
  return next() unless user_id
  User.get user_id, (err, user) ->
    return next(err) if err
    req.current_user = res.locals.current_user = user
    next()
