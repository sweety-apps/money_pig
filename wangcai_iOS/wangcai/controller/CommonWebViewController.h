//
//  CommonWebViewController.h
//  wangcai
//
//  Created by Lee Justin on 14-10-28.
//  Copyright (c) 2014年 1528studio. All rights reserved.
//

#import "CommonPullRefreshViewController.h"
#import "CommonWebViewTableViewCell.h"

@interface CommonWebViewController : CommonPullRefreshViewController

// 默认可以下拉刷新
+ (CommonWebViewController*) controllerWithUrl:(NSString *)url
                       andNavigationbarBgColor:(UIColor *)navigationbarBgColor;

+ (CommonWebViewController*) controllerWithUrl:(NSString *)url
                       andNavigationbarBgColor:(UIColor *)navigationbarBgColor
                             enablePullRefresh:(BOOL)enablePullRefresh;

// 子类使用，外部不用
@property (nonatomic,retain) CommonWebViewTableViewCell* webviewCell;
@property (nonatomic,retain) NSString* url;
@property (nonatomic,retain) UIColor* navBgColor;
@property (nonatomic,assign) BOOL enablePullRefresh;

@end

