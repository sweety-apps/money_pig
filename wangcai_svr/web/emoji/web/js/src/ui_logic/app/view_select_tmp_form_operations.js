define("view_select_tmp_form_operations",[],function(require, exports, module) {
    require('jquery');
    var CommonUILogic = require('common_ui_logic');
    var API = require('api');

    // 这里的代码考虑node表单操作的复用，【node可以使用jquery：node-jquery】

    // instruction
    function ViewSelectTemplateFormOperations() {

        this._init();

    }

    module.exports = ViewSelectTemplateFormOperations;

    //页面

    //数据

    //回调

    // 单例
    var gInstance = null;

    ViewSelectTemplateFormOperations.prototype._init = function() {
        // 成员变量

        // 初始化UI

        // 事件处理

        // 初始化数据

        return this;
    };

    ////////////////////////请求///////////////////////////

    // 拉取列表数据
    ViewSelectTemplateFormOperations.prototype.refreshItemList = function(typeid,success_callback,success_ctx,fail_callback,fail_ctx) {

        var url = API.URL.url_get_templete_list;
        var params = {"type":typeid};
        var this_obj = this;

        CommonUILogic.requestDATA(
            url,
            params,
            function(success_ctx,data)
            {
                success_callback(success_ctx,data);
            },
            success_ctx,
            function(fail_ctx,msg,ret)
            {
                fail_callback(fail_ctx,msg,ret)
            },
            fail_ctx
        );
    };

    // 拉取分类数据
    ViewSelectTemplateFormOperations.prototype.refreshCategoryList = function(id,success_callback,success_ctx,fail_callback,fail_ctx) {

        var url = API.URL.url_get_templete_category;
        var params = {"id":id};
        var this_obj = this;

        CommonUILogic.requestDATA(
            url,
            params,
            function(success_ctx,data)
            {
                success_callback(success_ctx,data);
            },
            success_ctx,
            function(fail_ctx,msg,ret)
            {
                fail_callback(fail_ctx,msg,ret)
            },
            fail_ctx
        );
    };


    ////////////////////////表单处理///////////////////////////

    // 生成列表成功数据
    ViewSelectTemplateFormOperations.prototype.generateListForm = function(data) {
        $("#view_select_tmp").find("#view_select_tmp_blockflow_inner_box").empty();
        var list = data.list;
        var html = "";
        for(var i = 0; i < list.length; ++i)
        {
            var itemJson = list[i];
            var itemHtml = "<div class=\"view_select_tmp_up_content_cell\">"+
                "<img class=\"view_select_tmp_up_content_cell_img\" "+
                "src=data:image/gif;base64,R0lGODlhAQABAAAAACH5BAEKAAEALAAAAAABAAEAAAICTAEAOw== "+
                "data-original=\"" + itemJson.picurl + "\" "+
                "width=\"200\" "+
                "height=\"200\" "+
                "alt=\"表情icon\">"+
                "<img class=\"view_select_tmp_up_content_cell_border\" "+
                "src=\"img/templete_cell_box.png\" "+
                "alt=\"" + itemJson.tag + " 表情制作的边框\">"+
                "<div class=\"view_select_tmp_up_content_cell_text\">"+
                     "<p><b>" + itemJson.text1 + "</b></p>"+
                     "<p>" + itemJson.text2 + "</p>"+
                "</div></div>";
            html = html + itemHtml;
        }
        $("#view_select_tmp").find("#view_select_tmp_blockflow_inner_box").html(html);
    };

    // 生成列表失败数据
    ViewSelectTemplateFormOperations.prototype.generateListErrorForm = function(msg) {
        $("#view_select_tmp").find("#view_select_tmp_blockflow_inner_box").empty();
        var html = "<p style='text-align: center;color: #ff0000'>Netork Error: "+msg+"</p>";
        $("#view_select_tmp").find("#view_select_tmp_blockflow_inner_box").html(html);
    };

    // 生成分类数据
    ViewSelectTemplateFormOperations.prototype.generateCategoryForm = function(data) {
        $("#view_select_tmp").find(".bts_bottom_inner_content").empty();
        var list = data.list;
        var html = "<div class=\"bts_slide_tab_cell_arrow\"><img class=\"bts_slide_tab_cell_arrow_img\" src=\"img/slide_arrow.png\"></div>";
        for(var i = 0; i < list.length; ++i)
        {
            var itemJson = list[i];
            var itemHtml = "<div class=\"bts_slide_tab_cell\">" +
                "<div class=\"bts_slide_tab_cell_image_div\">" +
                "<div class=\"bts_slide_tab_cell_image\">" +
                "<img class=\"bts_slide_tab_cell_image_border\" src=\"img/slide_tab_icon_box_big.png\" alt=\"" + itemJson.name + " 表情制作 分类边框\">" +
                "<img class=\"bts_slide_tab_cell_image_icon\" src=data:image/gif;base64,R0lGODlhAQABAAAAACH5BAEKAAEALAAAAAABAAEAAAICTAEAOw== " +
                "data-original=\"" + itemJson.thumbnail_url + "\" "+
                "width=\"200\" height=\"200\" alt=\""+ itemJson.name +"表情 分类\">" +
                "</div>" +
                "</div>" +
                "<div class=\"bts_slide_tab_cell_text\">" + itemJson.name + "</div>" +
                "</div>";
            html = html + itemHtml;
        }
        $("#view_select_tmp").find(".bts_bottom_inner_content").html(html);
    };

    // 生成分类失败数据
    ViewSelectTemplateFormOperations.prototype.generateCategoryErrorForm = function(msg) {
        $("#view_select_tmp").find(".bts_bottom_inner_content").empty();
        var html = "<p style='text-align: center;color: #ff0000'>Netork Error: "+msg+"</p>";
        $("#view_select_tmp").find(".bts_bottom_inner_content").html(html);
    };

    // 单例
    ViewSelectTemplateFormOperations.getShareInstance = function() {
        if(gInstance == null || gInstance == undefined)
        {
            gInstance = new ViewSelectTemplateFormOperations();
        }
        return gInstance;
    }
});