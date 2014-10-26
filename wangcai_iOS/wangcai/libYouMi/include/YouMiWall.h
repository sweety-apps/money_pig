//
//  YouMiWall.h
//  YouMiSDK
//
//  Created by Layne on 12-01-05.
//  Copyright (c) 2012年 YouMi Mobile Co. Ltd. All rights reserved.
//


#import <Foundation/Foundation.h>
#import "YouMiConfig.h"
#import "YouMiWallAppModel.h"
#import "YouMiPointsManager.h"


typedef enum {
    YouMiWallAnimationTransitionNone,  // no animation
    YouMiWallAnimationTransitionZoomIn,
    YouMiWallAnimationTransitionZoomOut,
    YouMiWallAnimationTransitionFade,
    YouMiWallAnimationTransitionPushFromBottom,
    YouMiWallAnimationTransitionPushFromTop
} YouMiWallAnimationTransition;


@interface YouMiWall : NSObject

// Launch Youmi offerwall
// 启动有米积分墙
+ (void)enable;


// Show offerwall
// param rewarded If it is rewarded offerwall mode
// param didShowBlock The executed block when successfully showing offerwall
// param didDismissBlock The executed block when closing offerwall
// returns If successfully showing offerwall. If not, the function didShowBlock and didDismissBlock won't be invoked.
//
// 显示积分墙
// param rewarded 是不是有积分模式
// param didShowBlock 成功显示积分墙时执行的block
// param didDismissBlock 关闭积分墙后执行的block
// returns 是否显示积分墙成功，积分墙显示不成功并不会调用didShowBlock和didDismissBlock
+ (BOOL)showOffers:(BOOL)rewarded didShowBlock:(void (^)(void))didShowBlock didDismissBlock:(void (^)(void))didDismissBlock;


// To choose if to show the guide of user obtaining currency points or not
// Suggest set it to be true. The default value is true.
//
// 是否显示用户获取积分指南
// 建议设置为true，默认不设置是true。
//
+ (void)showGuideMap:(BOOL)isShowGuideMap;



// Get the App ADs list of offerwall
// param rewarded If it is rewarded offerwall mode
// param page The page number of the request data
// param count The number of ADs in each page.(For example, requestPage is 1, adCountPage is 3, then it can be considered there are 3 apps in each page storing in server. Each time the server will return the 3 apps from specific page)
// param recievedBlock The block to receive ADs list. The content of NSArray is @[YouMiWallAppModel, YouMiWallAppModel...]; Fail to get the list, there is record in NSError.
//
// 获取积分墙的App广告列表
// param rewarded 是不是有积分模式
// param page 请求的数据第几页
// param count 每页有多少个广告（比如设置的requestPage为1，adCountPage为3.那么数据就可以看成是每页3个应用的形式在服务器上，每次请求服务器就把对应页的3个应用返回）
// param recievedBlock 接收广告列表的block, 其中NSArray的内容是 @[YouMiWallAppModel, YouMiWallAppModel...]; 获取列表失败, 在NSError里有记录.
//
+ (void)requestOffersOpenData:(BOOL)rewarded page:(NSInteger)requestPage count:(NSInteger)adCountPage revievedBlock:(void (^)(NSArray*, NSError *))recievedBlock;



// This will request the first page data in default, 10 records for each page.
// 这个默认请求第1页数据，每页10个
+ (void)requestOffersOpenData:(BOOL)rewarded revievedBlock:(void (^)(NSArray*, NSError *))recievedBlock;


// Install the apps in offerwall安装积分墙中的APP
// param app The App acquired through requestOffersOpenData
//
// 安装积分墙中的APP
// param app 通过requestOffersOpenData获得的APP
//
+ (void)userInstallApp:(YouMiWallAppModel *)app;


@end


