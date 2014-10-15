//
//  BillingHistoryList.h
//  wangcai
//
//  Created by Lee Justin on 14-10-3.
//  Copyright (c) 2014年 1528studio. All rights reserved.
//

#import "HttpRequest.h"
#import "ExtractAndExchangeLogic.h"

#define kDefaultBillingHistoryPageSize (30)

typedef enum : NSUInteger {
    BillingHistoryOrderStatusPending = 0,
    BillingHistoryOrderStatusConfirmed = 1,
    BillingHistoryOrderStatusCompleted = 2,
} BillingHistoryOrderStatus;

typedef enum : NSUInteger {
    BillingHistoryOrderDetailTypeUnknow = 0,
    BillingHistoryOrderDetailTypeAlipay = 1,
    BillingHistoryOrderDetailTypePhonePay = 2,
    BillingHistoryOrderDetailTypeExchangeCode = 3,
} BillingHistoryOrderDetailType;

#pragma mark - <BillingHistoryListDelegate>

@class BillingHistoryList;
@class BillingHistoryOrderDetailRecord;

@protocol BillingHistoryListDelegate <NSObject>

- (void)onFinishedRequestBillingHis:(BillingHistoryList*)logic
                          isSucceed:(BOOL)succeed
                             errMsg:(NSString*)msg
                              datas:(NSArray*)newRecords
                              isEnd:(BOOL)isEndPage;

- (void)onFinishedRequestOrderDetail:(BillingHistoryList*)logic
                         orderDetail:(BillingHistoryOrderDetailRecord*)orderDetail
                           isSucceed:(BOOL)succeed
                              errMsg:(NSString*)msg;

@end


#pragma mark - BillingHistoryRecord

@interface BillingHistoryRecord : NSObject

@property (nonatomic,retain) NSNumber* userid;
@property (nonatomic, retain) NSString* deviceId;
@property (nonatomic,retain) NSNumber* money;
@property (nonatomic, retain) NSString* remark;
@property (nonatomic, retain) NSString* datetime;
@property (nonatomic, retain) NSString* orderid;

+ (BillingHistoryRecord*) recordWithDict:(NSDictionary*)dict;

@end

#pragma mark - BillingHistoryOrderDetailRecord

@interface BillingHistoryOrderDetailRecord : NSObject

@property (nonatomic,retain) NSString* orderid;
@property (nonatomic,assign) BillingHistoryOrderStatus status;
@property (nonatomic,retain) NSString* name;
@property (nonatomic,assign) BillingHistoryOrderDetailType type;
@property (nonatomic,assign) ExtractAndExchangeType exchange_type;
@property (nonatomic,retain) NSNumber* money;
@property (nonatomic,retain) NSString* create_time;
@property (nonatomic,retain) NSString* confirm_time;
@property (nonatomic,retain) NSString* complete_time;
@property (nonatomic, retain) NSString* extra;;

+ (BillingHistoryOrderDetailRecord*) recordWithDict:(NSDictionary*)dict;

@end

#pragma mark - BillingHistoryList

@interface BillingHistoryList : NSObject <HttpRequestDelegate>
{
    BOOL _isEndPage;
    NSMutableArray* _allRecords;
    BillingHistoryOrderDetailRecord* _orderDetail;
}

AS_SINGLETON(BillingHistoryList)

//请求
- (void) requestRefreshBillingHis:(id<BillingHistoryListDelegate>)delegate;
- (void) requestGetMoreBillingHis:(id<BillingHistoryListDelegate>)delegate;
- (void) requestOrderDetailWithOrderid:(NSString*)orderid
                              delegate:(id<BillingHistoryListDelegate>)delegate;

//数据
- (NSArray*) allRecords;
- (BOOL) isEndPage;
- (BillingHistoryOrderDetailRecord*)lastRequestedOrderDetail;

@end
