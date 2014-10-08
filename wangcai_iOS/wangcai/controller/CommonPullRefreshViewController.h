//
//  CommonPullRefreshViewController.h
//  wangcai
//
//  Created by Lee Justin on 14-10-2.
//  Copyright (c) 2014年 1528studio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MJRefreshHeaderView.h"
#import "MJRefreshFooterView.h"
#import "CommonYuENumSmallView.h"

@interface CommonPullRefreshViewController : UIViewController <UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,retain) UIView* headerBgLongView;
@property (nonatomic,retain) MJRefreshHeaderView* header;
@property (nonatomic,retain) MJRefreshFooterView* footer;

@property (retain, nonatomic) IBOutlet UIView *yueContainerView;
@property (retain, nonatomic) IBOutlet CommonYuENumSmallView *yueView;

@property (retain, nonatomic) IBOutlet UIView *navigationBarView;
@property (retain, nonatomic) IBOutlet UILabel *navigationBarTitleLabel;
@property (retain, nonatomic) IBOutlet UITableView *tableView;

- (IBAction)onClickNaviback:(id)sender;

#pragma mark 子类覆盖
- (void) onStartHeaderRefresh;
- (void) onStartFooterRefresh;

#pragma mark - <UITableViewDelegate>
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
#pragma mark - <UITableViewDataSource>
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
#pragma mark - <UIScrollViewDelegate>
- (void)scrollViewDidScroll:(UIScrollView *)scrollView;

@end
