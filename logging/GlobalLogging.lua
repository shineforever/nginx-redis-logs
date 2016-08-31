--
-- Created by IntelliJ IDEA.
-- User: gary
-- Date: 16-8-24
-- Time: 下午4:14
-- To change this template use File | Settings | File Templates.

local gvs = ngx.shared.global_vars;
gvs:set("last_check_date", 0);
gvs:set("datestamp","");