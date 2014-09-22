//
//  MessageViewController.h
//  wangcai
//
//  Created by zhangc on 14-5-9.
//  Copyright (c) 2014年 1528studio. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MessageViewController : UIViewController {
    BeeUIStack* _beeUIStack;
    
}

- (IBAction)clickBack:(id)sender;

- (void)setUIStack:(BeeUIStack*) stack;

@property (retain, nonatomic) IBOutlet UITableView* tbView;
@end
