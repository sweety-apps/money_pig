define("view_select_tmp",[],function(require, exports, module) {
    require('jquery');
    require('jquery.lazyload');
    var CommonButton = require('common_button');
    var CommonAnimations = require('common_animations');
    var CommonUtil = require('common_util');
    var CommonBlockFlowPopbox = require('common_blockflow_popbox');
    var ViewSelectTempleteFormOperations = require('view_select_tmp_form_operations');
    var ViewSharedData = require('view_shared_data');

    // instruction
    function ViewSelectTemplete() {

        this._init();

    }

    module.exports = ViewSelectTemplete;

    //页面
    ViewSelectTemplete.prototype.view_blockflow_popbox = null;
    ViewSelectTemplete.prototype.view_up_content_title = null;
    ViewSelectTemplete.prototype.view_up_content_subtitle = null;

    //数据

    //回调
    ViewSelectTemplete.prototype.onDidSelectedItemCallbackFunc = null;
    ViewSelectTemplete.prototype.onDidSelectedItemCallbackCtx = null;
    ViewSelectTemplete.prototype.onDidClickedCloseCallbackFunc = null;
    ViewSelectTemplete.prototype.onDidClickedCloseCallbackCtx = null;


    ViewSelectTemplete.prototype._init = function() {
        //对齐比例
        this._adjustItemCSSPerportyVWUnit();

        // 成员变量

        // 初始化UI
        this.view_blockflow_popbox = new CommonBlockFlowPopbox(
            "#view_select_tmp","img/popbox_bg_right_top_btn.png","img/popbox_bg_right_top_btn_a.png",21.875,1.0,
            "#view_select_tmp_bottom_tabbar",22,true,
            "#view_select_tmp_up_tips_container","img/loading_icon.gif",
            "#view_select_tmp_blockflow_out_box",".view_select_tmp_up_content_cell",true
        );

        this.view_up_content_title = $("#view_select_tmp").find(".view_pop_box_up_content_title");
        this.view_up_content_subtitle = $("#view_select_tmp").find(".view_pop_box_up_content_subtitle");

        var title_id = "view_up_content_title_select_pic";
        var subtitle_id = "view_pop_box_up_content_subtitle_select_pic";
        this.view_up_content_title.attr("id",title_id);
        this.view_up_content_subtitle.attr("id",subtitle_id);

        CommonUtil.setFontForItem("#"+title_id,3.2);
        CommonUtil.setFontForItem("#"+subtitle_id,1.7);

        this.initAllCells();

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
        $("img.view_select_tmp_up_content_cell_img").lazyload({
            effect : "fadeIn"
        });
        $("img.bts_slide_tab_cell_image_icon").lazyload({
            effect : "fadeIn"
        });

        this.hide(false);

        return this;
    };

    //
    ViewSelectTemplete.prototype._adjustItemCSSPerportyVWUnit = function() {
        // 宽度自适应bug修正
        CommonUtil.setAttributeValueToVWUnit(".view_select_tmp_up_content_cell",42,"width");
        CommonUtil.setAttributeValueToVWUnit(".view_select_tmp_up_content_cell",50.55,"height");
        CommonUtil.updateAttributeValueToVWUnit();

        CommonUtil.setAttributeValueToVMINUnit(".view_select_tmp_up_content_cell_text",3.0,"font-size");
        CommonUtil.updateAttributeValueToVMINUnit();
    };

    ViewSelectTemplete.prototype._updateViewPosition = function() {
    };

    // 展示
    ViewSelectTemplete.prototype.show = function(isAnimated) {
        this.view_blockflow_popbox.show(isAnimated);
        this.view_up_content_title.css({"visibility":"visible"});
        this.view_up_content_subtitle.css({"visibility":"visible"});
    };

    // 隐藏
    ViewSelectTemplete.prototype.hide = function(isAnimated) {
        this.view_blockflow_popbox.hide(isAnimated);
        this.view_up_content_title.css({"visibility":"hidden"});
        this.view_up_content_subtitle.css({"visibility":"hidden"});
    };

    // tabbar选中
    ViewSelectTemplete.prototype.onDidSelectedTabbarCell = function(index) {
        this.view_blockflow_popbox.view_blockflow_div.hide();
        this.view_blockflow_popbox.view_loading_tips.showLoadingIcon(false);

        // 请求模板列表
        var listType = ViewSharedData.getShareInstance().fetchedTempleteCategory[index].type;
        this.current_selected_type = listType;
        this.requestAndRefreshUIWithCurrentCategoryType();
    };

    // blockflow选中
    ViewSelectTemplete.prototype.onDidSelectedBlockflowCell = function(index) {
        this.removeAllCellsSelectedState();
        this.setCellSelectedState(index);
        this._setCurrentSelectedData(index);
    };

    ViewSelectTemplete.prototype.requestAndRefreshUIWithCurrentCategoryType = function() {
        var this_obj = this;
        ViewSelectTempleteFormOperations.getShareInstance().refreshItemList(
            this.current_selected_type,
            function(success_ctx,data){
                ViewSelectTempleteFormOperations.getShareInstance().generateListForm(data);
                this_obj.resetBoxCells();
                ViewSharedData.getShareInstance().fetchedTempleteList = data.list;
                this_obj._autoSelectCellWithSelectedTempleteType();
                // 懒加载
                $("img.view_select_tmp_up_content_cell_img").lazyload({
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
                ViewSelectTempleteFormOperations.getShareInstance().generateListErrorForm(msg);
                CommonUtil.getIScrollTypeUsedObject("#"+this_obj.view_blockflow_popbox.iscroller_id).scrollTo(0,0,0);
                this_obj.view_blockflow_popbox.view_loading_tips.hideLoadingIcon(false);
                this_obj.view_blockflow_popbox.view_blockflow_div.show();
            },
            this);
    };

    // 选中+数据
    ViewSelectTemplete.prototype._setCurrentSelectedData = function(index) {
        var list = ViewSharedData.getShareInstance().fetchedTempleteList;
        if(list != null && list != undefined)
        {
            var item = list[index];
            if(item != null && item != undefined)
            {
                ViewSharedData.getShareInstance().selectedTempleteItem = JSON.parse(JSON.stringify(item));  //拷贝一份使用
            }
        }
    };

    // 查找选中的index
    ViewSelectTemplete.prototype._findSelectedIndexInFetchedList = function() {
        var index = null;
        var list = ViewSharedData.getShareInstance().fetchedTempleteList;
        var tmp_id = ViewSharedData.getShareInstance().selectedTempleteItem.id;
        if(list != null && list != undefined)
        {
            for(var i = 0; i < list.length; ++i)
            {
                var item = list[i];
                if(item.id == tmp_id)
                {
                    index = i;
                    break;
                }
            }
        }
        return index;
    };

    // 根据选中的pic_type更新选中的列表项
    ViewSelectTemplete.prototype._autoSelectCellWithSelectedTempleteType = function() {
        var index = this._findSelectedIndexInFetchedList();
        if(index != null && index != undefined)
        {
            this.onDidSelectedBlockflowCell(index);
        }
    };

    // 刷新blockflow内容
    ViewSelectTemplete.prototype.resetBoxCells = function() {
        this.view_blockflow_popbox.resetBoxCells();
        CommonUtil.updateAttributeValueToVMINUnit();
    };

    //////////////////////////////////////////////

    ViewSelectTemplete.prototype.initAllCells = function() {
        var cells = this.view_blockflow_popbox.view_blockflow_div.view_block_cells;
        for(var i = 0; i < cells.length; ++i)
        {
            var cell = $(cells[i]);
            var cellText = cell.find(".view_select_tmp_up_content_cell_text");
            if(cellText != null && cellText != undefined)
            {
                var textId = cellText.attr("id");
                if(textId == null || textId == undefined)
                {
                    textId = "view_select_tmp_up_content_cell_text"+i;
                    cellText.attr("id",textId);
                }
                CommonUtil.setFontForItem("#"+textId,1.6);
            }
        }
    };

    ViewSelectTemplete.prototype.removeAllCellsSelectedState = function() {
        var cells = this.view_blockflow_popbox.view_blockflow_div.view_block_cells;
        for(var i = 0; i < cells.length; ++i)
        {
            var cell = $(cells[i]);
            var selectedCells = cell.find(".view_select_tmp_up_content_cell_border");
            if(selectedCells != null && selectedCells != undefined)
            {
                selectedCells.attr({"src":"img/templete_cell_box.png"});
            }
        }
    };

    ViewSelectTemplete.prototype.setCellSelectedState = function(index) {
        var cells = this.view_blockflow_popbox.view_blockflow_div.view_block_cells;
        var cell = $(cells[index]);
        var selectedCells = cell.find(".view_select_tmp_up_content_cell_border");
        if(selectedCells != null && selectedCells != undefined)
        {
            selectedCells.attr({"src":"img/templete_cell_box_a.png"});
        }
    };

    ViewSelectTemplete.prototype.setDidSelectedItemCallback = function (func,ctx)
    {
        this.onDidSelectedItemCallbackFunc = func;
        this.onDidSelectedItemCallbackCtx = ctx;
    };

    ViewSelectTemplete.prototype.setDidClickCloseCallback = function (func,ctx)
    {
        this.onDidClickedCloseCallbackFunc = func;
        this.onDidClickedCloseCallbackCtx = ctx;
    };
});