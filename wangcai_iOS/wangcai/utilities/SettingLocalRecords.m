//
//  SettingLocalRecords.m
//  wangcai
//
//  Created by Lee Justin on 14-1-12.
//  Copyright (c) 2014年 1528studio. All rights reserved.
//

#import "SettingLocalRecords.h"
#import "LoginAndRegister.h"

#define kLastCheckInTime @"lastCheckInTime"
#define kLastShareTime @"lastShareTime"
#define kLastOfferWallAlertView @"offerWallAlertView"
#define kRatedApp @"ratedApp"
#define kCheckIn @"checkIn"
#define kFirstRun @"firstrun"
#define kMusicOnOff @"musicOnOff"
#define kInstallWangcaiAlertView @"installWangcaiAlertView"
#define kCheckInTimeArray @"checkInTimeArray"
#define kShareTimeArray @"shareTimeArray"
//#define kLastOfferWallAlertView @"offerWallClearPoint"
#define kClickMaxID @"clickMaxID"

#define NKEY(x) ([SettingLocalRecords getUserNamedKey:(x)])

@implementation SettingLocalRecords

+ (NSString*)getUserNamedKey:(NSString*)key
{
    id userid = [[LoginAndRegister sharedInstance] getUserId];
    id deviceid = [[LoginAndRegister sharedInstance] getDeviceId];
    NSString* newKey = [NSString stringWithFormat:@"%@_%@_%@",
                          key, deviceid, userid];
    return newKey;
}

+ (void)saveLastCheckInDateTime:(NSDate*)dateTime
{
    if (dateTime)
    {
        [[NSUserDefaults standardUserDefaults] setObject:dateTime forKey:NKEY(kLastCheckInTime)];
        BOOL syned = [[NSUserDefaults standardUserDefaults] synchronize];
        if (!syned)
        {
            NSLog(@"[[ERROR]] saveLastCheckInDateTime saved false!");
        }
        
        NSArray* rawArray = [[NSUserDefaults standardUserDefaults] objectForKey:NKEY(kCheckInTimeArray)];
        if (rawArray == nil)
        {
            rawArray = [NSArray array];
        }
        NSMutableArray* array = [NSMutableArray arrayWithArray:rawArray];
        [array addObject:dateTime];
        [[NSUserDefaults standardUserDefaults] setObject:array forKey:NKEY(kCheckInTimeArray)];
        syned = [[NSUserDefaults standardUserDefaults] synchronize];
        if (!syned)
        {
            NSLog(@"[[ERROR]] saveCheckInTimeArray false!");
        }
    }
}

+ (NSDate*)getLastCheckInDateTime
{
    NSDate* ret = [[NSUserDefaults standardUserDefaults] objectForKey:NKEY(kLastCheckInTime)];
    return ret;
}

+ (void)saveLastShareDateTime:(NSDate*)dateTime
{
    if (dateTime)
    {
        [[NSUserDefaults standardUserDefaults] setObject:dateTime forKey:NKEY(kLastShareTime)];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        NSArray* rawArray = [[NSUserDefaults standardUserDefaults] objectForKey:NKEY(kShareTimeArray)];
        if (rawArray == nil)
        {
            rawArray = [NSArray array];
        }
        NSMutableArray* array = [NSMutableArray arrayWithArray:rawArray];
        [array addObject:dateTime];
        [[NSUserDefaults standardUserDefaults] setObject:array forKey:NKEY(kShareTimeArray)];
        BOOL syned = [[NSUserDefaults standardUserDefaults] synchronize];
        if (!syned)
        {
            NSLog(@"[[ERROR]] saveShareTimeArray false!");
        }
    }
}

+ (BOOL)hasCheckinBeforeDays:(int)days
{
    BOOL ret = NO;
    NSArray* rawArray = [[NSUserDefaults standardUserDefaults] objectForKey:NKEY(kCheckInTimeArray)];
    if (rawArray == nil)
    {
        rawArray = [NSArray array];
    }
    NSDate* theDay = [NSDate dateWithTimeIntervalSinceNow:-(60.0f*60.0f*24.0f*((float)days))];
    NSString * theDayString = [[theDay description] substringToIndex:10];
    for (NSDate* dateTime in rawArray)
    {
        NSString * refDateString = [[dateTime description] substringToIndex:10];
        if ([theDayString isEqualToString:refDateString])
        {
            ret = YES;
        }
    }
    return ret;
}

+ (BOOL)hasShareBeforeDays:(int)days
{
    BOOL ret = NO;
    NSArray* rawArray = [[NSUserDefaults standardUserDefaults] objectForKey:NKEY(kShareTimeArray)];
    if (rawArray == nil)
    {
        rawArray = [NSArray array];
    }
    NSDate* theDay = [NSDate dateWithTimeIntervalSinceNow:-(60.0f*60.0f*24.0f*((float)days))];
    NSString * theDayString = [[theDay description] substringToIndex:10];
    for (NSDate* dateTime in rawArray)
    {
        NSString * refDateString = [[dateTime description] substringToIndex:10];
        if ([theDayString isEqualToString:refDateString])
        {
            ret = YES;
        }
    }
    return ret;
}

+ (NSDate*)getLastShareDateTime
{
    NSDate* ret = [[NSUserDefaults standardUserDefaults] objectForKey:NKEY(kLastShareTime)];
    return ret;
}

+ (void)saveOfferWallAlertViewShowed:(BOOL)showed
{
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:showed] forKey:kLastOfferWallAlertView];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (BOOL)getOfferWallAlertViewShowed
{
    BOOL ret = NO;
    NSNumber* boolNum = [[NSUserDefaults standardUserDefaults] objectForKey:kLastOfferWallAlertView];
    if (boolNum)
    {
        ret = [boolNum boolValue];
    }
    return ret;
}

+ (void)setRatedApp:(BOOL)rated
{
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:rated] forKey:NKEY(kRatedApp)];
    BOOL syned = [[NSUserDefaults standardUserDefaults] synchronize];
    if (!syned)
    {
        NSLog(@"[[ERROR]] rated saved false!");
    }
}

+ (BOOL)getRatedApp
{
    BOOL ret = NO;
    NSNumber* boolNum = [[NSUserDefaults standardUserDefaults] objectForKey:NKEY(kRatedApp)];
    if (boolNum)
    {
        ret = [boolNum boolValue];
    }
    return ret;
}

+ (void)setCheckIn:(BOOL)checkedIn
{
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:checkedIn] forKey:NKEY(kCheckIn)];
    BOOL syned = [[NSUserDefaults standardUserDefaults] synchronize];
    if (!syned)
    {
        NSLog(@"[[ERROR]] checked In saved false!");
    }
}

+ (BOOL)getCheckIn
{
    BOOL ret = NO;
    NSNumber* boolNum = [[NSUserDefaults standardUserDefaults] objectForKey:NKEY(kCheckIn)];
    if (boolNum)
    {
        ret = [boolNum boolValue];
    }
    return ret;
}

+ (BOOL)isFirstRun {
    BOOL ret = NO;
    NSNumber* boolNum = [[NSUserDefaults standardUserDefaults] objectForKey:NKEY(kFirstRun)];
    if (boolNum == nil) {
        ret = YES;
    }
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:NO] forKey:NKEY(kFirstRun)];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    return ret;
}

+ (BOOL)hasCheckInYesterday
{
    NSDate* today = [NSDate date];
    NSDate * yesterday = [NSDate dateWithTimeIntervalSinceNow:-86400];
    NSDate * refDate = [SettingLocalRecords getLastCheckInDateTime];
    
    if (refDate == nil)
    {
        return NO;
    }
    
    // 10 first characters of description is the calendar date:
    NSString * todayString = [[today description] substringToIndex:10];
    NSString * yesterdayString = [[yesterday description] substringToIndex:10];
    NSString * refDateString = [[refDate description] substringToIndex:10];
    
    if ([refDateString isEqualToString:yesterdayString])
    {
        return YES;
    }
    
    return NO;
}

+ (BOOL)hasCheckInRecent2Days
{
    BOOL ret = NO;
    if ([SettingLocalRecords hasCheckInYesterday] || [SettingLocalRecords hasCheckinBeforeDays:1])
    {
        if ([SettingLocalRecords hasCheckinBeforeDays:2])
        {
            ret = YES;
        }
    }
    
    return ret;
}

+ (BOOL)hasShareInRecent2Days
{
    BOOL ret = NO;
    if ([SettingLocalRecords hasShareToday])
    {
        if ([SettingLocalRecords hasShareBeforeDays:1])
        {
            ret = YES;
        }
    }
    
    return ret;
}


+ (BOOL)hasCheckInToday
{
    NSDate* today = [NSDate date];
    NSDate * yesterday = [NSDate dateWithTimeIntervalSinceNow:-86400];
    NSDate * refDate = [SettingLocalRecords getLastCheckInDateTime];
    
    if (refDate == nil)
    {
        return NO;
    }
    
    // 10 first characters of description is the calendar date:
    NSString * todayString = [[today description] substringToIndex:10];
    NSString * yesterdayString = [[yesterday description] substringToIndex:10];
    NSString * refDateString = [[refDate description] substringToIndex:10];
    
    if ([refDateString isEqualToString:todayString])
    {
        return YES;
    }
    
    return NO;
}

+ (BOOL)hasShareToday
{
    NSDate* today = [NSDate date];
    NSDate * yesterday = [NSDate dateWithTimeIntervalSinceNow:-86400];
    NSDate * refDate = [SettingLocalRecords getLastShareDateTime];
    
    if (refDate == nil)
    {
        return NO;
    }
    
    // 10 first characters of description is the calendar date:
    NSString * todayString = [[today description] substringToIndex:10];
    NSString * yesterdayString = [[yesterday description] substringToIndex:10];
    NSString * refDateString = [[refDate description] substringToIndex:10];
    
    if ([refDateString isEqualToString:todayString])
    {
        return YES;
    }
    
    return NO;
}

+ (int)getDomobPoint
{
    NSNumber* point = [[NSUserDefaults standardUserDefaults] objectForKey:NKEY(kLastOfferWallAlertView)];
    
    return [point intValue];
}

+ (void)setDomobPoint:(int) point
{
    NSNumber* number = [NSNumber numberWithInt:point];
    
    [[NSUserDefaults standardUserDefaults] setObject:number forKey:NKEY(kLastOfferWallAlertView)];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (void)setMusicEnable:(BOOL)enabled
{
    NSNumber* number = [NSNumber numberWithBool:enabled];
    
    [[NSUserDefaults standardUserDefaults] setObject:number forKey:kMusicOnOff];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (BOOL)getMusicEnabled
{
    BOOL ret = YES;
    NSNumber* boolNum = [[NSUserDefaults standardUserDefaults] objectForKey:kMusicOnOff];
    if (boolNum)
    {
        ret = [boolNum boolValue];
    }
    return ret;
}

+ (void)setClickMaxID:(int) mid {
    NSNumber* number = [NSNumber numberWithInt:mid];
    
    [[NSUserDefaults standardUserDefaults] setObject:number forKey:kClickMaxID];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (int) getClickMaxID {
    NSNumber* num = [[NSUserDefaults standardUserDefaults] objectForKey:kClickMaxID];
    if (num)
    {
        return [num intValue];
    }
    
    return 0;
}

+ (void)setPopedInstallWangcaiAlertView:(BOOL)alerted
{
    NSNumber* number = [NSNumber numberWithBool:alerted];
    
    [[NSUserDefaults standardUserDefaults] setObject:number forKey:kInstallWangcaiAlertView];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (BOOL)hasInstallWangcaiAlertViewPoped
{
    BOOL ret = NO;
    NSNumber* boolNum = [[NSUserDefaults standardUserDefaults] objectForKey:kInstallWangcaiAlertView];
    if (boolNum)
    {
        ret = [boolNum boolValue];
    }
    return ret;
}

@end
