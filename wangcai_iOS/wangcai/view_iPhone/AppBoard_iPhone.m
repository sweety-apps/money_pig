//
//  AppBoard_iPhone.m
//  wangcai
//
//  Created by Lee Justin on 13-12-8.
//  Copyright (c) 2013年 1528studio. All rights reserved.
//

#import "AppBoard_iPhone.h"
#import "MenuBoard_iPhone.h"
#import "LoginAndRegister.h"
#import "PhoneValidationController.h"
#import "OnlineWallViewController.h"
#import "MobClick.h"
#import "WebPageController.h"

#define SHOW_MASK (0)

#pragma mark -

#undef	MENU_BOUNDS
#define	MENU_BOUNDS	(210.0f)
#undef	MASK_LEFT_X
#define	MASK_LEFT_X	(160.0f)
#undef MENU_TRIGER_BOUNDS
#define	MENU_TRIGER_BOUNDS	(100.0f)

#undef ROTATE_PAN_MENU
#define ROTATE_PAN_MENU 0

#pragma mark -

@implementation AppBoard_iPhone
{
	BeeUIButton *	_mask;
	CGRect			_origFrame;
    BOOL            _hasPanOpened;
}

DEF_SINGLETON( AppBoard_iPhone )

+ (void)load
{
}

- (void)load
{
	[super load];
    _alertView = nil;
    _remoteNotificationTitle = nil;
    _remoteNotificationUrl = nil;
    
    float fl = [UIScreen mainScreen].scale;
    
    if ( [[LoginAndRegister sharedInstance] isInReview] ) {
        _adView = [[YouMiView alloc] initWithContentSizeIdentifier:YouMiBannerContentSizeIdentifier320x50 delegate:nil];
        _adView.indicateTranslucency = YES;
        _adView.indicateRounded = NO;
        [_adView start];
    } else {
        _adView = nil;
    }
}

- (void)unload
{
    if ( _alertView != nil ) {
        [_alertView release];
    }
	[super unload];
}

#pragma mark Signal

ON_SIGNAL2( BeeUIBoard, signal )
{
	[super handleUISignal:signal];
	
	if ( [signal is:BeeUIBoard.CREATE_VIEWS] )
	{
        [self observeNotification:@"showMenu"];
        
        self.view.backgroundColor = [UIColor whiteColor];

		MenuBoard_iPhone * menu = [MenuBoard_iPhone sharedInstance];
		menu.parentBoard = self;

		[self.view addSubview:menu.view];
        
		BeeUIRouter * router = [BeeUIRouter sharedInstance];
		router.parentBoard = self;
		[self.view addSubview:router.view];

		_mask = [BeeUIButton new];
        if (SHOW_MASK)
        {
            _mask.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6f];
        }
        else
        {
            _mask.backgroundColor = [UIColor clearColor];
        }
		_mask.hidden = YES;
		_mask.signal = @"mask";
        _mask.alpha = 1.0;
		[self.view addSubview:_mask];
        
		[menu selectItem:@"wc_main" animated:NO];
        _hasPanOpened = NO;
        
		[router open:@"wc_main"];
        
        if ( _adView != nil ) {
            CGRect rect = _adView.frame;
            rect.size.height = 50;
            rect.size.width = 320;
            rect.origin.x = 0;
            rect.origin.y = [[UIScreen mainScreen] bounds].size.height - 50;
            
            UIView* view = [[UIView alloc] initWithFrame:rect];
            [view addSubview:_adView];
            [self.view addSubview:view];
        }
        //[self _preOpenBoards:router];
	}
	else if ( [signal is:BeeUIBoard.DELETE_VIEWS] )
	{
        [self unobserveNotification:@"showMenu"];
		SAFE_RELEASE_SUBVIEW( _mask );
	}
	else if ( [signal is:BeeUIBoard.LAYOUT_VIEWS] )
	{
	}
	else if ( [signal is:BeeUIBoard.LAYOUT_VIEWS] )
	{
	}
	else if ( [signal is:BeeUIBoard.WILL_APPEAR] )
	{
	}
	else if ( [signal is:BeeUIBoard.DID_APPEAR] )
	{
		//[BeeUIRouter sharedInstance].view.pannable = YES;
        //_mask.pannable = YES;
        if ( _origFrame.size.height == 0 && _origFrame.size.width == 0 ) {
            _origFrame = [BeeUIRouter sharedInstance].view.frame;
        }
        
        if ( _remoteNotificationTitle != nil ) {
            BeeUIStack* stack = [BeeUIRouter sharedInstance].currentStack;
            
            WebPageController* controller = [[[WebPageController alloc] init:_remoteNotificationTitle
                                                                         Url:_remoteNotificationUrl Stack:stack] autorelease];
            [stack pushViewController:controller animated:YES];
            
            [_remoteNotificationTitle release];
            _remoteNotificationTitle = nil;
            [_remoteNotificationUrl release];
            _remoteNotificationUrl = nil;
        }
	}
	else if ( [signal is:BeeUIBoard.WILL_DISAPPEAR] )
	{
		//[BeeUIRouter sharedInstance].view.pannable = NO;
        //_mask.pannable = NO;
	}
	else if ( [signal is:BeeUIBoard.DID_DISAPPEAR] )
	{
	}
}


- (void)setPanable:(BOOL)panable
{
    [BeeUIRouter sharedInstance].view.pannable = panable;
    _mask.pannable = panable;
}

ON_SIGNAL2( UIView, signal )
{
    if ( [signal is:UIView.PAN_START]  )
    {
        [self syncPanPosition];
    }
    else if ( [signal is:UIView.PAN_CHANGED]  )
    {
        [self syncPanPosition];
    }
    else if ( [signal is:UIView.PAN_STOP] || [signal is:UIView.PAN_CANCELLED] )
    {
        [self syncPanPosition];
		
		[UIView beginAnimations:nil context:nil];
		[UIView setAnimationBeginsFromCurrentState:YES];
		[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
		[UIView setAnimationDuration:0.3f];

		BeeUIRouter * router = [BeeUIRouter sharedInstance];
		
		if ( router.view.left <= MENU_TRIGER_BOUNDS )
		{
			router.view.left = 0;
			
            router.view.transform = CGAffineTransformIdentity;
			_mask.frame = CGRectMake( 0.0, 0.0, _origFrame.size.width, _origFrame.size.height );
            _mask.alpha = 1.0f;
            router.view.frame = _mask.frame;
			
			[UIView setAnimationDelegate:self];
			[UIView setAnimationDidStopSelector:@selector(didMenuHidden)];
		}
		else
		{
            router.view.transform = CGAffineTransformIdentity;
            
            CGFloat panOffsetX = MENU_BOUNDS;
            router.view.frame = CGRectOffset( _origFrame, panOffsetX, 0 );
            router.view.bounds = router.view.frame;
            CGRect currentBounds = router.view.bounds;
            router.view.center = CGPointMake(CGRectGetMidX(currentBounds), CGRectGetMidY(currentBounds));
            CGFloat boundsX = currentBounds.origin.x;
            if (boundsX < 0)
            {
                INFO(@"<WHY??>");
            }
            CGFloat angle = (boundsX * M_PI / 5120.f);
            if (ROTATE_PAN_MENU)
            {
                router.view.transform = CGAffineTransformMakeRotation(angle);
                INFO(@"<Angle Rotated> A = %f, Off = %f",angle,boundsX);
            }
            
            CGRect rectNewBounds = router.view.bounds;
            CGFloat offsetY = tan(0.5*angle) * boundsX;
            
            if (ROTATE_PAN_MENU)
            {
                rectNewBounds.origin.y = offsetY;
            }
            else
            {
                rectNewBounds.origin.y = 0;
            }
            
            router.view.frame = rectNewBounds;
            
			_mask.frame = CGRectMake( MASK_LEFT_X, 0.0, _origFrame.size.width - MASK_LEFT_X, _origFrame.size.height );
			_mask.alpha = 1.0f;
            
			[UIView setAnimationDelegate:self];
			[UIView setAnimationDidStopSelector:@selector(didMenuShown)];
		}
		
		[UIView commitAnimations];
    }
}

ON_SIGNAL2( mask, signal )
{
	[self hideMenu];
}

ON_SIGNAL3( BeeUIRouter, WILL_CHANGE, signal )
{
}

ON_SIGNAL3( BeeUIRouter, DID_CHANGED, signal )
{
	[[MenuBoard_iPhone sharedInstance] selectItem:[BeeUIRouter sharedInstance].currentStack.name animated:YES];
}

ON_SIGNAL3( MenuBoard_iPhone, first, signal )
{
    [self hideMenu];
    [MobClick event:@"click_buy_item" attributes:@{@"currentpage":@"菜单"}];
	[[BeeUIRouter sharedInstance] open:@"first" animated:YES];
}

ON_SIGNAL3( MenuBoard_iPhone, second, signal )
{
    [self hideMenu];
    [MobClick event:@"click_extract_money" attributes:@{@"current_page":@"菜单"}];
	[[BeeUIRouter sharedInstance] open:@"second" animated:YES];
}

ON_SIGNAL3( MenuBoard_iPhone, my_wangcai, signal )
{
    [self hideMenu];
    [MobClick event:@"click_extract_money" attributes:@{@"current_page":@"菜单"}];
	[[BeeUIRouter sharedInstance] open:@"my_wangcai" animated:YES];
}

ON_SIGNAL3( MenuBoard_iPhone, third, signal )
{
    [self hideMenu];
    [MobClick event:@"click_setting" attributes:@{@"current_page":@"菜单"}];
	[[BeeUIRouter sharedInstance] open:@"third" animated:YES];
}

ON_SIGNAL3( MenuBoard_iPhone, wc_main, signal )
{
    [self hideMenu];
    //static BOOL isFirstShow = YES;
	[[BeeUIRouter sharedInstance] open:@"wc_main" animated:YES];
    //if (!isFirstShow)
    //{
        [self postNotification:@"naviToUserInfoEditor"];
    //}
    //isFirstShow = NO;
	
	
}

- (void)onTouchedInvite:(BOOL)switchToFillInvitedCodeView
{
    // 判断是否绑定了手机
    NSString* phoneNum = [[LoginAndRegister sharedInstance] getPhoneNum];
    if ( phoneNum == nil || [phoneNum isEqualToString:@""] ) {
        if ( _alertView != nil ) {
            [_alertView release];
        }
        
        if ( phoneNum != nil ) {
            [phoneNum release];
        }
        
        _alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"尚未绑定手机，请先绑定手机" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"绑定手机", nil];
        [_alertView show];
    } else {
        [phoneNum release];
        [self hideMenu];
        
        if (!switchToFillInvitedCodeView)
        {
            [[BeeUIRouter sharedInstance] open:@"invite" animated:YES];
        }
        else
        {
            [[BeeUIRouter sharedInstance] open:@"invite_fill_code" animated:YES];
        }
        
    }
}

ON_SIGNAL3( MenuBoard_iPhone, invite, signal )
{
    [MobClick event:@"click_invite_redbag" attributes:@{@"current_page":@"菜单"}];
    [self onTouchedInvite:NO];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if ( [_alertView isEqual:alertView] ) {
        if ( buttonIndex == 1 ) {
            [self hideMenu];
            [[BeeUIRouter sharedInstance] open:@"phone_validation" animated:YES];
            
            
        }
    }
}

ON_SIGNAL3( MenuBoard_iPhone, service, signal)
{
    [self hideMenu];
    //统计
    [MobClick event:@"click_help" attributes:@{@"current_page":@"menu"}];
	[[BeeUIRouter sharedInstance] open:@"service" animated:YES];
	
}

ON_SIGNAL3( MenuBoard_iPhone, team, signal )
{
    [self hideMenu];
    [[BeeUIRouter sharedInstance] open:@"team" animated:YES];
	
}

ON_SIGNAL3( MenuBoard_iPhone, busioness, signal )
{
    [self hideMenu];
	[[BeeUIRouter sharedInstance] open:@"busioness" animated:YES];
	
}

- (void)didMenuHidden
{
	_mask.hidden = YES;
    _hasPanOpened = NO;
}

- (void)didMenuShown
{
	BeeUIRouter * router = [BeeUIRouter sharedInstance];

	_mask.frame = CGRectMake( MASK_LEFT_X, 0.0, router.width - MASK_LEFT_X, router.height );
	_mask.hidden = NO;
    _hasPanOpened = YES;
}

- (void)syncPanPosition
{
	BeeUIRouter * router = [BeeUIRouter sharedInstance];
    
    router.view.transform = CGAffineTransformIdentity;
	CGFloat panOffsetX = router.view.panOffset.x;
    if (_hasPanOpened)
    {
        panOffsetX = MENU_BOUNDS + _mask.panOffset.x;
        if((MENU_BOUNDS + panOffsetX) < 0.f)
        {
            panOffsetX = 0.f;
        }
    }
    else
    {
        panOffsetX = router.view.panOffset.x;
        if((_origFrame.origin.x + panOffsetX) < 0.f)
        {
            panOffsetX = 0.f;
        }
    }
    [self syncPanPositionWithOffsetX:panOffsetX];
}

- (void)syncPanPositionWithOffsetX:(CGFloat)panOffsetX
{
	BeeUIRouter * router = [BeeUIRouter sharedInstance];
    router.view.transform = CGAffineTransformIdentity;
    
    router.view.frame = CGRectOffset( _origFrame, panOffsetX, 0 );
    router.view.bounds = router.view.frame;
    CGRect currentBounds = router.view.bounds;
    router.view.center = CGPointMake(CGRectGetMidX(currentBounds), CGRectGetMidY(currentBounds));
    CGFloat boundsX = currentBounds.origin.x;
    if (boundsX < 0)
    {
        INFO(@"<WHY??>");
    }
    CGFloat angle = (boundsX * M_PI / 5120.f);
    if (ROTATE_PAN_MENU)
    {
        router.view.transform = CGAffineTransformMakeRotation(angle);
        INFO(@"<Angle Rotated> A = %f, Off = %f",angle,boundsX);
    }
    
    CGRect rectNewBounds = router.view.bounds;
    CGFloat offsetY = tan(0.5*angle) * boundsX;
    if (ROTATE_PAN_MENU)
    {
        rectNewBounds.origin.y = offsetY;
    }
    else
    {
        rectNewBounds.origin.y = 0;
    }
    router.view.frame = rectNewBounds;
    
	if ( router.view.left <= 0.0f )
	{
		_mask.hidden = YES;
		_mask.alpha = 0.0f;
	}
	else if ( router.view.left >= MENU_BOUNDS )
	{
		_mask.hidden = NO;
		_mask.alpha = 1.0f;
	}
	else
	{
		_mask.hidden = NO;
        _mask.alpha = 1.0f - (MENU_BOUNDS - router.view.left) / MENU_BOUNDS;
	}
    
	_mask.frame = CGRectMake( router.view.left, 0.0, router.width, router.height );
}

- (void)showMenu
{
	//BeeUIRouter * router = [BeeUIRouter sharedInstance];

	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationBeginsFromCurrentState:YES];
	[UIView setAnimationDuration:0.3f];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(didMenuShown)];

    [self syncPanPositionWithOffsetX:MENU_BOUNDS];
	
	[UIView commitAnimations];
}

- (void)hideMenu
{
	BeeUIRouter * router = [BeeUIRouter sharedInstance];

	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationBeginsFromCurrentState:YES];
	[UIView setAnimationDuration:0.3f];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(didMenuHidden)];
	
    router.view.transform = CGAffineTransformIdentity;
	router.view.frame = CGRectMake( 0.0, 0.0, router.width, router.height );
	
	_mask.frame = CGRectMake( 0.0, 0.0, router.width, router.height );
	_mask.alpha = 0.0f;
	
	[UIView commitAnimations];
}

#pragma mark Notification

ON_NOTIFICATION( notification )
{
	if ([notification.name isEqualToString:@"showMenu"])
    {
        [self showMenu];
    }
}

#pragma mark Message

ON_MESSAGE( message )
{
	
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

- (void) openUrlFromRomoteNotification : (NSString*) title Url:(NSString*) url {
    _remoteNotificationTitle = [title copy];
    _remoteNotificationUrl = [url copy];
}

@end
