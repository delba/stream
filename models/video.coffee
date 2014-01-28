oembed = require 'oembed-auto'
redis  = require 'redis'
client = redis.createClient()

class Video
  @all: (fn) ->
    client.lrange 'videos:ids', 0, -1, (err, ids) ->
      return fn(err) if err

      multi = client.multi()

      multi.hgetall "videos:#{id}" for id in ids

      multi.exec (err, videos) ->
        return fn(err) if err
        fn(null, videos)

  @getByUrl: (url, fn) ->
    @getId url, (err, id) =>
      return fn(err) if err
      @get id, fn

  @getId: (url, fn) ->
    client.get "videos:id:#{url}", fn

  @get: (id, fn) ->
    client.hgetall "videos:#{id}", (err, video) ->
      return fn(err) if err
      fn(null, new Video(video))

  constructor: (attributes) ->
    for key, value of attributes
      this[key] = value

  save: (fn) ->
    client.sismember "videos:urls", @url, (err, exists) =>
      if exists
        Video.getByUrl @url, (err, video) ->
          if err then fn(err) else fn(null, video)
      else
        oembed @url, (err, data) =>
          return fn(err) if err

          client.incr 'videos:uid', (err, id) =>
            [data.id, data._url] = [id, @url]

            client.hmset "videos:#{id}", data, (err, status) ->
              return fn(err) if err

              multi = client.multi()

              multi.set   "videos:id:#{data._url}", id
              multi.sadd  "videos:urls", data._url
              multi.lpush "videos:ids", id

              multi.exec (err, responses) ->
                fn(null, data)

module.exports = Video
