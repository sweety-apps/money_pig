//
//  BillingHistoryViewController.h
//  wangcai
//
//  Created by Lee Justin on 14-10-2.
//  Copyright (c) 2014年 1528studio. All rights reserved.
//

#import "CommonPullRefreshViewController.h"
#import "BillingHisTotalTableViewCell.h"
#import "BillingHisIncomeTableViewCell.h"
#import "BillingHisOutgoTableViewCell.h"
#import "BillingHistoryList.h"

@interface BillingHistoryViewController : CommonPullRefreshViewController <BillingHistoryListDelegate>

+ (BillingHistoryViewController*) controller;

@end
