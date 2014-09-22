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
//  MyWangcaiBoard_iPhone.m
//  wangcai
//
//  Created by Lee Justin on 14-2-15.
//  Copyright (c) 2014年 1528studio. All rights reserved.
//

#import "MyWangcaiBoard_iPhone.h"

#pragma mark -

@interface MyWangcaiBoard_iPhone()
{
	//<#@private var#>
}
@end

@implementation MyWangcaiBoard_iPhone

+ (void)load
{
	[[BeeUIRouter sharedInstance] map:@"my_wangcai" toClass:self];
}

- (void)load
{
	[super load];
    
    _controller = [[MyWangcaiViewController alloc] initWithNibName:@"MyWangcaiViewController" bundle:nil];
    UIView* view = _controller.view;
    [self.view addSubview:view];
}

- (void)unload
{
    [_controller release];
	[super unload];
}

#pragma mark Signal

ON_SIGNAL2( BeeUIBoard, signal )
{
    [super handleUISignal:signal];

    if ( [signal is:BeeUIBoard.CREATE_VIEWS] )
    {
        self.view.hintString = @"This is the second board";
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
        [self hideNavigationBarAnimated:YES];
        [_controller setUIStack:self.stack];
        [_controller viewWillAppear:YES];
    }
    else if ( [signal is:BeeUIBoard.DID_APPEAR] )
    {
        [_controller viewDidAppear:YES];
    }
    else if ( [signal is:BeeUIBoard.WILL_DISAPPEAR] )
    {
        [_controller viewWillDisappear:YES];
    }
    else if ( [signal is:BeeUIBoard.DID_DISAPPEAR] )
    {
        [_controller viewDidDisappear:YES];
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

@end
