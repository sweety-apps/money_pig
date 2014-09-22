//
//  UserInfoAPI.h
//  wangcai
//
//  Created by Lee Justin on 13-12-26.
//  Copyright (c) 2013年 1528studio. All rights reserved.
//

#import "HttpRequest.h"

#define kUserSexMale (1)
#define kUserSexFemale (2)

@class UserInfoAPI;

@protocol UserInfoAPIDelegate <NSObject>

- (void)onFinishedFetchUserInfo:(UserInfoAPI*)userInfo isSucceed:(BOOL)succeed;
- (void)onFinishedUpdateUserInfo:(UserInfoAPI*)userInfo isSucceed:(BOOL)succeed;

@end

@interface UserInfoAPI : BeeActiveRecord <HttpRequestDelegate> {
    
}

@property (nonatomic,retain) NSNumber* uiUserid;
@property (nonatomic,retain) NSNumber* uiSex;
@property (nonatomic,retain) NSNumber* uiAge;
@property (nonatomic,retain) NSString* uiArea;
@property (nonatomic,retain) NSString* uiJob;
@property (nonatomic,retain) NSString* uiInterest;

+(UserInfoAPI*)loginedUserInfo;

- (void)addInterest:(NSString*)interest;
- (void)removeInterest:(NSString*)interest;
- (NSInteger)getInterestCount;
- (NSArray*)getInterests;

- (void)saveUserInfoToLocal;
- (void)fetchUserInfo:(id<UserInfoAPIDelegate>)delegate;
- (void)updateUserInfo:(id<UserInfoAPIDelegate>)delegate;

@end
