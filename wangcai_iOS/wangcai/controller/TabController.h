//
//  TabController.h
//  wangcai
//
//  Created by 1528 on 13-12-14.
//  Copyright (c) 2013年 1528studio. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TabController : UIViewController {
    
    
}

- (id)init:(NSBundle *)nibBundleOrNil;
- (void) setTabInfo:(NSString*)tab1 Tab2:(NSString*)tab2 Tab3:(NSString*)tab3 Purse:(float) purse;
- (void) selectTab:(int)index;
@end
