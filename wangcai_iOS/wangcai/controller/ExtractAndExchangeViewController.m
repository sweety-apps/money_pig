//
//  ExtractAndExchangeViewController.m
//  wangcai
//
//  Created by Lee Justin on 14-10-8.
//  Copyright (c) 2014年 1528studio. All rights reserved.
//

#import "ExtractAndExchangeViewController.h"
#import "LoginAndRegister.h"
#import "MBHUDView.h"
#import "ExtractAndExchangeLogic.h"
#import "TransferToAlipayAndPhoneController.h"

#define kAlertViewTypeNotEnoughRemain (1)
#define kAlertViewTypeContinueExchange (2)

@interface ExtractAndExchangeViewController () <ExtractAndExchangeLogicDelegate,UIAlertViewDelegate>
{
    ExtractAndExchangeListItem* _currentExchangeItem;
}
@end

@implementation ExtractAndExchangeViewController

@synthesize beeUIStack;

+ (ExtractAndExchangeViewController*) controller
{
    return [[[ExtractAndExchangeViewController alloc] initWithNibName:@"CommonPullRefreshViewController" bundle:nil] autorelease];
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
    
    self.navigationBarView.backgroundColor = RGB(66, 193, 206);
    self.navigationBarTitleLabel.text = @"兑换现金";
    
    self.header.arrowImage.image = [UIImage imageNamed:@"table_view_pull_icon_exhange"];
    self.header.statusLabel.textColor = RGB(66, 193, 206);
    self.header.activityView.color = RGB(66, 193, 206);
    self.header.lastUpdateTimeLabel.textColor = RGB(66, 193, 206);
    
    self.footer.statusLabel.textColor = RGB(66, 193, 206);
    self.footer.activityView.color = RGB(66, 193, 206);
    self.footer.lastUpdateTimeLabel.textColor = RGB(66, 193, 206);
    self.footer.arrowImage.image = [UIImage imageNamed:@"table_view_pull_icon_exhange"];
    
    self.footer.scrollView = nil;
    self.footer.hidden = YES;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"ExtractAndExchangeTableViewCell" bundle:nil] forCellReuseIdentifier:@"ExtractAndExchangeTableViewCell"];
    
    [self onStartHeaderRefresh];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    self.beeUIStack = nil;
    [super dealloc];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

#pragma mark 

- (void)clickAlipay:(ExtractAndExchangeListItem*)item
{
    TransferToAlipayAndPhoneController* controller = [[[TransferToAlipayAndPhoneController alloc]init:1 BeeUIStack:self.beeUIStack andItem:item] autorelease];
    
    [self.beeUIStack pushViewController:controller animated:YES];
}

- (void)clickPhone:(ExtractAndExchangeListItem*)item
{
    TransferToAlipayAndPhoneController* controller = [[[TransferToAlipayAndPhoneController alloc]init:2 BeeUIStack:self.beeUIStack andItem:item] autorelease];
    [self.beeUIStack pushViewController:controller animated:YES];
}

#pragma mark 子类覆盖
- (void) onStartHeaderRefresh
{
    [[ExtractAndExchangeLogic sharedInstance] requestExtractAndExchangeList:self];
}

- (void) onStartFooterRefresh
{
    //[[BillingHistoryList sharedInstance] requestGetMoreBillingHis:self];
}

#pragma mark - <UITableViewDelegate>
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    int row = indexPath.row;
    ExtractAndExchangeListItem* rcd = [[ExtractAndExchangeLogic sharedInstance] getExtractAndExchangeList][row];
    switch (rcd.type)
    {
        case ExtractAndExchangeTypeJingdong:
        case ExtractAndExchangeTypeXLVip:
        {
            UIAlertView* alert = nil;
            if ([rcd.remain intValue] <= 0)
            {
                alert = [[UIAlertView alloc] initWithTitle:@"库存已红血，无法兑换" message:@"请耐心等待1-2天，库存补充后即可兑换。" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
                alert.tag = kAlertViewTypeNotEnoughRemain;
            }
            else
            {
                NSString* msg = [NSString stringWithFormat:@"%@\n兑换价格：%@元",rcd.name,[NSNumber numberWithFloat:([rcd.price floatValue] / 100.f)]];
                alert = [[UIAlertView alloc] initWithTitle:@"请确认兑换信息" message:msg delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"继续兑换",nil];
                _currentExchangeItem = [rcd retain];
                alert.tag = kAlertViewTypeContinueExchange;
            }
            [alert show];
        }
            break;
            
        case ExtractAndExchangeTypeAlipay:
        {
            [self clickAlipay:rcd];
        }
            break;
        case ExtractAndExchangeTypePhonePay:
        {
            [self clickPhone:rcd];
        }
            break;
        default:
            break;
    }
}

#pragma mark - <UITableViewDataSource>
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[[ExtractAndExchangeLogic sharedInstance] getExtractAndExchangeList] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    int row = indexPath.row;
    UITableViewCell* retCell = nil;
    
    ExtractAndExchangeListItem* rcd = [[ExtractAndExchangeLogic sharedInstance] getExtractAndExchangeList][row];
    
    ExtractAndExchangeTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"ExtractAndExchangeTableViewCell" forIndexPath:indexPath];
    if (cell == nil)
    {
        cell = CREATE_NIBVIEW(@"ExtractAndExchangeTableViewCell");
    }
    retCell = cell;
    
    cell.nameLabel.text = rcd.name;
    cell.desLabel.text = rcd.desString;
    cell.cheapMarkImageView.hidden = [rcd.is_most_cheap boolValue] ? NO : YES;
    if ([rcd.iconUrl length] > 0)
    {
        [cell.iconImageView setUrl:nil];
    }
    else
    {
        static NSDictionary* localIconDict = nil;
        if (localIconDict == nil)
        {
            localIconDict =
            @{
              [NSString stringWithFormat:@"%d",ExtractAndExchangeTypeJingdong]:@"exchange_icon_jd_50",
              [NSString stringWithFormat:@"%d",ExtractAndExchangeTypeXLVip]:@"exchange_icon_jd_50",
              [NSString stringWithFormat:@"%d",ExtractAndExchangeTypeAlipay]:@"exchange_icon_alipay",
              [NSString stringWithFormat:@"%d",ExtractAndExchangeTypePhonePay]:@"exchange_icon_phonepay"
              };
            [localIconDict retain];
        }
        
        [cell.iconImageView setUrl:nil];
        NSString* typeKey = [NSString stringWithFormat:@"%d",rcd.type];
        UIImage* img = [UIImage imageNamed:localIconDict[typeKey]];
        [cell.iconImageView setImage:img];
    }
    
    return retCell;
}

#pragma mark - <UIScrollViewDelegate>
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [super scrollViewDidScroll:scrollView];
}

#pragma mark <ExtractAndExchangeLogicDelegate>

- (void)onFinishedRequestExtractAndExchangeList:(ExtractAndExchangeLogic*)logic
                                      isSucceed:(BOOL)succeed
                                         errMsg:(NSString*)msg
{
    [self.header endRefreshing];
    [self.footer endRefreshing];
    [MBHUDView dismissCurrentHUD];
    
    if (succeed)
    {
        [self.tableView reloadData];
    }
    else
    {
        if ([msg length] <= 0)
        {
            msg = @"请求兑换列表失败";
        }
        [MBHUDView hudWithBody:msg type:MBAlertViewHUDTypeImagePositive  hidesAfter:2.0 show:YES];
    }
}

- (void)onFinishedRequestExchangeCode:(ExtractAndExchangeLogic*)logic
                         exchangeType:(ExtractAndExchangeType)type
                            isSucceed:(BOOL)succeed
                               errMsg:(NSString*)msg
{
    [MBHUDView dismissCurrentHUD];
    
    if (succeed)
    {
        [self.header beginRefreshing];
    }
    else
    {
        if ([msg length] <= 0)
        {
            msg = @"兑换请求失败";
        }
        [MBHUDView hudWithBody:msg type:MBAlertViewHUDTypeImagePositive  hidesAfter:2.0 show:YES];
    }
    
    [_currentExchangeItem release];
    _currentExchangeItem = nil;
}

#pragma mark <UIAlertViewDelegate>

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == kAlertViewTypeContinueExchange)
    {
        if (buttonIndex != alertView.cancelButtonIndex)
        {
            [MBHUDView hudWithBody:@"正在兑换..." type:MBAlertViewHUDTypeActivityIndicator hidesAfter:-1 show:YES];
            [[ExtractAndExchangeLogic sharedInstance] requestExchangeCode:_currentExchangeItem.type price:_currentExchangeItem.price withDelegate:self];
        }
    }
}

@end

