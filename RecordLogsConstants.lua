--
-- Created by IntelliJ IDEA.
-- User: gary
-- Date: 16-8-8
-- Time: 下午8:24
RecordLogsConstants = {};
RecordLogsConstants.TIME_FORMAT = "%Y-%m-%d %H:%M:%S";
RecordLogsConstants.TABLE = "table";
RecordLogsConstants.NIL = nil;
RecordLogsConstants.STRING = "string";
RecordLogsConstants.REQUEST = ngx.req;
RecordLogsConstants.PARAMS = ngx.var;
RecordLogsConstants.REDIRECT = ngx.redirect;
RecordLogsConstants.REDIRECT_CODE = 302;
RecordLogsConstants.SAFE_CHAIN = "referer";
RecordLogsConstants.ERROR = "/error";
RecordLogsConstants.RECORD_LOG = "/recordLog";
RecordLogsConstants.PLACE_HOLDER = "-";
RecordLogsConstants.QUOTES = "'";
RecordLogsConstants.SPACE = " ";
RecordLogsConstants.BACKSLASH = "/";
RecordLogsConstants.TIME = "t";
RecordLogsConstants.PREFIX_PARAMS = args;
RecordLogsConstants.WITH_QUOTES = "1";
RecordLogsConstants.WITHOUT_QUOTES = "0";
RecordLogsConstants.OS_REGX = "%b()"; -- 正则表达式
RecordLogsConstants.SPLIT_REGX = "([^%s]+)";
RecordLogsConstants.AND_CHAR = "&";

-- 记录日志所需要的字段
RecordLogsConstants.LOG_CONFIG = {
    "tdbank_imp_date",
    "t&q",
    "un",
    "remote_addr", --client_ip
    "d", --domain
    "ru&q",
    "query_string&q",
    "request_method", --get or post or ...
    "s", --session id
    "rf", --reference
    "cf", -- come from
    "http_x_requested_with", --requested_type
    "net",
    "o&q", --platform
    "module",
    "module_id",
    "module_val",
    "business",
    "ext_json&q"
}
return RecordLogsConstants;

