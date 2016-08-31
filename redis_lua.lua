--
-- Created by IntelliJ IDEA.
-- User: gary
-- Date: 16-8-29
-- Time: 下午11:39
-- To change this template use File | Settings | File Templates.
package.path = "/usr/local/openresty/lualib/resty/?.lua;"
local redis = require "redis"
local cache = redis.new();
cache:set_timeout(60000)
-- ok = 1 err = nil
local ok,err = cache.connect(cache,"127.0.0.1","6379");
if(not err and ok == 1) then
    cache:lpush("logs_tgit",ngx.var.u_logs);
else
    ngx.say("redis connect fail!")
end




