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

#import "ServiceBoard_iPhone.h"
#import "AppBoard_iPhone.h"
#import "LoginAndRegister.h"
#import "Config.h"
#import "Common.h"

#pragma mark -

@implementation ServiceBoard_iPhone

+ (void)load
{
	[[BeeUIRouter sharedInstance] map:@"service" toClass:self];
}

- (void)load
{
	[super load];
}

- (void)unload
{
	[super unload];
}

#pragma mark Signal

ON_SIGNAL2( BeeUIBoard, signal )
{
	[super handleUISignal:signal];
	
	if ( [signal is:BeeUIBoard.CREATE_VIEWS] )
	{
        NSString* num = [[LoginAndRegister sharedInstance] getPhoneNum];
        if ( num == nil ) {
            num = @"";
        }

        _webPageController = [[WebPageController alloc] init:@"常见问题" Url:HTTP_SERVICE_QUESTION Stack:self.stack];
        
        [self.view addSubview:_webPageController.view];
        
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
    }
    else if ( [signal is:BeeUIBoard.DID_APPEAR] )
    {
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

@end
