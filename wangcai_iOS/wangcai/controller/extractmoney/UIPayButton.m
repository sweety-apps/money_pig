//
//  UIPayButton.m
//  wangcai
//
//  Created by NPHD on 14-3-19.
//  Copyright (c) 2014年 1528studio. All rights reserved.
//

#import "UIPayButton.h"

@interface UIPayButton ()

@end

@implementation UIPayButton

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _delegate = nil;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) setAmount:(int) amount Reward:(int) reward Hot:(BOOL) hot Delegate:(id) delegate{
    _delegate = delegate;
    _amount = amount;
    _reward = reward;
    
    UIButton* btn = nil;
    if ( hot ) {
        [[self.view viewWithTag:11] setHidden:YES];
        [[self.view viewWithTag:12] setHidden:NO];
        
        btn = (UIButton*)[self.view viewWithTag:12];
    } else {
        [[self.view viewWithTag:11] setHidden:NO];
        [[self.view viewWithTag:12] setHidden:YES];
        
        btn = (UIButton*)[self.view viewWithTag:11];
    }
    
    //[btn addTarget:self action:@selector(onClick:) forControlEvents:UIControlEventTouchUpInside];
    
    if ( reward == 0 ) {
        // 没有折扣
        [[self.view viewWithTag:31] setHidden:NO];
        
        [[self.view viewWithTag:41] setHidden:YES];
        [[self.view viewWithTag:42] setHidden:YES];
        [[self.view viewWithTag:43] setHidden:YES];
        [[self.view viewWithTag:44] setHidden:YES];
        
        UILabel* label = (UILabel*)[self.view viewWithTag:31];
        NSString* text = [NSString stringWithFormat:@"%d 元", amount / 100];
        [label setText:text];
    } else {
        [[self.view viewWithTag:31] setHidden:YES];
        
        [[self.view viewWithTag:41] setHidden:NO];
        [[self.view viewWithTag:42] setHidden:NO];
        [[self.view viewWithTag:43] setHidden:NO];
        [[self.view viewWithTag:44] setHidden:NO];
        
        UILabel* label = (UILabel*)[self.view viewWithTag:41];
        NSString* text = [NSString stringWithFormat:@"%d 元", amount / 100];
        [label setText:text];
        
        UILabel* label2 = (UILabel*)[self.view viewWithTag:44];
        NSString* text2 = [NSString stringWithFormat:@"%d", reward / 100];
        [label2 setText:text2];
    }
}

- (IBAction) onClick:(id)sender {
    if ( _delegate != nil ) {
        [_delegate onClickPay:_amount Reward:_reward];
    }
}


@end
