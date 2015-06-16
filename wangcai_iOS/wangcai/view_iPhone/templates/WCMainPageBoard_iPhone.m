//
//	 ______    ______    ______    
//	/\  __ \  /\  ___\  /\  ___\   
//	\ \  __<  \ \  __\_ \ \  __\_ 
//	 \ \_____\ \ \_____\ \ \_____\ 
//	  \/_____/  \/_____/  \/_____/ 
//
//	Powered by BeeFramework
//
//
//  WCMainPageBoard_iPhone.m
//  wangcai
//
//  Created by Lee Justin on 13-12-8.
//  Copyright (c) 2013年 1528studio. All rights reserved.
//

#import "WCMainPageBoard_iPhone.h"
#import "CommonYuENumView.h"
#import "UserInfoEditorViewController.h"
#import "AppBoard_iPhone.h"
#import "MobClick.h"
#import "SettingLocalRecords.h"
#import "MessageViewController.h"
#import "PrivacyPolicyView.h"
#import "UINavigationController+UIGestureRecognizerDelegate.h"


#pragma mark -

@interface WCMainPageBoard_iPhone() <BaseTaskTableViewControllerDelegate,PrivacyPolicyViewDelegate>
{
	//<#@private var#>
}
@end

@implementation WCMainPageBoard_iPhone

SUPPORT_AUTOMATIC_LAYOUT( YES )
SUPPORT_RESOURCE_LOADING( YES )

+ (void)load
{
	[[BeeUIRouter sharedInstance] map:@"wc_main" toClass:self];
}

- (void)load
{
	[super load];
}

- (void)unload
{
    [_taskTableViewController release];
	[super unload];
}

#pragma mark Signal

ON_SIGNAL2( BeeUIBoard, signal )
{
    [super handleUISignal:signal];

    if ( [signal is:BeeUIBoard.CREATE_VIEWS] )
    {
        [self observeNotification:@"naviToUserInfoEditor"];
        [self observeNotification:@"balanceChanged"];
        
        _alertView = nil;
        self.view.hintString = @"This is the  board";
        self.view.backgroundColor = [UIColor whiteColor];
        self.view.clipsToBounds = NO;
		
        [self hideNavigationBarAnimated:NO];
        //[self setTitleString:@"赚钱小猪"];
        
        //列表后面的白色背景
        UIView* listBgView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 1024)] autorelease];
        listBgView.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:listBgView];
        
        [[OnlineWallViewController sharedInstance] setViewController:self];
        
        //头部超出部分
        //UIImageView* testImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"testMain"]];
        UIImageView* headExtensionImageView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"head_extension_part"]] autorelease];
        CGRect headExtensionImageRect = headExtensionImageView.frame;
        headExtensionImageRect.origin.y -= headExtensionImageRect.size.height;
        headExtensionImageView.frame = headExtensionImageRect;
        [self.view addSubview:headExtensionImageView];
        
        CGRect rectFrame = CGRectZero;
        
        //头部导航栏
        UIView* headBgImageView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 50)] autorelease];
        headBgImageView.backgroundColor = [UIColor colorWithRed:0.117 green:0.212 blue:0.525 alpha:1.000];
        rectFrame = headBgImageView.frame;
        headBgImageView.frame = rectFrame;
        
        //免费购文字
        UILabel* label = [[[UILabel alloc] initWithFrame:CGRectMake(55, 0, 220, 50)] autorelease];
        label.textColor = [UIColor whiteColor];
        label.textAlignment = NSTextAlignmentCenter;
        label.backgroundColor = [UIColor clearColor];
        label.font = [UIFont fontWithName:@"STHeitiSC-Medium" size:18];
        label.text = @"免费购";
        
        [headBgImageView addSubview:label];
        
        [self.view addSubview:headBgImageView];
        
        //左上角小猪按钮
        _headLeftBtnImageView = [UIButton buttonWithType:UIButtonTypeCustom];
        UIImage* pigIconImg = [UIImage imageNamed:@"table_view_topleft_icon"];
        [_headLeftBtnImageView setBackgroundImage:pigIconImg forState:UIControlStateNormal];
        _headLeftBtnImageView.contentMode = UIViewContentModeScaleToFill;
        rectFrame = CGRectMake(0, 0, 100, 110);
        _headLeftBtnImageView.frame = rectFrame;
        [_headLeftBtnImageView addTarget:self action:@selector(onPressedPigIcon) forControlEvents:UIControlEventTouchUpInside];
        
        rectFrame = CGRectMake(0, 0, 100, 110);
        UIButton* headLeftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        headLeftBtn.backgroundColor = [UIColor clearColor];
        headLeftBtn.frame = rectFrame;
        [headLeftBtn addTarget:self action:@selector(onPressedLeftBackBtn:) forControlEvents:UIControlEventTouchUpInside];
        
        _headLeftBtnImageView.hidden = NO;
        _headLeftBtnImageView.alpha = 1;
        [self.view addSubview:_headLeftBtnImageView];
        //[self.view addSubview:headLeftBtn];
        
        //右上角按钮
        UIImageView* headRightBtnImageView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"msg_icon1"]] autorelease];
        rectFrame = headRightBtnImageView.frame;
        rectFrame.origin.x = 267;
        rectFrame.origin.y = 8;
        headRightBtnImageView.frame = rectFrame;
        _headRightBtnImageView = headRightBtnImageView;
        
        UIButton* headRightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        headRightBtn.backgroundColor = [UIColor clearColor];
        headRightBtn.frame = rectFrame;
        [headRightBtn addTarget:self action:@selector(onTouchDownRightBtn:) forControlEvents:UIControlEventTouchDown];
        [headRightBtn addTarget:self action:@selector(onTouchUpInsideRightBtn:) forControlEvents:UIControlEventTouchUpInside];
        [headRightBtn addTarget:self action:@selector(onTouchReleaseRightBtn:) forControlEvents:UIControlEventTouchUpOutside];
        [headRightBtn addTarget:self action:@selector(onTouchReleaseRightBtn:) forControlEvents:UIControlEventTouchCancel];
        
        
        //[self.view addSubview:headRightBtnImageView];
        //[self.view addSubview:headRightBtn];
        
        //判断是否是首次启动
        BOOL isFirst = [SettingLocalRecords isFirstRun];
        if ( isFirst ) {
            //[self showLeftAni:YES];
        }
        
        //列表
        BaseTaskTableViewController* taskTableViewController = [[BaseTaskTableViewController alloc] initWithNibName:@"BaseTaskTableViewController" bundle:nil];
        taskTableViewController.parentUIBoard = self;
        [self.view insertSubview:taskTableViewController.view belowSubview:headExtensionImageView];
        _taskTableViewController = taskTableViewController;
        
        _taskTableViewController.delegate = self;
        _taskTableViewController.view.frame = CGRectMake(0, headBgImageView.frame.size.height, self.view.frame.size.width, self.view.frame.size.height);
        _taskTableViewController.beeStack = self.stack;
        //_taskTableViewController.containTableView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - headBgImageView.frame.size.height);
        CGSize tableViewSize = [UIApplication sharedApplication].keyWindow.frame.size;
        _taskTableViewController.tableViewFrame = CGRectMake(0, 0, tableViewSize.width, tableViewSize.height - headBgImageView.frame.size.height);
        _taskTableViewController.containTableView.bounces = YES;
        
        [[OnlineWallViewController sharedInstance] setTaskTableViewController:_taskTableViewController];
        
        //开启侧滑Pop功能
        if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)])
        {
            self.navigationController.interactivePopGestureRecognizer.delegate = self.navigationController;
        }
        
        //[self.view addSubview:testImageView];
        
        //抗锯齿
        //self.view.layer.shouldRasterize = YES;
        //self.view.layer.edgeAntialiasingMask = kCALayerLeftEdge ;
        //self.view.layer.masksToBounds = YES;
                 
        // 亲友提示
#if TARGET_VERSION_LITE == 2
        //[self showFriendMsg];
#endif
    }
    else if ( [signal is:BeeUIBoard.DELETE_VIEWS] )
    {
        [self unobserveNotification:@"naviToUserInfoEditor"];
        [self unobserveNotification:@"balanceChanged"];
    }
    else if ( [signal is:BeeUIBoard.LAYOUT_VIEWS] )
    {
    }
    else if ( [signal is:BeeUIBoard.LOAD_DATAS] )
    {
    }
    else if ( [signal is:BeeUIBoard.FREE_DATAS] )
    {
    }
    else if ( [signal is:BeeUIBoard.WILL_APPEAR] )
    {
        [_taskTableViewController viewWillAppear:NO];
        
        [[UIApplication sharedApplication] setStatusBarHidden:YES];
        
        if (![SettingLocalRecords hasAgreedPrivacyPolicy])
        {
            PrivacyPolicyView* ppview = [PrivacyPolicyView privacyPolicyView];
            [ppview setShouldFinishReading:YES];
            ppview.delegate = self;
            [ppview showInWindow:NO];
        }
    }
    else if ( [signal is:BeeUIBoard.DID_APPEAR] )
    {
        self.view.clipsToBounds = NO;
        [self.view superview].clipsToBounds = NO;
        [[self.view superview] superview].clipsToBounds = NO;
        
        [_taskTableViewController viewDidAppear:NO];
        
        [[AppBoard_iPhone sharedInstance] setPanable:NO];
    }
    else if ( [signal is:BeeUIBoard.WILL_DISAPPEAR] )
    {
        [[AppBoard_iPhone sharedInstance] setPanable:NO];
        [_taskTableViewController viewWillDisappear:NO];
    }
    else if ( [signal is:BeeUIBoard.DID_DISAPPEAR] )
    {
        [_taskTableViewController viewDidDisappear:NO];
    }
}

ON_SIGNAL2( BeeUINavigationBar, signal )
{
	[super handleUISignal:signal];
	
	if ( [signal is:BeeUINavigationBar.LEFT_TOUCHED] )
	{
	}
	else if ( [signal is:BeeUINavigationBar.RIGHT_TOUCHED] )
	{
	}
}


-(void)onPressedLeftBackBtn:(id)sender
{
    //[self showLeftAni:NO];
    [self postNotification:@"showMenu"];
}

-(void)onTouchDownRightBtn:(id)sender
{
}

-(void)onTouchReleaseRightBtn:(id)sender
{
}

-(void)onTouchUpInsideRightBtn:(id)sender {
    MessageViewController* msgController = [[MessageViewController alloc] initWithNibName:nil bundle:nil];
    
    [msgController setUIStack:self.stack];
    [self.stack pushViewController:msgController animated:YES];
    
    [msgController release];
}

-(void)naviToUserInfoEditor
{
    UserInfoEditorViewController* userInfoCtrl = [[UserInfoEditorViewController alloc] initWithNibName:@"UserInfoEditorViewController" bundle:nil];
    if (self.stack == nil)
    {
        NSLog(@"靠！！！stack空的");
    }
    [self.stack pushViewController:userInfoCtrl animated:NO];
}

-(void)naviToExchangeController
{
    [MobClick event:@"click_buy_item" attributes:@{@"currentpage":@"任务列表"}];
    [[BeeUIRouter sharedInstance] open:@"first" animated:YES];
}

#pragma mark Notification

ON_NOTIFICATION( notification )
{
	if ([notification.name isEqualToString:@"naviToUserInfoEditor"])
    {
        [self naviToUserInfoEditor];
    }
    else if ([notification.name isEqualToString:@"balanceChanged"])
    {
        //[_taskTableViewController ]
    }
}

- (void) showFriendMsg {
    if ( _alertView != nil ) {
        [_alertView release];
    }
    
    UIView* view = [[[[NSBundle mainBundle] loadNibNamed:@"StartupController" owner:self options:nil] lastObject] autorelease];
    view.layer.masksToBounds = YES;
    view.layer.cornerRadius = 10.0;
    view.layer.borderWidth = 0.0;
    view.layer.borderColor = [[UIColor whiteColor] CGColor];
    
    UIColor *color = [UIColor colorWithRed:179.0/255 green:179.0/255 blue:179.0/255 alpha:1];
    
    UIButton* btn = (UIButton*)[view viewWithTag:11];
    [btn setTitleColor:color forState:UIControlStateHighlighted];
    
    [btn.layer setBorderWidth:0.5];
    [btn.layer setBorderColor:[color CGColor]];
    
    [btn addTarget:self action:@selector(clickContinue:) forControlEvents:UIControlEventTouchUpInside];
    _alertView = [[UICustomAlertView alloc]init:view];
    
    [_alertView show];
}

- (IBAction)clickContinue:(id)sender {
    if ( _alertView != nil ) {
        [_alertView hideAlertView];
    }
}

- (void) showLeftAni:(BOOL) show {
}

- (void) onPressedPigIcon
{
    [_taskTableViewController onPressedArticle];
}

#pragma mark <BaseTaskTableViewControllerDelegate>

- (void)taskTableViewController:(BaseTaskTableViewController*)ctrl
            scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat scale = 1.0;
    
    CGRect rectFrame = CGRectMake(0, 0, 100, 110);
    CGFloat minScale = 50.f / 110.f;
    CGFloat maxScale = 2.5f;
    
    scale = (rectFrame.size.height - scrollView.contentOffset.y) / rectFrame.size.height;
    if (scale < minScale)
    {
        scale = minScale;
    }
    if (scale > maxScale)
    {
        scale = maxScale;
    }
    
    rectFrame.size.width *= scale;
    rectFrame.size.height *= scale;
    _headLeftBtnImageView.frame = rectFrame;
    //_headLeftBtnImageView.alpha = scale;
    
}

#pragma mark <PrivacyPolicyViewDelegate>

- (void) privacyPolicyViewHasDismissedWithAgreed:(PrivacyPolicyView*)view
{
    [SettingLocalRecords setAgreedPrivacyPolicy:YES];
}

@end
