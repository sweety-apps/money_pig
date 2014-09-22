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

#import "InviteBoard_iPhone.h"
#import "AppBoard_iPhone.h"
#import "LoginAndRegister.h"
#import "Config.h"
#import "Common.h"

#pragma mark -

@implementation InviteBoard_iPhone

+ (void)load
{
	[[BeeUIRouter sharedInstance] map:@"invite" toClass:self];
    [[BeeUIRouter sharedInstance] map:@"invite_fill_code" toClass:self];
}

- (void)load
{
	[super load];
}

- (void)unload
{
    [_inviteController release];
    _inviteController = nil;
	[super unload];
}

#pragma mark Signal

ON_SIGNAL2( BeeUIBoard, signal )
{
	[super handleUISignal:signal];
	
	if ( [signal is:BeeUIBoard.CREATE_VIEWS] )
	{
        _inviteController = [[InviteController alloc] initWithNibName:@"InviteController" bundle:nil];
        [self.view addSubview:_inviteController.view];
        _inviteController._beeStack = self.stack;
        
        self.navigationController.navigationBarHidden = YES;
        
        //self.view.hintString = @"";
        //self.view.backgroundColor = [UIColor whiteColor];
    
        //[self setTitleString:@"我的旺财"];
        if ([[[self stack] name] isEqualToString:@"invite_fill_code"])
        {
            [_inviteController switchView:nil];
        }
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
