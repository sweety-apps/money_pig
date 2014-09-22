//
//  Spot.h
//  ZMSpot
//
//  Created by wisdome on 13-12-11.
//  Copyright (c) 2013年 wisdome. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SiWeiSpot : NSObject
/*
 请求插播数据
 */
+ (SiWeiSpot *)requestSpotADs;
/*
 显示插播数据，如果不显示则说明数据没有请求成功
 
   eg：
            [SiWeiSpot showSpotDismiss:^{
               NSLog(@"插播广告关闭");
              }];
 */
+ (BOOL)showSpotDismiss:(void (^)())dismiss;
@end
