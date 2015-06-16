define("view_main_form_operations",[],function(require, exports, module) {
    require('jquery');
    var CommonUILogic = require('common_ui_logic');
    var API = require('api');

    // 这里的代码考虑node表单操作的复用，【node可以使用jquery：node-jquery】

    // instruction
    function ViewMainFormOperations() {

        this._init();

    }

    module.exports = ViewMainFormOperations;

    //页面

    //数据

    //回调

    // 单例
    var gInstance = null;

    ViewMainFormOperations.prototype._init = function() {
        // 成员变量

        // 初始化UI

        // 事件处理

        // 初始化数据

        return this;
    };

    ////////////////////////请求///////////////////////////

    // 拉取单个模板数据
    ViewMainFormOperations.prototype.requestItem = function(id,success_callback,success_ctx,fail_callback,fail_ctx) {

        var url = API.URL.url_get_templete;
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

    // 生成新模板
    ViewMainFormOperations.prototype.requestGenerateTempleteItem = function(pic_id,text1,text2,success_callback,success_ctx,fail_callback,fail_ctx) {

        var url = API.URL.url_generate_templete;
        var params = {"pic_id":pic_id,"text1":text1,"text2":text2};
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
            fail_ctx,
            "post"
        );
    };

    ////////////////////////表单处理///////////////////////////

    // 生成成功数据
    ViewMainFormOperations.prototype.generateForm = function(data) {

        $("#view_main").find("#view_main_image").attr({"src":data.result_picurl,"alt":data.tag});

        $("#view_edit").find("#view_edit_picture").attr({"src":data.picurl,"alt":data.tag});
        $("#view_edit").find("#view_edit_text").attr({"value":data.text1,"name":data.text1});
        $("#view_edit").find("#view_edit_text2").attr({"value":data.text2,"name":data.text2});

        $("#view_edit").find("#view_edit_text_bg_img").attr({"alt":data.text1});
        $("#view_edit").find("#view_edit_text2_bg_img").attr({"alt":data.text2});
    };

    // 生成失败数据
    ViewMainFormOperations.prototype.generateErrorForm = function(msg) {
    };

    // 单例
    ViewMainFormOperations.getShareInstance = function() {
        if(gInstance == null || gInstance == undefined)
        {
            gInstance = new ViewMainFormOperations();
        }
        return gInstance;
    }
});