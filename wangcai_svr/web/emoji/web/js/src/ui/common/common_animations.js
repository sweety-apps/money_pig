define("common_animations",[],function(require, exports, module) {
    require('jquery');

    // instruction
    function CommonAnimations() {
        this._init();
    }
    module.exports = CommonAnimations;

    CommonAnimations.prototype._init = function() {
    };

    // 变换
    CommonAnimations.transfromItem = function(item_id,transValue,isAnimate,speed,callback) {
        var item = $(item_id);
        if(!isAnimate)
        {
            return item.css(
                {
                    "transform":transValue,
                    "-ms-transform":transValue,
                    "-webkit-transform":transValue,
                    "-o-transform":transValue,
                    "-moz-transform":transValue
                }
            );
        }
        else
        {
            return item.css(
                {
                    "transform":transValue+" "+speed/1000.0+"s",
                    "-ms-transform":transValue+" "+speed/1000.0+"s",
                    "-webkit-transform":transValue+" "+speed/1000.0+"s",
                    "-o-transform":transValue+" "+speed/1000.0+"s",
                    "-moz-transform":transValue+" "+speed/1000.0+"s"
                }
                //,speed,null,callback
            );
        }

    };

    var allAnimationClassNames = [
        "animationnone",
        "animationqbounce",
        "animationqbouncehide",
        "animationbottomslidein",
        "animationextendout",
        "animationleftbottommovein",
        "animationleftbottommoveout",
        "animationleftmovein",
        "animationleftmoveout",
        "animationfadein",
        "animationfadeout",
        "animationfadeoutslow",
        "animationscalepopupnormal",
        "animationscalepopdownnormal"
    ];

    // 缩放
    CommonAnimations.scaleItem = function(item_id,scaleXY,isAnimate,speed,callback) {
        var scaleValue = "";
        scaleValue = "scale("+scaleXY+","+scaleXY+")";

        return CommonAnimations.transfromItem(item_id,scaleValue,isAnimate,speed,callback);
    };

    CommonAnimations.animatefyItem = function(item_id) {
        var item = $(item_id);
        if(item.transfromItem == undefined || item.transfromItem == null)
        {
            item.transfromItem = function(transValue,isAnimate,speed,callback){
                var itemid = "#"+this.attr("id")
                return CommonAnimations.transfromItem(itemid,transValue,isAnimate,speed,callback);
            };
            item.scaleItem = function(scaleXY,isAnimate,speed,callback){
                var itemid = "#"+this.attr("id")
                return CommonAnimations.scaleItem(itemid,scaleXY,isAnimate,speed,callback);
            };
        }
        return item;
    }

    // 设置播放状态
    CommonAnimations.setPlayState = function(item,state_str)
    {
        item.css({
            "animation-play-state":state_str,
            "-webkit-animation-play-state":state_str,
            "-moz-animation-play-state":state_str,
            "-o-animation-play-state":state_str
        });
    }

    // 动画
    CommonAnimations.doAnimate = function(item_id, animate_css_class)
    {
        var item = CommonAnimations.animatefyItem(item_id);
        for(var i = 0; i < allAnimationClassNames.length; ++i)
        {
            var cls = allAnimationClassNames[i];
            item.removeClass(cls);
        }
        item.addClass("animationnone");
        CommonAnimations.setPlayState(item,"paused");
        CommonAnimations.setPlayState(item,"running");
        item.removeClass("animationnone");
        item.addClass(animate_css_class);
        CommonAnimations.setPlayState(item,"paused");
        CommonAnimations.setPlayState(item,"running");
    };

    CommonAnimations.scalePopup = function(item_id)
    {
        CommonAnimations.doAnimate(item_id,"animationqbounce");
    };

    CommonAnimations.scaleDismiss = function(item_id)
    {
        CommonAnimations.doAnimate(item_id,"animationqbouncehide");
    };

    CommonAnimations.popFromBottom = function(item_id)
    {
        CommonAnimations.doAnimate(item_id,"animationbottomslidein");
    };

    CommonAnimations.extendDismiss = function(item_id)
    {
        CommonAnimations.doAnimate(item_id,"animationextendout");
    };
});