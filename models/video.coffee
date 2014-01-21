redis  = require 'redis'
client = redis.createClient()

class Video
  @all: (fn) ->
    client.smembers 'videos', (err, urls) ->
      fn(err) if err

      multi = client.multi()

      for url in urls
        multi.hgetall "videos:#{url}"

      multi.exec (err, videos) ->
        fn(null, videos)

  @create: (data, fn) ->
    client.hmset "videos:#{data._url}", data, (err, status) ->
      fn(err) if err

      if status is 'OK'
        client.sadd 'videos', data._url, redis.print
        fn(null, data)

module.exports = Video
