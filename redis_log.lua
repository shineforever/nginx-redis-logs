--
-- Created by IntelliJ IDEA.
-- User: gary
-- Date: 16-9-1
-- Time: 上午1:14

package.path = "/usr/local/openresty/lualib/resty/?.lua;/home/gary/code/nginx-redis/?.lua"
local redis = require "redis"
local logging = require "LoggingRotate";
local cache = redis.new();
cache:set_timeout(60000)
-- ok = 1 err = nil
local ok,err = cache.connect(cache,"127.0.0.1","6379");
if(not err and ok == 1) then
    local logs_record = cache:brpop("logs_tgit",0);
    logging:log(logs_record[2]);
else
    ngx.say("redis connect fail!")
end
