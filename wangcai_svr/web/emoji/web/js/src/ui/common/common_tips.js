define("common_tips",[],function(require, exports, module) {
    require('jquery');
    var CommonUtil = require('common_util');
    
    // instruction
    function CommonTips(parent_item_id,loading_icon_url) {
        this._init(parent_item_id,loading_icon_url);
    }

    module.exports = CommonTips;

    //页面
    CommonTips.prototype.view_parent = null; //父窗口
    CommonTips.prototype.view_container_full = null;  //tips框
    CommonTips.prototype.view_loading_icon = null;

    //数据
    CommonTips.prototype.loading_icon_url = null; //父窗口

    //状态
    CommonTips.prototype.isShowing = false;

    CommonTips.prototype._init = function(parent_item_id,loading_icon_url) {
        this.view_parent = $(parent_item_id);
        this.loading_icon_url = loading_icon_url;
        this.view_container_full = null;
        return this;
    };

    //////////////////////////////////////////////


    CommonTips.prototype.createTipsContainer = function() {
        var txt = "<div class=\"tips_container_full\"><img class=\"tips_loading_icon\" src=\""+this.loading_icon_url+"\" alt = \"表情加载中\"></div>";
        var old_txt = this.view_parent.html();
        var new_txt = ""+txt+old_txt;
        this.view_parent.html(new_txt);
        this.view_container_full = this.view_parent.children(".tips_container_full");
        this.view_loading_icon = this.view_container_full.children(".tips_loading_icon");
    };

    CommonTips.prototype.deleteTipsContainer = function() {
        this.view_container_full.remove();
        this.view_container_full = null;
        this.view_loading_icon = null;
    };

    CommonTips.prototype._show = function(isAnimated) {
        if(this.isShowing)
        {
            return;
        }
        this.isShowing = true;

        this.createTipsContainer();

        this.view_container_full.css("visibility", "visible");
        this.view_loading_icon.css("visibility", "visible");

        if(isAnimated)
        {

        }
        else
        {

        }
    };

    CommonTips.prototype._hide = function(isAnimated) {
        if(!this.isShowing)
        {
            return;
        }
        this.isShowing = false;

        if(isAnimated)
        {

        }
        else
        {

        }

        this.deleteTipsContainer();
    };

    CommonTips.prototype.showLoadingIcon = function(isAnimated) {
        this._show(isAnimated);
    };

    CommonTips.prototype.hideLoadingIcon = function(isAnimated) {
        this._hide(isAnimated);
    };
});