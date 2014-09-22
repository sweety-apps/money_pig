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

@interface TransferToAlipayAndPhoneController : UIViewController<UITextFieldDelegate, HttpRequestDelegate, UIAlertViewDelegate, UIPayButtonDelegate> {
    int _nDiscount;
    int _nAmount;
    UICustomAlertView* _alertView;
    UIAlertView*    _alertBindPhone;
    BeeUIStack*     _beeStack;
    NSString* _orderId;
    int       _type; // type=1 支付宝  2 话费充值  3 qq币
    
    UIPayButton* _btn1;
    UIPayButton* _btn2;
    UIPayButton* _btn3;
}

@property (assign, nonatomic) UIView *_completeView;
@property (assign, nonatomic) UIView *_containerView;
@property (assign, nonatomic) UITextField *_textField;
@property (assign, nonatomic) UITextField *_textCheck;
@property (assign, nonatomic) UITextField *_textName;

@property (assign, nonatomic) UILabel *_textFieldTip;
@property (assign, nonatomic) UILabel *_textCheckTip;
@property (assign, nonatomic) UILabel *_textNameTip;

// type=1 支付宝  2 话费充值  3 qq币
- (id) init:(int) type BeeUIStack:(BeeUIStack*) stack;

- (IBAction)clickBack:(id)sender;
- (IBAction)hideKeyboard:(id)sender;

- (IBAction)clickOrderInfo:(id)sender;

- (IBAction)clickCancel:(id)sender;
- (IBAction)clickContinue:(id)sender;

- (IBAction)clickClear1:(id)sender;
- (IBAction)clickClear2:(id)sender;
- (IBAction)clickClear3:(id)sender;

@end
