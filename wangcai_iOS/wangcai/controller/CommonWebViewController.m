//
//  CommonWebViewController.m
//  wangcai
//
//  Created by Lee Justin on 14-10-28.
//  Copyright (c) 2014年 1528studio. All rights reserved.
//

#import "CommonWebViewController.h"
#import "PrivacyPolicyView.h"

@interface CommonWebViewController () <UIWebViewDelegate>

@end

@implementation CommonWebViewController

+ (CommonWebViewController*) controllerWithUrl:(NSString *)url
                       andNavigationbarBgColor:(UIColor *)navigationbarBgColor
{
    return [CommonWebViewController controllerWithUrl:url andNavigationbarBgColor:navigationbarBgColor enablePullRefresh:YES];
}


+ (CommonWebViewController*) controllerWithUrl:(NSString *)url
                       andNavigationbarBgColor:(UIColor *)navigationbarBgColor
                             enablePullRefresh:(BOOL)enablePullRefresh
{
    CommonWebViewController* ret = [[[CommonWebViewController alloc] initWithNibName:@"CommonPullRefreshViewController" bundle:nil] autorelease];
    ret.url = url;
    ret.navBgColor = navigationbarBgColor;
    ret.enablePullRefresh = enablePullRefresh;
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
    
    [self.tableView registerNib:[UINib nibWithNibName:@"CommonWebViewTableViewCell" bundle:nil] forCellReuseIdentifier:@"CommonWebViewTableViewCell"];
    
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    self.webviewCell = nil;
    self.url = nil;
    self.navBgColor = nil;
    [super dealloc];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void) _setupHeaderFooterNavibar
{
    if(self.navBgColor)
    {
        self.navigationBarView.backgroundColor = self.navBgColor;
    }
    self.navigationBarTitleLabel.text = @"";
    
    self.header.scrollView = nil;
    self.header.hidden = NO;
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
    [self.webviewCell.webView reload];
}

- (void) onStartFooterRefresh
{
    //[[BillingHistoryList sharedInstance] requestGetMoreBillingHis:self];
}

#pragma mark - <UITableViewDelegate>
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return self.view.frame.size.height - self.navigationBarView.frame.size.height;
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
    
    CommonWebViewTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"CommonWebViewTableViewCell" forIndexPath:indexPath];
    if (cell == nil)
    {
        cell = CREATE_NIBVIEW(@"CommonWebViewTableViewCell");
    }
    retCell = cell;
    
    if (self.webviewCell == nil)
    {
        self.webviewCell = cell;
        self.webviewCell.webView.delegate = self;
        if (self.enablePullRefresh)
        {
            self.header.scrollView = self.webviewCell.webView.scrollView;
        }
        else
        {
            self.header.scrollView = nil;
        }
        CGRect rectCell = retCell.frame;
        retCell.frame = rectCell;
        [retCell setNeedsLayout];
        [self.webviewCell.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.url]]];
    }
    
    return retCell;
}

#pragma mark - <UIScrollViewDelegate>
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [super scrollViewDidScroll:scrollView];
}

#pragma mark - <UIWebViewDelegate>

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [self.header endRefreshing];
    self.navigationBarTitleLabel.text = [self.webviewCell.webView stringByEvaluatingJavaScriptFromString:@"document.title"];;
    self.failedBGTipLabel.text = @"";
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [self.header endRefreshing];
    self.navigationBarTitleLabel.text = @"网络请求失败";
    self.failedBGTipLabel.text = @"加载失败，千万表下拉？";
}

@end
