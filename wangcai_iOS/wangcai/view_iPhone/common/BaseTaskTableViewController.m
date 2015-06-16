//
//  BaseTaskTableViewController.m
//  wangcai
//
//  Created by Lee Justin on 13-12-14.
//  Copyright (c) 2013年 1528studio. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>
#import <AudioToolbox/AudioToolbox.h>
#import "BaseTaskTableViewController.h"
#import "CommonTaskTableViewCell.h"
#import "UserInfoEditorViewController.h"
#import "CommonTaskList.h"
#import "MBHUDView.h"
#import "TaskController.h"
#import "ChoujiangViewController.h"
#import "ChoujiangLogic.h"
#import "NSString+FloatFormat.h"
#import "PhoneValidationController.h"
#import "SettingLocalRecords.h"
#import "AppBoard_iPhone.h"
#import "MenuBoard_iPhone.h"
#import "SettingViewController.h"
#import "Config.h"
#import "NSString+FloatFormat.h"
#import "MobClick.h"
#import "UIGetRedBagAlertView.h"
#import "UILevelUpAlertView.h"
#import "ECManager.h"
#import "EcomConfig.h"
#import "Common.h"
#import "BillingHistoryViewController.h"
#import "ExtractAndExchangeViewController.h"
#import "AriticleWebViewController.h"
#import "InviteController.h"
#import "UserHelpViewController.h"
#import <Foundation/Foundation.h>
#import <ShareSDK/ShareSDK.h>

static BOOL gNeedReloadTaskList = NO;
static BOOL gNeedShowChoujiangShare = NO;
static int  gChoujiang = 0;

#define kReloginTimeInterval (60.0f)

@interface BaseTaskTableViewController () <CommonTaskListDelegate,UIGetRedBagAlertViewDelegate>
{
    NSTimer* _checkOfferWallTimer;
    NSTimer* _reloginTimer;
    BOOL _justOnePage;
}

@end

@implementation BaseTaskTableViewController

@synthesize bounceHeader = _bounceHeader;
@synthesize zhanghuYuEHeaderCell = _zhanghuYuEHeaderCell;
@synthesize infoCell = _infoCell;
@synthesize containTableView = _containTableView;
@synthesize containTableViewFooterView = _containTableViewFooterView;
@synthesize containTableViewFooterViewTextLabel = _containTableViewFooterViewTextLabel;
@synthesize containTableViewFooterViewButton = _containTableViewFooterViewButton;
@synthesize containTableViewFooterJuhuaView = _containTableViewFooterJuhuaView;
@synthesize tableViewFrame = _tableViewFrame;
@synthesize beeStack = _beeStack;
@synthesize staticCells = _staticCells;

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
    [self observeNotification:@"applicationDidBecomeActive"];
    
    _justOnePage = NO;
    _curCellCount = 0;
    _hisCellCount = 0;
    _levelCell = nil;
    _levelChange = 0;
    _alertLevel = nil;
    _alertChoujiangeShare = nil;
    _alertInstallApp = nil;
    _installUrl = nil;
    
    self.staticCells = [NSMutableArray array];
    _bounceHeader = NO;
    _alertBalanceTip = nil;
    
    _hasLoadedHistoricalFinishedList = YES;
    
    [self addHeader];
    [self resetFooter];
    [self performSelector:@selector(resetTableViewFrame) withObject:nil afterDelay:0.05];
    [self resetStaticCells];
    
    [self.infoCell setJinTianHaiNengZhuanNumLabelTextNum:[[CommonTaskList sharedInstance] allMoneyCanBeEarnedInRMBYuan]];
    
    [self.zhanghuYuEHeaderCell.yuENumView setNum:[[LoginAndRegister sharedInstance] getBalance]];
    [[OnlineWallViewController sharedInstance].yueView setNum:[[LoginAndRegister sharedInstance] getBalance]];
    
    int nPollingInterval = [[LoginAndRegister sharedInstance] getPollingInterval];
    _checkOfferWallTimer = [NSTimer scheduledTimerWithTimeInterval:nPollingInterval target:self selector:@selector(checkDMOfferWall) userInfo:nil repeats:NO];
    
    _reloginTimer = [NSTimer scheduledTimerWithTimeInterval:kReloginTimeInterval target:self selector:@selector(_reloginEvent) userInfo:nil repeats:NO];
    //[self performSelector:@selector(refreshTaskList) withObject:nil afterDelay:2.0f];
}

- (void)_reloginEvent
{
    [[LoginAndRegister sharedInstance] login:self];
    _reloginTimer = [NSTimer scheduledTimerWithTimeInterval:kReloginTimeInterval target:self selector:@selector(_reloginEvent) userInfo:nil repeats:NO];
}

- (void)checkDMOfferWall
{
    [OnlineWallViewController sharedInstance].delegate = self;
    [[OnlineWallViewController sharedInstance] requestAndConsumePoint];
    
    int nPollingInterval = [[LoginAndRegister sharedInstance] getPollingInterval];
    _checkOfferWallTimer = [NSTimer scheduledTimerWithTimeInterval:nPollingInterval target:self selector:@selector(checkDMOfferWall) userInfo:nil repeats:NO];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self onViewDidAppearLogic];
    
    if ( gNeedShowChoujiangShare ) {
        _alertChoujiangeShare = [[[UIAlertView alloc] initWithTitle:@"中奖了" message:@"恭喜您中奖，快来分享给朋友们吧！" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"分享", nil] autorelease];
        [_alertChoujiangeShare show];
        
        gNeedShowChoujiangShare = NO;
    }
}

- (void)onViewDidAppearLogic
{
    [OnlineWallViewController sharedInstance].delegate = self;
    [[OnlineWallViewController sharedInstance] requestAndConsumePoint];
    
    [self checkBalanceAndAnimateYuE];
    
    if (![SettingLocalRecords hasInstallWangcaiAlertViewPoped])
    {
        if ([[[LoginAndRegister sharedInstance] getPhoneNum] length] <= 0 && [[LoginAndRegister sharedInstance] getBalance] == 100)
        {
            //首次启动弹出安装赚钱小猪奖励窗口，未绑定状态
            UIGetRedBagAlertView* getMoneyAlertView = [UIGetRedBagAlertView sharedInstance];
            [getMoneyAlertView setRMBString:[NSString stringWithFloatRoundToPrecision:((float)100)/100.f precision:2 ignoreBackZeros:NO]];
            [getMoneyAlertView setLevel:[[LoginAndRegister sharedInstance] getUserLevel]];
            [getMoneyAlertView setTitle:@"新装赚钱小猪获得红包"];
            //[getMoneyAlertView setDelegate:self];
            [getMoneyAlertView setShowCurrentBanlance:[[LoginAndRegister sharedInstance] getBalance] andIncrease:100];
            [getMoneyAlertView show];
        }
        
        [SettingLocalRecords setPopedInstallWangcaiAlertView:YES];
    }
    
    if (gNeedReloadTaskList)
    {
        [self refreshTaskList];
    }
}

- (void)checkBalanceAndAnimateYuE
{
    if ([[LoginAndRegister sharedInstance] getBalance] > [self.zhanghuYuEHeaderCell.yuENumView getNum])
    {
        NSIndexPath* pathTop = [NSIndexPath indexPathForRow:0 inSection:0];
        [self.containTableView scrollToRowAtIndexPath:pathTop atScrollPosition:UITableViewScrollPositionTop animated:YES];
        [self setYuENumberWithAnimationFrom:[self.zhanghuYuEHeaderCell.yuENumView getNum] toNum:[[LoginAndRegister sharedInstance] getBalance]];
    }
    else
    {
        [self.zhanghuYuEHeaderCell.yuENumView setNum:[[LoginAndRegister sharedInstance] getBalance]];
        [[OnlineWallViewController sharedInstance].yueView setNum:[[LoginAndRegister sharedInstance] getBalance]];
    }
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self refreshChoujiangButton];
    
    NSString* phoneNum = [[LoginAndRegister sharedInstance] getPhoneNum];
    if ([phoneNum length] > 0)
    {
        self.zhanghuYuEHeaderCell.bindphoneButton.enabled = NO;
        self.zhanghuYuEHeaderCell.bindphoneBubble.hidden = YES;
        self.zhanghuYuEHeaderCell.bindphoneLabel.hidden = NO;
        self.zhanghuYuEHeaderCell.bindphoneBottomLineView.hidden = YES;
        self.zhanghuYuEHeaderCell.bindphoneLabel.text = @"√ 已绑定手机";
        self.zhanghuYuEHeaderCell.bindphoneLabel.textColor = [UIColor colorWithRed:0.269 green:0.672 blue:0.882 alpha:1.000];
    }
    else
    {
        self.zhanghuYuEHeaderCell.bindphoneButton.enabled = YES;
        self.zhanghuYuEHeaderCell.bindphoneBubble.hidden = NO;
        self.zhanghuYuEHeaderCell.bindphoneLabel.hidden = NO;
        self.zhanghuYuEHeaderCell.bindphoneBottomLineView.hidden = NO;
        self.zhanghuYuEHeaderCell.bindphoneLabel.text = @"未绑定手机";
        self.zhanghuYuEHeaderCell.bindphoneLabel.textColor = [UIColor whiteColor];
    }
    
    [self.containTableView reloadData];
}

- (void)refreshChoujiangButton
{
    if ([[ChoujiangLogic sharedInstance] getAwardCode] == kGetAwardTypeNotGet)
    {
        [self enableQiandaoButton:YES];
    }
    else
    {
        [self enableQiandaoButton:NO];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    self.zhanghuYuEHeaderCell = nil;
    self.infoCell = nil;
    self.containTableView = nil;
    self.containTableViewFooterView = nil;
    self.containTableViewFooterViewTextLabel = nil;
    self.containTableViewFooterJuhuaView = nil;
    self.containTableViewFooterViewButton = nil;
    self.staticCells = nil;
    self.headerBgLongView = nil;
    [_checkOfferWallTimer invalidate];
    
    if ( _alertBalanceTip != nil ) {
        [_alertBalanceTip release];
        _alertBalanceTip = nil;
    }
    
    [_reloginTimer invalidate];
    
    [super dealloc];
}

- (void)addHeader
{
    UIView* longView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 0)] autorelease];
    longView.backgroundColor = [UIColor colorWithRed:0.084 green:0.406 blue:0.796 alpha:1.000];
    MJRefreshHeaderView *header = [MJRefreshHeaderView header];
    header.backgroundColor = RGB(25, 138, 191);
    self.headerBgLongView = longView;
    //[header insertSubview:longView atIndex:0];
    [self.view insertSubview:longView belowSubview:self.containTableView];
    //self.containTableView.backgroundColor = RGB(25, 138, 191);
    //header.scrollView = self.containTableView;
    header.beginRefreshingBlock = ^(MJRefreshBaseView *refreshView) {
        // 进入刷新状态就会回调这个Block

        // 模拟延迟加载数据，因此2秒后才调用）
        // 这里的refreshView其实就是header
        //[self performSelector:@selector(doneWithView:) withObject:refreshView afterDelay:2.0];
        [MobClick event:@"task_list_refresh_list" attributes:@{@"currentpage":@"任务列表"}];
        [self refreshTaskList];
        
        NSLog(@"%@----开始进入刷新状态", refreshView.class);
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
    //[header beginRefreshing];
    _header = header;
}

- (void)doneWithView:(MJRefreshBaseView *)refreshView
{
    // 刷新表格
    [self.containTableView reloadData];
    // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
    [refreshView endRefreshing];
}


-(void)setTableViewFrame:(CGRect)tableViewFrame
{
    //if (self.containTableView)
    //{
        //self.containTableView.frame = tableViewFrame;
    //}
    _tableViewFrame = tableViewFrame;
}

-(void)resetTableViewFrame
{
    if (!CGRectIsEmpty(_tableViewFrame))
    {
        self.containTableView.frame = _tableViewFrame;
        self.containTableView.clipsToBounds = NO;
    }
}

-(void)refreshTaskList
{
    [MBHUDView hudWithBody:@"" type:MBAlertViewHUDTypeActivityIndicator hidesAfter:10000000000.f show:YES];
    // 重登陆刷
    [[LoginAndRegister sharedInstance] login:self];
}

-(void)resetStaticCells
{
    [_staticCells removeAllObjects];
    
    [_staticCells addObject:self.zhanghuYuEHeaderCell];
    //[_staticCells addObject:self.infoCell];
}

- (void)onLoadHistoricalFinishedList
{
    //这里加载领取过的红包
    [MobClick event:@"task_list_get_unfinished" attributes:@{@"currentpage":@"任务列表"}];
    [self endFooter];
    _hasLoadedHistoricalFinishedList = YES;
    [self.containTableView reloadData];
}

- (IBAction)onPressedLoadHisButton:(id)sender
{
    [self onLoadHistoricalFinishedList];
}

- (void)onPressedArticle
{
    AriticleWebViewController* ctrl = [AriticleWebViewController controller];
    [self.parentUIBoard.stack pushViewController:ctrl animated:YES];
}

- (IBAction)onPressedQiandaoChoujiangButton:(id)sender
{
    //统计
    [MobClick event:@"task_list_daily_checkin" attributes:@{@"currentpage":@"任务列表"}];
    
    if ([ChoujiangLogic sharedInstance].getAwardCode == kGetAwardTypeNotGet) {
        ChoujiangViewController* choujiangCtrl = [[ChoujiangViewController alloc] init];
        [self.beeStack pushViewController:choujiangCtrl animated:YES];
    }
    else
    {
        UIAlertView* alert = [[[UIAlertView alloc] initWithTitle:@"提示" message:@"今天已经签到过了，明天记得来哟" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil] autorelease];
        [alert show];
    }
}

- (IBAction)onPressedTiquxianjinButton:(id)sender
{
    [MobClick event:@"click_extract_money" attributes:@{@"current_page":@"任务列表"}];
    [[BeeUIRouter sharedInstance] open:@"second" animated:YES];
}

- (void)enableQiandaoButton:(BOOL)enabled
{
    //self.zhanghuYuEHeaderCell.qiandaoButton.enabled = enabled;
    BOOL hidden = enabled ? NO : YES;
    self.zhanghuYuEHeaderCell.qiandaoRedDotBubble.hidden = hidden;
    //self.zhanghuYuEHeaderCell.qiandaoIcon.hidden = hidden;
    //self.zhanghuYuEHeaderCell.qiandaoLabel.hidden = hidden;
}

- (void)enableTixianButton:(BOOL)enabled
{
    //self.zhanghuYuEHeaderCell.tixianButton.enabled = enabled;
    BOOL hidden = enabled ? NO : YES;
    //self.zhanghuYuEHeaderCell.tixianIcon.hidden = hidden;
    //self.zhanghuYuEHeaderCell.tixianLabel.hidden = hidden;
}

//带动画和声音设置余额
- (void)setYuENumberWithAnimationFrom:(int)oldNum toNum:(int)newNum
{
    [self.zhanghuYuEHeaderCell.yuENumView animateNumFrom:oldNum to:newNum withAnimation:YES];
}

+ (void)setNeedReloadTaskList
{
    gNeedReloadTaskList = YES;
}

+ (void)setNeedShowChoujiangShare :(int)choujiang {
    gNeedShowChoujiangShare = YES;
    gChoujiang = choujiang;
}

#pragma mark - <UITableViewDataSource>

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (!_hasLoadedHistoricalFinishedList)
    {
        return [self.staticCells  count] + _curCellCount + [[[CommonTaskList sharedInstance] getUnfinishedTaskList] count];
    }
    return [self.staticCells  count] + _hisCellCount + _curCellCount + [[[CommonTaskList sharedInstance] getAllTaskList] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* cell = nil;
    
    NSInteger row = indexPath.row;
    NSInteger rowExceptStaticCells = row - [_staticCells count];
    
    if (row < [_staticCells count])
    {
        cell = [_staticCells objectAtIndex:row];
    }
    else
    {
        CommonTaskTableViewCell* comCell = [tableView dequeueReusableCellWithIdentifier:@"taskCell"];
        if (comCell == nil)
        {
            comCell = [[[CommonTaskTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"taskCell"] autorelease];
        } 
        
        /*
        if (rowExceptStaticCells == 0)
        {
            [comCell setTaskCellType:CommonTaskTableViewCellShowTypeRedTextUp];
            [comCell setUpText:@"补充个人信息"];
            [comCell setDownText:@"让赚钱小猪知道你喜欢什么，赚更多的红包"];
            [comCell setRedBagIcon:@"package_icon_one"];
            [comCell setLeftIconNamed:@"person_info_icon"];
            [comCell hideFinishedIcon:YES];
        }
        else if (rowExceptStaticCells == 1)
        {
            [comCell setTaskCellType:CommonTaskTableViewCellShowTypeRedTextUp];
            [comCell setUpText:@"关注赚钱小猪"];
            [comCell setDownText:@"用微信随时随地领红包"];
            [comCell setRedBagIcon:@"package_icon_8"];
            [comCell setLeftIconNamed:@"about_wangcai_cell_icon"];
            [comCell hideFinishedIcon:YES];
        }
         */
        if (0)
        {
            
        }
        else
        {
            CommonTaskInfo* task = [[[CommonTaskList sharedInstance] getAllTaskList] objectAtIndex:rowExceptStaticCells];
            [comCell setTaskCellType:CommonTaskTableViewCellShowTypeRedTextUp];
            [comCell setUpText:task.taskTitle];
            [comCell setDownText:task.taskDesc];
            float moneyInYuan = [task.taskMoney floatValue]/100.f;
            NSString* pic = nil;
            if (moneyInYuan >= 0.001f && moneyInYuan < 0.5)
            {
                pic = @"package_icon_1mao";
            }
            if (moneyInYuan >= 0.5f && moneyInYuan < 1.0f)
            {
                pic = @"package_icon_half";
            }
            if (moneyInYuan >= 1.0f && moneyInYuan < 1.5f)
            {
                pic = @"package_icon_one";
            }
            if (moneyInYuan >= 1.5f && moneyInYuan < 2.0f)
            {
                pic = @"package_icon_1_5";
            }
            if (moneyInYuan >= 2.0f && moneyInYuan < 2.5f)
            {
                pic = @"package_icon_2";
            }
            if (moneyInYuan >= 2.5f && moneyInYuan < 3.0f)
            {
                pic = @"package_icon_2_5";
            }
            if (moneyInYuan >= 3.0f && moneyInYuan < 8.0f)
            {
                pic = @"package_icon_3";
            }
            if (moneyInYuan >= 8.0f && moneyInYuan < 9.0f)
            {
                pic = @"package_icon_8";
            }
            if (moneyInYuan >= 9.0f)
            {
                pic = @"package_icon_many";
            }
            
            [comCell setRedBagIcon:pic];
            [comCell setLeftIconNamed:@"table_view_cell_icon_bg"];
            if (task.taskIsLocalIcon)
            {
                [comCell setLeftIconNamed:task.taskIconUrl];
            }
            else
            {
                [comCell setLeftIconUrl:task.taskIconUrl];
            }
            
            if ([task.taskStatus intValue] == CommonTaskTableViewCellStateFinished)
            {
                [comCell setCellState:CommonTaskTableViewCellStateFinished];
            }
            else
            {
                [comCell setCellState:CommonTaskTableViewCellStateUnfinish];
            }
            
            if ( [task.taskType intValue] == kTaskTypeEverydaySign )
            {
                // 是否已抽过
                if([[ChoujiangLogic sharedInstance] getAwardCode] != kGetAwardTypeNotGet)
                {
                    [comCell setCellState:CommonTaskTableViewCellStateFinished];
                }
            }
            
            if ( [task.taskType intValue] == KTaskTypeUpgrade ) {
                // 等级
                _levelCell = comCell;
                [self updateLevel];
            }
        }
        
        cell = comCell;
    }
    
    
    return cell;
}

#pragma mark - <UITableViewDelegate>
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = indexPath.row;
    /*
    if (row == 0)
    {
        return 134.0f;
    }
    else if (row == 1)
    {
        return 64.0f;
    }
     */
    if (row < [_staticCells count])
    {
        UITableViewCell* cell = [_staticCells objectAtIndex:row];
        //CGFloat height = cell.frame.size.height;
        return cell.frame.size.height;
    }
    return 80.f;
}

- (void)onTouchedInvite:(BOOL)switchToFillInvitedCodeView
{
    // 判断是否绑定了手机
    NSString* phoneNum = [[LoginAndRegister sharedInstance] getPhoneNum];
    if ( phoneNum == nil || [phoneNum isEqualToString:@""] ) {
        _needBindPhone = YES;
        UIAlertView* alertView = [[[UIAlertView alloc] initWithTitle:@"提示" message:@"先绑定手机，才能继续操作哟！" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"绑定手机", nil] autorelease];
        
        _alertBalanceTip = alertView;
        
        [alertView show];
    } else {
        [phoneNum release];
        
        InviteController* ctrl = [InviteController controller];
        [self.beeStack pushViewController:ctrl animated:YES];
    }
}

- (void)onTouchedExtract
{
    // 判断是否绑定了手机
    NSString* phoneNum = [[LoginAndRegister sharedInstance] getPhoneNum];
    if ( phoneNum == nil || [phoneNum isEqualToString:@""] ) {
        _needBindPhone = YES;
        UIAlertView* alertView = [[[UIAlertView alloc] initWithTitle:@"提示" message:@"先绑定手机，才能继续操作哟！" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"绑定手机", nil] autorelease];
        
        _alertBalanceTip = alertView;
        
        [alertView show];
    } else {
        [phoneNum release];
        
        ExtractAndExchangeViewController* ctrl = [ExtractAndExchangeViewController controller];
        ctrl.beeUIStack = self.parentUIBoard.stack;
        [self.parentUIBoard.stack pushViewController:ctrl animated:YES];
    }
}

- (void) onClickInstallApp: (CommonTaskInfo* ) task {
    if ( _alertInstallApp != nil ) {
        [_alertInstallApp release];
    }
    
    
    if ( _installUrl != nil ) {
        [_installUrl release];
        _installUrl = nil;
    }
    
    UIView* view = [[[[NSBundle mainBundle] loadNibNamed:@"AppInstallTipView" owner:self options:nil] lastObject] autorelease];
    view.layer.masksToBounds = YES;
    view.layer.cornerRadius = 10.0;
    view.layer.borderWidth = 0.0;
    view.layer.borderColor = [[UIColor whiteColor] CGColor];
        
    UIColor *color = [UIColor colorWithRed:179.0/255 green:179.0/255 blue:179.0/255 alpha:1];
        
    UIButton* btn = (UIButton*)[view viewWithTag:11];
    [btn.layer setBorderWidth:0.5];
    [btn.layer setBorderColor:[color CGColor]];
    [btn setTitleColor:color forState:UIControlStateHighlighted];
        
    btn = (UIButton*)[view viewWithTag:12];
    [btn.layer setBorderWidth:0.5];
    [btn.layer setBorderColor:[color CGColor]];
    [btn setTitleColor:color forState:UIControlStateHighlighted];
    
    NSString* text = [NSString stringWithFormat:@"安装%@赚取%.1f元红包", task.taskTitle, [task.taskMoney intValue]*1.0/100];
    
    NSString* text2 = [NSString stringWithFormat:@"提示：%@", task.taskIntro];
    ((UILabel*)[view viewWithTag:21]).text = text;
    ((UILabel*)[view viewWithTag:22]).text = text2;
    
    NSRange range = [task.taskRediectUrl rangeOfString:@"?"];
    NSString* urlHeader = nil;
    if ( range.length == 0 ) {
        // 没有?
        urlHeader = [NSString stringWithFormat:@"%@?", task.taskRediectUrl];
    } else {
        // 有?
        urlHeader = [NSString stringWithFormat:@"%@&", task.taskRediectUrl];
    }
    
    NSString* deviceId = [[LoginAndRegister sharedInstance] getDeviceId];
    NSString* mac = [Common getMACAddress];
    NSString* idfa = [Common getIDFAAddress];
    NSString* idfv = [Common getIDFV];
    
    NSString* md5param = [NSString stringWithFormat:@"appid=%@&deviceid=%@&idfa=%@&idfv=%@&mac=%@&cf1618a14ef2f600f89092fb3ccd7cf3", task.taskAppId, deviceId, idfa, idfv, mac];
    
    const char* cStr = [md5param UTF8String];
    unsigned char result[16];
    CC_MD5(cStr, strlen(cStr), result);
    NSMutableString* hash = [NSMutableString string];
    for (int i = 0; i < 16; i ++ ) {
        [hash appendFormat:@"%02x", result[i]];
    }
    
    NSString* param = [NSString stringWithFormat:@"appid=%@&deviceid=%@&idfa=%@&idfv=%@&mac=%@&sign=%@", task.taskAppId, deviceId, idfa, idfv, mac, [hash lowercaseString]];
    
    [deviceId release];
    
    _installUrl = [[NSString alloc] initWithFormat:@"%@%@", urlHeader, param];

    
    _alertInstallApp = [[UICustomAlertView alloc]init:view];
        
    [_alertInstallApp show];
}

- (IBAction)onClickCancelInstall:(id)sender {
    if ( _alertInstallApp != nil ) {
        [_alertInstallApp hideAlertView];
    }
}

- (IBAction)onClickInstall:(id)sender {
    if ( _alertInstallApp != nil ) {
        [_alertInstallApp hideAlertView];
    }
    
    // 安装app
    NSURL* url = [NSURL URLWithString:_installUrl];
    [[UIApplication sharedApplication] openURL:url];
}

- (void)onPressedOffWall
{
    [[OnlineWallViewController sharedInstance] setNeedRefreshUI];
    [self.parentUIBoard.stack pushViewController:[OnlineWallViewController sharedInstance] animated:YES];
}

- (IBAction)onPressedBindPhone:(id)sender
{
    NSString* phoneNum = [[LoginAndRegister sharedInstance] getPhoneNum];
    if ( phoneNum == nil || [phoneNum isEqualToString:@""] )
    {
        [[BeeUIRouter sharedInstance] open:@"phone_validation" animated:YES];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    NSInteger row = indexPath.row;
    if (row < [_staticCells count])
    {
        //测试数字动画
#if 0
        [self setYuENumberWithAnimationFrom:0.1 toNum:50000];
        
        int consume = 2254;
        UIGetRedBagAlertView* testAlertView = [UIGetRedBagAlertView sharedInstance];
        [testAlertView setRMBString:[[NSString stringWithFloatRoundToPrecision:((float)consume)/100.f precision:2 ignoreBackZeros:NO] retain]];
        [testAlertView setLevel:3];
        [testAlertView setShowCurrentBanlance:[[LoginAndRegister sharedInstance] getBalance] andIncrease:281];
        [testAlertView show];
        
        //static int level = 1;
        //UILevelUpAlertView* talert = [UILevelUpAlertView sharedInstance];
        //[talert setLevel:level++];
        //[talert show];
#endif
    }
    else
    {
        int taskIndex = row - [_staticCells count];
        CommonTaskInfo* task = [[[CommonTaskList sharedInstance] taskList] objectAtIndex:taskIndex];
        
        int nLevel = [[LoginAndRegister sharedInstance] getUserLevel];
        int nNeedLevel = [task.taskLevel intValue];
        
        if ( nLevel < nNeedLevel ) {
            // 等级不够
            if ( _alertLevel != nil ) {
                [_alertLevel release];
            }
            
            _alertLevel = [[UIAlertView alloc] initWithTitle:@"提示" message:[NSString stringWithFormat:@"该任务需要等级达到%d级才能进行", nNeedLevel] delegate:self cancelButtonTitle:@"关闭" otherButtonTitles:@"我的等级", nil];
            [_alertLevel show];
            
            return ;
        }
         
        switch ([task.taskType intValue])
        {
            case kTaskTypeUserInfo:
            {
                [MobClick event:@"task_list_click_user_info" attributes:@{@"currentpage":@"任务列表"}];
                if ([task.taskStatus intValue] == 0)
                {
                    UserInfoEditorViewController* userInfoCtrl = [[UserInfoEditorViewController alloc] initWithNibName:@"UserInfoEditorViewController" bundle:nil];
                    if (self.beeStack == nil)
                    {
                        NSLog(@"靠！！！stack空的");
                    }
                    [self.beeStack pushViewController:userInfoCtrl animated:YES];
                }
            }
                break;
            case kTaskTypeOfferWall:
            {
#if 1
                [MobClick event:@"task_list_offer_wall" attributes:@{@"currentpage":@"任务列表"}];
                [self onPressedOffWall];
#endif
            }
                break;
            case kTaskTypeIntallApp:
            {
                //统计
                [MobClick event:@"task_list_click_install_app" attributes:@{@"currentpage":@"任务列表"}];
                
                if ([task.taskStatus intValue] == 0)
                {
                    [self onClickInstallApp:task];
                }
            }
                break;
            case kTaskTypeInstallWangcai:
            case kTaskTypeCommon:
            {
                //统计
                if ([task.taskType intValue] == kTaskTypeInstallWangcai)
                {
                    [MobClick event:@"task_list_click_install_wangcai" attributes:@{@"currentpage":@"任务列表"}];
                }
                else
                {
                    [MobClick event:@"task_list_click_install_app" attributes:@{@"currentpage":@"任务列表"}];
                }
                
                if ([task.taskStatus intValue] == 0)
                {
                    NSString* tabs[3] = {0};
                    for (int i = 0; i < 3; ++i)
                    {
                        if ([task.taskStepStrings count] > i)
                        {
                            tabs[i] = [task.taskStepStrings objectAtIndex:i];
                        }
                    }
                    TaskController* taskCtrl = [[[TaskController alloc] init:task.taskId Tab1:tabs[0] Tab2:tabs[1] Tab3:tabs[2] Purse:[task.taskMoney floatValue]] autorelease];
                    [self.beeStack pushViewController:taskCtrl animated:YES];
                }
            }
                break;
                
            case kTaskTypeEverydaySign:
            {
                [self onPressedQiandaoChoujiangButton:nil];
            }
                break;
            case kTaskTypeInviteFriends:
            {
                [MobClick event:@"task_list_click_inviter" attributes:@{@"currentpage":@"任务列表"}];
                if ([task.taskStatus intValue] == 0)
                {
                    [self onTouchedInvite:YES];
                }
            }
                break;
            
            case kTaskTypeCommetWangcai:
            {
                [MobClick event:@"task_list_rate_wangcai" attributes:@{@"currentpage":@"任务列表"}];
                if ([task.taskStatus intValue] == 0)
                {
                    [SettingViewController jumpToAppStoreAndRate];
                    [[RateAppLogic sharedInstance] requestRated:self];
                }
            }
                break;
            case kTaskTypeShare:
            {
                [MobClick event:@"task_list_share_wangcai" attributes:@{@"currentpage":@"任务列表"}];
                if ([task.taskStatus intValue] == 0)
                {   // 分享
                    [self onClickShare];
                }
            }
                break;
            case KTaskTypeUpgrade:
            {
                [MobClick event:@"task_list_level" attributes:@{@"currentpage":@"任务列表"}];
                [[BeeUIRouter sharedInstance] open:@"my_wangcai" animated:YES];
            }
                break;
            case kTaskTypeExchange:
            {
                [self onTouchedExtract];
            }
                break;
            case kTaskTypeBillingHistory:
            {
                BillingHistoryViewController *ctrl = [BillingHistoryViewController controller];
                [self.parentUIBoard.stack pushViewController:ctrl animated:YES];
            }
                break;
            case kTaskTypeAbout:
            {
                UserHelpViewController* ctrl = [UserHelpViewController controller];
                [self.parentUIBoard.stack pushViewController:ctrl animated:YES];
            }
                break;
            case kTaskTypeYoumiEc:
            {
                ECManager *mgr = [[ECManager alloc]init];
                BeeUIRouter * router = [BeeUIRouter sharedInstance];
                [router presentViewController:mgr.wallNavController animated:YES completion:nil];
                break;
            }
            case kTaskTypeAriticle:
            {
                [self onPressedArticle];
            }
                break;
            default:
                break;
        }
        
        
        
    }
}

#pragma mark - <UIScrollViewDelegate>

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGRect rectHeaderLongView = CGRectMake(0, 0, scrollView.frame.size.width, -scrollView.contentOffset.y);
    self.headerBgLongView.frame = rectHeaderLongView;
    
#if 0
    if (scrollView.contentOffset.y < 100)
    {
        if (_bounceHeader)
        {
            self.containTableView.bounces = YES;
        }
        else
        {
            self.containTableView.bounces = NO;
        }
    }
    else
    {
        self.containTableView.bounces = YES;
    }
#endif
    
    if (!_justOnePage && !_isUIZhuanJuhuaing && (scrollView.contentOffset.y+scrollView.frame.size.height) > scrollView.contentSize.height)
    {
        self.containTableViewFooterJuhuaView.hidden = NO;
        [self.containTableViewFooterJuhuaView startAnimating];
        _isUIZhuanJuhuaing = YES;
        [self performSelector:@selector(onLoadHistoricalFinishedList) withObject:nil afterDelay:0.5];
        //[self onLoadHistoricalFinishedList];
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(taskTableViewController:scrollViewDidScroll:)])
    {
        [self.delegate taskTableViewController:self scrollViewDidScroll:scrollView];
    }
}

#pragma mark - other

- (void)resetFooter
{
    self.containTableViewFooterJuhuaView.hidden = YES;
    //self.containTableView.tableFooterView = self.containTableViewFooterView;
    
    if (self.containTableView.contentSize.height < self.containTableView.frame.size.height)
    {
        _justOnePage = YES;
        self.containTableViewFooterViewTextLabel.text = @"点击查看已领取的红包";
    }
    else
    {
        _justOnePage = NO;
        self.containTableViewFooterViewTextLabel.text = @"继续向上拖动查看已领取的红包";
    }
    _isUIZhuanJuhuaing = NO;
    
    if ([[[CommonTaskList sharedInstance] getAllTaskList] count] <= 5)
    {
        [self onLoadHistoricalFinishedList];
    }
}

- (void)endFooter
{
    self.containTableViewFooterJuhuaView.hidden = YES;
    self.containTableViewFooterView.hidden = YES;
    //self.containTableView.tableFooterView = nil;
}

#pragma mark <CommonTaskListDelegate>

- (void)onFinishedFetchTaskList:(CommonTaskList*)taskList resultCode:(NSInteger)result
{
    [MBHUDView dismissCurrentHUD];
    gNeedReloadTaskList = NO;
    if (result >= 0)
    {
        [self.containTableView reloadData];
        [self.infoCell setJinTianHaiNengZhuanNumLabelTextNum:[taskList allMoneyCanBeEarnedInRMBYuan]];
        [self.zhanghuYuEHeaderCell.yuENumView setNum:[[LoginAndRegister sharedInstance] getBalance]];
        [[OnlineWallViewController sharedInstance].yueView setNum:[[LoginAndRegister sharedInstance] getBalance]];
        //[self doneWithView:_header];
        [self resetFooter];
        [self refreshChoujiangButton];
        [self.containTableView reloadData];
    }
    else
    {
        [MobClick event:@"task_list_refresh_failed" attributes:@{@"currentpage":@"任务列表"}];
        [MBHUDView hudWithBody:@":(\n拉取失败" type:MBAlertViewHUDTypeImagePositive  hidesAfter:2.0 show:YES];
    }
}

#pragma mark <OnlineWallViewControllerDelegate>

- (void) onRequestAndConsumePointCompleted : (BOOL) suc Consume:(NSInteger) consume Level:(int)levelChange wangcaiIncome:(int) income
{
    if ([[LoginAndRegister sharedInstance] checkAndConsumeLevel])
    {
        //TODO:弹窗
    }
    
    if ( consume == -1 ) {
        consume = 0;
    }
    
    if (suc && (consume+income) > 0)
    {
        [[CommonTaskList sharedInstance] increaseEarned:consume];
        [self.infoCell setJinTianHaiNengZhuanNumLabelTextNum:[[CommonTaskList sharedInstance] allMoneyCanBeEarnedInRMBYuan]];
        
        //统计
        [MobClick event:@"money_get_from_all" attributes:@{@"RMB":[NSString stringWithFormat:@"%d",consume],@"FROM":@"积分墙"}];
        
        if ( levelChange > 0 ) {
            _levelChange = levelChange;
        }
        
        UIGetRedBagAlertView* getMoneyAlertView = [UIGetRedBagAlertView sharedInstance];
        [getMoneyAlertView setRMBString:[NSString stringWithFloatRoundToPrecision:((float)(consume + income))/100.f precision:2 ignoreBackZeros:NO]];
        [getMoneyAlertView setLevel:3];
        [getMoneyAlertView setTitle:@"获得应用体验红包"];
        [getMoneyAlertView setDelegate:self];
        [getMoneyAlertView setShowCurrentBanlance:[[LoginAndRegister sharedInstance] getBalance] andIncrease:(consume + income)];
        [getMoneyAlertView show];
        
        [[LoginAndRegister sharedInstance] increaseBalance:(consume + income)];
        [self checkBalanceAndAnimateYuE];
        
        [self refreshTaskList];
    }
}

#pragma mark <LoginAndRegisterDelegate>

-(void) loginCompleted : (LoginStatus) status HttpCode:(int)httpCode ErrCode:(int)errCode Msg:(NSString*)msg
{
    if ( status == Login_Success ) {
        int forceUpdate = [[LoginAndRegister sharedInstance] getForceUpdate];
        if ( forceUpdate == 1 ) {
            // 强制升级
            _needUpdateApp = YES;
            UIAlertView* alertForceUpdate = [[[UIAlertView alloc]initWithTitle:@"提示" message:@"发现新版赚钱小猪！更安全更好赚，请立即升级。" delegate:self cancelButtonTitle:@"更新" otherButtonTitles:nil, nil] autorelease];
            [alertForceUpdate show];
            
            if ([[LoginAndRegister sharedInstance] checkAndConsumeLevel])
            {
                //TODO:弹窗
            }
            
        } else {
            //任务列表改到登陆协议中去了，已不用单独再拉列表了
            //[[CommonTaskList sharedInstance] fetchTaskList:self];
            
            //统计
            [MobClick event:@"money_account_total"
                 attributes:@{
                              @"balance":[NSString stringWithFormat:@"%d",[[LoginAndRegister sharedInstance] getBalance]],
                              @"income":[NSString stringWithFormat:@"%d",[[LoginAndRegister sharedInstance] getIncome]],
                              @"outgo":[NSString stringWithFormat:@"%d",[[LoginAndRegister sharedInstance] getOutgo]]
                              }];
            [self onFinishedFetchTaskList:[CommonTaskList sharedInstance] resultCode:0];
        }
    } else {
        // 登陆错误，必须登陆成功才能进入下一步
        _needRetry = YES;
        
        if ( httpCode == 200 && (errCode == 511 || errCode == 403) ) {
            NSString* errMsg = [[msg copy] autorelease];
            NSRange range = [errMsg rangeOfString:@"$"];
            NSString* title = [errMsg substringToIndex:range.location];
            NSString* body = [errMsg substringFromIndex:range.location + range.length];
            
            UIAlertView* alertError = [[[UIAlertView alloc] initWithTitle:title message:body delegate:self cancelButtonTitle:@"重试" otherButtonTitles:nil, nil] autorelease];
            [alertError show];
        } else {
            UIAlertView* alertError = [[[UIAlertView alloc] initWithTitle:@"提示" message:@"当前网络不可用，请检查网络连接" delegate:self cancelButtonTitle:@"重试" otherButtonTitles:nil, nil] autorelease];
            [alertError show];
        }
    }
}

#pragma mark <UIAlertViewDelegate>

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if ( _needBindPhone) {
        if (buttonIndex == 1)
        {
            if ( [alertView isEqual:_alertBalanceTip] ) {
                // 绑定手机
                [MobClick event:@"click_bind_phone" attributes:@{@"currentpage":@"任务列表"}];
                
                [self onPressedBindPhone:nil];
            }
        }
    }
    else if ( _needRetry ) {
        // 重试
        [[LoginAndRegister sharedInstance] login:self];
    } else if ( _needUpdateApp ) {
        // 升级
        NSString* sysVer = [[UIDevice currentDevice] systemVersion];
        NSString* urlStr = [[[NSString alloc] initWithFormat:@"%@?sysVer=%@", WEB_FORCE_UPDATE, sysVer] autorelease];
        
        NSURL* url = [NSURL URLWithString:urlStr];
        [[UIApplication sharedApplication] openURL:url];
        
        exit(0);
    }
    if (_needAddCommentIncome)
    {
        [BaseTaskTableViewController setNeedReloadTaskList];
        [self onViewDidAppearLogic];
    }
    
    _needBindPhone = NO;
    _needRetry = NO;
    _needUpdateApp = NO;
    _needAddCommentIncome = NO;
    
    if ( _alertLevel != nil && [_alertLevel isEqual:alertView] ) {
        if ( buttonIndex == 1 ) {
            // 显示我的赚钱小猪
            [[BeeUIRouter sharedInstance] open:@"my_wangcai" animated:YES];
        }
    } else if ( _alertChoujiangeShare != nil && [_alertChoujiangeShare isEqual:alertView] ) {
        if ( buttonIndex == 1 ) {
            // 分享
            NSString* imagePath = [[NSBundle mainBundle] pathForResource:@"Icon@2x" ofType:@"png"];
            
            NSString* invite = [[LoginAndRegister sharedInstance] getInviteCode];
            NSString* content = [NSString stringWithFormat:@"今日大吉，签到都中了%d元红包。来赚钱小猪签到赚话费吧。赚钱小猪下载地址:%@", (gChoujiang / 100), [NSString stringWithFormat: INVITE_TASK, invite] ];
            
            id<ISSContent> publishContent = [ShareSDK content:content defaultContent:@"" image:[ShareSDK imageWithPath:imagePath] title: @"中奖了！" url: [NSString stringWithFormat: INVITE_TASK, invite] description: @"赚钱小猪分享" mediaType: SSPublishContentMediaTypeNews];
            
            [ShareSDK showShareActionSheet: nil shareList: nil content: publishContent statusBarTips: YES authOptions: nil shareOptions: nil result: ^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end)
             {
                 if (state == SSResponseStateSuccess)
                 {  // todo 分享成功
                     //[self onPressedBackButton:self.backButton];
                 }
                 else if (state == SSResponseStateFail)
                 {  // todo 分享失败
                     //[self onPressedBackButton:self.backButton];
                 }
                 else if (state == SSResponseStateCancel )
                 {  //
                     //[self onPressedBackButton:self.backButton];
                 }
             }];
        }
        _alertChoujiangeShare = nil;
    }
}

#pragma mark <RateAppLogicDelegate>

- (void)onRateAppLogicFinished:(RateAppLogic*)logic isRequestSucceed:(BOOL)isSucceed income:(NSInteger)income resultCode:(NSInteger)result msg:(NSString*)msg
{
    if (isSucceed && income > 0)
    {
        //统计
        [MobClick event:@"money_get_from_all" attributes:@{@"RMB":@"10",@"FROM":@"用户评价"}];
        
        _needAddCommentIncome = YES;
        NSString* strIncome = [NSString stringWithFloatRoundToPrecision:((float)income)/100.f precision:2 ignoreBackZeros:NO];
        
        UIGetRedBagAlertView* getMoneyAlertView = [UIGetRedBagAlertView sharedInstance];
        [getMoneyAlertView setRMBString:strIncome];
        [getMoneyAlertView setLevel:3];
        [getMoneyAlertView setTitle:@"获得好评红包"];
        [getMoneyAlertView setShowCurrentBanlance:[[LoginAndRegister sharedInstance] getBalance] andIncrease:income];
        [getMoneyAlertView show];
        
        [[LoginAndRegister sharedInstance] increaseBalance:income];
    }
    else
    {
        NSString* msgStr = @"服务器失败";
        if ([msg length] > 0)
        {
            msgStr = msg;
        }
        UIAlertView* alertView = [[[UIAlertView alloc] initWithTitle:@"提示" message:@"评价失败" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil] autorelease];
        [alertView show];
    }
}


ON_NOTIFICATION( notification )
{
	if ([notification.name isEqualToString:@"applicationDidBecomeActive"])
    {   // 界面被激活，查询积分
        [OnlineWallViewController sharedInstance].delegate = self;
        [[OnlineWallViewController sharedInstance] requestAndConsumePoint];
    }
}

- (void)updateLevel {
    if ( _levelCell != nil ) {
        // 修改等级信息
        int nLevel = [[LoginAndRegister sharedInstance] getUserLevel];
        int nExp = [[LoginAndRegister sharedInstance] getNextLevelExp] - [[LoginAndRegister sharedInstance] getCurrentExp];
        
        NSString* upText = [NSString stringWithFormat:@"赚钱小猪升级到LV%d", (nLevel+1)];
        NSString* downText = [NSString stringWithFormat:@"再赚%.2f元，即可升级领红包", 1.0*nExp / 100];
        [_levelCell setUpText:upText];
        [_levelCell setDownText:downText];
    }
}

- (void) showLoading {
    [MBHUDView hudWithBody:@"请等待..." type:MBAlertViewHUDTypeActivityIndicator hidesAfter:-1 show:YES];
}

- (void) hideLoading {
    [MBHUDView dismissCurrentHUD];
}


- (void) onClickShare {
    NSString* imagePath = [[NSBundle mainBundle] pathForResource:@"Icon@2x" ofType:@"png"];
    
    NSString* invite = [[LoginAndRegister sharedInstance] getInviteCode];
    int nBalance = [[LoginAndRegister sharedInstance] getIncome];
    NSString* content = [NSString stringWithFormat:@"我用赚钱小猪赚了%d元，你也可以的，填我的邀请码%@可领取2元红包。赚钱小猪下载地址:%@", nBalance/100, invite, [NSString stringWithFormat: INVITE_TASK, invite]];
                         
    id<ISSContent> publishContent = [ShareSDK content:content defaultContent:@"" image:[ShareSDK imageWithPath:imagePath] title: @"我们没情怀，直接发钞票" url: [NSString stringWithFormat: INVITE_TASK, invite] description: @"赚钱小猪分享" mediaType: SSPublishContentMediaTypeNews];
    
    [ShareSDK showShareActionSheet: nil shareList: nil content: publishContent statusBarTips: YES authOptions: nil shareOptions: nil result: ^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end)
     {
         if (state == SSResponseStateSuccess)
         {  // todo 分享成功，发送成功请求到服务器，返回获得的红包
             [self showLoading];
             HttpRequest* req = [[HttpRequest alloc] init:self];
             NSMutableDictionary* dictionary = [[[NSMutableDictionary alloc] init] autorelease];
             
             [req request:HTTP_TASK_SHARE Param:dictionary method:@"post"];
         }
         else if (state == SSResponseStateFail)
         {  // todo 分享失败
         }
     }];
}

-(void) HttpRequestCompleted : (id) request HttpCode:(int)httpCode Body:(NSDictionary*) body {
    [self hideLoading];
    
    if (httpCode == 200)
    {
        int result = [[body objectForKey:@"res"] intValue];
        if ( result != 0 ) {   // 返回失败了。。。
            NSString* msg = [body objectForKey:@"msg"];
            UIAlertView* view = [[[UIAlertView alloc] initWithTitle:@"错误" message:msg delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil] autorelease];
            [view show];
        }
        else {
            // 请求完成
            int nIncome = [[body objectForKey:@"income"] intValue];
            if ( nIncome > 0 ) {
                // 获得了金币
                NSString* strIncome = [NSString stringWithFloatRoundToPrecision:((float)nIncome)/100.f precision:2 ignoreBackZeros:NO];
                
                UIGetRedBagAlertView* getMoneyAlertView = [UIGetRedBagAlertView sharedInstance];
                [getMoneyAlertView setRMBString:strIncome];
                [getMoneyAlertView setLevel:3];
                [getMoneyAlertView setTitle:@"分享送红包"];
                [getMoneyAlertView setShowCurrentBanlance:[[LoginAndRegister sharedInstance] getBalance] andIncrease:nIncome];
                [getMoneyAlertView show];
                
                [[LoginAndRegister sharedInstance] increaseBalance:nIncome];
                
                [self refreshTaskList];
            }
        }
    }
}

#pragma mark <UIGetRedBagAlertViewDelegate>

- (void)onPressedCloseUIGetRedBagAlertView:(UIGetRedBagAlertView*)alertView
{
    if ( _levelChange > 0 )
    {
        UILevelUpAlertView* talert = [UILevelUpAlertView sharedInstance];
        [talert setLevel:[[LoginAndRegister sharedInstance] getUserLevel] level:_levelChange];
        
        _levelChange = 0;
        [talert show];
    }
}

- (void)onPressedGetRmbUIGetRedBagAlertView:(UIGetRedBagAlertView*)alertView
{
    if ( _levelChange > 0 )
    {
        UILevelUpAlertView* talert = [UILevelUpAlertView sharedInstance];
        [talert setLevel:[[LoginAndRegister sharedInstance] getUserLevel] level:_levelChange];
        _levelChange = 0;
        [talert show];
    }
}


@end
