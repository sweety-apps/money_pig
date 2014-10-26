

#import <UIKit/UIKit.h>
@class MyOfferAPI;


@protocol MyOfferAPIDelegate <NSObject>
@optional



#pragma mark - 积分墙, 推荐墙 展示接口调用后的回掉方法

// 这6个Delegate执行顺序
// --> didMiidiShowWallView
// --> myMiidiOfferViewWillAppear:
// --> myMiidiOfferViewDidAppear:
// --> didMiidiReceiveOffers/didMiidiFailToReceiveOffers:
// --> didMiidiDismissWallView

// 积分墙/推荐墙 视图展示 展开&关闭 Delegate
- (void)didMiidiShowWallView;
- (void)didMiidiDismissWallView;
// 积分墙/推荐墙 数据拉取 成功&失败 Delegate
- (void)didMiidiReceiveOffers;
- (void)didMiidiFailToReceiveOffers:(NSError *)error;
#pragma mark UI DIY
- (void)myMiidiOfferViewWillAppear:(UIViewController *)viewController;
- (void)myMiidiOfferViewDidAppear:(UIViewController *)viewController;

#pragma mark - API对接接口 调用 相关的回掉方法

// 补充：totalPoints: 返回用户的总积分
//      pointName  : 返回的积分名称

// GetValue Delegate
- (void)didMiidiReceiveGetPoints:(NSInteger)totalPoints forMiidiPointName:(NSString*)pointName;
- (void)didMiidiFailReceiveGetPoints:(NSError *)error;
// AddValue Delegate
- (void)didMiidiReceiveAddPoints:(NSInteger)totalPoints;
- (void)didMiidiFailReceiveAddPoints:(NSError *)error;
// CutValue Delegate
- (void)didMiidiReceiveCutPoints:(NSInteger)totalPoints;
- (void)didMiidiFailReceiveCutPoints:(NSError *)error;


#pragma mark - 数据源模式接口

@end
