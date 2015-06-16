//
//  CommonPullRefreshViewController.m
//  wangcai
//
//  Created by Lee Justin on 14-10-2.
//  Copyright (c) 2014年 1528studio. All rights reserved.
//

#import "CommonPullRefreshViewController.h"
#import "LoginAndRegister.h"
#import "UIGetRedBagAlertView.h"
#import "UINavigationController+UIGestureRecognizerDelegate.h"


@interface CommonPullRefreshViewControllerCallerWrapper : NSObject

@property (nonatomic,assign) CommonPullRefreshViewController* caller;

@end

@implementation CommonPullRefreshViewControllerCallerWrapper

@end

@interface CommonPullRefreshViewController ()

@end

@implementation CommonPullRefreshViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onRedBagAlertViewHasShown) name:kUIGetRedBagAlertViewShownNotification object:nil];
    
    //开启侧滑Pop功能
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)])
    {
        self.navigationController.interactivePopGestureRecognizer.delegate = self.navigationController;
    }
    
    [self _setupSubViews];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.yueView setNum:[[LoginAndRegister sharedInstance] getBalance] withAnimation:NO];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    self.tableView = nil;
    self.headerBgLongView = nil;
    self.header.scrollView = nil;
    self.header = nil;
    self.footer.scrollView = nil;
    self.footer = nil;
    self.navigationBarTitleLabel = nil;
    self.navigationBarView = nil;
    
    [_yueContainerView release];
    [_yueView release];
    [_failedBGTipLabel release];
    [super dealloc];
}

- (void)_setupSubViews
{
    UIView* longView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 0)] autorelease];
    longView.backgroundColor = [UIColor whiteColor];//[UIColor colorWithRed:0.084 green:0.406 blue:0.796 alpha:1.000];
    self.headerBgLongView = longView;
    [self.view insertSubview:longView belowSubview:self.tableView];

    //tableView
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    // Header
    MJRefreshHeaderView *header = [MJRefreshHeaderView header];
    header.backgroundColor = [UIColor clearColor];
    CommonPullRefreshViewControllerCallerWrapper* wrapper = [[[CommonPullRefreshViewControllerCallerWrapper alloc] init] autorelease];
    wrapper.caller = self;
    header.beginRefreshingBlock = ^(MJRefreshBaseView *refreshView) {
        // 进入刷新状态就会回调这个Block
        
        // 模拟延迟加载数据，因此2秒后才调用）
        // 这里的refreshView其实就是header
        NSLog(@"%@----开始进入刷新状态", refreshView.class);
        [wrapper.caller onStartHeaderRefresh];
    };
    header.endStateChangeBlock = ^(MJRefreshBaseView *refreshView) {
        // 刷新完毕就会回调这个Block
        NSLog(@"%@----刷新完毕", refreshView.class);
    };
    header.refreshStateChangeBlock = ^(MJRefreshBaseView *refreshView, MJRefreshState state) {
        // 控件的刷新状态切换了就会调用这个block
        switch (state) {
            case MJRefreshStateNormal:
                NSLog(@"%@----切换到：普通状态", refreshView.class);
                break;
                
            case MJRefreshStatePulling:
                NSLog(@"%@----切换到：松开即可刷新的状态", refreshView.class);
                break;
                
            case MJRefreshStateRefreshing:
                NSLog(@"%@----切换到：正在刷新状态", refreshView.class);
                break;
            default:
                break;
        }
    };
    header.scrollView = self.tableView;
    header.arrowImage.image = [UIImage imageNamed:@"table_view_pull_icon"];
    header.arrowImage.clipsToBounds = NO;
    header.arrowImage.contentMode = UIViewContentModeScaleAspectFill;
    header.statusLabel.textColor = RGB(15, 151, 208);
    header.activityView.color = RGB(15, 151, 208);
    header.lastUpdateTimeLabel.textColor = RGB(15, 151, 208);
    self.header = header;
    
    // Footer
    MJRefreshFooterView *footer = [MJRefreshFooterView footer];
    footer.backgroundColor = [UIColor clearColor];
    footer.beginRefreshingBlock = ^(MJRefreshBaseView *refreshView) {
        // 进入刷新状态就会回调这个Block
        
        // 模拟延迟加载数据，因此2秒后才调用）
        // 这里的refreshView其实就是footer
        NSLog(@"%@----开始进入刷新状态", refreshView.class);
        [wrapper.caller onStartFooterRefresh];
    };
    footer.endStateChangeBlock = ^(MJRefreshBaseView *refreshView) {
        // 刷新完毕就会回调这个Block
        NSLog(@"%@----刷新完毕", refreshView.class);
    };
    footer.refreshStateChangeBlock = ^(MJRefreshBaseView *refreshView, MJRefreshState state) {
        // 控件的刷新状态切换了就会调用这个block
        switch (state) {
            case MJRefreshStateNormal:
                NSLog(@"%@----切换到：普通状态", refreshView.class);
                break;
                
            case MJRefreshStatePulling:
                NSLog(@"%@----切换到：松开即可刷新的状态", refreshView.class);
                break;
                
            case MJRefreshStateRefreshing:
                NSLog(@"%@----切换到：正在刷新状态", refreshView.class);
                break;
            default:
                break;
        }
    };
    footer.scrollView = self.tableView;
    footer.arrowImage.image = [UIImage imageNamed:@"table_view_pull_icon"];
    footer.arrowImage.clipsToBounds = NO;
    footer.arrowImage.contentMode = UIViewContentModeScaleAspectFill;
    footer.statusLabel.textColor = RGB(15, 151, 208);
    footer.activityView.color = RGB(15, 151, 208);
    footer.lastUpdateTimeLabel.textColor = RGB(15, 151, 208);
    self.footer = footer;
    
    self.failedBGTipLabel.text = @"正在刷新...";
}

- (void)doneWithView:(MJRefreshBaseView *)refreshView
{
    // 刷新表格
    [self.tableView reloadData];
    // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
    [refreshView endRefreshing];
}

#pragma mark - <UITableViewDelegate>

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    int row = indexPath.row;
    if (row == 0)
    {
        return 172;
    }
    return 80;//[_tableViewDataDictArr ]
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

#pragma mark - <UITableViewDataSource>

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return nil;
}

#pragma mark - <UIScrollViewDelegate>

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGRect rectHeaderLongView = CGRectMake(0, 50, scrollView.frame.size.width, -scrollView.contentOffset.y);
    if (rectHeaderLongView.size.height < 0)
    {
        rectHeaderLongView.size.height = 0;
    }
    self.headerBgLongView.frame = rectHeaderLongView;
}

#pragma mark -

- (IBAction)onClickNaviback:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)onRedBagAlertViewHasShown
{
    [self.yueView setNum:[[LoginAndRegister sharedInstance] getBalance] withAnimation:YES];
}

#pragma mark 子类覆盖
- (void) onStartHeaderRefresh
{
    assert(0);
}

- (void) onStartFooterRefresh
{
    assert(0);
}

@end
