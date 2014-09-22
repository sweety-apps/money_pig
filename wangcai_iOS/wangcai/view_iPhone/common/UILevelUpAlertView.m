//
//  UILevelUpAlertView.m
//  wangcai
//
//  Created by Lee Justin on 14-2-22.
//  Copyright (c) 2014年 1528studio. All rights reserved.
//

#import "Bee.h"
#import "UILevelUpAlertView.h"
#import "LoginAndRegister.h"
#import "MobClick.h"

@interface UILevelUpAlertView ()
{
    UIView* _alertViewContainer;
    UIImageView* _alertBg;
    UIButton* _checkBtn;
    UIButton* _downCloseBtn;
    UIButton* _closeBtn;
    UILabel* _titleLbl;
    UILabel* _titleLevelLbl;
    UILabel* _extraRedBagLbl;
    UILabel* _extraRedBagValLbl;
    UILabel* _skillLbl;
    UILabel* _skillValLbl;
    UILabel* _awardLbl;
    UILabel* _awardRedLbl;
}

@end

static UILevelUpAlertView* gInstance = nil;

@implementation UILevelUpAlertView

+ (UILevelUpAlertView*)sharedInstance
{
    if (gInstance == nil)
    {
        gInstance = [[UILevelUpAlertView alloc] init];
    }
    return gInstance;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void) setLevel:(int)level level:(int)levelChange
{
    NSString* skill = @"";
    if (level == 3)
    {
        skill = @"百发百中";
    }
    if (level == 5)
    {
        skill = @"基友情深";
    }
    if (level == 10)
    {
        skill = @"一石二鸟";
    }

    int extraPlus = level;
    if ([[[LoginAndRegister sharedInstance] getPhoneNum] length]==0)
    {
        extraPlus = level;
    }
    
    _titleLevelLbl.text = [NSString stringWithFormat:@"Lv%d",level];
    _extraRedBagValLbl.text = [NSString stringWithFormat:@"%d%@",extraPlus,@"%"];
    _skillValLbl.text=skill;
    
    CGRect rectAlertView = _alertBg.frame;
    
    CGRect rectExtra = _extraRedBagLbl.frame;
    CGRect rectExtraVal = _extraRedBagValLbl.frame;
    CGRect rectSkill = _skillLbl.frame;
    CGRect rectSkillVal = _skillValLbl.frame;
    
    rectExtra = CGRectOffset(rectAlertView, 24, 116);
    rectExtra.size = _extraRedBagLbl.frame.size;
    
    rectExtraVal = CGRectOffset(rectAlertView, 118, 116);
    rectExtraVal.size = _extraRedBagValLbl.frame.size;
    
    rectSkill = CGRectOffset(rectAlertView, 24, 148);
    rectSkill.size = _skillLbl.frame.size;
    
    rectSkillVal = CGRectOffset(rectAlertView, 118, 148);
    rectSkillVal.size = _skillValLbl.frame.size;
    
    if ([skill length] > 0)
    {
        _skillLbl.hidden = NO;
        _skillValLbl.hidden = NO;
    }
    else
    {
        rectExtra.origin.y += 20;
        rectExtraVal.origin.y += 20;
        rectSkill.origin.y += 20;
        rectSkillVal.origin.y += 20;
        
        _skillLbl.hidden = YES;
        _skillValLbl.hidden = YES;
    }
    
    _skillLbl.frame = rectSkill;
    _skillValLbl.frame = rectSkillVal;
    _extraRedBagLbl.frame = rectExtra;
    _extraRedBagValLbl.frame = rectExtraVal;
    
    if ( levelChange == 0 ) {
        [_awardLbl setHidden:YES];
        [_awardRedLbl setHidden:YES];
    } else {
        [_awardLbl setHidden:NO];
        [_awardRedLbl setHidden:NO];
        
        NSString* text = [NSString stringWithFormat:@"%.2f元", 1.0*levelChange/100];
        [_awardRedLbl setText:text];
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
        
        _alertViewContainer = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, _bgView.frame.size.width, _bgView.frame.size.height)] autorelease];
        _alertViewContainer.backgroundColor = [UIColor clearColor];
        [self addSubview:_alertViewContainer];
        
        CGRect rectAlertView = CGRectZero;
        CGRect rect = CGRectZero;
        
        _alertBg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"levelup_bg"]];
        rectAlertView = _alertBg.frame;
        rectAlertView.origin = CGPointMake(0.5*(_bgView.frame.size.width - rectAlertView.size.width), 0.5*(_bgView.frame.size.height - rectAlertView.size.height));
        _alertBg.contentMode = UIViewContentModeTopLeft;
        _alertBg.frame = rectAlertView;
        
        _checkBtn = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
        [_checkBtn setImage:[UIImage imageNamed:@"levelup_check_btn"] forState:UIControlStateNormal];
        [_checkBtn setImage:[UIImage imageNamed:@"levelup_check_btn_pressed"] forState:UIControlStateHighlighted];
        [_checkBtn addTarget:self action:@selector(pressedGetButton) forControlEvents:UIControlEventTouchUpInside];
        _checkBtn.contentMode = UIViewContentModeTopLeft;
        rect = CGRectOffset(rectAlertView, 148, 249);
        rect.size = [UIImage imageNamed:@"levelup_check_btn_pressed"].size;
        _checkBtn.frame = rect;
        
        _downCloseBtn = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
        [_downCloseBtn setImage:[UIImage imageNamed:@"levelup_close_btn"] forState:UIControlStateNormal];
        [_downCloseBtn setImage:[UIImage imageNamed:@"levelup_close_btn_pressed"] forState:UIControlStateHighlighted];
        [_downCloseBtn addTarget:self action:@selector(tapGestureRecognizer) forControlEvents:UIControlEventTouchUpInside];
        _downCloseBtn.contentMode = UIViewContentModeTopLeft;
        rect = CGRectOffset(rectAlertView, 15, 249);
        rect.size = [UIImage imageNamed:@"levelup_close_btn_pressed"].size;
        _downCloseBtn.frame = rect;
        
        _closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_closeBtn setImage:[UIImage imageNamed:@"levelup_close_btn_up"] forState:UIControlStateNormal];
        [_closeBtn addTarget:self action:@selector(tapGestureRecognizer) forControlEvents:UIControlEventTouchUpInside];
        rect = CGRectOffset(rectAlertView, 285-29, -22);
        rect.size = [UIImage imageNamed:@"levelup_close_btn_up"].size;
        _closeBtn.frame = rect;
        _closeBtn.contentMode = UIViewContentModeTopLeft;
        
        rect = CGRectOffset(rectAlertView, 22, 54);
        rect.size = CGSizeMake(200, 28);
        _titleLbl = [[UILabel alloc] initWithFrame:rect];
        _titleLbl.textColor = RGB(0, 0, 0);
        _titleLbl.backgroundColor = [UIColor clearColor];
        _titleLbl.font = [UIFont boldSystemFontOfSize:26.0f];
        _titleLbl.textAlignment = NSTextAlignmentLeft;
        _titleLbl.frame = rect;
        _titleLbl.text = @"恭喜您升级到";
        _titleLbl.contentMode = UIViewContentModeTopLeft;
        
        rect = CGRectOffset(rectAlertView, 194, 48);
        rect.size = CGSizeMake(200, 36);
        _titleLevelLbl = [[UILabel alloc] initWithFrame:rect];
        _titleLevelLbl.textColor = RGB(214, 0, 0);
        _titleLevelLbl.backgroundColor = [UIColor clearColor];
        _titleLevelLbl.font = [UIFont boldSystemFontOfSize:36.0f];
        _titleLevelLbl.textAlignment = NSTextAlignmentLeft;
        _titleLevelLbl.frame = rect;
        _titleLevelLbl.text = @"Lv2";
        _titleLevelLbl.contentMode = UIViewContentModeTopLeft;
        
        rect = CGRectOffset(rectAlertView, 24, 116);
        rect.size = CGSizeMake(200, 22);
        _extraRedBagLbl = [[UILabel alloc] initWithFrame:rect];
        _extraRedBagLbl.textColor = RGB(139, 139, 139);
        _extraRedBagLbl.backgroundColor = [UIColor clearColor];
        _extraRedBagLbl.font = [UIFont systemFontOfSize:20.0f];
        _extraRedBagLbl.textAlignment = NSTextAlignmentLeft;
        _extraRedBagLbl.frame = rect;
        _extraRedBagLbl.text = @"额外红包:";
        _extraRedBagLbl.contentMode = UIViewContentModeTopLeft;
        
        rect = CGRectOffset(rectAlertView, 118, 116);
        rect.size = CGSizeMake(200, 20);
        _extraRedBagValLbl = [[UILabel alloc] initWithFrame:rect];
        _extraRedBagValLbl.textColor = RGB(11, 104, 208);
        _extraRedBagValLbl.backgroundColor = [UIColor clearColor];
        _extraRedBagValLbl.font = [UIFont systemFontOfSize:20.0f];
        _extraRedBagValLbl.textAlignment = NSTextAlignmentLeft;
        _extraRedBagValLbl.frame = rect;
        _extraRedBagValLbl.text = @"恭喜您升级到";
        _extraRedBagValLbl.contentMode = UIViewContentModeTopLeft;
        
        rect = CGRectOffset(rectAlertView, 24, 148);
        rect.size = CGSizeMake(200, 20);
        _skillLbl = [[UILabel alloc] initWithFrame:rect];
        _skillLbl.textColor = RGB(139, 139, 139);
        _skillLbl.backgroundColor = [UIColor clearColor];
        _skillLbl.font = [UIFont systemFontOfSize:20.0f];
        _skillLbl.textAlignment = NSTextAlignmentLeft;
        _skillLbl.frame = rect;
        _skillLbl.text = @"获得技能:";
        _skillLbl.contentMode = UIViewContentModeTopLeft;
        
        rect = CGRectOffset(rectAlertView, 118, 148);
        rect.size = CGSizeMake(200, 20);
        _skillValLbl = [[UILabel alloc] initWithFrame:rect];
        _skillValLbl.textColor = RGB(11, 104, 208);
        _skillValLbl.backgroundColor = [UIColor clearColor];
        _skillValLbl.font = [UIFont systemFontOfSize:20.0f];
        _skillValLbl.textAlignment = NSTextAlignmentLeft;
        _skillValLbl.frame = rect;
        _skillValLbl.text = @"恭喜您升级到";
        _skillValLbl.contentMode = UIViewContentModeTopLeft;
        
        
        
        
        rect = CGRectOffset(rectAlertView, 24, 180);
        rect.size = CGSizeMake(200, 20);
        _awardLbl = [[UILabel alloc] initWithFrame:rect];
        _awardLbl.textColor = RGB(139, 139, 139);
        _awardLbl.backgroundColor = [UIColor clearColor];
        _awardLbl.font = [UIFont systemFontOfSize:20.0f];
        _awardLbl.textAlignment = NSTextAlignmentLeft;
        _awardLbl.frame = rect;
        _awardLbl.text = @"升级奖励:";
        _awardLbl.contentMode = UIViewContentModeTopLeft;
        
        rect = CGRectOffset(rectAlertView, 118, 180);
        rect.size = CGSizeMake(200, 20);
        _awardRedLbl = [[UILabel alloc] initWithFrame:rect];
        _awardRedLbl.textColor = RGB(209, 13, 13);
        _awardRedLbl.backgroundColor = [UIColor clearColor];
        _awardRedLbl.font = [UIFont systemFontOfSize:20.0f];
        _awardRedLbl.textAlignment = NSTextAlignmentLeft;
        _awardRedLbl.frame = rect;
        _awardRedLbl.text = @"2.0元";
        _awardRedLbl.contentMode = UIViewContentModeTopLeft;
        
        [self addSubview:_bgView];
        [self addSubview:_alertViewContainer];
        [_alertViewContainer addSubview:_alertBg];
        [_alertViewContainer addSubview:_titleLbl];
        [_alertViewContainer addSubview:_titleLevelLbl];
        [_alertViewContainer addSubview:_extraRedBagLbl];
        [_alertViewContainer addSubview:_extraRedBagValLbl];
        [_alertViewContainer addSubview:_skillLbl];
        [_alertViewContainer addSubview:_skillValLbl];
        [_alertViewContainer addSubview:_closeBtn];
        [_alertViewContainer addSubview:_downCloseBtn];
        [_alertViewContainer addSubview:_checkBtn];
        [_alertViewContainer addSubview:_awardLbl];
        [_alertViewContainer addSubview:_awardRedLbl];
        
        [self showBackground];
        [self showAlertAnmation];
        
    }
    return self;
}

-(void) tapGestureRecognizer {
    if (_delegate && [_delegate respondsToSelector:@selector(onPressedCloseUILevelUpAlertView:)])
    {
        [_delegate onPressedCloseUILevelUpAlertView:self];
    }
    [self hideAlertView];
}

- (void)pressedGetButton {
    if (_delegate && [_delegate respondsToSelector:@selector(onPressedCheckLevelUILevelUpAlertView:)])
    {
        [_delegate onPressedCheckLevelUILevelUpAlertView:self];
    }
    [MobClick event:@"click_extract_money" attributes:@{@"current_page":@"等级弹框"}];
	[[BeeUIRouter sharedInstance] open:@"my_wangcai" animated:YES];
    [self hideAlertView];
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
    _alertViewContainer.transform = CGAffineTransformMakeScale(0.0f, 0.0f);
    [UIView animateWithDuration:0.2f delay:0.0f options:UIViewAnimationOptionCurveEaseOut animations:^(){
        _alertViewContainer.transform = CGAffineTransformMakeScale(1.1, 1.1);
    } completion:^(BOOL finished){
        [UIView animateWithDuration:0.1f delay:0.0f options:UIViewAnimationOptionCurveEaseIn animations:^(){
            _alertViewContainer.transform = CGAffineTransformIdentity;
        } completion:^(BOOL finished){
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


- (void)setDelegate:(id<UILevelUpAlertViewDelegate>)delegate
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
