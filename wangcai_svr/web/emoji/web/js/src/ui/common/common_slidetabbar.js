define("common_slidetabbar",['iscroll'],function(require, exports, module) {
    require('jquery');
    require('iscroll');
    var CommonAnimations = require('common_animations');
    var CommonUtil = require('common_util');
    var CommonButton = require('common_button')

    // instruction
    function CommonSlideTabbar(container_id,cell_width_percents_to_container,auto_resize_cell_text) {
        this._init(container_id,cell_width_percents_to_container,auto_resize_cell_text);
    }

    module.exports = CommonSlideTabbar;

    //页面
    CommonSlideTabbar.prototype.view_container = null; //容器
    CommonSlideTabbar.prototype.view_inner_content = null;  //滚动部分
    CommonSlideTabbar.prototype.view_slide_tab_arrow = null;  //指示箭头
    CommonSlideTabbar.prototype.view_slide_tab_cells = null; //元素数组

    //数据
    CommonSlideTabbar.prototype.cell_width_percents_to_container = null; //cell的宽度，相对于container的百分比
    CommonSlideTabbar.prototype.selected_cell_index = 0; //当前选中的cell角标
    CommonSlideTabbar.prototype.iscroll_inner_content = null; //拖动滚动

    //状态
    CommonSlideTabbar.prototype.isShowing = false;
    CommonSlideTabbar.prototype.isAutoResizeCellText = false;

    //回调
    CommonSlideTabbar.prototype.onClickedFunc = null;
    CommonSlideTabbar.prototype.onClickedCtx = null;

    //点击
    CommonSlideTabbar.prototype.isTouching = false;
    CommonSlideTabbar.prototype.isTouchMoved = false;
    CommonSlideTabbar.prototype.touchStartX = 0;
    CommonSlideTabbar.prototype.touchStartY = 0;

    CommonSlideTabbar.prototype._init = function(container_id,cell_width_percents_to_container,auto_resize_cell_text) {

        this.view_container = $(container_id);
        this.cell_width_percents_to_container = cell_width_percents_to_container;
        if(auto_resize_cell_text != null && auto_resize_cell_text != undefined)
        {
            this.isAutoResizeCellText = auto_resize_cell_text;
        }

        this.resetTabCells();

        this.setSelectedIndex(0, false);

        this._initIScroll(container_id);

        this._updateItemsPosition();

        var slidetabbar = this;
        $(window).resize(function(){
            // 监听窗口变化，对齐所有子控件
            slidetabbar._updateItemsPosition();
        });

        return this;
    };

    CommonSlideTabbar.prototype.resetTabCells = function() {
        if(this.view_container != null && this.view_container != undefined)
        {
            this.view_inner_content = this.view_container.children(".bts_bottom_inner_content");
            if(this.view_inner_content != null && this.view_inner_content != undefined)
            {
                this.view_slide_tab_arrow = this.view_inner_content.children(".bts_slide_tab_cell_arrow");
                this.view_slide_tab_cells = this.view_inner_content.children(".bts_slide_tab_cell");

                for(var i = 0; i < this.view_slide_tab_cells.length; ++i)
                {
                    var cell = this.view_slide_tab_cells[i];
                    var tabbar = this;
                    if (!navigator.userAgent.match(/mobile/i))
                    {
                        $(cell).on("mousedown",{index:i},function(event){
                            CommonSlideTabbar._onMouseStart(tabbar,event,event.data.index);
                        });
                        $(cell).on("mousemove",{index:i},function(event){
                            CommonSlideTabbar._onMouseMoved(tabbar,event,event.data.index);
                        });
                        $(cell).on("mouseup",{index:i},function(event){
                            CommonSlideTabbar._onMouseEnd(tabbar,event,event.data.index);
                        });

                        //this.view.mousedown(CommonButton.onMouseDown);
                        //this.view.mouseup(CommonButton.onMouseClicked);
                        //this.view.mouseout(CommonButton.onMouseLeave);
                    }
                    else
                    {
                        $(cell).on("touchstart",{index:i},function(event){
                            CommonSlideTabbar._onTouchStart(tabbar,event,event.data.index);
                        });
                        $(cell).on("touchmove",{index:i},function(event){
                            CommonSlideTabbar._onTouchMoved(tabbar,event,event.data.index);
                        });
                        $(cell).on("touchend",{index:i},function(event){
                            CommonSlideTabbar._onMouseEnd(tabbar,event,event.data.index);
                        });
                    }


                }
            }
        }

        this._updateItemsPosition();

        // 刷新下iscroll保证滚动范围正确
        var this_obj = this;
        setTimeout(function () {
            this_obj.iscroll_inner_content.refresh();
        }, 80);
        // 懒加载触发一下
        $("img.bts_slide_tab_cell_image_icon").lazyload({
            effect : "fadeIn"
        });
    };

    CommonSlideTabbar._onMouseStart = function (tabbar, event, index) {
        tabbar.isTouching = true;
        tabbar.isTouchMoved = false;
    };

    CommonSlideTabbar._onMouseMoved = function (tabbar, event, index) {
        if(tabbar.isTouching)
        {
            tabbar.isTouchMoved = true;
        }
    };

    CommonSlideTabbar._onTouchStart = function (tabbar, event, index) {
        tabbar.isTouching = true;
        tabbar.isTouchMoved = false;
        var touch = event.originalEvent.changedTouches[0];
        tabbar.touchStartX = touch.pageX;
        tabbar.touchStartY = touch.pageY;
    };

    CommonSlideTabbar._onTouchMoved = function (tabbar, event, index) {
        if(tabbar.isTouching && !tabbar.isTouchMoved)
        {
            var touch = event.originalEvent.changedTouches[0];
            var x = touch.pageX;
            var y = touch.pageY;

            var offsetX = x - tabbar.touchStartX;
            var offsetY = y - tabbar.touchStartY;

            if((offsetX*offsetX) + (offsetY*offsetY) >= 64)
            {
                // 偏移超过 8 像素，认为是拖动
                tabbar.isTouchMoved = true;
            }
        }
    };

    CommonSlideTabbar._onMouseEnd = function (tabbar, event, index) {
        if(tabbar.isTouching && !tabbar.isTouchMoved)
        {
            if(tabbar.onClickedFunc != null && tabbar.onClickedFunc != undefined)
            {
                tabbar.onClickedFunc(tabbar,index,tabbar.onClickedCtx);
            }
        }
        tabbar.isTouching = false;
        tabbar.isTouchMoved = false;
    };

    CommonSlideTabbar.prototype._updateItemsPosition = function() {
        var vw = this.view_container.width();
        var vh = this.view_container.height();

        var tabbar = this;
        this.view_slide_tab_cells.each(function(i,n) {
                var w = vw * tabbar.cell_width_percents_to_container / 100.0;
                var offset = i * w;
                var cell = $(this);
                if(i == tabbar.selected_cell_index)
                {
                    tabbar.view_slide_tab_arrow.css({"left":""+offset+"px","width":""+w+"px"});
                }
                cell.css({"left":""+offset+"px","width":""+w+"px"});

                if(tabbar.isAutoResizeCellText)
                {
                    cell.find(".bts_slide_tab_cell_text").css({"font-size":""+(vw*3.0/100.0)+"px"});
                }
            }
        );
        var w = vw * tabbar.cell_width_percents_to_container / 100.0;
        var wic = w * this.view_slide_tab_cells.length;
        this.view_inner_content.css({"width":""+wic+"px"});
    };

    CommonSlideTabbar.prototype._initIScroll = function(container_id) {
        if(container_id != null && container_id != undefined)
        {
            var iscroll_obj = new IScroll(container_id,
                {
                    scrollX: true,
                    scrollY:false,
                    freeScroll: true,
                    probeType: 2
                }
            );
            this.iscroll_inner_content = iscroll_obj;
            //兼容lazyload
            var fireScrollEvent = function(){
                $(document.body).trigger('scroll');
            };
            iscroll_obj.on('scroll',fireScrollEvent);
            iscroll_obj.on('scrollEnd',fireScrollEvent);
        }
    };

    //////////////////////////////////////////////

    CommonSlideTabbar.prototype.show = function() {
        if(this.isShowing)
        {
            return;
        }
        this.isShowing = true;

        this.view_container.css("visibility", "visible");
        this.view_inner_content.css("visibility", "visible");
        this.view_slide_tab_arrow.css("visibility", "visible");
        this.view_slide_tab_arrow.find().css("visibility", "visible");
        for(var i = 0; i < this.view_slide_tab_cells.length; ++i)
        {
            var cell = $(this.view_slide_tab_cells[i]);
            cell.css("visibility", "visible");
            cell.find().css("visibility", "visible");
        }
    };

    CommonSlideTabbar.prototype.hide = function() {
        if(!this.isShowing)
        {
            return;
        }
        this.isShowing = false;

        this.view_container.css("visibility", "hidden");
        this.view_inner_content.css("visibility", "hidden");
        this.view_slide_tab_arrow.css("visibility", "hidden");
        this.view_slide_tab_arrow.find().css("visibility", "hidden");
        for(var i = 0; i < this.view_slide_tab_cells.length; ++i)
        {
            var cell = $(this.view_slide_tab_cells[i]);
            cell.css("visibility", "hidden");
            cell.find().css("visibility", "hidden");
        }
    };

    //////////////////////////////////////////////

    CommonSlideTabbar.prototype.setSelectedIndex = function(index,isAnimated,scrollToSelectedItem) {
        if(scrollToSelectedItem == null || scrollToSelectedItem == undefined)
        {
            scrollToSelectedItem = true;
        }

        var oldIndex = this.selected_cell_index;
        var newIndex = index;
        if(newIndex < 0)
        {
            newIndex = 0;
        }
        else if(newIndex >= this.view_slide_tab_cells.length)
        {
            newIndex = this.view_slide_tab_cells.length - 1;
        }

        if(this.view_slide_tab_cells.length <= 0 || oldIndex == newIndex)
        {
            return;
        }

        if(isAnimated)
        {
            this._updateItemsPosition();
            var vw = this.view_container.width();
            var cell_width = vw * this.cell_width_percents_to_container / 100.0;
            var selected_offset = newIndex * cell_width;
            var tabbar = this;
            this.view_slide_tab_arrow.animate(
                {"left":""+selected_offset+"px","width":""+cell_width+"px"},
                300,
                "swing",
                function(){
                    tabbar._updateItemsPosition();
                }
            );
            this.selected_cell_index = newIndex;
        }
        else
        {
            this.selected_cell_index = newIndex;
            this._updateItemsPosition();
        }
    };

    CommonSlideTabbar.prototype.getSelectedIndex = function(index) {
        return this.selected_cell_index;
    };

    CommonSlideTabbar.prototype.scrollToSelectedItem = function(isAnimated) {
        if(this.view_slide_tab_cells.length <= 0)
        {
            return;
        }

        var vw = this.view_container.width();
        var cell_width = vw * this.cell_width_percents_to_container / 100.0;
        var content_width = cell_width * this.view_slide_tab_cells.length;
        var selected_offset = this.selected_cell_index * cell_width;
        var scroll_to_offset = 0;

        var needScroll = false;

        if(selected_offset < 0 - this.iscroll_inner_content.x)
        {
            scroll_to_offset = selected_offset - (cell_width * 0.4);
            needScroll = true;
        }
        else if(selected_offset + cell_width > 0 - this.iscroll_inner_content.x + vw)
        {
            scroll_to_offset = selected_offset + (cell_width * 1.4) - vw;
            needScroll = true;
        }
        if(!needScroll)
        {
            return;
        }


        if(scroll_to_offset + vw > content_width)
        {
            scroll_to_offset = content_width - vw;
        }

        if(scroll_to_offset <= 0)
        {
            scroll_to_offset = 0;
        }

        scroll_to_offset = 0 - scroll_to_offset;



        if(isAnimated)
        {
            this.iscroll_inner_content.scrollTo(scroll_to_offset,0,150,IScroll.utils.ease.bounce);
        }
        else
        {
            this.iscroll_inner_content.scrollTo(scroll_to_offset,0,0);
        }
    };

    //////////////////////////////////////////////

    CommonSlideTabbar.prototype.removeAllCellsSelectedState = function() {
        for(var i = 0; i < this.view_slide_tab_cells.length; ++i)
        {
            var cell = $(this.view_slide_tab_cells[i]);
            var selectedCells = cell.find(".bts_slide_tab_cell_image_selected");
            if(selectedCells != null && selectedCells != undefined)
            {
                selectedCells.removeClass("bts_slide_tab_cell_image_selected");
                selectedCells.addClass("bts_slide_tab_cell_image");
            }
        }
    };

    CommonSlideTabbar.prototype.setCellSelectedState = function() {
        var cell = $(this.view_slide_tab_cells[this.selected_cell_index]);
        var selectedCells = cell.find(".bts_slide_tab_cell_image");
        if(selectedCells != null && selectedCells != undefined)
        {
            selectedCells.removeClass("bts_slide_tab_cell_image");
            selectedCells.addClass("bts_slide_tab_cell_image_selected");
        }
    };

    //////////////////////////////////////////////

    CommonSlideTabbar.prototype.setClickedCallback = function (func,ctx)
    {
        this.onClickedFunc = func;
        this.onClickedCtx = ctx;
    };
});