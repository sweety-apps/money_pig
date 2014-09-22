//
//  MyWangcaiViewController.h
//  wangcai
//
//  Created by Lee Justin on 14-2-15.
//  Copyright (c) 2014年 1528studio. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyWangcaiViewController : UIViewController <UITableViewDataSource,UITableViewDelegate>
{
    BeeUIStack* _beeStack;
    int _nDogHight;
}

- (void)setUIStack : (BeeUIStack*) beeStack;

@property (nonatomic,retain) IBOutlet UITableView* tableView;
@property (nonatomic,retain) IBOutlet UIImageView* dogImageView;
@property (nonatomic,retain) IBOutlet UIImageView* jingyanView;
@property (nonatomic,retain) IBOutlet UIImageView* jingyan2View;
@property (nonatomic,retain) IBOutlet UILabel* dengjiNumLabel;
@property (nonatomic,retain) IBOutlet UILabel* jiachengInfoLabel;
@property (nonatomic,retain) IBOutlet UIView* bingphoneTipsView;
@property (nonatomic,retain) IBOutlet UITableViewCell* dogCell;
@property (nonatomic,retain) IBOutlet UILabel* EXPLabel;
@property (nonatomic,retain) IBOutlet UIView* dogcellContentView;

- (IBAction)onPressedBindPhone:(id)sender;
- (IBAction)onPressedBack:(id)sender;

- (void)setLevel:(int)level;
- (void)setEXP:(float)EXP nextLevelEXP:(float)nextLevelEXP withAnimation:(BOOL)animated;

@end
