//
//  RateAppLogic.h
//  wangcai
//
//  Created by Lee Justin on 14-1-15.
//  Copyright (c) 2014年 1528studio. All rights reserved.
//

#import <Foundation/Foundation.h>

@class RateAppLogic;

@protocol RateAppLogicDelegate <NSObject>

- (void)onRateAppLogicFinished:(RateAppLogic*)logic isRequestSucceed:(BOOL)isSucceed income:(NSInteger)income resultCode:(NSInteger)result msg:(NSString*)msg;

@end

@interface RateAppLogic : NSObject

+ (RateAppLogic*)sharedInstance;

- (void)requestRated:(id<RateAppLogicDelegate>)delegate;
- (BOOL)isRated;

@end
