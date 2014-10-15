//
//  OrderDetailViewController.h
//  wangcai
//
//  Created by Lee Justin on 14-10-11.
//  Copyright (c) 2014年 1528studio. All rights reserved.
//

#import "CommonPullRefreshViewController.h"
#import "BillingHistoryList.h"

@interface OrderDetailViewController : CommonPullRefreshViewController

+ (OrderDetailViewController*) controllerWithOrderId:(NSString*)orderid
                                             andType:(ExtractAndExchangeType)type;

@end
