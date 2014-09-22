//
//  PhoneValidation.m
//  wangcai
//
//  Created by 1528 on 13-12-9.
//  Copyright (c) 2013年 1528studio. All rights reserved.
//

#import "PhoneValidation.h"
#import "Config.h"
#import "LoginAndRegister.h"

@implementation PhoneValidation

-(id) init {
    self = [super init];
    if ( self != nil ) {
    }
    return self;
}

//int _status;  0-绑定手机号, 1-校验短信验证码, 2-发送短信验证码
- (void) attachPhone : (NSString*) phoneNum delegate:(id) del {
    _status = 0;
    
    _smsDelegate = del;
    
    HttpRequest* request = [[HttpRequest alloc] init:self];
    
    NSMutableDictionary* dictionary = [[NSMutableDictionary alloc] init];
    
    [dictionary setObject:phoneNum forKey:@"phone"];

    [request request:HTTP_BIND_PHONE Param:dictionary];
    
    [dictionary release];
}

- (void) sendCheckNumToPhone : (NSString*) token delegate : (id) del {
    _status = 2;
    
    _smsDelegate = del;
    
    HttpRequest* request = [[HttpRequest alloc] init:self];
    
    NSMutableDictionary* dictionary = [[NSMutableDictionary alloc] init];
    
    [dictionary setObject:token forKey:@"token"];
    [dictionary setObject:@"5" forKey:@"code_length"];
    
    [request request:HTTP_SEND_SMS_CODE Param:dictionary];
    
    [dictionary release];
}


- (void) checkSmsCode : (NSString*)code Token:(NSString*)token delegate:(id)del {
    _status = 1;
    
    _smsDelegate = del;
    
    HttpRequest* request = [[HttpRequest alloc] init:self];
    
    NSMutableDictionary* dictionary = [[NSMutableDictionary alloc] init];
    
    [dictionary setObject:token forKey:@"token"];
    [dictionary setObject:code forKey:@"sms_code"];
    
    [request request:HTTP_CHECK_SMS_CODE Param:dictionary];
    
    [dictionary release];
}

-(void) HttpRequestCompleted : (id) request HttpCode:(int)httpCode Body:(NSDictionary*) body {
     if ( _status == 0 ) {
         [self bindHandleRequest:httpCode Body:body];
     } else if ( _status == 2 ) {
         [self sendSmsHandleRequest:httpCode Body:body];
     } else if ( _status == 1 ) {
         [self checkSmsHandleRequest:httpCode Body:body];
     }
}

- (void) sendSmsHandleRequest:(int)httpCode Body:(NSDictionary*) body{
    if ( httpCode == 200 ) {
        // 服务器成功返回数据
        NSNumber* res = [body valueForKey:@"res"];
        int nRes = [res intValue];
        if ( nRes == 0 ) {
            // 调用成功
            NSString* token = [[body valueForKey:@"token"] copy];
            
            [_smsDelegate sendSMSCompleted:YES errMsg:nil token:token];
            
            [token release];
        } else {
            // 错误
            NSString* msg = [[body valueForKey:@"msg"] copy];
            
            // 重新登录过了，返回错误
            [_smsDelegate sendSMSCompleted:NO errMsg:msg token:nil];
            
            [msg release];
        }
    } else {
        [_smsDelegate sendSMSCompleted:NO errMsg:@"访问服务器错误" token:nil];
    }
}

- (void) bindHandleRequest:(int)httpCode Body:(NSDictionary*) body{
    if ( httpCode == 200 ) {
        // 服务器成功返回数据
        NSNumber* res = [body valueForKey:@"res"];
        int nRes = [res intValue];
        if ( nRes == 0 ) {
            // 调用成功
            NSString* token = [[body valueForKey:@"token"] copy];
            
            [_smsDelegate attachPhoneCompleted:YES Token:token errMsg:nil];
            
            [token release];
        } else {
            // 错误
            NSString* msg = [[body valueForKey:@"msg"] copy];
            
            // 重新登录过了，返回错误
            [_smsDelegate attachPhoneCompleted:NO Token:nil errMsg:msg];
            
            [msg release];
        }
    } else {
        [_smsDelegate attachPhoneCompleted:NO Token:nil errMsg:@"访问服务器错误"];
    }
}


- (void) checkSmsHandleRequest:(int)httpCode Body:(NSDictionary*) body{
    if ( httpCode == 200 ) {
        // 服务器成功返回数据
        NSNumber* res = [body valueForKey:@"res"];
        int nRes = [res intValue];
        if ( nRes == 0 ) {
            // 调用成功
            NSNumber* income = [body valueForKey:@"income"];
            NSNumber* outgo = [body valueForKey:@"outgo"];
            NSNumber* balance = [body valueForKey:@"balance"];
            NSNumber* shareIncome = [body valueForKey:@"shared_income"];
            NSNumber* boundNum = [body valueForKey:@"total_device"];
            NSString* inviter = [[body valueForKey:@"inviter"] copy];
            int nIncome = [income intValue];
            int nOutgo = [outgo intValue];
            int nBalance = [balance intValue];
            int nShareIncome = [shareIncome intValue];
            int nBoundNum = [boundNum intValue];
            [[LoginAndRegister sharedInstance] setIncome:nIncome];
            [[LoginAndRegister sharedInstance] setOutgo:nOutgo];
            [[LoginAndRegister sharedInstance] setBalance:nBalance];
            [[LoginAndRegister sharedInstance] setShareIncome:nShareIncome];
            [[LoginAndRegister sharedInstance] setInviter:inviter];
            
            NSString* userid = [[body valueForKey:@"userid"] copy];
            NSString* inviteCode = [[body valueForKey:@"invite_code"] copy];
            [_smsDelegate checkSmsCodeCompleted:YES errMsg:nil UserId:userid InviteCode:inviteCode boundPhoneNum:nBoundNum];
            
            [userid release];
            [inviteCode release];
            [inviter release];
        } else {
            // 错误
            NSString* msg = [[body valueForKey:@"msg"] copy];
            
            // 重新登录过了，返回错误
            [_smsDelegate checkSmsCodeCompleted:NO errMsg:msg UserId:nil InviteCode:nil boundPhoneNum:0];
            
            [msg release];
        }
    } else {
        [_smsDelegate checkSmsCodeCompleted:NO errMsg:@"访问服务器错误" UserId:nil InviteCode:nil boundPhoneNum:0];
    }
}

- (void) dealloc {
    [super dealloc];
}

@end
