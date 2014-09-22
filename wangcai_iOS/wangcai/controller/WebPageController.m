//
//  WebPageController.m
//  wangcai
//
//  Created by 1528 on 13-12-17.
//  Copyright (c) 2013年 1528studio. All rights reserved.
//

#import "WebPageController.h"

@interface WebPageController ()

@end

@implementation WebPageController

- (id)init:(NSString *)title Url : (NSString*) url Stack : (BeeUIStack*) stack
{
    self = [super initWithNibName:@"WebPageController" bundle:nil];
    if (self) {
        // Custom initialization
        self.view = [[[NSBundle mainBundle] loadNibNamed:@"WebPageController" owner:self options:nil] firstObject];
        self->_beeUIStack = stack;
        self->_titleLabel = (UILabel*)[self.view viewWithTag:99];
        
        [self->_titleLabel setText:title];
        
        self->_webViewController = [[WebViewController alloc]init];
        [self->_webViewController setBeeUIStack:stack];
        
        [self->_webViewController setDelegate:self];
        
        UIView* view = self->_webViewController.view;
        CGRect rect = [[UIScreen mainScreen]bounds];
        rect.origin.y = 54;
        rect.size.height -= 54;
        view.frame = rect;
        [self.view addSubview:view];
        
        [_webViewController setSize:rect.size];
        [self->_webViewController setNavigateUrl:url];
        
        [[self.view viewWithTag:97] setHidden:YES];
        [[self.view viewWithTag:98] setHidden:YES];
    }
    return self;
}

// 显示订单信息
- (id)initOrder:(NSString *)orderNum Url : (NSString*) url Stack : (BeeUIStack*) stack
{
    self = [super initWithNibName:@"WebPageController" bundle:nil];
    if (self) {
        // Custom initialization
        self.view = [[[NSBundle mainBundle] loadNibNamed:@"WebPageController" owner:self options:nil] firstObject];
        self->_beeUIStack = stack;
        self->_titleLabel = (UILabel*)[self.view viewWithTag:99];
        
        [self->_titleLabel setText:@"订单详情"];
        
        self->_webViewController = [[WebViewController alloc]init];
        [self->_webViewController setBeeUIStack:stack];
        [self->_webViewController setDelegate:self];
        
        UIView* view = self->_webViewController.view;
        CGRect rect = [[UIScreen mainScreen]bounds];
        rect.origin.y = 54;
        rect.size.height -= 54;
        view.frame = rect;
        [self.view addSubview:view];

        [_webViewController setSize:rect.size];
        
        NSString* device = [[[LoginAndRegister sharedInstance] getDeviceId] autorelease];
        NSString* sessionid = [[[LoginAndRegister sharedInstance] getSessionId] autorelease];
        NSString* userid = [[[LoginAndRegister sharedInstance] getUserId] autorelease];
        NSString* tmpUrl = [[[NSString alloc] initWithFormat:@"%@&device_id=%@&session_id=%@&userid=%@", url, device, sessionid, userid] autorelease];
        
        [self->_webViewController setNavigateUrl:tmpUrl];
        
        [[self.view viewWithTag:97] setHidden:YES];
        [[self.view viewWithTag:98] setHidden:YES];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) dealloc {
    self->_webViewController = nil;
    self->_titleLabel = nil;
    self->_beeUIStack = nil;
    [super dealloc];
}

- (IBAction)clickBack:(id)sender {
    int nCount = [_beeUIStack.viewControllers count];
    
    if ( nCount == 1 ) {
        [[BeeUIRouter sharedInstance] open:@"wc_main" animated:YES];
    } else {
        [self->_beeUIStack popViewControllerAnimated:YES];
    }
}

- (void) openUrl : (NSString*) url {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
}

@end
