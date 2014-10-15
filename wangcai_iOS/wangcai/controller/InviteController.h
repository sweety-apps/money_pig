//
//  InviteController.h
//  wangcai
//
//  Created by 1528 on 13-12-11.
//  Copyright (c) 2013年 1528studio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommonPullRefreshViewController.h"
#import "InviterUpdate.h"

@interface InviteController : CommonPullRefreshViewController <InviterUpdateDelegate, UITextFieldDelegate>
{
}

@property (assign, nonatomic) BeeUIStack* _beeStack;

+ (InviteController*) controller;

- (IBAction)copyUrl:(id)sender;
- (IBAction)share:(id)sender;
- (IBAction)hideKeyboard:(id)sender;
- (IBAction)updateInviter:(id)sender;

- (IBAction)clickTextLink:(id)sender;

@end
