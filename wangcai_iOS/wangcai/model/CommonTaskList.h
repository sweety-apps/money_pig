//
//  CommonTaskList.h
//  wangcai
//
//  Created by Lee Justin on 13-12-26.
//  Copyright (c) 2013年 1528studio. All rights reserved.
//

#import "HttpRequest.h"

#define kTaskTypeInstallWangcai (1)
#define kTaskTypeUserInfo (2)
#define kTaskTypeInviteFriends (3)
#define kTaskTypeEverydaySign (4)
#define kTaskTypeOfferWall (5)
#define kTaskTypeCommetWangcai (6)
#define KTaskTypeUpgrade (7)
#define kTaskTypeShare   (8)
#define kTaskTypeIntallApp (10000)
#define kTaskTypeCommon (10001)

#define kTaskTypeYoumiEc (99999)


@class CommonTaskList;

@protocol CommonTaskListDelegate <NSObject>

- (void)onFinishedFetchTaskList:(CommonTaskList*)taskList resultCode:(NSInteger)result;

@end

@interface CommonTaskInfo : NSObject

@property (nonatomic,retain) NSNumber* taskId;
@property (nonatomic,retain) NSNumber* taskType;
@property (nonatomic,retain) NSString* taskTitle;
@property (nonatomic,retain) NSString* taskIconUrl;
@property (nonatomic,retain) NSString* taskIntro;
@property (nonatomic,retain) NSString* taskDesc;
@property (nonatomic,retain) NSArray* taskStepStrings;
@property (nonatomic,retain) NSNumber* taskStatus;
@property (nonatomic,retain) NSNumber* taskMoney;
@property (nonatomic,assign) BOOL taskIsLocalIcon;
@property (nonatomic, assign) NSNumber* taskLevel;
@property (nonatomic, retain) NSString* taskRediectUrl;
@property (nonatomic, retain) NSString* taskAppId;

//@property (nonatomic,retain) NSNumber* taskStartTime;
//@property (nonatomic,retain) NSNumber* taskEndTime;

@end

@interface CommonTaskList : NSObject <HttpRequestDelegate> 

+ (CommonTaskList*)sharedInstance;
- (void)fetchTaskList:(id<CommonTaskListDelegate>)delegate;

@property (nonatomic,retain) NSArray* taskList;//item type = CommonTaskInfo

- (NSArray*)getUnfinishedTaskList;
- (NSArray*)getAllTaskList;
- (float)allMoneyCanBeEarnedInRMBYuan;
- (BOOL)containsUnfinishedUserInfoTask;
- (BOOL)isAwardTaskFinished;
- (void)resetTaskListWithJsonArray:(NSArray*)jsonArray;

- (void) increaseEarned:(NSInteger) increase;

@end
