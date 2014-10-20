//
//  OrderDetailTableViewCell.m
//  wangcai
//
//  Created by Lee Justin on 14-10-11.
//  Copyright (c) 2014年 1528studio. All rights reserved.
//

#import "OrderDetailTableViewCell.h"
#import "UIImage+imageUtils.h"

@implementation OrderDetailTableViewCell

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
    self.extraBgView.layer.masksToBounds = YES;
    self.extraBgView.layer.borderColor = self.extraLabel.textColor.CGColor;
    self.extraBgView.layer.borderWidth = 1.0f;
    self.extraBgView.layer.cornerRadius = 2.0f;
    
    self.checkButton.layer.masksToBounds = YES;
    self.checkButton.layer.cornerRadius = 5.0f;
    
    [self.checkButton setBackgroundImage:[UIImage imageWithPureColor:self.checkButton.backgroundColor] forState:UIControlStateNormal];
    self.checkButton.backgroundColor = [UIColor clearColor];
    
    
    [self.checkButton addTarget:self action:@selector(onPressedCheckButton) forControlEvents:UIControlEventTouchUpInside];
}

- (void) setupCellWithOrderDetailRecord:(BillingHistoryOrderDetailRecord*)record
{
    NSString* statusStr = @"未知状态";
    NSString* infoStr = @"";
    NSString* extraStr = @"";
    NSString* buttonStr = @"";
    
    infoStr = [infoStr stringByAppendingFormat:@"名称：%@",record.name];
    infoStr = [infoStr stringByAppendingFormat:@"\n花费：%@元",[NSNumber numberWithFloat:([record.money floatValue]/100.f)]];
    infoStr = [infoStr stringByAppendingFormat:@"\n\n申请提交时间：%@",record.create_time];
    switch (record.status)
    {
        case BillingHistoryOrderStatusPending:
        {
             statusStr = @"申请等待确认中...";
        }
            break;
        case BillingHistoryOrderStatusConfirmed:
        {
            statusStr = @"已确认申请。";
            infoStr = [infoStr stringByAppendingFormat:@"\n申请确认时间：%@",record.confirm_time];
        }
            break;
        case BillingHistoryOrderStatusCompleted:
        {
            statusStr = @"成功完成交易兑换！";
            infoStr = [infoStr stringByAppendingFormat:@"\n申请确认时间：%@",record.confirm_time];
            infoStr = [infoStr stringByAppendingFormat:@"\n订单完成时间：%@",record.complete_time];
        }
            break;
            
        default:
            break;
    }
    
    switch (record.exchange_type)
    {
        case ExtractAndExchangeTypeAlipay:
        {
            self.checkButton.hidden = YES;
            extraStr = [NSString stringWithFormat:@"充值账号：%@",record.extra];
        }
            break;
        case ExtractAndExchangeTypePhonePay:
        {
            self.checkButton.hidden = YES;
            extraStr = [NSString stringWithFormat:@"充值手机号：%@",record.extra];
        }
            break;
        case ExtractAndExchangeTypeJingdong:
        {
            self.checkButton.hidden = NO;
            extraStr = [NSString stringWithFormat:@"充值码：%@",record.extra];
            buttonStr = @"复制充值码并充值到京东账户";
        }
            break;
        case ExtractAndExchangeTypeXLVip:
        {
            self.checkButton.hidden = NO;
            extraStr = [NSString stringWithFormat:@"充值码：%@",record.extra];
            buttonStr = @"复制充值码";
        }
            break;
            
        default:
            break;
    }
    
    [self.iconImagView setUrl:nil];
    [self.iconImagView setImage:[[ExtractAndExchangeLogic sharedInstance] iconForExtractAndExchangeType:record.exchange_type]];
    self.infoLabel.text = infoStr;
    self.statusLabel.text = statusStr;
    self.extraLabel.text = extraStr;
    [self.checkButton setTitle:buttonStr forState:UIControlStateNormal];
}

- (void)onPressedCheckButton
{
    if (self.delegate)
    {
        [self.delegate onPressedCheckButtonOfOrderDetailCell:self];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)dealloc {
    [_iconImagView release];
    [_statusLabel release];
    [_infoLabel release];
    [_checkButton release];
    [_extraBgView release];
    [_extraLabel release];
    [super dealloc];
}
@end
