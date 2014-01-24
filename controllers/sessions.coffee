exports.new = (req, res) ->
  res.render 'sessions/new'

exports.create = (req, res) ->
  console.log 'login'
  res.redirect '/'

exports.destroy = (req, res) ->
  console.log 'logout'
  res.redirect '/'
