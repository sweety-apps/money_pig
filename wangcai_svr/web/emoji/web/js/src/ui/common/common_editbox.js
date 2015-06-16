define("common_editbox",[],function(require, exports, module) {
    require('jquery');
    var CommonButton = require('common_button');
    var CommonAnimations = require('common_animations');
    var CommonUtil = require('common_util');

    // instruction
    function CommonEditbox(bg_img_id, edit_button_img_id, edit_button_id, edit_button_img_url, edit_button_img_active_url, clear_button_img_id, clear_button_id, clear_button_img_url, clear_button_img_active_url, input_id) {

        this._init(bg_img_id, edit_button_img_id, edit_button_id, edit_button_img_url, edit_button_img_active_url, clear_button_img_id, clear_button_id, clear_button_img_url, clear_button_img_active_url, input_id);
    }

    module.exports = CommonEditbox;

    //页面
    CommonEditbox.prototype.view_bg_img = null; //背景图，位置以它为准
    CommonEditbox.prototype.view_edit_button = null;
    CommonEditbox.prototype.view_clear_button = null;
    CommonEditbox.prototype.view_input = null;

    //回调
    CommonEditbox.prototype.onInputFocusCallback = null; //输入框获得焦点时
    CommonEditbox.prototype.onInputBlurCallback = null; //输入框失去焦点时
    CommonEditbox.prototype.onInputChangeCallback = null; //输入框内容变化时
    //回调参数
    CommonEditbox.prototype.onInputFocusCallbackCtx = null;
    CommonEditbox.prototype.onInputBlurCallbackCtx = null;
    CommonEditbox.prototype.onInputChangeCallbackCtx = null;

    //数据
    CommonEditbox.prototype.textCheckTimer = null;
    CommonEditbox.prototype.lastText = null;


    CommonEditbox.prototype._init = function(bg_img_id, edit_button_img_id, edit_button_id, edit_button_img_url, edit_button_img_active_url, clear_button_img_id, clear_button_id, clear_button_img_url, clear_button_img_active_url, input_id) {
        this.view_bg_img = $(bg_img_id);
        this.view_edit_button = new CommonButton(edit_button_id,edit_button_img_id,edit_button_img_url,edit_button_img_active_url);
        this.view_clear_button = new CommonButton(clear_button_id,clear_button_img_id,clear_button_img_url,clear_button_img_active_url);
        this.view_input = $(input_id);

        this.lastText = this.getInputContent();

        // 点击编辑按钮时
        this.view_edit_button.setClickCallback(function(btn,edit_box){
            edit_box.focusInput();
        },this);

        // 点击清除按钮时
        this.view_clear_button.setClickCallback(function(btn,edit_box){
            var oldText = edit_box.getInputContent();
            edit_box.focusInput();
            edit_box.view_input.val("");
            edit_box.focusInput();
            if(oldText != "")
            {
                if(editbox.onInputChangeCallback != null
                    && editbox.onInputChangeCallback != undefined)
                {
                    editbox.onInputChangeCallback(editbox,editbox.onInputChangeCallbackCtx);
                }
            }
        },this);

        var editbox = this;
        // 进入编辑态时
        this.view_input.on('focus',function(){
            editbox.hideEditButton(false);
            editbox.showClearButton(false);
            if(editbox.onInputFocusCallback != null
                && editbox.onInputFocusCallback != undefined)
            {
                editbox.onInputFocusCallback(editbox,editbox.onInputFocusCallbackCtx);
            }
        });

        // 退出编辑态时
        this.view_input.on('blur',function(){
            //editbox.hideClearButton(false);
            //editbox.showEditButton(false);
            if(editbox.onInputBlurCallback != null
                && editbox.onInputBlurCallback != undefined)
            {
                editbox.onInputBlurCallback(editbox,editbox.onInputBlurCallbackCtx);
            }
        });

        this._updateEditBoxPosition();

        var obj = this;
        $(window).resize(function(){
            // 监听窗口变化，对齐图片和蒙层
            obj._updateEditBoxPosition();
        });

        return this;
    };

    CommonEditbox.prototype._updateEditBoxPosition = function() {
        var x = this.view_bg_img.offset().left;
        var y = this.view_bg_img.offset().top;
        var w = this.view_bg_img.width();
        var h = this.view_bg_img.height();

        var prntX = this.view_input.parent().offset().left;
        var prntY = this.view_input.parent().offset().top;

        x = x-prntX;
        y = y-prntY;

        this.view_clear_button.view_img.css({
            "left":""+(x+w-(w*0.0982))+"px",
            "top":""+y+"px",
            "width":""+(w*0.0982)+"px",
            "height":""+h+"px"});
        this.view_clear_button._updateButtonPosition();
        this.view_edit_button.view_img.css({
            "left":""+(x+w-(w*0.0982))+"px",
            "top":""+y+"px",
            "width":""+(w*0.0982)+"px",
            "height":""+h+"px"});
        this.view_edit_button._updateButtonPosition();

        var buttonW = this.view_clear_button.view_img.width();
        var margin_left = Math.floor(0.05*w);
        var margin_right = Math.floor(buttonW * 1.2);
        var margin_bottom = h * 0.15;

        this.view_input.css({"left":""+(x+margin_left)+"px","top":""+y+"px","width":""+(w-margin_left-margin_right)+"px","height":""+(h - margin_bottom)+"px"});
    };

    CommonEditbox.prototype.show = function(isAnimated) {
        this.view_input.css({visibility:"visible",opacity:1.0});
        this.view_bg_img.css({visibility:"visible",opacity:0.0});
        if(isAnimated)
        {
            this.view_bg_img.animate({visibility:"visible",opacity:1.0},200);
        }
        else
        {
            this.view_bg_img.css({visibility:"visible",opacity:1.0});
        }
        var text = this.getInputContent();
        if(text != null && text != undefined && text.length > 0)
        {
            this.hideClearButton(false);
            this.showEditButton(isAnimated);
        }
        else
        {
            this.showClearButton(isAnimated);
            this.hideEditButton(false);
        }

        // 设置定时器检查内容变化
        var editbox = this;
        this.textCheckTimer = setInterval(function(){
            var text = editbox.getInputContent();
            var needCallback = false;

            if(editbox.lastText != text)
            {
                needCallback = true;
            }

            editbox.lastText = editbox.getInputContent();

            if(needCallback)
            {
                if(editbox.onInputChangeCallback != null
                    && editbox.onInputChangeCallback != undefined)
                {
                    editbox.onInputChangeCallback(editbox,editbox.onInputChangeCallbackCtx);
                }
            }
        },200);
    };

    // 隐藏
    CommonEditbox.prototype.hide = function(isAnimated) {
        this.blurInput();
        if(isAnimated)
        {
            var editbox = this;
            this.view_bg_img.animate({visibility:"hidden",opacity:0.0},200,function(){
                editbox.view_input.css({visibility:"hidden",opacity:0.0});
                editbox.view_bg_img.css({visibility:"hidden",opacity:0.0});
            });
        }
        else
        {
            this.view_input.css({visibility:"hidden",opacity:0.0});
            this.view_bg_img.css({visibility:"hidden",opacity:0.0});
        }
        this.hideEditButton(isAnimated);
        this.hideClearButton(isAnimated);

        if(this.textCheckTimer != null)
        {
            clearInterval(this.textCheckTimer);
            this.textCheckTimer = null;
        }
    };


    CommonEditbox.prototype.focusInput = function() {
        var t= this.view_input.val();
        this.view_input.val("").focus().val(t);
    };

    CommonEditbox.prototype.blurInput = function() {
        this.view_input.blur();
    };

    CommonEditbox.prototype.isInputHasContent = function() {
        var val = this.view_input.val();
        if(val == null || val == undefined || val.length == 0)
        {
            return false;
        }
        else
        {
            return true;
        }
    };

    CommonEditbox.prototype.getInputContent = function() {
        return this.view_input.val();
    };

    CommonEditbox.prototype.showEditButton = function(isAnimated) {
        this.view_edit_button.show(isAnimated);
    };

    CommonEditbox.prototype.hideEditButton = function(isAnimated) {
        this.view_edit_button.hide(isAnimated);
    };

    CommonEditbox.prototype.showClearButton = function(isAnimated) {
        this.view_clear_button.show(isAnimated);
    };

    CommonEditbox.prototype.hideClearButton = function(isAnimated) {
        this.view_clear_button.hide(isAnimated);
    };

    // ===============--- 回调设置 ---=============== //
    CommonEditbox.prototype.setInputFocusCallback = function(func,ctx) {
        this.onInputFocusCallback = func;
        this.onInputFocusCallbackCtx = ctx;
    };

    CommonEditbox.prototype.setInputBlurCallback = function(func,ctx) {
        this.onInputBlurCallback = func;
        this.onInputBlurCallbackCtx = ctx;
    };

    CommonEditbox.prototype.setInputChangeCallback = function(func,ctx) {
        this.onInputChangeCallback = func;
        this.onInputChangeCallbackCtx = ctx;
    };
});