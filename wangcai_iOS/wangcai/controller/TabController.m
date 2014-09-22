//
//  TabController.m
//  wangcai
//
//  Created by 1528 on 13-12-14.
//  Copyright (c) 2013年 1528studio. All rights reserved.
//

#import "TabController.h"

@interface TabController ()

@end

@implementation TabController

- (id)init:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:@"TabController" bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.view = [[[NSBundle mainBundle] loadNibNamed:@"TabController" owner:self options:nil] firstObject];
    }
    return self;
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

- (void) setTabInfo:(NSString*)tab1 Tab2:(NSString*)tab2 Tab3:(NSString*)tab3 Purse:(float) purse {
    if ( tab3 == nil ) {
        // 调整项目位置
        [[self.view viewWithTag:77] setHidden:YES];
        UIView* split = [self.view viewWithTag:76];
        CGRect rect = split.frame;
        rect.origin.x += 54;
        [split setFrame:rect];
        
        for (int i = 21; i <= 22; i ++) {
            UIView* view = [self.view viewWithTag:i];
            [view setHidden:YES];
        }
        
        for (int i = 11; i <= 12; i ++ ) {
            UIView* view = [self.view viewWithTag:i];
            CGRect rect = view.frame;
            rect.origin.x += 40;
            [view setFrame:rect];
        }
        
        for (int i = 31; i <= 33; i ++ ) {
            UIView* view = [self.view viewWithTag:i];
            CGRect rect = view.frame;
            rect.origin.x -= 34;
            [view setFrame:rect];
        }
    }
    
    UILabel* label1 = (UILabel*)[self.view viewWithTag:11];
    UILabel* label2 = (UILabel*)[self.view viewWithTag:21];
    UILabel* label3 = (UILabel*)[self.view viewWithTag:31];
    
    label1.text = tab1;
    if ( tab3 == nil ) {
        label3.text = tab2;
    } else {
        label2.text = tab2;
        label3.text = tab3;
    }
    
    if ( purse == 0 ) {
        label3.textAlignment = UITextAlignmentCenter;
        
        [[self.view viewWithTag:33] setHidden:YES];
    } else {
        label3.textAlignment = UITextAlignmentLeft;
        
        UIImageView* imageView = (UIImageView*)[self.view viewWithTag:33];
        UIImage* image = nil;
        if ( purse == 1 ) {
            image = [UIImage imageNamed:@"package_icon_one@2x.png"];
        } else if ( purse == 3 ) {
            image = [UIImage imageNamed:@"package_icon_3@2x.png"];
        } else if ( purse == 8 ) {
            image = [UIImage imageNamed:@"package_icon_8@2x.png"];
        } else if ( purse == 0.5 ) {
            image = [UIImage imageNamed:@"package_icon_half@2x.png"];
        }
        
        if ( image != nil ) {
            [imageView setImage:image];
        } else {
            [[self.view viewWithTag:33] setHidden:YES];
        }
    }
}

- (void) selectTab:(int)index {
    UIView* view = [self.view viewWithTag:1];
    CGRect rect = view.frame;
    UIView* viewText = nil;
    
    if ( [[self.view viewWithTag:21] isHidden] ) {
        // 只显示了两个项目
        if ( index > 2 || index < 1 ) {
            return ;
        }
        
        if ( index == 1 ) {
            viewText = [self.view viewWithTag:11];
        } else if ( index == 2 ) {
            viewText = [self.view viewWithTag:31];
        }
    } else {
        // 显示了3个项目
        if ( index > 3 || index < 1 ) {
            return ;
        }
    
        if ( index == 1 ) {
            viewText = [self.view viewWithTag:11];
        } else if ( index == 2 ) {
            viewText = [self.view viewWithTag:21];
        } else if ( index == 3 ) {
            viewText = [self.view viewWithTag:31];
        }
    }
    
    CGRect destRect = viewText.frame;
    rect.origin.x = destRect.origin.x + destRect.size.width  / 2 - rect.size.width / 2;
    
    [view setFrame:rect];
    
    [((UILabel*)[self.view viewWithTag:11]) setTextColor:[UIColor colorWithRed:103.0/255 green:103.0/255 blue:103.0/255 alpha:1]];
    [((UILabel*)[self.view viewWithTag:21]) setTextColor:[UIColor colorWithRed:103.0/255 green:103.0/255 blue:103.0/255 alpha:1]];
    [((UILabel*)[self.view viewWithTag:31]) setTextColor:[UIColor colorWithRed:103.0/255 green:103.0/255 blue:103.0/255 alpha:1]];
    
    [((UILabel*)viewText) setTextColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:1]];
}

@end
