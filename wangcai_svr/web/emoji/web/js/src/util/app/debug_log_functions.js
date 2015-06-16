define("debug_log_functions",[],function(require, exports, module) {
    require('jquery');
    var CommonUtil = require('common_util');

    // instruction
    function DebugLogFunctions() {
        this._init();
    }

    module.exports = DebugLogFunctions;

    //页面

    //数据

    //状态

    DebugLogFunctions.prototype._init = function() {
        return this;
    };

    //////////////////////////////////////////////

    DebugLogFunctions.debugWindowSize = function() {
        var ww = $(window).width();
        var wh = $(window).height();
        var x = $("#view_main_image").offset().left;
        var y = $("#view_main_image").offset().top;
        var pw = $("#view_main_image").width();
        var ph = $("#view_main_image").height();
        var dw = $(document).width();
        var dh = $(document).height();
        var bw = $(document.body).width();
        var bh = $(document.body).height();

        var str = "main_img x:"+x+", y:"+y+", w:"+pw+", h:"+ph+"\n\rwindow w:"+ww+", h:"+wh+"\n\rdocument w:"+dw+", h:"+dh+"\n\rbody w:"+bw+", h:"+bh;
        var str = str + " " +document.getElementById('view_main_image').outerHTML;
        var str = str + " w:" +$('#view_main_image').css("width");
        var str = str + " mw:" +$('#view_main_image').css("max-width");
        CommonUtil.debugLog(str);
        //CommonUtil.debugLog(document.getElementsByTagName('html')[0].innerHTML);
    };

    DebugLogFunctions.debugWindowSizeDetail = function() {
        var str = "";
        str = str + DebugLogFunctions._getItemRectStr(window);
        str = str + "  ***  ";
        str = str + DebugLogFunctions._getItemRectStr(document);
        str = str + "  ***  ";
        str = str + DebugLogFunctions._getItemRectStr(document.body);
        str = str + "  ***  ";
        str = str + DebugLogFunctions._getItemRectStr("#view_bg");
        str = str + "  ***  ";
        str = str + DebugLogFunctions._getItemRectStr("#view_main");
        str = str + "  ***  ";
        str = str + DebugLogFunctions._getItemRectStr("#view_edit");
        str = str + "  ***  ";
        str = str + DebugLogFunctions._getItemRectStr("#view_edit_text_container");
        str = str + "  ***  ";
        str = str + DebugLogFunctions._getItemRectStr("#view_edit_text");
        str = str + "  ***  ";
        str = str + DebugLogFunctions._getItemRectStr("#view_edit_text_bg_img");
        str = str + "  ***  ";
        str = str + DebugLogFunctions._getItemRectStr("#view_edit_text_edit_btn_img");
        str = str + "  ***  ";
        str = str + DebugLogFunctions._getItemRectStr("#view_edit_text_clear_btn_img");
        str = str + "  ***  ";
        CommonUtil.debugLog(str);
        //CommonUtil.debugLog(document.getElementsByTagName('html')[0].innerHTML);
    };

    DebugLogFunctions._getItemRectStr = function(item_id) {
        var x = 0;
        var y = 0

        if(item_id != window && item_id != document)
        {
            x = $(item_id).offset().left;
            y = $(item_id).offset().top;
        }

        var w = $(item_id).width();
        var h = $(item_id).height();

        if(item_id == document)
        {
            item_id = "document"
        }
        else if(item_id == window)
        {
            item_id = "window"
        }
        else if(item_id == document.body)
        {
            item_id = "body"
        }

        var str = DebugLogFunctions._getFormatedRectItemStr(item_id,x,y,w,h);

        return str;
    };

    DebugLogFunctions._getFormatedRectItemStr = function(itemNameStr,x,y,w,h) {
        var str = "[[[[ (" + itemNameStr + ") ";
        if(x != null && x != undefined)
        {
            str = str + "x:"+x+"; ";
        }
        if(y != null && y != undefined)
        {
            str = str + "y:"+y+"; ";
        }
        if(w != null && w != undefined)
        {
            str = str + "w:"+w+"; ";
        }
        if(h != null && h != undefined)
        {
            str = str + "h:"+h+"; ";
        }
        str = str+"]]]]";

        return str;
    };

    DebugLogFunctions.debugUserAgents = function() {
        var str = navigator.userAgent;
        CommonUtil.debugLog(str);
        //CommonUtil.debugLog(document.getElementsByTagName('html')[0].innerHTML);
    };
});