//
//  ExtractAndExchangeLogic.h
//  wangcai
//
//  Created by Lee Justin on 14-10-8.
//  Copyright (c) 2014年 1528studio. All rights reserved.
//

#import "HttpRequest.h"

typedef enum : NSUInteger {
    ExtractAndExchangeTypeUndefined = 0,
    ExtractAndExchangeTypeJingdong = 1,
    ExtractAndExchangeTypeXLVip = 2,
    ExtractAndExchangeTypeAlipay = 100,
    ExtractAndExchangeTypePhonePay = 101,
} ExtractAndExchangeType;

@class ExtractAndExchangeLogic;

@protocol ExtractAndExchangeLogicDelegate <NSObject>

- (void)onFinishedRequestExtractAndExchangeList:(ExtractAndExchangeLogic*)logic
                                      isSucceed:(BOOL)succeed
                                         errMsg:(NSString*)msg;

- (void)onFinishedRequestExchangeCode:(ExtractAndExchangeLogic*)logic
                         exchangeType:(ExtractAndExchangeType)type
                            isSucceed:(BOOL)succeed
                               errMsg:(NSString*)msg;

@end

@interface ExtractAndExchangeListItem : NSObject

@property (nonatomic,assign) ExtractAndExchangeType type;
@property (nonatomic, retain) NSString* name;
@property (nonatomic, retain) NSString* desString;
@property (nonatomic, retain) NSString* iconUrl;
@property (nonatomic,retain) NSNumber* price;
@property (nonatomic,retain) NSNumber* remain;
@property (nonatomic,retain) NSNumber* is_most_cheap;

+ (ExtractAndExchangeListItem*) itemWithDict:(NSDictionary*)dict;

@end

@interface ExtractAndExchangeLogic : NSObject <HttpRequestDelegate>
{
    NSMutableArray* _allItems;
}

AS_SINGLETON(ExtractAndExchangeLogic)

- (void) requestExtractAndExchangeList:(id<ExtractAndExchangeLogicDelegate>)delegate;
- (NSArray*) getExtractAndExchangeList;
- (void) requestExchangeCode:(ExtractAndExchangeType)type
                       price:(NSNumber*)price
                withDelegate:(id<ExtractAndExchangeLogicDelegate>)delegate;

@end
