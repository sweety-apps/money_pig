//
//  CommonWebViewTableViewCell.m
//  wangcai
//
//  Created by Lee Justin on 14-10-28.
//  Copyright (c) 2014年 1528studio. All rights reserved.
//

#import "CommonWebViewTableViewCell.h"

@implementation CommonWebViewTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    CGRect rect = frame;
    rect.origin = CGPointZero;
    dispatch_async(dispatch_get_main_queue(), ^(){
        self.webView.frame = rect;
        self.webView.scrollView.frame = rect;
    });
}

- (void)dealloc {
    [_webView release];
    [super dealloc];
}
@end
