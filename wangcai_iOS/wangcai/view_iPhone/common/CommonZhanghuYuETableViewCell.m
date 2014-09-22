//
//  CommonZhanghuYuETableViewCell.m
//  wangcai
//
//  Created by Lee Justin on 13-12-23.
//  Copyright (c) 2013年 1528studio. All rights reserved.
//

#import "CommonZhanghuYuETableViewCell.h"

@implementation CommonZhanghuYuETableViewCell

@synthesize yuENumView;

@synthesize tixianButton;
@synthesize tixianIcon;
@synthesize tixianLabel;

@synthesize qiandaoButton;
@synthesize qiandaoIcon;
@synthesize qiandaoLabel;
@synthesize qiandaoRedDotBubble;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)dealloc
{
    self.yuENumView = nil;
    [super dealloc];
}


@end
