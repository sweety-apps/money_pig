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

@implementation BillingHistoryRecord : NSObject

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
    [_allRecords release];
    [super dealloc];
}

#pragma mark

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
    
    [req request:HTTP_BILLING_HISTORY Param:dictionary method:@"get"];
}

- (NSArray*) allRecords
{
    return _allRecords;
}

- (BOOL) isEndPage
{
    return _isEndPage;
}

#pragma mark <HttpRequestDelegate>

-(void) HttpRequestCompleted : (id) request HttpCode:(int)httpCode Body:(NSDictionary*) body {
    HttpRequest* req = (HttpRequest*)request;
    id<BillingHistoryListDelegate> delegate = req.extensionContext;
    
    NSNumber* result = [NSNumber numberWithInt:-1];
    NSString* msg = @"";
    //_awardCode = kGetAwardTypeRequestFailed;
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
        }
        succeed = YES;
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

@end
