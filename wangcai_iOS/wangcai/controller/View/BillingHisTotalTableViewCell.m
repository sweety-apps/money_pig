//
//  BillingHisTotalTableViewCell.m
//  wangcai
//
//  Created by Lee Justin on 14-10-2.
//  Copyright (c) 2014年 1528studio. All rights reserved.
//

#import "BillingHisTotalTableViewCell.h"

@implementation BillingHisTotalTableViewCell


- (void)awakeFromNib
{
    // Initialization code
    self.shareIncomeBtn.layer.masksToBounds = YES;
    self.shareIncomeBtn.layer.borderColor = [UIColor whiteColor].CGColor;
    self.shareIncomeBtn.layer.borderWidth = 1.0f;
    self.shareIncomeBtn.layer.cornerRadius = 3.f;
}

- (void)dealloc {
    [_shareIncomeBtn release];
    [_balanceLabel release];
    [_incomeLabel release];
    [_outgoLabel release];
    [super dealloc];
}
@end
