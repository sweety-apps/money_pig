define("view_main",[],function(require, exports, module) {
    require('jquery');
    var CommonButton = require('common_button');
    var CommonAnimations = require('common_animations');
    var CommonUtil = require('common_util');
    var ViewEdit = require('view_edit');
    var ViewMainFormOperations = require('view_main_form_operations');
    var ViewSelectPictureFormOperations = require('view_select_pic_form_operations');
    var ViewSelectTempleteFormOperations = require('view_select_tmp_form_operations');
    var ViewSharedData = require('view_shared_data');

    // instruction
    function ViewMain() {

        this._init();
    }

    module.exports = ViewMain;

    //页面
    ViewMain.prototype.view_main = null;
    ViewMain.prototype.view_main_save_tips = null;
    ViewMain.prototype.view_main_share_tips = null;
    ViewMain.prototype.view_main_start_btn = null;
    ViewMain.prototype.view_main_more_btn = null;
    ViewMain.prototype.view_main_exp_label = null;
    ViewMain.prototype.view_main_image_container = null;
    ViewMain.prototype.view_main_save_tips_container = null;
    ViewMain.prototype.view_main_cover_top = null;
    ViewMain.prototype.view_main_cover_left = null;
    ViewMain.prototype.view_main_cover_right = null;
    ViewMain.prototype.view_main_cover_bottom = null;
    ViewMain.prototype.view_main_image = null;

    //回调
    ViewMain.prototype._view_main_pressed_start_func = null;
    ViewMain.prototype._view_main_pressed_start_func_ctx = null;
    ViewMain.prototype._view_main_pressed_more_func = null;
    ViewMain.prototype._view_main_pressed_more_func_ctx = null;
    ViewMain.prototype._view_main_pressed_save_tips_func = null;
    ViewMain.prototype._view_main_pressed_save_tips_func_ctx = null;

    //状态变量
    ViewMain.prototype.is_entry_show_style = false; //show的时候是不是以Entry的方式
    ViewMain.prototype.tips_has_shown = false;

    //数据
    ViewMain.prototype.current_templete_id = null; //模板id

    ViewMain.getSaveTipsViewImage = function()
    {
        if(CommonUtil.getWrapperAppType() == CommonUtil.COMMON_WRAPPER_APP_TYPE_WECHAT)
        {
            return "img/save_pic_tips_wechat.png";
        }
        else if(CommonUtil.getDeviceType() == CommonUtil.COMMON_DEVICE_TYPE_IPAD
            || CommonUtil.getDeviceType() == CommonUtil.COMMON_DEVICE_TYPE_IPHONE
            || CommonUtil.getDeviceType() == CommonUtil.COMMON_DEVICE_TYPE_ANDROID
            )
        {
            return "img/save_pic_tips_safari.png";
        }
        else
        {
            return "img/save_pic_tips_pc.png";
        }
    };

    ViewMain.prototype._init = function() {
        // 先预对齐下元素
        this._adjustItemsMaxWidth();
        this._adjustItemCSSPerportyVWUnit();

        // 成员变量
        this.view_main = $("#view_main");
        this.view_main_save_tips = new CommonButton("#view_main_save_tips","#view_main_save_tips_img",ViewMain.getSaveTipsViewImage(),ViewMain.getSaveTipsViewImage());
        this.view_main_share_tips = $("#view_main_share_tips");
        this.view_main_start_btn = new CommonButton("#view_main_start_btn","#view_main_start_btn_img","img/btn_start.png","img/btn_start_a.png");
        this.view_main_more_btn = new CommonButton("#view_main_more_btn","#view_main_more_btn_img","img/btn_more.png","img/btn_more_a.png");
        this.view_main_exp_label = new CommonButton("#view_main_exp_label","#view_main_exp_label_img","img/tips_view_count_bg.png","img/tips_view_count_bg.png");
        this.view_main_image = $("#view_main_image");
        this.view_main_image_container = $("#view_main_image_container");
        this.view_main_save_tips_container = $("#view_main_save_tips_container");
        this.view_main_cover_top = $("#view_main_cover_top");
        this.view_main_cover_left = $("#view_main_cover_left");
        this.view_main_cover_right = $("#view_main_cover_right");
        this.view_main_cover_bottom = $("#view_main_cover_bottom");

        var view_main = this;
        $(window).resize(function(){
            // 监听窗口变化，对齐蒙层
            view_main._updateCoverViewPosition();
        });
        this._updateCoverViewPosition();

        // 点击事件处理
        this.view_main_start_btn.setClickCallback(function(btn,view_main){
            if(view_main._view_main_pressed_start_func != null
                && view_main._view_main_pressed_start_func != undefined)
            {
                view_main._view_main_pressed_start_func(view_main._view_main_pressed_start_func_ctx);
            }
        },this);

        this.view_main_more_btn.setClickCallback(function(btn,view_main){
            if(view_main._view_main_pressed_more_func != null
                && view_main._view_main_pressed_more_func != undefined)
            {
                view_main._view_main_pressed_more_func(view_main._view_main_pressed_more_func_ctx);
            }
        },this);

        this.view_main_save_tips.setClickCallback(function(btn,view_main){
            if(view_main._view_main_pressed_save_tips_func != null
                && view_main._view_main_pressed_save_tips_func != undefined)
            {
                view_main._view_main_pressed_save_tips_func(view_main._view_main_pressed_save_tips_func_ctx);
            }
        },this);

        return this;
    };

    //兼容微信的vh被修改的傻逼bug
    ViewMain.prototype._adjustItemsMaxWidth = function(){
        CommonUtil.setMaxWidthForItem("#view_main_image",65);
        CommonUtil.setMaxWidthForItem("#view_main_save_tips_img",100);
        CommonUtil.setMaxWidthForItem("#view_main_start_btn_img",35);
        CommonUtil.updateAttributeValueToVHUnit();
    };

    //
    ViewMain.prototype._adjustItemCSSPerportyVWUnit = function() {
        // 宽度自适应bug修正
        CommonUtil.setAttributeValueToVWUnit("#view_main_image",9.8,"top");
        CommonUtil.setAttributeValueToVWUnit("#view_main_cover_top",9.8,"top");
        CommonUtil.setAttributeValueToVWUnit("#view_main_cover_bottom",85,"top");
        CommonUtil.setAttributeValueToVWUnit("#view_main_save_tips_container",75,"height");
        CommonUtil.setAttributeValueToVWUnit("#view_main_save_tips_container",7.8,"top");
        CommonUtil.setAttributeValueToVWUnit("#view_main_save_tips_img",100,"width");
        CommonUtil.setAttributeValueToVWUnit("#view_main_save_tips",100,"width");
        CommonUtil.setAttributeValueToVWUnit("#view_main_start_btn_img",34.53,"width");
        CommonUtil.setAttributeValueToVWUnit("#view_main_start_btn_img",68,"left");
        CommonUtil.setAttributeValueToVWUnit("#view_main_exp_label_img",2,"top");
        CommonUtil.setAttributeValueToVWUnit("#view_main_exp_label",2,"top");
        CommonUtil.setAttributeValueToVWUnit("#view_main_exp_label",7.8,"line-height");
        CommonUtil.setAttributeValueToVWUnit("#view_main_exp_label",3.3,"font-size");
        CommonUtil.updateAttributeValueToVWUnit();
    };

    ViewMain.prototype._updateCoverViewPosition = function() {
        var x = this.view_main_image.offset().left;
        var y = this.view_main_image.offset().top;
        var w = this.view_main_image.width();
        var h = this.view_main_image.height();

        var ww = $(window).width();
        var wh = $(window).height();

        //微调图片高度和宽度，再盖住一点保存、分享提示泡泡
        w -= Math.floor(w * 0.1);
        h -= Math.floor(h * 0.05);

        this.view_main_cover_top.css({"left":"0px","top":"0px","width":"100%","height":""+y+"px"});
        this.view_main_cover_left.css({"left":"0px","top":"0px","width":""+x+"px","height":"100%"});
        this.view_main_cover_right.css({"left":""+(x+w)+"px","top":"0px","width":""+(ww-x)+"px","height":"100%"});
        this.view_main_cover_bottom.css({"left":"0px","top":""+(y+h)+"px","width":"100%","height":""+(wh-y-h)+"px"});
    };

    // 点击编辑的回调
    ViewMain.prototype.setPressedStartButtonCallback = function(callback,ctx) {
        this._view_main_pressed_start_func = callback;
        this._view_main_pressed_start_func_ctx = ctx;
    };

    // 点击加号更多的回调
    ViewMain.prototype.setPressedMoreButtonCallback = function(callback,ctx) {
        this._view_main_pressed_more_func = callback;
        this._view_main_pressed_more_func_ctx = ctx;
    };

    // 点击保存提示的回调
    ViewMain.prototype.setPressedSaveTipsButtonCallback = function(callback,ctx) {
        this._view_main_pressed_save_tips_func = callback;
        this._view_main_pressed_save_tips_func_ctx = ctx;
    };

    // 第一次进来的效果
    ViewMain.prototype.showForEntryStyle = function(isAnimated) {
        this.view_main.css("visibility", "visible");
        this.view_main.css({opacity:0.0});
        this.view_main_image.css({opacity:1.0});
        this.is_entry_show_style = true;
        if(isAnimated)
        {
            var view_main = this;
            this.view_main.animate({opacity:1.0},500,function(){
                view_main.showSaveTips(true);
                setTimeout(function(){
                    view_main.showStartButton(true);
                    view_main.showMoreButton(true);
                },1500);
            });

        }
        else
        {
            this.view_main.css("opacity", "1.0");
            this.showSaveTips(isAnimated);
            this.showStartButton(isAnimated);
            this.showMoreButton(isAnimated);
        }
    };

    // 生成结果展示时的效果
    ViewMain.prototype.showForResultStyle = function(isAnimated,animate_share_tips) {
        this.view_main.css("visibility", "visible");
        this.view_main.css({opacity:0.0});
        this.view_main_image.css({opacity:1.0});
        this.is_entry_show_style = false;
        var view_main = this;

        if(isAnimated)
        {
            view_main.showSaveTips(false);
            view_main.showStartButton(false);
            view_main.showMoreButton(false);
            var showEXPLabel = function(){
                if(!view_main.tips_has_shown)
                {
                    view_main.showEXPLabel(true);
                }
            };
            if(animate_share_tips)
            {
                this.view_main.animate({opacity:1.0},250,function(){
                    view_main.showShareTips(true);
                    setTimeout(function(){
                        showEXPLabel();
                    },1000);
                });
            }
            else
            {
                this.view_main.css("opacity", "1.0");
                view_main.showShareTips(false);
                setTimeout(function(){
                    showEXPLabel();
                },250);
            }

        }
        else
        {
            this.view_main.css("opacity", "1.0");

            if(!view_main.tips_has_shown)
            {
                this.showEXPLabel(isAnimated);
            }
            this.showShareTips(isAnimated);
            this.showSaveTips(isAnimated);
            this.showStartButton(isAnimated);
            this.showMoreButton(isAnimated);
        }

        setTimeout(function(){
            if(!view_main.tips_has_shown)
            {
                view_main.tips_has_shown = true;
                view_main.hideEXPLabel(true);
            }
        },4500)

    };

    // 隐藏
    ViewMain.prototype.hide = function(isAnimated,only_animate_edit_btn) {
        if(only_animate_edit_btn == null || only_animate_edit_btn == undefined)
        {
            only_animate_edit_btn = false;
        }
        if(only_animate_edit_btn)
        {
            isAnimated = false;
        }

        var this_obj = this;

        var hide_function = function(){
            this_obj.view_main.css("visibility", "visible");
            this_obj.hideSaveTips(isAnimated);
            this_obj.hideMoreButton(isAnimated);

            if(!this_obj.is_entry_show_style)
            {
                this_obj.hideEXPLabel(isAnimated);
                this_obj.hideShareTips(isAnimated);
            }

            var view_main = this_obj;
            if(isAnimated)
            {
                this_obj.view_main_image.animate({opacity:0.0},250);
                setTimeout(function(){
                    view_main.view_main.css({"visibility":"hidden","opacity":0.0});
                },400);
            }
            else
            {
                this_obj.view_main_image.css({opacity:0.0},250);
                this_obj.view_main.css({"visibility":"hidden","opacity":0.0});
            }

            this_obj.is_entry_show_style = false;
        };

        if(isAnimated)
        {
            this.hideStartButton(isAnimated);
        }

        if(only_animate_edit_btn)
        {
            this.hideStartButton(true);
            setTimeout(hide_function,350);
        }
        else
        {
            hide_function();
        }
    };



    ViewMain.prototype.showSaveTips = function(isAnimated) {
        this.view_main_save_tips.show(isAnimated);
    };

    ViewMain.prototype.hideSaveTips = function(isAnimated) {
        this.view_main_save_tips.hide(isAnimated);
    };

    ViewMain.prototype.showShareTips = function(isAnimated) {

        if(CommonUtil.getWrapperAppType() != "wechat")
        {
            //不是微信不反应
            return;
        }

        //var offsetY = this.view_main_image.attr("height");
        this.view_main_share_tips.css("visibility", "visible");
        //this.view_main_save_tips.css("top":"")
        if(isAnimated)
        {
            CommonAnimations.popFromBottom("#"+this.view_main_share_tips.attr('id'));
            //this.view_main_share_tips.animate({opacity:1.0},500);
        }
        else
        {
            CommonAnimations.doAnimate("#"+this.view_main_share_tips.attr('id'),"animationnone");
            this.view_main_share_tips.css("opacity", "1.0");
        }
    };

    ViewMain.prototype.hideShareTips = function(isAnimated) {

        if(CommonUtil.getWrapperAppType() != "wechat")
        {
            //不是微信不反应
            return;
        }

        //var offsetY = this.view_main_image.attr("height");
        this.view_main_share_tips.css("visibility", "visible");
        //this.view_main_save_tips.css("top":"")
        if(isAnimated)
        {
            CommonAnimations.extendDismiss("#"+this.view_main_share_tips.attr('id'));
            //this.view_main_share_tips.animate({opacity:1.0},500);
        }
        else
        {
            this.view_main_share_tips.css("opacity", "0.0");
            this.view_main_share_tips.css("visibility", "hidden");
        }
    };

    ViewMain.prototype.showStartButton = function(isAnimated) {
        this.view_main_start_btn.show(isAnimated);
    };

    ViewMain.prototype.hideStartButton = function(isAnimated) {
        this.view_main_start_btn.hide(isAnimated);
    };

    ViewMain.prototype.showMoreButton = function(isAnimated) {
        this.view_main_more_btn.show(isAnimated,"animationleftbottommovein");
    };

    ViewMain.prototype.hideMoreButton = function(isAnimated) {
        this.view_main_more_btn.hide(isAnimated,"animationleftbottommoveout");
    };

    ViewMain.prototype.showEXPLabel = function(isAnimated) {
        this.view_main_exp_label.show(isAnimated,"animationleftmovein");
    };

    ViewMain.prototype.hideEXPLabel = function(isAnimated) {
        this.view_main_exp_label.hide(isAnimated,"animationleftmoveout");
    };


    ViewMain.prototype.requestAndRefreshUI = function() {
        var this_obj = this;
        ViewMainFormOperations.getShareInstance().requestItem(
            this.current_templete_id,
            function(success_ctx,data){
                ViewMainFormOperations.getShareInstance().generateForm(data);
                ViewSharedData.getShareInstance().currentTempleteItem = JSON.parse(JSON.stringify(data));  //拷贝一份使用;
                ViewSharedData.getShareInstance().selectedTempleteItem = JSON.parse(JSON.stringify(data));  //拷贝一份使用;
            },
            this,
            function(fail_ctx,msg,ret){
            },
            this);
    };
});