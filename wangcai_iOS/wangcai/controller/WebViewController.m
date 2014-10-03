//
//  WebViewController.m
//  wangcai
//
//  Created by 1528 on 13-12-13.
//  Copyright (c) 2013年 1528studio. All rights reserved.
//

#import "WebViewController.h"
#import "PhoneValidationController.h"
#import "TransferToAlipayAndPhoneController.h"
#import "WebPageController.h"
#import "Config.h"
#import "Common.h"
#import "MBHUDView.h"
#import "MobClick.h"
#import "EGORefreshTableHeaderView.h"

@interface WebViewController ()

@end

@implementation WebViewController

- (id)init
{
    self = [super initWithNibName:@"WebViewController" bundle:nil];
    if (self) {
        // Custom initialization
        self.view = [[[NSBundle mainBundle] loadNibNamed:@"WebViewController" owner:self options:nil] firstObject];
        self->_webView = (UIWebView*)[self.view viewWithTag:11];
        self->_webView.delegate = self;
        self->_webView.scrollView.delegate = self;
        
        _delegate = nil;
        self->_refreshHeader = false;
        
        self->_loadingView = [[[NSBundle mainBundle] loadNibNamed:@"WebViewController" owner:self options:nil] objectAtIndex:1];
        [self.view addSubview:self->_loadingView];
        
        self->_errView = [[[NSBundle mainBundle] loadNibNamed:@"WebViewController" owner:self options:nil] objectAtIndex:2];
        [self.view addSubview:self->_errView];
        
        [self->_webView setHidden:YES];
        [self->_errView setHidden:YES];
        
        self->_alertBindPhone = nil;
        self->_alertNoBalance = nil;
        
        _alert = nil;
        _nsCallback = nil;
        _nsBtn2ID = nil;
        
        if ( _refreshHeaderView == nil ) {
            _refreshHeaderView = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0, 0-_webView.scrollView.bounds.size.height, _webView.scrollView.frame.size.width, _webView.scrollView.bounds.size.height)];
            _refreshHeaderView.delegate = self;
            [_webView.scrollView addSubview:_refreshHeaderView];
        }
        
        [_refreshHeaderView refreshLastUpdatedDate];
        
        //
        [[LoginAndRegister sharedInstance] attachBindPhoneEvent:self];
        [[LoginAndRegister sharedInstance] attachBalanceChangeEvent:self];
    }
    return self;
}

- (void)setSize:(CGSize) size {
    _size = size;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)setBeeUIStack:(BeeUIStack*) beeStack {
    _beeStack = beeStack;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) bindPhoneCompeted {
    NSString* phoneNum = [[LoginAndRegister sharedInstance] getPhoneNum];
    float banlance = (1.0*[[LoginAndRegister sharedInstance] getBalance]) / 100;
    [self notifyPhoneStatus:YES Phone:phoneNum Balance:banlance];
    [phoneNum release];
}

-(void) balanceChanged:(int) oldBalance New:(int) balance {
    [self notifyBalanceToWeb];
}

- (void)dealloc {
    [[LoginAndRegister sharedInstance] detachBindPhoneEvent:self];
    [[LoginAndRegister sharedInstance] detachBalanceChangeEvent:self];
    
    self->_webView = nil;
    self->_url = nil;
    if (_url)
    {
        [_url release];
        _url = nil;
    }
    
    [self->_loadingView release];
    self->_loadingView = nil;
    
    [self->_errView release];
    self->_errView = nil;
    
    self->_beeStack = nil;
    _delegate = nil;
    
    if ( _alert != nil ) {
        [_alert release];
    }
    if ( _nsCallback != nil ) {
        [_nsCallback release];
    }
    if ( _nsCallback != nil ) {
        [_nsBtn2ID release];
    }
    
    if ( _alertBindPhone != nil ) {
        [_alertBindPhone release];
    }
    
    if ( _alertNoBalance != nil ) {
        [_alertNoBalance release];
    }
    
    [super dealloc];
}

- (void)setNavigateUrl:(NSString*)url {
    if (_url)
    {
        [_url release];
        _url = nil;
    }
    _url = [url retain];
    
    CGRect rect = self.view.frame;
    rect.origin.y = 0;
    self->_webView.frame = rect;
    
    self->_refreshHeader = false;
    NSURL* nsurl = [[NSURL alloc] initWithString:url];
    [self->_webView loadRequest:[NSURLRequest requestWithURL:nsurl]];
    [nsurl release];
}

-(NSString*) getValueFromQuery:(NSString*) query Key:(NSString*) key {
    NSString* findKey = [[NSString alloc]initWithFormat:@"%@=", key];
    NSRange range = [query rangeOfString:findKey];
    [findKey release];
    if ( range.length != 0 ) {
        NSString* tmp = [query substringFromIndex:(range.location + range.length)];
        range = [tmp rangeOfString:@"&"];
        if ( range.length != 0 ) {
            tmp = [tmp substringToIndex:range.location];
        }
        
        return [[tmp copy]autorelease];
    }
    
    return nil;
}

-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    NSString* query = [request.mainDocumentURL query];
    
    if ( [request.mainDocumentURL.relativePath isEqualToString:@"/wangcai_js/query_attach_phone"] ) {
        // 查询手机是否已经绑定
        NSString* phoneNum = [[LoginAndRegister sharedInstance] getPhoneNum];
        if ( phoneNum == nil || [phoneNum isEqualToString:@""] ) {
            if ( phoneNum != nil ) {
                [phoneNum release];
            }
            
            float banlance = (1.0*[[LoginAndRegister sharedInstance] getBalance]) / 100;
            [self notifyPhoneStatus:NO Phone:@"" Balance:banlance];
        } else {
            float banlance = (1.0*[[LoginAndRegister sharedInstance] getBalance]) / 100;
            [self notifyPhoneStatus:YES Phone:phoneNum Balance:banlance];
            [phoneNum release];
        }
        
        return NO;
    } else if ( [request.mainDocumentURL.relativePath isEqualToString:@"/wangcai_js/query_balance"] ) {
        // 把钱的信息返回给页面
        [self notifyBalanceToWeb];
        return NO;
    } else if ( [request.mainDocumentURL.relativePath isEqualToString:@"/wangcai_js/query_device_info"] ) {
        // 查询设备信息
        [self notifyDeviceInfo];
        return NO;
    } else if ( [request.mainDocumentURL.relativePath isEqualToString:@"/wangcai_js/attach_phone"] ) {
        // 点击了绑定手机
        [self onAttachPhone];

        return NO;
    } else if ( [request.mainDocumentURL.relativePath isEqualToString:@"/wangcai_js/pay_to_alipay"] ) {
        NSString* discount = [self getValueFromQuery:query Key:@"discount"];
        NSString* amount = [self getValueFromQuery:query Key:@"amount"];
        int nDiscount = [discount intValue];
        int nAmount = [amount intValue];
        
        [self onPayToAlipay:nDiscount Amount:nAmount];
        
        return NO;
    } else if ( [request.mainDocumentURL.relativePath isEqualToString:@"/wangcai_js/pay_to_phone"] ) {
        NSString* discount = [self getValueFromQuery:query Key:@"discount"];
        NSString* amount = [self getValueFromQuery:query Key:@"amount"];
        int nDiscount = [discount intValue];
        int nAmount = [amount intValue];
        
        [self onPayToPhone:nDiscount Amount:nAmount];

        return NO;
    } else if ( [request.mainDocumentURL.relativePath isEqualToString:@"/wangcai_js/order_info"] ) {
        NSString* value = [self getValueFromQuery:query Key:@"num"];
        
        //统计
        [MobClick event:@"click_view_order_secret" attributes:@{@"current_page":@"网页",@"query_id":value}];
        
        [self onShowOrder:value];
        
        return NO;
    } else if ( [request.mainDocumentURL.relativePath isEqualToString:@"/wangcai_js/copy_to_clip"] ) {
        NSString* value = [self getValueFromQuery:query Key:@"context"];
        
        //统计
        [MobClick event:@"click_copy_to_clipboard" attributes:@{@"current_page":@"网页",@"content":value}];
        
        UIPasteboard* pasteboard = [UIPasteboard generalPasteboard];
        pasteboard.string = value;
        // 复制完成
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"复制完成" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
        
        return NO;
    } else if ( [request.mainDocumentURL.relativePath isEqualToString:@"/wangcai_js/install_app"] ) {
        NSString* value = [self getValueFromQuery:query Key:@"appid"];
        
        //统计
        [MobClick event:@"task_install_app_step1" attributes:@{@"appid":value}];

        if ( _delegate != nil ) {
            [_delegate openAppWithIdentifier:value];
        }

        return NO;
    } else if ( [request.mainDocumentURL.relativePath isEqualToString:@"/wangcai_js/open_url"] ) {
        NSString* value = [self getValueFromQuery:query Key:@"url"];
        
        //统计
        [MobClick event:@"web_open_outside_url" attributes:@{@"url":value}];
        
        if ( _delegate != nil ) {
            [_delegate openUrl:value];
        }
        
        return NO;
    } else if ( [request.mainDocumentURL.relativePath isEqualToString:@"/wangcai_js/service_center"] ) {
        NSString* num = [[LoginAndRegister sharedInstance] getPhoneNum];
        if ( num == nil ) {
            num = @"";
        }
        NSString* url = [[NSString alloc] initWithFormat:@"%@?mobile=%@&mobile_num=%@---%@",
                         HTTP_SERVICE_CENTER, num, [Common getMACAddress], [Common getIDFAAddress] ];
        
        //统计
        [MobClick event:@"click_contact_to_customer_service" attributes:@{@"current_page":@"网页"}];
        WebPageController* webController = [[[WebPageController alloc] init:@"客户服务" Url:url Stack:_beeStack]autorelease];
        
        [self->_beeStack pushViewController:webController animated:YES];
        return NO;
        
    } else if ( [request.mainDocumentURL.relativePath isEqualToString:@"/wangcai_js/open_url_inside"] ) {
        NSString* value = [self getValueFromQuery:query Key:@"url"];
        NSString* title = [self getValueFromQuery:query Key:@"title"];
        
        //统计
        [MobClick event:@"web_open_inside_url" attributes:@{@"url":value,@"title":title}];
        
        title = [title stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];

        WebPageController* webController = [[[WebPageController alloc] init:title Url:value Stack:_beeStack]autorelease];
        
        [self->_beeStack pushViewController:webController animated:YES];
        
        return NO;
    } else if ( [request.mainDocumentURL.relativePath isEqualToString:@"/wangcai_js/exchange_info"] ) {
        NSString* device = [[[LoginAndRegister sharedInstance] getDeviceId] autorelease];
        NSString* sessionid = [[[LoginAndRegister sharedInstance] getSessionId] autorelease];
        NSString* userid = [[[LoginAndRegister sharedInstance] getUserId] autorelease];
        NSString* timestamp = [Common getTimestamp];
        
        NSString* url = [[[NSString alloc] initWithFormat:@"%@?device_id=%@&session_id=%@&userid=%@&timestamp=%@", WEB_EXCHANGE_INFO, device, sessionid, userid, timestamp] autorelease];
    
        //统计
        [MobClick event:@"click_trade_details" attributes:@{@"current_page":@"网页"}];
        WebPageController* controller = [[WebPageController alloc] init:@"交易详情" Url:url Stack:_beeStack];
        [_beeStack pushViewController:controller animated:YES];
        
        return NO;
    } else if ( [request.mainDocumentURL.relativePath isEqualToString:@"/wangcai_js/alert"] ) {
        NSString* title = [self getValueFromQuery:query Key:@"title"];
        NSString* info = [self getValueFromQuery:query Key:@"info"];
        NSString* btntext = [self getValueFromQuery:query Key:@"btntext"];
        
        title = [title stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        info = [info stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        btntext = [btntext stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        NSString* btn2 = [self getValueFromQuery:query Key:@"btn2"];
        if ( btn2 != nil ) {
            //统计
            [MobClick event:@"click_clear_all_submitted_problem" attributes:@{@"current_page":@"网页"}];
            
            btn2 = [btn2 stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            NSString* btn2Id = [self getValueFromQuery:query Key:@"btn2id"];
            NSString* callback = [self getValueFromQuery:query Key:@"callback"];
            
            if ( _alert != nil ) {
                [_alert release];
            }
            if ( _nsCallback != nil ) {
                [_nsCallback release];
            }
            if ( _nsCallback != nil ) {
                [_nsBtn2ID release];
            }
            
            _nsCallback = [callback copy];
            _nsBtn2ID = [btn2Id copy];
            
            _alert = [[UIAlertView alloc] initWithTitle:title message:info delegate:self cancelButtonTitle:btntext otherButtonTitles:btn2, nil];
            
            [_alert show];
        } else {
            //统计
            [MobClick event:@"click_submit_problem" attributes:@{@"current_page":@"网页"}];
            
            UIAlertView* alert = [[UIAlertView alloc] initWithTitle:title message:info delegate:nil cancelButtonTitle:btntext otherButtonTitles:nil, nil];
            [alert show];
            [alert release];
        }
        
        return NO;
    } else if ( [request.mainDocumentURL.relativePath isEqualToString:@"/wangcai_js/alert_loading"] ) {
        NSString* show = [self getValueFromQuery:query Key:@"show"];
        if ( [show isEqualToString:@"1"] ) {
            NSString* info = [self getValueFromQuery:query Key:@"info"];
            info = [info stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            
            // 显示loading
            [MBHUDView hudWithBody:info type:MBAlertViewHUDTypeActivityIndicator hidesAfter:-1 show:YES];
        } else {
            [MBHUDView dismissCurrentHUD];
        }
        
        return NO;
    }
    
    return YES;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if ( _alert != nil ) {
        if ( [_alert isEqual:alertView] ) {
            if ( buttonIndex == 1 ) {
                NSString* js = [[NSString alloc] initWithFormat:@"%@(%@)", self->_nsCallback, _nsBtn2ID];
                [_webView stringByEvaluatingJavaScriptFromString:js];
                [js release];
            }
        }
    }
    
    if ( _alertBindPhone != nil ) {
        if ( [_alertBindPhone isEqual:alertView] ) {
            if ( buttonIndex == 1 ) {
                [self onAttachPhone];
            }
        }
    }
}

- (void) setDelegate:(id) delegate {
    _delegate = delegate;
}

- (void)notifyPhoneStatus:(BOOL)isAttach Phone:(NSString*)phone Balance:(float)banlance {
    NSString* js;
    if ( isAttach ) {
        js = [NSString stringWithFormat:@"notifyPhoneStatus(true, \"%@\", %.2f)", phone, banlance];
    } else {
        js = [NSString stringWithFormat:@"notifyPhoneStatus(false, \"\", %.2f)", banlance];
    }
    [self->_webView stringByEvaluatingJavaScriptFromString:js];
}

- (void)notifyBalanceToWeb {
    int balance = [[LoginAndRegister sharedInstance] getBalance];
    int income = [[LoginAndRegister sharedInstance] getIncome];
    int outgo = [[LoginAndRegister sharedInstance] getOutgo];
    int sharedIncome = [[LoginAndRegister sharedInstance] getInviteIncome];

    NSString* js = [NSString stringWithFormat:@"notifyBalance(%.2f, %.2f, %.2f, %.2f)",
                    1.0*balance/100, 1.0*income/100, 1.0*outgo/100, 1.0*sharedIncome/100];
    
    [self->_webView stringByEvaluatingJavaScriptFromString:js];
}
 
- (void)notifyDeviceInfo {
    NSString* device = [[LoginAndRegister sharedInstance] getDeviceId];
    NSString* sessionId = [[LoginAndRegister sharedInstance] getSessionId];
    NSString* userid = [[LoginAndRegister sharedInstance] getUserId];
    
    NSString* js = [NSString stringWithFormat:@"notifyDeviceInfo(\"%@\", \"%@\", %@)", device, sessionId, userid];
    
    [self->_webView stringByEvaluatingJavaScriptFromString:js];
    
    [device release];
    [sessionId release];
    [userid release];
}
 
- (void)webViewDidStartLoad:(UIWebView *)webView {
    if ( !self->_refreshHeader ) {
        [self->_loadingView setHidden:NO];
        [self->_webView setHidden:YES];
        [self->_errView setHidden:YES];
    }
    
    CGRect rect;
    rect.origin.y = 0;
    rect.origin.x = 0;
    rect.size = _size;
    
    if ( rect.size.height != 0 && rect.size.width != 0 ) {
        _webView.frame = rect;
    }
    
    _reloading = YES;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    if ( !self->_refreshHeader ) {
        [self->_loadingView setHidden:YES];
        [self->_webView setHidden:NO];
        [self->_errView setHidden:YES];
    }
    
    _reloading = NO;
    [_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:_webView.scrollView];
}

- (IBAction)onRequest:(id)sender {
    NSURL* nsurl = [[NSURL alloc] initWithString:_url];
    [self->_webView loadRequest:[NSURLRequest requestWithURL:nsurl]];
    [nsurl release];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    [self->_loadingView setHidden:YES];
    [self->_errView setHidden:NO];
    [self->_webView setHidden:YES];
    
    _reloading = NO;
	[_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:_webView.scrollView];
}

#pragma mark UIScrollViewDelegate Methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
	[_refreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
	[_refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
}

-(void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
    [_refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
}

#pragma mark EGORefreshTableHeaderDelegate Methods

- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView*)view{
    self->_refreshHeader = true;
    
    [_webView reload];
}

- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView*)view{
	
	return _reloading; // should return if data source model is reloading
	
}

- (NSDate*)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView*)view{
	
	return [NSDate date]; // should return date data source was last changed
}


-(void) onAttachPhone {
    // 绑定手机
    [MobClick event:@"click_bind_phone" attributes:@{@"currentpage":@"网页"}];
    PhoneValidationController* phoneVal = [PhoneValidationController shareInstance];
    [self->_beeStack pushViewController:phoneVal animated:YES];
}

-(BOOL) checkBalanceAndBindPhone :(float) fCoin {
    NSString* phoneNum = [[LoginAndRegister sharedInstance] getPhoneNum];
    if ( phoneNum == nil || [phoneNum isEqualToString:@""] ) {
        // 没有绑定手机号
        if ( _alertBindPhone != nil ) {
            [_alertBindPhone release];
        }
        
        _alertBindPhone = [[UIAlertView alloc] initWithTitle:@"提示" message:@"尚未绑定手机，请先绑定手机" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"绑定手机", nil];
        
        [_alertBindPhone show];
        
        if ( phoneNum != nil ) {
            [phoneNum release];
        }
        return NO;
    }
    
    [phoneNum release];
    
    float balance = (1.0*[[LoginAndRegister sharedInstance] getBalance]) / 100;
    if ( fCoin > balance ) {
        if ( _alertNoBalance != nil ) {
            [_alertNoBalance release];
        }
        
        _alertNoBalance = [[UIAlertView alloc] initWithTitle:@"提示" message:@"您的余额不足以支付" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [_alertNoBalance show];
        
        return NO;
    }
    
    return YES;
}

-(void) onPayToAlipay:(int) nDiscount Amount:(int) nAmount {
    // 转帐到支付宝
    if ([[LoginAndRegister sharedInstance] getNoWithDraw] != 0)
    {
        UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"休假通知" message:@"感谢各位对赚钱小猪的内测支持，春节期间由于假期关系，暂停取现充值功能，请在假期结束后（2月9日）执行相关操作，祝大家新年红包满满。" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alertView show];
    }
    else if ( [self checkBalanceAndBindPhone:(1.0*nDiscount/100)] ) {
        NSMutableDictionary* dict = [[NSMutableDictionary alloc]init];
        NSString* rmb = [[NSString alloc] initWithFormat:@"%d", nDiscount];
        
        [dict setObject:rmb forKey:@"RMB"];
        [MobClick event:@"pay_to_alipay" attributes:dict];
        
        [dict release];
        [rmb release];

        TransferToAlipayAndPhoneController* controller = [[[TransferToAlipayAndPhoneController alloc]init:YES BeeUIStack:_beeStack] autorelease];
        
        [self->_beeStack pushViewController:controller animated:YES];
    }
}

-(void) onPayToPhone:(int) nDiscount Amount:(int) nAmount {
    // 话费充值
    if ([[LoginAndRegister sharedInstance] getNoWithDraw] != 0)
    {
        UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"休假通知" message:@"感谢各位对赚钱小猪的内测支持，春节期间由于假期关系，暂停取现充值功能，请在假期结束后（2月9日）执行相关操作，祝大家新年红包满满。" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alertView show];
    }
    else if ( [self checkBalanceAndBindPhone:(1.0*nDiscount/100)] ) {
        NSMutableDictionary* dict = [[NSMutableDictionary alloc]init];
        NSString* rmb = [[NSString alloc] initWithFormat:@"%d", nDiscount];
        
        [dict setObject:rmb forKey:@"RMB"];
        [MobClick event:@"pay_to_phone" attributes:dict];
        
        [dict release];
        [rmb release];
        
        TransferToAlipayAndPhoneController* controller = [[[TransferToAlipayAndPhoneController alloc]init:NO BeeUIStack:_beeStack] autorelease];
        [self->_beeStack pushViewController:controller animated:YES];
    }
}

-(void) onShowOrder:(NSString*) orderNum {
    NSString* url = [[WEB_ORDER_INFO copy] autorelease];
    url = [url stringByAppendingFormat:@"?ordernum=%@", orderNum];
    
    WebPageController* controller = [[[WebPageController alloc] initOrder:orderNum Url:url Stack:_beeStack] autorelease];
    [_beeStack pushViewController:controller animated:YES];
}
@end
