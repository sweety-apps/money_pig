//define("src/main", [ 'jquery' ], function(require, exports, module) {
define(function(require, exports, module) {
    require('jquery');
    require('jquery.lazyload');
    require('html5Loader');
    var API = require('api');
    var CommonAnimations = require('common_animations');
    var CommonUtil = require('common_util');
    var CommonPopbox = require('common_popbox');
    var CommonTips = require('common_tips');
    var CommonSlideTabbar = require('common_slidetabbar');
    var ViewMain = require('view_main');
    var ViewEdit = require('view_edit');
    var ViewSelectPiciture = require('view_select_pic');
    var ViewSelectTemplete = require('view_select_tmp');
    var ViewSaveHelp = require('view_save_help');
    var ViewSharedData = require('view_shared_data');
    var DebugLogFunctions = require('debug_log_functions');
    var ViewMainFormOperations = require('view_main_form_operations');
    var ViewSelectPictureFormOperations = require('view_select_pic_form_operations');
    var ViewSelectTempleteFormOperations = require('view_select_tmp_form_operations');

    // instruction
    function AppInstance() {
        this._init();
    }
    module.exports = AppInstance;

    //页面
    AppInstance.prototype.view_bg = null;
    AppInstance.prototype.view_main = null;
    AppInstance.prototype.view_edit = null;
    AppInstance.prototype.view_select_pic = null;
    AppInstance.prototype.view_select_tmp = null;
    AppInstance.prototype.view_save_help = null;

    //状态
    AppInstance.prototype.is_selecting_first_templete = true;
    AppInstance.prototype.app_has_started = false;


    AppInstance.prototype._init = function() {

        //初始化一些特性
        if(CommonUtil.getWrapperAppType() == "wechat")
        {
            //微信固定vw和vh取值，防止bug
            CommonUtil.setFixVWVHEnabled(true);
        }

        // 成员变量
        this.view_bg = $("#view_bg");
        this.view_main = new ViewMain();
        this.view_edit = new ViewEdit();
        this.view_select_pic = new ViewSelectPiciture();
        this.view_select_tmp = new ViewSelectTemplete();
        this.view_save_help = new ViewSaveHelp();

        // debug，需要删除
        if(false)
        {
            setInterval(function(){
                DebugLogFunctions.debugWindowSizeDetail();
            },300);
            DebugLogFunctions.debugWindowSizeDetail();
        }

        return this;
    };

    AppInstance.prototype.hideAllPage = function(isAnimated) {
        this.view_main.hide(isAnimated);
        this.view_edit.hide(isAnimated);
        this.view_select_pic.hide(isAnimated);
        this.view_select_tmp.hide(isAnimated);
        this.view_save_help.hide(isAnimated);

        $("#view_select_pic").css("visibility", "hidden");
        $("#view_select_tmp").css("visibility", "hidden");
        $("#view_save_help").css("visibility", "hidden");
    };

    AppInstance.prototype.preloadResourcesAndStartApp = function() {
        CommonAnimations.popFromBottom("#view_preloading");
        var appinstance = this;
        $.html5Loader({
            appInstance:this,
            filesToLoad:'config/files.json',
            onUpdate: function(perc){
                $("#view_preloading").text("加载中...("+perc+"%)");
            },
            mediaBufferSizeToPreload:0.5,
            stopExecution:false,
            onComplete: function () {
                console.log("All the assets are loaded!");
                appinstance.startApp();
            },
            onElementLoaded: function ( obj, elm ){
                console.log("loaded elm!"+elm);
            },
            onMediaError: function( obj, elm ) {
                console.log("Fail to load elm!"+elm);
            }
        });

        setTimeout(function(){
            //5秒后资源没有预加载完也要强制开始
            appinstance.startApp();
        },5000);
    };

    AppInstance.prototype.loadRequiredData = function() {
        //一些变量及组件初始化
        var clientInfoString = $("#view_data_context").text();
        if(clientInfoString != null && clientInfoString != undefined)
        {
            ViewSharedData.getShareInstance().clientInfo = JSON.parse(clientInfoString);
        }

        // 初始化当前模板数据
        this.view_main.current_templete_id = ViewSharedData.getShareInstance().clientInfo.templete_id;
        this.view_main.requestAndRefreshUI();

        var this_obj = this;

        ViewSelectTempleteFormOperations.getShareInstance().refreshCategoryList(
            ViewSharedData.getShareInstance().clientInfo.templete_id,
            function(success_ctx,data){
                // 拉到了模板列表
                ViewSelectTempleteFormOperations.getShareInstance().generateCategoryForm(data);
                this_obj.view_select_tmp.view_blockflow_popbox.view_tabbar.resetTabCells();

                ViewSharedData.getShareInstance().fetchedTempleteCategory = data.list;
                var listType = ViewSharedData.getShareInstance().fetchedTempleteCategory[0].type;
                // 初始化模板数据
                this_obj.view_select_tmp.current_selected_type = listType;
                this_obj.view_select_tmp.requestAndRefreshUIWithCurrentCategoryType();
            },
            this,
            function(fail_ctx,msg,ret){
                ViewSelectTempleteFormOperations.getShareInstance().generateCategoryErrorForm(msg);
            },
            this);

        ViewSelectPictureFormOperations.getShareInstance().refreshCategoryList(
            ViewSharedData.getShareInstance().clientInfo.templete_id,
            function(success_ctx,data){
                // 拉到了模板列表
                ViewSelectPictureFormOperations.getShareInstance().generateCategoryForm(data);
                this_obj.view_select_pic.view_blockflow_popbox.view_tabbar.resetTabCells();

                ViewSharedData.getShareInstance().fetchedPictureCategory = data.list;
                var listType = ViewSharedData.getShareInstance().fetchedPictureCategory[0].type;
                // 初始化图片数据
                this_obj.view_select_pic.current_selected_type = listType;
                this_obj.view_select_pic.requestAndRefreshUIWithCurrentCategoryType();
            },
            this,
            function(fail_ctx,msg,ret){
                ViewSelectPictureFormOperations.getShareInstance().generateCategoryErrorForm(msg);
            },
            this);


    };

    AppInstance.prototype.startApp = function() {
        if(this.app_has_started)
        {
            return;
        }
        this.app_has_started = true;

        // 加载数据
        this.loadRequiredData();

        //去掉预加载框
        $("#view_preloading").css("visibility", "hidden");
        // 点击处理
        this.view_main.setPressedStartButtonCallback(function(appInstance){
            // 开始编辑

            // 如果是第一个用户，则增加引导性动画
            var useAnimation = false;
            var only_animate_start_btn = true; // 只展示编辑按钮隐藏动画
            if(ViewSharedData.getShareInstance().clientInfo.is_new_user)
            {
                useAnimation = true;
                only_animate_start_btn = false;
            }

            //appInstance.view_main.hide(useAnimation,only_animate_start_btn);
            appInstance.view_main.hide(true);

            setTimeout(function(){
                appInstance.view_select_tmp.show(true);
                appInstance.view_select_tmp.setDidClickCloseCallback(function(view_select_tmp,appInstance)
                {
                    if(appInstance.is_selecting_first_templete)
                    {
                        appInstance.view_edit.show(true);
                    }
                    appInstance.is_selecting_first_templete = false;
                },appInstance);
            },300);
        },this);
        this.view_main.setPressedMoreButtonCallback(function(appInstance){
            // 更多跳公众号

            //appInstance.view_select_tmp.show(true);

        },this);
        this.view_main.setPressedSaveTipsButtonCallback(function(appInstance){
            // 弹出微信保存说明
            if(CommonUtil.getWrapperAppType() == "wechat")
            {
                appInstance.view_save_help.show(true);
            }
        },this);

        this.view_edit.setTempleteCallback(function(view_edit, appInstance){
            // 编辑模板
            appInstance.view_select_tmp.show(true);
        },this);

        this.view_edit.setPictureCallback(function(view_edit, appInstance){
            // 编辑图片
            appInstance.view_select_pic.show(true);
        },this);

        this.view_edit.setFinishedCallback(function(view_edit, appInstance){
            appInstance.view_edit.hide(true);
            $("#view_preloading").text("表情生成中...");
            $("#view_preloading").css({"visibility":"visible"});
            ViewMainFormOperations.getShareInstance().requestGenerateTempleteItem(
                ViewSharedData.getShareInstance().selectedTempleteItem.pic_id,
                $("#view_edit_text").val().trim(),
                $("#view_edit_text2").val().trim(),
                function(success_ctx,data){
                    // 生成成功，跳到目标模板
                    var id = data.id;
                    location.href = API.URL.getTempletePage(id);
                },
                this,
                function(fail_ctx,msg,ret){
                    // 生成失败，跳到选中模板
                    location.href = API.URL.getTempletePage(ViewSharedData.getShareInstance().selectedTempleteItem.id);
                },
                this
            )
        },this);

        this.view_edit.setCancelCallback(function(view_edit, appInstance){
            appInstance.view_edit.hide(true);
            appInstance.is_selecting_first_templete = true;
            setTimeout(function(){
                // 展示主界面
                if(ViewSharedData.getShareInstance().clientInfo.is_new_user)
                {
                    appInstance.view_main.showForEntryStyle(false);
                }
                else
                {
                    appInstance.view_main.showForResultStyle(false,false);
                }
            },500);
        },this);

        this.view_select_tmp.setDidSelectedItemCallback(function(view_select_tmp, appInstance){
            // 如果是从main进入，则先展示
            if(appInstance.is_selecting_first_templete)
            {
                appInstance.view_edit.show(true);
            }
            appInstance.is_selecting_first_templete = false;
            // 选中了模板，更新编辑内容
            appInstance.view_edit.updateContentWithShareData(true,false);
        },this);

        this.view_select_pic.setDidSelectedItemCallback(function(view_select_pic, appInstance){
            // 选中了图片，更新编辑内容
            appInstance.view_edit.updateContentWithShareData(true,true);
        },this);

        // 展示主界面
        if(ViewSharedData.getShareInstance().clientInfo.is_new_user)
        {
            this.view_main.showForEntryStyle(true);
        }
        else
        {
            this.view_main.showForResultStyle(true,ViewSharedData.getShareInstance().clientInfo.animate_share_tips);
        }
    };

    //程序入口
    var gAppSharedInstance = null;
    $(document).ready(function(){
        //app启动
        gAppSharedInstance = new AppInstance();
        gAppSharedInstance.hideAllPage(false);
        gAppSharedInstance.preloadResourcesAndStartApp();
        //gAppSharedInstance.startApp();
    });
});

/*
define("js/src/main-debug", [ "./spinning-debug", "jquery-debug" ], function(require) {
    var Spinning = require("./spinning-debug");
    var s = new Spinning("#container");
    s.render();
});
*/

