--
-- Created by IntelliJ IDEA.
-- User: gary
-- Date: 16-8-15
-- Time: 下午6:38
package.path = "/home/gary/code/nginx-redis/?.lua";
local RecordLogsConstants = require("RecordLogsConstants");
local recordLogsUtils = require("recordLogsUtils");
local recordModule = {};

function recordModule:parse_module_by_domain(domain)
    -- 部分未实现
    return recordLogsUtils:get_val_from_nginx(domain,RecordLogsConstants.PARAMS);
end
return recordModule:parse_module_by_domain(ngx.arg[1]);
