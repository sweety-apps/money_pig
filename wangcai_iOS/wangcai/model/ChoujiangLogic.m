//
//  ChoujiangLogic.m
//  wangcai
//
//  Created by Lee Justin on 14-1-4.
//  Copyright (c) 2014年 1528studio. All rights reserved.
//

#import "ChoujiangLogic.h"
#import "Config.h"
#import "SettingLocalRecords.h"

@implementation ChoujiangLogic

DEF_SINGLETON( ChoujiangLogic )

- (id)init
{
    self = [super init];
    if (self) {
        if ([SettingLocalRecords getCheckIn])
        {
            _awardCode = kGetAwardTypeAlreadyGot;
        }
        else
        {
            _awardCode = kGetAwardTypeNotGet;
        }
    }
    return self;
}

- (void)dealloc
{
    [super dealloc];
}

- (GetAwardType)getAwardCode
{
/*
#if TEST == 1 
    return kGetAwardTypeNotGet;
#endif
*/
    if (![SettingLocalRecords getCheckIn])
    {
        _awardCode = kGetAwardTypeNotGet;
    }
    return _awardCode;
}

- (void)requestChoujiang:(id<ChoujiangLogicDelegate>)delegate
{
    HttpRequest* req = [[HttpRequest alloc] init:self];
    req.extensionContext = delegate;
    
    NSMutableDictionary* dictionary = [[[NSMutableDictionary alloc] init] autorelease];
    
    [req request:HTTP_TAKE_AWARD Param:dictionary method:@"post"];
}

#pragma mark <HttpRequestDelegate>

-(void) HttpRequestCompleted : (id) request HttpCode:(int)httpCode Body:(NSDictionary*) body {
    id<ChoujiangLogicDelegate> delegate = ((HttpRequest*)request).extensionContext;
    
    NSNumber* result = [NSNumber numberWithInt:-1];
    NSString* msg = @"";
    //_awardCode = kGetAwardTypeRequestFailed;
    BOOL succeed = NO;
    
    if (httpCode == 200)
    {
        result = [body objectForKey:@"res"];
        msg = [body objectForKey:@"msg"];
        if ([result intValue] != 0)
        {
            _awardCode = kGetAwardTypeAlreadyGot;
            [SettingLocalRecords setCheckIn:YES];
        }
        else if ([result integerValue] == 0)
        {
            NSNumber* awardCodeNum = [body objectForKey:@"award"];
            if (awardCodeNum)
            {
                _awardCode = [awardCodeNum integerValue];
                //if ([[LoginAndRegister sharedInstance] getUserLevel] < 5)
                //{
                    [SettingLocalRecords setCheckIn:YES];
                //}
            }
        }
        succeed = YES;
    }
    
    if (delegate)
    {
        [delegate onFinishedChoujiangRequest:self isRequestSucceed:succeed awardCode:_awardCode resultCode:[result integerValue] msg:msg];
    }
}

@end
