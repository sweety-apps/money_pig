//
//  InviterUpdate.m
//  wangcai
//
//  Created by Song on 13-12-29.
//  Copyright (c) 2013年 1528studio. All rights reserved.
//

#import "InviterUpdate.h"
#import "Config.h"
#import "LoginAndRegister.h";

@implementation InviterUpdate 

-(id) init {
    self = [super init];
    if ( self != nil ) {
    }
    return self;
}

- (void)updateInviter:(NSString *)inviter delegate:(id)del
{
    if (del != nil)
    {
        if (_updateDelegate != nil)
        {
            [_updateDelegate release];
        }
        
        _updateDelegate = [del retain];
    }
    
    HttpRequest* request = [[HttpRequest alloc] init: self];
    
    NSMutableDictionary* dictionary = [[NSMutableDictionary alloc] init];
    
    [dictionary setObject: inviter forKey: @"inviter"];
    
    [request request: HTTP_UPDATE_INVITER Param: dictionary];
    
    [dictionary release];
}

- (void)HttpRequestCompleted:(id)request HttpCode:(int)httpCode Body:(NSDictionary *)body
{
    [self updateInviterHandleRequest: httpCode Body: body];
}

- (void)updateInviterHandleRequest: (int)httpCode Body: (NSDictionary *)body
{
    if (httpCode == 200)
    {
        NSNumber* res = [body valueForKey: @"res"];
        int nRes = [res intValue];
        if (nRes == 0)
        {
            [_updateDelegate updateInviterCompleted: YES errMsg: nil];
        }
        else
        {
            NSString* msg = [[body valueForKey: @"msg"] copy];
            
            [_updateDelegate updateInviterCompleted: NO errMsg: msg];
            
            [msg release];
        }
    }
    else
    {
        [_updateDelegate updateInviterCompleted: NO errMsg: @"访问服务器错误"];
    }
}

- (void)dealloc
{
    [super dealloc];
}

@end
