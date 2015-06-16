define("common_blockflow_popbox",[],function(require, exports, module) {
    require('jquery');
    var CommonButton = require('common_button');
    var CommonAnimations = require('common_animations');
    var CommonUtil = require('common_util');
    var CommonPopbox = require('common_popbox');
    var CommonTips = require('common_tips');
    var CommonSlideTabbar = require('common_slidetabbar');
    var CommonBlockFlowDiv = require('common_blockflow_div');

    // instruction
    function CommonBlockFlowPopbox(
        popbox_id,popbox_close_btn_image_normal,popbox_close_btn_image_pressed,popbox_inset_width_percents,popbox_inset_width_height_ratio,
        bottombar_container_id,bottombar_cell_width_percents_to_container,bottombar_auto_resize_cell_text,
        loadingtips_parent_item_id,loadingtips_loading_icon_url,
        blockflowdiv_outbox_id,blockflowdiv_cell_id,blockflowdiv_should_auto_adjust_width_with_cell
        ) {

        this._init(popbox_id,popbox_close_btn_image_normal,popbox_close_btn_image_pressed,popbox_inset_width_percents,popbox_inset_width_height_ratio,
            bottombar_container_id,bottombar_cell_width_percents_to_container,bottombar_auto_resize_cell_text,
            loadingtips_parent_item_id,loadingtips_loading_icon_url,
            blockflowdiv_outbox_id,blockflowdiv_cell_id,blockflowdiv_should_auto_adjust_width_with_cell);

    }

    module.exports = CommonBlockFlowPopbox;

    //页面
    CommonBlockFlowPopbox.prototype.view_popbox = null;
    CommonBlockFlowPopbox.prototype.view_tabbar = null;
    CommonBlockFlowPopbox.prototype.view_loading_tips = null;
    CommonBlockFlowPopbox.prototype.view_blockflow_div = null;
    CommonBlockFlowPopbox.prototype.view_up_container = null;
    CommonBlockFlowPopbox.prototype.view_pop_box_up_content_box = null;

    //数据
    CommonBlockFlowPopbox.prototype.iscroller_id = null;
    CommonBlockFlowPopbox.prototype.popbox_id = null;

    //回调
    CommonBlockFlowPopbox.prototype._view_slidebar_cell_selected_func = null;
    CommonBlockFlowPopbox.prototype._view_slidebar_cell_selected_func_ctx = null;
    CommonBlockFlowPopbox.prototype._view_blockflow_cell_selected_func = null;
    CommonBlockFlowPopbox.prototype._view_blockflow_cell_selected_func_ctx = null;
    CommonBlockFlowPopbox.prototype._view_close_click_func = null;
    CommonBlockFlowPopbox.prototype._view_close_click_func_ctx = null;

    CommonBlockFlowPopbox.prototype._init = function(
        popbox_id,popbox_close_btn_image_normal,popbox_close_btn_image_pressed,popbox_inset_width_percents,popbox_inset_width_height_ratio,
        bottombar_container_id,bottombar_cell_width_percents_to_container,bottombar_auto_resize_cell_text,
        loadingtips_parent_item_id,loadingtips_loading_icon_url,
        blockflowdiv_outbox_id,blockflowdiv_cell_id,blockflowdiv_should_auto_adjust_width_with_cell
        ) {
        // 成员变量
        this.popbox_id = popbox_id;

        // 初始化UI
        this.view_popbox = new CommonPopbox(popbox_id,popbox_close_btn_image_normal,popbox_close_btn_image_pressed,popbox_inset_width_percents,popbox_inset_width_height_ratio);
        this.view_tabbar = new CommonSlideTabbar(bottombar_container_id,bottombar_cell_width_percents_to_container,bottombar_auto_resize_cell_text);
        this.view_loading_tips = new CommonTips(loadingtips_parent_item_id,loadingtips_loading_icon_url);
        this.view_blockflow_div = new CommonBlockFlowDiv(blockflowdiv_outbox_id,blockflowdiv_cell_id,blockflowdiv_should_auto_adjust_width_with_cell);
        this.view_pop_box_up_content_box = $(popbox_id).find(".view_pop_box_up_content_box");
        this.view_up_container = $(popbox_id).find(".bts_up_container");

        // 滑动组件初始化
        this._resetIScroll();

        // 对齐
        var this_obj = this;
        $(window).resize(function(){
            // 监听窗口变化，对齐蒙层
            this_obj._updateViewPosition();
        });
        this._updateViewPosition();

        // 事件处理
        this.view_popbox.setClickCloseCallback(function(){
            this_obj.view_tabbar.hide();
            if(this_obj._view_close_click_func != null && this_obj._view_close_click_func != undefined)
            {
                this_obj._view_close_click_func(this_obj._view_close_click_func_ctx);
            }
            return true;
        });

        this.view_tabbar.setClickedCallback(function(tabbar,index,this_obj){
            tabbar.removeAllCellsSelectedState();
            tabbar.setSelectedIndex(index,true);
            tabbar.setCellSelectedState();
            tabbar.scrollToSelectedItem(true);

            if(this_obj._view_slidebar_cell_selected_func != null
                &&this_obj._view_slidebar_cell_selected_func != undefined)
            {
                this_obj._view_slidebar_cell_selected_func(this_obj,index,this_obj._view_slidebar_cell_selected_func_ctx);
            }
        },this);

        this.view_blockflow_div.setClickedCallback(function(blockflow_div,index,this_obj){
            if(this_obj._view_blockflow_cell_selected_func != null
                &&this_obj._view_blockflow_cell_selected_func != undefined)
            {
                this_obj._view_blockflow_cell_selected_func(this_obj,index,this_obj._view_blockflow_cell_selected_func_ctx);
            }
        },this);

        this.view_tabbar.scrollToSelectedItem(false);

        this.hide(false);

        // 初始化数据

        return this;
    };

    CommonBlockFlowPopbox.prototype._updateViewPosition = function() {
    };

    // 滑动组件初始化
    CommonBlockFlowPopbox.prototype._resetIScroll = function() {
        if(this.view_up_container != null && this.view_up_container != undefined)
        {
            var up_iscroller = this.view_up_container.find(".iscroll_type_element");
            if(up_iscroller != null && up_iscroller != undefined)
            {
                var id_uis = up_iscroller.attr("id");
                if(id_uis == null || id_uis == undefined)
                {
                    id_uis = "iscroll_type_element"+this.popbox_id.substr(1,this.popbox_id.length - 1);
                    up_iscroller.attr("id",id_uis);
                }
                CommonUtil.useIScrollType("#"+id_uis);
                this.iscroller_id = id_uis;

                //兼容lazyload
                var fireScrollEvent = function(){
                    $(document.body).trigger('scroll');
                };
                var iscroll_obj = CommonUtil.getIScrollTypeUsedObject("#"+id_uis);
                iscroll_obj.on('scroll',fireScrollEvent);
                iscroll_obj.on('scrollEnd',fireScrollEvent);
            }
        }
    };

    CommonBlockFlowPopbox.prototype.resetBoxCells = function() {
        this.view_blockflow_div.resetTabCells();
        var this_obj = this;
        setTimeout(function () {
            CommonUtil.getIScrollTypeUsedObject("#"+this_obj.iscroller_id).refresh();
        }, 80);
    };

    // 生成结果展示时的效果
    CommonBlockFlowPopbox.prototype.show = function(isAnimated) {
        this.view_popbox.show(isAnimated);
        //this.view_loading_tips.showLoadingIcon(false);
        this.view_popbox.showContentBox();
        this.view_blockflow_div.show();

        var css_change = {"visibility":"visible"};
        this.view_pop_box_up_content_box.css(css_change);
        if(isAnimated)
        {
            this.view_up_container.animate(css_change,200);
        }
        else
        {
            this.view_up_container.css(css_change);
        }
    };

    // 隐藏
    CommonBlockFlowPopbox.prototype.hide = function(isAnimated) {
        this.view_popbox.hide(isAnimated);
        this.view_loading_tips.hideLoadingIcon(false);
        this.view_popbox.hideContentBox();
        this.view_blockflow_div.hide();

        var css_change = {"visibility":"hidden"};
        this.view_pop_box_up_content_box.css(css_change);
        if(isAnimated)
        {
            this.view_up_container.animate(css_change,200);
        }
        else
        {
            this.view_up_container.css(css_change);
        }
    };

    // 查询取得cell的Rect:{"x" : x, "y" : y, "w" : w, "h" : h}
    CommonBlockFlowPopbox.prototype.rectOfCellAtIndex = function(index) {
        var cell = this.view_blockflow_div.cellAtIndex(index);
        if(cell != null && cell != undefined)
        {
            return {"x":this.view_blockflow_div.posXOfCellAtIndex(index),"y":this.view_blockflow_div.posYOfCellAtIndex(index),"w":cell.width(),"h":cell.height()};
        }
        return null;
    };

    // 查询cell适合滚动到的Y
    CommonBlockFlowPopbox.prototype.scrollableOffsetYOfCellAtIndex = function(index) {
        if(index != null && index != undefined && index >= 0)
        {
            var cell_h = this.view_blockflow_div.cellAtIndex(index).height();
            var view_h = this.view_pop_box_up_content_box.height();
            var content_h = this.view_blockflow_div.view_blockflow_out_box.height();
            var cellY = this.rectOfCellAtIndex(index).y;
            var offsetY = cellY - (cell_h * 0.5);
            if(offsetY + view_h > content_h)
            {
                offsetY = content_h - view_h;
            }
            else if(offsetY < 0)
            {
                offsetY = 0;
            }
            return -offsetY;
        }
        return null;
    };

    // 事件设置
    CommonBlockFlowPopbox.prototype.setClickTabbarCellCallback = function (func,ctx)
    {
        this._view_slidebar_cell_selected_func = func;
        this._view_slidebar_cell_selected_func_ctx = ctx;
    };

    CommonBlockFlowPopbox.prototype.setClickBlockflowCellCallback = function (func,ctx)
    {
        this._view_blockflow_cell_selected_func = func;
        this._view_blockflow_cell_selected_func_ctx = ctx;
    };

    CommonBlockFlowPopbox.prototype.setClickCloseButtonCallback = function (func,ctx)
    {
        this._view_close_click_func = func;
        this._view_close_click_func_ctx = ctx;
    };
});