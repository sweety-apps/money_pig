define("common_util",[],function(require, exports, module) {
    require('jquery');
    require('iscroll');

    // browser类型
    CommonUtil.COMMON_BROWSER_TYPE_CHROME = "Chrome";
    CommonUtil.COMMON_BROWSER_TYPE_SAFARI = "Safari";
    CommonUtil.COMMON_BROWSER_TYPE_FIREFOX = "Firefox";
    CommonUtil.COMMON_BROWSER_TYPE_OPERA = "Opera";
    CommonUtil.COMMON_BROWSER_TYPE_IE = "IE";
    CommonUtil.COMMON_BROWSER_TYPE_NONE = "none";

    // browser子类型
    CommonUtil.COMMON_BROWSER_SUB_TYPE_MQQBROWSER = "mqqbroswer";
    CommonUtil.COMMON_BROWSER_SUB_TYPE_NONE = "none";

    // 哪个APP打开的
    CommonUtil.COMMON_WRAPPER_APP_TYPE_WECHAT = "wechat";
    CommonUtil.COMMON_WRAPPER_APP_TYPE_QQ = "QQ";
    CommonUtil.COMMON_WRAPPER_APP_TYPE_WEIBO = "weibo";
    CommonUtil.COMMON_WRAPPER_APP_TYPE_NONE = "none";

    // 设备类型
    CommonUtil.COMMON_DEVICE_TYPE_IPAD = "iPad";
    CommonUtil.COMMON_DEVICE_TYPE_IPHONE = "iPhone";
    CommonUtil.COMMON_DEVICE_TYPE_ANDROID = "Android";
    CommonUtil.COMMON_DEVICE_TYPE_WINDOWS_MOBILE = "Windows Mobile";
    CommonUtil.COMMON_DEVICE_TYPE_MACOSX = "Mac";
    CommonUtil.COMMON_DEVICE_TYPE_LINUX = "Linux";
    CommonUtil.COMMON_DEVICE_TYPE_WINDOWS = "Windows";
    CommonUtil.COMMON_DEVICE_TYPE_NONE = "none";

    //变量
    var gBrowser = null;    //浏览器类型和版本
    var gWrapperAppType = null; //哪个APP打开的
    var gDeviceType = null; //设备类型
    var gItemsAttrAndVHValueDict = null; //动态调整属性到vh单位，防iOS微信浏览器bug
    var gItemsAttrAndVWValueDict = null; //动态调整属性到vw单位，防android微信的QQ浏览器bug
    var gItemsAttrAndVMINValueDict = null; //动态调整属性到vmin单位
    var gItemsAttrAndVMAXValueDict = null; //动态调整属性到vmax单位
    var gFixedWindowWidth = null; //静态化窗口宽度，同上，防BUG
    var gFixedWindowHeight = null; //静态化窗口高度度，同上，防BUG
    var gFixedVWVHEnabled = false;
    var gIScrollItemDict = null; //储存使用iScroll的元素

    document.addEventListener('touchmove', function (e) { e.preventDefault(); }, false);

    function CommonUtil()
    {
        this._init();
    };

    module.exports = CommonUtil;

    CommonUtil.prototype._init = function() {};

    CommonUtil._initBrowserTypeAndVersion = function() {
        if(gBrowser == null || gBrowser == undefined){

            var Sys = {};
            var ua = CommonUtil.getUserAgent().toLowerCase();

            if (window.ActiveXObject)
            {
                Sys.version = ua.match(/msie ([\d.]+)/)[1];
                Sys.type = CommonUtil.COMMON_BROWSER_TYPE_IE;
            }
            else if (document.getBoxObjectFor)
            {
                Sys.version = ua.match(/firefox\/([\d.]+)/)[1];
                Sys.type = CommonUtil.COMMON_BROWSER_TYPE_FIREFOX;
            }
            else if (window.MessageEvent && !document.getBoxObjectFor)
            {
                if(ua.match(/chrome\/([\d.]+)/) != undefined && ua.match(/chrome\/([\d.]+)/) != null)
                {
                    Sys.version = ua.match(/chrome\/([\d.]+)/)[1];
                    Sys.type = CommonUtil.COMMON_BROWSER_TYPE_CHROME;
                }
            }
            else if (window.opera)
            {
                Sys.version = ua.match(/opera.([\d.]+)/)[1];
                Sys.type = CommonUtil.COMMON_BROWSER_TYPE_OPERA;
            }
            else if (window.openDatabase)
            {
                Sys.version = ua.match(/version\/([\d.]+)/)[1];
                Sys.type = CommonUtil.COMMON_BROWSER_TYPE_SAFARI;
            }
            else
            {
                Sys.version = '';
                Sys.type = CommonUtil.COMMON_BROWSER_TYPE_NONE;
            }

            // 子类型
            var subverstr = ua.match(/mqqbrowser\/([\d.]+)/);
            if(subverstr != null && subverstr != undefined && subverstr.length > 0)
            {
                Sys.subtype = CommonUtil.COMMON_BROWSER_SUB_TYPE_MQQBROWSER;
                Sys.subversion = ua.match(/mqqbrowser\/([\d.]+)/)[1];
            }
            else
            {
                Sys.subtype = CommonUtil.COMMON_BROWSER_SUB_TYPE_NONE;
                Sys.subversion = null;
            }

            gBrowser = Sys;
        }
        return gBrowser;
    };

    CommonUtil.getBrowserType = function() {
        CommonUtil._initBrowserTypeAndVersion();
        return gBrowser.type;
    };

    CommonUtil.getBrowserVersion = function() {
        CommonUtil._initBrowserTypeAndVersion();
        return gBrowser.version;
    };

    CommonUtil.getBrowserSubtype = function() {
        CommonUtil._initBrowserTypeAndVersion();
        return gBrowser.subtype;
    };

    CommonUtil.getBrowserSubversion = function() {
        CommonUtil._initBrowserTypeAndVersion();
        return gBrowser.subversion;
    };

    CommonUtil.getUserAgent = function() {
        return navigator.userAgent;
        //return "Mozilla/5.0 (Linux; U; Android 4.3; zh-cn; ZTE Q802T Build/JLS36C) AppleWebKit/533.1 (KHTML, like Gecko)Version/4.0 MQQBrowser/5.4 TBS/025411 Mobile Safari/533.1 MicroMessenger/6.1.0.74_r1098891.543 NetType/WIFI".toLowerCase();
    };

    CommonUtil.getWrapperAppType = function() {

        if(gWrapperAppType == null || gWrapperAppType == undefined){
            var type = null;
            var ua = CommonUtil.getUserAgent().toLowerCase();

            if(ua.match(/MicroMessenger/i)=='micromessenger')
            {
                type = CommonUtil.COMMON_WRAPPER_APP_TYPE_WECHAT;
            }
            else
            {
                type = CommonUtil.COMMON_WRAPPER_APP_TYPE_NONE;
            }

            gWrapperAppType = type;
        }
        return gWrapperAppType;
    };

    CommonUtil.getDeviceType = function() {
        if(gDeviceType == null || gDeviceType == undefined){
            var type = null;
            var ua = CommonUtil.getUserAgent().toLowerCase();

            if(ua.match(/ipad/i) == "ipad") {
                type = CommonUtil.COMMON_DEVICE_TYPE_IPAD;
            }
            else if(ua.match(/iphone os/i) == "iphone os") {
                type = CommonUtil.COMMON_DEVICE_TYPE_IPHONE;
            }
            else if(ua.match(/android/i) == "android") {
                type = CommonUtil.COMMON_DEVICE_TYPE_ANDROID;
            }
            else if(ua.match(/windows mobile/i) == "windows mobile") {
                type = CommonUtil.COMMON_DEVICE_TYPE_WINDOWS_MOBILE;
            }
            else if(ua.indexOf("Window")>0) {
                type = CommonUtil.COMMON_DEVICE_TYPE_WINDOWS;
            }
            else if(ua.indexOf("Mac OS X")>0) {
                type = CommonUtil.COMMON_DEVICE_TYPE_MACOSX;
            }
            else if(ua.indexOf("Linux")>0) {
                type = CommonUtil.COMMON_DEVICE_TYPE_LINUX;
            }
            else {
                type = CommonUtil.COMMON_DEVICE_TYPE_NONE;
            }

            gDeviceType = type;
        }
        return gDeviceType;

    };

    CommonUtil.isBrowserSupportHtml5 = function() {
        if (window.applicationCache) {
            return true;
        } else {
            return false;
        }
    };

    // 静态化vw和vh的值
    CommonUtil.setFixVWVHEnabled = function(enabled) {
        gFixedVWVHEnabled = enabled;
        if(gFixedVWVHEnabled)
        {
            CommonUtil.updateFixedVWVH();
        }
    };

    // 更新静态化vs和vh的值
    CommonUtil.updateFixedVWVH = function() {
        var ww = $(window).width();
        var wh = $(window).height();
        gFixedWindowWidth = ww;
        gFixedWindowHeight = wh;
    };

    // 通用vh转换函数，注：微信iOS浏览器的bug,input获得焦点时，vh会变化
    CommonUtil.setAttributeValueToVHUnit = function(item_id,percentOfHeight, attr) {
        if (gItemsAttrAndVHValueDict == null)
        {
            gItemsAttrAndVHValueDict = {};
            //监听窗口自动设置对象最大宽度

            $(window).resize(function(){
                // 监听窗口变化，调整最大宽度
                $(window).queue(function(){
                    CommonUtil._updateAttributeValueToVHUnit();
                    $(this).dequeue();
                });
                //CommonUtil._updateAttributeValueToVHUnit();
            });
        }
        var array = gItemsAttrAndVHValueDict[item_id];
        if(array == null || array == undefined)
        {
            array = [];
        }
        array[array.length] = {"attr":attr,"value":percentOfHeight};
        gItemsAttrAndVHValueDict[item_id] = array;
    };

    // 通用vw转换函数，注：微信android浏览器使用vw时有bug,vw值不正确
    CommonUtil.setAttributeValueToVWUnit = function(item_id,percentOfWidth, attr) {
        if (gItemsAttrAndVWValueDict == null)
        {
            gItemsAttrAndVWValueDict = {};
            //监听窗口自动设置对象最大宽度

            $(window).resize(function(){
                // 监听窗口变化，调整最大宽度
                $(window).queue(function(){
                    CommonUtil._updateAttributeValueToVWUnit();
                    $(this).dequeue();
                });
                //CommonUtil._updateAttributeValueToVWUnit();
            });
        }
        var array = gItemsAttrAndVWValueDict[item_id];
        if(array == null || array == undefined)
        {
            array = [];
        }
        array[array.length] = {"attr":attr,"value":percentOfWidth};
        gItemsAttrAndVWValueDict[item_id] = array;
    };

    // 通用vmin,使用window宽高最小那个百分比做单位
    CommonUtil.setAttributeValueToVMINUnit = function(item_id,percentOfVMin, attr) {
        if (gItemsAttrAndVMINValueDict == null)
        {
            gItemsAttrAndVMINValueDict = {};
            //监听窗口自动设置对象最大宽度

            $(window).resize(function(){
                // 监听窗口变化，调整最大宽度
                $(window).queue(function(){
                    CommonUtil._updateAttributeValueToVMINUnit();
                    $(this).dequeue();
                });
                //CommonUtil._updateAttributeValueToVMINUnit();
            });
        }
        var array = gItemsAttrAndVMINValueDict[item_id];
        if(array == null || array == undefined)
        {
            array = [];
        }
        array[array.length] = {"attr":attr,"value":percentOfVMin};
        gItemsAttrAndVMINValueDict[item_id] = array;
    };

    // 通用vmax,使用window宽高最大那个百分比做单位
    CommonUtil.setAttributeValueToVMAXUnit = function(item_id,percentOfVMax, attr) {
        if (gItemsAttrAndVMAXValueDict == null)
        {
            gItemsAttrAndVMAXValueDict = {};
            //监听窗口自动设置对象最大宽度

            $(window).resize(function(){
                // 监听窗口变化，调整最大宽度
                $(window).queue(function(){
                    CommonUtil._updateAttributeValueToVMAXUnit();
                    $(this).dequeue();
                });
                //CommonUtil._updateAttributeValueToVMAXUnit();
            });
        }
        var array = gItemsAttrAndVMAXValueDict[item_id];
        if(array == null || array == undefined)
        {
            array = [];
        }
        array[array.length] = {"attr":attr,"value":percentOfVMax};
        gItemsAttrAndVMAXValueDict[item_id] = array;
    };

    // 手动对齐下
    CommonUtil.updateAttributeValueToVHUnit = function() {
        CommonUtil._updateAttributeValueToVHUnit();
    };

    CommonUtil.updateAttributeValueToVWUnit = function() {
        CommonUtil._updateAttributeValueToVWUnit();
    };

    CommonUtil.updateAttributeValueToVMINUnit = function() {
        CommonUtil._updateAttributeValueToVMINUnit();
    };

    CommonUtil.updateAttributeValueToVMAXUnit = function() {
        CommonUtil._updateAttributeValueToVMAXUnit();
    };

    CommonUtil._updateAttributeValueToVWUnit = function() {
        var ww = $(window).width();
        var wh = $(window).height();

        if(gFixedVWVHEnabled)
        {
            ww = gFixedWindowWidth;
            wh = gFixedWindowHeight;
        }

        for(var item_id in gItemsAttrAndVWValueDict)
        {
            var item = $(item_id);
            var array = gItemsAttrAndVWValueDict[item_id];
            var cssval = null;
            for(var i = 0; i < array.length; ++i)
            {
                var dict = array[i];
                var percent = dict["value"];
                var attr_name = dict["attr"];
                var size = ww * percent / 100.0;
                if(cssval == null)
                {
                    cssval = {};
                }
                cssval[attr_name] = ""+size+"px";
            }
            if(item != null && item != undefined && cssval != null)
            {
                item.css(cssval);
            }
        }
    };

    CommonUtil._updateAttributeValueToVHUnit = function() {
        var ww = $(window).width();
        var wh = $(window).height();

        if(gFixedVWVHEnabled)
        {
            ww = gFixedWindowWidth;
            wh = gFixedWindowHeight;
        }

        for(var item_id in gItemsAttrAndVHValueDict)
        {
            var item = $(item_id);
            var array = gItemsAttrAndVHValueDict[item_id];
            var cssval = null;
            for(var i = 0; i < array.length; ++i)
            {
                var dict = array[i];
                var percent = dict["value"];
                var attr_name = dict["attr"];
                var size = wh * percent / 100.0;
                if(cssval == null)
                {
                    cssval = {};
                }
                cssval[attr_name] = ""+size+"px";
            }
            if(item != null && item != undefined && cssval != null)
            {
                item.css(cssval);
            }
        }
    };

    CommonUtil._updateAttributeValueToVMINUnit = function() {
        var ww = $(window).width();
        var wh = $(window).height();

        if(gFixedVWVHEnabled)
        {
            ww = gFixedWindowWidth;
            wh = gFixedWindowHeight;
        }

        var wval = ww;
        if(ww > wh)
        {
            wval = wh;
        }

        for(var item_id in gItemsAttrAndVMINValueDict)
        {
            var item = $(item_id);
            var array = gItemsAttrAndVMINValueDict[item_id];
            var cssval = null;
            for(var i = 0; i < array.length; ++i)
            {
                var dict = array[i];
                var percent = dict["value"];
                var attr_name = dict["attr"];
                var size = wval * percent / 100.0;
                if(cssval == null)
                {
                    cssval = {};
                }
                cssval[attr_name] = ""+size+"px";
            }
            if(item != null && item != undefined && cssval != null)
            {
                item.css(cssval);
            }
        }
    };

    CommonUtil._updateAttributeValueToVMAXUnit = function() {
        var ww = $(window).width();
        var wh = $(window).height();

        if(gFixedVWVHEnabled)
        {
            ww = gFixedWindowWidth;
            wh = gFixedWindowHeight;
        }

        var wval = ww;
        if(ww < wh)
        {
            wval = wh;
        }

        for(var item_id in gItemsAttrAndVMAXValueDict)
        {
            var item = $(item_id);
            var array = gItemsAttrAndVMAXValueDict[item_id];
            var cssval = null;
            for(var i = 0; i < array.length; ++i)
            {
                var dict = array[i];
                var percent = dict["value"];
                var attr_name = dict["attr"];
                var size = wval * percent / 100.0;
                if(cssval == null)
                {
                    cssval = {};
                }
                cssval[attr_name] = ""+size+"px";
            }
            if(item != null && item != undefined && cssval != null)
            {
                item.css(cssval);
            }
        }
    };

    // 最大宽度
    CommonUtil.setMaxWidthForItem = function(item_id,percentOfHeight) {
        CommonUtil.setAttributeValueToVHUnit(item_id,percentOfHeight,"max-width");
    };

    // 字体大小
    CommonUtil.setFontForItem = function(item_id,percentOfHeight) {
        CommonUtil.setAttributeValueToVHUnit(item_id,percentOfHeight,"font-size");
    };

    // 对元素启用iScroll风格滚动条
    CommonUtil.useIScrollType = function(element_mark_for_iscroll_type) {
        if(gIScrollItemDict == null)
        {
            gIScrollItemDict = {};
        }
        var iscroll_obj = gIScrollItemDict[element_mark_for_iscroll_type];
        if(iscroll_obj != null && iscroll_obj != undefined)
        {
            delete iscroll_obj;
        }
        iscroll_obj = new IScroll(element_mark_for_iscroll_type, {
            scrollbars: 'custom',
            mouseWheel: true,
            interactiveScrollbars: true,
            shrinkScrollbars: 'scale',
            fadeScrollbars: true,
            resizeScrollbars: true,
            probeType: 2
        });
        //iscroll_obj
        gIScrollItemDict[element_mark_for_iscroll_type] = iscroll_obj;
        return iscroll_obj;
    };

    // 获得iScroller对象
    CommonUtil.getIScrollTypeUsedObject = function(element_mark_for_iscroll_type) {
        if(gIScrollItemDict == null)
        {
            gIScrollItemDict = {};
        }
        var iscroll_obj = gIScrollItemDict[element_mark_for_iscroll_type];
        return iscroll_obj;
    };

    CommonUtil.debugLog = function(log) {
        $("#view_debug_label").text(""+log);
    };

    CommonUtil.debugLogAdd = function(log) {
        var text = $("#view_debug_label").text();
        $("#view_debug_label").text(text+log);
    };
});
