//
//  SiWeiWall.h
//  Spot
//
//  Created by wisdome on 13-12-30.
//  Copyright (c) 2013年 wisdome. All rights reserved.
//

#import <UIKit/UIKit.h>


#define SIWEI_WALL_CLOSED    @"SIWEI_WALL_CLOSED"

/*
 积分墙关闭的通知
 
  eg :
        //注册关闭的通知
         [[NSNotificationCenter defaultCenter]addObserver:self 
                                                 selector:@selector(closed:) 
                                                     name:SIWEI_WALL_CLOSED 
                                                   object:nil];
 
        //实现方法
            - (void)closed:(NSNotification *)noti
                {
                    NSLog(@"积分墙已关闭");
                }
    
*/

@interface SiWeiWall : UIViewController

+ (id)siwei;//实例化积分墙
/*
 //推出积分墙
 eg:   
        SiWeiWall *siwei = [SiWeiWall siwei];
        [siwei showOfferWall:self];
 
 */
- (void)showOfferWall:(UIViewController *)VC;
@end
