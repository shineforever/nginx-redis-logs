/**
 * Created by gary on 16-8-10.
 */
var config = {
    image_src:"http://192.168.1.9:9099/1",
};

var $ = function(id){
    return document.getElementById(id);
}

// {un:"",sid:"",d:"",o:"",r:"",rf:"",t:"",ru:"",}
// 传入不定参数
var path_helper = function(){
    var args = eval(arguments[0]);
    console.log(args);
    var args_ = [];
    for(var arg in args){
        args_.push(parseToQueryString(arg,(args[arg] == "" || typeof args[arg] == "undefined")?"":args[arg]));
    }
    return args_.join("&");
};

// get platform os
var platform = function(){
    var sUserAgent = navigator.userAgent;
    var isWin = (navigator.platform == "Win32") || (navigator.platform == "Windows");
    var isMac = (navigator.platform == "Mac68K") || (navigator.platform == "MacPPC") ||
        (navigator.platform == "Macintosh") || (navigator.platform == "MacIntel");
    if (isMac) return "Mac";
    var isUnix = (navigator.platform == "X11") && !isWin && !isMac;
    if (isUnix) return "Unix";
    var isLinux = (String(navigator.platform).indexOf("Linux") > -1);
    if (isLinux) return "Linux";
    if (isWin) {
        var isWin2K = sUserAgent.indexOf("Windows NT 5.0") > -1 || sUserAgent.indexOf("Windows 2000") > -1;
        if (isWin2K) return "Win2000";
        var isWinXP = sUserAgent.indexOf("Windows NT 5.1") > -1 || sUserAgent.indexOf("Windows XP") > -1;
        if (isWinXP) return "WinXP";
        var isWin2003 = sUserAgent.indexOf("Windows NT 5.2") > -1 || sUserAgent.indexOf("Windows 2003") > -1;
        if (isWin2003) return "Win2003";
        var isWinVista= sUserAgent.indexOf("Windows NT 6.0") > -1 || sUserAgent.indexOf("Windows Vista") > -1;
        if (isWinVista) return "WinVista";
        var isWin7 = sUserAgent.indexOf("Windows NT 6.1") > -1 || sUserAgent.indexOf("Windows 7") > -1;
        if (isWin7) return "Win7";
    }
    return "other";
}
var domain = function(){
    return window.location.hostname;
}
var req_url = function(){
    return window.location.href;
}
var referer = function(){
    return document.referrer;
}
var req_time = function(){
   return new Date().getTime();
}
var parseToQueryString = function(k,v){
    if(k == null || k.length == 0){
        return "";
    }
    if(v == null || v.length == 0){
        return "";
    }
    return k+"="+v;
};

(function(params){
    var image_log = function(config){
        var image = new Image();
        window[config.uid] = image;
        image.onload = image.onerror = function() {
            image.onerror = null;
            image.onload = null;
            delete window[config.uid];
        };
        image.src = config.image_src + "?" + path_helper(params);
    };
    image_log(config);
})({un:"gary",s:"123",d:domain(),o:platform(),rf:referer(),t:req_time(),ru:req_url()});
