//
//  PrivacyPolicyView.h
//  wangcai
//
//  Created by Lee Justin on 14-10-16.
//  Copyright (c) 2014年 1528studio. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PrivacyPolicyView;

@protocol PrivacyPolicyViewDelegate <NSObject>

- (void) privacyPolicyViewHasDismissedWithAgreed:(PrivacyPolicyView*)view;

@end

@interface PrivacyPolicyView : UIView
@property (retain, nonatomic) IBOutlet UIWebView *webView;
@property (retain, nonatomic) IBOutlet UIButton *agreeButton;
@property (assign, nonatomic) id<PrivacyPolicyViewDelegate> delegate;

+ (PrivacyPolicyView*) privacyPolicyView;
- (void) setShouldFinishReading:(BOOL)shouldFinishReading;
- (void) showInWindow:(BOOL)animated;
- (IBAction)onPressedAgree:(id)sender;

@end
