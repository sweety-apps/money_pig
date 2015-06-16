define("common_blockflow_div",[],function(require, exports, module) {
    require('jquery');
    var CommonButton = require('common_button');
    var CommonAnimations = require('common_animations');
    var CommonUtil = require('common_util');

    // instruction
    function CommonBlockFlowDiv(outbox_id,cell_id,should_auto_adjust_width_with_cell) {
        this._init(outbox_id,cell_id,should_auto_adjust_width_with_cell);
    }

    module.exports = CommonBlockFlowDiv;

    //页面
    CommonBlockFlowDiv.prototype.view_blockflow_out_box = null; //外框
    CommonBlockFlowDiv.prototype.view_blockflow_inner_box = null; //内框
    CommonBlockFlowDiv.prototype.view_block_cells = null;

    //数据
    CommonBlockFlowDiv.prototype.selected_cell_index = 0;
    CommonBlockFlowDiv.prototype.cell_id = null;
    CommonBlockFlowDiv.prototype.outbox_id = null;
    CommonBlockFlowDiv.prototype.should_auto_adjust_width_with_cell = false;

    //状态
    CommonBlockFlowDiv.prototype.isShowing = false;

    //点击
    CommonBlockFlowDiv.prototype.isTouching = false;
    CommonBlockFlowDiv.prototype.isTouchMoved = false;
    CommonBlockFlowDiv.prototype.touchStartX = 0;
    CommonBlockFlowDiv.prototype.touchStartY = 0;

    //回调
    CommonBlockFlowDiv.prototype.onClickedFunc = null;
    CommonBlockFlowDiv.prototype.onClickedCtx = null;

    CommonBlockFlowDiv.prototype._init = function(outbox_id,cell_id,should_auto_adjust_width_with_cell) {
        //对齐比例
        this._adjustItemCSSPerportyVWUnit();

        // 成员变量
        this.cell_id = cell_id;
        this.outbox_id = outbox_id;
        this.should_auto_adjust_width_with_cell = should_auto_adjust_width_with_cell;

        // 初始化UI
        this.resetTabCells();

        this.setSelectedIndex(0);

        var view_div = this;
        $(window).resize(function(){
            // 监听窗口变化，对齐元素
            view_div._updateItemsPosition();
        });
        this._updateItemsPosition();

        return this;
    };

    //
    CommonBlockFlowDiv.prototype._adjustItemCSSPerportyVWUnit = function() {
        // 宽度自适应bug修正
        CommonUtil.setAttributeValueToVWUnit(".view_pop_box_up_content_inner_blockflow_inner_box",86,"width");
        CommonUtil.updateAttributeValueToVWUnit();
    };

    CommonBlockFlowDiv.prototype._refetchBoxsAndCells = function() {
        this.view_blockflow_out_box = $(this.outbox_id);
        this.view_blockflow_inner_box = $(this.outbox_id).children(".view_pop_box_up_content_inner_blockflow_inner_box");
        if(this.view_blockflow_inner_box != null && this.view_blockflow_inner_box != undefined)
        {
            this.view_block_cells = this.view_blockflow_inner_box.children(this.cell_id);
        }
        else
        {
            this.view_block_cells = [];
        }
    }

    CommonBlockFlowDiv.prototype.resetTabCells = function() {
        this._refetchBoxsAndCells();

        for(var i = 0; i < this.view_block_cells.length; ++i)
        {
            var cell = this.view_block_cells[i];
            var this_obj = this;
            if (!navigator.userAgent.match(/mobile/i))
            {
                $(cell).on("mousedown",{index:i},function(event){
                    CommonBlockFlowDiv._onMouseStart(this_obj,event,event.data.index);
                });
                $(cell).on("mousemove",{index:i},function(event){
                    CommonBlockFlowDiv._onMouseMoved(this_obj,event,event.data.index);
                });
                $(cell).on("mouseup",{index:i},function(event){
                    CommonBlockFlowDiv._onMouseEnd(this_obj,event,event.data.index);
                });

                //this.view.mousedown(CommonButton.onMouseDown);
                //this.view.mouseup(CommonButton.onMouseClicked);
                //this.view.mouseout(CommonButton.onMouseLeave);
            }
            else
            {
                $(cell).on("touchstart",{index:i},function(event){
                    CommonBlockFlowDiv._onTouchStart(this_obj,event,event.data.index);
                });
                $(cell).on("touchmove",{index:i},function(event){
                    CommonBlockFlowDiv._onTouchMoved(this_obj,event,event.data.index);
                });
                $(cell).on("touchend",{index:i},function(event){
                    CommonBlockFlowDiv._onMouseEnd(this_obj,event,event.data.index);
                });
            }
        }

        this._updateItemsPosition();
    };

    CommonBlockFlowDiv._onMouseStart = function (this_obj, event, index) {
        this_obj.isTouching = true;
        this_obj.isTouchMoved = false;
    };

    CommonBlockFlowDiv._onMouseMoved = function (this_obj, event, index) {
        if(this_obj.isTouching)
        {
            this_obj.isTouchMoved = true;
        }
    };

    CommonBlockFlowDiv._onTouchStart = function (this_obj, event, index) {
        this_obj.isTouching = true;
        this_obj.isTouchMoved = false;
        var touch = event.originalEvent.changedTouches[0];
        this_obj.touchStartX = touch.pageX;
        this_obj.touchStartY = touch.pageY;
    };

    CommonBlockFlowDiv._onTouchMoved = function (this_obj, event, index) {
        if(this_obj.isTouching && !this_obj.isTouchMoved)
        {
            var touch = event.originalEvent.changedTouches[0];
            var x = touch.pageX;
            var y = touch.pageY;

            var offsetX = x - this_obj.touchStartX;
            var offsetY = y - this_obj.touchStartY;

            if((offsetX*offsetX) + (offsetY*offsetY) >= 64)
            {
                // 偏移超过 8 像素，认为是拖动
                this_obj.isTouchMoved = true;
            }
        }
    };

    CommonBlockFlowDiv._onMouseEnd = function (this_obj, event, index) {
        if(this_obj.isTouching && !this_obj.isTouchMoved)
        {
            if(this_obj.onClickedFunc != null && this_obj.onClickedFunc != undefined)
            {
                this_obj.onClickedFunc(this_obj,index,this_obj.onClickedCtx);
            }
        }
        this_obj.isTouching = false;
        this_obj.isTouchMoved = false;
    };

    CommonBlockFlowDiv.prototype._updateItemsPosition = function() {

        if(this.should_auto_adjust_width_with_cell == false
            || this.should_auto_adjust_width_with_cell == null
            || this.should_auto_adjust_width_with_cell == undefined)
        {
            return;
        }

        var vw = this.view_blockflow_out_box.width();
        //var vh = this.view_blockflow_out_box.height();

        var max_width = -1;

        if(this.view_block_cells.length > 0)
        {
            var max_width_cell = parseInt($(this.view_block_cells[0]).css('max-width'));
            var width_cell = $(this.view_block_cells[0]).width();

            if(width_cell >= max_width_cell)
            {
                width_cell = max_width_cell;
            }

            var dest_width = 0;
            while(dest_width + width_cell <= vw)
            {
                dest_width += width_cell;
            }
            dest_width += 10;

            max_width = dest_width;
        }

        if(max_width >= 0)
        {
            this.view_blockflow_inner_box.css({
                "max-width":""+max_width+"px"
            });
        }
    };

    // 查询取得cell
    CommonBlockFlowDiv.prototype.cellAtIndex = function(index) {
        return $(this.view_block_cells[index]);
    };

    // 查询取得cell相对于Div的位置X
    CommonBlockFlowDiv.prototype.posXOfCellAtIndex = function(index) {
        var cell = this.cellAtIndex(index);
        return this.view_blockflow_out_box.position().left + this.view_blockflow_inner_box.position().left + cell.position().left;
    };

    // 查询取得cell相对于Div的位置Y
    CommonBlockFlowDiv.prototype.posYOfCellAtIndex = function(index) {
        var cell = this.cellAtIndex(index);
        return this.view_blockflow_out_box.position().top + this.view_blockflow_inner_box.position().top + cell.position().top;
    };

    // 展示
    CommonBlockFlowDiv.prototype.show = function() {
        if(this.isShowing)
        {
            return;
        }
        this.isShowing = true;

        //this.resetTabCells();

        this.view_blockflow_out_box.css({"visibility":"visible"});
        this.view_blockflow_inner_box.css({"visibility":"visible"});

        for(var i = 0; i < this.view_block_cells.length; ++i)
        {
            var cell = $(this.view_block_cells[i]);
            cell.css({"visibility":"visible"});
            cell.find("*").css({"visibility":"visible"});
        }
    };

    // 隐藏
    CommonBlockFlowDiv.prototype.hide = function() {
        if(!this.isShowing)
        {
            return;
        }
        this.isShowing = false;

        //this.resetTabCells();

        this.view_blockflow_out_box.css({"visibility": "hidden"});
        this.view_blockflow_inner_box.css({"visibility": "hidden"});

        for(var i = 0; i < this.view_block_cells.length; ++i)
        {
            var cell = $(this.view_block_cells[i]);
            cell.css({"visibility": "hidden"});
            cell.find("*").css({"visibility": "hidden"});
        }
    };

    //////////////////////////////////////////////

    CommonBlockFlowDiv.prototype.setSelectedIndex = function(index) {
        var oldIndex = this.selected_cell_index;
        var newIndex = index;
        if(newIndex < 0)
        {
            newIndex = 0;
        }
        else if(newIndex >= this.view_block_cells.length)
        {
            newIndex = this.view_block_cells.length - 1;
        }

        if(this.view_block_cells.length <= 0 || oldIndex == newIndex)
        {
            return;
        }

        this.selected_cell_index = newIndex;
        this._updateItemsPosition();
    };

    CommonBlockFlowDiv.prototype.getSelectedIndex = function(index) {
        return this.selected_cell_index;
    };

    //////////////////////////////////////////////

    CommonBlockFlowDiv.prototype.setClickedCallback = function (func,ctx)
    {
        this.onClickedFunc = func;
        this.onClickedCtx = ctx;
    };
});