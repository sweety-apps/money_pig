//
//  UIPayButton.h
//  wangcai
//
//  Created by NPHD on 14-3-19.
//  Copyright (c) 2014年 1528studio. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol UIPayButtonDelegate <NSObject>
- (void)onClickPay:(int) amount Reward:(int) reward;
@end


@interface UIPayButton : UIViewController {
    id _delegate;
    int _amount;
    int _reward;
}

- (void) setAmount:(int) amount Reward:(int) reward Hot:(BOOL) hot Delegate:(id) delegate;

@end
