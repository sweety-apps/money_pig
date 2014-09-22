//
//  HttpRequest.m
//  wangcai
//
//  Created by 1528 on 13-12-21.
//  Copyright (c) 2013年 1528studio. All rights reserved.
//

#import "HttpRequest.h"
#import "Common.h"
#import "Encryption.h"
#import "Config.h"
#import "MobClick.h"

@implementation HttpRequest

@synthesize extensionContext;

- (id) init : (id) delegate {
    self = [super init];
    if ( self ) {
        _delegate = [delegate retain];
        _request = nil;
        _relogin = NO;
        _param = nil;
        _url = nil;
        _method = nil;
    }
    return self;
}

- (void) dealloc {
    if ( _delegate != nil ) {
        [_delegate release];
    }
    if ( _param != nil ) {
        [_param release];
    }
    if ( _url != nil ) {
        [_url release];
    }
    self.extensionContext = nil;
    [super dealloc];
}

- (void) request : (NSString*) url Param:(NSDictionary*) params {
    [self request:url Param:params method:@"post"];
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
    
    NSString* info = [[[NSString alloc] initWithFormat:@"%@_%@; app=%@; ver=%@; net=%@; local_ip=%@", sysModel, sysVer, APP_NAME, appVersion, network, localIP] autorelease];
    
    [properties setValue:info forKey:NSHTTPCookieValue];
    
    NSHTTPCookie* cookie = [[[NSHTTPCookie alloc] initWithProperties:properties] autorelease];
    
    return cookie;
}

- (void) request : (NSString*) url Param:(NSDictionary*) params method:(NSString*)getOrPost
{
    [self request:url Param:params method:getOrPost Aes:NO];
}

- (void) request : (NSString*) url Param:(NSDictionary*) params method:(NSString*)getOrPost Aes:(BOOL) aes
{
    if ([getOrPost length] == 0)
    {
        getOrPost = @"post";
    }
    
    _aes = aes;
    
    getOrPost = [getOrPost lowercaseString];
    NSString* newUrl = [[self BuildURL:url] autorelease];
    
    if ( _method != nil ) {
        [_method release];
    }
    
    _method = [getOrPost copy];
    
    if ([getOrPost isEqualToString:@"get"] && params != nil ) {
        NSArray* keys = [params allKeys];
        int nCount = [keys count];
        for (int i = 0; i < nCount; i ++ ) {
            id key = [keys objectAtIndex:i];
            id value = [params objectForKey:key];
            
            newUrl = [newUrl stringByAppendingFormat:@"&%@=%@", key, value];
        }
    }
    
    if ([getOrPost isEqualToString:@"get"])
    {
        _request = self.HTTP_GET(newUrl);
    }
    else if([getOrPost isEqualToString:@"post"])
    {
        _request = self.HTTP_POST(newUrl);
    }
    else
    {
        _request = self.HTTP_POST(newUrl);
    }
    
    // 设置https访问证书
    [_request setValidatesSecureCertificate:NO];
    //[_request setClientCertificateIdentity: [Common getSecIdentityRef]];
    //
    
    NSHTTPCookie* cookie = [self getCookie];
    [_request setRequestCookies:[NSMutableArray arrayWithObject:cookie]];
    
    if ( _url != nil ) {
        [_url release];
    }
    _url = [newUrl copy];
    
    if ( _param != nil ) {
        [_param release];
        _param = nil;
    }
    
    if([getOrPost isEqualToString:@"post"]) {
        NSString* nsParam = [[NSString alloc]init];
        
        if ( params != nil ) {
            NSArray* keys = [params allKeys];
            int nCount = [keys count];
            for (int i = 0; i < nCount; i ++ ) {
                id key = [keys objectAtIndex:i];
                id value = [params objectForKey:key];
                
                if ( i == nCount - 1 ) {
                    nsParam = [nsParam stringByAppendingFormat:@"%@=%@", key, value];
                } else {
                    nsParam = [nsParam stringByAppendingFormat:@"%@=%@&", key, value];
                }
            }
        }
        
        _param = [nsParam copy];
        
        NSMutableData* data = [[[NSMutableData alloc] init] autorelease];
        
        
        NSString* encodedString = [nsParam stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        _request.HEADER(@"Content-Type", @"application/x-www-form-urlencoded");
        
        const char * a =[encodedString UTF8String];
        if ( _aes ) {
            // 加密
            NSData* oldData = [encodedString dataUsingEncoding:NSUTF8StringEncoding];
            NSData* tmpData = [oldData AES256EncryptWithKey:AES_KEY];
            
            [data appendData:tmpData];
        } else {
            [data appendBytes:a length:strlen(a)];
        }
        
        _request.postBody = [[data copy] autorelease];
    }
    
    _request.TIMEOUT(10);
}

- (void) handleRequest:(BeeHTTPRequest *)req {
    if ( req.sending) {
    } else if ( req.recving ) {
    } else if ( req.failed ) {
        //统计
        [MobClick event:@"http_request_failed" attributes:@{@"url":[req.url absoluteString],@"device_id":[[LoginAndRegister sharedInstance] getDeviceId],@"status_code":[NSString stringWithFormat:@"%d",req.responseStatusCode]}];
        
        if ( _delegate != nil ) {
            [_delegate HttpRequestCompleted:self HttpCode:req.responseStatusCode Body:nil];
        }
        _relogin = NO;
    } else if ( req.succeed ) {
        // 判断返回数据是
        NSError* error;
        NSDictionary* dict = [NSJSONSerialization JSONObjectWithData:req.responseData options:NSJSONReadingMutableLeaves error:&error];
        if ( dict == nil || [dict count] == 0 ) {
            if ( _delegate != nil ) {
                [_delegate HttpRequestCompleted:self HttpCode:req.responseStatusCode Body:nil];
            }
            _relogin = NO;
        } else {
            NSNumber* res = [dict valueForKey:@"res"];
            if ( [res intValue] == 0 ) {
                if ( _delegate != nil ) {
                    [_delegate HttpRequestCompleted:self HttpCode:req.responseStatusCode Body:dict];
                }
                _relogin = NO;
            } else {
                if ( [res intValue] == 401 && !_relogin ) {
                    [self relogin];
                } else {
                    if ( _delegate != nil ) {
                        [_delegate HttpRequestCompleted:self HttpCode:req.responseStatusCode Body:dict];
                    }
                    _relogin = NO;
                }
            }
        }
    }
}

-(void) relogin {
    [[LoginAndRegister sharedInstance] login:self];
}


- (NSString*) BuildURL :(NSString*) url {
    id userid = [[LoginAndRegister sharedInstance] getUserId];
    id sessionid = [[LoginAndRegister sharedInstance]getSessionId];
    id deviceid = [[LoginAndRegister sharedInstance] getDeviceId];
    
    NSString* newUrl = [[NSString alloc] initWithFormat:@"%@?session_id=%@&device_id=%@&userid=%@",
                        url, sessionid, deviceid, userid];
    
    [userid release];
    [sessionid release];
    [deviceid release];
    
    return newUrl;
}

- (void) request {
    // 替换url中session
    NSString* url = [[_url copy] autorelease];
    NSRange range = [url rangeOfString:@"session_id="];
    if ( range.length != 0 ) {
        NSString* left = [url substringToIndex:range.location + range.length];
        NSString* right = [url substringFromIndex:range.location + range.length];
        NSRange range2 = [right rangeOfString:@"&"];
        NSString* right2 = [right substringFromIndex:range2.location];
        id sessionid = [[[LoginAndRegister sharedInstance]getSessionId] autorelease];
        url = [[[NSString alloc]initWithFormat:@"%@%@%@", left, sessionid, right2] autorelease];
    }
    
    if ( [_method isEqualToString:@"get"] ) {
        _request = self.HTTP_GET(url);
    } else {
        _request = self.HTTP_POST(url);
    }
    
    NSMutableData* data = [[NSMutableData alloc] init];
    
    if(_param == nil)
    {
        _param = @"";
    }
    
    NSString* encodedString = [_param stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    _request.HEADER(@"Content-Type", @"application/x-www-form-urlencoded");
    
    const char * a =[encodedString UTF8String];
    if ( _aes ) {
        // 加密
        NSData* oldData = [encodedString dataUsingEncoding:NSUTF8StringEncoding];
        NSData* tmpData = [oldData AES256EncryptWithKey:AES_KEY];
        [data appendData:tmpData];
    } else {
        [data appendBytes:a length:strlen(a)];
    }
    
    // 设置https访问证书
    [_request setValidatesSecureCertificate:NO];
    //[_request setClientCertificateIdentity: [Common getSecIdentityRef]];
    //
    
    _request.postBody = [[data copy] autorelease];
    
    _request.TIMEOUT(10);
    
    [data release];
}


-(void) loginCompleted : (LoginStatus) status HttpCode:(int)httpCode ErrCode:(int)errCode Msg:(NSString*) msg {
    if ( status == Login_Success ) {
        // 重新请求
        _relogin = YES;
        
        //
        if ( [[LoginAndRegister sharedInstance] getForceUpdate] == 1 ) {
            UIAlertView* alertForceUpdate = [[[UIAlertView alloc]initWithTitle:@"升级" message:@"为了您红包的安全，需要升级之后才能继续使用。" delegate:self cancelButtonTitle:@"升级" otherButtonTitles:nil, nil] autorelease];
            [alertForceUpdate show];
            
        } else {
            [self request];
        }
    } else {
        if ( _delegate != nil ) {
            [_delegate HttpRequestCompleted:self HttpCode:httpCode Body:nil];
        }
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    NSString* sysVer = [[UIDevice currentDevice] systemVersion];
    NSString* urlStr = [[[NSString alloc] initWithFormat:@"%@?sysVer=%@", WEB_FORCE_UPDATE, sysVer] autorelease];
    
    NSURL* url = [NSURL URLWithString:urlStr];
    [[UIApplication sharedApplication] openURL:url];
    
    exit(0);
}

@end
