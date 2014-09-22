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

#import "BusionessPageBoard_iPhone.h"
#import "CommonYuENumView.h"
#import "Config.h"
#import "LoginAndRegister.h"
#import "MobClick.h"
#import "Common.h"

#pragma mark -

@interface BusionessPageBoard_iPhone()
{
	//<#@private var#>
}
@end

@implementation BusionessPageBoard_iPhone

SUPPORT_AUTOMATIC_LAYOUT( YES )
SUPPORT_RESOURCE_LOADING( YES )

+ (void)load
{
	[[BeeUIRouter sharedInstance] map:@"busioness" toClass:self];
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
        NSString* device = [[[LoginAndRegister sharedInstance] getDeviceId] autorelease];
        NSString* sessionid = [[[LoginAndRegister sharedInstance] getSessionId] autorelease];
        NSString* userid = [[[LoginAndRegister sharedInstance] getUserId] autorelease];
        NSString* timestamp = [Common getTimestamp];
        
        NSString* url = [[[NSString alloc] initWithFormat:@"%@?device_id=%@&session_id=%@&userid=%@&timestamp=%@", WEB_EXCHANGE_INFO, device, sessionid, userid, timestamp] autorelease];
        
        //统计
        [MobClick event:@"click_trade_details" attributes:@{@"current_page":@"菜单"}];
        _webController = [[WebPageController alloc] init:@"交易详情" Url:url Stack:self.stack];
        
        [self.view addSubview:_webController.view];
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
    [self postNotification:@"showMenu"];
}

@end
