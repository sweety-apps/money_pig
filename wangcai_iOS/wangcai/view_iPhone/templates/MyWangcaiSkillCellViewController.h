//
//  MyWangcaiSkillCellViewController.h
//  wangcai
//
//  Created by Lee Justin on 14-2-15.
//  Copyright (c) 2014年 1528studio. All rights reserved.
//

#import <UIKit/UIKit.h>



@interface MyWangcaiSkillCell : UITableViewCell
{
    
}

@property (nonatomic,retain) IBOutlet UIImageView* icon;
@property (nonatomic,retain) IBOutlet UIImageView* lockIcon;
@property (nonatomic,retain) IBOutlet UIImageView* titleImg;
@property (nonatomic,retain) IBOutlet UIImageView* descriptionImg;

@end

@interface MyWangcaiSkillCellViewController : UIViewController
{
    
}

@property (nonatomic,retain) IBOutlet MyWangcaiSkillCell* cell;

@end
