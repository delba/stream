oembed = require 'oembed-auto'
redis  = require 'redis'
client = redis.createClient()

# video:uid  => [key, value] counter to generate unique id
# video:ids  => [list] video ids
# video:<id> => [multiple hash] video
# video:urls => [set] video urls
# video:url:<url> => [key, value] video id

class Video
  @all: (fn) ->
    client.lrange 'video:ids', 0, -1, (err, ids) ->
      fn(err) if err

      multi = client.multi()

      for id in ids
        multi.hgetall "video:#{id}"

      multi.exec (err, videos) ->
        fn(null, videos)

  @find_or_create_by_url: (url, fn) ->
    client.sismember 'video:urls', url, (err, exists) =>
      if exists
        @find_by_url url, (err, video) ->
          if err then fn(err) else fn(null, video)
      else
        @create_by_url url, (err, video) ->
          if err then fn(err) else fn(null, video)

  @find_by_url: (url, fn) ->
    client.get "video:url:#{url}", (err, id) ->
      fn(err) if err
      client.hgetall "video:#{id}", (err, video) ->
        fn(err) if err
        fn(null, video)

  @create_by_url: (url, fn) ->
    oembed url, (err, data) ->
      fn(err) if err

      client.incr 'video:uid', (err, id) ->
        [data.id, data._url] = [id, url]

        client.hmset "video:#{id}", data, (err, status) ->
          fn(err) if err

          client.set "video:url:#{data._url}", id, redis.print
          client.sadd 'video:urls', data._url, redis.print
          client.lpush 'video:ids', id, redis.print

          fn(null, data)

module.exports = Video
