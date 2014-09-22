//
//  PhoneValidationController.h
//  wangcai
//
//  Created by NPHD on 14-2-18.
//  Copyright (c) 2014年 1528studio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PhoneValidation.h"

@interface PhoneValidationController : UIViewController<UITextFieldDelegate, PhoneValidationDelegate> {
    BOOL _bSend;
    
    UITextField* _phoneField;
    UILabel*     _phoneFieldTip;
    UIButton*    _phoneClear;
    
    UIImageView* _smsBkg;
    UITextField* _smsCode;
    UILabel*     _smsCodeTip;
    
    UIButton*    _resendBtn;
    UIButton*    _smsBtn;
    
    UIButton*    _nextBtn;
    
    UILabel*     _smsTime;
    
    BOOL         _firstSend;
    
    PhoneValidation* phoneValidation;
    
    NSString*    _token;
    NSString*    _phoneNum;
    
    NSTimer*    _timer;
    int        _nTime;
    
    int _status;
}

+ (PhoneValidationController*) shareInstance;

- (IBAction)clickBack:(id)sender;

- (IBAction)hideKeyboard:(id)sender;

- (IBAction)clearPhone:(id)sender;

- (IBAction)cleckSendSms:(id)sender;

- (IBAction)clickNext:(id)sender;
@end
