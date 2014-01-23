bcrypt = require 'bcrypt'
redis  = require 'redis'

client = redis.createClient()

class User
  @getByName: (name, callback) ->
    @getId name, (err, id) =>
      return callback(err) if err
      @get id, callback

  @getId: (name, callback) ->
    client.get "users:id:#{name}", callback

  @get: (id, callback) ->
    client.hgetall "users:#{id}", (err, user) ->
      return callback(err) if err
      callback(null, new User(user))

  @authenticate: (name, password, callback) ->
    @getByName name, (err, user) ->
      return callback(err) if err
      return callback() unless user.id
      bcrypt.hash password, user.salt, (err, hash) ->
        return callback(err) if err
        if hash is user.password
          return callback(null, user)
        callback()

  constructor: (attributes) ->
    for key, value of attributes
      this[key] = value

  save: (callback) ->
    if @id
      @update(callback)
    else
      client.incr 'users:uid', (err, id) =>
        return callback(err) if err
        @id = id
        @hashPassword (err) =>
          return callback(err) if err
          @update(callback)

  update: (callback) ->
    client.set "users:id:#{@name}", @id, (err, res) =>
      return callback(err) if err
      client.hmset "users:#{@id}", this, (err, res) =>
        return callback(err) if err
        callback(null, this)

  hashPassword: (callback) ->
    bcrypt.genSalt 12, (err, salt) =>
      return callback(err) if err
      @salt = salt
      bcrypt.hash @password, @salt, (err, hash) =>
        return callback(err) if err
        @password = hash
        callback()

module.exports = User
