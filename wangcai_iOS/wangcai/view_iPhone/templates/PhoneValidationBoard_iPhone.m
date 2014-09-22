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
//  ThirdBoard_iPhone.m
//  wangcai
//
//  Created by Lee Justin on 13-12-8.
//  Copyright (c) 2013年 1528studio. All rights reserved.
//

#import "PhoneValidationBoard_iPhone.h"
#import "AppBoard_iPhone.h"
#import "LoginAndRegister.h"
#import "Config.h"
#import "Common.h"
#import "MobClick.h"

#pragma mark -

@implementation PhoneValidationBoard_iPhone

+ (void)load
{
	[[BeeUIRouter sharedInstance] map:@"phone_validation" toClass:self];
}

- (void)load
{
	[super load];
}

- (void)unload
{
    [_phoneController release];
    _phoneController = nil;
	[super unload];
}

#pragma mark Signal

ON_SIGNAL2( BeeUIBoard, signal )
{
	[super handleUISignal:signal];
	
	if ( [signal is:BeeUIBoard.CREATE_VIEWS] )
	{
        // 绑定手机
        [MobClick event:@"click_bind_phone" attributes:@{@"currentpage":@"菜单"}];
        
        _phoneController = [PhoneValidationController shareInstance];
        [_phoneController setBackType:YES];
        
        [self.view addSubview:_phoneController.view];

        self.navigationController.navigationBarHidden = YES;
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
        [_phoneController attachEvent];
    }
    else if ( [signal is:BeeUIBoard.DID_APPEAR] )
    {
    }
    else if ( [signal is:BeeUIBoard.WILL_DISAPPEAR] )
    {
        [_phoneController detachEvent];
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

@end
