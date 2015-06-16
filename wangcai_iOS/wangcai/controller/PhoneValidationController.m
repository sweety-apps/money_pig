//
//  PhoneValidationController.m
//  wangcai
//
//  Created by NPHD on 14-2-18.
//  Copyright (c) 2014年 1528studio. All rights reserved.
//

#import "PhoneValidationController.h"
#import "MobClick.h"
#import "MBHUDView.h"
#import "BaseTaskTableViewController.h"
#import "Common.h"

@interface PhoneValidationController () <UIAlertViewDelegate>
{
    NSDate* _startDate;
}

@property (nonatomic, retain) UIAlertView* succAlert;

@end

@implementation PhoneValidationController

+ (PhoneValidationController*) shareInstance {
    static PhoneValidationController* phoneVal = nil;
    if ( phoneVal == nil ) {
        phoneVal = [[PhoneValidationController alloc]initWithNibName:@"PhoneValidationController" bundle:nil];
    }
    
    // 查stack列表，从当前的stack中去掉
    NSMutableArray* mArray = [[NSMutableArray alloc] init];
    NSArray* array = [phoneVal.navigationController viewControllers];
    for (int i = 0; i < [array count]; i ++) {
        id obj = [array objectAtIndex:i];
        if ( ![obj isEqual:phoneVal] ) {
            [mArray addObject:obj];
        }
    }
    
    phoneVal.navigationController.viewControllers = mArray;
    
    [phoneVal setBackType:NO];
    return [phoneVal retain];
}

- (void)setBackType:(BOOL)bSend {
    _bSend = bSend;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _bSend = NO;
        _firstSend = YES;
        _token = nil;
        _phoneNum = nil;
        
        self.view = [[[NSBundle mainBundle] loadNibNamed:@"PhoneValidationController" owner:self options:nil] firstObject];
        
        _phoneField = (UITextField*)[self.view viewWithTag:11];
        _phoneClear = (UIButton*)[self.view viewWithTag:12];
        _smsBkg = (UIImageView*)[self.view viewWithTag:14];
        _smsCode = (UITextField*)[self.view viewWithTag:13];
        _smsBtn = (UIButton*)[self.view viewWithTag:15];
        _nextBtn = (UIButton*)[self.view viewWithTag:16];
        _smsTime = (UILabel*)[self.view viewWithTag:17];
        _phoneFieldTip = (UILabel*)[self.view viewWithTag:65];
        _smsCodeTip = (UILabel*)[self.view viewWithTag:66];
        _resendBtn = (UIButton*)[self.view viewWithTag:99];
        _phoneBgView = [self.view viewWithTag:100];
        _smsCodeBgView =  [self.view viewWithTag:101];
        
        _smsCode.delegate = self;
        _phoneField.delegate = self;
        
        [self setStatus:1]; // 等待输入手机号
        
        self->phoneValidation = [[PhoneValidation alloc] init];
        
        [self _setupUIAppearence];
    }
    return self;
}

- (void) _setupUIAppearence
{
    _phoneBgView.layer.masksToBounds = YES;
    _phoneBgView.layer.borderColor = [UIColor blackColor].CGColor;
    _phoneBgView.layer.borderWidth = 1.0f;
    _phoneBgView.layer.cornerRadius = 2.0f;
    
    _smsCodeBgView.layer.masksToBounds = YES;
    _smsCodeBgView.layer.borderColor = [UIColor blackColor].CGColor;
    _smsCodeBgView.layer.borderWidth = 1.0f;
    _smsCodeBgView.layer.cornerRadius = 2.0f;
    
    _smsBtn.layer.masksToBounds = YES;
    _smsBtn.layer.cornerRadius = 4.0f;
    _nextBtn.layer.masksToBounds = YES;
    _nextBtn.layer.cornerRadius = 4.0f;
    _resendBtn.layer.masksToBounds = YES;
    _resendBtn.layer.cornerRadius = 4.0f;
}


- (void)viewWillAppear:(BOOL)animated {    // Called when the view is about to made visible. Default does nothing
    // 绑定键盘事件
    [self attachEvent];
    
    if(_startDate)
    {
        [_startDate release];
        _startDate = nil;
    }
    _startDate = [[NSDate date] retain];
    //统计一
    if ( _phoneNum == nil ) {
        [MobClick beginEvent:@"bind_phone_step1" primarykey:@"phone_num" attributes:@{@"phone_num":@""}];
    } else {
        [MobClick beginEvent:@"bind_phone_step1" primarykey:@"phone_num" attributes:@{@"phone_num":_phoneNum}];
    }
}

- (void)viewWillDisappear:(BOOL)animated { // Called when the view is dismissed, covered or otherwise hidden. Default does nothing
    [self detachEvent];
}

-(void)attachEvent {
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(fieldTextChanged:) name:UITextFieldTextDidChangeNotification object:nil];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

-(void)detachEvent {
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UITextFieldTextDidChangeNotification object:nil];
    
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}


- (void)keyboardWillShow: (NSNotification*) notification {
    NSDictionary* userInfo = [notification userInfo];
    NSValue* aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    
    CGRect keyboardRect = [aValue CGRectValue];
    
    keyboardRect = [self.view convertRect:keyboardRect fromView:nil];
    
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:animationDuration];
    
    [UIView commitAnimations];
}

- (void)keyboardWillHide: (NSNotification*) notification {
    NSDictionary* userInfo = [notification userInfo];
    
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:animationDuration];
 
    [UIView commitAnimations];
}


- (IBAction)clearPhone:(id)sender {
    _firstSend = YES;
    _phoneField.text = @"";
    if ( _status != 1 ) {
        // 手机号变化
        [self setStatus:1];
    }
    
    if ( [_phoneField isFirstResponder] ) {
        [_phoneFieldTip setHidden:YES];
    } else {
        [_phoneFieldTip setHidden:NO];
    }
}

- (BOOL) checkPhoneNum : phoneNum {
    if ( [phoneNum length] != 11 ) {
        // 长度不对
        return NO;
    }
    
    for (NSUInteger i = 0; i < [phoneNum length]; i ++ ) {
        unichar uc = [phoneNum characterAtIndex:i];
        if ( !isnumber(uc) ) {
            return NO;
        }
    }
    
    return YES;
}

- (void) showLoading {
    [MBHUDView hudWithBody:@"请等待..." type:MBAlertViewHUDTypeActivityIndicator hidesAfter:-1 show:YES];
}

- (void) hideLoading {
    [MBHUDView dismissCurrentHUD];
}

- (IBAction)cleckSendSms:(id)sender {
    if ( _firstSend ) {
        // 首次发送
        NSString* phoneNum = _phoneField.text;
        if ( [self checkPhoneNum : phoneNum] ) {
            // 发送验证码，进入loading
            [self->phoneValidation attachPhone:phoneNum delegate:self];
            [self showLoading];
            
            return ;
        }
        
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"错误" message:@"请输入有效的手机号码" delegate:self cancelButtonTitle:@"重新输入" otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
    } else {
        // 第二次发送
        [MobClick event:@"bind_phone_resend_code" attributes:@{@"phone_num":_phoneNum}];
        
        [self->phoneValidation sendCheckNumToPhone:self->_token delegate:self ];
        [self showLoading];
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {  // return NO to not change text
    if ( [_phoneField isEqual:textField] ) {
        if ( [string isEqualToString:@""] ) {
            _firstSend = YES;
            if ( _status != 1 ) {
                // 手机号变化
                [self setStatus:1];
            }
            return YES;
        }
        
        if ( _phoneField.text.length + string.length <= 11 ) {
            _firstSend = YES;
            if ( _status != 1 ) {
                // 手机号变化
                [self setStatus:1];
            }
            return YES;
        }
    } else {
        if ( _smsCode.text.length + string.length <= 5 ) {
            return YES;
        }
    }

    return NO;
}

- (void) dealloc {
    if ( _token != nil ) {
        [_token release];
    }

    if ( _phoneNum != nil ) {
        [_phoneNum release];
    }
    
    [self->phoneValidation dealloc];
    
    self.succAlert = nil;
    
    [super dealloc];
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


- (IBAction)hideKeyboard:(id)sender
{
    [self hideKeyboard];
}

- (void) hideKeyboard {
    if ( [_phoneField isFirstResponder] ) {
        [_phoneField resignFirstResponder];
    }
    
    if ( [_smsCode isFirstResponder] ) {
        [_smsCode resignFirstResponder];
    }
}

- (IBAction)clickBack:(id)sender {
    if ( _bSend ) {
        [[BeeUIRouter sharedInstance] open:@"wc_main" animated:YES];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

// 1-等待输入手机号，2-验证码已发送，进入倒计时，3-倒计时结束，可重新发送验证码
- (void) setStatus:(int) status {
    _status = status;
    if ( status == 1 ) {
        _phoneField.enabled = YES;
        _phoneClear.hidden = YES;
        _smsBkg.highlighted = NO;
        _smsCode.hidden = YES;
        _smsBtn.hidden = NO;
        _smsTime.hidden = YES;
        _resendBtn.hidden = YES;
        
        [self updateNextBtnStatus];
        
        [_smsCode setText:@""];
        [_smsCodeTip setText:@""];
        
        [_smsBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
        
    } else if ( status == 2 ) {
        _phoneField.enabled = NO;   // 手机号不可再编辑，要等倒计时结束
        _phoneClear.hidden = YES;
        _smsBkg.highlighted = YES;
        _smsCode.hidden = NO;
        _smsBtn.hidden = YES;
        _smsTime.hidden = YES;
        [_smsCodeTip setText:@""];
        //[_smsBtn setTitle:@"请输入验证码" forState:UIControlStateNormal];
        _resendBtn.hidden = NO;
        _resendBtn.enabled = NO;
        _resendBtn.backgroundColor = [UIColor lightGrayColor];
        [self updateNextBtnStatus];
        
        [_smsCode becomeFirstResponder];
    } else if ( status == 3 ) {
        _phoneField.enabled = YES;   //
        _phoneClear.hidden = YES;
        _smsBkg.highlighted = YES;
        _smsCode.hidden = NO;
        
        if ( _firstSend ) {
            _resendBtn.hidden = YES;
            _smsBtn.hidden = NO;
        } else {
            _resendBtn.hidden = NO;
            _resendBtn.enabled = YES;
            _smsBtn.hidden = YES;
            _resendBtn.backgroundColor = RGB(250, 161, 45);
            [_resendBtn setTitle:@"重新获取" forState:UIControlStateNormal];
        }
        
        _smsTime.hidden = YES;
        [_smsCodeTip setText:@""];
        [self updateNextBtnStatus];
    }
}

- (void) updateNextBtnStatus {
    _nextBtn.hidden = NO;
    _smsCodeBgView.hidden = NO;
    if ( _status == 2 || _status == 3 ) {
        if ( [_smsCode.text length] == 5 ) {
            _nextBtn.enabled = YES;
            _nextBtn.backgroundColor = RGB(128, 195, 26);
        } else {
            _nextBtn.enabled = NO;
            _nextBtn.backgroundColor = [UIColor lightGrayColor];
            if (_firstSend)
            {
                _nextBtn.hidden = YES;
                _smsCodeBgView.hidden = YES;
            }
        }
    } else {
        _nextBtn.hidden = YES;
        _smsCodeBgView.hidden = YES;
        _nextBtn.enabled = NO;
        _nextBtn.backgroundColor = [UIColor lightGrayColor];
    }
}

-(void) sendSMSCompleted : (BOOL) suc errMsg:(NSString*) errMsg  token:(NSString*) token {
    [self hideLoading];
    if ( suc ) {
        [MobClick endEvent:@"bind_phone_step1" primarykey:@"phone_num"];
        [MobClick beginEvent:@"bind_phone_step2" primarykey:@"phone_num" attributes:@{@"phone_num":_phoneNum}];
        
        // 发送完成，进入下一步
        if ( _token != nil ) {
            [_token release];
        }
        
        _token = [token copy];
        
        [self beginTime];
        
        [self setStatus:2];
    } else {
        // 发送失败，错误提示
        if ( errMsg == nil ) {
            UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"错误" message:@"发送验证短信失败" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:nil, nil];
            [alert show];
            [alert release];
        } else {
            UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"错误" message:errMsg delegate:self cancelButtonTitle:@"取消" otherButtonTitles:nil, nil];
            [alert show];
            [alert release];
        }
    }
}

- (void) timerTick :(NSTimer *)timer {
    self->_nTime --;
    if ( self->_nTime <= 0 ) {
        [self endTime];
    }
    
    NSString *text = [[NSString alloc] initWithFormat:@"%d秒后重发", self->_nTime];
    [_resendBtn setTitle:text forState:UIControlStateDisabled];
    [text release];
}

- (void) beginTime {
    [self setStatus:2];
    self->_nTime = 60;
    self->_timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerTick:) userInfo:nil repeats:YES];

    NSString *text = [[NSString alloc] initWithFormat:@"60秒后重发"];
    [_resendBtn setTitle:text forState:UIControlStateDisabled];
    [text release];
}

- (void)fieldTextChanged: (NSNotification*) notification {
    [self updateNextBtnStatus];
}

- (void) endTime {
    if ( self->_timer != nil ) {
        [self->_timer invalidate];
        self->_timer = nil;
    }
    
    [self setStatus:3];
}

-(void) checkSmsCodeCompleted : (BOOL) suc errMsg:(NSString*) errMsg UserId:(NSString*) userId InviteCode:(NSString*)inviteCode boundPhoneNum:(int)boundPhoneNum {
    [self hideLoading];
    if ( suc ) {
        // 发送完成，进入下一步
        [[LoginAndRegister sharedInstance] attachPhone:_phoneNum UserId:userId InviteCode:inviteCode];
        
        [self onBindPhoneCompeted];
        
        NSString* msg = nil;
        
        msg = [NSString stringWithFormat:@"已绑定手机号: %@",_phoneNum];
        
        if (boundPhoneNum > 1)
        {
            msg = [msg stringByAppendingFormat:@"\n\n小猪重要提醒: 小猪鼓励您绑定手机和Pad一起使用小猪，但一个手机号绑定设备最好不要超过3台，绑定过多系统会判断为作弊者而 封！禁! 哦。\n已绑定设备数: %d",boundPhoneNum+1];
        }
        
        UIAlertView* succAlert = [[[UIAlertView alloc] initWithTitle:@"绑定成功！" message:msg delegate:self cancelButtonTitle:@"返回" otherButtonTitles: nil] autorelease];
        self.succAlert = succAlert;
        [succAlert show];
    } else {
        // 发送失败，错误提示
        if ( errMsg == nil ) {
            UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"错误" message:@"发送验证短信失败" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:nil, nil];
            [alert show];
            [alert release];
        } else {
            UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"错误" message:errMsg delegate:self cancelButtonTitle:@"取消" otherButtonTitles:nil, nil];
            [alert show];
            [alert release];
        }
    }
}

-(void) attachPhoneCompleted : (BOOL) suc Token:(NSString*)token errMsg:(NSString*)errMsg {
    [self hideLoading];
    if ( suc ) {
        // 发送完成，进入下一步
        if ( _token != nil ) {
            [_token release];
        }
        
        if ( _phoneNum != nil ) {
            [_phoneNum release];
        }
        _phoneNum = [_phoneField.text copy];
        _token = [token copy];
        _firstSend = NO;
        
        [MobClick endEvent:@"bind_phone_step1" primarykey:@"phone_num"];
        [MobClick beginEvent:@"bind_phone_step2" primarykey:@"phone_num" attributes:@{@"phone_num":_phoneNum}];
        
        [self beginTime];
        
        [self setStatus:2];
    } else {
        // 发送失败，错误提示
        if ( errMsg == nil ) {
            UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"错误" message:@"发送验证短信失败" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:nil, nil];
            [alert show];
            [alert release];
        } else {
            UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"错误" message:errMsg delegate:self cancelButtonTitle:@"取消" otherButtonTitles:nil, nil];
            [alert show];
            [alert release];
        }
    }
}

- (IBAction)clickNext:(id)sender {
    // 下一步
    NSString* checkNum = _smsCode.text;
    
    if ( checkNum.length != 5 ) {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"错误" message:@"请输入5位数的验证码" delegate:self cancelButtonTitle:@"重新输入" otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
    } else {
        //
        [self showLoading];
        // 给服务器发送验证请求
        [self->phoneValidation checkSmsCode:checkNum Token:_token delegate:self];
    }
}

-(void) onBindPhoneCompeted {
    [MobClick endEvent:@"bind_phone_step2" primarykey:@"phone_num"];
    if(_startDate)
    {
        NSTimeInterval interval = [[NSDate date] timeIntervalSinceDate:_startDate];
        [MobClick event:@"bind_phone_all_steps" attributes:@{@"phone_num":_phoneNum,@"result":@"成功"} durations:(interval*1000)];
        
        [_startDate release];
        _startDate = nil;
    }
    
    [BaseTaskTableViewController setNeedReloadTaskList];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    if ( [textField isEqual:_phoneField] ) {
        [_phoneFieldTip setHidden:YES];
    } else if ( [textField isEqual:_smsCode] ) {
        [_smsCodeTip setHidden:YES];
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    if ( [textField isEqual:_phoneField] ) {
        NSString* text = textField.text;
        NSUInteger n = text.length;
        if ( n == 0 ) {
            [_phoneFieldTip setHidden:NO];
        } else {
            [_phoneFieldTip setHidden:YES];
        }
    } else if ( [textField isEqual:_smsCode] ) {
        NSString* text = textField.text;
        NSUInteger n = text.length;
        if ( n == 0 ) {
            [_smsCodeTip setHidden:NO];
        } else {
            [_smsCodeTip setHidden:YES];
        }
    }
}

#pragma mark <UIAlertViewDelegate>

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView == self.succAlert)
    {
        [self clickBack:nil];
    }
}

@end
