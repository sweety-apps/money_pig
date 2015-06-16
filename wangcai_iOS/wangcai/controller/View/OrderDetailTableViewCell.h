//
//  OrderDetailTableViewCell.h
//  wangcai
//
//  Created by Lee Justin on 14-10-11.
//  Copyright (c) 2014年 1528studio. All rights reserved.
//

#import "BillingHistoryList.h"

@class OrderDetailTableViewCell;

@protocol OrderDetailTableViewCellDelegate <NSObject>

- (void) onPressedCheckButtonOfOrderDetailCell:(OrderDetailTableViewCell*)cell;
- (void) onPressedHelpButtonOfOrderDetailCell:(OrderDetailTableViewCell*)cell;

@end

@interface OrderDetailTableViewCell : UITableViewCell
@property (retain, nonatomic) IBOutlet BeeUIImageView *iconImagView;
@property (retain, nonatomic) IBOutlet UILabel *statusLabel;
@property (retain, nonatomic) IBOutlet UILabel *infoLabel;
@property (retain, nonatomic) IBOutlet UIButton *checkButton;
@property (retain, nonatomic) IBOutlet UIView *extraBgView;
@property (retain, nonatomic) IBOutlet UILabel *extraLabel;

@property (assign, nonatomic) id<OrderDetailTableViewCellDelegate> delegate;

- (void) setupCellWithOrderDetailRecord:(BillingHistoryOrderDetailRecord*)record;

@end
