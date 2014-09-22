//
//  CommonTaskList.m
//  wangcai
//
//  Created by Lee Justin on 13-12-26.
//  Copyright (c) 2013年 1528studio. All rights reserved.
//

#import "CommonTaskList.h"
#import "SettingLocalRecords.h"
#import "Config.h"
#import "SettingLocalRecords.h"

@interface CommonTaskInfoContext : NSObject

@property (nonatomic,retain) id<CommonTaskListDelegate> delegate;

@end

@implementation CommonTaskInfoContext

@synthesize delegate;

- (void)dealloc
{
    self.delegate = nil;
    [super dealloc];
}

@end

@implementation CommonTaskInfo

@synthesize taskId;
@synthesize taskType;
@synthesize taskTitle;
@synthesize taskIconUrl;
@synthesize taskIntro;
@synthesize taskStatus;
@synthesize taskMoney;
@synthesize taskDesc;
@synthesize taskStepStrings;
@synthesize taskIsLocalIcon;
@synthesize taskRediectUrl;
@synthesize taskAppId;

//@synthesize taskStartTime;
//@synthesize taskEndTime;

- (void)dealloc
{
    self.taskId = nil;
    self.taskType = nil;
    self.taskTitle = nil;
    self.taskIconUrl = nil;
    self.taskIntro = nil;
    self.taskStatus = nil;
    self.taskMoney = nil;
    self.taskDesc = nil;
    self.taskStepStrings = nil;
    self.taskRediectUrl = nil;
    self.taskAppId = nil;
    
    //self.taskStartTime = nil;
    //self.taskEndTime = nil;
    [super dealloc];
}

@end

static CommonTaskList* gInstance = nil;


@interface CommonTaskList ()
{
    BOOL _containsUserInfoTask;
    BOOL _awardTaskFinished;
}

@property (nonatomic,retain) NSMutableArray* unfinishedTaskList;

@end

@implementation CommonTaskList

@synthesize taskList;
@synthesize unfinishedTaskList;

- (id)init
{
    self = [super init];
    if (self) {
        _containsUserInfoTask = NO;
    }
    return self;
}

- (void)dealloc
{
    self.taskList = nil;
    self.unfinishedTaskList = nil;
    [super dealloc];
}

+ (CommonTaskList*)sharedInstance
{
    if (gInstance == nil)
    {
        gInstance = [[CommonTaskList alloc] init];
    }
    return gInstance;
}

- (void)fetchTaskList:(id<CommonTaskListDelegate>)delegate
{
    HttpRequest* req = [[HttpRequest alloc] init:self];
    CommonTaskInfoContext* context = [[[CommonTaskInfoContext alloc] init]autorelease];
    context.delegate = delegate;
    req.extensionContext = context;
    
    NSMutableDictionary* dictionary = [[[NSMutableDictionary alloc] init] autorelease];
    
    [req request:HTTP_READ_TASK_LIST Param:dictionary method:@"get"];
}

- (NSArray*)getUnfinishedTaskList
{
    return self.unfinishedTaskList;
}

- (NSArray*)getAllTaskList
{
    return self.taskList;
}

- (float)allMoneyCanBeEarnedInRMBYuan
{
    if ([self.taskList count] > 0)
    {
        float allRMBFen = 0.0f;
        for (CommonTaskInfo* task in self.unfinishedTaskList)
        {
            allRMBFen += [task.taskMoney floatValue];
        }
        
        allRMBFen -= [self getIncreaseEarned];
        if ( allRMBFen < 1000 ) {
            allRMBFen = 1000;
        }
        
        return allRMBFen/100.0f;
    }
    return 0.0f;
}

- (void) increaseEarned:(NSInteger) increase {
    // 今天已经赚了多少钱
    NSDate* now = [NSDate date];
    int nYear = [now year];
    int nMonth = [now month];
    int nDay = [now day];
    
    NSString* curTime = [[NSString alloc] initWithFormat:@"%d-%d-%d", nYear, nMonth, nDay];
    
    // 取配置文件中的时间
    NSString* cfgTime = [[NSUserDefaults standardUserDefaults] objectForKey:@"cfgTime"];
    NSNumber* cfgInc = [[NSUserDefaults standardUserDefaults] objectForKey:@"cfgInc"];
    if ( [curTime isEqualToString:cfgTime] ) {
        int value = [cfgInc intValue];
        value += increase;
        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:value] forKey:@"cfgInc"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    } else {
        [[NSUserDefaults standardUserDefaults] setObject:curTime forKey:@"cfgTime"];
        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:increase] forKey:@"cfgInc"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
    [curTime release];
}

- (int) getIncreaseEarned {
    NSDate* now = [NSDate date];
    int nYear = [now year];
    int nMonth = [now month];
    int nDay = [now day];
    
    NSString* curTime = [[[NSString alloc] initWithFormat:@"%d-%d-%d", nYear, nMonth, nDay] autorelease];
    
    // 取配置文件中的时间
    NSString* cfgTime = [[NSUserDefaults standardUserDefaults] objectForKey:@"cfgTime"];
    NSNumber* cfgInc = [[NSUserDefaults standardUserDefaults] objectForKey:@"cfgInc"];
    
    if ( [curTime isEqualToString:cfgTime] ) {
        return [cfgInc intValue];
    }
    return 0;
}

- (BOOL)containsUnfinishedUserInfoTask
{
    return _containsUserInfoTask;
}

- (BOOL)isAwardTaskFinished
{
    return _awardTaskFinished;
}

- (void)resetTaskListWithJsonArray:(NSArray*)jsonArray
{
    NSArray* taskList = jsonArray;
    NSMutableArray* resultTaskList = [NSMutableArray array];
    NSMutableArray* unfinishedTaskList = [NSMutableArray array];
    
    _containsUserInfoTask = NO;
    
    if (NO)
    {
        //本地测试数据
        NSArray* localTestTask = [self _buildLocalTestTask];
        [resultTaskList addObjectsFromArray:localTestTask];
    }
    
    if ( [[LoginAndRegister sharedInstance] isInReview] ) {
        CommonTaskInfo* task = [[[CommonTaskInfo alloc] init] autorelease];
        task.taskId = [NSNumber numberWithInt:99999];
        task.taskType = [NSNumber numberWithInt:kTaskTypeYoumiEc];
        task.taskTitle = @"购物赢红包";
        task.taskStatus = [NSNumber numberWithInt:0];
        task.taskMoney = [NSNumber numberWithInt:5000];
        task.taskIntro = @"";
        task.taskDesc = @"购物即可获得一定红包奖励";
        task.taskStepStrings = nil;
        task.taskIsLocalIcon = YES;
        task.taskIconUrl = @"tiyanzhongxin_cell_icon";
        task.taskRediectUrl = nil;
        task.taskAppId = nil;
        
        [resultTaskList addObject:task];
    }
    
    for (NSDictionary* taskDict in taskList)
    {
        CommonTaskInfo* task = [[[CommonTaskInfo alloc] init] autorelease];
        task.taskId = [taskDict objectForKey:@"id"];
        task.taskType = [taskDict objectForKey:@"type"];
        task.taskTitle = [taskDict objectForKey:@"title"];
        task.taskStatus = [taskDict objectForKey:@"status"];
        task.taskMoney = [taskDict objectForKey:@"money"];
        task.taskIconUrl = [taskDict objectForKey:@"icon"];
        task.taskIntro = [taskDict objectForKey:@"intro"];
        task.taskDesc = [taskDict objectForKey:@"desc"];
        task.taskStepStrings = [taskDict objectForKey:@"steps"];
        task.taskLevel = [taskDict objectForKey:@"level"];
        task.taskRediectUrl = [taskDict objectForKey:@"rediect_url"];
        task.taskAppId = [taskDict objectForKey:@"appid"];
        
        NSInteger taskType = [task.taskType intValue];
        
        BOOL shouldAddTask = YES;
        switch (taskType)
        {
            case kTaskTypeInstallWangcai:
                task.taskIsLocalIcon = YES;
                task.taskIconUrl = @"about_wangcai_cell_icon";
                break;
            case kTaskTypeUserInfo:
                task.taskIsLocalIcon = YES;
                task.taskIconUrl = @"person_info_icon";
                if ([task.taskStatus integerValue] != 1)
                {
                    _containsUserInfoTask = YES;
                }
                else
                {
                    _containsUserInfoTask = NO;
                }
                break;
            case kTaskTypeInviteFriends:
                task.taskIsLocalIcon = YES;
                task.taskIconUrl = @"qrcode_cell_icon";
                break;
            case kTaskTypeEverydaySign:
                task.taskIsLocalIcon = NO;
                if ([task.taskStatus intValue] == 10)
                {
                    [SettingLocalRecords setCheckIn:YES];
                }
                else
                {
                    [SettingLocalRecords setCheckIn:NO];
                }
                shouldAddTask = NO;
                //task.taskIconUrl = @"";
                break;
            case kTaskTypeIntallApp:
                task.taskIsLocalIcon = NO;
                //task.taskIconUrl = @"";
                break;
            case kTaskTypeCommon:
                task.taskIsLocalIcon = NO;
                //task.taskIconUrl = @"";
                break;
            case kTaskTypeOfferWall:
                task.taskIsLocalIcon = YES;
                task.taskIconUrl = @"tiyanzhongxin_cell_icon";
                //task.taskIconUrl = @"";
                break;
            case kTaskTypeCommetWangcai:
                task.taskIsLocalIcon = YES;
                task.taskIconUrl = @"rate_app_cell_icon";
                if ([task.taskStatus intValue] == 10)
                {
                    [SettingLocalRecords setRatedApp:YES];
                }
                else
                {
                    [SettingLocalRecords setRatedApp:NO];
                }
                break;
            case KTaskTypeUpgrade:
                task.taskIsLocalIcon = YES;
                task.taskIconUrl = @"upgrade";
                break;
            case kTaskTypeShare:
                task.taskIsLocalIcon = YES;
                task.taskIconUrl = @"share_cell_icon";
                break;
            default:
                if ([task.taskIconUrl rangeOfString:@"http://"].length > 0)
                {
                    task.taskIsLocalIcon = NO;
                }
                break;
        }
        
        if (shouldAddTask)
        {
            if ( [[LoginAndRegister sharedInstance] isInReview] && taskType == kTaskTypeInstallWangcai ) {
                
            } else {
                [resultTaskList addObject:task];
            }
        }
    }
    
    //分离完成任务和未完成任务
    for (CommonTaskInfo* task in resultTaskList)
    {
        if ([task.taskStatus intValue] == 0)
        {
            [unfinishedTaskList addObject:task];
        }
    }
    
    self.taskList = resultTaskList;
    self.unfinishedTaskList = unfinishedTaskList;
    NSMutableArray* reorderedTaskList = [NSMutableArray arrayWithArray:self.unfinishedTaskList];
    for (CommonTaskInfo* task in resultTaskList)
    {
        if ([task.taskStatus intValue] != 0)
        {
            [reorderedTaskList addObject:task];
        }
    }
    self.taskList = reorderedTaskList;
}

- (NSArray*)_buildLocalTestTask
{
    //本地测试数据
    NSMutableArray* tasks = [NSMutableArray array];
    
    BOOL finished = NO;
    CommonTaskInfo* task = nil;
    
    NSString* inviter = [[LoginAndRegister sharedInstance] getInviter];
    if (!(inviter == nil || [inviter length] == 0))
    {
        finished = YES;
    }
    else
    {
        finished = NO;
    }
    task = [[[CommonTaskInfo alloc] init] autorelease];
    task.taskId = [NSNumber numberWithInt:10];
    task.taskType = [NSNumber numberWithInt:kTaskTypeInviteFriends];
    task.taskTitle = @"填写邀请码拿红包";
    task.taskStatus = finished ? [NSNumber numberWithInt:10] : [NSNumber numberWithInt:0];
    task.taskMoney = [NSNumber numberWithInt:200];
    task.taskIconUrl = @"about_wangcai_cell_icon";
    task.taskIntro = @"";
    task.taskDesc = @"填写好友的邀请码领取红包";
    task.taskIsLocalIcon = YES;
    task.taskStepStrings = [NSArray array];
    
    [tasks addObject:task];
    
    finished = [SettingLocalRecords getRatedApp];
    task = [[[CommonTaskInfo alloc] init] autorelease];
    task.taskId = [NSNumber numberWithInt:10];
    task.taskType = [NSNumber numberWithInt:kTaskTypeCommetWangcai];
    task.taskTitle = @"评价旺财";
    task.taskStatus = finished ? [NSNumber numberWithInt:10] : [NSNumber numberWithInt:0];
    task.taskMoney = [NSNumber numberWithInt:50];
    task.taskIconUrl = @"about_wangcai_cell_icon";
    task.taskIntro = @"";
    task.taskDesc = @"评价旺财，给旺财打个赏";
    task.taskIsLocalIcon = YES;
    task.taskStepStrings = [NSArray array];
    
    [tasks addObject:task];
    
    return tasks;
}

#pragma mark <HttpRequestDelegate>

-(void) HttpRequestCompleted : (id) request HttpCode:(int)httpCode Body:(NSDictionary*) body {
    CommonTaskInfoContext* context = ((HttpRequest*)request).extensionContext;
    id<CommonTaskListDelegate> delegate = context.delegate;
    
    NSNumber* result = [NSNumber numberWithInt:-1];
    NSString* msg = @"";
    
    if (httpCode == 200)
    {
        result = [body objectForKey:@"res"];
        msg = [body objectForKey:@"msg"];
        if ([result integerValue] == 0)
        {
            NSArray* taskList = [body objectForKey:@"task_list"];
            [self resetTaskListWithJsonArray:taskList];
        }
    }
    
    if (delegate)
    {
        [delegate onFinishedFetchTaskList:self resultCode:[result integerValue]];
    }
}


@end
