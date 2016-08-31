--
-- Created by IntelliJ IDEA.
-- User: gary
-- Date: 16-8-8
-- Time: 下午8:20
package.path = "/home/gary/code/nginx-redis/?.lua";
recordLogsUtils = {};
local RecordLogsConstants = require("RecordLogsConstants");
local json = require("cjson");

-- check_null
function recordLogsUtils:check_null(attr)
    -- nil
    if(attr == RecordLogsConstants.NIL) then
        return true;
    end
    -- type string
    if(type(attr) == RecordLogsConstants.STRING) then
        return ((#attr ~= 0) and {false} or {true})[1];
    end
    -- type table
    if(type(attr) == RecordLogsConstants.TABLE) then
        return ((self:table_length(attr) ~= 0) and {false} or {true})[1];
    end
end


-- table_length
function recordLogsUtils:table_length(tb)
    if(tb == RecordLogsConstants.NIL) then
        return 0;
    else
        local _len = 0;
        for k,v in pairs(tb) do
            _len = _len + 1;
        end;
        return _len;
    end
end

-- format time
function recordLogsUtils:get_format_time(time,format)
    if(self:check_null(tostring(time))) then
        time = os.time();
    end
    if(type(time) == RecordLogsConstants.STRING) then
        time = tonumber(time);
    end
    return os.date(format,time);
end

-- get_request_params
function recordLogsUtils:get_request_params(request)
    return request.get_uri_args();
end

-- redirect_with_code
function recordLogsUtils:redirect_with_code(redirect,url,code)
    redirect(url,code);
end

-- checkIsReferer
function recordLogsUtils:checkIsReferer(request,name)
    local head_val = request.get_headers()[name];
    if(self:check_null(head_val)) then
        -- forbidden
        self:redirect_with_code(RecordLogsConstants.REDIRECT,
        RecordLogsConstants.ERROR,RecordLogsConstants.REDIRECT_CODE);
    end
end

-- unused
function recordLogsUtils:insert_table(tb,k,v)
    if(self:check_null(tb)) then
        tb = {};
    end
    tb[k] = v;
    return tb;
end

-- insert ele into tb
function recordLogsUtils:insert_list(tb,v)
    table.insert(tb,v);
    return tb;
end

-- list = {k=v,k=v,k=v,k=v,k=v}
function recordLogsUtils:contains_in_list(tb,val)
    if(self:check_null(tb)) then
        return false;
    end
    for k,v in pairs(tb) do
        if(val == k) then
            return true;
        end
    end
    return false;
end

-- get sepecific value by name from nginx
function recordLogsUtils:get_val_from_nginx(arg_name,params)
    if(self:check_null(arg_name)) then
        return RecordLogsConstants.NIL;
    end
    return params[arg_name];
end

-- parse table structure to string
function recordLogsUtils:parseTableToStringWithSeperator(tb,seperator)
    if(self:check_null(tb)) then
        return "";
    end
    seperator = ((self:check_null(seperator)) and {RecordLogsConstants.SPACE} or {seperator})[1];
    return table.concat(tb,seperator);
end

-- get net type (目前未进行具体判断)
function recordLogsUtils:get_net_type()
    return "internal";
end

-- get business name(目前未进行具体判断)
function recordLogsUtils:get_business_name()
   return "TGIT";
end

function recordLogsUtils:get_ext_json()
    local ext_json = {business=self:get_business_name()};
    return json.encode(ext_json);
end

function recordLogsUtils:string_contains_info(info,key)
    local start,end_idx = string.find(info,key);
    if(self:check_null(start) or self:check_null(end_idx)) then
        return false;
    else
        return true;
    end
end

-- string split method
-- str 中如果没有 delimiter 则直接返回str
function recordLogsUtils:string_split(str,delimiter)
    if(self:check_null(str)) then
        return RecordLogsConstants.NIL;
    end
    delimiter = delimiter or RecordLogsConstants.SPACE;
    local regx = string.format(RecordLogsConstants.SPLIT_REGX,delimiter);
    local result = {};

    string.gsub(str,regx,function(ele)
        result[#result+1] = ele;
    end);
    return result;
end

-- 判断是否需要加引号（内容空格区分）
function recordLogsUtils:insert_content_by_quotes(tb,args_name,val)
    local params_ = self:string_split(args_name,RecordLogsConstants.AND_CHAR);
    if(#params_ == 2) then
        self:insert_list(tb,RecordLogsConstants.QUOTES..val..RecordLogsConstants.QUOTES);
    else
        self:insert_list(tb,val);
    end
end

function recordLogsUtils:printMap(tb)
    if(type(tb) ~= RecordLogsConstants.TABLE) then
        return;
    end
    for k,v in pairs(tb) do
        if(type(v) == RecordLogsConstants.TABLE) then
            self:printMap(v);
        else
            ngx.say(k,":",v);
        end
    end
end

return recordLogsUtils;


