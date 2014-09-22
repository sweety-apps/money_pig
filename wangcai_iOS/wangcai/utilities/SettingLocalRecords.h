//
//  SettingLocalRecords.h
//  wangcai
//
//  Created by Lee Justin on 14-1-12.
//  Copyright (c) 2014年 1528studio. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SettingLocalRecords : NSObject

+ (void)saveLastCheckInDateTime:(NSDate*)dateTime;
+ (NSDate*)getLastCheckInDateTime;

+ (void)saveLastShareDateTime:(NSDate*)dateTime;
+ (NSDate*)getLastShareDateTime;

+ (void)saveOfferWallAlertViewShowed:(BOOL)showed;
+ (BOOL)getOfferWallAlertViewShowed;

+ (void)setRatedApp:(BOOL)rated;
+ (BOOL)getRatedApp;

+ (void)setCheckIn:(BOOL)checkedIn;
+ (BOOL)getCheckIn;

+ (BOOL)hasCheckInYesterday;
+ (BOOL)hasCheckInToday;
+ (BOOL)hasShareToday;
+ (BOOL)hasCheckInRecent2Days;
+ (BOOL)hasShareInRecent2Days;

+ (int)getDomobPoint;
+ (void)setDomobPoint:(int) point;

+ (void)setMusicEnable:(BOOL)enabled;
+ (BOOL)getMusicEnabled;

+ (void)setPopedInstallWangcaiAlertView:(BOOL)alerted;
+ (BOOL)hasInstallWangcaiAlertViewPoped;

+ (BOOL)isFirstRun;



+ (void)setClickMaxID:(int) mid;
+ (int) getClickMaxID;


@end
