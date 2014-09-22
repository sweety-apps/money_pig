//
//  UserInfoAPI.m
//  wangcai
//
//  Created by Lee Justin on 13-12-26.
//  Copyright (c) 2013年 1528studio. All rights reserved.
//

#import "UserInfoAPI.h"
#import "LoginAndRegister.h"
#import "Config.h"
#import "UtilityFunctions.h"

@interface UserInfoAPIRequestContext : NSObject

@property (nonatomic,retain) id<UserInfoAPIDelegate> delegate;
@property (nonatomic,retain) NSString* type;

@end

@implementation UserInfoAPIRequestContext

@synthesize delegate;
@synthesize type;

- (void)dealloc
{
    self.delegate = nil;
    self.type = nil;
    [super dealloc];
}

@end


static UserInfoAPI* gDefaultUserInfo = nil;

@implementation UserInfoAPI

@synthesize uiUserid;
@synthesize uiSex;
@synthesize uiAge;
@synthesize uiArea;
@synthesize uiJob;
@synthesize uiInterest;

+ (void)mapRelation
{
    [super mapRelation];
    [self mapPropertyAsKey:@"uiUserid"];
    [self mapProperty:@"uiSex"];
    [self mapProperty:@"uiAge"];
    [self mapProperty:@"uiArea"];
    [self mapProperty:@"uiJob"];
    [self mapProperty:@"uiInterest"];
}


-(void)load
{
    [super load];
    self.uiAge = [NSNumber numberWithInt:-1];
    self.uiSex = [NSNumber numberWithInt:0];
    self.uiInterest = @"";
}

- (id)init
{
    self = [super init];
    if (self) {
    }
    return self;
}

- (void)dealloc
{
    self.uiUserid = nil;
    self.uiSex = nil;
    self.uiAge = nil;
    self.uiArea = nil;
    self.uiJob = nil;
    self.uiInterest = nil;
    [super dealloc];
}

+(UserInfoAPI*)loginedUserInfo
{
    if (gDefaultUserInfo == nil)
    {
        NSString* userId = [[LoginAndRegister sharedInstance] getUserId];
        gDefaultUserInfo = [[UserInfoAPI recordWithKey:userId] retain];
        if (gDefaultUserInfo == nil)
        {
            gDefaultUserInfo = [[UserInfoAPI record] retain];
        }
    }
    return gDefaultUserInfo;
}

- (void)addInterest:(NSString*)interest
{
    [self removeInterest:interest];
    NSMutableArray* interests = [NSMutableArray arrayWithArray:[self getInterests]];
    [interests addObject:interest];
    self.uiInterest = [NSString stringFromArray:interests withInterlacer:@"|"];
}

- (void)removeInterest:(NSString*)interest
{
    NSString* strToRemove = nil;
    NSMutableArray* interests = [NSMutableArray arrayWithArray:[self getInterests]];
    for (NSString* str in interests)
    {
        if ([str isEqualToString:interest])
        {
            strToRemove = str;
            break;
        }
    }
    
    if (strToRemove)
    {
        [interests removeObject:strToRemove];
        self.uiInterest = [NSString stringFromArray:interests withInterlacer:@"|"];
    }
}

- (NSInteger)getInterestCount
{
    NSArray* interests = [self.uiInterest parseStringIntoArrayWithInterlacer:@"|"];
    return [interests count];
}

- (NSArray*)getInterests
{
    return [self.uiInterest parseStringIntoArrayWithInterlacer:@"|"];
}

- (void)saveUserInfoToLocal
{
    //self.primaryID = self.uiUserid;
    if (self.uiUserid)
    {
        self.SAVE();
    }
}

- (void)fetchUserInfo:(id<UserInfoAPIDelegate>)delegate
{
    HttpRequest* req = [[HttpRequest alloc] init:self];
    UserInfoAPIRequestContext* context = [[[UserInfoAPIRequestContext alloc] init]autorelease];
    context.delegate = delegate;
    context.type = @"fetchUserInfo";
    req.extensionContext = context;
    
    NSMutableDictionary* dictionary = [[[NSMutableDictionary alloc] init] autorelease];
    
    [req request:HTTP_READ_ACCOUNT_INFO Param:dictionary method:@"get"];
}

- (void)updateUserInfo:(id<UserInfoAPIDelegate>)delegate
{
    HttpRequest* req = [[HttpRequest alloc] init:self];
    UserInfoAPIRequestContext* context = [[[UserInfoAPIRequestContext alloc] init]autorelease];
    context.delegate = delegate;
    context.type = @"updateUserInfo";
    req.extensionContext = context;
    
    NSMutableDictionary* dictionary = [[[NSMutableDictionary alloc] init] autorelease];
    [dictionary setObject:self.uiAge forKey:@"age"];
    [dictionary setObject:self.uiInterest forKey:@"interest"];
    [dictionary setObject:self.uiSex forKey:@"sex"];
    
    [req request:HTTP_WRITE_ACCOUNT_INFO Param:dictionary method:@"post"];
}

#pragma mark <HttpRequestDelegate> 

-(void) HttpRequestCompleted : (id) request HttpCode:(int)httpCode Body:(NSDictionary*) body {
    UserInfoAPIRequestContext* context = ((HttpRequest*)request).extensionContext;
    id<UserInfoAPIDelegate> delegate = context.delegate;
    
    if ( [context.type isEqualToString:@"fetchUserInfo"] )
    {
        BOOL succeed = NO;
        
        if (httpCode == 200)
        {
            NSNumber* result = [body objectForKey:@"res"];
            //NSString* msg = [body objectForKey:@"msg"];
            succeed = YES;
            if ([result intValue] == 0)
            {
                self.uiAge = [body objectForKey:@"age"];
                self.uiSex = [body objectForKey:@"sex"];
                self.uiInterest = [body objectForKey:@"interest"];
            }
            else
            {
                self.uiAge = nil;
                self.uiSex = [NSNumber numberWithInt:0];
                self.uiInterest = @"";
            }
        }
        
        [delegate onFinishedFetchUserInfo:self isSucceed:succeed];
    }
    else  if ( [context.type isEqualToString:@"updateUserInfo"] )
    {
        BOOL succeed = NO;
        
        if (httpCode == 200)
        {
            NSNumber* result = [body objectForKey:@"res"];
            //NSString* msg = [body objectForKey:@"msg"];
            if ([result intValue] == 0)
            {
                succeed = YES;
            }
        }
        
        [delegate onFinishedUpdateUserInfo:self isSucceed:succeed];
        
    }
    else
    {
        
    }
    
    
    
}

@end
