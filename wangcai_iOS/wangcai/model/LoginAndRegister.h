//
//  LoginAndRegister.h
//  wangcai
//
//  Created by 1528 on 13-12-9.
//  Copyright (c) 2013年 1528studio. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kNotificationNameLevelUp @"LevelUp"

typedef enum LoginStatus {
    Login_Timeout,  // session超时，需要重新登录
    Login_Error,    // 登录失败
    Login_Success,  // 登录成功
    Login_In        // 登录中
} LoginStatus;

@protocol LoginAndRegisterDelegate <NSObject>
-(void) loginCompleted : (LoginStatus) status HttpCode:(int)httpCode ErrCode:(int)errCode Msg:(NSString*)msg;
@end

@protocol BindPhoneDelegate <NSObject>
-(void) bindPhoneCompeted;
@end

@protocol BalanceChangeDelegate <NSObject>
-(void) balanceChanged:(int) oldBalance New:(int) balance;
@end

@interface BalanceInfo : NSObject {
}

@property float _oldBalance;
@property float _newBalance;
@end

@interface LoginAndRegister : NSObject {
    id          _delegate;
    LoginStatus loginStatus;
    NSString*   _phoneNum;
    NSString*   _userid;
    NSString*   _session_id;
    NSString*   _nickname;
    NSString*   _device_id;
    NSString*   _tipsString;
    int       _balance;
    int       _income;    // 总收入
    int       _outgo;     // 总支出
    int       _recentIncome;  // 最近赚到
    int       _offerwallIncome; // 积分墙总收入
    int       _inviteIncome;
    NSString*   _invite_code;
    NSString*   _inviter;
    
    NSMutableArray* _delegateArray;
    NSMutableArray* _delegateBalanceArray;
    
    int        _force_update;
    
    BOOL       _firstLogin;
    
    int        _nowithdraw;
    
    int        _showDomob;
    int        _showYoumi;
    int        _showLimei;
    int        _showMobsmar; //指盟
    int        _showMopan;
    int        _showPunchBox; // 触控
    int        _showMiidi;    // 米迪
    int        _showJupeng;   // 巨朋
    int        _showDianru;   // 点入
    int        _showAdwo;     // 安沃
    
    int        _inReview;
    
    int        _pollingInterval;
    
    int        _userLevel;
    int        _currentEXP;
    int        _nextLevelEXP;
    int        _benefit;
    
    BOOL       _hasLevelUp;
    
    NSArray*   _phonePay;
    NSArray*   _aliPay;
    NSArray*   _qbiPay;
}

+(id) sharedInstance;

// 如果不是返回成功，可以attach事件，然后调用login接口，完成后回调，然后再调用相应的接口从服务器取数据
-(LoginStatus) getLoginStatus;
// session超时后，需要先设置超时，然后login
-(void) setTimeout; // 修改登录状态为已超时
-(void) login;

-(void) login: (id) delegate;

-(NSString*) getPhoneNum;
-(NSString*) getUserId;
-(NSString*) getSessionId;
-(NSString*) getNickName;
-(NSString*) getDeviceId;
-(int) getBalance;
-(NSString*) getInviteCode;
-(NSString*) getInviter;

-(int) getIncome;
-(int) getOutgo;
-(int) getRecentIncome;

-(void) setIncome:(int) income;
-(void) setOutgo:(int) outgo;

-(void) attachPhone : (NSString*) phoneNum UserId:(NSString*) userid InviteCode:(NSString*) inviteCode;

-(void) attachBindPhoneEvent : (id) delegate;
-(void) detachBindPhoneEvent : (id) delegate;

-(void) attachBalanceChangeEvent : (id) delegate;
-(void) detachBalanceChangeEvent : (id) delegate;

-(void) increaseBalance:(int) inc;
-(void) setBalance:(int) balance;

-(int) getInviteIncome;
-(int) getForceUpdate;

-(void) setShareIncome:(int) nShareIncome;
-(void) setInviter:(NSString*) inviter;

-(BOOL) isShowDomob;
-(BOOL) isShowYoumi;
-(BOOL) isShowLimei;
-(BOOL) isShowMobsmar;
-(BOOL) isShowMopan;
-(BOOL) isShowPunchBox;
-(BOOL) isShowMiidi;
-(BOOL) isShowJupeng;
-(BOOL) isShowDianru;
-(BOOL) isShowAdwo;

-(BOOL) isInMoreDomob;
-(BOOL) isInMoreYoumi;
-(BOOL) isInMoreLimei;
-(BOOL) isInMoreMobsmar;
-(BOOL) isInMoreMopan;
-(BOOL) isInMorePunchBox;
-(BOOL) isInMoreMiidi;
-(BOOL) isInMoreJupeng;
-(BOOL) isInMoreDianru;
-(BOOL) isInMoreAdwo;

-(BOOL) isRecommendDomob;
-(BOOL) isRecommendYoumi;
-(BOOL) isRecommendLimei;
-(BOOL) isRecommendMobsmar;
-(BOOL) isRecommendMopan;
-(BOOL) isRecommendPunchBox;
-(BOOL) isRecommendMiidi;
-(BOOL) isRecommendJupeng;
-(BOOL) isRecommendDianru;
-(BOOL) isRecommendAdwo;

-(int)  getNoWithDraw;
-(NSString*) getTipsStrings;

-(BOOL) isInReview;
-(int) getOfferwallIncome;

-(int) getPollingInterval;

-(int) getUserLevel;
-(void) setUserLevel:(int)level;

-(int) getCurrentExp;
-(void) setCurrentExp:(int)exp;

-(int) getNextLevelExp;
-(void) setNextLevelExp:(int)exp;

-(int) getBenefit;
-(void) setBenefit:(int)benefit;

-(BOOL)checkAndConsumeLevel;


-(NSArray*) getPhonePay;
-(NSArray*) getAlipay;
-(NSArray*) getQbiPay;

@end
