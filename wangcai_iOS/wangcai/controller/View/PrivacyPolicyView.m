//
//  PrivacyPolicyView.m
//  wangcai
//
//  Created by Lee Justin on 14-10-16.
//  Copyright (c) 2014年 1528studio. All rights reserved.
//

#import "PrivacyPolicyView.h"

@interface PrivacyPolicyView () <UIScrollViewDelegate,UIWebViewDelegate>

@property (nonatomic,assign) BOOL finishReading;

@end


@implementation PrivacyPolicyView

+ (PrivacyPolicyView*) privacyPolicyView
{
    PrivacyPolicyView* ret = CREATE_NIBVIEW(@"PrivacyPolicyView");
    return ret;
}

- (void) setShouldFinishReading:(BOOL)shouldFinishReading
{
    self.finishReading = shouldFinishReading;
    if (self.finishReading)
    {
        [self enableAgreeButton:NO];
        [self scrollViewDidScroll:self.webView.scrollView];
    }
    else
    {
        [self enableAgreeButton:YES];
    }
}

- (void) enableAgreeButton:(BOOL)enabled
{
    if (!enabled)
    {
        self.agreeButton.enabled = NO;
        self.agreeButton.backgroundColor = [UIColor lightGrayColor];
        [self.agreeButton setTitle:@"请滚动阅读" forState:UIControlStateNormal];
        [self scrollViewDidScroll:self.webView.scrollView];
    }
    else
    {
        self.agreeButton.enabled = YES;
        self.agreeButton.backgroundColor = RGB(153, 191, 34);
        [self.agreeButton setTitle:@"我同意此协议" forState:UIControlStateNormal];
    }
}

- (void) showInWindow:(BOOL)animated
{
    CGRect rect = CGRectZero;
    
    rect = [UIApplication sharedApplication].keyWindow.frame;
    rect.origin = CGPointZero;
    
    self.frame = rect;
    
    rect.origin = CGPointZero;
    rect.origin.y = 0;
    rect.size = self.frame.size;
    rect.size.height -= 80;
    self.webView.frame = rect;
    
    rect = self.agreeButton.frame;
    rect.origin.y = self.frame.size.height - 65;
    self.agreeButton.frame = rect;
    
    rect = self.frame;
    rect.origin.y = rect.size.height;
    self.frame = rect;
    
    rect.origin.y = 0;
    
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    
    void (^animateBlk)() = ^(){
        self.frame = rect;
    };
    void (^endBlk)() = ^(){
        self.frame = rect;
    };
    
    if (animated)
    {
        [UIView animateWithDuration:0.3 animations:animateBlk completion:^(BOOL finished) {
            endBlk();
        }];
    }
    else
    {
        animateBlk();
        endBlk();
    }
    
}

- (IBAction)onPressedAgree:(id)sender
{
    if (self.delegate)
    {
        [self.delegate privacyPolicyViewHasDismissedWithAgreed:self];
    }
    [self hideAndRelease:YES];
}

- (void) hideAndRelease:(BOOL)animated
{
    CGRect rect = CGRectZero;
    rect = self.frame;
    rect.origin.y = rect.size.height;
    
    void (^animateBlk)() = ^(){
        self.frame = rect;
    };
    void (^endBlk)() = ^(){
        [self removeFromSuperview];
    };
    
    if (animated)
    {
        [UIView animateWithDuration:0.3 animations:animateBlk completion:^(BOOL finished) {
            endBlk();
        }];
    }
    else
    {
        animateBlk();
        endBlk();
    }
}

- (void)awakeFromNib
{
    self.agreeButton.layer.masksToBounds = YES;
    self.agreeButton.layer.cornerRadius = 5.0;
    
    [self enableAgreeButton:YES];
    
    NSURL* url = [[NSBundle mainBundle] URLForResource:@"pp" withExtension:@"html"];
    NSURLRequest* req = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:req];
    
    self.webView.scrollView.delegate = self;
    
    self.webView.delegate = self;
}

-(void)dealloc
{
    [_webView release];
    [_agreeButton release];
    [super dealloc];
}

#pragma mark <UIScrollViewDelegate>

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (self.finishReading)
    {
        if (scrollView.contentOffset.y + (scrollView.frame.size.height * 2) > scrollView.contentSize.height )
        {
            if (!self.agreeButton.enabled)
            {
                [self enableAgreeButton:YES];
            }
        }
    }
}

#pragma mark <UIWebViewDelegate>

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [self setShouldFinishReading:self.finishReading];
}

@end
