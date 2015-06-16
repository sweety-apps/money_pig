//
//  ArticleToolbarTableViewCell.h
//  wangcai
//
//  Created by Lee Justin on 14-11-3.
//  Copyright (c) 2014年 1528studio. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ArticleToolbarTableViewCell;

@protocol ArticleToolbarTableViewCellDelegate <NSObject>

- (void)onArticleToolbarPressedTaskButton:(ArticleToolbarTableViewCell*)cell;
- (void)onArticleToolbarPressedInviteButton:(ArticleToolbarTableViewCell*)cell;

@end

@interface ArticleToolbarTableViewCell : UITableViewCell

@property (retain, nonatomic) IBOutlet UIButton *inviteButton;
@property (retain, nonatomic) IBOutlet UIButton *taskButton;

@property (assign, nonatomic) id<ArticleToolbarTableViewCellDelegate> delegate;


@end
