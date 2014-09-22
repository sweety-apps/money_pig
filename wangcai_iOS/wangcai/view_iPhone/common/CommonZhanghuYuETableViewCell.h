//
//  CommonZhanghuYuETableViewCell.h
//  wangcai
//
//  Created by Lee Justin on 13-12-23.
//  Copyright (c) 2013年 1528studio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommonYuENumView.h"

@interface CommonZhanghuYuETableViewCell : UITableViewCell

@property (nonatomic,retain) IBOutlet CommonYuENumView* yuENumView;

@property (nonatomic,retain) IBOutlet UIButton* tixianButton;
@property (nonatomic,retain) IBOutlet UIImageView* tixianIcon;
@property (nonatomic,retain) IBOutlet UILabel* tixianLabel;

@property (nonatomic,retain) IBOutlet UIButton* qiandaoButton;
@property (nonatomic,retain) IBOutlet UIImageView* qiandaoIcon;
@property (nonatomic,retain) IBOutlet UIImageView* qiandaoRedDotBubble;
@property (nonatomic,retain) IBOutlet UILabel* qiandaoLabel;

@end
