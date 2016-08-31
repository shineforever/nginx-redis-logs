--
-- Date: 16-8-18
-- Time: 上午11:28
-- 1.file configuration
-- 2.in case of deleting the file that is used, we can rebuild the log file.
-- 3.close the unused the memory
package.path = "/home/gary/code/nginx-redis/?.lua";
local function file_is_exists(filename)
    if(io.open(filename,"r+") ~= nil) then
        io.close(io.open(filename,"r+"));
        return true;
    end
    return false;
end

local gvs = ngx.shared.global_vars;

local logging = {
    log_file_ref=nil;
    seperator="/",
    time_format="%Y-%m-%d", --表示时间的格式
    directory="/home/gary/logs_test_cur",
    prefix="tgit_access_log",
    suffix=".log";
    operate_directory_cmd={
        mkdir="mkdir",
        cd="cd"
    },
    -- in case of external log files removement or something other else op
    check_exists=false
};

function logging.log(self,msg)
    logging:rotate();

    if(self.check_exists) then
        -- if file not exists
        if(self.log_file_ref ~= nil and not (file_is_exists(logging:get_log_file_path(false,"")))) then
            -- close current file
            logging:close(false);
            -- set the global variables
            gvs:set("datestamp",os.date(self.time_format,os.time()));
            logging:open(false,"");
        end
    end

    -- rotate self.log_file_ref is not nil
    -- not rotate self.log_file is nil

    -- log message
    if(self.log_file_ref == nil) then
        logging:open(false,"");
    else
        local file_path = logging:get_log_file_path(false,"");
        if(not file_is_exists(file_path)) then
            local file_cur = self.log_file_ref;
            file_cur:close();
            logging:open(false,"");
        end
    end
    local file_ = self.log_file_ref;
    file_:write(msg .. "\n");
    file_:flush();
end

-- if the logging files need to be rotated
function logging.rotate(self)
    -- the current time
    local current_time = os.time();

    if(current_time - tonumber(gvs:get("last_check_date")) > 1) then
        gvs:set("last_check_date",current_time);
        local current_time_log_file = os.date(self.time_format,os.time());
        if(gvs:get("datestamp") ~= current_time_log_file) then
            logging:close(true);
            gvs:set("datestamp",current_time_log_file);
            logging:open(false,"");
        end
    end
end

function logging.close(self,rename)
    -- close the current logging file
    if(not file_is_exists(logging:get_log_file_path(false,""))) then
        -- invoke the first time of logging msg
        return;
    end

    if(rename) then

        local new_file_path = logging:get_log_file_path(true,gvs:get("datestamp"));
        local old_file_path = logging:get_log_file_path(false,"");

        -- new_file_path must not exists
        if(not file_is_exists(new_file_path)) then
            os.rename(old_file_path,new_file_path);
        end
    end
    --    self.datestamp = "";
    gvs:set("datestamp","");
    self.log_file_ref = nil;
end

-- open the outputstream of specific file
function logging.open(self,use_time_stamp,datestamp)
    self.log_file_ref = logging:get_log_file_ref(use_time_stamp,datestamp);
    -- setting the attr of log_file_ref
    io.output(self.log_file_ref);
end

-- get the ref to log_file
-- 1. tgit-access-log.log ref
-- 2. tgit-access-log-datestamp.log ref
function logging.get_log_file_ref(self,use_time_stamp,datestamp)
    local is_exists_directory = os.execute(self.operate_directory_cmd.cd .. " " .. self.directory);
    -- create directory fails
    if(is_exists_directory ~= 0) then
        os.execute(self.operate_directory_cmd.mkdir .. " " .. self.directory);
    end
    -- get the file obj (tgit-access-log.log file)
    local current_log_file_path = logging:get_log_file_path(use_time_stamp);
    local file_ = self.log_file_ref;
    if(file_ == nil) then
        io.close();
        local current_log_file = io.open(current_log_file_path,"a");
        return current_log_file;
    end
    -- 是否存在
    if(not file_is_exists(current_log_file_path)) then
        self.log_file_ref = nil;
        return io.open(current_log_file_path,"a");
    end
    return file_;
end

-- get the tgit-access-log.log or get the tgit-access-log-2016-08-17.log
function logging.get_log_file_name(self,use_time_stamp,datestamp)
    local current_log_file_name = "";
    if(use_time_stamp) then
        current_log_file_name = current_log_file_name .. self.prefix .. "-" ..datestamp .. self.suffix;
    else
        current_log_file_name = current_log_file_name .. self.prefix .. self.suffix;
    end
    return current_log_file_name;
end

--get the absolute path of the log file
--return /home/gary/code/nginx-logs/logs/tgit-access-log.log
function logging.get_log_file_path(self,use_date_stamp,datestamp)
    -- if there is no prefix and suffix to be set,use the default setting
    if(self.prefix == nil or #self.prefix == 0) then
        self.prefix = "tgit-access-log";
    end
    if(self.suffix == nil or #self.suffix == 0) then
        self.suffix = ".log"
    end
    if(self.directory == nil or #self.directory == 0) then
        self.directory = "logs";
    end
    return self.directory .. self.seperator .. logging:get_log_file_name(use_date_stamp,datestamp);
end

return logging;





