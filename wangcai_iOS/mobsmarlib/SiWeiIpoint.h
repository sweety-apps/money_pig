//
//  IPOINT.h
//  ZhiMengIpoint
//
//  Created by wisdome on 13-11-1.
//  Copyright (c) 2013年 wisdome. All rights reserved.
//

#import <Foundation/Foundation.h>

/******
 
 i悠广告打开的通知，如果接收不到打开的通知则说明数据请求失败，请间隔几秒后再次打开
 
 ******/
#define ipointOpenNotification         @"ipointOpenNotification"
/****
 
 i悠广告关闭的通知
 
 *****/
#define ipointClosedNotification       @"ipointClosedNotification"

@interface SiWeiIpoint : NSObject

//是否正在运行
@property (nonatomic,readonly)BOOL    running;

//使用单例类，方便在全局控制
+ (SiWeiIpoint *)defaultIpoint;
/*
 i悠广告显示的方法
 
   eg：  
            SiWeiIpoint *siweIpoint =  [SiWeiIpoint defaultIpoint];
            [siweIpoint startRunning];
 
 */
- (void)startRunning;
/*
 i悠广告打开的方法，每次打开都相应要处理网络数据，有时会出现无数据的情况（无数据情况下，默认是不打开的）
 
 本SDK并不提供关闭的方法，关闭方式有两种情况，点击非广告区域即视为关闭，在用户不做任何操作的情况下，广告展示7秒钟将自动关闭
 */

- (void)iPointOpen;

@end