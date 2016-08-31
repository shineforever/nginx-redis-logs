--
-- Created by IntelliJ IDEA.
-- User: gary
-- Date: 16-8-8
-- Time: 下午2:14
--

package.path = "/home/gary/code/nginx-redis/?.lua";
local RecordLogsConstants = require("RecordLogsConstants");
local recordLogsUtils = require("recordLogsUtils");
local logging = require("LoggingRotate");
local Logs = {};


function Logs.record_logs(params)
    local result = {};
    for k,v in pairs(RecordLogsConstants.LOG_CONFIG) do

        local param_ = recordLogsUtils:string_split(v,RecordLogsConstants.AND_CHAR);

        -- 如果参数可以从 ngx请求参数中获取
        if(recordLogsUtils:contains_in_list(params,param_[1])) then
            recordLogsUtils:insert_content_by_quotes(result,v,params[param_[1]]);
        -- 如果参数可以从 ngx 变量中进行获取
        else if(recordLogsUtils:check_null(recordLogsUtils:get_val_from_nginx(param_[1],RecordLogsConstants.PARAMS)) ~= true) then
            recordLogsUtils:insert_content_by_quotes(result,v,recordLogsUtils:
            get_val_from_nginx(param_[1],RecordLogsConstants.PARAMS));
        -- 如果既不能从 ngx变量中获取，同时也不能从请求参数中获取，就要考虑特殊字段
        else if(param_[1] == "net") then
            recordLogsUtils:insert_content_by_quotes(result,v,recordLogsUtils:get_net_type());
        else if(param_[1] == "business") then
            recordLogsUtils:insert_content_by_quotes(result,v,recordLogsUtils:get_business_name());
        else if(param_[1] == "ext_json") then
            recordLogsUtils:insert_content_by_quotes(result,v,recordLogsUtils:get_ext_json());
        else
            recordLogsUtils:insert_list(result,RecordLogsConstants.PLACE_HOLDER);
        end
        end
        end
        end
        end
    end
    return recordLogsUtils:parseTableToStringWithSeperator(result,RecordLogsConstants.SPACE);
end

function Logs.start()
    --recordLogsUtils:checkIsReferer();
    
    local params = recordLogsUtils:get_request_params(RecordLogsConstants.REQUEST);
    local time = params[RecordLogsConstants.TIME];
    local access_time;

    -- use redis （os.date() is dequeue time but not client access time)
    -- prevent time is not number type
    if(time == "" or time == nil or tonumber(time) == nil) then
            access_time = recordLogsUtils:get_format_time(os.time(),RecordLogsConstants.TIME_FORMAT);
    else
            access_time = recordLogsUtils:get_format_time(tonumber(time)/1000,RecordLogsConstants.TIME_FORMAT)
    end

    params = recordLogsUtils:insert_table(params,RecordLogsConstants.TIME,access_time);
    return Logs.record_logs(params);
end;

return Logs.start();