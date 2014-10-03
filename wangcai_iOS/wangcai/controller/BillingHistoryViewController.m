//
//  BillingHistoryViewController.m
//  wangcai
//
//  Created by Lee Justin on 14-10-2.
//  Copyright (c) 2014年 1528studio. All rights reserved.
//

#import "BillingHistoryViewController.h"
#import "LoginAndRegister.h"
#import "MBHUDView.h"

@interface BillingHistoryViewController ()

@property (nonatomic,retain) BillingHisTotalTableViewCell* tipCell;

@end

@implementation BillingHistoryViewController

+ (BillingHistoryViewController*) controller
{
    return [[[BillingHistoryViewController alloc] initWithNibName:@"CommonPullRefreshViewController" bundle:nil] autorelease];
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
    
    self.navigationBarView.backgroundColor = RGB(15, 151, 208);
    self.navigationBarTitleLabel.text = @"收支明细";
    self.tipCell = CREATE_NIBVIEW(@"BillingHisTotalTableViewCell");
    self.tipCell.frame = CGRectMake(0, 50, self.tipCell.frame.size.width, self.tipCell.frame.size.height);
    [self.view addSubview:self.tipCell];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"BillingHisIncomeTableViewCell" bundle:nil] forCellReuseIdentifier:@"BillingHisIncomeTableViewCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"BillingHisOutgoTableViewCell" bundle:nil] forCellReuseIdentifier:@"BillingHisOutgoTableViewCell"];
    
    [self.header beginRefreshing];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    self.tipCell = nil;
    [super dealloc];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    CGFloat offY = CGRectGetMaxY(self.tipCell.frame);
    CGRect rect = self.view.frame;
    rect.origin = CGPointZero;
    rect.origin.y = offY;
    rect.size.height -= offY;
    self.tableView.frame = rect;
    
    self.tipCell.balanceLabel.text = [NSString stringWithFormat:@"￥%@",[NSNumber numberWithFloat:((float)[[LoginAndRegister sharedInstance] getBalance])/100.f]];
    self.tipCell.incomeLabel.text = [NSString stringWithFormat:@"￥%@",[NSNumber numberWithFloat:((float)[[LoginAndRegister sharedInstance] getIncome])/100.f]];
    self.tipCell.outgoLabel.text = [NSString stringWithFormat:@"￥%@",[NSNumber numberWithFloat:((float)[[LoginAndRegister sharedInstance] getOutgo])/100.f]];
    NSString* btnStr = [NSString stringWithFormat:@"好友帮你赚了:%@元 >",[NSNumber numberWithFloat:((float)[[LoginAndRegister sharedInstance] getInviteIncome])/100.f]];
    [self.tipCell.shareIncomeBtn setTitle:btnStr forState:UIControlStateNormal];
}

#pragma mark HTTP

#pragma mark 子类覆盖
- (void) onStartHeaderRefresh
{
    [[BillingHistoryList sharedInstance] requestRefreshBillingHis:self];
}

- (void) onStartFooterRefresh
{
    [[BillingHistoryList sharedInstance] requestGetMoreBillingHis:self];
}

#pragma mark - <UITableViewDelegate>
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    int row = indexPath.row;
    BillingHistoryRecord* rcd = [[BillingHistoryList sharedInstance] allRecords][row];
    if ([rcd.money floatValue] < 0)
    {
        //跳转交易详情页
    }
}

#pragma mark - <UITableViewDataSource>
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[[BillingHistoryList sharedInstance] allRecords] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    int row = indexPath.row;
    UITableViewCell* retCell = nil;
    
    BillingHistoryRecord* rcd = [[BillingHistoryList sharedInstance] allRecords][row];
    
    NSNumber* moneyInYuan = [NSNumber numberWithFloat:((float)abs([rcd.money intValue])) / 100.f];
    if ([rcd.money floatValue] >= 0)
    {
        BillingHisIncomeTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"BillingHisIncomeTableViewCell" forIndexPath:indexPath];
        if (cell == nil)
        {
            cell = CREATE_NIBVIEW(@"BillingHisIncomeTableViewCell");
        }
        retCell = cell;
        
        cell.valueLbl.text = [NSString stringWithFormat:@"+ %@ 元",moneyInYuan];
        cell.titleLbl.text = rcd.remark;
        cell.timeLbl.text = rcd.datetime;
    }
    else
    {
        BillingHisOutgoTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"BillingHisOutgoTableViewCell" forIndexPath:indexPath];
        if (cell == nil)
        {
            cell = CREATE_NIBVIEW(@"BillingHisOutgoTableViewCell");
        }
        retCell = cell;
        
        cell.valueLbl.text = [NSString stringWithFormat:@"- %@ 元",moneyInYuan];
        cell.titleLbl.text = rcd.remark;
        cell.timeLbl.text = rcd.datetime;
    }
    
    return retCell;
}

#pragma mark - <UIScrollViewDelegate>
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [super scrollViewDidScroll:scrollView];
}

#pragma mark <BillingHistoryListDelegate>

- (void)onFinishedRequestBillingHis:(BillingHistoryList*)logic
                          isSucceed:(BOOL)succeed
                             errMsg:(NSString*)msg
                              datas:(NSArray*)newRecords
                              isEnd:(BOOL)isEndPage
{
    [self.header endRefreshing];
    [self.footer endRefreshing];
    
    if (succeed)
    {
        [self.tableView reloadData];
    }
    else
    {
        [MBHUDView hudWithBody:@":(\n拉取失败" type:MBAlertViewHUDTypeImagePositive  hidesAfter:2.0 show:YES];
    }
    
    
    if (isEndPage)
    {
        self.footer.scrollView = nil;
        self.footer.hidden = YES;
    }
    else
    {
        self.footer.scrollView = self.tableView;
        self.footer.hidden = NO;
    }
    
    
}

@end
