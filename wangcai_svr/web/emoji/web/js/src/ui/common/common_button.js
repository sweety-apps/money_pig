define("common_button",[],function(require, exports, module) {
    require('jquery');
    var CommonAnimations = require('common_animations');

    var COMMONBUTTON_STATE_NORMAL = 0;
    var COMMONBUTTON_STATE_MOUSEOVER = 1;
    var COMMONBUTTON_STATE_PRESSED = 2;


    // instruction
    function CommonButton(item_id,item_img_id,image_normal,image_pressed) {

        this._init(item_id,item_img_id,image_normal,image_pressed);
    }

    module.exports = CommonButton;

    //页面
    CommonButton.prototype.view = null; //图片
    CommonButton.prototype.view_img = null;  //蒙层
    CommonButton.prototype.image_normal = null;
    CommonButton.prototype.image_pressed = null;

    //状态
    CommonButton.prototype.commonbutton_state = null;
    CommonButton.prototype.isShowing = false;
    CommonButton.prototype.isTouching = false;

    //回调
    CommonButton.prototype.onPressedFunc = null;
    CommonButton.prototype.onPressedCtx = null;
    CommonButton.prototype.onTouchedFunc = null;
    CommonButton.prototype.onTouchedCtx = null;
    CommonButton.prototype.onReleasedFunc = null;
    CommonButton.prototype.onReleasedCtx = null;
    CommonButton.prototype.onDelayedReleasedFunc = null;
    CommonButton.prototype.onDelayedReleasedCtx = null;

    //全局所有button
    CommonButton.btndict = null;

    // 按下时禁止右键菜单
    $(document).bind("contextmenu",function(e){
        for(var key in CommonButton.btndict)
        {
            var val = CommonButton.btndict[key];
            if(val.commonbutton_state != COMMONBUTTON_STATE_NORMAL)
            {
                return false;
            }
        }
        return true;
    });

    CommonButton.prototype._init = function(item_id,item_img_id,image_normal,image_pressed) {
        this.view = $(item_id);
        this.view_img = $(item_img_id);
        if(CommonButton.btndict == null)
        {
            CommonButton.btndict = {};
        }
        CommonButton.btndict[item_id]=this;
        this.image_normal = image_normal;
        this.image_pressed = image_pressed;

        //先隐藏
        this.view.css("visibility", "hidden");
        this.view_img.css("visibility", "hidden");

        //设置状态
        this.setState(COMMONBUTTON_STATE_NORMAL);

        if (!navigator.userAgent.match(/mobile/i))
        {
            this.view.mousedown(CommonButton.onMouseDown);
            this.view.mouseup(CommonButton.onMouseClicked);
            this.view.mouseout(CommonButton.onMouseLeave);
        }
        else
        {
            this.view.bind('touchstart',CommonButton.onMouseDown);
            this.view.bind('touchend',CommonButton.onTouchEnd);
        }

        this._updateButtonPosition();

        var btn = this;
        $(window).resize(function(){
            // 监听窗口变化，对齐图片和蒙层
            btn._updateButtonPosition();
        });

        return this;
    };

    CommonButton.prototype._updateButtonPosition = function() {
        var x = this.view_img.offset().left;
        var y = this.view_img.offset().top;
        var w = this.view_img.width();
        var h = this.view_img.height();

        var prntX = this.view.parent().offset().left;
        var prntY = this.view.parent().offset().top;

        x = x-prntX;
        y = y-prntY;

        this.view.css({
            "left":""+x+"px",
            "top":""+y+"px",
            "width":""+w+"px",
            "height":""+h+"px"
        });
    };

    //////////////////////////////////////////////
    CommonButton.getButtonWithItemId = function(item_id)
    {
        if(CommonButton.btndict == null)
        {
            CommonButton.btndict = {};
        }
        return CommonButton.btndict[item_id];
    };

    CommonButton.onMouseOver = function(event){
        CommonButton.getButtonWithItemId("#"+this.id).setState(COMMONBUTTON_STATE_MOUSEOVER);
    };

    CommonButton.onDown = function(view){
        var btn = CommonButton.getButtonWithItemId("#"+view.id);
        btn.setState(COMMONBUTTON_STATE_PRESSED);
        btn.isTouching = true;
        //回调
        if(btn.onTouchedFunc != null && btn.onTouchedFunc != undefined)
        {
            btn.onTouchedFunc(btn,btn.onTouchedCtx);
        }
    };

    CommonButton.onClicked = function(view){
        var btn = CommonButton.getButtonWithItemId("#"+view.id);
        if(btn.commonbutton_state != COMMONBUTTON_STATE_NORMAL)
        {
            btn.setState(COMMONBUTTON_STATE_NORMAL);
            btn.view_img.attr("src",btn.image_pressed);
            setTimeout(function(){
                btn.setState(btn.commonbutton_state,true);
                if(btn.onDelayedReleasedFunc != null && btn.onDelayedReleasedFunc != undefined)
                {
                    btn.onDelayedReleasedFunc(btn,btn.onDelayedReleasedCtx);
                }
            },120);
        }
        btn.isTouching = false;
        //回调
        if(btn.onReleasedFunc != null && btn.onReleasedFunc != undefined)
        {
            btn.onReleasedFunc(btn,btn.onReleasedCtx);
        }
        if(btn.onPressedFunc != null && btn.onPressedFunc != undefined)
        {
            btn.onPressedFunc(btn,btn.onPressedCtx);
        }
    };

    CommonButton.onLeave = function(view){
        var btn = CommonButton.getButtonWithItemId("#"+view.id);
        if(btn.commonbutton_state != COMMONBUTTON_STATE_NORMAL)
        {
            btn.setState(COMMONBUTTON_STATE_NORMAL);
        }
        var touchedBefore = btn.isTouching;
        btn.isTouching = false;
        //回调
        if(touchedBefore && btn.onReleasedFunc != null && btn.onReleasedFunc != undefined)
        {
            btn.onReleasedFunc(btn,btn.onReleasedCtx);
        }
        if(touchedBefore && btn.onDelayedReleasedFunc != null && btn.onDelayedReleasedFunc != undefined)
        {
            btn.onDelayedReleasedFunc(btn,btn.onDelayedReleasedCtx);
        }
    };

    CommonButton.onTouchEnd = function(event) {
        var touch = event.originalEvent.changedTouches[0];
        console.log("x:"+touch.pageX+" y:"+touch.pageY);
        var btn = CommonButton.getButtonWithItemId("#"+this.id);
        var x = btn.view.offset().left;
        var y = btn.view.offset().top;
        var w = btn.view.width();
        var h = btn.view.height();
        if(touch.pageX > x && touch.pageX < x + w
            && touch.pageY > y && touch.pageY < y + h
            )
        {
            CommonButton.onClicked(this);
        }
        else
        {
            CommonButton.onLeave(this);
        }
    };

    CommonButton.onMouseClicked = function(event) {
        CommonButton.onClicked(this);
    };

    CommonButton.onMouseLeave = function(event){
        CommonButton.onLeave(this);
    };

    CommonButton.onMouseDown = function(event){
        CommonButton.onDown(this);
    };

    //////////////////////////////////////////////

    CommonButton.prototype.show = function(isAnimated, customAnimationName) {
        if(this.isShowing)
        {
            return;
        }
        this.isShowing = true;
        this.view.css("visibility", "visible");
        this.view_img.css("visibility", "visible");

        if(isAnimated)
        {
            this.view.css("opacity", "1.0");
            this.view_img.css("opacity", "1.0");
            if(customAnimationName != null && customAnimationName != undefined)
            {
                CommonAnimations.doAnimate("#"+this.view_img.attr('id'), customAnimationName);
                CommonAnimations.doAnimate("#"+this.view.attr('id'), customAnimationName);
            }
            else
            {
                CommonAnimations.scalePopup("#"+this.view_img.attr('id'));
                CommonAnimations.scalePopup("#"+this.view.attr('id'));
            }
            var btn = this;
            setTimeout(function(){
                btn._updateButtonPosition();
            },1000);
        }
        else
        {
            CommonAnimations.doAnimate("#"+this.view_img.attr('id'), "animationnone");
            CommonAnimations.doAnimate("#"+this.view.attr('id'), "animationnone");
            this.view.css("opacity", "1.0");
            this.view_img.css("opacity", "1.0");
            this._updateButtonPosition();
        }
    };

    CommonButton.prototype.hide = function(isAnimated, customAnimationName) {
        if(!this.isShowing)
        {
            return;
        }
        this.isShowing = false;

        this.view.css("visibility", "visible");
        this.view_img.css("visibility", "visible");
        this.view.css("opacity", "1.0");
        this.view_img.css("opacity", "1.0");
        if(isAnimated)
        {
            if(customAnimationName != null && customAnimationName != undefined)
            {
                CommonAnimations.doAnimate("#"+this.view_img.attr('id'), customAnimationName);
                CommonAnimations.doAnimate("#"+this.view.attr('id'), customAnimationName);
            }
            else
            {
                CommonAnimations.scaleDismiss("#"+this.view_img.attr('id'));
                CommonAnimations.scaleDismiss("#"+this.view.attr('id'));
            }
            this.view.animate({opacity:0.0},500);
            var btn = this;
            setTimeout(function(){
                btn.view.css("visibility", "hidden");
            },500);
        }
        else
        {
            this.view.css("opacity", "0.0");
            this.view_img.css("opacity", "0.0");
            this.view.css("visibility", "hidden");
            this.view_img.css("visibility", "hidden");
        }
    };

    CommonButton.prototype.setState = function(state,force_change) {
        if(!arguments[1])
        {
            isAnimated = false;
        }
        if(force_change == null || force_change == undefined)
        {
            force_change = false;
        }

        if(force_change || state != this.commonbutton_state)
        {
            switch(state)
            {
                case COMMONBUTTON_STATE_NORMAL:
                {
                    //this.view.attr()
                    this.view_img.attr("src",this.image_normal);
                    //this.view.css("background-image:","url("+this.image_normal+")");
                }
                    break;
                case COMMONBUTTON_STATE_MOUSEOVER:
                {
                    //this.view.attr()
                    this.view_img.attr("src",this.image_normal);
                    //this.view.css("background-image:","url("+this.image_normal+")");
                }
                    break;
                case COMMONBUTTON_STATE_PRESSED:
                {
                    //this.view.attr()
                    this.view_img.attr("src",this.image_pressed);
                    //this.view.css("background-image:","url("+this.image_pressed+")");
                }
                    break;
                default :
                    break;
            }
            this.commonbutton_state = state;

        }
    };

    CommonButton.prototype.setClickCallback = function (func,ctx)
    {
        this.onPressedFunc = func;
        this.onPressedCtx = ctx;
    };

    CommonButton.prototype.setTouchedCallback = function (func,ctx)
    {
        this.onTouchedFunc = func;
        this.onTouchedCtx = ctx;
    };

    CommonButton.prototype.setReleasedCallback = function (func,ctx)
    {
        this.onReleasedFunc = func;
        this.onReleasedCtx = ctx;
    };

    CommonButton.prototype.setDelayedReleasedCallback = function (func,ctx)
    {
        this.onDelayedReleasedFunc = func;
        this.onDelayedReleasedCtx = ctx;
    };

});