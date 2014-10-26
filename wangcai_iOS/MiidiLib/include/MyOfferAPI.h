#import <UIKit/UIKit.h>
#import "MyOfferAPIDelegate.h"

/*/
 *  code   :   desc                         Note
 *  0           well servered
 *  20001       bad request!
 *  20002       don't have enought score    // cut points
 *  20003       bad sequence!
 *  20004       device not init             // seq error
 *  20005       interface close             // 接口不允许
 */

// 数据源模式 的 数据模型
@interface MyOfferSourceItem : NSObject

/*
 * 1.弃用部分属性值*
 * 2.预留miidiAppStoreId 属性值, 服务器可能后期传值 1.5.2开始
 * 3.miidiAppImageUrls类型有NSArray 改为NSString 1.5.3开始
 */
//显示相关
@property(nonatomic, retain, readonly) NSString * miidiAdTitle;       //广告标题
@property(nonatomic, retain, readonly) NSString * miidiAdSubtitle;    //广告子标题
@property(nonatomic, retain, readonly) NSString * miidiAdIconUrl;     //广告小图
@property(nonatomic, retain, readonly) NSString * miidiAdEarnStep;    //获取积分步骤提示（例如：首次下载，注册一个新帐号）
@property(nonatomic, assign, readonly) NSInteger  miidiAdScore;       //广告收益
@property(nonatomic, retain, readonly) NSString * miidiAdClick;       //广告点击

// 广告app基本信息
@property(nonatomic, retain, readonly) NSString * miidiAppVersion;      // AdApp版本
@property(nonatomic, retain, readonly) NSString * miidiAppPackage;      // AdApp包名
@property(nonatomic, retain, readonly) NSString * miidiAppStoreId;      // AdAppAppid 服务器暂无值
@property(nonatomic, assign, readonly) NSInteger  miidiAppSize;         // AdApp安装包大小
@property(nonatomic, retain, readonly) NSString * miidiAppImageUrls;    // AdApp截图  //!!!: √数据类型变化
@property(nonatomic, retain, readonly) NSString * miidiAppDescription;  // AdApp包名


// !!!: √ [重要]被废弃掉的属性, 值<不可用>
@property(nonatomic, retain, readonly) NSString * miidiAdId;          //广告标识
@property(nonatomic, retain, readonly) NSString * miidiAdAction;      //用于存储“安装”或“注册”的字段
@property(nonatomic, assign, readonly) NSInteger  miidiAdCacheType;
@property(nonatomic, retain, readonly) NSString * miidiAppName;         // AdApp名称
@property(nonatomic, retain, readonly) NSString * miidiAppProvider;     // AdApp提供商

- (id)initMiidiSourceItemWithDictionary:(NSDictionary *)dictionary;

@end



#pragma mark -
@interface MyOfferAPI : NSObject

#pragma mark - 1_0.* 配置SDK接口<开发者必调接口>
//
// 设置发布应用的应用id, 应用密码信息,必须在应用启动的时候呼叫
// 参数 appID		:开发者应用ID ;     开发者到 www.miidi.net 上提交应用时候,获取id和密码
// 参数 appPassword	:开发者的安全密钥 ;  开发者到 www.miidi.net 上提交应用时候,获取id和密码
//
+ (void)setMiidiAppPublisher:(NSString*) appID withMiidiAppSecret:(NSString*)appSecret;
#pragma mark 1_1.. 设置用户ID接口<开发者可选接口>
// 用于服务器积分对接,设置自定义参数,参数可以传递给对接服务器
// 参数 paramText				: 需要传递给对接服务器的自定义参数
+ (void)setMiidiUserParam:(NSString*)paramText;


#pragma mark - 2_1 资源展示接口
// 显示积分墙
+ (BOOL)showMiidiAppOffers:(UIViewController*)hostViewController withMiidiDelegate:(id<MyOfferAPIDelegate>) delegate;

// 显示无积分推荐墙
// 参数 hostViewController		: 通过api [hostViewController presentModalViewController:nav animated:YES];
+ (BOOL)showMiidiAppOffersNoScore:(UIViewController*)hostViewController withMiidiDelegate:(id<MyOfferAPIDelegate>) delegate;

#pragma mark  2_2 数据源接口
+ (void)requestMiidiAppOffersSourcesWithBlock:(void (^)(NSArray*, NSError *))receivedBlock;
+ (BOOL)requestMiidiClickAd:(MyOfferSourceItem *)item;

#pragma mark - 3 API对接接口
//积分查询, 增加用户积分, 扣除用户积分接口
+ (void)requestMiidiGetPoints:(id<MyOfferAPIDelegate>)delegate;
+ (void)requestMiidiCutPoints:(NSInteger)points withMiidiDelegate:(id<MyOfferAPIDelegate>)delegate;
+ (void)requestMiidiAddPoints:(NSInteger)points withMiidiDelegate:(id<MyOfferAPIDelegate>)delegate;

#pragma mark - 4 其他功能接口
// 获取Miidi广告IOS 版本号
+ (NSString*)getMiidiSdkVersion;

@end
