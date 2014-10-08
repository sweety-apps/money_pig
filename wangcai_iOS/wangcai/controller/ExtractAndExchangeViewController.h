//
//  ExtractAndExchangeViewController.h
//  wangcai
//
//  Created by Lee Justin on 14-10-8.
//  Copyright (c) 2014年 1528studio. All rights reserved.
//

#import "CommonPullRefreshViewController.h"
#import "ExtractAndExchangeTableViewCell.h"

@interface ExtractAndExchangeViewController : CommonPullRefreshViewController

+ (ExtractAndExchangeViewController*) controller;

@property (nonatomic,retain) BeeUIStack* beeUIStack;

@end
