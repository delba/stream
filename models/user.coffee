bcrypt = require 'bcrypt'
redis  = require 'redis'

client = redis.createClient()

class User
  @getByName: (name, cb) ->
    @getId name, (err, id) =>
      return cb(err) if err
      @get id, cb

  @getId: (name, cb) ->
    client.get "users:id:#{name}", cb

  @get: (id, cb) ->
    client.hgetall "users:#{id}", (err, user) ->
      return cb(err) if err
      cb(null, new User(user))

  @authenticate: (name, password, cb) ->
    @getByName name, (err, user) ->
      return cb(err) if err
      return cb() unless user.id
      bcrypt.hash password, user.salt, (err, hash) ->
        return cb(err) if err
        if hash is user.password
          return cb(null, user)
        cb()

  constructor: (attributes) ->
    for key, value of attributes
      this[key] = value

  save: (cb) ->
    if @id
      @update(cb)
    else
      client.incr 'users:uid', (err, id) =>
        return cb(err) if err
        @id = id
        @hashPassword (err) =>
          return cb(err) if err
          @update(cb)

  update: (cb) ->
    client.set "users:id:#{@name}", @id, (err, res) =>
      return cb(err) if err
      client.hmset "users:#{@id}", this, (err, res) =>
        return cb(err) if err
        cb(null, this)

  hashPassword: (cb) ->
    bcrypt.genSalt 12, (err, salt) =>
      return cb(err) if err
      @salt = salt
      bcrypt.hash @password, @salt, (err, hash) =>
        return cb(err) if err
        @password = hash
        cb()

module.exports = User
