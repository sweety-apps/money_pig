//
//  UIGetRedBagAlertView.m
//  wangcai
//
//  Created by Lee Justin on 14-1-23.
//  Copyright (c) 2014年 1528studio. All rights reserved.
//

#import "UIGetRedBagAlertView.h"
#import "NSString+FloatFormat.h"
#import "LoginAndRegister.h"
#import "Common.h"

#define MAX_CATEGORY_NAME_LENGTH 9
#define kTagViewTextFieldJalBreakPassW (1001)

@interface UIGetRedBagAlertView ()
{
    UIView* _alertViewContainer;
    UIImageView* _alertBg;
    UIButton* _getMoneyBtn;
    UIButton* _closeBtn;
    UILabel* _rmbLbl;
    UILabel* _yuanLbl;
    UILabel* _titleLbl;
    UILabel* _lvLbl;
    UILabel* _levelBounusLbl;
    UILabel* _balanceIncreaseLbl;
    
    UIImageView* _levelBlock[5];
    
    CGRect _rectAlertViewContainer;
}

@end

static UIGetRedBagAlertView* gInstance = nil;

@implementation UIGetRedBagAlertView

+ (UIGetRedBagAlertView*)sharedInstance
{
    if (gInstance == nil)
    {
        gInstance = [[UIGetRedBagAlertView alloc] init];
    }
    return gInstance;
}

- (void)setRMBString:(NSString*)rmb
{
    CGFloat lblWidth = [rmb sizeWithFont:_rmbLbl.font].width;
    
    CGRect rectRmb = _rmbLbl.frame;
    rectRmb.size.width = lblWidth;
    //_rmbLbl.frame = rectRmb;
    _rmbLbl.text = rmb;
    
    CGRect rectYuan = _yuanLbl.frame;
    rectYuan.origin.x = CGRectGetMaxX(rectRmb);
    _yuanLbl.frame = rectYuan;
}

- (void) setLevel:(int)level
{
    level = [[LoginAndRegister sharedInstance] getUserLevel];
    //level = 10;
    
    float blocksNum = 0.0f;
    if ([[LoginAndRegister sharedInstance] getNextLevelExp]>0)
    {
        blocksNum = ((float)[[LoginAndRegister sharedInstance] getCurrentExp])/((float)[[LoginAndRegister sharedInstance] getNextLevelExp]);
    }
    int blockN = (int)(blocksNum*5.0f);
    if ( blockN > 5 ) {
        blockN = 5;
    }
    
    for (int i = 0; i < 5; ++i)
    {
        _levelBlock[i].image = [UIImage imageNamed:@"redbag_mb_lv_unget"];
    }
    
    for (int i = 0; i < blockN; ++i)
    {
        _levelBlock[i].image = [UIImage imageNamed:@"redbag_mb_lv_get"];
    }
    
    _lvLbl.text = [NSString stringWithFormat:@"LV%d",level];
    _levelBounusLbl.text = [NSString stringWithFormat:@"等级加成 +%d%@",level,@"%"];
}

- (void) setTitle:(NSString*)title
{
    _titleLbl.text = title;
}

- (void) setShowCurrentBanlance:(int)balance andIncrease:(int)increase
{
    NSString* bal = [NSString stringWithFloatRoundToPrecision:(((float)balance)/100.f) precision:2 ignoreBackZeros:YES];
    NSString* inc = [NSString stringWithFloatRoundToPrecision:(((float)increase)/100.f) precision:2 ignoreBackZeros:YES];
    NSString* new = [NSString stringWithFloatRoundToPrecision:(((float)(balance+increase))/100.f) precision:2 ignoreBackZeros:YES];
    _balanceIncreaseLbl.text = [NSString stringWithFormat:@"当前账户余额 ￥%@ + ￥%@ = ￥%@",bal,inc,new];
    //_balanceIncreaseLbl.hidden = YES;
    //_lvLbl.hidden = YES;
    //_levelBounusLbl.hidden = YES;
    
    for (int i = 0; i < 5; i++)
    {
        //_levelBlock[i].hidden = YES;
    }
}

//含有title，提示内容和1个button
- (id)init
{
    if ((self = [super initWithFrame:[[UIScreen mainScreen] bounds]]))
    {
        // Initialization code
        [self setBackgroundColor:[UIColor clearColor]];
        _bgView = [[UIView alloc] initWithFrame:self.frame];
        [_bgView setBackgroundColor:[UIColor blackColor]];
        
        _rectAlertViewContainer = CGRectMake(0, 0, _bgView.frame.size.width, _bgView.frame.size.height);
        _alertViewContainer = [[[UIView alloc] initWithFrame:_rectAlertViewContainer] autorelease];
        _alertViewContainer.backgroundColor = [UIColor clearColor];
        [self addSubview:_alertViewContainer];
        
        CGRect rectAlertView = CGRectZero;
        CGRect rect = CGRectZero;
        
        _alertBg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"redbag_mb_bg"]];
        rectAlertView = _alertBg.frame;
        rectAlertView.origin = CGPointMake(0.5*(_bgView.frame.size.width - rectAlertView.size.width), 0.5*(_bgView.frame.size.height - rectAlertView.size.height));
        _alertBg.contentMode = UIViewContentModeTopLeft;
        _alertBg.frame = rectAlertView;
        
        _getMoneyBtn = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
        [_getMoneyBtn setImage:[UIImage imageNamed:@"redbag_mb_btn_normal"] forState:UIControlStateNormal];
        [_getMoneyBtn setImage:[UIImage imageNamed:@"redbag_mb_btn_pressed"] forState:UIControlStateHighlighted];
        [_getMoneyBtn addTarget:self action:@selector(pressedGetButton) forControlEvents:UIControlEventTouchUpInside];
        _getMoneyBtn.contentMode = UIViewContentModeTopLeft;
        rect = CGRectOffset(rectAlertView, 252, 265);
        rect.size = [UIImage imageNamed:@"redbag_mb_btn_pressed"].size;
        _getMoneyBtn.frame = rect;
        
        UIImageView* _testBtn = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"redbag_mb_btn_normal"]];
        _testBtn.frame = _getMoneyBtn.frame;
        
        _closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_closeBtn setImage:[UIImage imageNamed:@"redbag_mb_close"] forState:UIControlStateNormal];
        [_closeBtn addTarget:self action:@selector(tapGestureRecognizer) forControlEvents:UIControlEventTouchUpInside];
        rect = CGRectOffset(rectAlertView, 257, -22);
        rect.size = [UIImage imageNamed:@"redbag_mb_close"].size;
        _closeBtn.frame = rect;
        _closeBtn.contentMode = UIViewContentModeTopLeft;
        _closeBtn.hidden = YES;
        
        rect = CGRectOffset(rectAlertView, 31, 13);
        rect.size = CGSizeMake(200, 20);
        _titleLbl = [[UILabel alloc] initWithFrame:rect];
        _titleLbl.textColor = RGB(0, 0, 0);
        _titleLbl.backgroundColor = [UIColor clearColor];
        _titleLbl.font = [UIFont systemFontOfSize:20.0f];
        _titleLbl.textAlignment = NSTextAlignmentLeft;
        _titleLbl.frame = rect;
        _titleLbl.text = @"获得红包";
        _titleLbl.contentMode = UIViewContentModeTopLeft;
        _titleLbl.hidden = YES;
        
        
        rect = CGRectOffset(rectAlertView, 112, 104);
        rect.size = CGSizeMake(120, 75);
        _rmbLbl = [[UILabel alloc] initWithFrame:rect];
        _rmbLbl.textColor = [UIColor whiteColor];
        _rmbLbl.backgroundColor = [UIColor clearColor];
        _rmbLbl.font = [UIFont systemFontOfSize:60.0f];
        _rmbLbl.textAlignment = NSTextAlignmentCenter;
        _rmbLbl.adjustsFontSizeToFitWidth = YES;
        _rmbLbl.frame = rect;
        _rmbLbl.text = @"0.0";
        _rmbLbl.contentMode = UIViewContentModeTopLeft;
        
        rect = CGRectOffset(rectAlertView, 30, 66);
        rect.size = CGSizeMake(100, 31);
        _yuanLbl = [[UILabel alloc] initWithFrame:rect];
        _yuanLbl.textColor = RGB(209, 13, 13);
        _yuanLbl.backgroundColor = [UIColor clearColor];
        _yuanLbl.font = [UIFont systemFontOfSize:30.0f];
        _yuanLbl.textAlignment = NSTextAlignmentLeft;
        _yuanLbl.frame = rect;
        _yuanLbl.text = @"元";
        _yuanLbl.contentMode = UIViewContentModeTopLeft;
        _yuanLbl.hidden = YES;
        
        rect = CGRectOffset(rectAlertView, 132, 113);
        rect.size = CGSizeMake(150, 15);
        _levelBounusLbl = [[UILabel alloc] initWithFrame:rect];
        _levelBounusLbl.textColor = RGB(90, 90, 90);
        _levelBounusLbl.backgroundColor = [UIColor clearColor];
        _levelBounusLbl.font = [UIFont systemFontOfSize:12.0f];
        _levelBounusLbl.textAlignment = NSTextAlignmentLeft;
        _levelBounusLbl.frame = rect;
        _levelBounusLbl.text = @"等级加成 +1%";
        _levelBounusLbl.contentMode = UIViewContentModeTopLeft;
        _levelBounusLbl.hidden = YES;
        
        rect = CGRectOffset(rectAlertView, 30, 113);
        rect.size = CGSizeMake(320, 15);
        _balanceIncreaseLbl = [[UILabel alloc] initWithFrame:rect];
        _balanceIncreaseLbl.textColor = RGB(90, 90, 90);
        _balanceIncreaseLbl.backgroundColor = [UIColor clearColor];
        _balanceIncreaseLbl.font = [UIFont systemFontOfSize:12.0f];
        _balanceIncreaseLbl.textAlignment = NSTextAlignmentLeft;
        _balanceIncreaseLbl.frame = rect;
        _balanceIncreaseLbl.text = @"目前余额";
        _balanceIncreaseLbl.contentMode = UIViewContentModeTopLeft;
        _balanceIncreaseLbl.hidden = YES;
        
        rect = CGRectOffset(rectAlertView, 30, 112);
        rect.size = CGSizeMake(31, 17);
        _lvLbl = [[UILabel alloc] initWithFrame:rect];
        _lvLbl.textColor = RGB(0, 0, 0);
        _lvLbl.backgroundColor = [UIColor clearColor];
        _lvLbl.font = [UIFont systemFontOfSize:16.0f];
        _lvLbl.textAlignment = NSTextAlignmentLeft;
        _lvLbl.frame = rect;
        _lvLbl.text = @"LV1";
        _lvLbl.adjustsFontSizeToFitWidth = YES;
        _lvLbl.contentMode = UIViewContentModeTopLeft;
        _lvLbl.hidden = YES;
        
        UIImage* imgBlk = [UIImage imageNamed:@"redbag_mb_lv_unget"];
        rect = CGRectOffset(rectAlertView, 62, 114);
        rect.size = imgBlk.size;
        for (int i = 0; i < 5; ++i)
        {
            _levelBlock[i] = [[UIImageView alloc] initWithImage:imgBlk];
            _levelBlock[i].frame = rect;
            rect.origin.x += (rect.size.width + 2);
            _levelBlock[i].hidden = YES;
        }
        
        [self addSubview:_bgView];
        [self addSubview:_alertViewContainer];
        [_alertViewContainer addSubview:_alertBg];
        [_alertViewContainer addSubview:_titleLbl];
        [_alertViewContainer addSubview:_rmbLbl];
        [_alertViewContainer addSubview:_yuanLbl];
        [_alertViewContainer addSubview:_closeBtn];
        [_alertViewContainer addSubview:_getMoneyBtn];
        [_alertViewContainer addSubview:_lvLbl];
        [_alertViewContainer addSubview:_levelBounusLbl];
        [_alertViewContainer addSubview:_balanceIncreaseLbl];
        
        //[self addSubview:_testBtn];
        //_getMoneyBtn.hidden = YES;
        
        for (int i = 0; i < 5; ++i)
        {
            [_alertViewContainer addSubview:_levelBlock[i]];
        }
        
        /*
        UITapGestureRecognizer* TapGesturRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureRecognizer)];
        [self addGestureRecognizer:TapGesturRecognizer];
         */
        
        [self showBackground];
        [self showAlertAnmation];
        
    }
    return self;
}

-(void) tapGestureRecognizer {
    if (_delegate && [_delegate respondsToSelector:@selector(onPressedCloseUIGetRedBagAlertView:)])
    {
        [_delegate onPressedCloseUIGetRedBagAlertView:self];
    }
    [self hideAlertView];
    [[NSNotificationCenter defaultCenter] postNotificationName:kUIGetRedBagAlertViewShownNotification object:nil];
}

- (void)pressedGetButton {
    if (_delegate && [_delegate respondsToSelector:@selector(onPressedGetRmbUIGetRedBagAlertView:)])
    {
        [_delegate onPressedGetRmbUIGetRedBagAlertView:self];
    }
    [self hideAlertView];
    [[NSNotificationCenter defaultCenter] postNotificationName:kUIGetRedBagAlertViewShownNotification object:nil];
}

-(void) show
{
    UIWindow* window = [[UIApplication sharedApplication] keyWindow];
    NSArray* windowViews = [window subviews];
    if(windowViews && [windowViews count]>0){
        UIView* subView = [windowViews objectAtIndex:[windowViews count]-1];
        for(UIView* aSubView in subView.subviews)
        {
            [aSubView.layer removeAllAnimations];
        }
        [window addSubview:self];//[subView addSubview:self];
    }
    [self showAlertAnmation];
}


- (void)showBackground
{
    _bgView.alpha = 0;
    _alertViewContainer.alpha = 1.0;
    [UIView beginAnimations:@"fadeIn" context:nil];
    [UIView setAnimationDuration:0.35];
    _bgView.alpha = 0.6;
    [UIView commitAnimations];
}

-(void) showAlertAnmation
{
    _bgView.alpha = 0;
    _alertViewContainer.alpha = 1.0;
    _alertViewContainer.transform = CGAffineTransformIdentity;
    
    CGRect rect0 = _rectAlertViewContainer;
    CGRect rect1 = _rectAlertViewContainer;
    CGRect rect2 = _rectAlertViewContainer;
    CGRect rect3 = _rectAlertViewContainer;
    CGRect rect4 = _rectAlertViewContainer;
    
    rect0.origin.y -= _rectAlertViewContainer.size.height;
    rect1.origin.y += 20;
    rect2.origin.y -= 10;
    rect3.origin.y += 5;
    rect4.origin.y -= 0;
    
    CGAffineTransform trans0 = CGAffineTransformIdentity;
    CGAffineTransform trans1 = CGAffineTransformIdentity;
    CGAffineTransform trans2 = CGAffineTransformMakeRotation(-M_PI / 30);//CGAffineTransformIdentity;//
    CGAffineTransform trans3 = CGAffineTransformMakeRotation(M_PI / 30);//CGAffineTransformIdentity;//
    CGAffineTransform trans4 = CGAffineTransformIdentity;
    
    _alertViewContainer.frame = rect0;
    _alertViewContainer.transform = trans0;
    _alertViewContainer.alpha = 0.0;
    _getMoneyBtn.transform = CGAffineTransformMakeScale(0, 0);
    
    [Common playAddCoinSound];
    [UIView animateWithDuration:0.25f delay:0.0f options:UIViewAnimationOptionCurveEaseIn animations:^(){
        _alertViewContainer.frame = rect1;
        _alertViewContainer.alpha = 1.0;
        _alertViewContainer.transform = trans1;
    } completion:^(BOOL finished){
        _alertViewContainer.alpha = 1.0;
        [UIView animateWithDuration:0.08f delay:0.0f options:UIViewAnimationOptionCurveEaseInOut animations:^(){
            _alertViewContainer.frame = rect2;
            _alertViewContainer.transform = trans2;
        } completion:^(BOOL finished){
            [UIView animateWithDuration:0.05f delay:0.0f options:UIViewAnimationOptionCurveEaseInOut animations:^(){
                _alertViewContainer.frame = rect3;
                _alertViewContainer.transform = trans3;
            } completion:^(BOOL finished){
                [UIView animateWithDuration:0.02f delay:0.0f options:UIViewAnimationOptionCurveEaseInOut animations:^(){
                    _alertViewContainer.frame = rect4;
                    _alertViewContainer.transform = trans4;
                } completion:^(BOOL finished){
                    _alertViewContainer.frame = _rectAlertViewContainer;
                    _alertViewContainer.transform = CGAffineTransformIdentity;
                    [UIView animateWithDuration:0.1f delay:0.0f options:UIViewAnimationOptionCurveEaseOut animations:^(){
                        _getMoneyBtn.transform = CGAffineTransformMakeScale(2.5, 2.5);
                    } completion:^(BOOL finished){
                        [UIView animateWithDuration:0.1f delay:0.0f options:UIViewAnimationOptionCurveEaseIn animations:^(){
                            _getMoneyBtn.transform = CGAffineTransformIdentity;
                        } completion:^(BOOL finished){
                            _getMoneyBtn.transform = CGAffineTransformIdentity;
                        }];
                    }];
                }];
            }];
        }];
    }];
    
    [UIView animateWithDuration:0.35f delay:0.0f options:UIViewAnimationOptionCurveEaseOut animations:^(){
        _bgView.alpha = 0.6;
    } completion:^(BOOL finished){
    }];
}

-(void) hideAlertAnmation
{
    [UIView beginAnimations:@"fadeIn" context:nil];
    [UIView setAnimationDuration:0.35];
    _bgView.alpha = 0;
    _alertViewContainer.alpha = 0.0;
    [UIView commitAnimations];
}


- (void)setDelegate:(id<UIGetRedBagAlertViewDelegate>)delegate
{
    _delegate = delegate;
}

- (void) hideAlertView
{
    [self hideAlertAnmation];
    [self performSelector:@selector(removeFromSuperview) withObject:nil afterDelay:0.2];
}

-(void) removeFromSuperview
{
    [super removeFromSuperview];
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self endEditing:YES];
}


@end
