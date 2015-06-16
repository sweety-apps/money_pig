//
//  PhoneValidationController.h
//  wangcai
//
//  Created by 1528 on 13-12-9.
//  Copyright (c) 2013年 1528studio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PhoneValidation.h"
#import "TabController.h"
#import "UICustomAlertView.h"
#import "UIPayButton.h"
#import "CommonPullRefreshViewController.h"
#import "ExtractAndExchangeLogic.h"

@interface TransferToAlipayAndPhoneController : CommonPullRefreshViewController<UITextFieldDelegate, HttpRequestDelegate, UIAlertViewDelegate, UIPayButtonDelegate> {
    int _nDiscount;
    int _nAmount;
    UIAlertView* _alertView;
    UIAlertView*    _alertBindPhone;
    BeeUIStack*     _beeStack;
    NSString* _orderId;
    int       _type; // type=1 支付宝  2 话费充值  3 qq币
    
    UIPayButton* _btn1;
    UIPayButton* _btn2;
    UIPayButton* _btn3;
    
    UIButton* _helpButton;
}

@property (retain, nonatomic) IBOutlet UITapGestureRecognizer *tapGestureRecognizer;
@property (retain, nonatomic, readonly) ExtractAndExchangeListItem* item;

@property (assign, nonatomic) UIView *_completeView;
@property (assign, nonatomic) UIView *_containerView;

@property (assign, nonatomic) UIView *_textFieldBgView;
@property (assign, nonatomic) UIView *_textCheckBgView;
@property (assign, nonatomic) UIView *_textNameBgView;

@property (assign, nonatomic) UITextField *_textField;
@property (assign, nonatomic) UITextField *_textCheck;
@property (assign, nonatomic) UITextField *_textName;

@property (assign, nonatomic) UILabel *_textFieldTip;
@property (assign, nonatomic) UILabel *_textCheckTip;
@property (assign, nonatomic) UILabel *_textNameTip;

// type=1 支付宝  2 话费充值  3 qq币 100 支付宝 101 话费
- (id) init:(int) type BeeUIStack:(BeeUIStack*) stack andItem:(ExtractAndExchangeListItem*)item;

- (IBAction)clickBack:(id)sender;
- (IBAction)hideKeyboard:(id)sender;

- (IBAction)clickOrderInfo:(id)sender;

- (IBAction)clickCancel:(id)sender;
- (IBAction)clickContinue:(id)sender;

- (IBAction)clickClear1:(id)sender;
- (IBAction)clickClear2:(id)sender;
- (IBAction)clickClear3:(id)sender;

- (IBAction)clickAlipayHelp:(id)sender;

@end
