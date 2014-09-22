//
//  TaskInfoTableViewCell.h
//  wangcai
//
//  Created by Lee Justin on 13-12-14.
//  Copyright (c) 2013年 1528studio. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TaskInfoTableViewCell : UITableViewCell

@property (nonatomic,retain) IBOutlet UILabel* jintianhainengzhuanLabel;

- (void)setJinTianHaiNengZhuanNumLabelText:(NSString*)text;
- (void)setJinTianHaiNengZhuanNumLabelTextNum:(float)num;

@end
