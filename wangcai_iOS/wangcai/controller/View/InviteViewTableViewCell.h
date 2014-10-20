//
//  InviteViewTableViewCell.h
//  wangcai
//
//  Created by Lee Justin on 14-10-14.
//  Copyright (c) 2014年 1528studio. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InviteViewTableViewCell : UITableViewCell

@property (retain, nonatomic) IBOutlet UILabel *myCodeLabel;
@property (retain, nonatomic) IBOutlet UIButton *shareButton;
@property (retain, nonatomic) IBOutlet UILabel *friendShareEarnLabel;
@property (retain, nonatomic) IBOutlet UIButton *firendEarnDetailBtn;
@property (retain, nonatomic) IBOutlet UIView *myBgView;
@property (retain, nonatomic) IBOutlet UIView *otherBgView;
@property (retain, nonatomic) IBOutlet UITextField *otherCodeField;
@property (retain, nonatomic) IBOutlet UIButton *commitOtherCodeBtn;
@property (retain, nonatomic) IBOutlet UIImageView *qrcodeImageView;
@property (retain, nonatomic) IBOutlet UIView *shareButtonShadowView;
@property (retain, nonatomic) IBOutlet UIView *commitOtherCodeBtnShadowView;


- (void)setHasBindCode:(BOOL)hasBind;

@end
