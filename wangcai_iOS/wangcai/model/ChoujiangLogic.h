//
//  ChoujiangLogic.h
//  wangcai
//
//  Created by Lee Justin on 14-1-4.
//  Copyright (c) 2014年 1528studio. All rights reserved.
//

#import "HttpRequest.h"

typedef NSInteger GetAwardType;

#define kGetAwardTypeNotGet (-1)
#define kGetAwardTypeAlreadyGot (-2)
#define kGetAwardTypeNothing (0)
#define kGetAwardType1Mao (1)
#define kGetAwardType5Mao (2)
#define kGetAwardType3Yuan (3)
#define kGetAwardType8Yuan (4)

@class ChoujiangLogic;

@protocol ChoujiangLogicDelegate <NSObject>

- (void)onFinishedChoujiangRequest:(ChoujiangLogic*)logic isRequestSucceed:(BOOL)isSucceed awardCode:(GetAwardType)awardCode resultCode:(NSInteger)result msg:(NSString*)msg;

@end

@interface ChoujiangLogic : NSObject <HttpRequestDelegate>
{
    GetAwardType _awardCode;
}

AS_SINGLETON( ChoujiangLogic )

- (GetAwardType)getAwardCode;
- (void)requestChoujiang:(id<ChoujiangLogicDelegate>)delegate;

@end
