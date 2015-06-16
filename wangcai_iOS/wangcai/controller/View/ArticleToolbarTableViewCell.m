//
//  ArticleToolbarTableViewCell.m
//  wangcai
//
//  Created by Lee Justin on 14-11-3.
//  Copyright (c) 2014年 1528studio. All rights reserved.
//

#import "ArticleToolbarTableViewCell.h"
#import "UIImage+imageUtils.h"

@implementation ArticleToolbarTableViewCell

- (void)awakeFromNib {
    // Initialization code
    self.inviteButton.layer.masksToBounds = YES;
    self.inviteButton.layer.cornerRadius = 5.0f;
    
    self.taskButton.layer.masksToBounds = YES;
    self.taskButton.layer.cornerRadius = 5.0f;
    
    UIImage* icon = nil;
    icon = [self.inviteButton imageForState:UIControlStateNormal];
    icon = [icon imageBlendWithColor:[UIColor whiteColor]];
    [self.inviteButton setImage:icon forState:UIControlStateNormal];
    [self.inviteButton setBackgroundImage:[UIImage imageWithPureColor:self.inviteButton.backgroundColor] forState:UIControlStateNormal];
    [self.inviteButton setImage:icon forState:UIControlStateHighlighted];
    
    icon = [self.taskButton imageForState:UIControlStateNormal];
    icon = [icon imageBlendWithColor:[UIColor whiteColor]];
    [self.taskButton setImage:icon forState:UIControlStateNormal];
    [self.taskButton setBackgroundImage:[UIImage imageWithPureColor:self.taskButton.backgroundColor] forState:UIControlStateNormal];
    [self.taskButton setImage:icon forState:UIControlStateHighlighted];
    
    [self.taskButton addTarget:self action:@selector(_onPressedTask) forControlEvents:UIControlEventTouchUpInside];
    [self.inviteButton addTarget:self action:@selector(_onPressedInvite) forControlEvents:UIControlEventTouchUpInside];
}

- (void) _onPressedTask
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(onArticleToolbarPressedTaskButton:)])
    {
        [self.delegate onArticleToolbarPressedTaskButton:self];
    }
}

- (void) _onPressedInvite
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(onArticleToolbarPressedInviteButton:)])
    {
        [self.delegate onArticleToolbarPressedInviteButton:self];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)dealloc {
    [_inviteButton release];
    [_taskButton release];
    [super dealloc];
}
@end
