//
//  InviteViewTableViewCell.m
//  wangcai
//
//  Created by Lee Justin on 14-10-14.
//  Copyright (c) 2014年 1528studio. All rights reserved.
//

#import "InviteViewTableViewCell.h"
#import "UIImage+imageUtils.h"

@implementation InviteViewTableViewCell

- (void)awakeFromNib
{
    // Initialization code
    [self setToUnbind];
}

- (void)setHasBindCode:(BOOL)hasBind
{
    if (hasBind)
    {
        [self setToBinded];
    }
    else
    {
        [self setToUnbind];
    }
}

- (void)setToBinded
{
    self.commitOtherCodeBtn.layer.masksToBounds = YES;
    self.otherCodeField.layer.masksToBounds = YES;
    self.shareButton.layer.masksToBounds = YES;
    self.myCodeLabel.layer.masksToBounds = YES;
    
    [self.commitOtherCodeBtn setBackgroundImage:nil forState:UIControlStateNormal];
    self.commitOtherCodeBtn.backgroundColor = RGB(159, 171, 175);
    
    self.commitOtherCodeBtnShadowView.hidden = YES;
    
    self.otherCodeField.layer.borderWidth = 0.0f;
    self.otherCodeField.layer.borderColor = [UIColor clearColor].CGColor;
    self.otherCodeField.enabled = NO;
    self.otherCodeField.backgroundColor = self.myCodeLabel.backgroundColor;
    
    [self.commitOtherCodeBtn setTitle:@"已领取" forState:UIControlStateNormal];
    self.commitOtherCodeBtn.enabled = NO;
    
}

- (void)setToUnbind
{
    self.commitOtherCodeBtn.layer.masksToBounds = YES;
    self.commitOtherCodeBtn.layer.cornerRadius = 5.0f;
    
    [self.commitOtherCodeBtn setBackgroundImage:[UIImage imageWithPureColor:RGB(250, 161, 45)] forState:UIControlStateNormal];
    self.commitOtherCodeBtn.backgroundColor = [UIColor clearColor];
    
    self.commitOtherCodeBtnShadowView.layer.masksToBounds = YES;
    self.commitOtherCodeBtnShadowView.layer.cornerRadius = 5.0f;
    
    self.commitOtherCodeBtnShadowView.backgroundColor = RGB(176, 104, 27);
    
    self.commitOtherCodeBtnShadowView.hidden = NO;
    
    self.otherCodeField.layer.masksToBounds = YES;
    self.otherCodeField.layer.borderWidth = 1.0f;
    self.otherCodeField.layer.borderColor = [UIColor blackColor].CGColor;
    self.otherCodeField.layer.cornerRadius = 2.0f;
    self.otherCodeField.backgroundColor = [UIColor whiteColor];
    self.otherCodeField.enabled = YES;
    
    self.shareButton.layer.masksToBounds = YES;
    self.shareButton.layer.cornerRadius = 5.0f;
    
    [self.shareButton setBackgroundImage:[UIImage imageWithPureColor:RGB(250, 161, 45)] forState:UIControlStateNormal];
    self.shareButton.backgroundColor = [UIColor clearColor];
    
    self.shareButtonShadowView.layer.masksToBounds = YES;
    self.shareButtonShadowView.layer.cornerRadius = 5.0f;
    
    self.shareButtonShadowView.backgroundColor = RGB(176, 104, 27);
    
    self.myCodeLabel.layer.masksToBounds = YES;
    self.myCodeLabel.layer.cornerRadius = 2.0f;
    
    [self.commitOtherCodeBtn setTitle:@"领2元" forState:UIControlStateNormal];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)dealloc {
    [_myCodeLabel release];
    [_shareButton release];
    [_friendShareEarnLabel release];
    [_firendEarnDetailBtn release];
    [_myBgView release];
    [_otherBgView release];
    [_otherCodeField release];
    [_commitOtherCodeBtn release];
    [_qrcodeImageView release];
    [_shareButtonShadowView release];
    [_commitOtherCodeBtnShadowView release];
    [super dealloc];
}
@end
