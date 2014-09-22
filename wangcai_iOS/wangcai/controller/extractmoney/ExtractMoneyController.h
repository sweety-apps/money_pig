//
//  ExtractMoneyController.h
//  wangcai
//
//  Created by 1528 on 13-12-13.
//  Copyright (c) 2013年 1528studio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WebViewController.h"
#import "LoginAndRegister.h"

@interface ExtractMoneyController : UIViewController<BindPhoneDelegate, BalanceChangeDelegate> {
    BeeUIStack* _beeStack;
}

@property (nonatomic,retain) IBOutlet UIView* bingphoneTipsView;
@property (nonatomic,retain) IBOutlet UIView* jiaoyiTipsView;
@property (nonatomic,retain) IBOutlet UIButton* jiaoyiBtn;
@property (nonatomic,retain) IBOutlet UILabel* labelBalance;

- (id)init:(NSBundle *)nibBundleOrNil;
- (void)setUIStack : (BeeUIStack*) beeStack;

- (IBAction)clickBack:(id)sender;

- (IBAction)bindPhone:(id)sender;
- (IBAction)clickJiaoyi:(id)sender;

- (IBAction)clickAlipay:(id)sender;
- (IBAction)clickPhone:(id)sender;
- (IBAction)clickQBi:(id)sender;
@end
