//
//  BillingHistoryList.h
//  wangcai
//
//  Created by Lee Justin on 14-10-3.
//  Copyright (c) 2014年 1528studio. All rights reserved.
//

#import "HttpRequest.h"

#define kDefaultBillingHistoryPageSize (30)

@class BillingHistoryList;

@protocol BillingHistoryListDelegate <NSObject>

- (void)onFinishedRequestBillingHis:(BillingHistoryList*)logic
                          isSucceed:(BOOL)succeed
                             errMsg:(NSString*)msg
                              datas:(NSArray*)newRecords
                              isEnd:(BOOL)isEndPage;

@end

@interface BillingHistoryRecord : NSObject

@property (nonatomic,retain) NSNumber* userid;
@property (nonatomic, retain) NSString* deviceId;
@property (nonatomic,retain) NSNumber* money;
@property (nonatomic, retain) NSString* remark;
@property (nonatomic, retain) NSString* datetime;
@property (nonatomic, retain) NSString* orderid;

+ (BillingHistoryRecord*) recordWithDict:(NSDictionary*)dict;

@end

@interface BillingHistoryList : NSObject <HttpRequestDelegate>
{
    BOOL _isEndPage;
    NSMutableArray* _allRecords;
}

AS_SINGLETON(BillingHistoryList)

- (void) requestRefreshBillingHis:(id<BillingHistoryListDelegate>)delegate;
- (void) requestGetMoreBillingHis:(id<BillingHistoryListDelegate>)delegate;
- (NSArray*) allRecords;
- (BOOL) isEndPage;

@end
