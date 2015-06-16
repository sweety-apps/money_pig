define("common_popbox",[],function(require, exports, module) {
    require('jquery');
    var CommonAnimations = require('common_animations');
    var CommonUtil = require('common_util');
    var CommonButton = require('common_button')

    // instruction
    function CommonPopbox(popbox_view_id,close_btn_image_normal,close_btn_image_pressed,inset_width_percents,inset_width_height_ratio) {
        this._init(popbox_view_id,close_btn_image_normal,close_btn_image_pressed,inset_width_percents,inset_width_height_ratio);
    }

    module.exports = CommonPopbox;

    //页面
    CommonPopbox.prototype.view = null; //图片
    CommonPopbox.prototype.view_cp_bg = null;  //半透明黑色背景
    CommonPopbox.prototype.view_cp_container = null;    //box的限制框
    CommonPopbox.prototype.view_cp_t_l = null;
    CommonPopbox.prototype.view_cp_t_m = null;
    CommonPopbox.prototype.view_cp_t_r = null;
    CommonPopbox.prototype.view_cp_m_l = null;
    CommonPopbox.prototype.view_cp_m_m = null;
    CommonPopbox.prototype.view_cp_m_r = null;
    CommonPopbox.prototype.view_cp_b_l = null;
    CommonPopbox.prototype.view_cp_b_m = null;
    CommonPopbox.prototype.view_cp_b_r = null;
    CommonPopbox.prototype.view_cp_content_box = null; //内容框
    CommonPopbox.prototype.view_close_btn = null; //关闭按钮

    //数据
    CommonPopbox.prototype.inset_width_percents = null; //边角处矩形的宽度
    CommonPopbox.prototype.inset_width_height_ratio = null; //边角处矩形的宽高比
    CommonPopbox.prototype.popbox_view_id = null;
    CommonPopbox.prototype.cp_container_id = null;
    CommonPopbox.prototype.close_btn_id = null;
    CommonPopbox.prototype.close_btn_img_id = null;
    CommonPopbox.prototype.cp_bg_original_alpha = 0.3;

    //状态
    CommonPopbox.prototype.isShowing = false;

    //回调
    CommonPopbox.prototype.onPressedCloseFunc = null;
    CommonPopbox.prototype.onPressedCloseCtx = null;

    CommonPopbox.prototype._init = function(popbox_view_id,close_btn_image_normal,close_btn_image_pressed,inset_width_percents,inset_width_height_ratio) {

        this.popbox_view_id = popbox_view_id;
        var pbid = popbox_view_id.substr(1,popbox_view_id.length-1);

        this.cp_container_id = pbid + "cp_container";
        this.close_btn_id = pbid + "close_btn";
        this.close_btn_img_id = pbid + "close_btn_img";

        this.inset_width_percents = inset_width_percents;
        this.inset_width_height_ratio = inset_width_height_ratio;

        this.view = $(popbox_view_id);

        this.view_cp_bg = this.view.children(".cp_bg");
        this.cp_bg_original_alpha = this.view_cp_bg.css("opacity");

        this.view_cp_container = this.view.children(".cp_container");
        if(this.view_cp_container != null && this.view_cp_container != undefined)
        {
            this.view_cp_container.attr("id",this.cp_container_id);
            CommonUtil.setMaxWidthForItem("#"+this.cp_container_id,100);
            CommonUtil.updateAttributeValueToVHUnit();
            this.view_cp_t_l = this.view_cp_container.children(".cp_t_l");
            this.view_cp_t_m = this.view_cp_container.children(".cp_t_m");
            this.view_cp_t_r = this.view_cp_container.children(".cp_t_r");
            this.view_cp_m_l = this.view_cp_container.children(".cp_m_l");
            this.view_cp_m_m = this.view_cp_container.children(".cp_m_m");
            this.view_cp_m_r = this.view_cp_container.children(".cp_m_r");
            this.view_cp_b_l = this.view_cp_container.children(".cp_b_l");
            this.view_cp_b_m = this.view_cp_container.children(".cp_b_m");
            this.view_cp_b_r = this.view_cp_container.children(".cp_b_r");
            this.view_cp_content_box = this.view_cp_container.children(".cp_content_box");
        }

        var view_close_btn_part = this.view_cp_t_r;

        if(view_close_btn_part != null && view_close_btn_part != undefined)
        {
            // 关闭按钮
            var view_close_btn = this.view.children(".cp_close_btn");
            var view_close_btn_img = view_close_btn_part.children(".cp_close_btn_img");
            view_close_btn.attr("id",this.close_btn_id);
            view_close_btn_img.attr("id",this.close_btn_img_id);

            this.view_close_btn = new CommonButton("#"+this.close_btn_id,"#"+this.close_btn_img_id,close_btn_image_normal,close_btn_image_pressed);

            this.view_close_btn.setClickCallback(function(close_btn,popbox){
                var shouldAutoClose = true;
                if(popbox.onPressedCloseFunc != null && popbox.onPressedCloseFunc != undefined)
                {
                    shouldAutoClose = popbox.onPressedCloseFunc(popbox.onPressedCloseCtx);
                    if(shouldAutoClose == null || shouldAutoClose == undefined)
                    {
                        shouldAutoClose = true;
                    }
                }

                if(shouldAutoClose)
                {
                    popbox.hide(true);
                }
            },this);
        }

        this.hide(false);

        this._updateItemsPosition();

        var popbox = this;
        $(window).resize(function(){
            // 监听窗口变化，对齐所有子控件
            popbox._updateItemsPosition();
        });

        return this;
    };

    CommonPopbox.prototype._updateItemsPosition = function() {
        var vw = this.view.width();
        var vh = this.view.height();

        var x = this.view_cp_container.offset().left;
        var y = this.view_cp_container.offset().top;
        var w = this.view_cp_container.width();
        var h = this.view_cp_container.height();

        if(w < vw)
        {
            this.view_cp_container.css({
                "left":""+((vw-w)*0.5)+"px",
                "top":"0px"
            });
        }
        else
        {
            this.view_cp_container.css({
                "left":"0px",
                "top":"0px"
            });
        }

        var inset_width = w*this.inset_width_percents*0.01;
        var inset_height = inset_width/this.inset_width_height_ratio;
        inset_width = Math.floor(inset_width);
        inset_height = Math.floor(inset_height);
        var width_m = w - 2*inset_width;
        var height_m = h - 2*inset_height;

        this.view_cp_t_l.css({
            "left":""+0+"px",
            "top":""+0+"px",
            "width":""+inset_width+"px",
            "height":""+inset_height+"px"
        });
        this.view_cp_t_m.css({
            "left":""+inset_width+"px",
            "top":""+0+"px",
            "width":""+width_m+"px",
            "height":""+inset_height+"px"
        });
        this.view_cp_t_r.css({
            "left":""+(inset_width+width_m)+"px",
            "top":""+0+"px",
            "width":""+inset_width+"px",
            "height":""+inset_height+"px"
        });

        this.view_cp_m_l.css({
            "left":""+0+"px",
            "top":""+inset_height+"px",
            "width":""+inset_width+"px",
            "height":""+height_m+"px"
        });
        this.view_cp_m_m.css({
            "left":""+(inset_width-2)+"px",
            "top":""+(inset_height-2)+"px",
            "width":""+(width_m+4)+"px",
            "height":""+(height_m+4)+"px"
        });
        this.view_cp_m_r.css({
            "left":""+(inset_width+width_m)+"px",
            "top":""+inset_height+"px",
            "width":""+inset_width+"px",
            "height":""+height_m+"px"
        });


        this.view_cp_b_l.css({
            "left":""+0+"px",
            "top":""+(inset_height+height_m)+"px",
            "width":""+inset_width+"px",
            "height":""+inset_height+"px"
        });
        this.view_cp_b_m.css({
            "left":""+inset_width+"px",
            "top":""+(inset_height+height_m)+"px",
            "width":""+width_m+"px",
            "height":""+inset_height+"px"
        });
        this.view_cp_b_r.css({
            "left":""+(inset_width+width_m)+"px",
            "top":""+(inset_height+height_m)+"px",
            "width":""+inset_width+"px",
            "height":""+inset_height+"px"
        });

        this.view_close_btn._updateButtonPosition();
    };

    //////////////////////////////////////////////

    CommonPopbox.prototype.show = function(isAnimated) {
        if(this.isShowing)
        {
            return;
        }
        this.isShowing = true;
        this.view.css("visibility", "visible");
        this.view_cp_container.css({"visibility":"visible"});
        this.view_cp_bg.css({"visibility":"visible","opacity":0.0});
        this.view.css({"z-index":999999});

        if(isAnimated)
        {
            var popbox = this;
            this.view_cp_bg.animate({"opacity":this.cp_bg_original_alpha},300);
            CommonAnimations.doAnimate("#"+this.cp_container_id,"animationscalepopupnormal");
            setTimeout(function(){
                popbox.view_close_btn.show(true,"animationfadein");
            },150);
        }
        else
        {
            this.view_cp_bg.css({"opacity":this.cp_bg_original_alpha});
            this.view_close_btn.show(false,"animationfadein");
        }
    };

    CommonPopbox.prototype.hide = function(isAnimated) {
        //if(!this.isShowing)
        //{
            //return;
        //}
        this.isShowing = false;

        this.view.css("visibility", "visible");
        this.view_cp_container.css({"visibility":"visible"});
        this.view_cp_bg.css({"visibility":"visible","opacity":this.cp_bg_original_alpha});

        if(isAnimated)
        {
            var popbox = this;
            this.view_cp_bg.animate({"opacity":0.0},150);
            CommonAnimations.doAnimate("#"+this.cp_container_id,"animationscalepopdownnormal");
            this.view_close_btn.hide(true,"animationfadeout");
            setTimeout(function(){
                popbox.view_cp_bg.css({"visibility":"hidden"});
                popbox.view_cp_container.css({"visibility":"hidden"});
                popbox.view.css({"visibility":"hidden"});
                if(!popbox.isShowing)
                {
                    popbox.view.css({"z-index":-999999});
                }
            },200);
        }
        else
        {
            this.view_cp_bg.css({"opacity":0.0,"visibility":"hidden"});
            this.view_close_btn.hide(false,"animationfadeout");
            this.view_cp_container.css({"visibility":"hidden"});
            this.view.css({"visibility":"hidden"});
            this.view.css({"z-index":-999999});
        }
    };

    CommonPopbox.prototype.showContentBox = function() {
        this.view_cp_content_box.css({"visibility":"visible"});
    };

    CommonPopbox.prototype.hideContentBox = function() {
        this.view_cp_content_box.css({"visibility":"hidden"});
    };

    CommonPopbox.prototype.setClickCloseCallback = function (func,ctx)
    {
        this.onPressedCloseFunc = func;
        this.onPressedCloseCtx = ctx;
    };

});