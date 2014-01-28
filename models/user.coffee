bcrypt = require 'bcrypt'
redis  = require 'redis'

client = redis.createClient()

class User
  @getByName: (name, fn) ->
    @getId name, (err, id) =>
      return fn(err) if err
      @get id, fn

  @getId: (name, fn) ->
    client.get "users:id:#{name}", fn

  @get: (id, fn) ->
    client.hgetall "users:#{id}", (err, user) ->
      return fn(err) if err
      fn(null, new User(user))

  @authenticate: (name, password, fn) ->
    @getByName name, (err, user) ->
      return fn(err) if err
      return fn() unless user.id
      bcrypt.hash password, user.salt, (err, hash) ->
        return fn(err) if err
        if hash is user.password
          return fn(null, user)
        fn()

  constructor: (attributes) ->
    for key, value of attributes
      this[key] = value

  save: (fn) ->
    if @id
      @update(fn)
    else
      client.incr 'users:uid', (err, id) =>
        return fn(err) if err
        @id = id
        @hashPassword (err) =>
          return fn(err) if err
          @update(fn)

  update: (fn) ->
    client.set "users:id:#{@name}", @id, (err, res) =>
      return fn(err) if err
      client.hmset "users:#{@id}", this, (err, res) =>
        return fn(err) if err
        fn(null, this)

  hashPassword: (fn) ->
    bcrypt.genSalt 12, (err, salt) =>
      return fn(err) if err
      @salt = salt
      bcrypt.hash @password, @salt, (err, hash) =>
        return fn(err) if err
        @password = hash
        fn()

module.exports = User
