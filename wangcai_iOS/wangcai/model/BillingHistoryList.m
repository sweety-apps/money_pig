//
//  BillingHistoryList.m
//  wangcai
//
//  Created by Lee Justin on 14-10-3.
//  Copyright (c) 2014年 1528studio. All rights reserved.
//

#import "BillingHistoryList.h"
#import "Config.h"
#import "SettingLocalRecords.h"
#import "HttpRequest.h"

#pragma mark - BillingHistoryRecord

@implementation BillingHistoryRecord

@synthesize userid;
@synthesize deviceId;
@synthesize money;
@synthesize remark;
@synthesize datetime;
@synthesize orderid;

+ (BillingHistoryRecord*) recordWithDict:(NSDictionary*)dict
{
    BillingHistoryRecord* rcd = [[[BillingHistoryRecord alloc] init] autorelease];
    rcd.userid = dict[@"userid"];
    rcd.deviceId = dict[@"device_id"];
    rcd.orderid = dict[@"serial_num"];
    rcd.money = dict[@"money"];
    rcd.remark = dict[@"remark"];
    rcd.datetime = dict[@"time"];
    return rcd;
}

- (void)dealloc
{
    self.userid = nil;
    self.deviceId = nil;
    self.money = nil;
    self.remark = nil;
    self.datetime = nil;
    self.orderid = nil;
    [super dealloc];
}

@end

#pragma mark - BillingHistoryOrderDetailRecord

@implementation BillingHistoryOrderDetailRecord

@synthesize orderid;
@synthesize status;
@synthesize exchange_type;
@synthesize type;
@synthesize name;
@synthesize money;
@synthesize create_time;
@synthesize confirm_time;
@synthesize complete_time;
@synthesize extra;

+ (BillingHistoryOrderDetailRecord*) recordWithDict:(NSDictionary*)dict
{
    BillingHistoryOrderDetailRecord* rcd = [[[BillingHistoryOrderDetailRecord alloc] init] autorelease];
    rcd.orderid = @"";
    rcd.status = [dict[@"status"] integerValue];
    rcd.exchange_type = [dict[@"exchange_type"] integerValue];
    rcd.name = dict[@"name"];
    rcd.type = [dict[@"type"] integerValue];
    rcd.money = dict[@"money"];
    rcd.create_time = dict[@"create_time"];
    rcd.confirm_time = dict[@"confirm_time"];
    rcd.complete_time = dict[@"complete_time"];
    if (rcd.exchange_type < ExtractAndExchangeTypeAlipay)
    {
        NSString* extraStr = dict[@"extra"];
        NSDictionary* dictExtra = [NSJSONSerialization JSONObjectWithData:[extraStr data] options:NSJSONReadingMutableLeaves error:nil];
        rcd.extra = dictExtra[@"code"];
    }
    else
    {
        rcd.extra = dict[@"extra"];
    }
    return rcd;
}

- (void)dealloc
{
    self.orderid = nil;
    self.money = nil;
    self.create_time = nil;
    self.confirm_time = nil;
    self.complete_time = nil;
    self.extra = nil;
    self.name = nil;
    [super dealloc];
}

@end


#pragma mark - BillingHistoryList

@interface BillingHistoryList ()
{
    NSInteger _lastReqCount;
    NSInteger _lastReqOffset;
}

@end


@implementation BillingHistoryList

DEF_SINGLETON(BillingHistoryList)

#pragma mark

- (instancetype)init
{
    self = [super init];
    if (self) {
        _isEndPage = NO;
        _allRecords = [[NSMutableArray array] retain];
    }
    return self;
}

- (void)dealloc
{
    [_orderDetail release];
    [_allRecords release];
    [super dealloc];
}

#pragma mark 请求

- (void) requestRefreshBillingHis:(id<BillingHistoryListDelegate>)delegate
{
    [self requestBillingHisWithOffset:0 count:kDefaultBillingHistoryPageSize del:delegate];
}

- (void) requestGetMoreBillingHis:(id<BillingHistoryListDelegate>)delegate
{
    [self requestGetMoreBillingHisWithOffset:[_allRecords count] del:delegate];
}

- (void) requestGetMoreBillingHisWithOffset:(NSInteger)offset
                                        del:(id<BillingHistoryListDelegate>)delegate
{
    [self requestBillingHisWithOffset:offset count:kDefaultBillingHistoryPageSize del:delegate];
}

- (void) requestBillingHisWithOffset:(NSInteger)offset
                               count:(NSInteger)count
                                 del:(id<BillingHistoryListDelegate>)delegate
{
    HttpRequest* req = [[HttpRequest alloc] init:self];
    req.extensionContext = delegate;
    
    NSMutableDictionary* dictionary = [[[NSMutableDictionary alloc] init] autorelease];
    dictionary[@"offset"] = [NSNumber numberWithInt:offset];
    dictionary[@"num"] = [NSNumber numberWithInt:count];
    
    _lastReqCount = count;
    _lastReqOffset = offset;
    
    [req request:HTTP_BILLING_HISTORY Param:dictionary method:@"post"];
}

- (void) requestOrderDetailWithOrderid:(NSString*)orderid
                              delegate:(id<BillingHistoryListDelegate>)delegate
{
    HttpRequest* req = [[HttpRequest alloc] init:self];
    req.extensionContext = @{@"orderid":orderid,@"delegate":delegate};
    
    NSMutableDictionary* dictionary = [[[NSMutableDictionary alloc] init] autorelease];
    dictionary[@"order_id"] = orderid;
    
    [req request:HTTP_ORDER_DETAIL Param:dictionary method:@"post"];
}

#pragma mark 数据

- (NSArray*) allRecords
{
    return _allRecords;
}

- (BOOL) isEndPage
{
    return _isEndPage;
}

- (BillingHistoryOrderDetailRecord*)lastRequestedOrderDetail
{
    return _orderDetail;
}

#pragma mark <HttpRequestDelegate>

-(void) HttpRequestCompleted : (id) request HttpCode:(int)httpCode Body:(NSDictionary*) body {
    HttpRequest* req = (HttpRequest*)request;
    if ([[[req getBeeHttpRequest].url absoluteString] rangeOfString:HTTP_BILLING_HISTORY].length > 0)
    {
        [self listRequestCompleted:request
                          HttpCode:httpCode
                              Body:body];
        
        [request autorelease];
    }
    else if ([[[req getBeeHttpRequest].url absoluteString] rangeOfString:HTTP_ORDER_DETAIL].length > 0)
    {
        [self orderDetailRequestCompleted:request HttpCode:httpCode Body:body];
        
        [request autorelease];
    }
}

#pragma mark 请求处理

-(void) listRequestCompleted : (id) request HttpCode:(int)httpCode Body:(NSDictionary*) body {
    HttpRequest* req = (HttpRequest*)request;
    id<BillingHistoryListDelegate> delegate = req.extensionContext;
    
    NSNumber* result = [NSNumber numberWithInt:-1];
    NSString* msg = @"网络不通，请检查网络";
    BOOL succeed = NO;
    NSMutableArray* newHisArr = nil;
    
    if (httpCode == 200)
    {
        result = [body objectForKey:@"res"];
        msg = [body objectForKey:@"msg"];
        if ([result integerValue] == 0)
        {
            _isEndPage = NO;
            NSArray* newHisDictArr = body[@"history"];
            int rmvCount = [_allRecords count] - _lastReqOffset;
            if (rmvCount < 0)
            {
                rmvCount = 0;
            }
            NSRange rmvRange = {_lastReqOffset,rmvCount};
            [_allRecords removeObjectsInRange:rmvRange];
            
            newHisArr = [NSMutableArray array];
            for (NSDictionary* dict in newHisDictArr)
            {
                BillingHistoryRecord * rcd = [BillingHistoryRecord recordWithDict:dict];
                [newHisArr addObject:rcd];
            }
            
            [_allRecords addObjectsFromArray:newHisArr];
            
            if (_lastReqCount > [newHisDictArr count])
            {
                _isEndPage = YES;
            }
            
            succeed = YES;
        }
    }
    
    if (delegate)
    {
        [delegate onFinishedRequestBillingHis:self
                                    isSucceed:succeed
                                       errMsg:msg
                                        datas:newHisArr
                                        isEnd:_isEndPage];
    }
}

-(void) orderDetailRequestCompleted : (id) request HttpCode:(int)httpCode Body:(NSDictionary*) body {
    HttpRequest* req = (HttpRequest*)request;
    NSDictionary* paramDict = req.extensionContext;
    NSString* orderid = paramDict[@"orderid"];
    id<BillingHistoryListDelegate> delegate = paramDict[@"delegate"];
    
    NSNumber* result = [NSNumber numberWithInt:-1];
    NSString* msg = @"网络不通，请检查网络";
    BOOL succeed = NO;
    
    BillingHistoryOrderDetailRecord* rcd = nil;
    if (_orderDetail)
    {
        [_orderDetail release];
        _orderDetail = nil;
    }
    
    if (httpCode == 200)
    {
        result = [body objectForKey:@"res"];
        msg = [body objectForKey:@"msg"];
        if ([result integerValue] == 0)
        {
            rcd = [BillingHistoryOrderDetailRecord recordWithDict:body];
            rcd.orderid = orderid;
            
            _orderDetail = [rcd retain];
            
            succeed = YES;
        }
    }
    
    if (delegate)
    {
        [delegate onFinishedRequestOrderDetail:self orderDetail:rcd isSucceed:succeed errMsg:msg];
    }
}

@end
