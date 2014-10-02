//
//  OfferwallTableViewCell.m
//  wangcai
//
//  Created by Lee Justin on 14-10-1.
//  Copyright (c) 2014年 1528studio. All rights reserved.
//

#import "OfferwallTableViewCell.h"

@implementation OfferwallTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

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
    [_hotMarkImageView release];
    [super dealloc];
}
@end
