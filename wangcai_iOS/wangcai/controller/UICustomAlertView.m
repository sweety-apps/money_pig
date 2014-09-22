//
//  UICustomAlertView.m
//  wangcai
//
//  Created by 1528 on 14-1-7.
//  Copyright (c) 2014年 1528studio. All rights reserved.
//

#import "UICustomAlertView.h"



#define MAX_CATEGORY_NAME_LENGTH 9
#define kTagViewTextFieldJalBreakPassW (1001)


@implementation UICustomAlertView


//含有title，提示内容以及两个button.
- (id)init:(UIView*) alertView
{
    if ((self = [super initWithFrame:[[UIScreen mainScreen] bounds]]))
    {
        // Initialization code
        [self setBackgroundColor:[UIColor clearColor]];
        _bgView = [[UIView alloc] initWithFrame:self.frame];
        [_bgView setBackgroundColor:[UIColor blackColor]];
        
        [self addSubview:_bgView];
        [_bgView release];
        
        CGRect alertRect = [self getAlertBounds:alertView];
        _alertView = [alertView retain];
        _alertView.frame = alertRect;
        
        UIImageView *alertBg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, alertRect.size.width, alertRect.size.height)];
        alertBg.image = [UIImage imageNamed:@"AlertView_background.png"];
        [_alertView addSubview:alertBg];
        [alertBg release];
        
        [self addSubview:_alertView];

        UITapGestureRecognizer* TapGesturRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureRecognizer)];
        [self addGestureRecognizer:TapGesturRecognizer];
        
        [self showBackground];
        [self showAlertAnmation];
        
    }
    return self;
}

-(void) tapGestureRecognizer {
    //[self hideAlertView];
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
        [subView addSubview:self];
    }
    
}


- (void)showBackground
{
    _bgView.alpha = 0;
    [UIView beginAnimations:@"fadeIn" context:nil];
    [UIView setAnimationDuration:0.35];
    _bgView.alpha = 0.6;
    [UIView commitAnimations];
}

-(void) showAlertAnmation
{
    CAKeyframeAnimation * animation;
    animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    animation.duration = 0.20;
    animation.removedOnCompletion = YES;
    animation.fillMode = kCAFillModeForwards;
    NSMutableArray *values = [NSMutableArray array];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.9, 0.9, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.1, 1.1, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)]];
    animation.values = values;
    [_alertView.layer addAnimation:animation forKey:nil];
    
}

-(void) hideAlertAnmation
{
    [UIView beginAnimations:@"fadeIn" context:nil];
    [UIView setAnimationDuration:0.35];
    _bgView.alpha = 0.0;
    _alertView.alpha = 0.0;
    [UIView commitAnimations];
}



-(CGRect)getAlertBounds:(UIView*) view
{
    CGSize size = view.frame.size;
    
    CGRect retRect = CGRectMake((self.frame.size.width-size.width)/2, (self.frame.size.height-size.height)/2,
                                size.width, size.height);
    
    return retRect;
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