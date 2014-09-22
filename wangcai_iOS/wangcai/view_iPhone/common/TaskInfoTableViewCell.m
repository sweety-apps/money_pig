//
//  TaskInfoTableViewCell.m
//  wangcai
//
//  Created by Lee Justin on 13-12-14.
//  Copyright (c) 2013年 1528studio. All rights reserved.
//

#import "TaskInfoTableViewCell.h"
#import "NSString+FloatFormat.h"

@implementation TaskInfoTableViewCell

@synthesize jintianhainengzhuanLabel;

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
    self.jintianhainengzhuanLabel = nil;
    [super dealloc];
}

- (void)setJinTianHaiNengZhuanNumLabelText:(NSString*)text
{
    self.jintianhainengzhuanLabel.text = text;
}

- (void)setJinTianHaiNengZhuanNumLabelTextNum:(float)num
{
    self.jintianhainengzhuanLabel.text = [NSString stringWithFloatRoundToPrecision:num precision:2 ignoreBackZeros:YES];
}

@end
