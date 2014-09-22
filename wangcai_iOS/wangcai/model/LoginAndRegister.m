//
//  LoginAndRegister.m
//  wangcai
//
//  Created by 1528 on 13-12-9.
//  Copyright (c) 2013年 1528studio. All rights reserved.
//

#import "LoginAndRegister.h"
#import "Config.h"
#import "Common.h"
#import "CommonTaskList.h"
#import "../JPushlib/APService.h"
#import "MobClick.h"
#import "Common.h"
#import "ALSystem.h"
#import "Reachability.h"
#import "YouMiConfig.h"
#import "UtilityFunctions.h"
#import "ECManager.h"
#import "EcomConfig.h"

@implementation BalanceInfo
@synthesize _newBalance;
@synthesize _oldBalance;
@end

@implementation LoginAndRegister
static LoginAndRegister* _sharedInstance = nil;

+(id) sharedInstance {
    if ( _sharedInstance == nil ) {
        _sharedInstance = [[LoginAndRegister alloc]init];
    }
    return _sharedInstance;
}

- (id) init {
    [super init];
    self->_delegate = nil;
    self->loginStatus = Login_Error;
    self->_phoneNum = nil;
    self->_delegateArray = [[NSMutableArray alloc]init];
    self->_delegateBalanceArray = [[NSMutableArray alloc]init];
    self->_balance = 0;
    self->_firstLogin = YES;
    
    self->_showDomob = 0;
    self->_showYoumi = 0;
    self->_showMobsmar = 0;
    self->_showLimei = 0;
    self->_showMopan = 0;
    self->_showPunchBox = 0;
    self->_showMiidi = 0;
    self->_showJupeng = 0;
    self->_showDianru = 0;
    self->_showAdwo = 0;
    
    self->_phonePay = nil;
    self->_aliPay = nil;
    self->_qbiPay = nil;
    
    _tipsString = @"";
    
    return self;
}

- (void) dealloc {
    if ( _delegate != nil ) {
        [_delegate release];
    }
    
    [super dealloc];
}

-(LoginStatus) getLoginStatus {
    return loginStatus;
}

// session超时后，需要先设置超时，然后login
-(void) setTimeout { // 修改登录状态为已超时
    self->loginStatus = Login_Timeout;
}

-(void) sendEvent : (LoginStatus) status HttpCode:(int)httpCode ErrCode:(int)errCode Msg:(NSString*)msg {
    if (_delegate != nil ) {
        [_delegate loginCompleted:status HttpCode:httpCode ErrCode:errCode Msg:msg];
    }
}

-(void) login: (id) delegate {
    [self login];
    _delegate = [delegate retain];
}

- (NSString*) getNetworkInfo {
    Reachability* r = [Reachability reachabilityWithHostName:@"app.getwangcai.com"];
    NSInteger state = [r currentReachabilityStatus];
    if ( state == ReachableViaWiFi ) {
        return [[@"wifi" copy] autorelease];
    } else if ( state == ReachableViaWWAN ) {
        return [[@"3g" copy] autorelease];
    }
    
    return [[@"none" copy] autorelease];
}

- (NSHTTPCookie*) getCookie {
    NSMutableDictionary* properties = [[[NSMutableDictionary alloc] init] autorelease];
    
    [properties setValue:@".getwangcai.com" forKey:NSHTTPCookieDomain];
    [properties setValue:[NSDate dateWithTimeIntervalSinceNow:60*60] forKey:NSHTTPCookieExpires];
    [properties setValue:@"/asi-http-request/wangcai" forKey:NSHTTPCookiePath];
    
    [properties setValue:@"p" forKey:NSHTTPCookieName];
    
    NSString* sysModel = [Common deviceModel];
    NSString* sysVer = [[UIDevice currentDevice] systemVersion];
    NSDictionary* dic = [[NSBundle mainBundle] infoDictionary];
    NSString* appVersion = [dic valueForKey:@"CFBundleVersion"];
    NSString* network = [self getNetworkInfo];
    NSString* localIP = [Common localIPAddress];
    
    NSString* info = [[[NSString alloc] initWithFormat:@"%@_%@; app=%@; ver=%@; net=%@;  local_ip=%@", sysModel, sysVer, APP_NAME, appVersion, network, localIP] autorelease];
    [properties setValue:info forKey:NSHTTPCookieValue];
    
    NSHTTPCookie* cookie = [[[NSHTTPCookie alloc] initWithProperties:properties] autorelease];
    
    return cookie;
}

-(void) login {
    // 发起登录或注册请求
    if ( _delegate != nil ) {
        [_delegate release];
        _delegate = nil;
    }
    
    self->loginStatus = Login_In;

    BeeHTTPRequest* req = self.HTTP_POST(HTTP_LOGIN_AND_REGISTER);
    NSString* nsParam = [[NSString alloc]init];
    
    NSHTTPCookie* cookie = [self getCookie];
    [req setRequestCookies:[NSMutableArray arrayWithObject:cookie]];
    
    if ( _phoneNum != nil ) {
        // 应该在登录成功后设置
        nsParam = [nsParam stringByAppendingFormat:@"phone=%@&", _phoneNum];
    }
    
    
    NSString* idfa = [Common getIDFAAddress];
    nsParam = [nsParam stringByAppendingFormat:@"idfa=%@&", idfa];

    NSString* mac = [Common getMACAddress];
    nsParam = [nsParam stringByAppendingFormat:@"mac=%@&", mac];
    
    NSString* timestamp = [Common getTimestamp];
    nsParam = [nsParam stringByAppendingFormat:@"timestamp=%@", timestamp];

#if TARGET_VERSION_LITE == 2 
    // 亲友版带上openudid
    NSString* openUdid = [OpenUDID value];
    nsParam = [nsParam stringByAppendingFormat:@"&openudid=%@", openUdid];
#endif
    
    NSMutableData* data = [[NSMutableData alloc] init];
    
    
    NSString* encodedString = [nsParam stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    //[nsParam release];
    
    const char * a =[encodedString UTF8String];

    req.HEADER(@"Content-Type", @"application/x-www-form-urlencoded");
    [data appendBytes:a length:strlen(a)];
    
    // 设置https访问证书
    [req setValidatesSecureCertificate:NO];
    //[req setClientCertificateIdentity: [Common getSecIdentityRef]];
    //
    
    req.postBody = [[data copy] autorelease];
    
    req.TIMEOUT(10);
    
    [data release];
}

- (void) setLoginStatus : (LoginStatus) status HttpCode:(int)code ErrCode:(int) errCode Msg:(NSString*) msg {
    self->loginStatus = status;
    
    [self sendEvent:status HttpCode:code ErrCode:errCode Msg:msg];
}

- (void) handleRequest:(BeeHTTPRequest *)req {
    if ( req.sending) {
    } else if ( req.recving ) {
    } else if ( req.failed ) {
        //统计]
        [MobClick event:@"http_request_failed" attributes:@{@"url":[req.url absoluteString],@"status_code":[NSString stringWithFormat:@"%d",req.responseStatusCode]}];
        [MobClick event:@"login_failed" attributes:@{@"reason":@"服务器状态码错误",@"status_code":[NSString stringWithFormat:@"%d",req.responseStatusCode]}];
        
        //
        [self setLoginStatus:Login_Error HttpCode:req.responseStatusCode ErrCode:0 Msg:nil];
    } else if ( req.succeed ) {
        // 判断返回数据是
        
        NSError* error;
        NSDictionary* dict = [NSJSONSerialization JSONObjectWithData:req.responseData options:NSJSONReadingMutableLeaves error:&error];
        if ( dict == nil || [dict count] == 0 ) {
            [self setLoginStatus:Login_Error HttpCode:req.responseStatusCode ErrCode:0 Msg:nil];
        } else {
            NSNumber* res = [dict valueForKey:@"res"];
            if ( [res intValue] == 0 ) {
                _userid = [[dict valueForKey:@"userid"] copy];
                _session_id = [[dict valueForKey:@"session_id"] copy];
                _nickname = [[dict valueForKey:@"nickname"] copy];
                _device_id = [[dict valueForKey:@"device_id"] copy];
                _phoneNum = [[dict valueForKey:@"phone"] copy];
                _tipsString = [[dict valueForKey:@"tips"] copy];
                if ([_tipsString length] == 0)
                {
                    _tipsString = @"";
                }
                
                NSNumber* num = [dict valueForKey:@"balance"];
                int nOldBalance = _balance;
                
                _balance = [num intValue];
                num = [dict valueForKey:@"income"];
                _income = [num intValue];
                
                num = [dict valueForKey:@"outgo"];
                _outgo = [num intValue];
                
                num = [dict valueForKey:@"recent_income"];
                _recentIncome = [num intValue];
                
                _inviter = [[dict valueForKey:@"inviter"] copy];
                _invite_code = [[dict valueForKey:@"invite_code"] copy];
                
                _inviteIncome = [[dict valueForKey:@"shared_income"] intValue];
                _force_update = [[dict valueForKey:@"force_update"] intValue];
                
                _nowithdraw = [[dict valueForKey:@"no_withdraw"] intValue];
                
                _inReview = [[dict valueForKey:@"in_review"] intValue];
              
                _offerwallIncome = [[dict valueForKey:@"offerwall_income"] intValue];
                
                _pollingInterval = [[dict valueForKey:@"polling_interval"] intValue];
                if ( _pollingInterval < 5 ) {
                    _pollingInterval = 5;
                }

                if ( _inReview == 1 ) {
                    [YouMiConfig setIsTesting:YES];
                    // 初始化电商墙
                    [EcomConfig setIsTesting:NO];
                    [EcomConfig setUserID:@"thisisuser"];
                    [EcomConfig launchWithAppID:@"76f21df6134acdee" appSecret:@"b914719dcac278e9"];
                    
                    [ECManager ecWallPreload];
                }
                
                NSDictionary* offerwall = [dict valueForKey:@"offerwall"];
                if ( [[offerwall allKeys] containsObject:@"domob"] ) {
                    _showDomob = [[offerwall valueForKey:@"domob"] intValue];
                }
                
                if ( [[offerwall allKeys] containsObject:@"youmi"] ) {
                    _showYoumi = [[offerwall valueForKey:@"youmi"] intValue];
                }
                
                if ( [[offerwall allKeys] containsObject:@"mobsmar"] ) {
                    _showMobsmar = [[offerwall valueForKey:@"mobsmar"] intValue];
                }
                
                if ( [[offerwall allKeys] containsObject:@"limei"] ) {
                    _showLimei = [[offerwall valueForKey:@"limei"] intValue];
                }
            
                if ( [[offerwall allKeys] containsObject:@"mopan"] ) {
                    _showMopan = [[offerwall valueForKey:@"mopan"] intValue];
                }
                
                if ( [[offerwall allKeys] containsObject:@"punchbox"] ) {
                    _showPunchBox = [[offerwall valueForKey:@"punchbox"] intValue];
                }
                
                if ( [[offerwall allKeys] containsObject:@"miidi"] ) {
                    _showMiidi = [[offerwall valueForKey:@"miidi"] intValue];
                }
                
                if ( [[offerwall allKeys] containsObject:@"jupeng"] ) {
                    _showJupeng = [[offerwall valueForKey:@"jupeng"] intValue];
                }
                
                if ( [[offerwall allKeys] containsObject:@"dianru"] ) {
                    _showDianru = [[offerwall valueForKey:@"dianru"] intValue];
                }
                
                if ( [[offerwall allKeys] containsObject:@"adwo"] ) {
                    _showAdwo = [[offerwall valueForKey:@"adwo"] intValue];
                }

#if TEST == 1
                _showLimei = 0;
                _showMopan = 3;
                _showYoumi = 1;
                _showMobsmar = 3;
                _showDomob = 0;
                _showPunchBox = 0;
                _showMiidi = 0;
                _showJupeng = 3;
                _showDianru = 3;
                _showAdwo = 3;
#endif

                [self initWithDraw:dict];
                
                int userLevel = [[dict valueForKey:@"level"] intValue];
                int currentEXP = [[dict valueForKey:@"exp_current"] intValue];
                int nextLevelEXP = [[dict valueForKey:@"exp_next_level"] intValue];
                int benefit = [[dict valueForKey:@"benefit"] intValue];
                
                if (userLevel > 0)
                {
                    [[LoginAndRegister sharedInstance] setUserLevel:userLevel];
                    [[LoginAndRegister sharedInstance] setCurrentExp:currentEXP];
                    [[LoginAndRegister sharedInstance] setNextLevelExp:nextLevelEXP];
                    if (benefit > 0)
                    {
                        [[LoginAndRegister sharedInstance] setBenefit:benefit];
                    }
                }
                
                NSArray* taskList = [dict objectForKey:@"task_list"];
                
                [[CommonTaskList sharedInstance] resetTaskListWithJsonArray:taskList];

                [self RegisterDeviceIDToAPService];
                
                [self setLoginStatus:Login_Success HttpCode:req.responseStatusCode ErrCode:[res intValue] Msg:nil];
                
                if ( _firstLogin ) {
                    _firstLogin = NO;
                } else {
                    // 钱币变化的通知
                    if ( nOldBalance != _balance ) {
                        [self fire_balanceChanged:nOldBalance New:_balance];
                    }
                }
            } else {
                NSString* err = [[dict valueForKey:@"msg"] copy];
                
                [MobClick event:@"login_failed" attributes:@{@"reason":[err length]==0?@"服务器状态码错误":err,@"device_idfa":[Common getIDFAAddress],@"res":[res stringValue]}];
                
                [self setLoginStatus:Login_Error HttpCode:req.responseStatusCode ErrCode:[res intValue] Msg:err];
            }
        }
    }
}

- (void) initWithDraw:(NSDictionary*) dict {
    NSArray* withDraw = (NSArray*)[dict valueForKey:@"withdraw_config"];
    if ( withDraw == nil ) {
        return ;
    }
    
    if ( _aliPay != nil ) {
        [_aliPay release];
    }
    if ( _qbiPay != nil ) {
        [_qbiPay release];
    }
    if ( _phonePay != nil ) {
        [_phonePay release];
    }
    
    for (int i = 0; i < [withDraw count]; i ++ ) {
        NSDictionary* item = (NSDictionary*)[withDraw objectAtIndex:i];
        int nType = [[item objectForKey:@"type"] intValue];
        if ( nType == 1 ) {
            // 支付宝
            _aliPay = [(NSArray*)[item objectForKey:@"info"] copy];
        } else if ( nType == 2 ) {
            // 话费
            _phonePay = [(NSArray*)[item objectForKey:@"info"] copy];
        } else if ( nType == 4 ) {
            // Q币
            _qbiPay = [(NSArray*)[item objectForKey:@"info"] copy];
        }
    }
}

-(int) getPollingInterval {
    return _pollingInterval;
}

-(int) getUserLevel
{
    return _userLevel;
}

-(void) setUserLevel:(int)level
{
    if (_userLevel != 0 && level > _userLevel)
    {
        _hasLevelUp = YES;
    }
    if (_benefit == 0)
    {
        _benefit = level;
    }
    _userLevel = level;
}

-(int) getCurrentExp
{
    return _currentEXP;
}

-(void) setCurrentExp:(int)exp
{
    _currentEXP = exp;
}

-(int) getNextLevelExp
{
    return _nextLevelEXP;
}

-(void) setNextLevelExp:(int)exp
{
    _nextLevelEXP = exp;
}

-(int) getBenefit
{
    return _benefit;
}

-(void) setBenefit:(int)benefit
{
    _benefit = benefit;
}

-(BOOL)checkAndConsumeLevel
{
    BOOL ret = NO;
    if (_hasLevelUp)
    {
        ret = YES;
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationNameLevelUp object:nil];
    }
    _hasLevelUp = NO;
    return ret;
}

-(BOOL) isInReview {
    if ( _inReview == 1 ) {
        return YES;
    }
    return NO;
}

-(void)RegisterDeviceIDToAPService {
    NSString* deviceid = [[LoginAndRegister sharedInstance] getDeviceId];
    if ( deviceid != nil ) {
        [APService setTags:[NSSet setWithObjects:nil] alias:deviceid callbackSelector:@selector(tagsAliasCallback:tags:alias:) target:self];
    }
    
    if ( deviceid != nil ) {
        [deviceid release];
    }
}

- (void)tagsAliasCallback:(int)iResCode tags:(NSSet*)tags alias:(NSString*)alias {
    if (DEBUG_PUSH)
    {
        [UtilityFunctions debugAlertView:@"推送测试（正式版不出现）" content:[NSString stringWithFormat:@"[Push] 收到通知, tags:\[{\n%@\n}]\",\n alias:\[{\n%@\n}]\"",tags,alias]];
    }
}

-(int) getForceUpdate {
    return _force_update;
}

-(void) increaseBalance:(int) inc {
    int oldBalance = _balance;
    _balance = _balance + inc;
    
    if ( inc > 0 ) { //总收入
        _income = _income + inc;
    } else {
        _outgo = _outgo - inc;
    }
    
    [self fire_balanceChanged:oldBalance New:_balance];
}

-(void) setBalance:(int) balance {
    if ( balance != _balance ) {
        int oldBalance = _balance;
        _balance = balance;
    
        [self fire_balanceChanged:oldBalance New:_balance];
    }
}

-(void) setShareIncome:(int) nShareIncome {
    self->_inviteIncome = nShareIncome;
}
-(void) setInviter:(NSString*) inviter {
    if ( inviter ==nil || [inviter length] == 0 ) {
        return ;
    }
    
    if ( _inviter != nil ) {
        [_inviter release];
    }
    _inviter = [inviter copy];
}

-(void) fire_balanceChanged:(int) old New:(int) balance {
    BalanceInfo* info = [[BalanceInfo alloc]init];
    info._newBalance = balance;
    info._newBalance = old;
    [self postNotification:@"balanceChanged" withObject:info];
    [info release];
    
    for ( int i = 0; i < [_delegateBalanceArray count]; i ++ ) {
        id delegate = [_delegateBalanceArray objectAtIndex:i];
        [delegate balanceChanged:old New:balance];
    }
}

-(void) fire_bindPhoneEvent {
    for ( int i = 0; i < [_delegateArray count]; i ++ ) {
        id delegate = [_delegateArray objectAtIndex:i];
        [delegate bindPhoneCompeted];
    }
}

-(void) attachBindPhoneEvent : (id) delegate {
    [_delegateArray addObject:[delegate retain]];
}

-(void) detachBindPhoneEvent : (id) delegate {
    [_delegateArray removeObject:delegate];
    [delegate release];
}

-(void) attachBalanceChangeEvent : (id) delegate {
    [_delegateBalanceArray addObject:[delegate retain]];
}

-(void) detachBalanceChangeEvent : (id) delegate {
    [_delegateBalanceArray removeObject:delegate];
    [delegate release];
}

-(void) attachPhone : (NSString*) phoneNum UserId:(NSString*) userid InviteCode:(NSString*) inviteCode {
    if ( _invite_code != nil ) {
        [_invite_code release];
    }
    
    _invite_code = [inviteCode copy];
    
    if ( _phoneNum != nil ) {
        [_phoneNum release];
    }
    
    _phoneNum = [phoneNum copy];
    
    if ( _userid != nil ) {
        [_userid release];
    }
    
    _userid = [userid copy];
    
    [self fire_bindPhoneEvent];
}

-(NSString*) getPhoneNum {
    if ( self->_phoneNum == nil ) {
        return nil;
    }
    return [self->_phoneNum copy];
}

-(NSString*) getUserId  {
    if ( self->_userid == nil ) {
        return nil;
    }
    return [self->_userid copy];
}

-(NSString*) getSessionId  {
    if ( self->_session_id == nil ) {
        return nil;
    }
    return [self->_session_id copy];
}

-(NSString*) getNickName  {
    if ( self->_nickname == nil ) {
        return nil;
    }
    return [self->_nickname copy];
}

-(NSString*) getDeviceId  {
    if ( self->_device_id == nil ) {
        return nil;
    }
    return [self->_device_id copy];
}

-(int) getBalance {
    return _balance;
}

-(NSString*) getInviteCode {
    if ( self->_invite_code== nil ) {
        return nil;
    }
    return [self->_invite_code copy];
}

-(NSString*) getInviter {
    if ( self->_inviter== nil ) {
        return nil;
    }
    return [self->_inviter copy];
}

-(int) getIncome {
    return _income;
}

-(int) getOutgo {
    return _outgo;
}

-(void) setIncome:(int) income {
    _income = income;
}

-(void) setOutgo:(int) outgo {
    _outgo = outgo;
}

-(int) getRecentIncome {
    return _recentIncome;
}

-(int) getInviteIncome {
    return _inviteIncome;
}

-(BOOL) isShowDomob {
    if ( _showDomob == 0 ) {
        return NO;
    }
    return YES;
}

-(BOOL) isShowYoumi {
    if ( _showYoumi == 0 ) {
        return NO;
    }
    return YES;
}

-(BOOL) isShowLimei {
    if ( _showLimei == 0 ) {
        return NO;
    }
    return YES;
}

-(BOOL) isShowMobsmar {
    if ( _showMobsmar == 0 ) {
        return NO;
    }
    return YES;
}

-(BOOL) isShowMopan {
    if ( _showMopan == 0 ) {
        return NO;
    }
    return YES;
}

-(BOOL) isShowPunchBox {
    if ( _showPunchBox == 0 ) {
        return NO;
    }
    return YES;
}

-(BOOL) isShowMiidi {
    if ( _showMiidi == 0 ) {
        return NO;
    }
    return YES;
}

-(BOOL) isShowJupeng {
    if ( _showJupeng == 0 ) {
        return NO;
    }
    return YES;
}

-(BOOL) isShowDianru {
    if ( _showDianru == 0 ) {
        return NO;
    }
    return YES;
}

-(BOOL) isShowAdwo {
    if ( _showAdwo == 0 ) {
        return NO;
    }
    return YES;
}


-(BOOL) isInMoreDomob {
    if ( _showDomob == 3 ) {
        return YES;
    }
    return NO;
}

-(BOOL) isInMoreYoumi {
    if ( _showYoumi == 3 ) {
        return YES;
    }
    return NO;
}

-(BOOL) isInMoreLimei {
    if ( _showLimei == 3 ) {
        return YES;
    }
    return NO;
}

-(BOOL) isInMoreMobsmar {
    if ( _showMobsmar == 3 ) {
        return YES;
    }
    return NO;
}

-(BOOL) isInMoreMopan {
    if ( _showMopan == 3 ) {
        return YES;
    }
    return NO;
}

-(BOOL) isInMorePunchBox {
    if ( _showPunchBox == 3 ) {
        return YES;
    }
    return NO;
}

-(BOOL) isInMoreAdwo {
    if ( _showAdwo == 3 ) {
        return YES;
    }
    return NO;
}

-(BOOL) isInMoreMiidi {
    if ( _showMiidi == 3 ) {
        return YES;
    }
    return NO;
}

-(BOOL) isInMoreJupeng {
    if ( _showJupeng == 3 ) {
        return YES;
    }
    return NO;
}

-(BOOL) isInMoreDianru {
    if ( _showDianru == 3 ) {
        return YES;
    }
    return NO;
}

-(BOOL) isRecommendDomob {
    if ( _showDomob == 2 ) {
        return YES;
    }
    return NO;
}

-(BOOL) isRecommendYoumi {
    if ( _showYoumi == 2 ) {
        return YES;
    }
    return NO;
}

-(BOOL) isRecommendLimei {
    if ( _showLimei == 2 ) {
        return YES;
    }
    return NO;
}

-(BOOL) isRecommendMobsmar {
    if ( _showMobsmar == 2 ) {
        return YES;
    }
    return NO;
}

-(BOOL) isRecommendMopan {
    if ( _showMopan == 2 ) {
        return YES;
    }
    return NO;
}

-(BOOL) isRecommendPunchBox {
    if ( _showPunchBox == 2 ) {
        return YES;
    }
    return NO;
}

-(BOOL) isRecommendMiidi {
    if ( _showMiidi == 2 ) {
        return YES;
    }
    return NO;
}

-(BOOL) isRecommendAdwo {
    if ( _showAdwo == 2 ) {
        return YES;
    }
    return NO;
}

-(BOOL) isRecommendJupeng {
    if ( _showJupeng == 2 ) {
        return YES;
    }
    return NO;
}

-(BOOL) isRecommendDianru {
    if ( _showDianru == 2 ) {
        return YES;
    }
    return NO;
}

-(int) getNoWithDraw {
    return _nowithdraw;
}

-(NSString*) getTipsStrings
{
    return _tipsString;
}

-(int) getOfferwallIncome {
    return _offerwallIncome;
}

-(NSArray*) getPhonePay {
    return _phonePay;
}

-(NSArray*) getAlipay {
    return _aliPay;
}

-(NSArray*) getQbiPay {
    return _qbiPay;
}

@end
