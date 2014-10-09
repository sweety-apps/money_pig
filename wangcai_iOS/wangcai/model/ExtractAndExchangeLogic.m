//
//  ExtractAndExchangeLogic.m
//  wangcai
//
//  Created by Lee Justin on 14-10-8.
//  Copyright (c) 2014年 1528studio. All rights reserved.
//

#import "ExtractAndExchangeLogic.h"
#import "Config.h"
#import "SettingLocalRecords.h"
#import "HttpRequest.h"
#import "Common.h"
#import "LoginAndRegister.h"

#pragma mark - BillingHistoryRecord

@implementation ExtractAndExchangeListItem

@synthesize type;
@synthesize name;
@synthesize desString;
@synthesize iconUrl;
@synthesize price;
@synthesize remain;

+ (ExtractAndExchangeListItem*) itemWithDict:(NSDictionary*)dict
{
    ExtractAndExchangeListItem* rcd = [[[ExtractAndExchangeListItem alloc] init] autorelease];
    rcd.type = [dict[@"type"] intValue];
    rcd.name = dict[@"name"];
    rcd.desString = dict[@"description"];
    rcd.iconUrl = dict[@"icon"];
    rcd.price = dict[@"price"];
    rcd.remain = dict[@"remain"];
    rcd.is_most_cheap = dict[@"is_most_cheap"];
    rcd.succeedTip = dict[@"succeed_tip"];
    
    return rcd;
}

- (void)dealloc
{
    self.name = nil;
    self.desString = nil;
    self.iconUrl = nil;
    self.price = nil;
    self.remain = nil;
    self.is_most_cheap = nil;
    self.succeedTip = nil;
    
    [super dealloc];
}

@end


#pragma mark - ExtractAndExchangeLogic

@interface ExtractAndExchangeLogic ()
{
    NSInteger _lastReqCount;
    NSInteger _lastReqOffset;
}

@end


@implementation ExtractAndExchangeLogic

DEF_SINGLETON(ExtractAndExchangeLogic)

#pragma mark

- (instancetype)init
{
    self = [super init];
    if (self) {
        _allItems = [[NSMutableArray array] retain];
    }
    return self;
}

- (void)dealloc
{
    [_allItems release];
    [super dealloc];
}

#pragma mark

- (void) requestExtractAndExchangeList:(id<ExtractAndExchangeLogicDelegate>)delegate
{
    HttpRequest* req = [[HttpRequest alloc] init:self];
    req.extensionContext = delegate;
    NSMutableDictionary* dictionary = [[[NSMutableDictionary alloc] init] autorelease];
    NSString* timestamp = [Common getTimestamp];
    [dictionary setObject:timestamp forKey:@"stamp"];
    NSDictionary* dic = [[NSBundle mainBundle] infoDictionary];
    NSString* appVersion = [dic valueForKey:@"CFBundleVersion"];
    [dictionary setObject:appVersion forKey:@"ver"];
    [dictionary setObject:APP_NAME forKey:@"app"];
    
    [req request:HTTP_EXCHANGE_LIST Param:dictionary method:@"get"];
}

- (void) requestExchangeCode:(ExtractAndExchangeType)type
                       price:(NSNumber*)price
                withDelegate:(id<ExtractAndExchangeLogicDelegate>)delegate
{
    HttpRequest* req = [[HttpRequest alloc] init:self];
    req.extensionContext = @{@"price":price,@"delegate":delegate,@"type":[NSNumber numberWithUnsignedInt:type]};
    NSMutableDictionary* dictionary = [[[NSMutableDictionary alloc] init] autorelease];
    [dictionary setObject:[NSNumber numberWithUnsignedInt:type] forKey:@"exchange_type"];
    
    [req request:HTTP_EXCHANGE_CODE Param:dictionary];
}

- (NSArray*) getExtractAndExchangeList
{
    return _allItems;
}

#pragma mark <HttpRequestDelegate>

-(void) HttpRequestCompleted : (id) request HttpCode:(int)httpCode Body:(NSDictionary*) body
{
    HttpRequest* req = (HttpRequest*)request;
    if ([[[req getBeeHttpRequest].url absoluteString] rangeOfString:HTTP_EXCHANGE_LIST].length > 0)
    {
        [self onGetListCompleted:request
                        HttpCode:httpCode
                            Body:body];
    }
    else if ([[[req getBeeHttpRequest].url absoluteString] rangeOfString:HTTP_EXCHANGE_CODE].length > 0)
    {
        [self onExchangeCompleted:request HttpCode:httpCode Body:body];
    }
}

- (void) onGetListCompleted: (id) request HttpCode:(int)httpCode Body:(NSDictionary*) body
{
    HttpRequest* req = (HttpRequest*)request;
    id<ExtractAndExchangeLogicDelegate> delegate = req.extensionContext;
    
    NSNumber* result = [NSNumber numberWithInt:-1];
    NSString* msg = @"";
    BOOL succeed = NO;
    
    if (httpCode == 200)
    {
        // 获取到返回的列表
        result = [body objectForKey:@"res"];
        msg = [body objectForKey:@"msg"];
        int nRes = [result intValue];
        if (nRes == 0) {
            NSArray* list = [body valueForKey: @"exchange_list"];
            [_allItems removeAllObjects];
            for (NSDictionary* dict in list)
            {
                ExtractAndExchangeListItem* item = [ExtractAndExchangeListItem itemWithDict:dict];
                [_allItems addObject:item];
            }
        }
        succeed = YES;
    }
    
    if (delegate)
    {
        [delegate onFinishedRequestExtractAndExchangeList:self
                                                isSucceed:succeed
                                                   errMsg:msg];
    }
}

- (void) onExchangeCompleted: (id) request HttpCode:(int)httpCode Body:(NSDictionary*) body
{
    HttpRequest* req = (HttpRequest*)request;
    NSDictionary* paramDict = req.extensionContext;
    NSNumber* price = paramDict[@"price"];
    id<ExtractAndExchangeLogicDelegate> delegate = paramDict[@"delegate"];
    ExtractAndExchangeType type = [((NSNumber*)paramDict[@"type"]) unsignedIntegerValue];
    
    NSNumber* result = [NSNumber numberWithInt:-1];
    NSString* msg = @"网络不通，请检查网络";
    BOOL succeed = NO;
    
    if (httpCode == 200)
    {
        result = [body objectForKey:@"res"];
        msg = [body objectForKey:@"msg"];
        int nRes = [result intValue];
        if (nRes == 0) {
            NSString* exchange_code = [body valueForKey: @"order_id"];
            [[LoginAndRegister sharedInstance] increaseBalance:(-1*[price doubleValue])];
            
            [self _reduceRemainCount:type];
            
            succeed = YES;
        }
    }
    
    if (delegate)
    {
        [delegate onFinishedRequestExtractAndExchangeList:self
                                                isSucceed:succeed
                                                   errMsg:msg];
    }
    
    
}

-(void) _reduceRemainCount:(int) type {
    for (ExtractAndExchangeListItem* item in _allItems)
    {
        if ( item.type == type )
        {
            item.remain = [NSNumber numberWithInt:[item.remain intValue] - 1];
        }
    }
}

@end
