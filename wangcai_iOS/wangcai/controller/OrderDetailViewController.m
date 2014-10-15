//
//  OrderDetailViewController.m
//  wangcai
//
//  Created by Lee Justin on 14-10-11.
//  Copyright (c) 2014年 1528studio. All rights reserved.
//

#import "OrderDetailViewController.h"
#import "LoginAndRegister.h"
#import "MBHUDView.h"
#import "BillingHistoryList.h"
#import "OrderDetailTableViewCell.h"
#import "Config.h"

#define kAlertViewTypeCopyedCode (1)

@interface OrderDetailViewController () <BillingHistoryListDelegate,UIAlertViewDelegate,OrderDetailTableViewCellDelegate>
{
    BOOL _hasRequested;
}

@property (nonatomic,retain) NSString* orderid;
@property (nonatomic,assign) ExtractAndExchangeType orderType;

@end

@implementation OrderDetailViewController

+ (OrderDetailViewController*) controllerWithOrderId:(NSString*)orderid
                                             andType:(ExtractAndExchangeType)type
{
    OrderDetailViewController* ret = [[[OrderDetailViewController alloc] initWithNibName:@"CommonPullRefreshViewController" bundle:nil] autorelease];
    ret.orderid = orderid;
    ret.orderType = type;
    return ret;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        // Custom initialization
        _hasRequested = NO;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self _setupHeaderFooterNavibar];
    self.navigationBarTitleLabel.text = @"正在拉取...";
    
    [self.tableView registerNib:[UINib nibWithNibName:@"OrderDetailTableViewCell" bundle:nil] forCellReuseIdentifier:@"OrderDetailTableViewCell"];
    
    [self onStartHeaderRefresh];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    self.orderid = nil;
    [super dealloc];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void) _setupHeaderFooterNavibar
{
    self.navigationBarView.backgroundColor = [[ExtractAndExchangeLogic sharedInstance] colorForExtractAndExchangeType:self.orderType];
    self.navigationBarTitleLabel.text = @"正在拉取...";
    
    switch (self.orderType) {
        case ExtractAndExchangeTypeJingdong:
        case ExtractAndExchangeTypeXLVip:
        {
            self.navigationBarTitleLabel.text = @"查看兑换码";
        }
            break;
        case ExtractAndExchangeTypeAlipay:
        case ExtractAndExchangeTypePhonePay:
        {
            self.navigationBarTitleLabel.text = @"订单详情";
        }
            break;
            
        default:
            break;
    }
    
    self.header.arrowImage.image = [[ExtractAndExchangeLogic sharedInstance] pullIconForExtractAndExchangeType:self.orderType];
    self.header.statusLabel.textColor = self.navigationBarView.backgroundColor;
    self.header.activityView.color = self.navigationBarView.backgroundColor;
    self.header.lastUpdateTimeLabel.textColor = self.navigationBarView.backgroundColor;
    
    self.footer.arrowImage.image = [[ExtractAndExchangeLogic sharedInstance] pullIconForExtractAndExchangeType:self.orderType];
    self.footer.statusLabel.textColor = self.navigationBarView.backgroundColor;
    self.footer.activityView.color = self.navigationBarView.backgroundColor;
    self.footer.lastUpdateTimeLabel.textColor = self.navigationBarView.backgroundColor;
    
    self.footer.scrollView = nil;
    self.footer.hidden = YES;
}

#pragma mark 子类覆盖
- (void) onStartHeaderRefresh
{
    [[BillingHistoryList sharedInstance] requestOrderDetailWithOrderid:self.orderid delegate:self];
}

- (void) onStartFooterRefresh
{
    //[[BillingHistoryList sharedInstance] requestGetMoreBillingHis:self];
}

#pragma mark - <UITableViewDelegate>
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 380;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

#pragma mark - <UITableViewDataSource>
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([[BillingHistoryList sharedInstance] lastRequestedOrderDetail] != nil && _hasRequested)
    {
        return 1;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    int row = indexPath.row;
    UITableViewCell* retCell = nil;
    
    BillingHistoryOrderDetailRecord* rcd = [[BillingHistoryList sharedInstance] lastRequestedOrderDetail];
    
    OrderDetailTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"OrderDetailTableViewCell" forIndexPath:indexPath];
    if (cell == nil)
    {
        cell = CREATE_NIBVIEW(@"ExtractAndExchangeTableViewCell");
    }
    retCell = cell;
    
    cell.delegate = self;
    [cell setupCellWithOrderDetailRecord:rcd];
    
    return retCell;
}

#pragma mark - <UIScrollViewDelegate>
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [super scrollViewDidScroll:scrollView];
}

#pragma mark - <BillingHistoryListDelegate>

- (void)onFinishedRequestBillingHis:(BillingHistoryList*)logic
                          isSucceed:(BOOL)succeed
                             errMsg:(NSString*)msg
                              datas:(NSArray*)newRecords
                              isEnd:(BOOL)isEndPage
{
    [self.header endRefreshing];
    [self.footer endRefreshing];
    [MBHUDView dismissCurrentHUD];
}

- (void)onFinishedRequestOrderDetail:(BillingHistoryList*)logic
                         orderDetail:(BillingHistoryOrderDetailRecord*)orderDetail
                           isSucceed:(BOOL)succeed
                              errMsg:(NSString*)msg
{
    [self.header endRefreshing];
    [self.footer endRefreshing];
    [MBHUDView dismissCurrentHUD];
    
    if (succeed)
    {
        _hasRequested = YES;
        self.orderType = [[BillingHistoryList sharedInstance] lastRequestedOrderDetail].exchange_type;
        [UIView animateWithDuration:0.3 animations:^(){[self _setupHeaderFooterNavibar];} completion:^(BOOL finished) {
            [self _setupHeaderFooterNavibar];
        }];
        [self.tableView reloadData];
    }
    else
    {
        if ([msg length] <= 0)
        {
            msg = @"请求订单详情失败";
        }
        [MBHUDView hudWithBody:msg type:MBAlertViewHUDTypeImagePositive  hidesAfter:2.0 show:YES];
    }
}

#pragma mark <UIAlertViewDelegate>

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == kAlertViewTypeCopyedCode)
    {
        if (buttonIndex != alertView.cancelButtonIndex)
        {
            switch (self.orderType)
            {
                case ExtractAndExchangeTypeJingdong:
                {
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:WEB_JD_ENCHARGE_CODE]];
                }
                    break;
                
                case ExtractAndExchangeTypeXLVip:
                {
                }
                    break;
                    
                default:
                    break;
            }
        }
    }
}

#pragma mark <OrderDetailTableViewCellDelegate>

- (void) onPressedCheckButtonOfOrderDetailCell:(OrderDetailTableViewCell*)cell
{
    switch (self.orderType)
    {
        case ExtractAndExchangeTypeJingdong:
        case ExtractAndExchangeTypeXLVip:
        {
            UIPasteboard* pasteboard = [UIPasteboard generalPasteboard];
            pasteboard.string = [[BillingHistoryList sharedInstance] lastRequestedOrderDetail].extra;
            
            UIAlertView* alertView = [[UIAlertView alloc] initWithTitle: @"兑换码已复制到剪贴板中" message: nil delegate:self cancelButtonTitle:@"关闭" otherButtonTitles:@"使用兑换码",nil];
            alertView.tag = kAlertViewTypeCopyedCode;
            [alertView show];
            [alertView release];
        }
            break;
            
        default:
            break;
    }
}

@end
