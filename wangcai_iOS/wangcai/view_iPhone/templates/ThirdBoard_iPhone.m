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

#import "ThirdBoard_iPhone.h"
#import "AppBoard_iPhone.h"

#pragma mark -

@implementation ThirdBoard_iPhone

+ (void)load
{
	[[BeeUIRouter sharedInstance] map:@"third" toClass:self];
}

- (void)load
{
	[super load];
    
    self->_settingController = [[SettingViewController alloc] init];
    UIView* view = _settingController.view;
    [self.view addSubview:view];
    
    //TaskController* _taskController = [[TaskController alloc]init:nil];
    
    //UIView* view = _taskController.view;
    //[self.view addSubview:view];
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
        self.view.hintString = @"This is the third board";
        self.view.backgroundColor = [UIColor whiteColor];
		
        [self showNavigationBarAnimated:NO];
        [self setTitleString:@"Third"];
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
        [self->_settingController setUIStack:self.stack];
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
