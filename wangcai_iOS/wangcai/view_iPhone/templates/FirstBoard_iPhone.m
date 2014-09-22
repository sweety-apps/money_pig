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
//  FirstBoard_iPhone.m
//  wangcai
//
//  Created by Lee Justin on 13-12-8.
//  Copyright (c) 2013年 1528studio. All rights reserved.
//

#import "FirstBoard_iPhone.h"
#import "AppBoard_iPhone.h"
#import "PhoneValidationController.h"
#import "InviteController.h"
#import "MobClick.h"

#pragma mark -

@implementation FirstBoard_iPhone

SUPPORT_AUTOMATIC_LAYOUT( YES );
SUPPORT_RESOURCE_LOADING( YES );

+ (void)load
{
	[[BeeUIRouter sharedInstance] map:@"first" toClass:self];
}

- (void)load
{
	[super load];
    
    self->_exchangeController = [[ExchangeController alloc] init];
    
    UIView* view = self->_exchangeController.view;
    [self.view addSubview:view];
}

- (void)unload
{
    [self->_exchangeController release];
	[super unload];
}

#pragma mark Signal

ON_SIGNAL2( BeeUIBoard, signal )
{
	[super handleUISignal:signal];
	
	if ( [signal is:BeeUIBoard.CREATE_VIEWS] )
	{
        self.view.hintString = @"";
        self.view.backgroundColor = [UIColor whiteColor];

        [self showNavigationBarAnimated:NO];
        [self setTitleString:@"我的旺财"];
	}
	else if ( [signal is:BeeUIBoard.DELETE_VIEWS] )
	{
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
        [self->_exchangeController setUIStack:self.stack];
        [self hideNavigationBarAnimated:YES];
    }
    else if ( [signal is:BeeUIBoard.DID_APPEAR] )
    {
        [self hideNavigationBarAnimated:NO];
    }
    else if ( [signal is:BeeUIBoard.WILL_DISAPPEAR] )
    {
    }
    else if ( [signal is:BeeUIBoard.DID_DISAPPEAR] )
    {
    }
}

ON_SIGNAL3( BeeUINavigationBar, LEFT_TOUCHED, signal )
{
	[super handleUISignal:signal];
}


ON_SIGNAL3( BeeUINavigationBar, RIGHT_TOUCHED, signal )
{
	[super handleUISignal:signal];
}

#pragma mark Notification

ON_NOTIFICATION( notification )
{
	
}

#pragma mark Message

ON_MESSAGE( message )
{
	
}

ON_SIGNAL3( FirstBoard_iPhone, test, signal )
{
    // 绑定手机
    [MobClick event:@"click_bind_phone" attributes:@{@"currentpage":@"test"}];
    
    PhoneValidationController* phoneVal = [PhoneValidationController shareInstance];
    
    [self.stack pushViewController:phoneVal animated:YES];
}

@end
