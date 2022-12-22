redis_port = Settings.redis.port
redis_host = Settings.redis.host
$redis = Redis.new(host: redis_host , port: redis_port)
puts "Redis: will try to init on : redis://#{ redis_host }:#{ redis_port }!".cyan
