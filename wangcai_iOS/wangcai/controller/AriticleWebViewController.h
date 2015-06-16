//
//  AriticleWebViewController.h
//  wangcai
//
//  Created by Lee Justin on 14-11-3.
//  Copyright (c) 2014年 1528studio. All rights reserved.
//

#import "CommonWebViewController.h"
#import "ArticleToolbarTableViewCell.h"

@interface AriticleWebViewController : CommonWebViewController <ArticleToolbarTableViewCellDelegate>

+ (AriticleWebViewController*) controller;

@property (nonatomic,retain) ArticleToolbarTableViewCell* toolbarCell;

@end
