define("common_ui_logic",[],function(require, exports, module) {
    require('jquery');

    // 这里的代码考虑node表单操作的复用，【node可以使用jquery：node-jquery】

    // instruction
    function CommonUILogic() {

        this._init();

    }

    module.exports = CommonUILogic;

    CommonUILogic.prototype._init = function() {
        return this;
    };

    // 拉取数据
    CommonUILogic.requestDATA = function(url,params,success_callback,success_ctx,fail_callback,fail_ctx,method) {
        if(method == null || method == undefined)
        {
            method = "get";
        }
        $.ajax({
            type: method,
            url: url,
            dataType: "json",
            cache: false,
            data: params,
            success: function (json) {
                if(json.ret == 0)
                {
                    success_callback(success_ctx,json.data);
                }
                else
                {
                    fail_callback(fail_ctx,json.msg,json.ret);
                }
            },
            error: function(xhr, status, error) {
                fail_callback(fail_ctx,error,-1);
            }
        });
        return this;
    };
});