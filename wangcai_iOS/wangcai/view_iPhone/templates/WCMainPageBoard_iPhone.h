//
//   ______    ______    ______    
//  /\  __ \  /\  ___\  /\  ___\   
//  \ \  __<  \ \  __\_ \ \  __\_ 
//   \ \_____\ \ \_____\ \ \_____\ 
//    \/_____/  \/_____/  \/_____/ 
//
//  Powered by BeeFramework
//
//
//  WCMainPageBoard_iPhone.h
//  wangcai
//
//  Created by Lee Justin on 13-12-8.
//  Copyright (c) 2013年 1528studio. All rights reserved.
//

#import "Bee.h"
#import "BaseTaskTableViewController.h"

#pragma mark -

@interface WCMainPageBoard_iPhone : BeeUIBoard
{
    BaseTaskTableViewController* _taskTableViewController;
    UICustomAlertView* _alertView;
    
    UIImageView* _headLeftBtnImageView;
    UIImageView* _headRightBtnImageView;
}

@end
