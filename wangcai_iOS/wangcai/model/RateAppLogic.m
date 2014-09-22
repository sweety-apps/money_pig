//
//  RateAppLogic.m
//  wangcai
//
//  Created by Lee Justin on 14-1-15.
//  Copyright (c) 2014年 1528studio. All rights reserved.
//

#import "RateAppLogic.h"
#import "HttpRequest.h"
#import "Config.h"
#import "SettingLocalRecords.h"

@interface RateAppLogicContext : NSObject

@property (nonatomic,retain) id<RateAppLogicDelegate> delegate;

@end

@implementation RateAppLogicContext

@synthesize delegate;

- (void)dealloc
{
    self.delegate = nil;
    [super dealloc];
}

@end


static RateAppLogic* gInstance = nil;

@implementation RateAppLogic

+ (RateAppLogic*)sharedInstance
{
    if (gInstance == nil)
    {
        gInstance = [[RateAppLogic alloc] init];
    }
    return gInstance;
}

- (void)requestRated:(id<RateAppLogicDelegate>)delegate
{
    HttpRequest* req = [[HttpRequest alloc] init:self];
    RateAppLogicContext* context = [[[RateAppLogicContext alloc] init]autorelease];
    context.delegate = delegate;
    req.extensionContext = context;
    
    NSMutableDictionary* dictionary = [[[NSMutableDictionary alloc] init] autorelease];
    
    [req request:HTTP_TASK_COMMENT Param:dictionary method:@"post"];
}

- (BOOL)isRated
{
    return [SettingLocalRecords getRatedApp];
}

#pragma mark <HttpRequestDelegate>

-(void) HttpRequestCompleted : (id) request HttpCode:(int)httpCode Body:(NSDictionary*) body {
    RateAppLogicContext* context = ((HttpRequest*)request).extensionContext;
    id<RateAppLogicDelegate> delegate = context.delegate;
    
    BOOL succeed = NO;
    NSInteger income = 0;
    NSInteger res = -1;
    NSString* msg = @"";
    
    if (httpCode == 200)
    {
        NSNumber* result = [body objectForKey:@"res"];
        msg = [body objectForKey:@"msg"];
        succeed = YES;
        [SettingLocalRecords setRatedApp:YES];
        if ([result intValue] == 0)
        {
            NSNumber* incomeInt = [body objectForKey:@"income"];
            income = [incomeInt intValue];
        }
        else
        {
        }
    }
    
    [delegate onRateAppLogicFinished:self isRequestSucceed:succeed income:income resultCode:res msg:msg];
}

@end
