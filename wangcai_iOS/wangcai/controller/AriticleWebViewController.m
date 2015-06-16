//
//  AriticleWebViewController.m
//  wangcai
//
//  Created by Lee Justin on 14-11-3.
//  Copyright (c) 2014年 1528studio. All rights reserved.
//

#import "AriticleWebViewController.h"
#import "Config.h"
#import "OnlineWallViewController.h"
#import "InviteController.h"
#import "UIImage+imageUtils.h"

@interface AriticleWebViewController ()

@end

@implementation AriticleWebViewController

+ (AriticleWebViewController*) controller
{
    AriticleWebViewController* ret = [[[AriticleWebViewController alloc] initWithNibName:@"CommonPullRefreshViewController" bundle:nil] autorelease];
    ret.url = WEB_ARTICLE_URL;
    ret.navBgColor = RGB(168, 207, 73);
    ret.enablePullRefresh = YES;
    return ret;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.toolbarCell = CREATE_NIBVIEW(@"ArticleToolbarTableViewCell");
    self.toolbarCell.delegate = self;
    [self.view addSubview:self.toolbarCell];
    
    self.header.arrowImage.image = [[UIImage imageNamed:@"table_view_pull_icon_white"] imageBlendWithColor:self.navigationBarView.backgroundColor];
    self.header.statusLabel.textColor = self.navigationBarView.backgroundColor;
    self.header.activityView.color = self.navigationBarView.backgroundColor;
    self.header.lastUpdateTimeLabel.textColor = self.navigationBarView.backgroundColor;
    
    [self.tableView reloadData];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    CGRect rectToolbarCell = self.toolbarCell.frame;
    rectToolbarCell.origin.y = self.view.frame.size.height - rectToolbarCell.size.height;
    self.toolbarCell.frame = rectToolbarCell;
    [self.tableView reloadData];
}

- (void)dealloc
{
    self.toolbarCell = nil;
    [super dealloc];
}

#pragma mark - <UITableViewDelegate>
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return self.view.frame.size.height - self.navigationBarView.frame.size.height -self.toolbarCell.frame.size.height;
}

#pragma mark <ArticleToolbarTableViewCellDelegate>

- (void)onArticleToolbarPressedTaskButton:(ArticleToolbarTableViewCell*)cell
{
    [[OnlineWallViewController sharedInstance] setNeedRefreshUI];
    [self.navigationController pushViewController:[OnlineWallViewController sharedInstance] animated:YES];
}

- (void)onArticleToolbarPressedInviteButton:(ArticleToolbarTableViewCell*)cell
{
    InviteController* ctrl = [InviteController controller];
    [self.navigationController pushViewController:ctrl animated:YES];
}

@end
