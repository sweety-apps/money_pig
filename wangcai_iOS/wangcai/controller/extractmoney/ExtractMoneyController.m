//
//  ExtractMoneyController.m
//  wangcai
//
//  Created by 1528 on 13-12-13.
//  Copyright (c) 2013年 1528studio. All rights reserved.
//

#import "ExtractMoneyController.h"
#import "Config.h"
#import "PhoneValidationController.h"
#import "TransferToAlipayAndPhoneController.h"
#import "WebPageController.h"
#import "Common.h"

@interface ExtractMoneyController ()

@end

@implementation ExtractMoneyController
@synthesize bingphoneTipsView;
@synthesize jiaoyiTipsView;
@synthesize jiaoyiBtn;
@synthesize labelBalance;

- (id)init:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:@"ExtractMoneyController" bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.view = [[[NSBundle mainBundle] loadNibNamed:@"ExtractMoneyController" owner:self options:nil] firstObject];
        
        if ( [[LoginAndRegister sharedInstance] isInReview] ) {
            // 隐藏交易明细按钮
            [self.jiaoyiBtn setHidden:YES];
        }
        
        [[LoginAndRegister sharedInstance] attachBalanceChangeEvent:self];
        [[LoginAndRegister sharedInstance] attachBindPhoneEvent:self];
        
        [self performSelector:@selector(onViewInit) withObject:nil afterDelay:0.1];
        
        [self updateBalance];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (IBAction)bindPhone:(id)sender {
    PhoneValidationController* phoneVal = [PhoneValidationController shareInstance];
    [self->_beeStack pushViewController:phoneVal animated:YES];
}

- (void)onViewInit
{
    if ([[[LoginAndRegister sharedInstance] getPhoneNum] length]> 0)
    {
        [self hideBindTips:NO];
    }
    else
    {
        [self showBindTips:YES];
    }
}

- (void)showBindTips:(BOOL)animated;
{
    self.bingphoneTipsView.frame = CGRectMake(0, 5, self.bingphoneTipsView.frame.size.width, self.bingphoneTipsView.frame.size.height);
    
    void (^block)(void) = ^(){
        self.bingphoneTipsView.frame = CGRectMake(0, 52, self.bingphoneTipsView.frame.size.width, self.bingphoneTipsView.frame.size.height);
    };
    
    [jiaoyiTipsView setHidden:YES];
    
    if (animated)
    {
        [UIView animateWithDuration:1.0 animations:block];
    }
    else
    {
        block();
    }
}

- (void)hideBindTips:(BOOL)animated;
{
    void (^block)(void) = ^(){
        self.bingphoneTipsView.frame = CGRectMake(0, 5, self.bingphoneTipsView.frame.size.width, self.bingphoneTipsView.frame.size.height);
    };
    
    [jiaoyiTipsView setHidden:NO];
    
    if (animated)
    {
        [UIView animateWithDuration:1.0 animations:block];
    }
    else
    {
        block();
    }
}


- (void) dealloc {
    self->_beeStack = nil;
    [jiaoyiBtn release];
    [jiaoyiTipsView release];
    [bingphoneTipsView release];
    [labelBalance release];
    [super dealloc];
}

- (void)setUIStack : (BeeUIStack*) beeStack {
    self->_beeStack = beeStack;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)clickBack:(id)sender {
	//[[BeeUIRouter sharedInstance] open:@"wc_main" animated:YES];
    [self->_beeStack popViewControllerAnimated:YES];
}

- (void)updateBalance {
    int nBalance = [[LoginAndRegister sharedInstance] getBalance];
    NSString* balance = [[NSString alloc] initWithFormat:@"可用余额：¥ %.2f元", (1.0*nBalance/100)];
    [labelBalance setText:balance];
}

- (IBAction)clickJiaoyi:(id)sender {
    NSString* device = [[[LoginAndRegister sharedInstance] getDeviceId] autorelease];
    NSString* sessionid = [[[LoginAndRegister sharedInstance] getSessionId] autorelease];
    NSString* userid = [[[LoginAndRegister sharedInstance] getUserId] autorelease];
    NSString* timestamp = [Common getTimestamp];
    
    NSString* url = [[[NSString alloc] initWithFormat:@"%@?device_id=%@&session_id=%@&userid=%@&timestamp=%@", WEB_EXCHANGE_INFO, device, sessionid, userid, timestamp] autorelease];

    WebPageController* controller = [[WebPageController alloc] init:@"交易详情" Url:url Stack:_beeStack];
    [_beeStack pushViewController:controller animated:YES];
}

-(void) bindPhoneCompeted {
    [self hideBindTips:YES];
}

-(void) balanceChanged:(int) oldBalance New:(int) balance {
    [self updateBalance];
}

- (IBAction)clickAlipay:(id)sender {
    TransferToAlipayAndPhoneController* controller = [[[TransferToAlipayAndPhoneController alloc]init:1 BeeUIStack:_beeStack andItem:nil] autorelease];
        
    [self->_beeStack pushViewController:controller animated:YES];
}

- (IBAction)clickPhone:(id)sender {
    TransferToAlipayAndPhoneController* controller = [[[TransferToAlipayAndPhoneController alloc]init:2 BeeUIStack:_beeStack andItem:nil] autorelease];
    [self->_beeStack pushViewController:controller animated:YES];
}

- (IBAction)clickQBi:(id)sender {
    TransferToAlipayAndPhoneController* controller = [[[TransferToAlipayAndPhoneController alloc]init:3 BeeUIStack:_beeStack andItem:nil] autorelease];
    [self->_beeStack pushViewController:controller animated:YES];
}

@end
