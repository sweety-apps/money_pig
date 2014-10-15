//
//  InviteViewTableViewCell.m
//  wangcai
//
//  Created by Lee Justin on 14-10-14.
//  Copyright (c) 2014年 1528studio. All rights reserved.
//

#import "InviteViewTableViewCell.h"

@implementation InviteViewTableViewCell

- (void)awakeFromNib
{
    // Initialization code
    [self setToBinded];
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
    self.commitOtherCodeBtn.backgroundColor = RGB(159, 171, 175);
    
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
    
    self.commitOtherCodeBtn.backgroundColor = RGB(132, 196, 77);
    
    self.otherCodeField.layer.masksToBounds = YES;
    self.otherCodeField.layer.borderWidth = 1.0f;
    self.otherCodeField.layer.borderColor = [UIColor blackColor].CGColor;
    self.otherCodeField.layer.cornerRadius = 2.0f;
    self.otherCodeField.backgroundColor = [UIColor whiteColor];
    self.otherCodeField.enabled = YES;
    
    self.shareButton.layer.masksToBounds = YES;
    self.shareButton.layer.cornerRadius = 5.0f;
    
    self.shareButton.backgroundColor = RGB(132, 196, 77);
    
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
    [super dealloc];
}
@end
