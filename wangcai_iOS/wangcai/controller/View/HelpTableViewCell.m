//
//  HelpTableViewCell.m
//  wangcai
//
//  Created by Lee Justin on 14-10-16.
//  Copyright (c) 2014年 1528studio. All rights reserved.
//

#import "HelpTableViewCell.h"

@implementation HelpTableViewCell

- (void)awakeFromNib
{
    // Initialization code
    
    NSDictionary* dict = [[NSBundle mainBundle] infoDictionary];
    NSString* ver = [dict objectForKey:@"CFBundleVersion"];
    ver = [NSString stringWithFormat:@"版本 %@",ver];
    self.versionLabel.text = ver;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)dealloc {
    [_privacyPolicyBtn release];
    [_qqCopyBtn release];
    [_wxCopyBtn release];
    [_versionLabel release];
    [super dealloc];
}
@end
