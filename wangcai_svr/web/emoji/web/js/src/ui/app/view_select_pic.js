define("view_select_pic",[],function(require, exports, module) {
    require('jquery');
    require('jquery.lazyload');
    var CommonButton = require('common_button');
    var CommonAnimations = require('common_animations');
    var CommonUtil = require('common_util');
    var CommonBlockFlowPopbox = require('common_blockflow_popbox');
    var ViewSelectPictureFormOperations = require('view_select_pic_form_operations');
    var ViewSharedData = require('view_shared_data');

    // instruction
    function ViewSelectPiciture() {

        this._init();

    }

    module.exports = ViewSelectPiciture;

    //页面
    ViewSelectPiciture.prototype.view_blockflow_popbox = null;
    ViewSelectPiciture.prototype.view_up_content_title = null;
    ViewSelectPiciture.prototype.view_up_content_subtitle = null;

    //数据
    ViewSelectPiciture.prototype.current_selected_type = null;  //底部tabbar选中图片的分类

    //回调
    ViewSelectPiciture.prototype.onDidSelectedItemCallbackFunc = null;
    ViewSelectPiciture.prototype.onDidSelectedItemCallbackCtx = null;
    ViewSelectPiciture.prototype.onDidClickedCloseCallbackFunc = null;
    ViewSelectPiciture.prototype.onDidClickedCloseCallbackCtx = null;


    ViewSelectPiciture.prototype._init = function() {
        //对齐比例
        this._adjustItemCSSPerportyVWUnit();

        // 成员变量

        // 初始化UI
        this.view_blockflow_popbox = new CommonBlockFlowPopbox(
            "#view_select_pic","img/popbox_bg_right_top_btn.png","img/popbox_bg_right_top_btn_a.png",21.875,1.0,
            "#view_select_pic_bottom_tabbar",22,true,
            "#view_select_pic_up_tips_container","img/loading_icon.gif",
            "#view_select_pic_blockflow_out_box",".view_select_pic_up_content_cell",true
        );

        this.view_up_content_title = $("#view_select_pic").find(".view_pop_box_up_content_title");
        this.view_up_content_subtitle = $("#view_select_pic").find(".view_pop_box_up_content_subtitle");

        var title_id = "view_up_content_title_select_pic";
        var subtitle_id = "view_pop_box_up_content_subtitle_select_pic";
        this.view_up_content_title.attr("id",title_id);
        this.view_up_content_subtitle.attr("id",subtitle_id);

        CommonUtil.setFontForItem("#"+title_id,3.2);
        CommonUtil.setFontForItem("#"+subtitle_id,1.7);

        var this_obj = this;
        $(window).resize(function(){
            // 监听窗口变化，对齐蒙层
            this_obj._updateViewPosition();
        });
        this._updateViewPosition();

        // 事件处理
        this.view_blockflow_popbox.setClickTabbarCellCallback(function(popbox,index,this_obj){
            this_obj.onDidSelectedTabbarCell(index);
        },this);

        this.view_blockflow_popbox.setClickBlockflowCellCallback(function(popbox,index,this_obj){
            this_obj.onDidSelectedBlockflowCell(index);
            this_obj.hide(true);

            if(this_obj.onDidSelectedItemCallbackFunc != null && this_obj.onDidSelectedItemCallbackFunc != undefined)
            {
                this_obj.onDidSelectedItemCallbackFunc(this_obj, this_obj.onDidSelectedItemCallbackCtx);
            }
        },this);

        this.view_blockflow_popbox.setClickCloseButtonCallback(function(this_obj){
            if(this_obj.onDidClickedCloseCallbackFunc != null && this_obj.onDidClickedCloseCallbackFunc != undefined)
            {
                this_obj.onDidClickedCloseCallbackFunc(this_obj, this_obj.onDidClickedCloseCallbackCtx);
            }
        },this);

        // 懒加载
        $("img.view_select_pic_up_content_cell_img").lazyload({
            effect : "fadeIn"
        });
        $("img.bts_slide_tab_cell_image_icon").lazyload({
            effect : "fadeIn"
        });

        this.hide(false);

        return this;
    };

    //
    ViewSelectPiciture.prototype._adjustItemCSSPerportyVWUnit = function() {
        // 宽度自适应bug修正
        CommonUtil.setAttributeValueToVWUnit(".view_select_pic_up_content_cell",28,"width");
        CommonUtil.setAttributeValueToVWUnit(".view_select_pic_up_content_cell",28.55,"height");
        CommonUtil.updateAttributeValueToVWUnit();
    };

    ViewSelectPiciture.prototype._updateViewPosition = function() {
    };

    // 展示
    ViewSelectPiciture.prototype.show = function(isAnimated) {
        this.view_blockflow_popbox.show(isAnimated);
        this.view_up_content_title.css({"visibility":"visible"});
        this.view_up_content_subtitle.css({"visibility":"visible"});
    };

    // 隐藏
    ViewSelectPiciture.prototype.hide = function(isAnimated) {
        this.view_blockflow_popbox.hide(isAnimated);
        this.view_up_content_title.css({"visibility":"hidden"});
        this.view_up_content_subtitle.css({"visibility":"hidden"});
    };

    // tabbar选中
    ViewSelectPiciture.prototype.onDidSelectedTabbarCell = function(index) {
        this.view_blockflow_popbox.view_blockflow_div.hide();
        this.view_blockflow_popbox.view_loading_tips.showLoadingIcon(false);

        // 请求图片列表
        var listType = ViewSharedData.getShareInstance().fetchedPictureCategory[index].type;
        this.current_selected_type = listType;
        this.requestAndRefreshUIWithCurrentCategoryType();
    };

    // blockflow选中
    ViewSelectPiciture.prototype.onDidSelectedBlockflowCell = function(index) {
        this.removeAllCellsSelectedState();
        this.setCellSelectedState(index);
        this._setCurrentSelectedData(index);
    };

    ViewSelectPiciture.prototype.requestAndRefreshUIWithCurrentCategoryType = function() {
        var this_obj = this;
        ViewSelectPictureFormOperations.getShareInstance().refreshItemList(
            this.current_selected_type,
            function(success_ctx,data){
                ViewSelectPictureFormOperations.getShareInstance().generateListForm(data);
                this_obj.resetBoxCells();
                ViewSharedData.getShareInstance().fetchedPictureList = data.list;
                this_obj._autoSelectCellWithSelectedPictureType();
                // 懒加载
                $("img.view_select_pic_up_content_cell_img").lazyload({
                    effect : "fadeIn"
                });
                CommonUtil.getIScrollTypeUsedObject("#"+this_obj.view_blockflow_popbox.iscroller_id).scrollTo(0,0,0);

                // 找到选中那条滚过去
                var scrollOffsetY = 0;
                var selectedIndex = this_obj._findSelectedIndexInFetchedList();
                if(selectedIndex != null && selectedIndex != undefined)
                {
                    scrollOffsetY = this_obj.view_blockflow_popbox.scrollableOffsetYOfCellAtIndex(selectedIndex);
                }
                setTimeout(function(){
                    CommonUtil.getIScrollTypeUsedObject("#"+this_obj.view_blockflow_popbox.iscroller_id).scrollTo(0,scrollOffsetY,0);
                    $(document.body).trigger('scroll'); //兼容lazyload
                    //
                    this_obj.view_blockflow_popbox.view_loading_tips.hideLoadingIcon(false);
                    this_obj.view_blockflow_popbox.view_blockflow_div.show();
                },120);
            },
            this,
            function(fail_ctx,msg,ret){
                ViewSelectPictureFormOperations.getShareInstance().generateListErrorForm(msg);
                CommonUtil.getIScrollTypeUsedObject("#"+this_obj.view_blockflow_popbox.iscroller_id).scrollTo(0,0,0);
                this_obj.view_blockflow_popbox.view_loading_tips.hideLoadingIcon(false);
                this_obj.view_blockflow_popbox.view_blockflow_div.show();
            },
            this);
    };

    // 选中+数据
    ViewSelectPiciture.prototype._setCurrentSelectedData = function(index) {
        var list = ViewSharedData.getShareInstance().fetchedPictureList;
        if(list != null && list != undefined)
        {
            var item = list[index];
            if(item != null && item != undefined)
            {
                ViewSharedData.getShareInstance().selectedTempleteItem.pic_id = item.pic_id;
                ViewSharedData.getShareInstance().selectedTempleteItem.pic_type = item.pic_type;
                ViewSharedData.getShareInstance().selectedTempleteItem.picurl = item.picurl;
            }
        }
    };

    // 查找选中的index
    ViewSelectPiciture.prototype._findSelectedIndexInFetchedList = function() {
        var index = null;
        var list = ViewSharedData.getShareInstance().fetchedPictureList;
        var pic_id = ViewSharedData.getShareInstance().selectedTempleteItem.pic_id;
        if(list != null && list != undefined)
        {
            for(var i = 0; i < list.length; ++i)
            {
                var item = list[i];
                if(item.pic_id == pic_id)
                {
                    index = i;
                    break;
                }
            }
        }
        return index;
    };

    // 根据选中的pic_type更新选中的列表项
    ViewSelectPiciture.prototype._autoSelectCellWithSelectedPictureType = function() {
        var index = this._findSelectedIndexInFetchedList();
        if(index != null && index != undefined)
        {
            this.onDidSelectedBlockflowCell(index);
        }
    };

    // 刷新blockflow内容
    ViewSelectPiciture.prototype.resetBoxCells = function() {
        this.view_blockflow_popbox.resetBoxCells();
    };

    //////////////////////////////////////////////

    ViewSelectPiciture.prototype.removeAllCellsSelectedState = function() {
        var cells = this.view_blockflow_popbox.view_blockflow_div.view_block_cells;
        for(var i = 0; i < cells.length; ++i)
        {
            var cell = $(cells[i]);
            var selectedCells = cell.find(".view_select_pic_up_content_cell_border");
            if(selectedCells != null && selectedCells != undefined)
            {
                selectedCells.attr({"src":"img/pic_cell_box.png"});
            }
        }
    };

    ViewSelectPiciture.prototype.setCellSelectedState = function(index) {
        var cells = this.view_blockflow_popbox.view_blockflow_div.view_block_cells;
        var cell = $(cells[index]);
        var selectedCells = cell.find(".view_select_pic_up_content_cell_border");
        if(selectedCells != null && selectedCells != undefined)
        {
            selectedCells.attr({"src":"img/pic_cell_box_a.png"});
        }
    };

    ViewSelectPiciture.prototype.setDidSelectedItemCallback = function (func,ctx)
    {
        this.onDidSelectedItemCallbackFunc = func;
        this.onDidSelectedItemCallbackCtx = ctx;
    };

    ViewSelectPiciture.prototype.setDidClickCloseCallback = function (func,ctx)
    {
        this.onDidClickedCloseCallbackFunc = func;
        this.onDidClickedCloseCallbackCtx = ctx;
    };
});