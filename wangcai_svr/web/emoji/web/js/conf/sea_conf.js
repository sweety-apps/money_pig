(function(seajs){
    var isDebug = location.href.indexOf("?dev") > 0 ? true : false;

    var usedJSlist = [
        isDebug ? "src/api/api" : "src/api/api-debug",
        "src/util/common/common_util",
        "src/ui_logic/common/common_ui_logic",
        "src/ui/common/common_button",
        "src/ui/common/common_animations",
        "src/ui/common/common_editbox",
        "src/ui/common/common_tips",
        "src/ui/common/common_popbox",
        "src/ui/common/common_slidetabbar",
        "src/ui/common/common_blockflow_div",
        "src/ui/common/common_blockflow_popbox",
        "src/util/app/debug_log_functions",
        "src/ui_logic/app/view_shared_data",
        "src/ui_logic/app/view_main_form_operations",
        "src/ui_logic/app/view_select_pic_form_operations",
        "src/ui_logic/app/view_select_tmp_form_operations",
        "src/ui/app/view_edit",
        "src/ui/app/view_main",
        "src/ui/app/view_save_help",
        "src/ui/app/view_select_pic",
        "src/ui/app/view_select_tmp"
    ];

    if (isDebug) {
        // Set configuration
        seajs.config({
            base:"./js",
            alias: {
                "jquery" : "libs/jquery/jquery-1.11.2.js",
                "jquery.lazyload" : "libs/jquery/jquery.lazyload.js",
                "html5Loader" : "libs/loader/jquery.html5Loader.js",
                "iscroll" : "libs/iscroll/iscroll-probe.js"
            },
            preload: ["jquery"]
        });
        //seajs.use("jquery");
        //seajs.use("html5Loader");

    }
    // For production
    else {
        // Set configuration
        seajs.config({
            base:"./js",
            alias: {
                "jquery" : "libs/jquery/jquery-1.11.2.min.js",
                "jquery.lazyload" : "libs/jquery/jquery.lazyload.min.js",
                "html5Loader" : "libs/loader/jquery.html5Loader.min.js",
                "iscroll" : "libs/iscroll/iscroll-probe.js"
            },
            preload: ["jquery"]
        });
        //seajs.use("jquery");
        //seajs.use("html5Loader");

    }

    seajs.use(usedJSlist);
    seajs.use("src/main");
})(seajs);