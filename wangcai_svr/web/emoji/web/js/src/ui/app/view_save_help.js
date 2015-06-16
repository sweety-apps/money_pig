define("view_save_help",[],function(require, exports, module) {
    require('jquery');
    var CommonButton = require('common_button');
    var CommonAnimations = require('common_animations');
    var CommonUtil = require('common_util');
    var CommonPopbox = require('common_popbox');
    var CommonTips = require('common_tips');

    // instruction
    function ViewSaveHelp() {

        this._init();

    }

    module.exports = ViewSaveHelp;

    //页面
    ViewSaveHelp.prototype.view_popbox = null;
    ViewSaveHelp.prototype.view_save_help_content_box = null;
    ViewSaveHelp.prototype.view_up_content_title = null;
    ViewSaveHelp.prototype.view_up_content_subtitle = null;
    ViewSaveHelp.prototype.view_save_help_text_box = null;
    ViewSaveHelp.prototype.view_up_container = null;

    //数据

    //回调
    ViewSaveHelp.prototype._view_slidebar_cell_selected_func = null;
    ViewSaveHelp.prototype._view_slidebar_cell_selected_func_ctx = null;
    ViewSaveHelp.prototype._view_blockflow_cell_selected_func = null;
    ViewSaveHelp.prototype._view_blockflow_cell_selected_func_ctx = null;

    ViewSaveHelp.prototype._init = function() {
        // 成员变量
        // 初始化UI
        var popbox_id = "#view_save_help";
        this.view_popbox = new CommonPopbox(popbox_id,"img/popbox_bg_right_top_btn.png","img/popbox_bg_right_top_btn_a.png",21.875,1.0);
        this.view_save_help_content_box = $("#view_save_help_content_box");
        this.view_save_help_text_box = $("#view_save_help_text_box");
        this.view_up_container = $(popbox_id).find(".bts_up_container");

        this.view_up_content_title = $(popbox_id).find(".view_pop_box_up_content_title");
        this.view_up_content_subtitle = $(popbox_id).find(".view_pop_box_up_content_subtitle");

        var title_id = "view_up_content_title_save_help";
        var subtitle_id = "view_pop_box_up_content_subtitle_save_help";
        this.view_up_content_title.attr("id",title_id);
        this.view_up_content_subtitle.attr("id",subtitle_id);

        CommonUtil.setFontForItem("#"+title_id,3.2);
        CommonUtil.setFontForItem("#"+subtitle_id,1.7);
        CommonUtil.setFontForItem("#view_save_help_text_box",1.7);

        // 滑动组件初始化
        if(this.view_save_help_content_box != null && this.view_save_help_content_box != undefined)
        {
            var up_iscroller = this.view_save_help_content_box.find(".iscroll_type_element");
            if(up_iscroller != null && up_iscroller != undefined)
            {
                var id_uis = up_iscroller.attr("id");
                if(id_uis == null || id_uis == undefined)
                {
                    id_uis = "iscroll_type_element"+popbox_id.substr(1,popbox_id.length - 1);
                    up_iscroller.attr("id",id_uis);
                }
                CommonUtil.useIScrollType("#"+id_uis);
            }
        }

        // 对齐
        var this_obj = this;
        $(window).resize(function(){
            // 监听窗口变化，对齐蒙层
            this_obj._updateViewPosition();
        });
        this._updateViewPosition();

        // 事件处理
        this.view_popbox.setClickCloseCallback(function(){
            //this_obj.view_up_container.css({"visibility":"hidden"});
            return true;
        });

        this.hide(false);

        // 初始化数据

        return this;
    };

    ViewSaveHelp.prototype._updateViewPosition = function() {
    };

    // 生成结果展示时的效果
    ViewSaveHelp.prototype.show = function(isAnimated) {
        this.view_popbox.show(isAnimated);
        this.view_popbox.showContentBox();

        var css_change = {"visibility":"visible"};
        this.view_up_content_title.css(css_change);
        this.view_up_content_subtitle.css(css_change);
        this.view_save_help_content_box.css(css_change);
        this.view_save_help_text_box.css(css_change);
        this.view_up_container.css(css_change);
        if(isAnimated)
        {
            this.view_save_help_content_box.animate(css_change,200);
        }
        else
        {
            this.view_save_help_content_box.css(css_change);
        }
    };

    // 隐藏
    ViewSaveHelp.prototype.hide = function(isAnimated) {
        this.view_popbox.hide(isAnimated);
        this.view_popbox.hideContentBox();

        var css_change = {"visibility":"hidden"};
        this.view_up_content_title.css(css_change);
        this.view_up_content_subtitle.css(css_change);
        this.view_save_help_content_box.css(css_change);
        this.view_save_help_text_box.css(css_change);
        this.view_up_container.css(css_change);
        if(isAnimated)
        {
            this.view_save_help_content_box.animate(css_change,200);
        }
        else
        {
            this.view_save_help_content_box.css(css_change);
        }
    };
});