define("view_shared_data",[],function(require, exports, module) {
    require('jquery');

    // instruction
    function ViewSharedData() {

        this._init();

    }

    module.exports = ViewSharedData;

    //当前数据
    ViewSharedData.prototype.currentTempleteItem = {};

    //编辑中的数据
    ViewSharedData.prototype.selectedTempleteItem = {};

    //信息配置
    ViewSharedData.prototype.clientInfo = {};

    //缓存数据
    ViewSharedData.prototype.fetchedPictureList = [];
    ViewSharedData.prototype.fetchedTempleteList = [];
    ViewSharedData.prototype.fetchedPictureCategory = [];
    ViewSharedData.prototype.fetchedTempleteCategory = [];

    // 单例
    var gInstance = null;

    ViewSharedData.prototype._init = function() {
        // 成员变量

        // 初始化UI

        // 事件处理

        // 初始化数据

        return this;
    };

    // 单例
    ViewSharedData.getShareInstance = function() {
        if(gInstance == null || gInstance == undefined)
        {
            gInstance = new ViewSharedData();
        }
        return gInstance;
    }
});