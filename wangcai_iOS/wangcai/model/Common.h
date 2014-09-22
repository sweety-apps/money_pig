//
//  Common.h
//  wangcai
//
//  Created by 1528 on 13-12-9.
//  Copyright (c) 2013年 1528studio. All rights reserved.
//

#import <Foundation/Foundation.h>

#define DEVICE_IS_IPHONE5 ([[UIScreen mainScreen] bounds].size.height == 568)

@interface Common : NSObject

+ (void) openUrl:(NSString*) url;
+ (NSString*) getIDFAAddress;
+ (NSString*) getIDFV;
+ (NSString*) getMACAddress;
+ (NSString*) getTimestamp;
+ (NSString*) buildURL:(NSString*) url Params:(NSMutableDictionary*) params;

+ (SecIdentityRef) getSecIdentityRef;

+ (NSString *)localIPAddress;
+ (NSString*)deviceModel;

+ (void)playAddCoinSound;

#if TARGET_VERSION_LITE == 1
+ (BOOL)setUDIDToKeyChain:(NSString*)udid;
+ (NSString*)getUDIDFromKeyChain;
#endif
@end
