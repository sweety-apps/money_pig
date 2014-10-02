//
//  OnlineWallViewController.m
//  wangcai
//
//  Created by 1528 on 13-12-31.
//  Copyright (c) 2013年 1528studio. All rights reserved.
//

#import "config.h"

#if !USE_NEW_OFFERWALL_REQUEST

#import "OnlineWallViewController.h"
#import "LoginAndRegister.h"
#import "HttpRequest.h"
#import "YouMiConfig.h"
#import "YouMiWall.h"
#import "YouMiWallAppModel.h"
#import "YouMiPointsManager.h"
#import "SettingLocalRecords.h"
#import "MobClick.h"
#import "BeeUIBoard+ModalBoard.h"
#import "WebPageController.h"

#import "JupengConfig.h"
#import "JupengWall.h"
#import "CommonTaskList.h"
#import "SiWeiAdConfig.h"
#import "SiWeiPointsManger.h"
#import "PunchBoxAd.h"
#import "PBOfferWall.h"
#import "BaseTaskTableViewController.h"

#import "DianRuAdWall.h"
#import "AdwoOfferWall.h"

@interface OnlineWallViewController ()
{
    DMOfferWallManager* _offerWallManager;
}

@end

@implementation OnlineWallViewController
@synthesize adView_adWall;
@synthesize delegate = _delegate;

static OnlineWallViewController* _sharedInstance;

+(OnlineWallViewController*) sharedInstance {
    if ( _sharedInstance == nil ) {
        _sharedInstance = [[OnlineWallViewController alloc] initWithNibName:nil bundle:nil];
    }
    
    return _sharedInstance;
}

-(void)setViewController:(UIViewController*) viewController {
    _viewController = viewController;
}

-(void)setTaskTableViewController:(BaseTaskTableViewController*)taskTableViewController {
    _baseTaskTableViewController = taskTableViewController;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        NSString* deviceId = [[LoginAndRegister sharedInstance] getDeviceId];
        _offerwallIncome = [[LoginAndRegister sharedInstance] getOfferwallIncome];
        
        _alertView = nil;
        _request = NO;
        _baseTaskTableViewController = nil;
        
        //多盟
        _offerWallManager = [[DMOfferWallManager alloc] initWithPublishId:DOMOB_PUBLISHER_ID userId:deviceId];
        _offerWallManager.delegate = self;
        
        // 触控
        [PunchBoxAd startSession:PUNCHBOX_APP_SECRET];
        [PunchBoxAd setVersion:1];
        [PBOfferWall sharedOfferWall].delegate = self;
        
        // 米迪
        [MiidiManager setAppPublisher:APP_MIIDI_ID withAppSecret:APP_MIIDI_SECRET];
        
        // 巨朋
        [JupengConfig launchWithAppID:APP_JUPENG_ID withAppSecret:APP_JUPENG_SECRET];
        
        // 点入
        [DianRuAdWall initAdWallWithDianRuAdWallDelegate:self];
        
        // 有米积分墙
#if TEST == 1
        NSString* did = [[NSString alloc] initWithFormat:@"dev_%@", deviceId];
        
        _offerWallController = [[DMOfferWallViewController alloc] initWithPublisherID:DOMOB_PUBLISHER_ID andUserID:did];
        _offerWallController.delegate = self;
        
        [YouMiConfig setUserID:did];
        
        [SiWeiAdConfig launchWithAppID:MOBSMAR_APP_ID];//初始化appid
        [SiWeiAdConfig setDeveloperParam:did];
        [SiWeiPointsManger enableSiweiWall];
        
        _mopanAdWallControl = [[MopanAdWall alloc] initWithMopan:MOPAN_APP_ID withAppSecret:MOPAN_APP_SECRET];
        [_mopanAdWallControl setCustomUserID:did];
        
        [PunchBoxAd setUserInfo:did];
        
        [MiidiAdWall setUserParam:did];
        
        [JupengWall setServerUserID:did];
#else
        _offerWallController = [[DMOfferWallViewController alloc] initWithPublisherID:DOMOB_PUBLISHER_ID andUserID:deviceId];
        _offerWallController.delegate = self;
        
        [YouMiConfig setUserID:deviceId];
        
        [SiWeiAdConfig launchWithAppID:MOBSMAR_APP_ID];//初始化appid
        [SiWeiAdConfig setDeveloperParam:deviceId];
        [SiWeiPointsManger enableSiweiWall];
        
        _mopanAdWallControl = [[MopanAdWall alloc] initWithMopan:MOPAN_APP_ID withAppSecret:MOPAN_APP_SECRET];
        [_mopanAdWallControl setCustomUserID:deviceId];
        
        [PunchBoxAd setUserInfo:deviceId];
        
        [MiidiAdWall setUserParam:deviceId];
        
        [JupengWall setServerUserID:deviceId];
#endif
        
        _siweWall = [SiWeiWall siwei];
        
        [YouMiConfig setUseInAppStore:YES];
        
        [YouMiConfig launchWithAppID:YOUMI_APP_ID appSecret:YOUMI_APP_SECRET];  //服务器版
        
        [YouMiWall enable];
        [YouMiPointsManager enable];
        
        [deviceId release];
        
        [[PBOfferWall sharedOfferWall] loadOfferWall:[PBADRequest request]];
    }
    return self;
}

- (void)setFullScreenWindow:(UIWindow*) window {
    [YouMiConfig setFullScreenWindow:window];
}

- (void)showWithModal {
    if ( _alertView != nil ) {
        [_alertView release];
    }
    
    BOOL showDomob = [[LoginAndRegister sharedInstance] isShowDomob] && (![[LoginAndRegister sharedInstance] isInMoreDomob]);
    BOOL showYoumi = [[LoginAndRegister sharedInstance] isShowYoumi] && (![[LoginAndRegister sharedInstance] isInMoreYoumi]);
    BOOL showLimei = [[LoginAndRegister sharedInstance] isShowLimei] && (![[LoginAndRegister sharedInstance] isInMoreLimei]);
    BOOL showMobsmar = [[LoginAndRegister sharedInstance] isShowMobsmar] && (![[LoginAndRegister sharedInstance] isInMoreMobsmar]);
    BOOL showMopan = [[LoginAndRegister sharedInstance] isShowMopan] && (![[LoginAndRegister sharedInstance] isInMoreMopan]);
    BOOL showPunchBox = [[LoginAndRegister sharedInstance] isShowPunchBox] && (![[LoginAndRegister sharedInstance] isInMorePunchBox]);
    BOOL showMiidi = [[LoginAndRegister sharedInstance] isShowMiidi] && (![[LoginAndRegister sharedInstance] isInMoreMiidi]);
    BOOL showJupeng = [[LoginAndRegister sharedInstance] isShowJupeng] && (![[LoginAndRegister sharedInstance] isInMoreJupeng]);
    BOOL showDianru = [[LoginAndRegister sharedInstance] isShowDianru] && (![[LoginAndRegister sharedInstance] isInMoreDianru]);
    BOOL showAdwo = [[LoginAndRegister sharedInstance] isShowAdwo] && (![[LoginAndRegister sharedInstance] isInMoreAdwo]);
    
    UIView* view = [[[[NSBundle mainBundle] loadNibNamed:@"OnlineWallViewController" owner:self options:nil] firstObject] autorelease];
    
    _nRecommend = 0;
    NSMutableArray* nsOfferwall = [[[NSMutableArray alloc] init] autorelease];
    if ( showDomob ) {
        [nsOfferwall pushTail:[view viewWithTag:11] ];
        if ( [[LoginAndRegister sharedInstance] isRecommendDomob] ) {
            _nRecommend = 11;
        }
    }
    if ( showYoumi ) {
        [nsOfferwall pushTail:[view viewWithTag:12] ];
        if ( [[LoginAndRegister sharedInstance] isRecommendYoumi] ) {
            _nRecommend = 12;
        }
    }
    if ( showLimei && [nsOfferwall count] < 2 ) {
        [nsOfferwall pushTail:[view viewWithTag:13] ];
        if ( [[LoginAndRegister sharedInstance] isRecommendLimei] ) {
            _nRecommend = 13;
        }
    }
    
    if ( showMobsmar && [nsOfferwall count] < 2 ) {
        [nsOfferwall pushTail:[view viewWithTag:14] ];
        if ( [[LoginAndRegister sharedInstance] isRecommendMobsmar] ) {
            _nRecommend = 14;
        }
    }
    
    if ( showMopan && [nsOfferwall count] < 2 ) {
        [nsOfferwall pushTail:[view viewWithTag:15] ];
        if ( [[LoginAndRegister sharedInstance] isRecommendMopan] ) {
            _nRecommend = 15;
        }
    }
    
    if ( showPunchBox && [nsOfferwall count] < 2 ) {
        [nsOfferwall pushTail:[view viewWithTag:16] ];
        if ( [[LoginAndRegister sharedInstance] isRecommendPunchBox] ) {
            _nRecommend = 16;
        }
    }
    
    if ( showMiidi && [nsOfferwall count] < 2 ) {
        [nsOfferwall pushTail:[view viewWithTag:17] ];
        if ( [[LoginAndRegister sharedInstance] isRecommendMiidi] ) {
            _nRecommend = 17;
        }
    }
    
    if ( showJupeng && [nsOfferwall count] < 2 ) {
        [nsOfferwall pushTail:[view viewWithTag:18] ];
        if ( [[LoginAndRegister sharedInstance] isRecommendJupeng] ) {
            _nRecommend = 18;
        }
    }
    
    if ( showDianru && [nsOfferwall count] < 2 ) {
        [nsOfferwall pushTail:[view viewWithTag:19] ];
        if ( [[LoginAndRegister sharedInstance] isRecommendDianru] ) {
            _nRecommend = 19;
        }
    }
    
    if ( showAdwo && [nsOfferwall count] < 2 ) {
        [nsOfferwall pushTail:[view viewWithTag:20] ];
        if ( [[LoginAndRegister sharedInstance] isRecommendAdwo] ) {
            _nRecommend = 20;
        }
    }
    
    [[view viewWithTag:11] setHidden:YES];
    [[view viewWithTag:12] setHidden:YES];
    [[view viewWithTag:13] setHidden:YES];
    [[view viewWithTag:14] setHidden:YES];
    [[view viewWithTag:15] setHidden:YES];
    [[view viewWithTag:16] setHidden:YES];
    [[view viewWithTag:17] setHidden:YES];
    [[view viewWithTag:18] setHidden:YES];
    [[view viewWithTag:19] setHidden:YES];
    [[view viewWithTag:20] setHidden:YES];
    
    _moreView = [view viewWithTag:97];
    [[view viewWithTag:97] setHidden:YES];
    if ( [[LoginAndRegister sharedInstance] isInMoreDomob] ||
        [[LoginAndRegister sharedInstance] isInMoreYoumi] ||
        [[LoginAndRegister sharedInstance] isInMoreLimei] ||
        [[LoginAndRegister sharedInstance] isInMoreMobsmar] ||
        [[LoginAndRegister sharedInstance] isInMoreMopan] ||
        [[LoginAndRegister sharedInstance] isInMorePunchBox] ||
        [[LoginAndRegister sharedInstance] isInMoreJupeng] ||
        [[LoginAndRegister sharedInstance] isInMoreDianru] ||
        [[LoginAndRegister sharedInstance] isInMoreAdwo] ) {
        // 显示更多按钮
        [[view viewWithTag:91] setHidden:NO];
        [self repositionMore];
    } else {
        [[view viewWithTag:91] setHidden:YES];
    }
    
    if ( [nsOfferwall count] == 2 ) {
        // 显示两个按钮
        UIButton* btn1 = (UIButton*) [nsOfferwall objectAtIndex:0];
        UIButton* btn2 = (UIButton*) [nsOfferwall objectAtIndex:1];
        
        CGRect rect = btn1.frame;
        [btn1 setHidden:NO];
        rect.origin.y = 275;
        [btn1 setFrame:rect];
        
        rect = btn2.frame;
        [btn2 setHidden:NO];
        rect.origin.y = 335;
        [btn2 setFrame:rect];
    } else if ( [nsOfferwall count] == 1 ) {
        // 只显示一个按钮
        UIButton* btn1 = (UIButton*) [nsOfferwall objectAtIndex:0];
        
        CGRect rect = btn1.frame;
        [btn1 setHidden:NO];
        rect.origin.y = 310;
        [btn1 setFrame:rect];
    } else {
        return ;
    }
    
    if ( _nRecommend != 0 ) {
        UIView* btnView = [view viewWithTag:_nRecommend];
        [[view viewWithTag:22] setFrame:btnView.frame];
        [[view viewWithTag:22] setHidden:NO];
    } else {
        [[view viewWithTag:22] setHidden:YES];
    }
    
    UIColor *color = [UIColor colorWithRed:179.0/255 green:179.0/255 blue:179.0/255 alpha:1];
    
    UIButton* btn = (UIButton*)[view viewWithTag:11];
    [btn setTitleColor:color forState:UIControlStateHighlighted];
    
    [btn.layer setBorderWidth:0];
    
    btn = (UIButton*)[view viewWithTag:12];
    [btn setTitleColor:color forState:UIControlStateHighlighted];
    
    [btn.layer setBorderWidth:0];
    
    _alertView = [[UICustomAlertView alloc]init:view];
    
    //[view release];
    [_alertView show];
}

- (void)repositionMore {
    NSMutableArray* nsOfferwall = [[[NSMutableArray alloc] init] autorelease];
    
    if ( [[LoginAndRegister sharedInstance] isInMoreDianru] ) {
        [nsOfferwall pushTail:[_moreView viewWithTag:59] ];
    }
    
    if ( [[LoginAndRegister sharedInstance] isInMoreAdwo] ) {
        [nsOfferwall pushTail:[_moreView viewWithTag:60] ];
    }
    
    if ( [[LoginAndRegister sharedInstance] isInMoreDomob] ) {
        [nsOfferwall pushTail:[_moreView viewWithTag:51] ];
    }
    
    if ( [[LoginAndRegister sharedInstance] isInMoreYoumi] ) {
        [nsOfferwall pushTail:[_moreView viewWithTag:52] ];
    }
    
    if ( [[LoginAndRegister sharedInstance] isInMoreLimei] ) {
        [nsOfferwall pushTail:[_moreView viewWithTag:53] ];
    }
    
    if ( [[LoginAndRegister sharedInstance] isInMoreMobsmar] ) {
        [nsOfferwall pushTail:[_moreView viewWithTag:54] ];
    }
    
    if ( [[LoginAndRegister sharedInstance] isInMoreMopan] ) {
        [nsOfferwall pushTail:[_moreView viewWithTag:55] ];
    }
    
    if ( [[LoginAndRegister sharedInstance] isInMorePunchBox] ) {
        [nsOfferwall pushTail:[_moreView viewWithTag:56] ];
    }
    
    if ( [[LoginAndRegister sharedInstance] isInMoreMiidi] ) {
        [nsOfferwall pushTail:[_moreView viewWithTag:57] ];
    }
    
    if ( [[LoginAndRegister sharedInstance] isInMoreJupeng] ) {
        [nsOfferwall pushTail:[_moreView viewWithTag:58] ];
    }
    
    [[_moreView viewWithTag:51] setHidden:YES];
    [[_moreView viewWithTag:52] setHidden:YES];
    [[_moreView viewWithTag:53] setHidden:YES];
    [[_moreView viewWithTag:54] setHidden:YES];
    [[_moreView viewWithTag:55] setHidden:YES];
    [[_moreView viewWithTag:56] setHidden:YES];
    [[_moreView viewWithTag:57] setHidden:YES];
    [[_moreView viewWithTag:58] setHidden:YES];
    [[_moreView viewWithTag:59] setHidden:YES];
    [[_moreView viewWithTag:60] setHidden:YES];
    
    for (int i = 0; i < [nsOfferwall count]; i ++ ) {
        UIView* btnView = [nsOfferwall objectAtIndex:i];
        [btnView setHidden:NO];
        CGRect rect = btnView.frame;
        rect.origin.y = 47 + (60 * i);
        [btnView setFrame:rect];
    }
}

- (IBAction)onClickBack:(id)sender {
    if ( _moreView != nil ) {
        [_moreView setHidden:YES];
    }
}

- (IBAction)onClickNaviback:(id)sender {
}

- (IBAction)clickYoumi:(id)sender {
    if ( _alertView != nil ) {
        [_alertView hideAlertView];
    }
    
    [MobClick event:@"task_list_click_youmi" attributes:@{@"currentpage":@"任务列表"}];
    [YouMiWall showOffers:YES didShowBlock:^{
    }didDismissBlock:^{
    }];
}

- (IBAction) clickMore:(id)sender {
    [_moreView setHidden:NO];
}

- (IBAction)clickMobsmar:(id)sender {
    if ( _alertView != nil ) {
        [_alertView hideAlertView];
    }
    
    [MobClick event:@"task_list_click_mobsmar" attributes:@{@"currentpage":@"任务列表"}];
    [_siweWall showOfferWall:_viewController];//打开积分墙
}

- (IBAction)clickMopan:(id)sender {
    if ( _alertView != nil ) {
        [_alertView hideAlertView];
    }
    
    [MobClick event:@"task_list_click_mopan" attributes:@{@"currentpage":@"任务列表"}];
    
    _mopanAdWallControl.rootViewController = _viewController;
    [_mopanAdWallControl showAppOffers];
}

- (IBAction)clickPunchBox:(id)sender {
    if ( _alertView != nil ) {
        [_alertView hideAlertView];
    }
    
    [MobClick event:@"task_list_click_pubchbox" attributes:@{@"currentpage":@"任务列表"}];
    [PBOfferWall sharedOfferWall].orientationSupported = PBOrientationSupported_Vertical;
    [[PBOfferWall sharedOfferWall] showOfferWallWithScale:1.0f];
}

- (void)pbOfferWall:(PBOfferWall *)pbOfferWall finishTaskRewardCoin:(NSArray *)taskCoins {
    
}


// 积分墙加载完成
- (void)pbOfferWallDidLoadAd:(PBOfferWall *)pbOfferWall {
    
}

// 积分墙加载错误
- (void)pbOfferWall:(PBOfferWall *)pbOfferWall loadAdFailureWithError:(PBRequestError *)requestError {
    
}

// 积分墙打开完成
- (void)pbOfferWallDidPresentScreen:(PBOfferWall *)pbOfferWall {
    
}

// 积分墙将要关闭
- (void)pbOfferWallWillDismissScreen:(PBOfferWall *)pbOfferWall {
    
}

// 积分墙关闭完成
- (void)pbOfferWallDidDismissScreen:(PBOfferWall *)pbOfferWall {
    
}


- (IBAction)clickLimei:(id)sender {
    if ( _alertView != nil ) {
        [_alertView hideAlertView];
    }
    
    [MobClick event:@"task_list_click_limei" attributes:@{@"currentpage":@"任务列表"}];
    [self enterAdWall];
}

// 进入积分墙
-(void)enterAdWall{
    // 实例化 immobView 对象,在此处替换在力美广告平台申请到的广告位 ID;
    self.adView_adWall=[[immobView alloc] initWithAdUnitID:LIMEI_ID];
    //添加 immobView 的 Delegate;
    self.adView_adWall.delegate=self;
    
    //添加 userAccount 属性,此属性针对多账户应用所使用,用于区分不同账户下的积分(可选)。
    NSString* deviceId = [[LoginAndRegister sharedInstance] getDeviceId];
#if TEST == 1
    NSString* did = [[NSString alloc] initWithFormat:@"dev_%@", deviceId];
    [self.adView_adWall.UserAttribute setObject:did forKey:@"accountname"];
#else
    [self.adView_adWall.UserAttribute setObject:deviceId forKey:@"accountname"];
#endif
    
    [deviceId release];
    
    //开始加载广告。
    [self.adView_adWall immobViewRequest];
    
    UIView* view = _viewController.view;
    
    //将 immobView 添加到界面上。
    [view addSubview:adView_adWall];
    
    //将 immobView 添加到界面后,调用 immobViewDisplay。
    [self.adView_adWall immobViewDisplay];
}

// 设置必需的 UIViewController, 此方法的返回值如果为空,会导致广告展示不正常。
- (UIViewController *)immobViewController{
    return _viewController;
}

- (void) immobView: (immobView*) immobView didFailReceiveimmobViewWithError: (NSInteger) errorCode {
    
}

- (void) immobViewDidReceiveAd:(immobView*)immobView {
}

- (IBAction)clickDomob:(id)sender {
    if ( _alertView != nil ) {
        [_alertView hideAlertView];
    }
    
    [MobClick event:@"task_list_click_duomeng" attributes:@{@"currentpage":@"任务列表"}];
    [_offerWallController presentOfferWall];
}

- (IBAction)clickClose:(id)sender {
    if ( _alertView != nil ) {
        [_alertView hideAlertView];
    }
}

- (IBAction)clickHelper:(id)sender {
    if ( _alertView != nil ) {
        [_alertView hideAlertView];
    }
    
    BeeUIStack* stack = [BeeUIRouter sharedInstance].currentStack;
    
    NSString* url = [[[NSString alloc] initWithFormat:@"%@132", WEB_SERVICE_VIEW] autorelease];
    
    WebPageController* controller = [[[WebPageController alloc] init:@"重要提示"
                                                                 Url:url Stack:stack] autorelease];
    [stack pushViewController:controller animated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void) dealloc {
    _offerWallController.delegate = nil;
    [_offerWallController release];
    _offerWallController = nil;
    
    if ( self->_alertView != nil ) {
        [self->_alertView release];
        self->_alertView = nil;
    }
    
    [PBOfferWall sharedOfferWall].delegate = nil;
    [[PBOfferWall sharedOfferWall] closeOfferWall];
    
    [_yueLbl release];
    [_yueView release];
    [_tableView release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// 积分墙开始加载数据。
- (void)offerWallDidStartLoad {
    
}

// 积分墙加载完成。
- (void)offerWallDidFinishLoad {
    
}

// 积分墙加载失败。可能的原因由error部分提供,例如⺴⽹网络连接失败、被禁⽤用等。
- (void)offerWallDidFailLoadWithError:(NSError *)error {
    
}

// 积分墙页面被关闭。
// Offer wall closed.
- (void)offerWallDidClosed {
    
}

- (void)requestAndConsumePoint {
    if ( _request ) {
        return ;
    }
    
    _request = YES;
    [_offerWallManager requestOnlinePointCheck];
}

// 积分查询成功之后，回调该接口，获取总积分和总已消费积分。
// Called when finished to do point check.
- (void)offerWallDidFinishCheckPointWithTotalPoint:(NSInteger)totalPoint
                             andTotalConsumedPoint:(NSInteger)consumed {
    _nConsume = totalPoint - consumed;
    
    int clearPoint = [SettingLocalRecords getDomobPoint];
    _allConsume = _nConsume;
    _nConsume -= clearPoint;    // 实际可消费的点数
    
    _remained = *[YouMiPointsManager pointsRemained];
    
    // 能消费的积分
    if ( _nConsume > 0 || _remained > 0 ) {
        // 有能消费的积分
        // 报给自己的服务器获取能消费的积分数
        HttpRequest* request = [[HttpRequest alloc] init:self];
        
        NSMutableDictionary* dictionary = [[[NSMutableDictionary alloc] init] autorelease];
        NSString* nsPoint = [[[NSString alloc] initWithFormat:@"%d", _nConsume] autorelease];
        NSString* nsYoumi = [[[NSString alloc] initWithFormat:@"%d", _remained] autorelease];
        
        [dictionary setObject:nsPoint forKey:@"domob_point"];
        [dictionary setObject:nsYoumi forKey:@"youmi_point"];
        
        [request request:HTTP_TASK_OFFERWALL Param:dictionary method:@"post"];
    } else {
        // 不继续往下请求
        _request = NO;
    }
}

// 积分查询失败之后，回调该接口，返回查询失败的错误原因。
// Called when failed to do point check.
- (void)offerWallDidFailCheckPointWithError:(NSError *)error {
    _request = NO;
}

#pragma mark Consume Callbacks
// 消费请求正常应答后，回调该接口，并返回消费状态（成功或余额不足），以及总积分和总已消费积分。
- (void)offerWallDidFinishConsumePointWithStatusCode:(DMOfferWallConsumeStatusCode)statusCode
                                          totalPoint:(NSInteger)totalPoint
                                  totalConsumedPoint:(NSInteger)consumed {
    switch (statusCode) {
        case DMOfferWallConsumeStatusCodeSuccess:
            [SettingLocalRecords setDomobPoint:0];
            break;
        default:
            [SettingLocalRecords setDomobPoint:_allConsume];
            _allConsume = 0;
            break;
    }
    
    _request = NO;
}

// 消费请求异常应答后，回调该接口，并返回异常的错误原因。
// Called when failed to do consume request.
- (void)offerWallDidFailConsumePointWithError:(NSError *)error {
    // 从多盟那消费积分失败
    [SettingLocalRecords setDomobPoint:_allConsume];
    _allConsume = 0;
    
    _request = NO;
}

#pragma mark CheckOfferWall Enable Callbacks
// 获取积分墙可用状态的回调。
// Called after get OfferWall enable state.
- (void)offerWallDidCheckEnableState:(BOOL)enable {
    
}

-(void) HttpRequestCompleted : (id) request HttpCode:(int)httpCode Body:(NSDictionary*) body {
    /*NSError* error;
     NSString* tmp = @"{\"offerwall_income\": 0, \"benefit\": 0, \"wangcai_income\": [{\"task_id\":10000,\"income\":300}], \"exp_next_level\": 2000, \"income\": 0, \"msg\": \"\", \"res\": 0, \"level\": 1, \"exp_current\": 0}";
     NSData* aData = [tmp dataUsingEncoding: NSASCIIStringEncoding];
     body = [NSJSONSerialization JSONObjectWithData:aData options:NSJSONReadingMutableLeaves error:&error];
     */
    if ( httpCode == 200 ) {
        int res = [[body objectForKey:@"res"] intValue];
        if ( res == 0 ) {
            int offerwallIncome = [[body valueForKey:@"offerwall_income"] intValue];
            
            int userLevel = [[body valueForKey:@"level"] intValue];
            int currentEXP = [[body valueForKey:@"exp_current"] intValue];
            int nextLevelEXP = [[body valueForKey:@"exp_next_level"] intValue];
            int benefit = [[body valueForKey:@"benefit"] intValue];
            
            int levelChange = 0;
            if (userLevel > 0)
            {
                int nLevel = [[LoginAndRegister sharedInstance] getUserLevel];
                if ( nLevel < userLevel ) {
                    // 等级变化
                    levelChange = 200;
                }
                [[LoginAndRegister sharedInstance] setUserLevel:userLevel];
                [[LoginAndRegister sharedInstance] setCurrentExp:currentEXP];
                [[LoginAndRegister sharedInstance] setNextLevelExp:nextLevelEXP];
                if (benefit > 0)
                {
                    [[LoginAndRegister sharedInstance] setBenefit:benefit];
                }
                [_baseTaskTableViewController updateLevel];
            }
            
            NSArray* wangcaiIncome = [body valueForKey:@"wangcai_income"];
            int nWangcaiIncome = 0; // 旺财任务获得的钱
            if ( wangcaiIncome != nil ) {
                for ( int i = 0; i < [wangcaiIncome count]; i ++ ) {
                    NSDictionary* item = [wangcaiIncome objectAtIndex:i];
                    
                    int taskId = [[item objectForKey:@"task_id"] intValue];
                    
                    if ( [self isUnfinished:taskId] ) {
                        nWangcaiIncome += [[item objectForKey:@"income"] intValue];
                    }
                }
            }
            
            //旧版协议处理收入的逻辑
            [SettingLocalRecords setDomobPoint:_allConsume];
            
            int inc = [[body objectForKey:@"income"] intValue];
            
            // 消费掉多余的积分
            [YouMiPointsManager spendPoints:_remained];
            [_offerWallManager requestOnlineConsumeWithPoint:_allConsume];
            
            if ( inc > 0 ) {
                nWangcaiIncome = inc;
            }
            
            if ( offerwallIncome > _offerwallIncome || nWangcaiIncome > 0 ) {
                int diff = offerwallIncome - _offerwallIncome;
                
                _offerwallIncome = offerwallIncome;
                [self->_delegate onRequestAndConsumePointCompleted:YES Consume:diff Level:levelChange wangcaiIncome:nWangcaiIncome];
            }
            
            _request = NO;
        } else {
            _request = NO;
        }
    } else {
        _request = NO;
    }
}

- (BOOL) isUnfinished:(int) taskId {
    NSArray* unfinished = [[CommonTaskList sharedInstance] getUnfinishedTaskList];
    for ( int i = 0; i < [unfinished count]; i ++ ) {
        CommonTaskInfo* obj = [unfinished objectAtIndex:i];
        if ( [obj.taskId intValue] == taskId ) {
            return YES;
        }
    }
    
    return NO;
}

- (IBAction)clickMiidi:(id)sender {
    if ( _alertView != nil ) {
        [_alertView hideAlertView];
    }
    
    [MiidiAdWall showAppOffers:_viewController withDelegate:self];
}

- (IBAction)clickJupeng:(id)sender {
    if ( _alertView != nil ) {
        [_alertView hideAlertView];
    }
    
    [JupengWall showOffers:_viewController didShowBlock:nil didDismissBlock:nil];
}

- (IBAction)clickDianru:(id)sender {
    if ( _alertView != nil ) {
        [_alertView hideAlertView];
    }
    
    [DianRuAdWall showAdWall:_viewController];
}

- (IBAction)clickAdwo:(id)sender {
    if ( _alertView != nil ) {
        [_alertView hideAlertView];
    }
    
    // 安沃
    AdwoOWPresentOfferWall(ADWO_OFFERWALL_BASIC_PID, _viewController);
}

- (NSString *)applicationKey {
    return @"00003215130000F0";
}

- (NSString*) dianruAdWallAppUserId {
    NSString* deviceId = [[LoginAndRegister sharedInstance] getDeviceId];
#if TEST == 1
    NSString* userid = [NSString stringWithFormat:@"dev_%@", deviceId];
#else
    NSString* userid = [NSString stringWithFormat:@"%@", deviceId];
#endif
    
    [deviceId release];
    
    return userid;
}

@end

#endif

#pragma mark - 新版服务器轮询查积分

#if USE_NEW_OFFERWALL_REQUEST

#import "OnlineWallViewController.h"
#import "LoginAndRegister.h"
#import "HttpRequest.h"
#import "YouMiConfig.h"
#import "YouMiWall.h"
#import "YouMiWallAppModel.h"
#import "YouMiPointsManager.h"
#import "SettingLocalRecords.h"
#import "MobClick.h"
#import "BeeUIBoard+ModalBoard.h"
#import "WebPageController.h"
#import "OfferwallTipTableViewCell.h"
#import "OfferwallTableViewCell.h"

#import "JupengConfig.h"
#import "JupengWall.h"
#import "CommonTaskList.h"
#import "SiWeiAdConfig.h"
#import "SiWeiPointsManger.h"
#import "PunchBoxAd.h"
#import "PBOfferWall.h"
#import "BaseTaskTableViewController.h"

#import "DianRuAdWall.h"
#import "AdwoOfferWall.h"

@interface OnlineWallViewController ()
{
    NSMutableArray* _tableViewDataDictArr;
    BOOL _needRefreshUI;
}
@end

@implementation OnlineWallViewController
@synthesize adView_adWall;
@synthesize delegate = _delegate;

static OnlineWallViewController* _sharedInstance;

+(OnlineWallViewController*) sharedInstance {
    if ( _sharedInstance == nil ) {
        _sharedInstance = [[OnlineWallViewController alloc] initWithNibName:nil bundle:nil];
    }
    
    return _sharedInstance;
}

-(void)setViewController:(UIViewController*) viewController {
    _viewController = viewController;
}

-(void)setTaskTableViewController:(BaseTaskTableViewController*)taskTableViewController {
    _baseTaskTableViewController = taskTableViewController;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        NSString* deviceId = [[LoginAndRegister sharedInstance] getDeviceId];
        _offerwallIncome = [[LoginAndRegister sharedInstance] getOfferwallIncome];
        
        _alertView = nil;
        _request = NO;
        _baseTaskTableViewController = nil;
        
        // 触控
        [PunchBoxAd startSession:PUNCHBOX_APP_SECRET];
        [PunchBoxAd setVersion:1];
        [PBOfferWall sharedOfferWall].delegate = self;
        
        // 米迪
        [MiidiManager setAppPublisher:APP_MIIDI_ID withAppSecret:APP_MIIDI_SECRET];
        
        // 巨朋
        [JupengConfig launchWithAppID:APP_JUPENG_ID withAppSecret:APP_JUPENG_SECRET];
        
        // 点入
        [DianRuAdWall initAdWallWithDianRuAdWallDelegate:self];
        
        // 有米积分墙
#if TEST == 1
        NSString* did = [[NSString alloc] initWithFormat:@"dev_%@", deviceId];
        
        _offerWallController = [[DMOfferWallViewController alloc] initWithPublisherID:DOMOB_PUBLISHER_ID andUserID:did];
        _offerWallController.delegate = self;
        
        [YouMiConfig setUserID:did];
        
        [SiWeiAdConfig launchWithAppID:MOBSMAR_APP_ID];//初始化appid
        [SiWeiAdConfig setDeveloperParam:did];
        [SiWeiPointsManger enableSiweiWall];
        
        _mopanAdWallControl = [[MopanAdWall alloc] initWithMopan:MOPAN_APP_ID withAppSecret:MOPAN_APP_SECRET];
        [_mopanAdWallControl setCustomUserID:did];
        
        [PunchBoxAd setUserInfo:did];
        
        [MiidiAdWall setUserParam:did];
        
        [JupengWall setServerUserID:did];
#else 
        _offerWallController = [[DMOfferWallViewController alloc] initWithPublisherID:DOMOB_PUBLISHER_ID andUserID:deviceId];
        _offerWallController.delegate = self;

        [YouMiConfig setUserID:deviceId];
        
        [SiWeiAdConfig launchWithAppID:MOBSMAR_APP_ID];//初始化appid
        [SiWeiAdConfig setDeveloperParam:deviceId];
        [SiWeiPointsManger enableSiweiWall];
        
        _mopanAdWallControl = [[MopanAdWall alloc] initWithMopan:MOPAN_APP_ID withAppSecret:MOPAN_APP_SECRET];
        [_mopanAdWallControl setCustomUserID:deviceId];
        
        [PunchBoxAd setUserInfo:deviceId];
        
        [MiidiAdWall setUserParam:deviceId];
        
        [JupengWall setServerUserID:deviceId];
#endif
        
        _siweWall = [SiWeiWall siwei];
        
        [YouMiConfig setUseInAppStore:YES];
        
        [YouMiConfig launchWithAppID:YOUMI_APP_ID appSecret:YOUMI_APP_SECRET];  //服务器版
        
        [YouMiWall enable];
        [YouMiPointsManager enable];
        
        [deviceId release];
        
        [[PBOfferWall sharedOfferWall] loadOfferWall:[PBADRequest request]];
        
        [self _generateDataArray];
    }
    return self;
}

- (void) _generateDataArray
{
    if (_tableViewDataDictArr)
    {
        [_tableViewDataDictArr release];
        _tableViewDataDictArr = nil;
    }
    _tableViewDataDictArr = [NSMutableArray arrayWithArray:
                             @[
                               @{
                                   @"icon":@"task_icon_punchbox",
                                   @"name":@"触控应用任务",
                                   @"type":@"punchbox",
                                   @"ishot":@1
                                   },
                               @{
                                   @"icon":@"task_icon_youmi",
                                   @"name":@"有米应用任务",
                                   @"type":@"youmi",
                                   @"ishot":@0
                                   },
                               @{
                                   @"icon":@"task_icon_domob",
                                   @"name":@"触控应用任务",
                                   @"type":@"domob",
                                   @"ishot":@0
                                   },
                               @{
                                   @"icon":@"task_icon_dianru",
                                   @"name":@"点入应用任务",
                                   @"type":@"dianru",
                                   @"ishot":@0
                                   }
                               ]];
    [_tableViewDataDictArr retain];
}

- (void)setFullScreenWindow:(UIWindow*) window {
    [YouMiConfig setFullScreenWindow:window];
}

- (void)showWithModal {
    if ( _alertView != nil ) {
        [_alertView release];
    }
    
    BOOL showDomob = [[LoginAndRegister sharedInstance] isShowDomob] && (![[LoginAndRegister sharedInstance] isInMoreDomob]);
    BOOL showYoumi = [[LoginAndRegister sharedInstance] isShowYoumi] && (![[LoginAndRegister sharedInstance] isInMoreYoumi]);
    BOOL showLimei = [[LoginAndRegister sharedInstance] isShowLimei] && (![[LoginAndRegister sharedInstance] isInMoreLimei]);
    BOOL showMobsmar = [[LoginAndRegister sharedInstance] isShowMobsmar] && (![[LoginAndRegister sharedInstance] isInMoreMobsmar]);
    BOOL showMopan = [[LoginAndRegister sharedInstance] isShowMopan] && (![[LoginAndRegister sharedInstance] isInMoreMopan]);
    BOOL showPunchBox = [[LoginAndRegister sharedInstance] isShowPunchBox] && (![[LoginAndRegister sharedInstance] isInMorePunchBox]);
    BOOL showMiidi = [[LoginAndRegister sharedInstance] isShowMiidi] && (![[LoginAndRegister sharedInstance] isInMoreMiidi]);
    BOOL showJupeng = [[LoginAndRegister sharedInstance] isShowJupeng] && (![[LoginAndRegister sharedInstance] isInMoreJupeng]);
    BOOL showDianru = [[LoginAndRegister sharedInstance] isShowDianru] && (![[LoginAndRegister sharedInstance] isInMoreDianru]);
    BOOL showAdwo = [[LoginAndRegister sharedInstance] isShowAdwo] && (![[LoginAndRegister sharedInstance] isInMoreAdwo]);
    
    showPunchBox = YES;
    
    UIView* view = [[[[NSBundle mainBundle] loadNibNamed:@"OnlineWallViewController" owner:self options:nil] firstObject] autorelease];
    
    _nRecommend = 0;
    NSMutableArray* nsOfferwall = [[[NSMutableArray alloc] init] autorelease];
    if ( showDomob ) {
        [nsOfferwall pushTail:[view viewWithTag:11] ];
        if ( [[LoginAndRegister sharedInstance] isRecommendDomob] ) {
            _nRecommend = 11;
        }
    }
    if ( showYoumi ) {
        [nsOfferwall pushTail:[view viewWithTag:12] ];
        if ( [[LoginAndRegister sharedInstance] isRecommendYoumi] ) {
            _nRecommend = 12;
        }
    }
    if ( showLimei && [nsOfferwall count] < 2 ) {
        [nsOfferwall pushTail:[view viewWithTag:13] ];
        if ( [[LoginAndRegister sharedInstance] isRecommendLimei] ) {
            _nRecommend = 13;
        }
    }
    
    if ( showMobsmar && [nsOfferwall count] < 2 ) {
        [nsOfferwall pushTail:[view viewWithTag:14] ];
        if ( [[LoginAndRegister sharedInstance] isRecommendMobsmar] ) {
            _nRecommend = 14;
        }
    }
    
    if ( showMopan && [nsOfferwall count] < 2 ) {
        [nsOfferwall pushTail:[view viewWithTag:15] ];
        if ( [[LoginAndRegister sharedInstance] isRecommendMopan] ) {
            _nRecommend = 15;
        }
    }
    
    if ( showPunchBox && [nsOfferwall count] < 2 ) {
        [nsOfferwall pushTail:[view viewWithTag:16] ];
        if ( [[LoginAndRegister sharedInstance] isRecommendPunchBox] ) {
            _nRecommend = 16;
        }
    }
    
    if ( showMiidi && [nsOfferwall count] < 2 ) {
        [nsOfferwall pushTail:[view viewWithTag:17] ];
        if ( [[LoginAndRegister sharedInstance] isRecommendMiidi] ) {
            _nRecommend = 17;
        }
    }

    if ( showJupeng && [nsOfferwall count] < 2 ) {
        [nsOfferwall pushTail:[view viewWithTag:18] ];
        if ( [[LoginAndRegister sharedInstance] isRecommendJupeng] ) {
            _nRecommend = 18;
        }
    }
    
    if ( showDianru && [nsOfferwall count] < 2 ) {
        [nsOfferwall pushTail:[view viewWithTag:19] ];
        if ( [[LoginAndRegister sharedInstance] isRecommendDianru] ) {
            _nRecommend = 19;
        }
    }
    
    if ( showAdwo && [nsOfferwall count] < 2 ) {
        [nsOfferwall pushTail:[view viewWithTag:20] ];
        if ( [[LoginAndRegister sharedInstance] isRecommendAdwo] ) {
            _nRecommend = 20;
        }
    }
    
    [[view viewWithTag:11] setHidden:YES];
    [[view viewWithTag:12] setHidden:YES];
    [[view viewWithTag:13] setHidden:YES];
    [[view viewWithTag:14] setHidden:YES];
    [[view viewWithTag:15] setHidden:YES];
    [[view viewWithTag:16] setHidden:YES];
    [[view viewWithTag:17] setHidden:YES];
    [[view viewWithTag:18] setHidden:YES];
    [[view viewWithTag:19] setHidden:YES];
    [[view viewWithTag:20] setHidden:YES];
    
    _moreView = [view viewWithTag:97];
    [[view viewWithTag:97] setHidden:YES];
    if ( [[LoginAndRegister sharedInstance] isInMoreDomob] ||
        [[LoginAndRegister sharedInstance] isInMoreYoumi] ||
        [[LoginAndRegister sharedInstance] isInMoreLimei] ||
        [[LoginAndRegister sharedInstance] isInMoreMobsmar] ||
        [[LoginAndRegister sharedInstance] isInMoreMopan] ||
        [[LoginAndRegister sharedInstance] isInMorePunchBox] ||
        [[LoginAndRegister sharedInstance] isInMoreJupeng] ||
        [[LoginAndRegister sharedInstance] isInMoreDianru] ||
        [[LoginAndRegister sharedInstance] isInMoreAdwo] ) {
        // 显示更多按钮
        [[view viewWithTag:91] setHidden:NO];
        [self repositionMore];
    } else {
        [[view viewWithTag:91] setHidden:YES];
    }
    
    if ( [nsOfferwall count] == 2 ) {
        // 显示两个按钮
        UIButton* btn1 = (UIButton*) [nsOfferwall objectAtIndex:0];
        UIButton* btn2 = (UIButton*) [nsOfferwall objectAtIndex:1];
        
        CGRect rect = btn1.frame;
        [btn1 setHidden:NO];
        rect.origin.y = 275;
        [btn1 setFrame:rect];
        
        rect = btn2.frame;
        [btn2 setHidden:NO];
        rect.origin.y = 335;
        [btn2 setFrame:rect];
    } else if ( [nsOfferwall count] == 1 ) {
        // 只显示一个按钮
        UIButton* btn1 = (UIButton*) [nsOfferwall objectAtIndex:0];
        
        CGRect rect = btn1.frame;
        [btn1 setHidden:NO];
        rect.origin.y = 310;
        [btn1 setFrame:rect];
    } else {
        return ;
    }
    
    if ( _nRecommend != 0 ) {
        UIView* btnView = [view viewWithTag:_nRecommend];
        [[view viewWithTag:22] setFrame:btnView.frame];
        [[view viewWithTag:22] setHidden:NO];
    } else {
        [[view viewWithTag:22] setHidden:YES];
    }
    
    UIColor *color = [UIColor colorWithRed:179.0/255 green:179.0/255 blue:179.0/255 alpha:1];
        
    UIButton* btn = (UIButton*)[view viewWithTag:11];
    [btn setTitleColor:color forState:UIControlStateHighlighted];
    
    [btn.layer setBorderWidth:0];
    
    btn = (UIButton*)[view viewWithTag:12];
    [btn setTitleColor:color forState:UIControlStateHighlighted];
    
    [btn.layer setBorderWidth:0];

    _alertView = [[UICustomAlertView alloc]init:view];
        
    //[view release];
    [_alertView show];
}

- (void)repositionMore {
    NSMutableArray* nsOfferwall = [[[NSMutableArray alloc] init] autorelease];

    if ( [[LoginAndRegister sharedInstance] isInMoreDianru] ) {
        [nsOfferwall pushTail:[_moreView viewWithTag:59] ];
    }
    
    if ( [[LoginAndRegister sharedInstance] isInMoreAdwo] ) {
        [nsOfferwall pushTail:[_moreView viewWithTag:60] ];
    }
    
    if ( [[LoginAndRegister sharedInstance] isInMoreDomob] ) {
        [nsOfferwall pushTail:[_moreView viewWithTag:51] ];
    }
    
    if ( [[LoginAndRegister sharedInstance] isInMoreYoumi] ) {
        [nsOfferwall pushTail:[_moreView viewWithTag:52] ];
    }
    
    if ( [[LoginAndRegister sharedInstance] isInMoreLimei] ) {
        [nsOfferwall pushTail:[_moreView viewWithTag:53] ];
    }
    
    if ( [[LoginAndRegister sharedInstance] isInMoreMobsmar] ) {
        [nsOfferwall pushTail:[_moreView viewWithTag:54] ];
    }
    
    if ( [[LoginAndRegister sharedInstance] isInMoreMopan] ) {
        [nsOfferwall pushTail:[_moreView viewWithTag:55] ];
    }
    
    if ( [[LoginAndRegister sharedInstance] isInMorePunchBox] ) {
        [nsOfferwall pushTail:[_moreView viewWithTag:56] ];
    }
    
    if ( [[LoginAndRegister sharedInstance] isInMoreMiidi] ) {
        [nsOfferwall pushTail:[_moreView viewWithTag:57] ];
    }
    
    if ( [[LoginAndRegister sharedInstance] isInMoreJupeng] ) {
        [nsOfferwall pushTail:[_moreView viewWithTag:58] ];
    }
    
    [[_moreView viewWithTag:51] setHidden:YES];
    [[_moreView viewWithTag:52] setHidden:YES];
    [[_moreView viewWithTag:53] setHidden:YES];
    [[_moreView viewWithTag:54] setHidden:YES];
    [[_moreView viewWithTag:55] setHidden:YES];
    [[_moreView viewWithTag:56] setHidden:YES];
    [[_moreView viewWithTag:57] setHidden:YES];
    [[_moreView viewWithTag:58] setHidden:YES];
    [[_moreView viewWithTag:59] setHidden:YES];
    [[_moreView viewWithTag:60] setHidden:YES];
    
    for (int i = 0; i < [nsOfferwall count]; i ++ ) {
        UIView* btnView = [nsOfferwall objectAtIndex:i];
        [btnView setHidden:NO];
        CGRect rect = btnView.frame;
        rect.origin.y = 47 + (60 * i);
        [btnView setFrame:rect];
    }
}
    
- (IBAction)onClickBack:(id)sender {
    if ( _moreView != nil ) {
        [_moreView setHidden:YES];
    }
}
    
- (IBAction)clickYoumi:(id)sender {
    if ( _alertView != nil ) {
        [_alertView hideAlertView];
    }
    
    [MobClick event:@"task_list_click_youmi" attributes:@{@"currentpage":@"任务列表"}];
    [YouMiWall showOffers:YES didShowBlock:^{
    }didDismissBlock:^{
    }];
}

- (IBAction) clickMore:(id)sender {
    [_moreView setHidden:NO];
}

- (IBAction)clickMobsmar:(id)sender {
    if ( _alertView != nil ) {
        [_alertView hideAlertView];
    }
    
    [MobClick event:@"task_list_click_mobsmar" attributes:@{@"currentpage":@"任务列表"}];
    [_siweWall showOfferWall:_viewController];//打开积分墙
}

- (IBAction)clickMopan:(id)sender {
    if ( _alertView != nil ) {
        [_alertView hideAlertView];
    }
    
    [MobClick event:@"task_list_click_mopan" attributes:@{@"currentpage":@"任务列表"}];
    
    _mopanAdWallControl.rootViewController = _viewController;
    [_mopanAdWallControl showAppOffers];
}

- (IBAction)clickPunchBox:(id)sender {
    if ( _alertView != nil ) {
        [_alertView hideAlertView];
    }
    
    [MobClick event:@"task_list_click_pubchbox" attributes:@{@"currentpage":@"任务列表"}];
    [PBOfferWall sharedOfferWall].orientationSupported = PBOrientationSupported_Vertical;
    [[PBOfferWall sharedOfferWall] showOfferWallWithScale:1.0f];
}

- (void)pbOfferWall:(PBOfferWall *)pbOfferWall finishTaskRewardCoin:(NSArray *)taskCoins {
    
}


// 积分墙加载完成
- (void)pbOfferWallDidLoadAd:(PBOfferWall *)pbOfferWall {
    
}

// 积分墙加载错误
- (void)pbOfferWall:(PBOfferWall *)pbOfferWall loadAdFailureWithError:(PBRequestError *)requestError {
    
}

// 积分墙打开完成
- (void)pbOfferWallDidPresentScreen:(PBOfferWall *)pbOfferWall {
    
}

// 积分墙将要关闭
- (void)pbOfferWallWillDismissScreen:(PBOfferWall *)pbOfferWall {
    
}

// 积分墙关闭完成
- (void)pbOfferWallDidDismissScreen:(PBOfferWall *)pbOfferWall {
    
}


- (IBAction)clickLimei:(id)sender {
    if ( _alertView != nil ) {
        [_alertView hideAlertView];
    }
    
    [MobClick event:@"task_list_click_limei" attributes:@{@"currentpage":@"任务列表"}];
    [self enterAdWall];
}

// 进入积分墙
-(void)enterAdWall{
    // 实例化 immobView 对象,在此处替换在力美广告平台申请到的广告位 ID;
    self.adView_adWall=[[immobView alloc] initWithAdUnitID:LIMEI_ID];
    //添加 immobView 的 Delegate;
    self.adView_adWall.delegate=self;

    //添加 userAccount 属性,此属性针对多账户应用所使用,用于区分不同账户下的积分(可选)。
    NSString* deviceId = [[LoginAndRegister sharedInstance] getDeviceId];
#if TEST == 1
    NSString* did = [[NSString alloc] initWithFormat:@"dev_%@", deviceId];
    [self.adView_adWall.UserAttribute setObject:did forKey:@"accountname"];
#else
    [self.adView_adWall.UserAttribute setObject:deviceId forKey:@"accountname"];
#endif
    
    [deviceId release];
    
    //开始加载广告。
    [self.adView_adWall immobViewRequest];
    
    UIView* view = _viewController.view;
    
    //将 immobView 添加到界面上。
    [view addSubview:adView_adWall];
    
    //将 immobView 添加到界面后,调用 immobViewDisplay。
    [self.adView_adWall immobViewDisplay];
}

-(void)QueryScore
{
    //TODO
}

// 设置必需的 UIViewController, 此方法的返回值如果为空,会导致广告展示不正常。
- (UIViewController *)immobViewController{
    return _viewController;
}

- (void) immobView: (immobView*) immobView didFailReceiveimmobViewWithError: (NSInteger) errorCode {
    
}

- (void) immobViewDidReceiveAd:(immobView*)immobView {
}

- (IBAction)clickDomob:(id)sender {
    if ( _alertView != nil ) {
        [_alertView hideAlertView];
    }
    
    [MobClick event:@"task_list_click_duomeng" attributes:@{@"currentpage":@"任务列表"}];
    [_offerWallController presentOfferWall];
}

- (IBAction)clickClose:(id)sender {
    if ( _alertView != nil ) {
        [_alertView hideAlertView];
    }
}

- (IBAction)clickHelper:(id)sender {
    if ( _alertView != nil ) {
        [_alertView hideAlertView];
    }
    
    BeeUIStack* stack = [BeeUIRouter sharedInstance].currentStack;
    
    NSString* url = [[[NSString alloc] initWithFormat:@"%@132", WEB_SERVICE_VIEW] autorelease];
    
    WebPageController* controller = [[[WebPageController alloc] init:@"重要提示"
                                                                 Url:url Stack:stack] autorelease];
    [stack pushViewController:controller animated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    UIView* longView = [[[UIView alloc] initWithFrame:CGRectMake(0, 50, 320, 0)] autorelease];
    longView.backgroundColor = RGB(35, 172, 229);
    [self.view insertSubview:longView belowSubview:self.tableView];
    [self.tableView setBackgroundColor:[UIColor clearColor]];
    self.headerBgLongView = longView;
    [self.tableView registerNib:[UINib nibWithNibName:@"OfferwallTableViewCell" bundle:nil] forCellReuseIdentifier:@"OfferwallTableViewCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"OfferwallTipTableViewCell" bundle:nil] forCellReuseIdentifier:@"OfferwallTipTableViewCell"];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    CGRect rect = self.view.frame;
    rect.origin = CGPointZero;
    rect.origin.y = 50;
    rect.size.height -= 50;
    self.tableView.frame = rect;
    [self.yueView setNum:[[LoginAndRegister sharedInstance] getBalance] withAnimation:NO];
    [self _generateDataArray];
    if (_needRefreshUI)
    {
        [self refreshUI];
    }
}

- (void)setNeedRefreshUI
{
    _needRefreshUI = YES;
}

- (void)refreshUI
{
    [self.tableView setContentOffset:CGPointZero animated:NO];
    [self.tableView reloadData];
    _needRefreshUI = NO;
}

- (void) dealloc {
    _offerWallController.delegate = nil;
    [_offerWallController release];
    _offerWallController = nil;
    
    if ( self->_alertView != nil ) {
        [self->_alertView release];
        self->_alertView = nil;
    }
    
    [PBOfferWall sharedOfferWall].delegate = nil;
    [[PBOfferWall sharedOfferWall] closeOfferWall];
    
    if (_tableViewDataDictArr)
    {
        [_tableViewDataDictArr release];
        _tableViewDataDictArr = nil;
    }
    
    self.headerBgLongView = nil;
    
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// 积分墙开始加载数据。
- (void)offerWallDidStartLoad {
    
}

// 积分墙加载完成。
- (void)offerWallDidFinishLoad {
    
}

// 积分墙加载失败。可能的原因由error部分提供,例如⺴⽹网络连接失败、被禁⽤用等。
- (void)offerWallDidFailLoadWithError:(NSError *)error {
    
}

// 积分墙页面被关闭。
// Offer wall closed.
- (void)offerWallDidClosed {
    
}

- (void)requestAndConsumePoint {
    if ( _request ) {
        return ;
    }
    
    _request = YES;
    
    // 查询自己的服务器来获取积分
    HttpRequest* request = [[HttpRequest alloc] init:self];
    
    NSMutableDictionary* dictionary = [[[NSMutableDictionary alloc] init] autorelease];
    
    [request request:HTTP_TASK_OFFERWALL Param:dictionary method:@"get"];
}


-(void) HttpRequestCompleted : (id) request HttpCode:(int)httpCode Body:(NSDictionary*) body {
    /*NSError* error;
    NSString* tmp = @"{\"offerwall_income\": 0, \"benefit\": 0, \"wangcai_income\": [{\"task_id\":10000,\"income\":300}], \"exp_next_level\": 2000, \"income\": 0, \"msg\": \"\", \"res\": 0, \"level\": 1, \"exp_current\": 0}";
    NSData* aData = [tmp dataUsingEncoding: NSASCIIStringEncoding];
    body = [NSJSONSerialization JSONObjectWithData:aData options:NSJSONReadingMutableLeaves error:&error];
    */
    if ( httpCode == 200 ) {
        int res = [[body objectForKey:@"res"] intValue];
        if ( res == 0 ) {
            int offerwallIncome = [[body valueForKey:@"offerwall_income"] intValue];
            
            int userLevel = [[body valueForKey:@"level"] intValue];
            int currentEXP = [[body valueForKey:@"exp_current"] intValue];
            int nextLevelEXP = [[body valueForKey:@"exp_next_level"] intValue];
            int benefit = [[body valueForKey:@"benefit"] intValue];

            int levelChange = 0;
            if (userLevel > 0)
            {
                int nLevel = [[LoginAndRegister sharedInstance] getUserLevel];
                if ( nLevel < userLevel ) {
                    // 等级变化
                    levelChange = 200;
                }
                [[LoginAndRegister sharedInstance] setUserLevel:userLevel];
                [[LoginAndRegister sharedInstance] setCurrentExp:currentEXP];
                [[LoginAndRegister sharedInstance] setNextLevelExp:nextLevelEXP];
                if (benefit > 0)
                {
                    [[LoginAndRegister sharedInstance] setBenefit:benefit];
                }
                [_baseTaskTableViewController updateLevel];
            }
            
            NSArray* wangcaiIncome = [body valueForKey:@"wangcai_income"];
            int nWangcaiIncome = 0; // 旺财任务获得的钱
            if ( wangcaiIncome != nil ) {
                for ( int i = 0; i < [wangcaiIncome count]; i ++ ) {
                    NSDictionary* item = [wangcaiIncome objectAtIndex:i];
                    
                    int taskId = [[item objectForKey:@"task_id"] intValue];
                    
                    if ( [self isUnfinished:taskId] ) {
                        nWangcaiIncome += [[item objectForKey:@"income"] intValue];
                    }
                }
            }
            
            if ( offerwallIncome > _offerwallIncome || nWangcaiIncome > 0 ) {
                int diff = offerwallIncome - _offerwallIncome;
                
                _offerwallIncome = offerwallIncome;
                [self->_delegate onRequestAndConsumePointCompleted:YES Consume:diff Level:levelChange wangcaiIncome:nWangcaiIncome];
            }

            _request = NO;
        } else {
            _request = NO;
        }
    } else {
        _request = NO;
    }
}

- (BOOL) isUnfinished:(int) taskId {
    NSArray* unfinished = [[CommonTaskList sharedInstance] getUnfinishedTaskList];
    for ( int i = 0; i < [unfinished count]; i ++ ) {
        CommonTaskInfo* obj = [unfinished objectAtIndex:i];
        if ( [obj.taskId intValue] == taskId ) {
            return YES;
        }
    }
    
    return NO;
}

- (IBAction)clickMiidi:(id)sender {
    if ( _alertView != nil ) {
        [_alertView hideAlertView];
    }
    
    [MiidiAdWall showAppOffers:_viewController withDelegate:self];
}

- (IBAction)clickJupeng:(id)sender {
    if ( _alertView != nil ) {
        [_alertView hideAlertView];
    }
    
    [JupengWall showOffers:_viewController didShowBlock:nil didDismissBlock:nil];
}

- (IBAction)clickDianru:(id)sender {
    if ( _alertView != nil ) {
        [_alertView hideAlertView];
    }
    
    [DianRuAdWall showAdWall:_viewController];
}

- (IBAction)clickAdwo:(id)sender {
    if ( _alertView != nil ) {
        [_alertView hideAlertView];
    }
    
    // 安沃
    AdwoOWPresentOfferWall(ADWO_OFFERWALL_BASIC_PID, _viewController);
}

- (NSString *)applicationKey {
    return @"00003215130000F0";
}

- (NSString*) dianruAdWallAppUserId {
    NSString* deviceId = [[LoginAndRegister sharedInstance] getDeviceId];
#if TEST == 1
    NSString* userid = [NSString stringWithFormat:@"dev_%@", deviceId];
#else
    NSString* userid = [NSString stringWithFormat:@"%@", deviceId];
#endif

    [deviceId release];
    
    return userid;
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
    int row = indexPath.row;
    if (row > 0)
    {
        int index = row - 1;
        NSString* type = _tableViewDataDictArr[index][@"type"];
        if ([type isEqualToString:@"punchbox"])
        {
            [self clickPunchBox:nil];
        }
        else if ([type isEqualToString:@"youmi"])
        {
            [self clickYoumi:nil];
        }
        else if ([type isEqualToString:@"domob"])
        {
            [self clickDomob:nil];
        }
        else if ([type isEqualToString:@"dianru"])
        {
            [self clickDianru:nil];
        }
    }
}

#pragma mark - <UITableViewDataSource>

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1+[_tableViewDataDictArr count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    int row = indexPath.row;
    UITableViewCell* retCell = nil;
    if (row == 0)
    {
        OfferwallTipTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"OfferwallTipTableViewCell" forIndexPath:indexPath];
        if (cell == nil)
        {
            cell = CREATE_NIBVIEW(@"OfferwallTipTableViewCell");
        }
        retCell = cell;
    }
    else
    {
        int index = row - 1;
        OfferwallTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"OfferwallTableViewCell" forIndexPath:indexPath];
        if (cell == nil)
        {
            cell = CREATE_NIBVIEW(@"OfferwallTableViewCell");
        }
        cell.iconImageView.image = [UIImage imageFromString:_tableViewDataDictArr[index][@"icon"]];
        cell.hotMarkImageView.hidden = YES;
        if ([_tableViewDataDictArr[index][@"ishot"] intValue])
        {
            cell.hotMarkImageView.hidden = NO;
        }
        cell.nameLabel.text = _tableViewDataDictArr[index][@"name"];
        retCell = cell;
    }
    
    return retCell;
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

@end

#endif
