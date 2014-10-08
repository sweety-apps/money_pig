//
//  ExtractAndExchangeTableViewCell.m
//  wangcai
//
//  Created by Lee Justin on 14-10-8.
//  Copyright (c) 2014年 1528studio. All rights reserved.
//

#import "ExtractAndExchangeTableViewCell.h"

@implementation ExtractAndExchangeTableViewCell

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)dealloc {
    [_iconImageView release];
    [_nameLabel release];
    [_desLabel release];
    [_cheapMarkImageView release];
    [super dealloc];
}
@end
