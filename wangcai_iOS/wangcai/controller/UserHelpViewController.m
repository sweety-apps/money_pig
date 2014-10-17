//
//  UserHelpViewController.m
//  wangcai
//
//  Created by Lee Justin on 14-10-16.
//  Copyright (c) 2014年 1528studio. All rights reserved.
//

#import "UserHelpViewController.h"
#import "HelpTableViewCell.h"

@interface UserHelpViewController ()

@property (nonatomic,retain) HelpTableViewCell* helpCell;

@end

@implementation UserHelpViewController

+ (UserHelpViewController*) controller
{
    UserHelpViewController* ret = [[[UserHelpViewController alloc] initWithNibName:@"CommonPullRefreshViewController" bundle:nil] autorelease];
    return ret;
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self _setupHeaderFooterNavibar];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"HelpTableViewCell" bundle:nil] forCellReuseIdentifier:@"HelpTableViewCell"];
    
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    self.helpCell = nil;
    [super dealloc];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void) _setupHeaderFooterNavibar
{
    self.navigationBarView.backgroundColor = RGB(238, 81, 9);
    self.navigationBarTitleLabel.text = @"帮助";
    
    self.header.scrollView = nil;
    self.header.hidden = YES;
    self.footer.scrollView = nil;
    self.footer.hidden = YES;
}

- (void) _onPressedCopyQQ
{
    UIPasteboard* pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = @"365957583";
    
    NSString* msg = [NSString stringWithFormat:@"已复制QQ群号: %@",pasteboard.string];
    UIAlertView* alertView = [[[UIAlertView alloc] initWithTitle: msg message: nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil] autorelease];
    [alertView show];
}

- (void) _onPressedCopyWX
{
    UIPasteboard* pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = @"gh_181777780aee";
    
    NSString* msg = [NSString stringWithFormat:@"已复制微信公众号: %@",pasteboard.string];
    UIAlertView* alertView = [[[UIAlertView alloc] initWithTitle: msg message: nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil] autorelease];
    [alertView show];
}

- (void) _onPressedPrivacyPolicyBtn
{
    PrivacyPolicyView* view = [PrivacyPolicyView privacyPolicyView];
    [view showInWindow:YES];
}

#pragma mark 子类覆盖
- (void) onStartHeaderRefresh
{
    //
}

- (void) onStartFooterRefresh
{
    //[[BillingHistoryList sharedInstance] requestGetMoreBillingHis:self];
}

#pragma mark - <UITableViewDelegate>
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 400;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

#pragma mark - <UITableViewDataSource>
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    int row = indexPath.row;
    UITableViewCell* retCell = nil;
    
    HelpTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"HelpTableViewCell" forIndexPath:indexPath];
    if (cell == nil)
    {
        cell = CREATE_NIBVIEW(@"HelpTableViewCell");
    }
    retCell = cell;
    
    if (self.helpCell == nil)
    {
        self.helpCell = cell;
        [self.helpCell.qqCopyBtn addTarget:self action:@selector(_onPressedCopyQQ) forControlEvents:UIControlEventTouchDown];
        [self.helpCell.wxCopyBtn addTarget:self action:@selector(_onPressedCopyWX) forControlEvents:UIControlEventTouchDown];
        [self.helpCell.privacyPolicyBtn addTarget:self action:@selector(_onPressedPrivacyPolicyBtn) forControlEvents:UIControlEventTouchDown];
    }
    
    
    return retCell;
}

#pragma mark - <UIScrollViewDelegate>
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [super scrollViewDidScroll:scrollView];
}

@end
